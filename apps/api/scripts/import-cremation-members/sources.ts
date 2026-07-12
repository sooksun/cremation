import * as path from 'path';
import * as XLSX from 'xlsx';
import { normalizeIdCard, nameKey } from './name-utils';

export const DOC_DIR = path.join(__dirname, '../../../../doc/member');

const F1 = path.join(DOC_DIR, '2.ฌาปนกิจ มฟล.xls');
const F2 = path.join(DOC_DIR, 'new_teacher_in_saocr3.xls');
const F3 = path.join(DOC_DIR, 'new_ข้อมูลครู อ.แม่ฟ้าหลวง.xls');
const F4 = path.join(DOC_DIR, 'member_data.xlsx');

export interface F2Info { type: 'ขรก' | 'ลจ.'; acc: string; branch: string; remark: string }
export interface F4Info { position: string; phone: string; sheet: string }
export interface SourceData {
  f1: { idCard: string; rawName: string }[];
  f2ById: Map<string, F2Info>;
  f3IdToCode: Map<string, string>;
  f3IdToName: Map<string, string>;
  f4NameToInfo: Map<string, F4Info>;
  f4SheetToTitle: Map<string, string>;
  f4SheetNames: string[];
}

function cell(v: unknown): string {
  if (v === null || v === undefined) return '';
  const s = String(v).trim();
  return s === 'nan' ? '' : s;
}

/** อ่าน sheet เป็น array-of-arrays (raw, ไม่ใช้ header) */
function rows(file: string, sheet: string): unknown[][] {
  const wb = XLSX.readFile(file, { codepage: 65001 });
  const ws = wb.Sheets[sheet];
  return XLSX.utils.sheet_to_json(ws, { header: 1, raw: false, defval: '' }) as unknown[][];
}
function sheetNames(file: string): string[] {
  return XLSX.readFile(file, { bookSheets: true }).SheetNames;
}

export function readAllSources(): SourceData {
  // --- F1 ฌาปนกิจ: header row 0 = person_id|name|money ---
  const f1rows = rows(F1, 'Sheet1');
  const f1: { idCard: string; rawName: string }[] = [];
  for (let i = 1; i < f1rows.length; i++) {
    const r = f1rows[i];
    // money แสดงเป็น "100.00" (raw:false) — เทียบเชิงตัวเลข, ตัด total row (60300) ออก
    if (parseFloat(cell(r[2])) !== 100) continue;
    const id = normalizeIdCard(r[0]);
    if (!id) continue;
    f1.push({ idCard: id, rawName: cell(r[1]) });
  }

  // --- F2 saocr3: 2 sheets, header row 0 ---
  const f2ById = new Map<string, F2Info>();
  for (const sh of ['ขรก', 'ลจ.'] as const) {
    const rr = rows(F2, sh);
    for (let i = 1; i < rr.length; i++) {
      const r = rr[i];
      const id = normalizeIdCard(r[0]);
      if (!id) continue;
      f2ById.set(id, { type: sh, acc: cell(r[2]), branch: cell(r[3]), remark: cell(r[4]) });
    }
  }

  // --- F3 แม่ฟ้าหลวง: sheet 0, ไม่มี header ---
  const f3Sheet = sheetNames(F3)[0];
  const f3rows = rows(F3, f3Sheet);
  const f3IdToCode = new Map<string, string>();
  const f3IdToName = new Map<string, string>();
  for (const r of f3rows) {
    const id = normalizeIdCard(r[0]);
    if (!id) continue;
    f3IdToCode.set(id, cell(r[2]));
    f3IdToName.set(id, cell(r[1]));
  }

  // --- F4 member_data: 31 sheets ---
  const f4SheetNames = sheetNames(F4);
  const f4NameToInfo = new Map<string, F4Info>();
  const f4SheetToTitle = new Map<string, string>();
  for (const sh of f4SheetNames) {
    const rr = rows(F4, sh);
    f4SheetToTitle.set(sh.trim(), rr.length > 1 ? cell(rr[1][0]) : '');
    for (const r of rr) {
      const c0 = cell(r[0]);
      const c1 = cell(r[1]);
      if (!/^\d+$/.test(c0) || !c1) continue; // แถวข้อมูล: col0 เป็นลำดับตัวเลข
      const k = nameKey(c1);
      if (!k || f4NameToInfo.has(k)) continue;
      // ตำแหน่ง/เบอร์: บาง sheet มีคอลัมน์เกิน (ชื่อแยก 2 ช่อง) — เก็บ 2 คอลัมน์ท้ายแบบ heuristic
      const position = cell(r[2]);
      const phone = cell(r[3]) || cell(r[r.length - 1]);
      f4NameToInfo.set(k, { position, phone, sheet: sh.trim() });
    }
  }

  return { f1, f2ById, f3IdToCode, f3IdToName, f4NameToInfo, f4SheetToTitle, f4SheetNames };
}
