import assert from "node:assert/strict";
import test from "node:test";
import { onRequestOptions, onRequestPost } from "../../functions/api/accessibility-contact.js";
const env = (extra = {}) => ({
  ORVIKA_TURNSTILE_SECRET: "test-secret",
  ORVIKA_TURNSTILE_HOSTNAMES: "orvika.pages.dev,orvika-web.vercel.app",
  ORVIKA_ACCESSIBILITY_CONTACT_EMAILS: JSON.stringify(["a@example.test", "b@example.test"]),
  ...extra,
});
function makeRequest(data, origin = "https://orvika.pages.dev", type = "application/json") {
  return new Request("https://orvika.pages.dev/api/accessibility-contact", {
    method: "POST", headers: { Origin: origin, "Content-Type": type }, body: JSON.stringify(data),
  });
}
function stubFetch(t, result, status = 200) {
  const original = globalThis.fetch;
  globalThis.fetch = async () => new Response(JSON.stringify(result), { status });
  t.after(() => { globalThis.fetch = original; });
}
test("discloses contacts only after valid action and exact hostname verification", async (t) => {
  stubFetch(t, { success: true, action: "contact_reveal", hostname: "orvika.pages.dev" });
  const response = await onRequestPost({ request: makeRequest({ turnstileToken: "fresh-token" }), env: env() });
  assert.equal(response.status, 200);
  assert.deepEqual(await response.json(), { emails: ["a@example.test", "b@example.test"] });
  assert.equal(response.headers.get("cache-control"), "no-store, max-age=0");
});
test("rejects missing and oversized tokens", async () => {
  for (const token of ["", "x".repeat(2049)]) {
    const response = await onRequestPost({ request: makeRequest({ turnstileToken: token }), env: env() });
    assert.equal(response.status, 403);
  }
});
for (const result of [
  { success: false, action: "contact_reveal", hostname: "orvika.pages.dev" },
  { success: true, action: "wrong", hostname: "orvika.pages.dev" },
  { success: true, action: "contact_reveal", hostname: "attacker.example" },
  { success: true, action: "contact_reveal", hostname: "orvika-web.vercel.app" },
]) test(`rejects invalid verification result: ${JSON.stringify(result)}`, async (t) => {
  stubFetch(t, result);
  const response = await onRequestPost({ request: makeRequest({ turnstileToken: "token" }), env: env() });
  assert.equal(response.status, 403);
});
test("rejects origins outside the allowlist and missing Origin", async () => {
  const denied = await onRequestPost({ request: makeRequest({ turnstileToken: "token" }, "https://evil.example"), env: env() });
  assert.equal(denied.status, 403);
  const noOrigin = new Request("https://orvika.pages.dev/api/accessibility-contact", {
    method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ turnstileToken: "token" }),
  });
  assert.equal((await onRequestPost({ request: noOrigin, env: env() })).status, 403);
});
test("rejects non-JSON and malformed payloads", async () => {
  const type = await onRequestPost({ request: makeRequest({}, "https://orvika.pages.dev", "text/plain"), env: env() });
  assert.equal(type.status, 415);
  const malformed = new Request("https://orvika.pages.dev/api/accessibility-contact", {
    method: "POST", headers: { Origin: "https://orvika.pages.dev", "Content-Type": "application/json" }, body: "{",
  });
  assert.equal((await onRequestPost({ request: malformed, env: env() })).status, 400);
});
test("fails closed when contact secret configuration is invalid", async (t) => {
  stubFetch(t, { success: true, action: "contact_reveal", hostname: "orvika.pages.dev" });
  const response = await onRequestPost({
    request: makeRequest({ turnstileToken: "token" }),
    env: env({ ORVIKA_ACCESSIBILITY_CONTACT_EMAILS: "not-json" }),
  });
  assert.equal(response.status, 503);
});
test("fails closed when Siteverify is unavailable", async (t) => {
  stubFetch(t, {}, 502);
  const response = await onRequestPost({ request: makeRequest({ turnstileToken: "token" }), env: env() });
  assert.equal(response.status, 503);
});
test("preflight allows only an allowlisted origin", async () => {
  const ok = await onRequestOptions({
    request: new Request("https://orvika.pages.dev/api/accessibility-contact", {
      method: "OPTIONS", headers: { Origin: "https://orvika-web.vercel.app" },
    }), env: env(),
  });
  assert.equal(ok.status, 204);
  assert.equal(ok.headers.get("access-control-allow-origin"), "https://orvika-web.vercel.app");
  const bad = await onRequestOptions({
    request: new Request("https://orvika.pages.dev/api/accessibility-contact", {
      method: "OPTIONS", headers: { Origin: "https://evil.example" },
    }), env: env(),
  });
  assert.equal(bad.status, 403);
});
