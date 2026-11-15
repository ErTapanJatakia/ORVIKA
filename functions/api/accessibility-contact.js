const SITEVERIFY_URL = "https://challenges.cloudflare.com/turnstile/v0/siteverify";
const EXPECTED_ACTION = "contact_reveal";
const MAX_BODY_BYTES = 4096;
const MAX_TOKEN_LENGTH = 2048;
function jsonResponse(body, status, origin = null) {
  const headers = new Headers({
    "Content-Type": "application/json; charset=utf-8",
    "Cache-Control": "no-store, max-age=0", "Pragma": "no-cache",
    "X-Content-Type-Options": "nosniff", "Referrer-Policy": "no-referrer", "Vary": "Origin",
  });
  if (origin) headers.set("Access-Control-Allow-Origin", origin);
  return new Response(JSON.stringify(body), { status, headers });
}
function hostnames(env) {
  return new Set((env.ORVIKA_TURNSTILE_HOSTNAMES ?? "").split(",")
    .map((value) => value.trim().toLowerCase()).filter(Boolean));
}
function allowedOrigin(request, hosts) {
  const origin = request.headers.get("Origin");
  if (!origin) return null;
  try {
    const parsed = new URL(origin);
    const local = parsed.hostname === "localhost" || parsed.hostname === "127.0.0.1";
    if (parsed.origin !== origin || !hosts.has(parsed.hostname.toLowerCase()) ||
        (!local && parsed.protocol !== "https:")) return null;
    return origin;
  } catch { return null; }
}
function parseEmails(raw) {
  if (typeof raw !== "string" || raw.length > 2048) return null;
  try {
    const values = JSON.parse(raw);
    if (!Array.isArray(values) || values.length < 1 || values.length > 5 ||
        !values.every((value) => typeof value === "string" && value.length <= 254 &&
          /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value))) return null;
    return values;
  } catch { return null; }
}
export async function onRequestOptions({ request, env }) {
  const origin = allowedOrigin(request, hostnames(env));
  if (!origin) return jsonResponse({ error: "forbidden" }, 403);
  return new Response(null, { status: 204, headers: {
    "Access-Control-Allow-Origin": origin,
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type",
    "Access-Control-Max-Age": "600", "Cache-Control": "no-store", "Vary": "Origin",
  }});
}
export async function onRequestPost({ request, env }) {
  const hosts = hostnames(env);
  const origin = allowedOrigin(request, hosts);
  if (!origin || !env.ORVIKA_TURNSTILE_SECRET || hosts.size === 0)
    return jsonResponse({ error: "forbidden" }, 403);
  if (request.headers.get("Content-Type")?.split(";")[0].trim().toLowerCase() !== "application/json")
    return jsonResponse({ error: "unsupported_media_type" }, 415, origin);
  const length = Number(request.headers.get("Content-Length") ?? "0");
  if (length > MAX_BODY_BYTES) return jsonResponse({ error: "invalid_request" }, 400, origin);
  let body;
  try {
    const raw = await request.text();
    if (new TextEncoder().encode(raw).byteLength > MAX_BODY_BYTES) throw new Error("too large");
    body = JSON.parse(raw);
  } catch { return jsonResponse({ error: "invalid_request" }, 400, origin); }
  const token = body?.turnstileToken;
  if (typeof token !== "string" || token.length === 0 || token.length > MAX_TOKEN_LENGTH)
    return jsonResponse({ error: "verification_failed" }, 403, origin);
  let verification;
  try {
    const response = await fetch(SITEVERIFY_URL, {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      signal: AbortSignal.timeout(10_000),
      body: new URLSearchParams({
        secret: env.ORVIKA_TURNSTILE_SECRET,
        response: token,
        ...(request.headers.get("CF-Connecting-IP")
          ? { remoteip: request.headers.get("CF-Connecting-IP") } : {}),
      }),
    });
    if (!response.ok) return jsonResponse({ error: "verification_unavailable" }, 503, origin);
    verification = await response.json();
  } catch { return jsonResponse({ error: "verification_unavailable" }, 503, origin); }
  const verifiedHost = typeof verification?.hostname === "string"
    ? verification.hostname.toLowerCase() : "";
  if (verification?.success !== true || verification?.action !== EXPECTED_ACTION ||
      !hosts.has(verifiedHost) || verifiedHost !== new URL(origin).hostname.toLowerCase())
    return jsonResponse({ error: "verification_failed" }, 403, origin);
  const emails = parseEmails(env.ORVIKA_ACCESSIBILITY_CONTACT_EMAILS);
  if (!emails) return jsonResponse({ error: "contact_unavailable" }, 503, origin);
  return jsonResponse({ emails }, 200, origin);
}
