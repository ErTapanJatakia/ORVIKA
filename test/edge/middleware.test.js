import assert from "node:assert/strict";
import test from "node:test";
import { onRequest } from "../../functions/_middleware.js";
const expectedHeaders = {
  "strict-transport-security": "max-age=31536000; includeSubDomains",
  "x-content-type-options": "nosniff", "x-frame-options": "DENY",
  "referrer-policy": "strict-origin-when-cross-origin",
  "permissions-policy": "camera=(self), microphone=(), geolocation=()",
  "cross-origin-embedder-policy": "credentialless",
  "cross-origin-opener-policy": "same-origin-allow-popups",
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
test("allows POST and OPTIONS only on the exact contact endpoint", async () => {
  for (const method of ["POST", "OPTIONS"]) {
    const { response, nextCalled } = await invoke(method, "https://orvika.pages.dev/api/accessibility-contact");
    assert.equal(nextCalled, true, method); assert.equal(response.status, 200, method);
  }
});
test("rejects other methods and lookalike paths", async () => {
  for (const method of ["GET", "PUT", "PATCH", "DELETE"]) {
    const { response, nextCalled } = await invoke(method, "https://orvika.pages.dev/api/accessibility-contact");
    assert.equal(nextCalled, false); assert.equal(response.status, 405);
    assert.equal(response.headers.get("allow"), "POST, OPTIONS");
  }
  for (const path of ["/api/accessibility-contact/", "/api/accessibility-contact/extra", "/api/other"]) {
    const { response, nextCalled } = await invoke("POST", `https://orvika.pages.dev${path}`);
    assert.equal(nextCalled, false, path); assert.equal(response.status, 405, path);
    assert.equal(response.headers.get("allow"), "GET, HEAD");
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
test("adds security headers and Turnstile CSP directives", async () => {
  const { response } = await invoke("GET");
  for (const [name, value] of Object.entries(expectedHeaders)) assert.equal(response.headers.get(name), value);
  const csp = response.headers.get("content-security-policy");
  assert.match(csp, /default-src 'none'/); assert.match(csp, /'wasm-unsafe-eval'/);
  assert.match(csp, /https:\/\/challenges\.cloudflare\.com/);
  assert.doesNotMatch(csp, /'unsafe-eval'/);
});
test("adds security headers to middleware-generated errors", async () => {
  const { response } = await invoke("POST");
  for (const [name, value] of Object.entries(expectedHeaders)) assert.equal(response.headers.get(name), value);
});
