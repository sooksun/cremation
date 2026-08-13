import * as XLSX from 'xlsx';

export function buildWorkbookBuffer(
  sheetName: string,
  rows: Array<Record<string, string | number>>,
): Buffer {
  const sheet = XLSX.utils.json_to_sheet(rows);
  const book = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(book, sheet, sheetName);
  return XLSX.write(book, { type: 'buffer', bookType: 'xlsx' }) as Buffer;
}
