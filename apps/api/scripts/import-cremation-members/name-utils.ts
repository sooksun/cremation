// คำนำหน้า เรียงยาว→สั้น เพื่อ match แบบ greedy (เช่น "นางสาว" ก่อน "นาง")
export const TITLES: string[] = [
  'ว่าที่ร้อยเอก', 'ว่าที่ร้อยโท', 'ว่าที่ร้อยตรี',
  'นางสาว', 'นาง', 'นาย',
  'ดร.', 'จ.ส.อ.', 'พ.จ.อ.', 'ส.อ.', 'ร.ต.',
];

export function normalizeIdCard(raw: unknown): string | null {
  if (raw === null || raw === undefined) return null;
  const digits = String(raw).replace(/\D/g, '');
  return digits.length === 13 ? digits : null;
}

/** คืนคำนำหน้าที่ match (longest-first) หรือ '' */
function detectTitle(s: string): string {
  for (const t of TITLES) {
    if (s.startsWith(t)) return t;
  }
  return '';
}

export function parseThaiName(raw: string): { firstName: string; lastName: string } {
  const collapsed = String(raw ?? '').replace(/\s+/g, ' ').trim();
  const title = detectTitle(collapsed.replace(/\s+/g, '')); // เทียบแบบไม่มีช่องว่าง
  // ตัด title ออกจากต้นสตริง (คำนำหน้าอาจมีช่องว่างคั่นจากชื่อ)
  let rest = collapsed;
  if (title) {
    // ลบ title ที่ต้นสตริงโดยไม่สนช่องว่างภายใน title
    const re = new RegExp(
      '^' + title.split('').map((c) => c.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')).join('\\s*') + '\\s*',
    );
    rest = collapsed.replace(re, '').trim();
  }
  const parts = rest.split(' ').filter(Boolean);
  const first = parts.length > 0 ? parts[0] : '';
  const last = parts.slice(1).join(' ');
  return { firstName: title + first, lastName: last };
}

export function nameKey(raw: unknown): string | null {
  if (raw === null || raw === undefined) return null;
  let s = String(raw);
  for (const t of TITLES) s = s.split(t).join('');
  s = s.replace(/\s+/g, '');
  return s.length > 0 ? s : null;
}
