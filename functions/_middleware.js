const SECURITY_HEADERS = Object.freeze({
  "Strict-Transport-Security": "max-age=31536000; includeSubDomains",
  "X-Content-Type-Options": "nosniff",
  "X-Frame-Options": "DENY",
  "Referrer-Policy": "strict-origin-when-cross-origin",
  "Permissions-Policy": "camera=(self), microphone=(), geolocation=()",
  "Content-Security-Policy":
    "default-src 'none'; base-uri 'self'; object-src 'none'; frame-ancestors 'none'; form-action 'self'; script-src 'self' 'wasm-unsafe-eval' https://challenges.cloudflare.com; frame-src https://challenges.cloudflare.com; style-src 'self' 'unsafe-inline'; img-src 'self' data: blob:; font-src 'self' data:; connect-src 'self' https://challenges.cloudflare.com https://orvika.pages.dev; worker-src 'self' blob:; manifest-src 'self'; media-src 'self' blob:",
  "Cross-Origin-Embedder-Policy": "credentialless",
  "Cross-Origin-Opener-Policy": "same-origin-allow-popups",
});
const ALLOWED_METHODS = new Set(["GET", "HEAD"]);
const CONTACT_ENDPOINT = "/api/accessibility-contact";
const CONTACT_METHODS = new Set(["POST", "OPTIONS"]);
function withSecurityHeaders(response) {
  const secured = new Response(response.body, response);
  for (const [name, value] of Object.entries(SECURITY_HEADERS)) secured.headers.set(name, value);
  return secured;
}
export async function onRequest(context) {
  const { request } = context;
  const pathname = new URL(request.url).pathname;
  if (pathname === CONTACT_ENDPOINT) {
    if (!CONTACT_METHODS.has(request.method.toUpperCase())) {
      return withSecurityHeaders(new Response(null, { status: 405, headers: {
        Allow: "POST, OPTIONS", "Cache-Control": "no-store",
      }}));
    }
    return withSecurityHeaders(await context.next());
  }
  if (!ALLOWED_METHODS.has(request.method.toUpperCase())) {
    return withSecurityHeaders(new Response(null, { status: 405, headers: {
      Allow: "GET, HEAD", "Cache-Control": "no-store",
    }}));
  }
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
  return withSecurityHeaders(await context.next());
}
