/**
 * Extract rectangle-like paths from template PDF near national ID row.
 */
import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const webRoot = path.resolve(__dirname, '..');

async function extractRects(pdfPath, pageNum = 1) {
  const pdfjs = await import('pdfjs-dist/legacy/build/pdf.mjs');
  const data = new Uint8Array(await fs.readFile(pdfPath));
  const doc = await pdfjs.getDocument({ data, useSystemFonts: true }).promise;
  const page = await doc.getPage(pageNum);
  const viewport = page.getViewport({ scale: 1 });
  const ops = await page.getOperatorList();
  const { fnArray, argsArray } = ops;

  const rects = [];
  let currentTransform = [1, 0, 0, 1, 0, 0];

  const multiply = (m1, m2) => [
    m1[0] * m2[0] + m1[2] * m2[1],
    m1[1] * m2[0] + m1[3] * m2[1],
    m1[0] * m2[2] + m1[2] * m2[3],
    m1[1] * m2[2] + m1[3] * m2[3],
    m1[0] * m2[4] + m1[2] * m2[5] + m1[4],
    m1[1] * m2[4] + m1[3] * m2[5] + m1[5],
  ];

  for (let i = 0; i < fnArray.length; i++) {
    const fn = fnArray[i];
    const args = argsArray[i];

    if (fn === pdfjs.OPS.transform) {
      currentTransform = multiply(currentTransform, args);
    } else if (fn === pdfjs.OPS.constructPath) {
      const [opsList, coords] = args;
      let ci = 0;
      for (const op of opsList) {
        if (op === pdfjs.OPS.rectangle) {
          const w = coords[ci++];
          const h = coords[ci++];
          const x = coords[ci++];
          const y = coords[ci++];
          const tx = currentTransform;
          const px = tx[0] * x + tx[2] * y + tx[4];
          const py = tx[1] * x + tx[3] * y + tx[5];
          const pw = Math.abs(w * tx[0]);
          const ph = Math.abs(h * tx[3]);
          const yTop = viewport.height - py;
          rects.push({
            x: Math.round(px * 10) / 10,
            y: Math.round(py * 10) / 10,
            yTop: Math.round(yTop * 10) / 10,
            w: Math.round(pw * 10) / 10,
            h: Math.round(ph * 10) / 10,
            centerX: Math.round((px + pw / 2) * 10) / 10,
          });
        } else if (op === pdfjs.OPS.moveTo || op === pdfjs.OPS.lineTo) {
          ci += 2;
        } else if (op === pdfjs.OPS.curveTo) {
          ci += 6;
        } else if (op === pdfjs.OPS.closePath) {
          // no coords
        }
      }
    }
  }

  return { viewport, rects };
}

async function main() {
  for (const [name, rel] of [
    ['ordinary', 'public/doc/ref1-1.pdf'],
    ['contributory', 'public/doc/ref1-2.pdf'],
  ]) {
    const pdfPath = path.join(webRoot, rel);
    const { rects } = await extractRects(pdfPath);

    // ID digit boxes: small rectangles near yTop 220-250, width ~10-14
    const idBoxes = rects
      .filter((r) => r.yTop >= 220 && r.yTop <= 250 && r.w >= 8 && r.w <= 20 && r.h >= 8 && r.h <= 20)
      .sort((a, b) => a.x - b.x);

    console.log(`\n=== ${name} (${idBoxes.length} candidate boxes near ID row) ===`);
    for (const b of idBoxes) {
      console.log(`  x=${b.x} w=${b.w} h=${b.h} yTop=${b.yTop} centerX=${b.centerX}`);
    }

    if (idBoxes.length >= 13) {
      const centers = idBoxes.slice(0, 13).map((b) => b.centerX);
      console.log(`digitCentersX: [${centers.join(', ')}]`);
    }
  }
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});