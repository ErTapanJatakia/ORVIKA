import assert from "node:assert/strict";
import test from "node:test";

import { onRequest } from "../../functions/_middleware.js";

const expectedHeaders = {
  "strict-transport-security": "max-age=31536000; includeSubDomains",
  "x-content-type-options": "nosniff",
  "x-frame-options": "DENY",
  "referrer-policy": "strict-origin-when-cross-origin",
  "permissions-policy": "camera=(self), microphone=(), geolocation=()",
  "cross-origin-embedder-policy": "credentialless",
  "cross-origin-opener-policy": "same-origin-allow-popups",
};

async function invoke(method, url = "https://orvika.pages.dev/") {
  let nextCalled = false;
  const response = await onRequest({
    request: { method, url },
    next: async () => {
      nextCalled = true;
      return new Response("static asset", {
        status: 200,
        headers: { "Content-Type": "text/plain" },
      });
    },
  });

  return { response, nextCalled };
}

test("passes GET requests through and preserves the response body", async () => {
  const { response, nextCalled } = await invoke("GET", "https://orvika.pages.dev/assets/app.js");

  assert.equal(nextCalled, true);
  assert.equal(response.status, 200);
  assert.equal(await response.text(), "static asset");
});

test("passes HEAD requests through", async () => {
  const { response, nextCalled } = await invoke("HEAD");

  assert.equal(nextCalled, true);
  assert.equal(response.status, 200);
});

for (const method of ["POST", "PUT", "PATCH", "DELETE", "TRACE", "CONNECT"]) {
  test(`rejects ${method} requests without invoking the static handler`, async () => {
    const { response, nextCalled } = await invoke(method);

    assert.equal(nextCalled, false);
    assert.equal(response.status, 405);
    assert.equal(response.headers.get("allow"), "GET, HEAD");
    assert.equal(response.headers.get("cache-control"), "no-store");
  });
}

test("rejects malformed percent escapes in URL paths", async () => {
  const { response, nextCalled } = await invoke("GET", "https://orvika.pages.dev/bad%2path");

  assert.equal(nextCalled, false);
  assert.equal(response.status, 400);
});

test("rejects encoded control characters in URL paths", async () => {
  const { response, nextCalled } = await invoke("GET", "https://orvika.pages.dev/%0d%0aheader");

  assert.equal(nextCalled, false);
  assert.equal(response.status, 400);
});

test("adds the complete security-header policy to passed-through responses", async () => {
  const { response } = await invoke("GET");

  for (const [name, value] of Object.entries(expectedHeaders)) {
    assert.equal(response.headers.get(name), value, `unexpected ${name}`);
  }

  const csp = response.headers.get("content-security-policy");
  assert.match(csp, /default-src 'none'/);
  assert.match(csp, /'wasm-unsafe-eval'/);
  assert.doesNotMatch(csp, /'unsafe-eval'/);
});

test("adds security headers to middleware-generated error responses", async () => {
  const { response } = await invoke("POST");

  for (const [name, value] of Object.entries(expectedHeaders)) {
    assert.equal(response.headers.get(name), value, `unexpected ${name}`);
  }
});
