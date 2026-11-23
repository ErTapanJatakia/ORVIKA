import assert from 'node:assert/strict';
import { createRequire } from 'node:module';
import test from 'node:test';

const require = createRequire(import.meta.url);
const { resolveDirectoryEntry } = require('../../scripts/verify-privacy-boundaries.cjs');

test('privacy source walker resolves a valid child basename', () => {
  assert.equal(
    resolveDirectoryEntry('/repo/lib/features', 'link_check.dart'),
    '/repo/lib/features/link_check.dart',
  );
});

test('privacy source walker rejects traversal and path separators', () => {
  for (const name of ['..', '.', '../escape', 'sub/file.dart', 'sub\\file.dart', '']) {
    assert.throws(
      () => resolveDirectoryEntry('/repo/lib/features', name),
      /safe single path segment/,
      name,
    );
  }
});
