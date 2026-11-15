import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";

const [html, styles] = await Promise.all([
  readFile(new URL("../../web/accessibility-contact.html", import.meta.url), "utf8"),
  readFile(new URL("../../web/accessibility-contact.css", import.meta.url), "utf8"),
]);

test("accessibility statement is standalone, semantic and clearly labelled", () => {
  assert.match(html, /<html lang="en">/);
  assert.match(html, /<main class="page">/);
  assert.match(html, /accessibility-badge/);
  assert.match(html, /role="status"|class="status"/);
  assert.match(html, /does not claim full WCAG/i);
});

test("contact addresses are directly available without CAPTCHA or an API", () => {
  assert.match(html, /mailto:ertapanjatakia@yandex\.com/);
  assert.match(html, /mailto:tapan_ditu_17\.20@outlook\.com/);
  assert.match(html, /No CAPTCHA, account, or verification challenge is required/i);
  assert.doesNotMatch(html, /turnstile|accessibility-contact\.js|\/api\/accessibility-contact/i);
});

test("contact route retains visible focus and reduced-motion support", () => {
  assert.match(styles, /:focus-visible/);
  assert.match(styles, /prefers-reduced-motion/);
});
