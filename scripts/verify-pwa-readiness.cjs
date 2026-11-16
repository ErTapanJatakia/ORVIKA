'use strict';

const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const root = path.resolve(__dirname, '..');
const web = path.join(root, 'web');
const read = (file) => fs.readFileSync(path.join(root, file), 'utf8');
const manifest = JSON.parse(read('web/manifest.json'));
const index = read('web/index.html');

for (const key of [
  'id',
  'name',
  'short_name',
  'description',
  'lang',
  'start_url',
  'scope',
  'display',
  'theme_color',
  'background_color',
]) {
  assert.ok(typeof manifest[key] === 'string' && manifest[key].trim(), `PWA manifest is missing ${key}`);
}

assert.equal(manifest.id, './', 'PWA identity should remain stable at the application root');
assert.equal(manifest.scope, './', 'PWA scope should remain confined to the application root');
assert.equal(manifest.start_url, './', 'PWA start URL should remain relative to the deployment base');
assert.equal(manifest.display, 'standalone');
assert.equal(manifest.prefer_related_applications, false);
assert.ok(Array.isArray(manifest.display_override) && manifest.display_override.includes('standalone'));

const requiredIconSizes = new Set(['192x192', '512x512']);
const seenSizes = new Set();
let hasMaskableIcon = false;

for (const icon of manifest.icons ?? []) {
  assert.ok(icon.src && !icon.src.startsWith('/') && !icon.src.includes('..'), 'PWA icon path must remain local and relative');
  const iconPath = path.join(web, icon.src);
  assert.ok(fs.existsSync(iconPath), `PWA icon file is missing: ${icon.src}`);
  assert.equal(icon.type, 'image/svg+xml', `Unexpected icon type for ${icon.src}`);

  const svg = fs.readFileSync(iconPath, 'utf8');
  const dimensions = svg.match(/<svg[^>]*\bwidth="(\d+)"[^>]*\bheight="(\d+)"[^>]*\bviewBox="([^"]+)"/i);
  assert.ok(dimensions, `PWA SVG icon must declare width, height and viewBox: ${icon.src}`);
  const actualSize = `${dimensions[1]}x${dimensions[2]}`;
  assert.equal(actualSize, icon.sizes, `Declared PWA icon size does not match SVG dimensions: ${icon.src}`);
  seenSizes.add(icon.sizes);
  if ((icon.purpose ?? '').split(/\s+/).includes('maskable')) hasMaskableIcon = true;
}

for (const size of requiredIconSizes) {
  assert.ok(seenSizes.has(size), `PWA manifest needs a ${size} icon`);
}
assert.ok(hasMaskableIcon, 'PWA manifest needs a maskable icon');

for (const marker of [
  '<link rel="manifest" href="manifest.json">',
  '<meta name="theme-color"',
  '<meta name="mobile-web-app-capable" content="yes">',
  '<meta name="apple-mobile-web-app-capable" content="yes">',
  '<meta name="apple-mobile-web-app-title" content="ORVIKA">',
  '<link rel="mask-icon"',
  '<link rel="apple-touch-icon" sizes="192x192" href="icons/apple-touch-icon.png">',
  'src="flutter_bootstrap.js"',
  'src="orvika-analytics-bootstrap.js"',
]) {
  assert.ok(index.includes(marker), `Web entrypoint is missing required PWA metadata: ${marker}`);
}

assert.ok(!/serviceWorker\.register\s*\(/.test(index), 'Do not add a second hand-written service-worker registration beside Flutter bootstrap');
assert.ok(fs.existsSync(path.join(web, 'icons', 'apple-touch-icon.png')), 'Apple touch icon PNG is missing');
const appleTouchIcon = fs.readFileSync(path.join(web, 'icons', 'apple-touch-icon.png'));
assert.deepEqual([...appleTouchIcon.subarray(0, 8)], [137, 80, 78, 71, 13, 10, 26, 10], 'Apple touch icon must be a valid PNG');
assert.equal(appleTouchIcon.readUInt32BE(16), 192, 'Apple touch icon width must be 192px');
assert.equal(appleTouchIcon.readUInt32BE(20), 192, 'Apple touch icon height must be 192px');

console.log('ORVIKA PWA source metadata and icon references: PASS');

const buildWeb = path.join(root, 'build', 'web');
if (fs.existsSync(buildWeb)) {
  assert.ok(fs.existsSync(path.join(buildWeb, 'flutter_bootstrap.js')), 'Built Web output is missing Flutter bootstrap');
  assert.ok(fs.existsSync(path.join(buildWeb, 'manifest.json')), 'Built Web output is missing its PWA manifest');
  console.log('ORVIKA built Web output: present; browser install/offline validation is still required');
  console.log(`Flutter service-worker artifact: ${fs.existsSync(path.join(buildWeb, 'flutter_service_worker.js')) ? 'present' : 'not emitted by this Flutter build/strategy'}`);
} else {
  console.log('ORVIKA built Web output: not present; run this preflight after an authorised Flutter Web build');
}
