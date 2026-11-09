const assert = require('node:assert/strict');
const { chromium } = require('playwright');

const baseUrl = (process.env.ORVIKA_BASE_URL || 'https://orvika-web.vercel.app').replace(/\/$/, '');
const pageErrors = [];
const consoleErrors = [];
const failedRequests = [];
const criticalAssetResponses = [];

function redirectChain(request) {
  const chain = [];
  let current = request;
  while (current) {
    chain.unshift(current.url());
    current = current.redirectedFrom();
  }
  return chain;
}

async function main() {
  const browser = await chromium.launch({ headless: true });
  try {
    async function verifyViewport(width, height, label) {
      // Isolate each viewport and block service workers so a prior navigation
      // cannot satisfy the next check from a PWA-controlled cached response.
      const context = await browser.newContext({
        viewport: { width, height },
        locale: 'en-IN',
        timezoneId: 'Asia/Kolkata',
        serviceWorkers: 'block',
      });
      try {
        const page = await context.newPage();
        page.on('pageerror', (error) => pageErrors.push(error.message));
        page.on('console', (message) => {
          if (message.type() === 'error') consoleErrors.push(message.text());
        });
        page.on('response', (response) => {
          const url = new URL(response.url());
          const sameOrigin = url.origin === new URL(baseUrl).origin;
          if (sameOrigin && /\/(flutter_bootstrap\.js|main\.dart\.js|manifest\.json|favicon\.svg)$/.test(url.pathname)) {
            criticalAssetResponses.push({ path: url.pathname, status: response.status() });
          }
        });
        page.on('requestfailed', (request) => {
          failedRequests.push({
            url: request.url(),
            error: request.failure()?.errorText || 'unknown request failure',
          });
        });

        const response = await page.goto(baseUrl, {
          waitUntil: 'domcontentloaded',
          timeout: 90000,
        });
        assert(response, `${label}: navigation returned no HTTP response`);
        assert.equal(response.status(), 200, `${label}: unexpected HTTP status`);
        const headers = response.headers();
        const headerDiagnostics = {
          requestedUrl: baseUrl,
          finalResponseUrl: response.url(),
          status: response.status(),
          redirectChain: redirectChain(response.request()),
          serviceWorkers: 'blocked',
          headers: Object.fromEntries(
            ['strict-transport-security', 'x-content-type-options', 'x-frame-options',
              'referrer-policy', 'permissions-policy', 'server', 'x-vercel-id',
              'cache-control', 'age', 'via'].map((name) => [name, headers[name] || null]),
          ),
        };
        console.log(`${label} production response diagnostics: ${JSON.stringify(headerDiagnostics)}`);

        const hsts = headers['strict-transport-security'] || '';
        const hstsMaxAge = hsts.match(/(?:^|;)\\s*max-age=(\\d+)/i);
        assert(
          hstsMaxAge
            && Number(hstsMaxAge[1]) >= 31536000
            && /(?:^|;)\\s*includeSubDomains(?:;|$)/i.test(hsts),
          `${label}: HSTS must set max-age of at least one year and includeSubDomains; response diagnostics logged above`,
        );
        assert.equal(headers['x-content-type-options'], 'nosniff', `${label}: nosniff header missing`);
        assert.equal(headers['x-frame-options'], 'DENY', `${label}: frame protection header missing`);
        assert.equal(headers['referrer-policy'], 'strict-origin-when-cross-origin', `${label}: referrer policy missing`);
        assert.match(headers['permissions-policy'] || '', /camera=\(self\)/, `${label}: camera permission policy missing`);

        // Flutter Web renderer internals vary by engine version. Inspect light DOM
        // and nested shadow roots rather than relying on one private tag selector.
        await page.waitForFunction(() => {
          const selectors = ['flutter-view', 'flt-glass-pane', 'flt-scene-host'];
          if (selectors.some((selector) => document.querySelector(selector))) return true;
          return Array.from(document.querySelectorAll('*')).some((element) =>
            element.shadowRoot && selectors.some((selector) => element.shadowRoot.querySelector(selector)));
        }, { timeout: 20000 }).catch(() => {});
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
        return page;
      } catch (error) {
        await context.close();
        throw error;
      }
    }

    const desktopPage = await verifyViewport(1440, 1000, 'Desktop');
    const mobilePage = await verifyViewport(390, 844, 'Mobile');

    const manifest = await mobilePage.request.get(new URL('manifest.json', `${baseUrl}/`).toString());
    assert.equal(manifest.status(), 200, 'PWA manifest did not return HTTP 200');
    const manifestJson = await manifest.json();
    assert.equal(manifestJson.short_name, 'ORVIKA', 'PWA manifest branding is missing');

    const favicon = await mobilePage.request.get(new URL('favicon.svg', `${baseUrl}/`).toString());
    assert.equal(favicon.status(), 200, 'ORVIKA favicon did not return HTTP 200');

    assert(criticalAssetResponses.some((item) => item.path.endsWith('/flutter_bootstrap.js') && item.status === 200), 'Flutter bootstrap asset did not load successfully');
    assert(criticalAssetResponses.some((item) => item.path.endsWith('/main.dart.js') && item.status === 200), 'Flutter application bundle did not load successfully');
    assert(criticalAssetResponses.some((item) => item.path.endsWith('/manifest.json') && item.status === 200), 'PWA manifest asset did not load successfully');
    assert(criticalAssetResponses.every((item) => item.status === 200), `Critical asset returned an error: ${JSON.stringify(criticalAssetResponses)}`);
    assert.deepEqual(pageErrors, [], `Browser runtime errors: ${pageErrors.join(' | ')}`);
    console.log(`Browser console errors (diagnostic): ${JSON.stringify(consoleErrors)}`);
    console.log('ORVIKA production browser smoke tests passed.');
    await desktopPage.context().close();
    await mobilePage.context().close();
  } finally {
    await browser.close();
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
