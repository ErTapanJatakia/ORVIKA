import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import test from "node:test";
import { onRequest } from "../../functions/_middleware.js";

const vercelConfig = JSON.parse(
  readFileSync(new URL("../../vercel.json", import.meta.url), "utf8"),
);
const vercelCsp = vercelConfig.headers
  .flatMap((route) => route.headers ?? [])
  .find((header) => header.key.toLowerCase() === "content-security-policy")?.value;
const expectedHeaders = {
  "strict-transport-security": "max-age=31536000; includeSubDomains",
  "x-content-type-options": "nosniff", "x-frame-options": "DENY",
  "referrer-policy": "strict-origin-when-cross-origin",
  "permissions-policy": "camera=(self), microphone=(), geolocation=()",
  "cross-origin-embedder-policy": "credentialless",
  "cross-origin-opener-policy": "same-origin",
};
async function invoke(method, url = "https://orvika.pages.dev/") {
  let nextCalled = false;
  const response = await onRequest({ request: { method, url }, next: async () => {
    nextCalled = true;
    return new Response("static asset", { status: 200, headers: { "Content-Type": "text/plain" } });
  }});
  return { response, nextCalled };
}
test("passes GET requests through and preserves the response body", async () => {
  const { response, nextCalled } = await invoke("GET", "https://orvika.pages.dev/assets/app.js");
  assert.equal(nextCalled, true); assert.equal(response.status, 200);
  assert.equal(await response.text(), "static asset");
});
test("passes HEAD requests through", async () => {
  const { response, nextCalled } = await invoke("HEAD");
  assert.equal(nextCalled, true); assert.equal(response.status, 200);
});
for (const method of ["POST", "PUT", "PATCH", "DELETE", "TRACE", "CONNECT"]) {
  test(`rejects ${method} requests on static routes`, async () => {
    const { response, nextCalled } = await invoke(method);
    assert.equal(nextCalled, false); assert.equal(response.status, 405);
    assert.equal(response.headers.get("allow"), "GET, HEAD");
    assert.equal(response.headers.get("cache-control"), "no-store");
  });
}
test("all static routes, including the accessibility contact page, remain GET/HEAD only", async () => {
  for (const method of ["GET", "HEAD"]) {
    const { response, nextCalled } = await invoke(method, "https://orvika.pages.dev/accessibility-contact.html");
    assert.equal(nextCalled, true, method); assert.equal(response.status, 200, method);
  }
  for (const method of ["POST", "OPTIONS"]) {
    const { response, nextCalled } = await invoke(method, "https://orvika.pages.dev/accessibility-contact.html");
    assert.equal(nextCalled, false); assert.equal(response.status, 405);
  }
});
test("rejects malformed percent escapes", async () => {
  const { response, nextCalled } = await invoke("GET", "https://orvika.pages.dev/bad%2path");
  assert.equal(nextCalled, false); assert.equal(response.status, 400);
});
test("rejects encoded control characters", async () => {
  const { response, nextCalled } = await invoke("GET", "https://orvika.pages.dev/%0d%0aheader");
  assert.equal(nextCalled, false); assert.equal(response.status, 400);
});
test("rejects dotfile probes", async () => {
  for (const path of ["/.env", "/.git/config", "/config/%2Eenv"]) {
    const { response, nextCalled } = await invoke("GET", `https://orvika.pages.dev${path}`);
    assert.equal(nextCalled, false, path); assert.equal(response.status, 400, path);
  }
});
test("allows the .well-known namespace", async () => {
  const { response, nextCalled } = await invoke("GET", "https://orvika.pages.dev/.well-known/assetlinks.json");
  assert.equal(nextCalled, true); assert.equal(response.status, 200);
});
test("strips permissive CORS headers from public static responses", async () => {
  const response = await onRequest({
    request: { method: "GET", url: "https://orvika.pages.dev/" },
    next: async () => new Response("public asset", { status: 200, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
      "Access-Control-Allow-Headers": "Authorization, Content-Type",
    }}),
  });
  for (const name of [
    "access-control-allow-origin",
    "access-control-allow-credentials",
    "access-control-allow-methods",
    "access-control-allow-headers",
  ]) assert.equal(response.headers.get(name), null, name);
});

test("adds security headers and no third-party CAPTCHA directives", async () => {
  const { response } = await invoke("GET");
  for (const [name, value] of Object.entries(expectedHeaders)) assert.equal(response.headers.get(name), value);
  const csp = response.headers.get("content-security-policy");
  assert.ok(vercelCsp, "Vercel security policy must define a Content-Security-Policy header");
  assert.equal(csp, vercelCsp, "Cloudflare middleware CSP must remain aligned with Vercel CSP");
  assert.match(csp, /default-src 'none'/); assert.match(csp, /'wasm-unsafe-eval'/);
  assert.match(csp, /script-src[^;]*https:\/\/cdn\.jsdelivr\.net/, "Web QR decoder script origin must be allowed");
  assert.match(csp, /connect-src[^;]*https:\/\/cdn\.jsdelivr\.net/, "Web QR decoder fetch origin must be allowed");
  assert.doesNotMatch(csp, /(?:script-src|connect-src)[^;]*\*/, "CSP must not allow wildcard script or connection origins");
  assert.doesNotMatch(csp, /challenges\.cloudflare\.com|turnstile/);
  assert.doesNotMatch(csp, /'unsafe-eval'/);
});
test("adds security headers to middleware-generated errors", async () => {
  const { response } = await invoke("POST");
  for (const [name, value] of Object.entries(expectedHeaders)) assert.equal(response.headers.get(name), value);
});
