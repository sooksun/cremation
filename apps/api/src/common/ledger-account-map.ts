import { PaymentType, ReceiptType } from '@prisma/client';

/**
 * ผังบัญชีที่คู่กับประเภทเอกสาร
 *
 * ประกาศเป็น Record<enum, string> โดยตั้งใจ: ถ้ามีการเพิ่มสมาชิกใน ReceiptType/PaymentType
 * แล้วลืมกำหนดบัญชี TypeScript จะ error ตั้งแต่ตอน build แทนที่จะเงียบแล้วลงบัญชีผิดประเภท
 * (โค้ดเดิมใช้ if ที่กำหนดค่าเดิมทับตัวเอง จึงเป็น dead branch — ทุกประเภทลง 401/501 หมด)
 *
 * FALLBACK_* ใช้กับฐานข้อมูลที่ผังบัญชียังไม่มีรหัสใหม่ (ยังไม่ได้รัน seed รอบล่าสุด)
 * เพื่อไม่ให้การออกใบเสร็จ/ใบสำคัญจ่ายล้มเพราะบัญชีหาย
 */
export const RECEIPT_REVENUE_ACCOUNT: Record<ReceiptType, string> = {
  [ReceiptType.MEMBER_CONTRIBUTION]: '401',
  [ReceiptType.DEATH_COLLECTION]: '401',
  [ReceiptType.ADVANCE_WELFARE]: '401',
  // ห้ามใช้ 402: สมาคมยุบ "รายได้ค่าบริการ" เข้า 401 ไปแล้ว การชี้มาที่ 402
  // เท่ากับรื้อมติเดิม จึงใช้รหัสใหม่ 405 สำหรับค่าสมัคร/ค่าคู่มือ/ค่าบำรุงรายปี
  [ReceiptType.MEMBERSHIP_FEE]: '405',
  [ReceiptType.BOOK_FEE]: '405',
  [ReceiptType.ANNUAL_FEE]: '405',
  [ReceiptType.OTHER]: '409',
};

export const PAYMENT_EXPENSE_ACCOUNT: Record<PaymentType, string> = {
  [PaymentType.DEATH_BENEFIT]: '501',
  [PaymentType.OPERATING_EXPENSE]: '502',
  [PaymentType.BANK_FEE]: '504',
  [PaymentType.OTHER]: '509',
};

export const FALLBACK_REVENUE_ACCOUNT = '401';
export const FALLBACK_EXPENSE_ACCOUNT = '501';
