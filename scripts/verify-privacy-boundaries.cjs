'use strict';

const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const root = path.resolve(__dirname, '..');
const featureRoots = [
  'lib/features/link_check',
  'lib/features/qr_check',
  'lib/features/message_check',
];
const forbidden = [
  [/package:http\//, 'HTTP client dependency'],
  [/package:dio\//, 'Dio network client'],
  [/\bHttpClient\b/, 'Dart HttpClient'],
  [/\bhttp\.(?:get|post|put|patch|delete)\s*\(/, 'HTTP request'],
  [/\bfetch\s*\(/, 'Fetch request'],
  [/\bXMLHttpRequest\b/, 'XMLHttpRequest'],
  [/\b(?:navigator|window)\.sendBeacon\b/, 'Beacon request'],
  [/\b(?:launchUrl|canLaunchUrl)\s*\(/, 'External URL launch'],
  [/package:url_launcher\//, 'URL launcher dependency'],
  [/SharedPreferences/, 'Persistent preferences access'],
  [/localStorage|sessionStorage|indexedDB/i, 'Persistent browser storage'],
  [/FirebaseAnalytics|VercelAnalytics|window\.va\s*\(/, 'Analytics instrumentation'],
];

function walk(directory) {
  if (!fs.existsSync(directory)) return [];
  return fs.readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    // Never follow repository symlinks while walking source paths.
    if (entry.isSymbolicLink()) return [];
    const absolute = path.join(directory, entry.name);
    return entry.isDirectory() ? walk(absolute) : entry.name.endsWith('.dart') ? [absolute] : [];
  });
}

const scanned = featureRoots.flatMap((relative) => walk(path.join(root, relative)));
assert.ok(scanned.length > 0, 'No checker feature sources were found');

for (const file of scanned) {
  const relative = path.relative(root, file).split(path.sep).join('/');
  const source = fs.readFileSync(file, 'utf8');
  for (const [pattern, label] of forbidden) {
    assert.ok(!pattern.test(source), relative + ' contains forbidden ' + label);
  }
}

// Native temporary-file cleanup is the sole intentional dart:io use in QR Check.
for (const file of scanned) {
  const relative = path.relative(root, file).split(path.sep).join('/');
  if (relative === 'lib/features/qr_check/domain/qr_image_file_cleanup_io.dart') continue;
  const source = fs.readFileSync(file, 'utf8');
  assert.ok(!/import\s+['"]dart:io['"]/.test(source), relative + ' must not import dart:io');
}

const analytics = fs.readFileSync(path.join(root, 'web/orvika-analytics-bootstrap.js'), 'utf8');
assert.ok(!/document\.(?:body|forms)|querySelectorAll\s*\(.*(?:input|textarea)/is.test(analytics),
  'Analytics bootstrap must not inspect form or input content');
assert.ok(!/window\.va\s*\(\s*['"]event['"]/i.test(analytics),
  'Analytics bootstrap must not emit custom feature events');

console.log('ORVIKA checker privacy source boundaries: PASS.');
