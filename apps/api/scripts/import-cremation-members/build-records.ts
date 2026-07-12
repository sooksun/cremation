import { parseThaiName, nameKey } from './name-utils';
import type { SourceData } from './sources';

export interface MemberRecord {
  idCard: string;
  firstName: string;
  lastName: string;
  schoolId: string;
  memberTypeCode: 'REG' | 'PERM';
  memberNo: string;
  phone: string | null;
  position: string | null;
  notes: string | null;
  salaryDeduction: boolean;
}

export interface BuildResult {
  records: MemberRecord[];
  stats: {
    withSchoolCode: number;
    unknownSchool: number;
    enrichedBank: number;
    enrichedPosition: number;
    typeReg: number;
    typePerm: number;
    duplicateIdCards: string[];
  };
}

function memberNo(i: number): string {
  return 'M' + String(i + 1).padStart(4, '0');
}

export function buildMemberRecords(
  s: SourceData,
  codeToSchool: Map<string, string>,
  unknownSchoolId: string,
): BuildResult {
  const records: MemberRecord[] = [];
  const stats = {
    withSchoolCode: 0, unknownSchool: 0, enrichedBank: 0, enrichedPosition: 0,
    typeReg: 0, typePerm: 0, duplicateIdCards: [] as string[],
  };
  const seen = new Set<string>();

  s.f1.forEach((row, i) => {
    const { idCard, rawName } = row;
    if (seen.has(idCard)) { stats.duplicateIdCards.push(idCard); return; }
    seen.add(idCard);

    const { firstName, lastName } = parseThaiName(rawName);

    // --- school ---
    const code = s.f3IdToCode.get(idCard);
    let schoolId: string;
    if (code && codeToSchool.has(code)) {
      schoolId = codeToSchool.get(code)!;
      stats.withSchoolCode++;
    } else {
      schoolId = unknownSchoolId;
      stats.unknownSchool++;
    }

    // --- type (from F2) ---
    const f2 = s.f2ById.get(idCard);
    const memberTypeCode: 'REG' | 'PERM' = f2?.type === 'ลจ.' ? 'PERM' : 'REG';
    if (memberTypeCode === 'PERM') stats.typePerm++; else stats.typeReg++;

    // --- enrich: notes (bank + สังกัดจริงถ้าเข้า unknown), phone, position ---
    const noteParts: string[] = [];
    let salaryDeduction = false;
    if (f2 && f2.acc) {
      noteParts.push(`บัญชีธนาคาร: ${f2.acc}${f2.branch ? ` สาขา ${f2.branch}` : ''}`);
      salaryDeduction = true;
      stats.enrichedBank++;
    }
    if (schoolId === unknownSchoolId && f2 && f2.remark) {
      noteParts.push(`สังกัดเดิม: ${f2.remark}`);
    }

    const f4 = s.f4NameToInfo.get(nameKey(rawName) ?? '');
    let position: string | null = null;
    let phone: string | null = null;
    if (f4) {
      position = f4.position ? f4.position.slice(0, 100) : null;
      phone = f4.phone || null;
      if (position) stats.enrichedPosition++;
    }

    records.push({
      idCard, firstName, lastName, schoolId, memberTypeCode,
      memberNo: memberNo(i),
      phone, position,
      notes: noteParts.length ? noteParts.join(' | ') : null,
      salaryDeduction,
    });
  });

  return { records, stats };
}
