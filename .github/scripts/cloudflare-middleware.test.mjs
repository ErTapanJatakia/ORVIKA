import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";

const source = await readFile(
  new URL("../../functions/_middleware.js", import.meta.url),
  "utf8",
);
const moduleUrl = `data:text/javascript;base64,${Buffer.from(source).toString("base64")}`;
const { onRequest } = await import(moduleUrl);

function makeContext(url, method = "GET") {
  let nextCalled = false;
  const request = new Request(url, { method });
  return {
    context: {
      request,
      next: async () => {
        nextCalled = true;
        return new Response("static asset", { status: 200 });
      },
    },
    wasNextCalled: () => nextCalled,
  };
}

test("allows normal Flutter document requests", async () => {
  for (const method of ["GET", "HEAD"]) {
    const { context, wasNextCalled } = makeContext("https://orvika.pages.dev/", method);
    const response = await onRequest(context);
    assert.equal(response.status, 200);
    assert.equal(wasNextCalled(), true);
  }
});

test("allows nested static assets and query strings", async () => {
  const { context, wasNextCalled } = makeContext(
    "https://orvika.pages.dev/canvaskit/canvaskit.wasm?v=1",
  );
  const response = await onRequest(context);
  assert.equal(response.status, 200);
  assert.equal(wasNextCalled(), true);
});

test("rejects state-changing and preflight methods on the static app origin", async () => {
  for (const method of ["POST", "PUT", "PATCH", "DELETE", "OPTIONS", "TRACE"]) {
    const { context, wasNextCalled } = makeContext("https://orvika.pages.dev/", method);
    const response = await onRequest(context);
    assert.equal(response.status, 405, method);
    assert.equal(response.headers.get("allow"), "GET, HEAD");
    assert.equal(response.headers.get("cache-control"), "no-store");
    assert.equal(wasNextCalled(), false);
  }
});

test("hides common sensitive dotfile probes", async () => {
  for (const path of ["/.env", "/.git/config", "/.ssh/id_rsa", "/folder/.htaccess"]) {
    const { context, wasNextCalled } = makeContext(`https://orvika.pages.dev${path}`);
    const response = await onRequest(context);
    assert.equal(response.status, 404, path);
    assert.equal(wasNextCalled(), false);
  }
});

test("keeps the well-known namespace available", async () => {
  const { context, wasNextCalled } = makeContext(
    "https://orvika.pages.dev/.well-known/security.txt",
  );
  const response = await onRequest(context);
  assert.equal(response.status, 200);
  assert.equal(wasNextCalled(), true);
});

test("rejects malformed percent-encoding", async () => {
  const { context, wasNextCalled } = makeContext("https://orvika.pages.dev/%E0%A4%A");
  const response = await onRequest(context);
  assert.equal(response.status, 400);
  assert.equal(wasNextCalled(), false);
});

test("rejects encoded path separators and traversal segments", async () => {
  for (const path of ["/private%2f..%2f.env", "/private%5c..%5c.env"]) {
    const { context, wasNextCalled } = makeContext(`https://orvika.pages.dev${path}`);
    const response = await onRequest(context);
    assert.ok([400, 404].includes(response.status), path);
    assert.equal(wasNextCalled(), false);
  }
});

test("rejects excessively long request URLs", async () => {
  const path = `https://orvika.pages.dev/${"a".repeat(4100)}`;
  const { context, wasNextCalled } = makeContext(path);
  const response = await onRequest(context);
  assert.equal(response.status, 414);
  assert.equal(wasNextCalled(), false);
});
