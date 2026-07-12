import { PDFDocument, type PDFPage, type PDFFont, rgb } from 'pdf-lib';
import fontkit from '@pdf-lib/fontkit';
import dayjs from 'dayjs';
import buddhistEra from 'dayjs/plugin/buddhistEra';
import {
  MEMBERSHIP_TYPE_CONFIG,
  type AddressFields,
  type Beneficiary,
  type MembershipRegisterForm,
  type MembershipType,
} from '@/lib/membership-register';

dayjs.extend(buddhistEra);

const DEFAULT_SIZE = 10;
const FONT_URL = '/fonts/Sarabun-Regular.ttf';
/** Fine-tune overlay: shift right +10pt, up +2pt (PDF user space) */
const OFFSET_X = 10;
const OFFSET_Y = 2;

const THAI_MONTHS = [
  'มกราคม',
  'กุมภาพันธ์',
  'มีนาคม',
  'เมษายน',
  'พฤษภาคม',
  'มิถุนายน',
  'กรกฎาคม',
  'สิงหาคม',
  'กันยายน',
  'ตุลาคม',
  'พฤศจิกายน',
  'ธันวาคม',
];

type PageIndex = 0 | 1;

interface FieldPos {
  page: PageIndex;
  x: number;
  y: number;
  size?: number;
  maxChars?: number;
}

interface AddressLine1Coords {
  yTop: number;
  houseNo: number;
  moo: number;
  road?: number;
  soi?: number;
  subdistrict: number;
}

interface AddressLine2Coords {
  yTop: number;
  district: number;
  province: number;
  zip: number;
  phone: number;
}

interface BeneficiaryFieldCoords {
  nameX: number;
  relationshipX: number;
  nationalIdX: number;
  houseX: number;
  mooX: number;
  roadX: number;
  soiX: number;
  subdistrictX: number;
  districtX: number;
  provinceX: number;
  zipX: number;
  phoneX: number;
  contactX: number;
  contactPhoneX: number;
  lineSpacing: number;
}

interface TemplateCoords {
  memberNo: { x: number; yTop: number };
  memberSince: { x: number; yTop: number };
  governmentAgency: { x: number; yTop: number };
  applicationDate: { day: number; month: number; year: number; yTop: number };
  fullName: { x: number; yTop: number };
  birthDate: { x: number; yTop: number };
  age: { x: number; yTop: number };
  nationalId: { x: number; yTop: number; digitCentersX?: number[] };
  registeredAddress1: AddressLine1Coords;
  registeredAddress2: AddressLine2Coords;
  maritalStatus: { yTop: number; singleX: number; marriedX: number; spouseX: number };
  contactAddress1: AddressLine1Coords;
  contactAddress2: AddressLine2Coords;
  bloodRelatives: { nameX: number; relationshipX: number; yTops: number[] };
  beneficiaries: { yTops: [number, number, number] };
  signature: { nameX: number; nameYTop: number; dateX: number; dateYTop: number };
}

const BENEFICIARY_FIELDS: BeneficiaryFieldCoords = {
  nameX: 118,
  relationshipX: 438.2,
  nationalIdX: 170.9,
  houseX: 441.5,
  mooX: 504.5,
  roadX: 103,
  soiX: 201.3,
  subdistrictX: 298.1,
  districtX: 424.9,
  provinceX: 95.6,
  zipX: 236.5,
  phoneX: 398.6,
  contactX: 176,
  contactPhoneX: 400.9,
  lineSpacing: 21,
};

const PLACEHOLDER_PATTERNS = [
  /^choose\b/i,
  /^select\b/i,
  /^เลือก/,
  /^please\b/i,
];

