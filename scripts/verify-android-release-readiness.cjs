'use strict';

const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { execFileSync } = require('node:child_process');

const root = path.resolve(__dirname, '..');
const android = path.join(root, 'android');
const read = (relative) => fs.readFileSync(path.join(root, relative), 'utf8');
const requiredFiles = [
  'android/gradlew',
  'android/gradlew.bat',
  'android/gradle/wrapper/gradle-wrapper.jar',
  'android/gradle/wrapper/gradle-wrapper.properties',
  'android/settings.gradle.kts',
  'android/build.gradle.kts',
  'android/app/build.gradle.kts',
  'android/app/src/main/AndroidManifest.xml',
  'android/app/src/main/res/xml/backup_rules.xml',
  'android/app/src/main/res/xml/data_extraction_rules.xml',
  'android/.gitignore',
];

for (const relative of requiredFiles) {
  assert.ok(fs.existsSync(path.join(root, relative)), `Missing Android release input: ${relative}`);
}

const wrapper = read('android/gradle/wrapper/gradle-wrapper.properties');
const distributionUrl = wrapper.match(/^distributionUrl=(.+)$/m)?.[1]?.replace(/\\:/g, ':');
const wrapperVersion = distributionUrl?.match(/gradle-([0-9.]+)-all\.zip/)?.[1];
assert.equal(wrapperVersion, '9.3.1', 'Review and update the expected wrapper checksum when changing Gradle versions');
assert.equal(
  distributionUrl,
  'https://services.gradle.org/distributions/gradle-9.3.1-all.zip',
  'Gradle wrapper distribution must use the reviewed official HTTPS URL',
);
const wrapperChecksum = wrapper.match(/^distributionSha256Sum=([a-f0-9]{64})$/m)?.[1];
assert.equal(
  wrapperChecksum,
  '17f277867f6914d61b1aa02efab1ba7bb439ad652ca485cd8ca6842fccec6e43',
  'Gradle 9.3.1 distribution checksum differs from the reviewed official SHA-256',
);

const settings = read('android/settings.gradle.kts');
const appGradle = read('android/app/build.gradle.kts');
const manifest = read('android/app/src/main/AndroidManifest.xml');
const legacyBackupRules = read('android/app/src/main/res/xml/backup_rules.xml');
const extractionRules = read('android/app/src/main/res/xml/data_extraction_rules.xml');
const ignore = read('android/.gitignore');
const pubspec = read('pubspec.yaml');

assert.match(settings, /id\("com\.android\.application"\)\s+version\s+"[0-9.]+"/);
assert.match(settings, /id\("org\.jetbrains\.kotlin\.android"\)\s+version\s+"[0-9.]+"/);
assert.match(appGradle, /namespace = "com\.orvika\.app"/);
assert.match(appGradle, /applicationId = "com\.orvika\.app"/);
assert.match(appGradle, /sourceCompatibility = JavaVersion\.VERSION_17/);
assert.match(appGradle, /targetCompatibility = JavaVersion\.VERSION_17/);
assert.match(appGradle, /throw GradleException\([\s\S]*?release signing is not configured/);
assert.match(manifest, /android:usesCleartextTraffic="false"/);
assert.match(manifest, /android:allowBackup="false"/);
assert.match(manifest, /android:fullBackupContent="@xml\/backup_rules"/);
assert.match(manifest, /android:dataExtractionRules="@xml\/data_extraction_rules"/);
assert.match(legacyBackupRules, /<exclude domain="root" path="\."\s*\/>/);
assert.match(extractionRules, /<cloud-backup>[\s\S]*?<exclude domain="root" path="\."\s*\/>[\s\S]*?<\/cloud-backup>/);
assert.match(extractionRules, /<device-transfer>[\s\S]*?<exclude domain="root" path="\."\s*\/>[\s\S]*?<\/device-transfer>/);
assert.match(manifest, /android:name="android\.hardware\.camera"[\s\S]*?android:required="false"/);
assert.match(
  manifest,
  /<uses-feature\b(?=[^>]*\bandroid:name="android\.hardware\.camera\.autofocus")(?=[^>]*\bandroid:required="false")[^>]*\/>/s,
  "Camera autofocus must remain an optional device feature",
);
assert.match(ignore, /key\.properties/);
assert.match(ignore, /\*\*\/\*\.jks/);
assert.match(ignore, /\*\*\/\*\.keystore/);
assert.match(ignore, /\*\*\/\*\.p12/);
assert.match(ignore, /\*\*\/\*\.pfx/);

const tracked = execFileSync('git', ['-C', root, 'ls-files', '--', 'android'], {
  encoding: 'utf8',
}).split(/\r?\n/).filter(Boolean);
const trackedSecrets = tracked.filter((file) =>
  /(^|\/)(key\.properties|[^/]+\.(?:jks|keystore|p12|pfx))$/i.test(file),
);
assert.deepEqual(trackedSecrets, [], 'Signing properties or keystore material must never be tracked');

const signingPropertyNames = ['storeFile', 'storePassword', 'keyAlias', 'keyPassword'];
const signingEnvironmentNames = [
  'ORVIKA_UPLOAD_STORE_FILE',
  'ORVIKA_UPLOAD_STORE_PASSWORD',
  'ORVIKA_UPLOAD_KEY_ALIAS',
  'ORVIKA_UPLOAD_KEY_PASSWORD',
];
const propertiesPath = path.join(android, 'key.properties');
const properties = new Map();
if (fs.existsSync(propertiesPath)) {
  for (const line of fs.readFileSync(propertiesPath, 'utf8').split(/\r?\n/)) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith('#')) continue;
    const separator = trimmed.indexOf('=');
    if (separator < 0) {
      properties.set(trimmed, '');
    } else {
      properties.set(trimmed.slice(0, separator).trim(), trimmed.slice(separator + 1).trim());
    }
  }
}

