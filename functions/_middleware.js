const MAX_REQUEST_URL_LENGTH = 4096;
const SAFE_METHODS = new Set(["GET", "HEAD"]);

function reject(status, message, extraHeaders = {}) {
  return new Response(message, {
    status,
    headers: {
      "cache-control": "no-store",
      "content-type": "text/plain; charset=utf-8",
      "x-content-type-options": "nosniff",
      ...extraHeaders,
    },
  });
}

function getRawPath(requestUrl) {
  const match = requestUrl.match(/^https?:\/\/[^/?#]*([^?#]*)/i);
  return match?.[1] || "/";
}

export async function onRequest({ request, next }) {
  if (request.url.length > MAX_REQUEST_URL_LENGTH) {
    return reject(414, "URI Too Long");
  }

  if (!SAFE_METHODS.has(request.method)) {
    return reject(405, "Method Not Allowed", { allow: "GET, HEAD" });
  }

  let decodedPath;
  try {
    decodedPath = decodeURIComponent(getRawPath(request.url));
  } catch {
    return reject(400, "Bad Request");
  }

  if (/[\u0000-\u001f\u007f\\]/.test(decodedPath)) {
    return reject(400, "Bad Request");
  }

  const segments = decodedPath.split("/");
  if (segments.some((segment) => segment === "." || segment === "..")) {
    return reject(400, "Bad Request");
  }

  // Keep the standard well-known namespace available; hide other dotfiles
  // and dot-directories from public probing.
  if (
    segments.some(
      (segment) =>
        segment.startsWith(".") && segment.toLowerCase() !== ".well-known",
    )
  ) {
    return reject(404, "Not Found");
  }

  return next();
}
