import { chromium, firefox } from 'playwright';

const browserName = process.env.BROWSER ?? 'chromium';
const browserType = browserName === 'firefox' ? firefox : chromium;
const browser = await browserType.launch({ headless: true });
try {
  const page = await browser.newPage();
  page.on('pageerror', error => console.error('PAGE_ERROR:', error.message));
  page.on('console', message => {
    if (message.type() === 'error') console.error('BROWSER_CONSOLE:', message.text());
  });
  await page.goto('http://127.0.0.1:4173', { waitUntil: 'networkidle' });
  await page.waitForFunction(() =>
    document.body.innerText.includes('WXSCAN_STATUS:PASS') ||
    document.body.innerText.includes('WXSCAN_STATUS:FAIL'),
    null,
    { timeout: 90000 },
  );
  const status = await page.locator('body').innerText();
  console.log(status);
  if (!status.includes('WXSCAN_STATUS:PASS')) {
    throw new Error(`wxscan browser smoke failed in ${browserName}: ${status}`);
  }
} finally {
  await browser.close();
}
