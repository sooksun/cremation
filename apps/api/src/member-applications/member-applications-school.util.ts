export function normalizeSchoolLookup(value: string): string {
  return value.trim().replace(/\s+/g, ' ');
}

export type SchoolLookupMatch<T extends { name: string; code: string }> =
  | { kind: 'empty' }
  | { kind: 'one'; school: T }
  | { kind: 'many'; candidates: T[] }
  | { kind: 'none' };

export function matchSchoolByAgency<T extends { name: string; code: string }>(
  agency: string,
  schools: T[],
): SchoolLookupMatch<T> {
  const normalized = normalizeSchoolLookup(agency);
  if (!normalized) {
    return { kind: 'empty' };
  }

  const exact = schools.filter(
    (school) =>
      normalizeSchoolLookup(school.name) === normalized ||
      normalizeSchoolLookup(school.code) === normalized,
  );

  if (exact.length === 1) {
    return { kind: 'one', school: exact[0] };
  }
  if (exact.length > 1) {
    return { kind: 'many', candidates: exact };
  }
  return { kind: 'none' };
}

export function schoolLookupErrorMessage(
  result: SchoolLookupMatch<{ name: string; code: string }>,
): string | null {
  if (result.kind === 'empty' || result.kind === 'none') {
    return 'ไม่พบโรงเรียนที่ตรงกับชื่อที่ระบุ กรุณาตรวจสอบให้ตรงกับชื่อหรือรหัสโรงเรียนในระบบ (ไม่รองรับการค้นหาแบบย่อหรือบางส่วน)';
  }
  if (result.kind === 'many') {
    return `พบโรงเรียนที่ตรงกันหลายแห่ง: ${result.candidates.map((s) => s.name).join(', ')} กรุณาระบุชื่อเต็มหรือรหัสโรงเรียนให้ชัดเจน`;
  }
  return null;
}