import { toLocalISODate, todayISODate } from './date';

describe('toLocalISODate', () => {
  it('อ่านวันที่จากเวลาท้องถิ่น ไม่แปลงเป็น UTC ก่อน', () => {
    // สร้างจากส่วนประกอบเวลาท้องถิ่น ผลจึงต้องเท่ากันทุกเขตเวลา
    expect(toLocalISODate(new Date(2026, 0, 15, 3, 30))).toBe('2026-01-15');
    expect(toLocalISODate(new Date(2026, 11, 31, 23, 59))).toBe('2026-12-31');
    expect(toLocalISODate(new Date(2026, 0, 1, 0, 0))).toBe('2026-01-01');
  });

  it('เติมศูนย์หน้าเดือนและวันให้ครบสองหลัก', () => {
    expect(toLocalISODate(new Date(2026, 8, 6))).toBe('2026-09-06');
  });

  /**
   * นี่คือบั๊กที่ตัวช่วยนี้มีไว้แก้ — เวลาตีสามของไทยตรงกับสองทุ่มของวันก่อนหน้าใน UTC
   * `toISOString().split('T')[0]` จึงคืนวันที่ของเมื่อวาน
   * เทสต์นี้ทำงานเฉพาะเมื่อรันในเขตเวลาที่ล้ำหน้า UTC ซึ่งครอบคลุมเครื่องในไทย
   */
  it('ต่างจากวิธีเดิมที่ใช้ toISOString เมื่ออยู่ในเขตเวลาที่ล้ำหน้า UTC', () => {
    const earlyMorning = new Date(2026, 0, 15, 3, 30);
    const offsetMinutes = -earlyMorning.getTimezoneOffset(); // ไทย = +420

    if (offsetMinutes > 210) {
      expect(earlyMorning.toISOString().split('T')[0]).toBe('2026-01-14');
      expect(toLocalISODate(earlyMorning)).toBe('2026-01-15');
    } else {
      // เขตเวลาอื่นไม่เกิดอาการนี้ ยืนยันแค่ว่าผลยังถูกต้อง
      expect(toLocalISODate(earlyMorning)).toBe('2026-01-15');
    }
  });

  it('todayISODate คืนวันที่ของวันนี้ตามเครื่องผู้ใช้', () => {
    const now = new Date();
    expect(todayISODate()).toBe(
      `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(
        now.getDate(),
      ).padStart(2, '0')}`,
    );
  });
});
