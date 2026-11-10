import { chromium, firefox } from 'playwright';

const browserName = process.env.BROWSER ?? 'chromium';
const browserType = browserName === 'firefox' ? firefox : chromium;
const browser = await browserType.launch({ headless: true });
try {
  // Pin a valid BCP-47 locale so runner host locale settings cannot leak
  // malformed values (for example en_US) into Flutter's Intl startup.
  const context = await browser.newContext({ locale: 'en-US' });
  const page = await context.newPage();
  page.on('pageerror', error => console.error('PAGE_ERROR:', error.message));
  page.on('requestfailed', request =>
    console.error('REQUEST_FAILED:', request.url(), request.failure()?.errorText),
  );
  page.on('response', response => {
    if (response.status() >= 400) {
      console.error('HTTP_ERROR:', response.status(), response.url());
    }
  });
  page.on('console', message => {
    if (message.type() === 'error') console.error('BROWSER_CONSOLE:', message.text());
  });
  await page.goto('http://127.0.0.1:4173', { waitUntil: 'networkidle' });
  try {
    await page.waitForFunction(() =>
      document.title.includes('WXSCAN_STATUS:PASS') ||
      document.title.includes('WXSCAN_STATUS:FAIL'),
      null,
      { timeout: 130000 },
    );
  } catch (error) {
    console.error('LAST_APP_TITLE:', await page.title());
    console.error('LAST_APP_BODY:', await page.locator('body').innerText());
    throw error;
  }
  const status = await page.title();
  console.log(status);
  if (!status.includes('WXSCAN_STATUS:PASS')) {
    throw new Error(`wxscan browser smoke failed in ${browserName}: ${status}`);
  }
} finally {
  await browser.close();
}
