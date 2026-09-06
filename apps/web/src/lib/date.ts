/**
 * วันที่รูปแบบ YYYY-MM-DD ตามเวลาท้องถิ่นของผู้ใช้
 *
 * ห้ามใช้ `new Date().toISOString().split('T')[0]` สำหรับค่าตั้งต้น "วันนี้"
 * เพราะ toISOString แปลงเป็น UTC ก่อน ไทยอยู่ UTC+7 ช่วงเที่ยงคืนถึงเจ็ดโมงเช้า
 * จึงได้วันที่ของเมื่อวาน เจ้าหน้าที่ที่ทำงานเช้ามืดจะบันทึกวันที่ผิดไปหนึ่งวัน
 * โดยไม่มีอะไรเตือน
 *
 * ตัวนี้อ่านปี เดือน วัน จากเวลาท้องถิ่นตรง ๆ จึงไม่มีการเลื่อนวัน
 */
export function toLocalISODate(date: Date = new Date()): string {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}

/** วันที่วันนี้ตามเวลาท้องถิ่น ใช้เป็นค่าตั้งต้นของช่องกรอกวันที่ */
export function todayISODate(): string {
  return toLocalISODate();
}
