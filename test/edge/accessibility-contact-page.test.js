import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";

const [html, script, styles] = await Promise.all([
  readFile(new URL("../../web/accessibility-contact.html", import.meta.url), "utf8"),
  readFile(new URL("../../web/accessibility-contact.js", import.meta.url), "utf8"),
  readFile(new URL("../../web/accessibility-contact.css", import.meta.url), "utf8"),
]);

test("accessibility contact page loads a semantic, standalone statement", () => {
  assert.match(html, /<html lang="en">/);
  assert.match(html, /<main class="page">/);
  assert.match(html, /role="status" aria-live="polite"/);
  assert.match(html, /accessibility-contact\.js/);
  assert.match(html, /accessibility-contact\.css/);
  assert.match(html, /does not claim full WCAG/i);
});

test("contact addresses are never embedded in public page assets", () => {
  assert.doesNotMatch(html + script, /ertapanjatakia@yandex\.com|tapan_ditu_17\.20@outlook\.com/i);
  assert.match(script, /turnstileToken/);
  assert.match(script, /contact_reveal/);
  assert.match(script, /\/api\/accessibility-contact/);
  assert.match(script, /credentials: 'omit'/);
});

test("contact disclosure is fail-closed and uses accessible status feedback", () => {
  assert.match(html, /disabled>Verify and reveal contact details/);
  assert.match(html, /aria-live="polite"/);
  assert.match(script, /if \(!token\) return/);
  assert.match(script, /!response\.ok/);
  assert.match(styles, /:focus-visible/);
  assert.match(styles, /prefers-reduced-motion/);
});
