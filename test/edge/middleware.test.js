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
const strictNonHtmlCsp = vercelCsp?.replace(
  "style-src 'self' 'unsafe-inline'",
  "style-src 'self'",
);
const expectedHeaders = {
  "strict-transport-security": "max-age=31536000; includeSubDomains",
  "x-content-type-options": "nosniff", "x-frame-options": "DENY",
  "referrer-policy": "strict-origin-when-cross-origin",
  "permissions-policy": "camera=(self), microphone=(), geolocation=()",
  "cross-origin-embedder-policy": "credentialless",
  "cross-origin-opener-policy": "same-origin",
  "cross-origin-resource-policy": "same-origin",
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
  assert.equal(csp, strictNonHtmlCsp, "Non-HTML responses must not permit inline styles");
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


class FakeHtmlRewriter {
  constructor() {
    this.handlers = new Map();
  }
  on(selector, handler) {
    this.handlers.set(selector, handler);
    return this;
  }
  transform(response) {
    const handlers = this.handlers;
    const body = new ReadableStream({
      async start(controller) {
        try {
          const html = await response.text();
          const transformed = html.replace(/<(script|style)\b([^>]*)>/gi, (match, tagName, rawAttributes) => {
            const handler = handlers.get(tagName.toLowerCase());
            if (!handler?.element) return match;
            let attributes = rawAttributes;
            handler.element({
              setAttribute(name, value) {
                attributes += " " + name + "=\"" + value + "\"";
              },
            });
            return "<" + tagName + attributes + ">";
          });
          controller.enqueue(new TextEncoder().encode(transformed));
          controller.close();
        } catch (error) {
          controller.error(error);
        }
      },
    });
    return new Response(body, { status: response.status, headers: response.headers });
  }
}

test("isolated Cloudflare validation host receives a fresh nonce policy and matching HTML attributes", async () => {
  const previous = globalThis.HTMLRewriter;
  globalThis.HTMLRewriter = FakeHtmlRewriter;
  try {
    const html = '<!doctype html><html><head><style>.a{color:red}</style></head><body><script src="flutter_bootstrap.js" async></script><script>window.ready=true</script></body></html>';
    const response = await onRequest({
      request: { method: "GET", url: "https://orvika-validation.orvika.pages.dev/" },
      next: async () => new Response(html, { status: 200, headers: {
        "Content-Type": "text/html; charset=utf-8",
        "Content-Length": String(html.length),
        ETag: '"static-shell"',
      }}),
    });
    const policy = response.headers.get("content-security-policy");
    const nonce = policy.match(/'nonce-([^']+)'/)?.[1];
    assert.ok(nonce, "preview CSP must contain a generated nonce");
    assert.match(policy, /style-src 'self' 'nonce-[^']+'/);
    assert.match(policy, /style-src-attr 'none'/);
    assert.doesNotMatch(policy, /style-src 'self' 'unsafe-inline'/);
    const scriptDirective = policy.split(";").find((directive) => directive.trim().startsWith("script-src "));
    assert.ok(
      scriptDirective?.includes("'nonce-" + nonce + "'"),
      "script-src directive must authorize the generated nonce",
    );
    const body = await response.text();
    assert.equal(body.split('nonce="' + nonce + '"').length - 1, 3);
    assert.match(body, /<style[^>]*nonce="/);
    assert.match(body, /<script[^>]*nonce="/);
    assert.equal(response.headers.get("content-length"), null);
    assert.equal(response.headers.get("etag"), null);
  } finally {
    if (previous === undefined) delete globalThis.HTMLRewriter;
    else globalThis.HTMLRewriter = previous;
  }
});

test("isolated Cloudflare validation host generates a distinct nonce for each HTML response", async () => {
  const previous = globalThis.HTMLRewriter;
  globalThis.HTMLRewriter = FakeHtmlRewriter;
  try {
    const request = { method: "GET", url: "https://orvika-validation.orvika.pages.dev/" };
    const next = async () => new Response('<html><head></head><body><script src="flutter_bootstrap.js"></script></body></html>', {
      status: 200, headers: { "Content-Type": "text/html" },
    });
    const first = await onRequest({ request, next });
    const second = await onRequest({ request, next });
    const firstNonce = first.headers.get("content-security-policy").match(/'nonce-([^']+)'/)?.[1];
    const secondNonce = second.headers.get("content-security-policy").match(/'nonce-([^']+)'/)?.[1];
    assert.ok(firstNonce && secondNonce);
    assert.notEqual(firstNonce, secondNonce, "nonce values must not be reused across responses");
  } finally {
    if (previous === undefined) delete globalThis.HTMLRewriter;
    else globalThis.HTMLRewriter = previous;
  }
});

test("keeps the existing CSP on production HTML responses", async () => {
  const response = await onRequest({
    request: { method: "GET", url: "https://orvika-web.vercel.app/" },
    next: async () => new Response("<html><body>production shell</body></html>", {
      status: 200, headers: { "Content-Type": "text/html; charset=utf-8" },
    }),
  });
  assert.equal(response.headers.get("content-security-policy"), vercelCsp);
  assert.doesNotMatch(vercelCsp, /nonce-/);
});

test("nonce prototype is not activated on production Cloudflare or Vercel hosts", async () => {
  for (const url of ["https://orvika.pages.dev/", "https://orvika-web.vercel.app/"]) {
    const response = await onRequest({
      request: { method: "GET", url },
      next: async () => new Response("<html><body><script>window.ready=true</script></body></html>", {
        status: 200, headers: { "Content-Type": "text/html" },
      }),
    });
    const policy = response.headers.get("content-security-policy");
    assert.equal(policy, vercelCsp);
    assert.doesNotMatch(policy, /nonce-/);
    assert.match(await response.text(), /<script>window.ready=true<\/script>/);
  }
});

test("nonce prototype does not transform non-HTML resources on the validation host", async () => {
  const response = await onRequest({
    request: { method: "GET", url: "https://orvika-validation.orvika.pages.dev/main.dart.js" },
    next: async () => new Response("console.log('asset')", {
      status: 200, headers: { "Content-Type": "application/javascript" },
    }),
  });
  assert.equal(response.headers.get("content-security-policy"), strictNonHtmlCsp);
  assert.equal(await response.text(), "console.log('asset')");
});
