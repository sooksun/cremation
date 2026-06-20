/**
 * Offline verify contributory national ID alignment against ref1-2.pdf box layout.
 */
import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const webRoot = path.resolve(__dirname, '..');

const DIGIT_CENTERS = [223.3, 247.3, 259.3, 271.3, 283.3, 307.3, 319.3, 331.3, 343.3, 355.2, 379.1, 391.0, 415.0];
const Y_TOP = 236.9;
const ORD_GAPS = [24, 12, 12, 12, 24, 12, 12, 12, 12, 24, 12, 24];
const SIZE = 10;

async function extractBoxCenters(pdfPath, rowYTop) {
  const pdfjs = await import('pdfjs-dist/legacy/build/pdf.mjs');
  const data = new Uint8Array(await fs.readFile(pdfPath));
  const doc = await pdfjs.getDocument({ data, useSystemFonts: true }).promise;
  const page = await doc.getPage(1);
  const vh = page.getViewport({ scale: 1 }).height;
  const yPdf = vh - rowYTop;
  const ops = await page.getOperatorList();
  const xs = [];
  for (let i = 0; i < ops.fnArray.length; i++) {
    if (ops.fnArray[i] !== pdfjs.OPS.constructPath) continue;
    const p = ops.argsArray[i][1]?.[0];
    if (!p) continue;
    for (let j = 1; j < 40; j += 2) {
      if (p[j] == null || p[j + 1] == null) break;
      if (Math.abs(p[j + 1] - yPdf) < 2 && p[j] > 200 && p[j] < 430) xs.push(+p[j].toFixed(2));
    }
  }
  const uniq = [...new Set(xs)].sort((a, b) => a - b);
  const centers = [];
  for (let i = 0; i < uniq.length - 1; i++) {
    const w = uniq[i + 1] - uniq[i];
    if (w >= 9.5 && w <= 14.5) centers.push(Math.round(((uniq[i] + uniq[i + 1]) / 2) * 10) / 10);
  }
  return centers;
}

function pickByGapPattern(candidates) {
  let best = { err: Infinity, picked: [] };
  const go = (i, picked) => {
    if (picked.length === 13) {
      const gaps = picked.slice(1).map((v, j) => Math.round((v - picked[j]) * 10) / 10);
      let err = 0;
      for (let k = 0; k < 12; k++) err += Math.abs(gaps[k] - ORD_GAPS[k]);
      if (err < best.err) best = { err, picked: [...picked] };
      return;
    }
    for (; i < candidates.length; i++) {
      if (picked.length) {
        const g = candidates[i] - picked[picked.length - 1];
        if (Math.abs(g - ORD_GAPS[picked.length - 1]) > 2.5) continue;
      }
      picked.push(candidates[i]);
      go(i + 1, picked);
      picked.pop();
    }
  };
  go(0, []);
  return best;
}

async function main() {
  const templatePath = path.join(webRoot, 'public/doc/ref1-2.pdf');
  const boxCenters = await extractBoxCenters(templatePath, 243);
  const match = pickByGapPattern(boxCenters);

  console.log('Template box match err:', match.err.toFixed(1));
  console.log('Template centers:', match.picked.join(', '));
  console.log('Configured centers:', DIGIT_CENTERS.join(', '));

  let maxDelta = 0;
  for (let i = 0; i < 13; i++) {
    const d = Math.abs(DIGIT_CENTERS[i] - match.picked[i]);
    maxDelta = Math.max(maxDelta, d);
  }
  if (maxDelta > 1) {
    console.error(`FAIL: max center delta ${maxDelta} vs template boxes`);
    process.exit(1);
  }

  const { PDFDocument } = await import('pdf-lib');
  const fontkit = (await import('@pdf-lib/fontkit')).default;
  const pdfjs = await import('pdfjs-dist/legacy/build/pdf.mjs');

  const template = await fs.readFile(templatePath);
  const fontBytes = await fs.readFile(path.join(webRoot, 'public/fonts/Sarabun-Regular.ttf'));
  const pdfDoc = await PDFDocument.load(template);
  pdfDoc.registerFontkit(fontkit);
  const font = await pdfDoc.embedFont(fontBytes);
  const page = pdfDoc.getPages()[0];
  const y = page.getHeight() - Y_TOP + 2;
  const id = '1234567890123';

  [...id].forEach((digit, i) => {
    const cx = DIGIT_CENTERS[i];
    const w = font.widthOfTextAtSize(digit, SIZE);
    page.drawText(digit, { x: cx - w / 2, y, size: SIZE, font });
  });

  const out = path.join(webRoot, 'test-output/verify-contributory-id.pdf');
  await fs.mkdir(path.dirname(out), { recursive: true });
  const bytes = await pdfDoc.save();
  await fs.writeFile(out, bytes);

  const doc = await pdfjs.getDocument({ data: new Uint8Array(bytes), useSystemFonts: true }).promise;
  const p1 = await doc.getPage(1);
  const content = await p1.getTextContent();
  const vh = p1.getViewport({ scale: 1 }).height;
  const digits = content.items
    .filter((item) => 'str' in item && /^\d$/.test(item.str.trim()))
    .map((item) => ({
      text: item.str.trim(),
      center: item.transform[4] + item.width / 2,
      yTop: vh - item.transform[5],
    }))
    .filter((d) => Math.abs(d.yTop - Y_TOP) <= 8)
    .sort((a, b) => a.center - b.center);

  const renderOk =
    digits.length === 13 &&
    digits.map((d) => d.text).join('') === id &&
    digits.every((d, i) => Math.abs(d.center - DIGIT_CENTERS[i]) <= 2);

  console.log(renderOk ? 'PASS: rendered digits match configured centers' : 'FAIL: render check');
  console.log(`Output: ${out}`);
  if (!renderOk) process.exit(1);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});