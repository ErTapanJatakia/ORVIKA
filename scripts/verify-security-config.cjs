'use strict';

const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const configPath = path.join(__dirname, '..', 'vercel.json');
const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
const headers = config.headers?.flatMap((entry) => entry.headers ?? []) ?? [];
const values = new Map(headers.map(({ key, value }) => [key.toLowerCase(), value]));
const required = [
  'strict-transport-security',
  'x-content-type-options',
  'x-frame-options',
  'referrer-policy',
  'permissions-policy',
  'content-security-policy',
  'cross-origin-embedder-policy',
  'cross-origin-opener-policy',
];

for (const name of required) {
  assert.ok(values.has(name), `Missing required response header: ${name}`);
}

assert.match(values.get('strict-transport-security'), /max-age=31536000/);
assert.equal(values.get('x-content-type-options'), 'nosniff');
assert.equal(values.get('x-frame-options'), 'DENY');
assert.match(values.get('permissions-policy'), /camera=\(self\)/);
assert.match(values.get('permissions-policy'), /microphone=\(\)/);
assert.match(values.get('permissions-policy'), /geolocation=\(\)/);

const csp = values.get('content-security-policy');
for (const directive of [
  "default-src 'none'",
  "base-uri 'self'",
  "object-src 'none'",
  "frame-ancestors 'none'",
  "form-action 'self'",
  "connect-src 'self'",
]) {
  assert.ok(csp.includes(directive), `CSP is missing: ${directive}`);
}
assert.ok(!/connect-src[^;]*\*/.test(csp), 'CSP must not allow wildcard connections');

console.log('ORVIKA security response-header configuration: PASS');