// Calibrated from /doc/ref1-1.pdf and /doc/ref1-2.pdf text positions (pdf.js)
const TEMPLATE_COORDS: Record<MembershipType, TemplateCoords> = {
  ordinary: {
    memberNo: { x: 328.2, yTop: 108.1 },
    memberSince: { x: 502.3, yTop: 108.1 },
    governmentAgency: { x: 436.9, yTop: 171 },
    applicationDate: { day: 364.2, month: 426.2, year: 514.7, yTop: 192 },
    fullName: { x: 132.6, yTop: 212.9 },
    birthDate: { x: 424, yTop: 212.9 },
    age: { x: 522.9, yTop: 212.9 },
    nationalId: {
      x: 191.4,
      yTop: 233.9,
      digitCentersX: [201.4, 225.5, 237.5, 249.5, 261.4, 285.4, 297.4, 309.4, 321.4, 333.3, 357.3, 369.2, 393.2],
    },
    registeredAddress1: {
      yTop: 265.4,
      houseNo: 200,
      moo: 258,
      road: 300,
      soi: 400,
      subdistrict: 486,
    },
    registeredAddress2: {
      yTop: 286.4,
      district: 95,
      province: 205,
      zip: 314,
      phone: 438,
    },
    maritalStatus: { yTop: 308.1, singleX: 108, marriedX: 178, spouseX: 317.1 },
    contactAddress1: {
      yTop: 371,
      houseNo: 215,
      moo: 270,
      road: 310,
      soi: 406,
      subdistrict: 490,
    },
    contactAddress2: {
      yTop: 392,
      district: 95,
      province: 205,
      zip: 314,
      phone: 410,
    },
    bloodRelatives: {
      nameX: 118,
      relationshipX: 438.2,
      yTops: [475.7, 496.7, 517.8, 538.6, 559.6, 580.6, 601.5],
    },
    beneficiaries: {
      yTops: [695.9, 76.8, 181.6],
    },
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
      // Calibrated from ref1-2.pdf vector boxes (yTop ~243, Thai ID 1-4-5-2-1 gaps)
      digitCentersX: [223.3, 247.3, 259.3, 271.3, 283.3, 307.3, 319.3, 331.3, 343.3, 355.2, 379.1, 391, 415],
    },
    registeredAddress1: {
      yTop: 264.5,
      houseNo: 184,
      moo: 258,
      road: 322,
      soi: 420,
      subdistrict: 510,
    },
    registeredAddress2: {
      yTop: 285.5,
      district: 105,
      province: 205,
      zip: 334,
      phone: 438,
    },
    maritalStatus: { yTop: 307.3, singleX: 108, marriedX: 178, spouseX: 317.1 },
    contactAddress1: {
      yTop: 370.1,
      houseNo: 215,
      moo: 280,
      road: 325,
      soi: 430,
      subdistrict: 510,
    },
    contactAddress2: {
      yTop: 391,
      district: 105,
      province: 205,
      zip: 334,
      phone: 410,
    },
    bloodRelatives: {
      nameX: 118,
      relationshipX: 438.2,
      yTops: [474.9, 495.9, 516.9, 537.8, 558.8, 579.8, 600.7],
    },
    beneficiaries: {
      yTops: [695, 76.8, 181.6],
    },
    signature: { nameX: 300.2, nameYTop: 328.4, dateX: 362, dateYTop: 349.4 },
  },
};

function toPdfY(page: PDFPage, yTop: number): number {
  return page.getHeight() - yTop + OFFSET_Y;
}

function sanitizeField(value: string | undefined): string {
  let text = (value ?? '').trim();
  if (!text) return '';
  if (PLACEHOLDER_PATTERNS.some((pattern) => pattern.test(text))) return '';
  // Browser autocomplete often appends Latin suffix e.g. "เชียงราย - Chiang Rai"
  text = text.replace(/\s*[-–—]\s*[A-Za-z].*$/, '').trim();
  return text;
}

function truncate(value: string | undefined, maxChars: number): string {
  const text = sanitizeField(value);
  if (!text) return '';
  if (text.length <= maxChars) return text;
  return `${text.slice(0, maxChars - 1)}…`;
}

