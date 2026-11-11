const SECURITY_HEADERS = Object.freeze({
  "Strict-Transport-Security": "max-age=31536000; includeSubDomains",
  "X-Content-Type-Options": "nosniff",
  "X-Frame-Options": "DENY",
  "Referrer-Policy": "strict-origin-when-cross-origin",
  "Permissions-Policy": "camera=(self), microphone=(), geolocation=()",
  "Content-Security-Policy":
    "default-src 'none'; base-uri 'self'; object-src 'none'; frame-ancestors 'none'; form-action 'self'; script-src 'self' 'wasm-unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: blob:; font-src 'self' data:; connect-src 'self'; worker-src 'self' blob:; manifest-src 'self'; media-src 'self' blob:",
  "Cross-Origin-Embedder-Policy": "credentialless",
  "Cross-Origin-Opener-Policy": "same-origin-allow-popups",
});

const ALLOWED_METHODS = new Set(["GET", "HEAD"]);

function withSecurityHeaders(response) {
  const secured = new Response(response.body, response);

  for (const [name, value] of Object.entries(SECURITY_HEADERS)) {
    secured.headers.set(name, value);
  }

  return secured;
}

export async function onRequest({ request, next }) {
  if (!ALLOWED_METHODS.has(request.method.toUpperCase())) {
    const response = new Response(null, {
      status: 405,
      headers: {
        Allow: "GET, HEAD",
        "Cache-Control": "no-store",
      },
    });

    return withSecurityHeaders(response);
  }

  const pathname = new URL(request.url).pathname;
  if (/%(?![0-9a-f]{2})/i.test(pathname) || /%(?:0[0-9a-f]|1[0-9a-f]|7f)/i.test(pathname)) {
    const response = new Response(null, {
      status: 400,
      headers: {
        "Cache-Control": "no-store",
      },
    });

    return withSecurityHeaders(response);
  }

  return withSecurityHeaders(await next());
}
