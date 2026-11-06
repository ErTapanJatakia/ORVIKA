const assert = require('node:assert/strict');
const { chromium } = require('playwright');

const baseUrl = (process.env.ORVIKA_BASE_URL || 'https://orvika-web.vercel.app').replace(/\/$/, '');
const pageErrors = [];

async function main() {
  const browser = await chromium.launch({ headless: true });
  try {
    const page = await browser.newPage({ viewport: { width: 1440, height: 1000 } });
    page.on('pageerror', (error) => pageErrors.push(error.message));

    async function verifyViewport(width, height, label) {
      await page.setViewportSize({ width, height });
      const response = await page.goto(baseUrl, {
        waitUntil: 'domcontentloaded',
        timeout: 90000,
      });
      assert(response, `${label}: navigation returned no HTTP response`);
      assert.equal(response.status(), 200, `${label}: unexpected HTTP status`);

      await page.waitForFunction(
        () => Boolean(
          document.querySelector('flt-glass-pane') &&
          document.querySelector('canvas')
        ),
        null,
        { timeout: 90000 },
      );

      const metrics = await page.evaluate(() => ({
        viewportWidth: window.innerWidth,
        documentWidth: document.documentElement.scrollWidth,
        hasFlutterGlassPane: Boolean(document.querySelector('flt-glass-pane')),
        hasCanvas: Boolean(document.querySelector('canvas')),
        title: document.title,
      }));

      assert(metrics.hasFlutterGlassPane, `${label}: Flutter surface did not mount`);
      assert(metrics.hasCanvas, `${label}: Flutter canvas did not render`);
      assert(
        metrics.documentWidth <= metrics.viewportWidth + 2,
        `${label}: horizontal overflow (${metrics.documentWidth}px document / ${metrics.viewportWidth}px viewport)`,
      );
      assert(metrics.title.includes('ORVIKA'), `${label}: unexpected document title`);

      console.log(`${label} viewport passed: ${JSON.stringify(metrics)}`);
    }

    await verifyViewport(1440, 1000, 'Desktop');
    await verifyViewport(390, 844, 'Mobile');

    const manifest = await page.request.get(new URL('manifest.json', `${baseUrl}/`).toString());
    assert.equal(manifest.status(), 200, 'PWA manifest did not return HTTP 200');
    const manifestJson = await manifest.json();
    assert.equal(manifestJson.short_name, 'ORVIKA', 'PWA manifest branding is missing');

    const favicon = await page.request.get(new URL('favicon.svg', `${baseUrl}/`).toString());
    assert.equal(favicon.status(), 200, 'ORVIKA favicon did not return HTTP 200');

    assert.deepEqual(pageErrors, [], `Browser runtime errors: ${pageErrors.join(' | ')}`);
    console.log('ORVIKA production browser smoke tests passed.');
  } finally {
    await browser.close();
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
