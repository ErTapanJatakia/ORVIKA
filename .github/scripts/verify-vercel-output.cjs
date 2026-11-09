const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const configPath = path.join('.vercel', 'output', 'config.json');
assert(fs.existsSync(configPath), `Vercel Build Output API config not found: ${configPath}`);

const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
assert.equal(config.version, 3, 'Unexpected Vercel Build Output API config version');
assert(Array.isArray(config.routes), 'Vercel Build Output API config has no routes array');

const required = {
  'strict-transport-security': /max-age=31536000(?:;|$)/i,
  'x-content-type-options': /^nosniff$/i,
  'x-frame-options': /^DENY$/i,
  'referrer-policy': /^strict-origin-when-cross-origin$/i,
  'permissions-policy': /camera=\(self\)/i,
};

const candidates = config.routes.filter((route) => {
  if (typeof route.src !== 'string' || !route.headers || typeof route.headers !== 'object') return false;
  try {
    return new RegExp(route.src).test('/') && new RegExp(route.src).test('/index.html');
  } catch {
    return false;
  }
});

console.log(`Vercel output route candidates for / and /index.html: ${JSON.stringify(candidates, null, 2)}`);
assert(candidates.length > 0, 'No generated Vercel response-header route matches both / and /index.html');

const normalized = candidates.map((route) =>
  Object.fromEntries(Object.entries(route.headers).map(([key, value]) => [key.toLowerCase(), String(value)])),
);
for (const [name, pattern] of Object.entries(required)) {
  assert(
    normalized.some((headers) => pattern.test(headers[name] || '')),
    `Generated Vercel output is missing required response header: ${name}`,
  );
}
console.log('Generated Vercel output contains all required security headers for / and /index.html.');
