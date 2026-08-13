import * as XLSX from 'xlsx';
import { buildWorkbookBuffer } from './payment-workbook';

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
});
