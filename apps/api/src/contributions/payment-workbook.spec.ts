import * as XLSX from 'xlsx';
import { buildWorkbookBuffer } from './payment-workbook';
import { parsePaymentFile } from './payment-file.parser';

describe('buildWorkbookBuffer', () => {
  it('สร้างไฟล์ xlsx ที่อ่านกลับได้และมี header ตามคีย์ของ object', () => {
    const buffer = buildWorkbookBuffer('รายชื่อ', [
      { เลขสมาชิก: 'M0001', ชื่อ: 'ก', ยอดที่ต้องชำระ: 100 },
    ]);

    const book = XLSX.read(buffer, { type: 'buffer' });
    expect(book.SheetNames).toEqual(['รายชื่อ']);

    const rows = XLSX.utils.sheet_to_json<Record<string, unknown>>(book.Sheets['รายชื่อ']);
    expect(rows).toEqual([{ เลขสมาชิก: 'M0001', ชื่อ: 'ก', ยอดที่ต้องชำระ: 100 }]);
  });

  it('รายการว่างยังสร้างไฟล์ที่เปิดได้', () => {
    const buffer = buildWorkbookBuffer('ว่าง', []);

    expect(XLSX.read(buffer, { type: 'buffer' }).SheetNames).toEqual(['ว่าง']);
  });

  // รอบการทำงานจริงคือ ดาวน์โหลด template -> ผู้ใช้กรอก -> อัปโหลดกลับ ไฟล์ที่ออกจากที่นี่จึงต้อง
  // ถูก parsePaymentFile อ่านได้เสมอ ถ้าใครเปลี่ยนชื่อหัวคอลัมน์ฝั่งใดฝั่งหนึ่ง เทสต์นี้ต้องแดง
  describe('round-trip กับ parsePaymentFile', () => {
    // คีย์ของ object ชุดนี้ต้องตรงกับที่ generatePaymentTemplate สร้างใน contributions.service.ts
    const templateRow = {
      เลขสมาชิก: 'M0001',
      ชื่อ: 'สมชาย',
      นามสกุล: 'ใจดี',
      โรงเรียน: 'ร.ร.ทดสอบ',
      รหัสโรงเรียน: 'SCH_001',
      ประเภท: 'สามัญ',
      วิธีชำระ: 'หักเงินเดือน',
      ยอดที่ต้องชำระ: 120,
      สถานะ: 'ชำระแล้ว',
    };

    it('ไฟล์ที่ buildWorkbookBuffer สร้างจากแถว template ถูก parsePaymentFile อ่านกลับได้ครบ', () => {
      const buffer = buildWorkbookBuffer('รายชื่อเก็บเงิน', [
        templateRow,
        { ...templateRow, เลขสมาชิก: 'M0002', สถานะ: 'ยังไม่ชำระ' },
      ]);

      const parsed = parsePaymentFile(buffer);

      expect(parsed.duplicates).toEqual([]);
      expect(parsed.rows).toEqual([
        { rowNo: 2, memberNo: 'M0001', isPaid: true, amount: 120 },
        { rowNo: 3, memberNo: 'M0002', isPaid: false, amount: 120 },
      ]);
    });

    it('หัวคอลัมน์ที่ parser ต้องการ อยู่ในไฟล์ที่ template สร้างจริง', () => {
      const buffer = buildWorkbookBuffer('รายชื่อเก็บเงิน', [templateRow]);
      const book = XLSX.read(buffer, { type: 'buffer' });
      const headers = XLSX.utils.sheet_to_json<string[]>(book.Sheets[book.SheetNames[0]], {
        header: 1,
      })[0];

      expect(headers).toEqual(expect.arrayContaining(['เลขสมาชิก', 'สถานะ', 'ยอดที่ต้องชำระ']));
    });
  });
});
