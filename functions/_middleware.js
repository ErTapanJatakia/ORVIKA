const SECURITY_HEADERS = Object.freeze({
  "Strict-Transport-Security": "max-age=31536000; includeSubDomains",
  "X-Content-Type-Options": "nosniff",
  "X-Frame-Options": "DENY",
  "Referrer-Policy": "strict-origin-when-cross-origin",
  "Permissions-Policy": "camera=(self), microphone=(), geolocation=()",
  "Content-Security-Policy":
    "default-src 'none'; base-uri 'self'; object-src 'none'; frame-ancestors 'none'; form-action 'self'; script-src 'self' https://cdn.jsdelivr.net 'wasm-unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: blob:; font-src 'self' data:; connect-src 'self' https://cdn.jsdelivr.net; worker-src 'self' blob:; manifest-src 'self'; media-src 'self' blob:",
  "Cross-Origin-Embedder-Policy": "credentialless",
  "Cross-Origin-Opener-Policy": "same-origin",
  "Cross-Origin-Resource-Policy": "same-origin",
});
const ALLOWED_METHODS = new Set(["GET", "HEAD"]);
const CSP_NONCE_PREVIEW_HOST = "orvika-validation.orvika.pages.dev";

function withSecurityHeaders(response) {
  const secured = new Response(response.body, response);
  for (const [name, value] of Object.entries(SECURITY_HEADERS)) secured.headers.set(name, value);
  for (const name of [
    "Access-Control-Allow-Origin",
    "Access-Control-Allow-Credentials",
    "Access-Control-Allow-Methods",
    "Access-Control-Allow-Headers",
  ]) {
    secured.headers.delete(name);
  }
  return secured;
}

function createCspNonce() {
  const bytes = crypto.getRandomValues(new Uint8Array(16));
  let binary = "";
  for (const byte of bytes) binary += String.fromCharCode(byte);
  return btoa(binary);
}

function withPreviewNonce(response, nonce) {
  const transformed = new HTMLRewriter()
    .on("script", {
      element(element) {
        element.setAttribute("nonce", nonce);
      },
    })
    .on("style", {
      element(element) {
        element.setAttribute("nonce", nonce);
      },
    })
    .transform(response);

  const headers = new Headers(transformed.headers);
  // HTMLRewriter changes the response body; stale representation metadata must not survive.
  headers.delete("Content-Length");
  headers.delete("Content-Encoding");
  headers.delete("ETag");
  headers.set(
    "Content-Security-Policy",
    "default-src 'none'; base-uri 'self'; object-src 'none'; frame-ancestors 'none'; form-action 'self'; script-src 'self' https://cdn.jsdelivr.net 'wasm-unsafe-eval' 'nonce-" +
      nonce +
      "'; style-src 'self' 'nonce-" +
      nonce +
      "'; style-src-attr 'none'; img-src 'self' data: blob:; font-src 'self' data:; connect-src 'self' https://cdn.jsdelivr.net; worker-src 'self' blob:; manifest-src 'self'; media-src 'self' blob:",
  );
  return new Response(transformed.body, {
    status: transformed.status,
    statusText: transformed.statusText,
    headers,
  });
}

export async function onRequest(context) {
  const { request } = context;
  if (!ALLOWED_METHODS.has(request.method.toUpperCase())) {
    return withSecurityHeaders(new Response(null, { status: 405, headers: {
      Allow: "GET, HEAD", "Cache-Control": "no-store",
    }}));
  }
  const pathname = new URL(request.url).pathname;
  let decodedPathname;
  try { decodedPathname = decodeURIComponent(pathname); }
  catch {
    return withSecurityHeaders(new Response(null, { status: 400, headers: { "Cache-Control": "no-store" }}));
  }
  const hasControlCharacters = /[\u0000-\u001f\u007f]/.test(decodedPathname);
  const hasHiddenPathSegment = decodedPathname.split("/")
    .some((segment) => segment.startsWith(".") && segment !== ".well-known");
  if (hasControlCharacters || hasHiddenPathSegment) {
    return withSecurityHeaders(new Response(null, { status: 400, headers: { "Cache-Control": "no-store" }}));
  }

  const secured = withSecurityHeaders(await context.next());
  const isNoncePreview =
    new URL(request.url).hostname === CSP_NONCE_PREVIEW_HOST &&
    request.method.toUpperCase() === "GET" &&
    secured.status === 200 &&
    (secured.headers.get("content-type") ?? "").toLowerCase().includes("text/html");

  if (!isNoncePreview) return secured;
  return withPreviewNonce(secured, createCspNonce());
}
