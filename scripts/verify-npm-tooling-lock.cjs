'use strict';

const assert = require('node:assert/strict');
const fs = require('node:fs');

const manifest = JSON.parse(fs.readFileSync('.github/tooling/package.json', 'utf8'));
const lock = JSON.parse(fs.readFileSync('.github/tooling/package-lock.json', 'utf8'));
const expectedDirectDependencies = {
  playwright: '1.56.1',
  vercel: '65.17.0',
  wrangler: '4.163.0',
};

assert.equal(lock.lockfileVersion, 3, 'CI tooling lockfile must use npm lockfile v3.');
assert.deepEqual(
  manifest.devDependencies,
  expectedDirectDependencies,
  'CI tooling direct dependencies must remain explicitly version-pinned.',
);
assert.deepEqual(
  lock.packages?.['']?.devDependencies,
  manifest.devDependencies,
  'CI tooling lockfile root dependencies must match package.json exactly.',
);

const packages = Object.entries(lock.packages ?? {}).filter(([path]) => path);
const invalid = packages.filter(([, item]) => (
  !item.resolved?.startsWith('https://registry.npmjs.org/') || !item.integrity
));
assert.deepEqual(
  invalid.map(([path]) => path),
  [],
  'Every locked CI tooling package must resolve from the npm registry and include integrity metadata.',
);

console.log(
  'ORVIKA npm tooling lockfile: PASS (' + packages.length +
  ' package entries; all registry resolutions include integrity metadata).',
);
