import { PrismaClient } from '@prisma/client';
import { nameKey } from './name-utils';
import type { SourceData } from './sources';

/** override สำหรับ 2 รหัสที่ auto-match ไม่ได้ (F4 sheet บ้านกลางแยกชื่อ 2 คอลัมน์) */
const HARDCODE_CODE_TO_SCHOOLNAME: Record<string, string> = {
  '410': 'ห้วยอื้น',
  '417': 'บ้านกลาง',
};

export function schoolNameKey(raw: string): string {
  let s = String(raw ?? '');
  s = s.replace(/โรงเรียน/g, '').replace(/รร\./g, '');
  s = s.replace(/[()（）.\s]/g, '');
  return s;
}

export async function ensureUnknownSchool(prisma: PrismaClient): Promise<string> {
  const existing = await prisma.school.findUnique({ where: { code: 'SCH_UNKNOWN' } });
  if (existing) return existing.id;
  const created = await prisma.school.create({
    data: { code: 'SCH_UNKNOWN', name: 'ไม่ระบุ/ส่วนกลาง', district: 'แม่ฟ้าหลวง', province: 'เชียงราย' },
  });
  return created.id;
}

export async function buildCodeToSchoolId(prisma: PrismaClient, s: SourceData): Promise<Map<string, string>> {
  const dbSchools = await prisma.school.findMany({ select: { id: true, code: true, name: true } });
  // index DB schools by normalized name key (เฉพาะ SCH_ ของจริง)
  const dbByKey = new Map<string, { id: string; name: string }>();
  for (const sc of dbSchools) {
    if (!sc.code.startsWith('SCH_')) continue;
    dbByKey.set(schoolNameKey(sc.name), { id: sc.id, name: sc.name });
  }
  const findDbByContains = (needleKey: string): string | null => {
    if (!needleKey) return null;
    for (const [k, v] of dbByKey) if (k.includes(needleKey) || needleKey.includes(k)) return v.id;
    return null;
  };

  // code → dominant F4 sheet (จากคนใน F3 ที่ code นั้น แล้ว match ชื่อใน F4)
  const codeSheetVotes = new Map<string, Map<string, number>>();
  for (const [id, code] of s.f3IdToCode) {
    const k = nameKey(s.f3IdToName.get(id) ?? '');
    if (!k) continue;
    const info = s.f4NameToInfo.get(k);
    if (!info) continue;
    if (!codeSheetVotes.has(code)) codeSheetVotes.set(code, new Map());
    const m = codeSheetVotes.get(code)!;
    m.set(info.sheet, (m.get(info.sheet) ?? 0) + 1);
  }

  const codeToSchool = new Map<string, string>();
  const allCodes = new Set(s.f3IdToCode.values());
  const unresolved: string[] = [];

  for (const code of allCodes) {
    if (!code) continue;
    // 1) hardcode override
    if (HARDCODE_CODE_TO_SCHOOLNAME[code]) {
      const hit = findDbByContains(schoolNameKey(HARDCODE_CODE_TO_SCHOOLNAME[code]));
      if (hit) { codeToSchool.set(code, hit); continue; }
    }
    // 2) auto: dominant sheet → sheet title (R1) หรือ sheet name → DB school
    const votes = codeSheetVotes.get(code);
    if (votes && votes.size > 0) {
      const topSheet = [...votes.entries()].sort((a, b) => b[1] - a[1])[0][0];
      const title = s.f4SheetToTitle.get(topSheet) ?? '';
      const hit = findDbByContains(schoolNameKey(title)) ?? findDbByContains(schoolNameKey(topSheet));
      if (hit) { codeToSchool.set(code, hit); continue; }
    }
    unresolved.push(code);
  }

  if (unresolved.length > 0) {
    throw new Error(`buildCodeToSchoolId: ไม่สามารถ map school code: ${unresolved.join(', ')} — ต้องเพิ่ม HARDCODE`);
  }
  return codeToSchool;
}
