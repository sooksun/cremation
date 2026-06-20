/**
 * Extract Thai national ID digit box centers from template PDFs (ref1-1 / ref1-2).
 * Usage: node scripts/extract-thai-id-centers.mjs
 */
import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const webRoot = path.resolve(__dirname, '..');

const THAI_ID_GAPS = [24, 12, 12, 12, 24, 12, 12, 12, 12, 24, 12, 24];

function extractVertices(page, vh, ops, pdfjs) {
  const verts = [];
  for (let i = 0; i < ops.fnArray.length; i++) {
    if (ops.fnArray[i] !== pdfjs.OPS.constructPath) continue;
    const p = ops.argsArray[i][1]?.[0];
    if (!p) continue;
    for (let j = 1; j < 40; j += 2) {
      if (p[j] == null || p[j + 1] == null) break;
      verts.push({ x: p[j], yTop: vh - p[j + 1] });
    }
  }
  return verts;
}

function boxCentersAtY(verts, yTop, tolerance = 2) {
  const row = verts.filter((v) => Math.abs(v.yTop - yTop) <= tolerance);
  const xs = [...new Set(row.map((v) => Math.round(v.x * 100) / 100))].sort((a, b) => a - b);
  const centers = [];
  for (let i = 0; i < xs.length - 1; i++) {
    const w = xs[i + 1] - xs[i];
    if (w >= 9.5 && w <= 14.5) {
      centers.push(Math.round(((xs[i] + xs[i + 1]) / 2) * 10) / 10);
    }
  }
  return centers;
}

function pickThaiIdCenters(candidates) {
  let best = { err: Infinity, picked: [] };
  const go = (i, picked) => {
    if (picked.length === 13) {
      const gaps = picked.slice(1).map((v, j) => Math.round((v - picked[j]) * 10) / 10);
      let err = 0;
      for (let k = 0; k < 12; k++) err += Math.abs(gaps[k] - THAI_ID_GAPS[k]);
      if (err < best.err) best = { err, picked: [...picked] };
      return;
    }
    for (; i < candidates.length; i++) {
      if (picked.length) {
        const g = candidates[i] - picked[picked.length - 1];
        if (Math.abs(g - THAI_ID_GAPS[picked.length - 1]) > 2.5) continue;
      }
      picked.push(candidates[i]);
      go(i + 1, picked);
      picked.pop();
    }
  };
  go(0, []);
  return best;
}

async function analyze(relPath) {
  const pdfjs = await import('pdfjs-dist/legacy/build/pdf.mjs');
  const data = new Uint8Array(await fs.readFile(path.join(webRoot, relPath)));
  const doc = await pdfjs.getDocument({ data, useSystemFonts: true }).promise;
  const page = await doc.getPage(1);
  const vh = page.getViewport({ scale: 1 }).height;
  const ops = await page.getOperatorList();
  const verts = extractVertices(page, vh, ops, pdfjs);

  const label = (await page.getTextContent()).items.find(
    (i) => 'str' in i && i.str.includes('เลขประจำตัวประชาชน'),
  );
  const labelYTop = label ? Math.round((vh - label.transform[5]) * 10) / 10 : null;

  let best = { err: Infinity, yTop: 0, picked: [] };
  for (let y = 228; y <= 252; y += 0.5) {
    const centers = boxCentersAtY(verts, y);
    const pick = pickThaiIdCenters(centers);
    if (pick.err < best.err) best = { err: pick.err, yTop: y, picked: pick.picked };
  }

  const textYTop = best.yTop ? Math.round((best.yTop - 6.1) * 10) / 10 : null;

  return { relPath, labelYTop, boxRowYTop: best.yTop, textYTop, err: best.err, digitCentersX: best.picked };
}

async function main() {
  for (const file of ['public/doc/ref1-1.pdf', 'public/doc/ref1-2.pdf']) {
    const r = await analyze(file);
    console.log(`\n=== ${file} ===`);
    console.log(`Label yTop: ${r.labelYTop}`);
    console.log(`Box row yTop: ${r.boxRowYTop} (match err ${r.err.toFixed(1)})`);
    console.log(`Suggested text yTop: ${r.textYTop}`);
    console.log(`digitCentersX: [${r.digitCentersX.join(', ')}]`);
  }
}

main().catch(console.error);