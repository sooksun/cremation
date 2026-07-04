/**
 * Generate sample membership register PDFs and verify text positions.
 * Usage: node scripts/test-membership-register-pdf.mjs
 * Requires: dev server on http://localhost:3000 (or set WEB_BASE_URL)
 */
import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { createRequire } from 'node:module';

const require = createRequire(import.meta.url);
const __dirname = path.dirname(fileURLToPath(import.meta.url));
const webRoot = path.resolve(__dirname, '..');
const outDir = path.join(webRoot, 'test-output');

const WEB_BASE = process.env.WEB_BASE_URL ?? 'http://localhost:3000';

const OFFSET_X = 10;
const OFFSET_Y = 2;
const DEFAULT_SIZE = 10;
const FONT_REL = '/fonts/Sarabun-Regular.ttf';

const THAI_MONTHS = [
  'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
  'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม',
];

const BENEFICIARY_FIELDS = {
  nameX: 118, relationshipX: 438.2, nationalIdX: 170.9, houseX: 441.5, mooX: 504.5,
  roadX: 103, soiX: 201.3, subdistrictX: 298.1, districtX: 424.9, provinceX: 95.6,
  zipX: 256.5, phoneX: 398.6, contactX: 176, contactPhoneX: 400.9, lineSpacing: 21,
};

const TEMPLATE_COORDS = {
  ordinary: {
    memberNo: { x: 328.2, yTop: 108.1 },
    memberSince: { x: 502.3, yTop: 108.1 },
    governmentAgency: { x: 436.9, yTop: 171 },
    applicationDate: { day: 364.2, month: 426.2, year: 514.7, yTop: 192 },
    fullName: { x: 131.6, yTop: 212.9 },
    birthDate: { x: 424, yTop: 212.9 },
    age: { x: 522.9, yTop: 212.9 },
    nationalId: {
      x: 191.4,
      yTop: 233.9,
      digitCentersX: [201.4, 225.5, 237.5, 249.5, 261.4, 285.4, 297.4, 309.4, 321.4, 333.3, 357.3, 369.2, 393.2],
    },
    registeredAddress1: { yTop: 265.4, houseNo: 160, moo: 236.5, road: 283.1, soi: 396.3, subdistrict: 481.9 },
    registeredAddress2: { yTop: 286.4, district: 82.2, province: 182.3, zip: 296.2, phone: 402.9 },
    maritalStatus: { yTop: 308.1, singleX: 108, marriedX: 178, spouseX: 317.1 },
    contactAddress1: { yTop: 371, houseNo: 183.2, moo: 254.3, road: 296.4, soi: 403.2, subdistrict: 483 },
    contactAddress2: { yTop: 392, district: 82.2, province: 177.9, zip: 296.2, phone: 373.8 },
    bloodRelatives: { nameX: 118, relationshipX: 438.2, yTops: [475.7, 496.7, 517.8, 538.6, 559.6, 580.6, 601.5] },
    beneficiaries: { yTops: [695.9, 76.8, 181.6] },
    signature: { nameX: 300.2, nameYTop: 328.4, dateX: 362, dateYTop: 349.4 },
  },
  contributory: {
    memberNo: { x: 328.2, yTop: 107.3 },
    memberSince: { x: 502.3, yTop: 107.3 },
    governmentAgency: { x: 436.9, yTop: 170.2 },
    applicationDate: { day: 364.2, month: 426.2, year: 514.7, yTop: 191.2 },
    fullName: { x: 131.6, yTop: 212.1 },
    birthDate: { x: 424, yTop: 212.1 },
    age: { x: 522.9, yTop: 212.1 },
    nationalId: {
      x: 223.3,
      yTop: 236.9,
      digitCentersX: [223.3, 247.3, 259.3, 271.3, 283.3, 307.3, 319.3, 331.3, 343.3, 355.2, 379.1, 391, 415],
    },
    registeredAddress1: { yTop: 264.5, houseNo: 160, moo: 236.5, road: 283.1, soi: 396.3, subdistrict: 481.9 },
    registeredAddress2: { yTop: 285.5, district: 83.4, province: 185.5, zip: 307, phone: 412.9 },
    maritalStatus: { yTop: 307.3, singleX: 108, marriedX: 178, spouseX: 317.1 },
    contactAddress1: { yTop: 370.1, houseNo: 182.6, moo: 253.5, road: 295.3, soi: 399.9, subdistrict: 480.2 },
    contactAddress2: { yTop: 391, district: 82.2, province: 177.9, zip: 296.2, phone: 373.8 },
    bloodRelatives: { nameX: 118, relationshipX: 438.2, yTops: [474.9, 495.9, 516.9, 537.8, 558.8, 579.8, 600.7] },
    beneficiaries: { yTops: [695, 76.8, 181.6] },
    signature: { nameX: 300.2, nameYTop: 328.4, dateX: 362, dateYTop: 349.4 },
  },
};

