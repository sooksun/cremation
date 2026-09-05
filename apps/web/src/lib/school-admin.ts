/**
 * ชื่อผู้ใช้เริ่มต้นของผู้ดูแลโรงเรียน = "admin" + ลำดับโรงเรียน 2 หลัก (admin01, admin02, ...)
 *
 * สะท้อน (แต่ไม่แทนที่) `buildDefaultSchoolAdminUsername` ใน
 * apps/api/src/school-admins/school-admins.service.ts — ฝั่ง API เป็นตัวจริงที่บังคับใช้
 * ถ้าแก้กฎที่นี่ ต้องแก้ฝั่ง API ด้วย
 */
export function buildDefaultSchoolAdminUsername(schoolCode: string): string {
  const ordinal = /^SCH[_-](\d{1,3})(?:[_-]|$)/i.exec(schoolCode ?? '');
  if (ordinal) {
    return `admin${String(Number(ordinal[1])).padStart(2, '0')}`;
  }
  return `admin-${(schoolCode ?? '').toLowerCase()}`;
}
