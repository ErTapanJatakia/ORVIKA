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
  'cross-origin-resource-policy',
];

for (const name of required) {
  assert.ok(values.has(name), `Missing required response header: ${name}`);
}

assert.match(values.get('strict-transport-security'), /max-age=31536000/);
assert.match(values.get('strict-transport-security'), /includeSubDomains/i, 'HSTS must cover subdomains');
assert.equal(values.get('x-content-type-options'), 'nosniff');
assert.equal(values.get('x-frame-options'), 'DENY');
assert.equal(values.get('cross-origin-opener-policy'), 'same-origin', 'COOP must use strict same-origin isolation');
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
  "connect-src 'self' https://cdn.jsdelivr.net",
  "script-src 'self' https://cdn.jsdelivr.net 'wasm-unsafe-eval'",
]) {
  assert.ok(csp.includes(directive), `CSP is missing: ${directive}`);
}
assert.ok(!/connect-src[^;]*\*/.test(csp), 'CSP must not allow wildcard connections');
assert.ok(!/script-src[^;]*\*/.test(csp), 'CSP must not allow wildcard script sources');
assert.ok(!/script-src[^;]*'unsafe-eval'/i.test(csp), 'CSP must not permit unsafe-eval');

console.log('ORVIKA Web response-header configuration: PASS');

const androidRoot = path.join(__dirname, '..', 'android');
const manifestPath = path.join(androidRoot, 'app', 'src', 'main', 'AndroidManifest.xml');
const gradlePath = path.join(androidRoot, 'app', 'build.gradle.kts');
const wrapperPath = path.join(androidRoot, 'gradle', 'wrapper', 'gradle-wrapper.properties');
const androidIgnorePath = path.join(androidRoot, '.gitignore');

for (const requiredPath of [manifestPath, gradlePath, wrapperPath, androidIgnorePath]) {
  assert.ok(fs.existsSync(requiredPath), `Missing Android security/release file: ${path.relative(androidRoot, requiredPath)}`);
}

const manifest = fs.readFileSync(manifestPath, 'utf8');
const permissions = [...manifest.matchAll(/<uses-permission\s+android:name="([^"]+)"/g)]
  .map((match) => match[1])
  .sort();
assert.deepEqual(
  permissions,
  ['android.permission.CAMERA', 'android.permission.INTERNET'],
  'Android manifest permission set changed; review privacy and platform requirements explicitly',
);

assert.match(
  manifest,
  /<uses-feature[\s\S]*?android:name="android\.hardware\.camera"[\s\S]*?android:required="false"/,
  'Camera must remain an optional device feature',
);
assert.match(
  manifest,
  /<uses-feature\b(?=[^>]*\bandroid:name="android\.hardware\.camera\.autofocus")(?=[^>]*\bandroid:required="false")[^>]*\/>/s,
  "Camera autofocus must remain an optional device feature",
);
assert.match(manifest, /android:usesCleartextTraffic="false"/, 'Android cleartext traffic must remain disabled');
assert.ok(!/android:debuggable="true"/.test(manifest), 'Production manifest must not enable debugging');
assert.match(manifest, /android:exported="true"/, 'Launcher activity must declare its exported state');
assert.match(manifest, /<action android:name="android\.intent\.action\.MAIN"\s*\/>[\s\S]*?<category android:name="android\.intent\.category\.LAUNCHER"\s*\/>/, 'Expected launcher intent filter is missing');

const gradle = fs.readFileSync(gradlePath, 'utf8');
assert.match(gradle, /applicationId = "com\.orvika\.app"/, 'Android application ID changed unexpectedly');
assert.match(gradle, /if \(gradle\.startParameter\.taskNames\.any/, 'Release signing guard is missing');
assert.match(gradle, /throw GradleException\([\s\S]*?release signing is not configured/, 'Unsigned release builds must fail closed');
for (const name of [
  'ORVIKA_UPLOAD_STORE_FILE',
  'ORVIKA_UPLOAD_STORE_PASSWORD',
  'ORVIKA_UPLOAD_KEY_ALIAS',
  'ORVIKA_UPLOAD_KEY_PASSWORD',
]) {
  assert.ok(gradle.includes(name), `Gradle signing configuration is missing ${name}`);
}

const androidIgnore = fs.readFileSync(androidIgnorePath, 'utf8');
assert.match(androidIgnore, /key\.properties/, 'Android signing properties must be ignored by Git');
assert.match(androidIgnore, /\*\*\/\*\.jks/, 'JKS keystores must be ignored by Git');
assert.match(androidIgnore, /\*\*\/\*\.keystore/, 'Keystore files must be ignored by Git');

const wrapper = fs.readFileSync(wrapperPath, 'utf8');
assert.match(wrapper, /distributionUrl=.*gradle-[0-9.]+-all\.zip/, 'Gradle wrapper distribution must be explicitly pinned');
assert.ok(fs.existsSync(path.join(androidRoot, 'gradlew')), 'Gradle wrapper launcher is missing');
assert.ok(fs.existsSync(path.join(androidRoot, 'gradlew.bat')), 'Windows Gradle wrapper launcher is missing');

console.log('ORVIKA Android manifest, permission and release-signing configuration: PASS');

