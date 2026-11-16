'use strict';

const assert = require('node:assert/strict');
const { execFileSync } = require('node:child_process');

const [aapt, apk] = process.argv.slice(2);
assert.ok(aapt, 'Usage: node verify-android-apk-manifest.cjs <aapt-path> <apk-path>');
assert.ok(apk, 'Usage: node verify-android-apk-manifest.cjs <aapt-path> <apk-path>');

const badging = execFileSync(aapt, ['dump', 'badging', apk], { encoding: 'utf8' });
const applicationId = badging.match(/^package: name='([^']+)'/m)?.[1];
assert.equal(applicationId, 'com.orvika.app', 'Built APK application ID must be com.orvika.app');

const permissionsOutput = execFileSync(aapt, ['dump', 'permissions', apk], { encoding: 'utf8' });
const permissions = [...permissionsOutput.matchAll(/^uses-permission(?:-sdk-\\d+)?: name='([^']+)'/gm)]
  .map((match) => match[1]);
const actual = [...new Set(permissions)].sort();
const expected = ['android.permission.CAMERA', 'android.permission.INTERNET'].sort();

assert.deepEqual(
  actual,
  expected,
  'Merged APK manifest permission set differs from the reviewed CAMERA + INTERNET allowlist',
);

console.log('Built APK identity and merged-manifest permissions verified.');
console.log(`- Application ID: ${applicationId}`);
console.log(`- Permissions: ${actual.join(', ')}`);
