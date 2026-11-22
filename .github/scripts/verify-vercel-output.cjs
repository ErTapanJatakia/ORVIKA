const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const configPath = path.join('.vercel', 'output', 'config.json');
assert(fs.existsSync(configPath), `Vercel Build Output API config not found: ${configPath}`);

const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
assert.equal(config.version, 3, 'Unexpected Vercel Build Output API config version');
assert(Array.isArray(config.routes), 'Vercel Build Output API config has no routes array');

function hasValidHsts(value) {
  const header = String(value || '');
  const maxAge = header.match(/(?:^|;)\s*max-age=(\d+)/i);
  return Boolean(maxAge && Number(maxAge[1]) >= 31536000 && /(?:^|;)\s*includeSubDomains(?:;|$)/i.test(header));
}

const required = {
  'strict-transport-security': hasValidHsts,
  'x-content-type-options': /^nosniff$/i,
  'x-frame-options': /^DENY$/i,
  'referrer-policy': /^strict-origin-when-cross-origin$/i,
  'permissions-policy': /camera=\(self\)/i,
  'content-security-policy': (value) => /default-src 'none'/i.test(value)
    && /script-src[^;]*'wasm-unsafe-eval'/i.test(value)
    && /object-src 'none'/i.test(value)
    && /frame-ancestors 'none'/i.test(value)
    && /base-uri 'self'/i.test(value)
    && /form-action 'self'/i.test(value)
    && !/script-src[^;]*'unsafe-eval'/i.test(value),
  'cross-origin-embedder-policy': /^credentialless$/i,
  'cross-origin-opener-policy': /^same-origin$/i,
};

const MAX_ROUTE_SOURCE_LENGTH = 256;
const UNSAFE_ROUTE_REGEX_FEATURES = /(?:\\([^)]*[+*][^)]*\\)[+*{]|\\\\[1-9]|\\(\\?[=!<])/;

function matchesPath(route, pathname) {
  if (typeof route.src !== 'string') return false;
  if (!['/', '/index.html'].includes(pathname)) return false;
  if (route.src.length > MAX_ROUTE_SOURCE_LENGTH || UNSAFE_ROUTE_REGEX_FEATURES.test(route.src)) {
    throw new Error('Vercel route source exceeds the bounded verification pattern policy.');
  }
  try {
    // Vercel-generated route expressions are checked against only two fixed, short local paths.
    return new RegExp(route.src).test(pathname);
  } catch (error) {
    throw new Error(`Invalid Vercel route regex: ${error.message}`);
  }
}

function normalizeHeaders(headers) {
  return Object.fromEntries(Object.entries(headers || {}).map(([key, value]) => [key.toLowerCase(), String(value)]));
}

for (const pathname of ['/', '/index.html']) {
  const matchingRoutes = config.routes.filter((route) => matchesPath(route, pathname));
  const headerRoutes = matchingRoutes.filter((route) => route.headers && typeof route.headers === 'object');
  console.log('Vercel response-header route evaluation in progress.');

  const completeHeaderRoute = headerRoutes.find((route) => {
    const headers = normalizeHeaders(route.headers);
    return Object.entries(required).every(([name, matcher]) => (
      typeof matcher === 'function' ? matcher(headers[name] || '') : matcher.test(headers[name] || '')
    ));
  });

  assert(completeHeaderRoute, `No single generated Vercel response-header route applies all required security headers to ${pathname}`);
  const appliedHeaders = normalizeHeaders(completeHeaderRoute.headers);
  assert.equal(appliedHeaders['access-control-allow-origin'], undefined, 'Static pages must not expose a permissive CORS origin');
}

console.log('Generated Vercel output applies the complete required security-header set to / and /index.html.');