const TEMPLATES = {
  ordinary: '/doc/ref1-1.pdf',
  contributory: '/doc/ref1-2.pdf',
};

function sampleForm(type) {
  // Worst-case: real-world rural addresses often repeat the same long village name across
  // road/soi/subdistrict/district (e.g. "บ้านพญาไพร") — this is what overlapped before the fix.
  const addr = (suffix) => ({
    houseNo: `222`,
    moo: `${suffix}`,
    road: `บ้านพญาไพร`,
    soi: `บ้านพญาไพร`,
    subdistrict: `บ้านพญาไพร`,
    district: `บ้านพญาไพร`,
    province: 'เชียงราย',
    zip: `56779${suffix}`,
    phone: `081234567${suffix}`,
  });

  return {
    type,
    memberNo: 'CR-2568-001',
    memberSince: '2024-05-15',
    governmentAgency: 'โรงเรียนทดสอบอนุบาลเชียงราย',
    applicationDate: '2025-06-19',
    fullName: 'นายทดสอบ ระบบสมัครสมาชิก',
    birthDate: '1985-03-20',
    age: '40',
    nationalId: '1234567890123',
    registeredAddress: addr('1'),
    maritalStatus: 'married',
    spouseName: 'นางสาวคู่สมรส ทดสอบ',
    contactAddress: addr('2'),
    bloodRelatives: [
      { name: 'นายญาติหนึ่ง ทดสอบ', relationship: 'บิดา' },
      { name: 'นางญาติสอง ทดสอบ', relationship: 'มารดา' },
      { name: 'นายญาติสาม ทดสอบ', relationship: 'พี่ชาย' },
      { name: 'นางญาติสี่ ทดสอบ', relationship: 'น้องสาว' },
      { name: 'นายญาติห้า ทดสอบ', relationship: 'ลุง' },
      { name: 'นางญาติหก ทดสอบ', relationship: 'ป้า' },
      { name: 'นายญาติเจ็ด ทดสอบ', relationship: 'ลูกเขย' },
    ],
    beneficiaries: [1, 2, 3].map((n) => ({
      name: `นายผู้รับผลประโยชน์คนที่ ${n}`,
      relationship: n === 1 ? 'คู่สมรส' : n === 2 ? 'บุตร' : 'บิดา',
      nationalId: `987654321012${n}`,
      houseNo: `88/${n}`,
      moo: `${n}`,
      road: `ถนนผู้รับ${n}`,
      soi: `ซอยผู้รับ${n}`,
      subdistrict: `ต.ผู้รับ${n}`,
      district: 'อ.เมือง',
      province: 'เชียงราย',
      zip: `5710${n}`,
      phone: `089876543${n}`,
      contactPerson: `ผู้ติดต่อคนที่ ${n}`,
      contactPhone: `082345678${n}`,
    })),
    applicantSignatureName: 'นายทดสอบ ระบบสมัครสมาชิก',
    applicantSignatureDate: '2025-06-19',
  };
}

function toPdfY(page, yTop) {
  return page.getHeight() - yTop + OFFSET_Y;
}

function splitApplicationDate(iso) {
  const [y, m, d] = iso.split('-').map(Number);
  return { day: String(d), month: THAI_MONTHS[m - 1], year: String(y + 543) };
}

function formatShortThaiDate(iso) {
  const [y, m, d] = iso.split('-').map(Number);
  return `${d}/${m}/${y + 543}`;
}

function formatFullThaiDate(iso) {
  const [y, m, d] = iso.split('-').map(Number);
  return `${d} ${THAI_MONTHS[m - 1]} ${y + 543}`;
}

function truncate(text, maxChars) {
  if (!text) return '';
  if (!maxChars || text.length <= maxChars) return text;
  return `${text.slice(0, maxChars - 1)}…`;
}

function drawText(page, font, text, pos) {
  const value = truncate(text, pos.maxChars);
  if (!value) return;
  const size = pos.size ?? DEFAULT_SIZE;
  page.drawText(value, {
    x: pos.x + OFFSET_X,
    y: pos.y,
    size,
    font,
  });
}