function splitApplicationDate(iso: string | undefined) {
  if (!iso || !dayjs(iso).isValid()) {
    return { day: '', month: '', year: '' };
  }
  const date = dayjs(iso);
  return {
    day: String(date.date()),
    month: THAI_MONTHS[date.month()],
    year: String(date.year() + 543),
  };
}

function formatShortThaiDate(iso: string | undefined): string {
  if (!iso || !dayjs(iso).isValid()) return '';
  return dayjs(iso).format('D/M/BBBB');
}

function formatFullThaiDate(iso: string | undefined): string {
  if (!iso || !dayjs(iso).isValid()) return '';
  const date = dayjs(iso);
  return `${date.date()} ${THAI_MONTHS[date.month()]} ${date.year() + 543}`;
}

function drawText(
  page: PDFPage,
  font: PDFFont,
  text: string,
  pos: FieldPos,
) {
  const value = truncate(text, pos.maxChars ?? 80);
  if (!value) return;

  const size = pos.size ?? DEFAULT_SIZE;
  page.drawText(value, {
    x: pos.x + OFFSET_X,
    y: pos.y,
    size,
    font,
    color: rgb(0, 0, 0),
  });
}

function drawNationalId(
  page: PDFPage,
  font: PDFFont,
  value: string,
  coords: TemplateCoords['nationalId'],
) {
  const nationalId = sanitizeField(value).replace(/\D/g, '').slice(0, 13);
  if (!nationalId) return;

  const y = toPdfY(page, coords.yTop);
  if (!coords.digitCentersX) {
    drawText(page, font, nationalId, { page: 0, x: coords.x, y, maxChars: 13 });
    return;
  }

  [...nationalId].forEach((digit, index) => {
    const centerX = coords.digitCentersX?.[index];
    if (centerX == null) return;
    const width = font.widthOfTextAtSize(digit, DEFAULT_SIZE);
    page.drawText(digit, {
      x: centerX - width / 2,
      y,
      size: DEFAULT_SIZE,
      font,
      color: rgb(0, 0, 0),
    });
  });
}

function drawAddressLine1(
  page: PDFPage,
  font: PDFFont,
  addr: AddressFields,
  coords: AddressLine1Coords,
) {
  const y = toPdfY(page, coords.yTop);
  const fields: Array<{ key: keyof AddressFields; x?: number; maxChars: number }> = [
    { key: 'houseNo', x: coords.houseNo, maxChars: 14 },
    { key: 'moo', x: coords.moo, maxChars: 6 },
    { key: 'road', x: coords.road, maxChars: 18 },
    { key: 'soi', x: coords.soi, maxChars: 14 },
    { key: 'subdistrict', x: coords.subdistrict, maxChars: 16 },
  ];

  for (const field of fields) {
    if (field.x == null) continue;
    drawText(page, font, addr[field.key], { page: 0, x: field.x, y, maxChars: field.maxChars });
  }
}

function drawAddressLine2(
  page: PDFPage,
  font: PDFFont,
  addr: AddressFields,
  coords: AddressLine2Coords,
) {
  const y = toPdfY(page, coords.yTop);
  drawText(page, font, addr.district, { page: 0, x: coords.district, y, maxChars: 16 });
  drawText(page, font, addr.province, { page: 0, x: coords.province, y, maxChars: 12 });
  drawText(page, font, addr.zip, { page: 0, x: coords.zip, y, maxChars: 10 });
  drawText(page, font, addr.phone, { page: 0, x: coords.phone, y, maxChars: 12 });
}

function drawBloodRelative(
  page: PDFPage,
  font: PDFFont,
  pageIndex: PageIndex,
  yTop: number,
  name: string,
  relationship: string,
  coords: TemplateCoords['bloodRelatives'],
) {
  const y = toPdfY(page, yTop);
  drawText(page, font, name, { page: pageIndex, x: coords.nameX, y, maxChars: 34 });
  drawText(page, font, relationship, { page: pageIndex, x: coords.relationshipX, y, maxChars: 18 });
}

