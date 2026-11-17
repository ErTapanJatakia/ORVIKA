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
const dynamicReceiverPermission = `${applicationId}.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`;
const expected = [
  'android.permission.ACCESS_NETWORK_STATE',
  'android.permission.CAMERA',
  'android.permission.INTERNET',
  dynamicReceiverPermission,
].sort();

assert.deepEqual(
  actual,
  expected,
  'Merged APK manifest permission set differs from the reviewed Android + AndroidX allowlist',
);

// AndroidX Core contributes this app-scoped permission to protect dynamic
// receivers on Android versions before API 33. Do not merely allowlist its
// uses-permission: the declaration must be signature-protected as well.
// aapt versions may render the enum as a typed hexadecimal value or a name.
const signatureProtectionPattern =
  /android:protectionLevel\\([^)]*\\)=(?:\\(type 0x11\\))?(?:0x0*2|"signature")/i;

// Guard the parser against the representations emitted by Android build-tools.
assert.match(
  'android:protectionLevel(0x01010009)=(type 0x11)0x2',
  signatureProtectionPattern,
);
assert.match(
  'android:protectionLevel(0x01010009)="signature"',
  signatureProtectionPattern,
);
assert.doesNotMatch(
  'android:protectionLevel(0x01010009)=(type 0x11)0x0',
  signatureProtectionPattern,
);

const manifestTree = execFileSync(
  aapt,
  ['dump', 'xmltree', apk, 'AndroidManifest.xml'],
  { encoding: 'utf8' },
);
const manifestElements = manifestTree.split(/(?=^\\s*E: )/m);
const dynamicPermissionDeclaration = manifestElements.find((element) =>
  /^\\s*E: permission(?:\\s|$)/.test(element) &&
  element.includes(dynamicReceiverPermission),
);
assert.ok(
  dynamicPermissionDeclaration,
  `Merged APK manifest must declare ${dynamicReceiverPermission}`,
);
assert.match(
  dynamicPermissionDeclaration,
  signatureProtectionPattern,
  'AndroidX dynamic receiver permission must use signature-level protection',
);

console.log('Built APK identity and merged-manifest permissions verified.');
console.log(`- Application ID: ${applicationId}`);
console.log(`- Permissions: ${actual.join(', ')}`);
console.log('- AndroidX dynamic receiver permission: declared with signature protection');