async function buildPdf(data) {
  const { PDFDocument } = await import('pdf-lib');
  const fontkit = (await import('@pdf-lib/fontkit')).default;

  const templateUrl = `${WEB_BASE}${TEMPLATES[data.type]}`;
  const [templateRes, fontRes] = await Promise.all([
    fetch(templateUrl),
    fetch(`${WEB_BASE}${FONT_REL}`),
  ]);
  if (!templateRes.ok) throw new Error(`Template fetch failed: ${templateUrl}`);
  if (!fontRes.ok) throw new Error(`Font fetch failed`);

  const pdfDoc = await PDFDocument.load(await templateRes.arrayBuffer());
  pdfDoc.registerFontkit(fontkit);
  const font = await pdfDoc.embedFont(await fontRes.arrayBuffer());
  const coords = TEMPLATE_COORDS[data.type];
  const [page1, page2] = pdfDoc.getPages();

  const appDate = splitApplicationDate(data.applicationDate);
  const appY = toPdfY(page1, coords.applicationDate.yTop);

  drawText(page1, font, data.memberNo, { x: coords.memberNo.x, y: toPdfY(page1, coords.memberNo.yTop) });
  drawText(page1, font, formatShortThaiDate(data.memberSince), { x: coords.memberSince.x, y: toPdfY(page1, coords.memberSince.yTop) });
  drawText(page1, font, data.governmentAgency, { x: coords.governmentAgency.x, y: toPdfY(page1, coords.governmentAgency.yTop) });
  drawText(page1, font, appDate.day, { x: coords.applicationDate.day, y: appY });
  drawText(page1, font, appDate.month, { x: coords.applicationDate.month, y: appY });
  drawText(page1, font, appDate.year, { x: coords.applicationDate.year, y: appY });
  drawText(page1, font, data.fullName, { x: coords.fullName.x, y: toPdfY(page1, coords.fullName.yTop) });
  drawText(page1, font, formatShortThaiDate(data.birthDate), { x: coords.birthDate.x, y: toPdfY(page1, coords.birthDate.yTop) });
  drawText(page1, font, data.age, { x: coords.age.x, y: toPdfY(page1, coords.age.yTop) });
  const nationalId = data.nationalId.replace(/\D/g, '').slice(0, 13);
  if (coords.nationalId.digitCentersX) {
    [...nationalId].forEach((digit, index) => {
      const centerX = coords.nationalId.digitCentersX[index];
      if (centerX == null) return;
      page1.drawText(digit, {
        x: centerX - font.widthOfTextAtSize(digit, DEFAULT_SIZE) / 2,
        y: toPdfY(page1, coords.nationalId.yTop),
        size: DEFAULT_SIZE,
        font,
      });
    });
  } else {
    drawText(page1, font, nationalId, { x: coords.nationalId.x, y: toPdfY(page1, coords.nationalId.yTop) });
  }

  const drawAddr1 = (page, addr, c) => {
    const y = toPdfY(page, c.yTop);
    drawText(page, font, addr.houseNo, { x: c.houseNo, y, maxChars: 6 });
    drawText(page, font, addr.moo, { x: c.moo, y, maxChars: 4 });
    if (c.road) drawText(page, font, addr.road, { x: c.road, y, maxChars: 13 });
    if (c.soi) drawText(page, font, addr.soi, { x: c.soi, y, maxChars: 9 });
    drawText(page, font, addr.subdistrict, { x: c.subdistrict, y, maxChars: 8 });
  };
  const drawAddr2 = (page, addr, c) => {
    const y = toPdfY(page, c.yTop);
    drawText(page, font, addr.district, { x: c.district, y, maxChars: 10 });
    drawText(page, font, addr.province, { x: c.province, y, maxChars: 10 });
    drawText(page, font, addr.zip, { x: c.zip, y, maxChars: 8 });
    drawText(page, font, addr.phone, { x: c.phone, y, maxChars: 12 });
  };

  drawAddr1(page1, data.registeredAddress, coords.registeredAddress1);
  drawAddr2(page1, data.registeredAddress, coords.registeredAddress2);

  const maritalY = toPdfY(page1, coords.maritalStatus.yTop);
  drawText(page1, font, '✓', { x: coords.maritalStatus.marriedX, y: maritalY, size: 11 });
  drawText(page1, font, data.spouseName, { x: coords.maritalStatus.spouseX, y: maritalY });

  drawAddr1(page1, data.contactAddress, coords.contactAddress1);
  drawAddr2(page1, data.contactAddress, coords.contactAddress2);

  data.bloodRelatives.forEach((rel, i) => {
    const yTop = coords.bloodRelatives.yTops[i];
    if (yTop == null) return;
    const y = toPdfY(page1, yTop);
    drawText(page1, font, rel.name, { x: coords.bloodRelatives.nameX, y });
    drawText(page1, font, rel.relationship, { x: coords.bloodRelatives.relationshipX, y });
  });

  const drawBen = (page, yTop, b) => {
    const f = BENEFICIARY_FIELDS;
    const gap = f.lineSpacing;
    drawText(page, font, b.name, { x: f.nameX, y: toPdfY(page, yTop) });
    drawText(page, font, b.relationship, { x: f.relationshipX, y: toPdfY(page, yTop) });
    drawText(page, font, b.nationalId, { x: f.nationalIdX, y: toPdfY(page, yTop + gap) });
    drawText(page, font, b.houseNo, { x: f.houseX, y: toPdfY(page, yTop + gap) });
    drawText(page, font, b.moo, { x: f.mooX, y: toPdfY(page, yTop + gap) });
    drawText(page, font, b.road, { x: f.roadX, y: toPdfY(page, yTop + gap * 2) });
    drawText(page, font, b.soi, { x: f.soiX, y: toPdfY(page, yTop + gap * 2) });
    drawText(page, font, b.subdistrict, { x: f.subdistrictX, y: toPdfY(page, yTop + gap * 2) });
    drawText(page, font, b.district, { x: f.districtX, y: toPdfY(page, yTop + gap * 2) });
    drawText(page, font, b.province, { x: f.provinceX, y: toPdfY(page, yTop + gap * 3) });
    drawText(page, font, b.zip, { x: f.zipX, y: toPdfY(page, yTop + gap * 3) });
    drawText(page, font, b.phone, { x: f.phoneX, y: toPdfY(page, yTop + gap * 3) });
    drawText(page, font, b.contactPerson, { x: f.contactX, y: toPdfY(page, yTop + gap * 4) });
    drawText(page, font, b.contactPhone, { x: f.contactPhoneX, y: toPdfY(page, yTop + gap * 4) });
  };

  const [ben1Y, ben2Y, ben3Y] = coords.beneficiaries.yTops;
  drawBen(page1, ben1Y, data.beneficiaries[0]);
  drawBen(page2, ben2Y, data.beneficiaries[1]);
  drawBen(page2, ben3Y, data.beneficiaries[2]);

  drawText(page2, font, data.applicantSignatureName, { x: coords.signature.nameX, y: toPdfY(page2, coords.signature.nameYTop) });
  drawText(page2, font, formatFullThaiDate(data.applicantSignatureDate), { x: coords.signature.dateX, y: toPdfY(page2, coords.signature.dateYTop) });

  return pdfDoc.save();
}

