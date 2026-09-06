import { buildDefaultSchoolAdminUsername } from './school-admin';

/**
 * กฎนี้สะท้อน buildDefaultSchoolAdminUsername ฝั่ง API
 * (apps/api/src/school-admins/school-admins.service.ts) ซึ่งเป็นตัวจริงที่บังคับใช้
 * เทสต์ชุดนี้ต้องให้ผลเหมือนเทสต์ฝั่ง API ทุกเคส ถ้าแก้ที่หนึ่งต้องแก้อีกที่
 */
describe('buildDefaultSchoolAdminUsername (ฝั่งเว็บ)', () => {
  it('แปลงรหัสโรงเรียนจริงเป็น admin + ลำดับ 3 หลัก', () => {
    expect(buildDefaultSchoolAdminUsername('SCH_001_ชุมชนศึกษา_บ้านแม่สะ')).toBe('admin001');
    expect(buildDefaultSchoolAdminUsername('SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')).toBe('admin009');
    expect(buildDefaultSchoolAdminUsername('SCH_031_บ้านขาแหย่งพัฒนา_กลุ')).toBe('admin031');
  });

  it('รองรับลำดับเกิน 3 หลักโดยไม่ตัดทิ้ง', () => {
    expect(buildDefaultSchoolAdminUsername('SCH_032_โรงเรียนใหม่')).toBe('admin032');
    expect(buildDefaultSchoolAdminUsername('SCH_100_โรงเรียนใหม่')).toBe('admin100');
  });

  it('ไม่แตะรหัสตัวอย่างที่ไม่มีตัวคั่น จึงไม่ชนกับลำดับจริง', () => {
    expect(buildDefaultSchoolAdminUsername('SCH001')).toBe('admin-sch001');
  });

  it('คงรูปแบบเดิมเมื่อรหัสไม่มีลำดับ', () => {
    expect(buildDefaultSchoolAdminUsername('SCH_UNKNOWN')).toBe('admin-sch_unknown');
  });
});
