/**
 * jspdf ถูกโหลดแบบ dynamic import แล้วหยิบ `.default` ออกมาใช้
 *
 * ตอนอัปจาก 2.x ไป 4.x ตัวไลบรารีเปลี่ยนเป็น ESM เป็นหลัก ถ้ารูปแบบ export
 * เปลี่ยนไป `.default` จะกลายเป็น undefined แล้วพังตอนผู้ใช้กดออกเอกสารจริง
 * ซึ่ง TypeScript จับไม่ได้เพราะชนิดยังตรง
 *
 * เทสต์นี้เรียกใช้เส้นทางเดียวกับโค้ดจริง คือ import แล้วสร้างเอกสาร
 * ใส่รูป เพิ่มหน้า และบีบออกมาเป็นไบต์
 */
describe('jspdf ที่ใช้ออกใบเสร็จและรายงาน', () => {
  // PNG ขนาด 1x1 พิกเซล สำหรับทดสอบ addImage
  const PNG_1X1 =
    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';

  it('โหลดผ่าน dynamic import แล้วได้ตัวสร้างเอกสารจริง', async () => {
    const jsPDF = (await import('jspdf')).default;

    expect(typeof jsPDF).toBe('function');
  });

  it('สร้างเอกสาร A4 แนวตั้ง ใส่รูป เพิ่มหน้า แล้วออกเป็นไฟล์ PDF ได้', async () => {
    const jsPDF = (await import('jspdf')).default;

    const pdf = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
    pdf.addImage(PNG_1X1, 'PNG', 0, 0, 210, 297);
    pdf.addPage();
    pdf.addImage(PNG_1X1, 'PNG', 0, 0, 210, 100);

    const bytes = new Uint8Array(pdf.output('arraybuffer') as ArrayBuffer);

    expect(bytes.length).toBeGreaterThan(500);
    // ต้องขึ้นต้นด้วยลายเซ็นของไฟล์ PDF จริง
    expect(Buffer.from(bytes.slice(0, 5)).toString()).toBe('%PDF-');
  });

  it('ขนาดหน้ากระดาษ A4 ตรงตามที่โค้ดคำนวณตำแหน่งรูปไว้', async () => {
    const jsPDF = (await import('jspdf')).default;

    const pdf = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });

    expect(Math.round(pdf.internal.pageSize.getWidth())).toBe(210);
    expect(Math.round(pdf.internal.pageSize.getHeight())).toBe(297);
  });
});