async function extractTextPositions(pdfPath) {
  const pdfjs = await import('pdfjs-dist/legacy/build/pdf.mjs');
  const data = new Uint8Array(await fs.readFile(pdfPath));
  const doc = await pdfjs.getDocument({ data, useSystemFonts: true }).promise;
  const items = [];

  for (let p = 1; p <= doc.numPages; p++) {
    const page = await doc.getPage(p);
    const content = await page.getTextContent();
    const viewport = page.getViewport({ scale: 1 });
    for (const item of content.items) {
      if (!('str' in item) || !item.str.trim()) continue;
      const tx = item.transform;
      const x = tx[4];
      const yTop = viewport.height - tx[5];
      items.push({ page: p, text: item.str.trim(), x: Math.round(x * 10) / 10, yTop: Math.round(yTop * 10) / 10, width: item.width });
    }
  }
  return items;
}

function checkField(label, expected, actual, tolerance = 8) {
  if (!actual) return { label, ok: false, note: 'ไม่พบข้อความใน PDF' };
  const dx = Math.abs(actual.x - (expected.x + OFFSET_X));
  const dy = Math.abs(actual.yTop - expected.yTop);
  const ok = dx <= tolerance && dy <= tolerance;
  return {
    label,
    ok,
    expected: { x: expected.x + OFFSET_X, yTop: expected.yTop },
    actual: { x: actual.x, yTop: actual.yTop },
    delta: { dx: Math.round(dx * 10) / 10, dy: Math.round(dy * 10) / 10 },
  };
}

