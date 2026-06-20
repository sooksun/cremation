/**
 * E2E: fill /register form in browser and download PDF.
 * Usage: node scripts/e2e-register-pdf.mjs
 */
import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const outDir = path.join(__dirname, '..', 'test-output');
const BASE = process.env.WEB_BASE_URL ?? 'http://localhost:3000';

async function main() {
  const { chromium } = await import('playwright');
  await fs.mkdir(outDir, { recursive: true });

  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({ acceptDownloads: true });
  const page = await context.newPage();

  await page.route('**/api/member-applications/submit', async (route) => {
    await route.fulfill({
      status: 201,
      contentType: 'application/json',
      body: JSON.stringify({ message: 'ส่งใบสมัครสำเร็จ (ทดสอบ)', memberNo: 'E2E-TEST-001' }),
    });
  });

  await page.goto(`${BASE}/register?type=ordinary`, { waitUntil: 'networkidle' });

  await page.locator('input[name="governmentAgency"]').fill('โรงเรียนบ้านพญาไพร');
  await page.locator('input[name="memberNo"]').fill('E2E-2568-99');
  await page.locator('input[name="fullName"]').fill('นาย E2E ทดสอบระบบ');
  await page.locator('input[name="nationalId"]').fill('9998887776665');
  await page.locator('input[name="registeredAddress.houseNo"]').fill('123');
  await page.locator('input[name="registeredAddress.moo"]').fill('4');
  await page.locator('input[name="registeredAddress.subdistrict"]').fill('รอบเวียง');
  await page.locator('input[name="registeredAddress.district"]').fill('เมือง');
  await page.locator('input[name="registeredAddress.zip"]').fill('57000');

  const [download] = await Promise.all([
    page.waitForEvent('download', { timeout: 30_000 }),
    page.getByRole('button', { name: 'ส่งใบสมัครและดาวน์โหลด PDF' }).click(),
  ]);

  const savePath = path.join(outDir, 'e2e-browser-ใบสมัคร-สามัญ.pdf');
  await download.saveAs(savePath);

  const stat = await fs.stat(savePath);
  console.log(`E2E PDF saved: ${savePath} (${stat.size} bytes)`);

  await browser.close();
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});