function drawBeneficiaryBlock(
  page: PDFPage,
  font: PDFFont,
  pageIndex: PageIndex,
  yTop: number,
  beneficiary: Beneficiary,
  fields: BeneficiaryFieldCoords = BENEFICIARY_FIELDS,
) {
  const { lineSpacing: gap } = fields;
  const yName = toPdfY(page, yTop);
  drawText(page, font, beneficiary.name, { page: pageIndex, x: fields.nameX, y: yName, maxChars: 34 });
  drawText(page, font, beneficiary.relationship, {
    page: pageIndex,
    x: fields.relationshipX,
    y: yName,
    maxChars: 18,
  });

  const yId = toPdfY(page, yTop + gap);
  drawText(page, font, beneficiary.nationalId, { page: pageIndex, x: fields.nationalIdX, y: yId, maxChars: 13 });
  drawText(page, font, beneficiary.houseNo, { page: pageIndex, x: fields.houseX, y: yId, maxChars: 10 });
  drawText(page, font, beneficiary.moo, { page: pageIndex, x: fields.mooX, y: yId, maxChars: 6 });

  const yRoad = toPdfY(page, yTop + gap * 2);
  drawText(page, font, beneficiary.road, { page: pageIndex, x: fields.roadX, y: yRoad, maxChars: 16 });
  drawText(page, font, beneficiary.soi, { page: pageIndex, x: fields.soiX, y: yRoad, maxChars: 12 });
  drawText(page, font, beneficiary.subdistrict, { page: pageIndex, x: fields.subdistrictX, y: yRoad, maxChars: 14 });
  drawText(page, font, beneficiary.district, { page: pageIndex, x: fields.districtX, y: yRoad, maxChars: 14 });

  const yProvince = toPdfY(page, yTop + gap * 3);
  drawText(page, font, beneficiary.province, { page: pageIndex, x: fields.provinceX, y: yProvince, maxChars: 12 });
  drawText(page, font, beneficiary.zip, { page: pageIndex, x: fields.zipX, y: yProvince, maxChars: 10 });
  drawText(page, font, beneficiary.phone, { page: pageIndex, x: fields.phoneX, y: yProvince, maxChars: 12 });

  const yContact = toPdfY(page, yTop + gap * 4);
  drawText(page, font, beneficiary.contactPerson, { page: pageIndex, x: fields.contactX, y: yContact, maxChars: 24 });
  drawText(page, font, beneficiary.contactPhone, { page: pageIndex, x: fields.contactPhoneX, y: yContact, maxChars: 12 });
}

function drawMaritalStatus(
  page: PDFPage,
  font: PDFFont,
  data: MembershipRegisterForm,
  coords: TemplateCoords['maritalStatus'],
) {
  const y = toPdfY(page, coords.yTop);
  if (data.maritalStatus === 'single') {
    drawText(page, font, '✓', { page: 0, x: coords.singleX, y, size: 11, maxChars: 1 });
  } else {
    drawText(page, font, '✓', { page: 0, x: coords.marriedX, y, size: 11, maxChars: 1 });
    drawText(page, font, data.spouseName, { page: 0, x: coords.spouseX, y, maxChars: 38 });
  }
}

async function loadAssets(templateUrl: string) {
  const [templateBytes, fontBytes] = await Promise.all([
    fetch(templateUrl).then((response) => {
      if (!response.ok) throw new Error('ไม่พบแบบฟอร์มต้นฉบับ');
      return response.arrayBuffer();
    }),
    fetch(FONT_URL).then((response) => {
      if (!response.ok) throw new Error('ไม่พบฟอนต์สำหรับ PDF');
      return response.arrayBuffer();
    }),
  ]);

  return { templateBytes, fontBytes };
}