async function verifyPdf(type, pdfPath) {
  const coords = TEMPLATE_COORDS[type];
  const items = await extractTextPositions(pdfPath);

  const find = (needle) => items.find((i) => i.text.includes(needle));

  let nationalIdCheck;
  if (coords.nationalId.digitCentersX) {
    const digits = items
      .filter((item) => item.page === 1 && /^\d$/.test(item.text) && Math.abs(item.yTop - coords.nationalId.yTop) <= 8)
      .sort((a, b) => a.x - b.x);
    const valueMatches = digits.map((item) => item.text).join('') === '1234567890123';
    const positionsMatch = digits.length === 13 && digits.every((item, index) => {
      const actualCenter = item.x + item.width / 2;
      return Math.abs(actualCenter - coords.nationalId.digitCentersX[index]) <= 2;
    });
    nationalIdCheck = {
      label: 'เลขบัตร',
      ok: valueMatches && positionsMatch,
      note: valueMatches && positionsMatch ? 'ครบ 13 หลักและอยู่กึ่งกลางทุกช่อง' : 'เลขหรือพิกัดรายช่องไม่ถูกต้อง',
    };
  } else {
    nationalIdCheck = checkField('เลขบัตร', { x: coords.nationalId.x, yTop: coords.nationalId.yTop }, find('1234567890123'));
  }

  const checks = [
    checkField('เลขสมาชิก', { x: coords.memberNo.x, yTop: coords.memberNo.yTop }, find('CR-2568')),
    checkField('ชื่อ-สกุล', { x: coords.fullName.x, yTop: coords.fullName.yTop }, find('นายทดสอบ')),
    nationalIdCheck,
    checkField('หน่วยงาน', { x: coords.governmentAgency.x, yTop: coords.governmentAgency.yTop }, find('โรงเรียนทดสอบ')),
    checkField('คู่สมรส', { x: coords.maritalStatus.spouseX, yTop: coords.maritalStatus.yTop }, find('นางสาวคู่สมรส')),
    // The embedded Thai font maps the tone mark in "ที่" inconsistently in pdf.js.
    checkField('ผู้รับผลประโยชน์ 1', { x: BENEFICIARY_FIELDS.nameX, yTop: coords.beneficiaries.yTops[0] }, find('นายผู้รับผลประโยชน์คนที')),
    checkField('ลายเซ็น', { x: coords.signature.nameX, yTop: coords.signature.nameYTop }, items.filter((i) => i.page === 2 && i.text.includes('นายทดสอบ')).pop()),
  ];

  return checks;
}

async function main() {
  await fs.mkdir(outDir, { recursive: true });

  const health = await fetch(`${WEB_BASE}/login`).catch(() => null);
  if (!health?.ok) {
    console.error(`Web server not reachable at ${WEB_BASE}. Run: pnpm dev`);
    process.exit(1);
  }

  const report = [];

  for (const type of ['ordinary', 'contributory']) {
    const data = sampleForm(type);
    const bytes = await buildPdf(data);
    const filename = `test-ใบสมัคร-${type === 'ordinary' ? 'สามัญ' : 'สมทบ'}.pdf`;
    const outPath = path.join(outDir, filename);
    await fs.writeFile(outPath, bytes);

    let checks = [];
    try {
      checks = await verifyPdf(type, outPath);
    } catch (err) {
      checks = [{ label: 'verify', ok: false, note: `ตรวจตำแหน่งไม่ได้: ${err.message}` }];
    }

    report.push({ type, outPath, checks });
    console.log(`\n=== ${type === 'ordinary' ? 'สมาชิกสามัญ' : 'สมาชิกสมทบ'} ===`);
    console.log(`PDF: ${outPath}`);
    for (const c of checks) {
      if (c.ok) {
        console.log(`  ✓ ${c.label}`);
      } else {
        console.log(`  ✗ ${c.label}: ${c.note ?? `dx=${c.delta?.dx}, dy=${c.delta?.dy} (expected x=${c.expected?.x}, yTop=${c.expected?.yTop} got x=${c.actual?.x}, yTop=${c.actual?.yTop})`}`);
      }
    }
  }

  const failed = report.flatMap((r) => r.checks).filter((c) => !c.ok);
  const summaryPath = path.join(outDir, 'position-report.json');
  await fs.writeFile(summaryPath, JSON.stringify(report, null, 2));
  console.log(`\nรายงาน: ${summaryPath}`);
  console.log(failed.length === 0 ? '\nผลทดสอบ: ผ่านทุกฟิลด์หลัก' : `\nผลทดสอบ: พบ ${failed.length} จุดที่ต้องตรวจสอบด้วยตา`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
