const assert = require('node:assert/strict');
const { chromium } = require('playwright');

const baseUrl = (process.env.ORVIKA_BASE_URL || 'https://orvika-web.vercel.app').replace(/\/$/, '');
const pageErrors = [];
const consoleErrors = [];
const failedRequests = [];

async function main() {
  const browser = await chromium.launch({ headless: true });
  try {
    const page = await browser.newPage({ viewport: { width: 1440, height: 1000 } });
    page.on('pageerror', (error) => pageErrors.push(error.message));
    page.on('console', (message) => {
      if (message.type() === 'error') consoleErrors.push(message.text());
    });
    page.on('requestfailed', (request) => {
      failedRequests.push({
        url: request.url(),
        error: request.failure()?.errorText || 'unknown request failure',
      });
    });

    async function verifyViewport(width, height, label) {
      await page.setViewportSize({ width, height });
      const response = await page.goto(baseUrl, {
        waitUntil: 'domcontentloaded',
        timeout: 90000,
      });
      assert(response, `${label}: navigation returned no HTTP response`);
      assert.equal(response.status(), 200, `${label}: unexpected HTTP status`);

      // Flutter Web renderer internals vary by engine version. Inspect light DOM
      // and nested shadow roots rather than relying on one private tag selector.
      await page.waitForTimeout(4000);
      const renderer = await page.evaluate(() => {
        function deepExists(selector, root = document) {
          if (root.querySelector(selector)) return true;
          for (const element of root.querySelectorAll('*')) {
            if (element.shadowRoot && deepExists(selector, element.shadowRoot)) return true;
          }
          return false;
        }

        const flutterTags = Array.from(document.querySelectorAll('*'))
          .map((element) => element.tagName.toLowerCase())
          .filter((tag) => tag.startsWith('flt-') || tag === 'flutter-view');

        return {
          viewportWidth: window.innerWidth,
          documentWidth: document.documentElement.scrollWidth,
          title: document.title,
          hasFlutterView: deepExists('flutter-view'),
          hasGlassPane: deepExists('flt-glass-pane'),
          hasSceneHost: deepExists('flt-scene-host'),
          hasCanvasContainer: deepExists('flt-canvas-container'),
          hasCanvas: deepExists('canvas'),
          flutterTags: [...new Set(flutterTags)],
          bodyText: document.body.innerText.slice(0, 500),
          bodyMarkup: document.body.innerHTML.slice(0, 1800),
          scriptSources: Array.from(document.scripts).map((script) => script.src).filter(Boolean),
        };
      });

      console.log(`${label} renderer diagnostics: ${JSON.stringify(renderer)}`);
      assert(renderer.title.includes('ORVIKA'), `${label}: unexpected document title`);
      assert(
        renderer.hasFlutterView || renderer.hasGlassPane || renderer.hasSceneHost,
        `${label}: Flutter Web root was not detected; page errors: ${pageErrors.join(' | ')}; failed requests: ${JSON.stringify(failedRequests)}`,
      );
      assert(
        renderer.hasCanvas || renderer.hasCanvasContainer || renderer.hasSceneHost,
        `${label}: Flutter renderer surface was not detected`,
      );
      assert(
        renderer.documentWidth <= renderer.viewportWidth + 2,
        `${label}: horizontal overflow (${renderer.documentWidth}px document / ${renderer.viewportWidth}px viewport)`,
      );

      console.log(`${label} viewport passed.`);
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
    console.log(`Browser console errors (diagnostic): ${JSON.stringify(consoleErrors)}`);
    console.log('ORVIKA production browser smoke tests passed.');
  } finally {
    await browser.close();
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