// Match Gradle's per-key precedence exactly: a present but blank property does
// not fall back to its environment variable because signingValue() applies
// the blank-value filter after the property/environment choice.
const resolvedSigningValues = signingPropertyNames.map((propertyName, index) => {
  const value = properties.has(propertyName)
    ? properties.get(propertyName)
    : process.env[signingEnvironmentNames[index]];
  return typeof value === 'string' && value.trim() ? value.trim() : null;
});
const signingValuesComplete = resolvedSigningValues.every(Boolean);
const configuredStoreFile = resolvedSigningValues[0];
const resolvedStoreFile = configuredStoreFile
  ? (path.isAbsolute(configuredStoreFile)
      ? configuredStoreFile
      : path.resolve(android, 'app', configuredStoreFile))
  : null;
const signingStoreFileExists = Boolean(
  resolvedStoreFile && fs.existsSync(resolvedStoreFile) && fs.statSync(resolvedStoreFile).isFile(),
);
if (signingValuesComplete) {
  assert.ok(signingStoreFileExists, 'Release signing values are present but the configured keystore file is missing');
}
const signingReady = signingValuesComplete && signingStoreFileExists;

const version = pubspec.match(/^version:\s*(.+)$/m)?.[1]?.trim() ?? 'not declared';
const gradlePlugin = settings.match(/id\("com\.android\.application"\)\s+version\s+"([0-9.]+)"/)?.[1] ?? 'not detected';
const kotlinPlugin = settings.match(/id\("org\.jetbrains\.kotlin\.android"\)\s+version\s+"([0-9.]+)"/)?.[1] ?? 'not detected';

console.log('ORVIKA Android release preflight: STRUCTURE PASS');
console.log(`- Application ID: com.orvika.app`);
console.log(`- App version: ${version}`);
console.log(`- Gradle wrapper: ${wrapperVersion} (SHA-256 pinned)`);
console.log(`- Android Gradle Plugin: ${gradlePlugin}`);
console.log(`- Kotlin plugin: ${kotlinPlugin}`);
console.log(`- Java compatibility: 17`);
console.log(`- Android app backup: disabled; full backup and device-transfer exclusions present`);
console.log(`- Tracked signing secrets: none`);
console.log(`- Release signing: ${signingReady ? 'CONFIGURED (credentials not displayed)' : signingValuesComplete ? 'INVALID — configured keystore file is missing' : resolvedSigningValues.some(Boolean) ? 'INCOMPLETE — signing values are partial' : 'NOT CONFIGURED — release artifacts must not be built or submitted'}`);