function fillTemplate(pdfDoc: PDFDocument, font: PDFFont, data: MembershipRegisterForm) {
  const coords = TEMPLATE_COORDS[data.type];
  const pages = pdfDoc.getPages();
  const page1 = pages[0];
  const page2 = pages[1];

  drawText(page1, font, data.memberNo, {
    page: 0,
    x: coords.memberNo.x,
    y: toPdfY(page1, coords.memberNo.yTop),
    maxChars: 14,
  });
  drawText(page1, font, formatShortThaiDate(data.memberSince), {
    page: 0,
    x: coords.memberSince.x,
    y: toPdfY(page1, coords.memberSince.yTop),
    maxChars: 16,
  });

  drawText(page1, font, data.governmentAgency, {
    page: 0,
    x: coords.governmentAgency.x,
    y: toPdfY(page1, coords.governmentAgency.yTop),
    maxChars: 22,
  });

  const appDate = splitApplicationDate(data.applicationDate);
  const appY = toPdfY(page1, coords.applicationDate.yTop);
  drawText(page1, font, appDate.day, { page: 0, x: coords.applicationDate.day, y: appY, maxChars: 4 });
  drawText(page1, font, appDate.month, { page: 0, x: coords.applicationDate.month, y: appY, maxChars: 12 });
  drawText(page1, font, appDate.year, { page: 0, x: coords.applicationDate.year, y: appY, maxChars: 4 });

  drawText(page1, font, data.fullName, {
    page: 0,
    x: coords.fullName.x,
    y: toPdfY(page1, coords.fullName.yTop),
    maxChars: 30,
  });
  drawText(page1, font, formatShortThaiDate(data.birthDate), {
    page: 0,
    x: coords.birthDate.x,
    y: toPdfY(page1, coords.birthDate.yTop),
    maxChars: 14,
  });
  drawText(page1, font, data.age, {
    page: 0,
    x: coords.age.x,
    y: toPdfY(page1, coords.age.yTop),
    maxChars: 4,
  });

  drawNationalId(page1, font, data.nationalId, coords.nationalId);

  drawAddressLine1(page1, font, data.registeredAddress, coords.registeredAddress1);
  drawAddressLine2(page1, font, data.registeredAddress, coords.registeredAddress2);

  drawMaritalStatus(page1, font, data, coords.maritalStatus);

  drawAddressLine1(page1, font, data.contactAddress, coords.contactAddress1);
  drawAddressLine2(page1, font, data.contactAddress, coords.contactAddress2);

  data.bloodRelatives.forEach((relative, index) => {
    const yTop = coords.bloodRelatives.yTops[index];
    if (yTop == null) return;
    drawBloodRelative(page1, font, 0, yTop, relative.name, relative.relationship, coords.bloodRelatives);
  });

  const beneficiaries = data.beneficiaries;
  const [ben1Y, ben2Y, ben3Y] = coords.beneficiaries.yTops;
  drawBeneficiaryBlock(page1, font, 0, ben1Y, beneficiaries[0]);
  drawBeneficiaryBlock(page2, font, 1, ben2Y, beneficiaries[1]);
  drawBeneficiaryBlock(page2, font, 1, ben3Y, beneficiaries[2]);

  drawText(page2, font, data.applicantSignatureName, {
    page: 1,
    x: coords.signature.nameX,
    y: toPdfY(page2, coords.signature.nameYTop),
    maxChars: 40,
  });
  drawText(page2, font, formatFullThaiDate(data.applicantSignatureDate), {
    page: 1,
    x: coords.signature.dateX,
    y: toPdfY(page2, coords.signature.dateYTop),
    maxChars: 28,
  });
}

