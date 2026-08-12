import { BadRequestException } from '@nestjs/common';
import * as XLSX from 'xlsx';
import { parsePaymentFile } from './payment-file.parser';

function xlsxBuffer(rows: string[][]): Buffer {
  const sheet = XLSX.utils.aoa_to_sheet(rows);
  const book = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(book, sheet, 'Sheet1');
  return XLSX.write(book, { type: 'buffer', bookType: 'xlsx' }) as Buffer;
}

function xlsBuffer(rows: string[][]): Buffer {
  const sheet = XLSX.utils.aoa_to_sheet(rows);
  const book = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(book, sheet, 'Sheet1');
  return XLSX.write(book, { type: 'buffer', bookType: 'xls' }) as Buffer;
}

const HEADER = ['เลขสมาชิก', 'ชื่อ', 'นามสกุล', 'ยอดที่ต้องชำระ', 'สถานะ'];

describe('parsePaymentFile', () => {
  it('อ่านไฟล์ xlsx จริงและใส่เลขบรรทัดตามไฟล์', () => {
    const buffer = xlsxBuffer([
      HEADER,
      ['M0001', 'ก', 'ข', '100', 'ชำระแล้ว'],
      ['M0002', 'ค', 'ง', '100', 'ยังไม่ชำระ'],
    ]);

    const result = parsePaymentFile(buffer);

    expect(result.rows).toEqual([
      { rowNo: 2, memberNo: 'M0001', isPaid: true, amount: 100 },
      { rowNo: 3, memberNo: 'M0002', isPaid: false, amount: 100 },
    ]);
    expect(result.duplicates).toEqual([]);
  });

  it('อ่านไฟล์ csv ได้ด้วย', () => {
    const csv = Buffer.from(
      `${HEADER.join(',')}\nM0001,ก,ข,100,ชำระแล้ว\n`,
      'utf-8',
    );

    const result = parsePaymentFile(csv);

    expect(result.rows).toEqual([{ rowNo: 2, memberNo: 'M0001', isPaid: true, amount: 100 }]);
  });

  it('อ่านไฟล์ xls (binary/OLE2) ได้ด้วย', () => {
    const buffer = xlsBuffer([
      HEADER,
      ['M0001', 'สมชาย', 'บุญชัย', '200', 'ชำระแล้ว'],
    ]);

    const result = parsePaymentFile(buffer);

    expect(result.rows).toEqual([{ rowNo: 2, memberNo: 'M0001', isPaid: true, amount: 200 }]);
  });

  it.each(['ชำระแล้ว', 'ชำระ', 'paid'])('ถือว่าสถานะ %s คือชำระแล้ว', (status) => {
    const result = parsePaymentFile(xlsxBuffer([HEADER, ['M0001', 'ก', 'ข', '100', status]]));

    expect(result.rows[0].isPaid).toBe(true);
  });

  it('ข้ามแถวว่างโดยไม่นับเป็น error', () => {
    const result = parsePaymentFile(
      xlsxBuffer([HEADER, ['', '', '', '', ''], ['M0002', 'ค', 'ง', '100', 'ชำระแล้ว']]),
    );

    expect(result.rows).toEqual([{ rowNo: 3, memberNo: 'M0002', isPaid: true, amount: 100 }]);
  });

  it('เลขสมาชิกซ้ำ: เก็บแถวที่ชำระแล้ว และรายงานแถวที่ทิ้ง', () => {
    const result = parsePaymentFile(
      xlsxBuffer([
        HEADER,
        ['M0001', 'ก', 'ข', '100', 'ยังไม่ชำระ'],
        ['M0001', 'ก', 'ข', '100', 'ชำระแล้ว'],
      ]),
    );

    expect(result.rows).toEqual([{ rowNo: 3, memberNo: 'M0001', isPaid: true, amount: 100 }]);
    expect(result.duplicates).toEqual([{ rowNo: 2, memberNo: 'M0001' }]);
  });

  it('เลขสมาชิกซ้ำและไม่มีแถวไหนชำระเลย: เก็บแถวแรกสุด', () => {
    const result = parsePaymentFile(
      xlsxBuffer([
        HEADER,
        ['M0001', 'ก', 'ข', '100', 'ยังไม่ชำระ'],
        ['M0001', 'ก', 'ข', '100', 'ยังไม่ชำระ'],
      ]),
    );

    expect(result.rows).toEqual([{ rowNo: 2, memberNo: 'M0001', isPaid: false, amount: 100 }]);
    expect(result.duplicates).toEqual([{ rowNo: 3, memberNo: 'M0001' }]);
  });

  it('ไม่มีคอลัมน์เลขสมาชิก: โยน BadRequestException ที่บอกคอลัมน์ที่เจอ', () => {
    const buffer = xlsxBuffer([['ชื่อ', 'สถานะ'], ['ก', 'ชำระแล้ว']]);

    expect(() => parsePaymentFile(buffer)).toThrow(BadRequestException);
    expect(() => parsePaymentFile(buffer)).toThrow(/ชื่อ, สถานะ/);
  });
});
