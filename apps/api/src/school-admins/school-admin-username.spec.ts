import { buildDefaultSchoolAdminUsername } from './school-admins.service';

describe('buildDefaultSchoolAdminUsername', () => {
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
    expect(buildDefaultSchoolAdminUsername('SCH001')).not.toBe(
      buildDefaultSchoolAdminUsername('SCH_001_ชุมชนศึกษา_บ้านแม่สะ'),
    );
  });

  it('คงรูปแบบเดิมเมื่อรหัสไม่มีลำดับ', () => {
    expect(buildDefaultSchoolAdminUsername('SCH_UNKNOWN')).toBe('admin-sch_unknown');
    expect(buildDefaultSchoolAdminUsername('')).toBe('admin-');
  });

  it('ไม่สร้างชื่อซ้ำกันในชุดรหัสโรงเรียนจริงทั้ง 31 แห่ง', () => {
    const codes = Array.from({ length: 31 }, (_, i) => `SCH_${String(i + 1).padStart(3, '0')}_x`);
    const names = codes.map(buildDefaultSchoolAdminUsername);
    expect(new Set(names).size).toBe(31);
  });
});
