import assert from 'node:assert/strict';
import fc from 'fast-check';
import test from 'node:test';
import { onRequest } from '../../functions/_middleware.js';

async function checkPath(path) {
  const response = await onRequest({
    request: { method: 'GET', url: `https://orvika.pages.dev${path}` },
    next: async () => new Response('ok', { status: 200 }),
  });
  return response.status;
}

test('bounded property-based URL path validation rejects hidden and control-character segments', async () => {
  await fc.assert(
    fc.asyncProperty(fc.string({ maxLength: 128 }), async (generated) => {
      const value = generated.toWellFormed();
      const status = await checkPath('/' + encodeURIComponent(value));
      assert.ok(status === 200 || status === 400, 'middleware must not produce an unexpected response');
      const hasControlCharacters = /[\u0000-\u001f\u007f]/.test(value);
      const hasHiddenSegment = value.split('/').some(
        (segment) => segment.startsWith('.') && segment !== '.well-known',
      );
      if (hasControlCharacters || hasHiddenSegment) assert.equal(status, 400);
    }),
    { seed: 20261123, numRuns: 192, endOnFailure: true },
  );
});

test('bounded property-based malformed percent encodings are rejected', async () => {
  await fc.assert(
    fc.asyncProperty(fc.string({ maxLength: 64 }), async (generated) => {
      const path = '/probe/' + encodeURIComponent(generated.toWellFormed()) + '%';
      assert.equal(await checkPath(path), 400);
    }),
    { seed: 20261124, numRuns: 96, endOnFailure: true },
  );
});