async function buildMembershipRegisterPdf(data: MembershipRegisterForm): Promise<Uint8Array> {
  const config = MEMBERSHIP_TYPE_CONFIG[data.type];
  const { templateBytes, fontBytes } = await loadAssets(config.blankPdf);

  const pdfDoc = await PDFDocument.load(templateBytes);
  pdfDoc.registerFontkit(fontkit);
  const font = await pdfDoc.embedFont(fontBytes);

  fillTemplate(pdfDoc, font, data);

  return pdfDoc.save();
}

export async function exportMembershipRegisterPdf(
  data: MembershipRegisterForm,
  filename: string,
): Promise<void> {
  const bytes = await buildMembershipRegisterPdf(data);
  const blob = new Blob([Uint8Array.from(bytes)], { type: 'application/pdf' });
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement('a');
  anchor.href = url;
  anchor.download = filename;
  anchor.click();
  URL.revokeObjectURL(url);
}

function printPdfBlob(blob: Blob): Promise<void> {
  const url = URL.createObjectURL(blob);

  const printViaHiddenIframe = () =>
    new Promise<void>((resolve, reject) => {
      const iframe = document.createElement('iframe');
      iframe.style.cssText = 'position:fixed;right:0;bottom:0;width:0;height:0;border:0;visibility:hidden';
      iframe.setAttribute('aria-hidden', 'true');

      let settled = false;
      const settle = (action: 'resolve' | 'reject', error?: unknown) => {
        if (settled) return;
        settled = true;
        window.clearTimeout(timeoutTimer);
        window.clearTimeout(fallbackTimer);
        URL.revokeObjectURL(url);
        iframe.remove();
        if (action === 'resolve') resolve();
        else reject(error);
      };

      const tryPrint = () => {
        if (settled) return;
        try {
          const frameWindow = iframe.contentWindow;
          if (!frameWindow) {
            settle('reject', new Error('ไม่สามารถเปิด PDF สำหรับพิมพ์ได้'));
            return;
          }
          frameWindow.focus();
          frameWindow.print();
          settle('resolve');
        } catch (error) {
          settle('reject', error);
        }
      };

      const timeoutTimer = window.setTimeout(() => {
        settle('reject', new Error('โหลด PDF สำหรับพิมพ์ไม่สำเร็จ'));
      }, 20_000);

      // PDF in iframe may not fire onload in some browsers — use delayed fallback too.
      const fallbackTimer = window.setTimeout(tryPrint, 1200);
      iframe.onload = () => window.setTimeout(tryPrint, 400);
      iframe.onerror = () => settle('reject', new Error('โหลด PDF สำหรับพิมพ์ไม่สำเร็จ'));

      iframe.src = url;
      document.body.appendChild(iframe);
    });

  const printWindow = window.open(url, '_blank');
  if (!printWindow) {
    return printViaHiddenIframe();
  }

  return new Promise<void>((resolve, reject) => {
    let settled = false;
    const settle = (action: 'resolve' | 'reject', error?: unknown) => {
      if (settled) return;
      settled = true;
      window.clearTimeout(fallbackTimer);
      window.clearTimeout(cleanupTimer);
      if (action === 'resolve') resolve();
      else reject(error);
    };

    const triggerPrint = () => {
      try {
        printWindow.focus();
        printWindow.print();
        settle('resolve');
      } catch (error) {
        printWindow.close();
        printViaHiddenIframe().then(() => settle('resolve')).catch((err) => settle('reject', err));
      }
    };

    printWindow.addEventListener('load', () => window.setTimeout(triggerPrint, 500));
    const fallbackTimer = window.setTimeout(triggerPrint, 1500);

    const cleanupTimer = window.setTimeout(() => {
      URL.revokeObjectURL(url);
    }, 120_000);
  });
}

export async function printMembershipRegisterPdf(data: MembershipRegisterForm): Promise<void> {
  const bytes = await buildMembershipRegisterPdf(data);
  const blob = new Blob([Uint8Array.from(bytes)], { type: 'application/pdf' });
  await printPdfBlob(blob);
}
