import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";

const [html, styles] = await Promise.all([
  readFile(new URL("../../web/accessibility-contact.html", import.meta.url), "utf8"),
  readFile(new URL("../../web/accessibility-contact.css", import.meta.url), "utf8"),
]);

test("accessibility statement declares scope and publisher WCAG 2.2 AA claim", () => {
  assert.match(html, /<html lang="en">/);
  assert.match(html, /<main class="page">/);
  assert.match(html, /<h1>Accessibility Statement<\/h1>/);
  assert.equal((html.match(/wcag2\.2AA-blue/g) ?? []).length, 2);
  assert.match(html, /WCAG 2\.2 Level AA conformance claim/);
  assert.match(html, /Technologies relied upon/);
  assert.match(html, /Claim date/);
  assert.match(html, /Er\. Tapan Jatakia \(C\.Eng\.\), WCAG Auditor/);
  assert.match(html, /W3C does not review, validate, certify or endorse this claim/);
  assert.doesNotMatch(html, /A11Y-0[1-9]|A11Y-10|does not claim full WCAG/i);
});

test("WCAG auditor contact is directly available", () => {
  assert.match(html, /mailto:cyber\.litigation\.advisor@gmail\.com/);
  assert.match(html, /\+91 9664332984/);
  assert.match(html, /https:\/\/linktr\.ee\/ertapanjatakia/);
});

test("contact route retains visible focus, compact spacing and reduced-motion support", () => {
  assert.match(styles, /:focus-visible/);
  assert.match(styles, /prefers-reduced-motion/);
  assert.match(styles, /padding:16px/);
});
