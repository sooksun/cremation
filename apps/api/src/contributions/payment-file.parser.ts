import { BadRequestException } from '@nestjs/common';
import * as XLSX from 'xlsx';

export const MEMBER_NO_HEADER = 'เลขสมาชิก';
export const STATUS_HEADER = 'สถานะ';
export const AMOUNT_HEADER = 'ยอดที่ต้องชำระ';

/** ค่าที่ถือว่าชำระแล้ว — ตรงกับที่ processPaymentUpload รับมาแต่เดิม */
const PAID_VALUES = ['ชำระแล้ว', 'ชำระ', 'paid'];

/** ใช้ร่วมกับ controller ตอนรับ body JSON แบบเดิม — อย่าเขียนรายการนี้ซ้ำที่อื่น */
export function isPaidStatus(value: unknown): boolean {
  return PAID_VALUES.includes(String(value ?? '').trim());
}

export interface ParsedPaymentRow {
  /** เลขบรรทัดจริงในไฟล์ (header = 1) */
  rowNo: number;
  memberNo: string;
  isPaid: boolean;
  amount?: number;
}

export interface ParsedDuplicate {
  rowNo: number;
  memberNo: string;
}

export interface ParsedPaymentFile {
  rows: ParsedPaymentRow[];
  duplicates: ParsedDuplicate[];
}

function isLikelyCSV(buffer: Buffer): boolean {
  const sample = buffer.toString('utf-8', 0, Math.min(200, buffer.length));
  // CSV is plain text, no null bytes; XLSX starts with PK (zip header)
  return !sample.includes('\x00') && (sample.includes(',') || sample.includes('\t'));
}

export function parsePaymentFile(buffer: Buffer): ParsedPaymentFile {
  const isCSV = isLikelyCSV(buffer);
  const book = isCSV
    ? XLSX.read(buffer.toString('utf-8'), { type: 'string' })
    : XLSX.read(buffer, { type: 'buffer' });
  const sheetName = book.SheetNames[0];
  if (!sheetName) {
    throw new BadRequestException('ไฟล์ไม่มีชีตข้อมูล');
  }

  const table = XLSX.utils.sheet_to_json<unknown[]>(book.Sheets[sheetName], {
    header: 1,
    defval: '',
    raw: false,
  });

  const headers = (table[0] ?? []).map((cell) => String(cell ?? '').trim());
  const memberNoIdx = headers.indexOf(MEMBER_NO_HEADER);
  if (memberNoIdx === -1) {
    throw new BadRequestException(
      `ไม่พบคอลัมน์ "${MEMBER_NO_HEADER}" ในไฟล์ — คอลัมน์ที่เจอ: ${headers.join(', ')}`,
    );
  }
  const statusIdx = headers.indexOf(STATUS_HEADER);
  const amountIdx = headers.indexOf(AMOUNT_HEADER);

  const kept = new Map<string, ParsedPaymentRow>();
  const duplicates: ParsedDuplicate[] = [];

  for (let i = 1; i < table.length; i++) {
    const cells = table[i] ?? [];
    const memberNo = String(cells[memberNoIdx] ?? '').trim();
    if (!memberNo) continue;

    const status = statusIdx === -1 ? '' : String(cells[statusIdx] ?? '').trim();
    const rawAmount = amountIdx === -1 ? '' : String(cells[amountIdx] ?? '').trim();
    const amount = rawAmount === '' ? undefined : Number(rawAmount.replace(/,/g, ''));

    const row: ParsedPaymentRow = {
      rowNo: i + 1,
      memberNo,
      isPaid: isPaidStatus(status),
      ...(amount !== undefined && Number.isFinite(amount) ? { amount } : {}),
    };

    const existing = kept.get(memberNo);
    if (!existing) {
      kept.set(memberNo, row);
      continue;
    }

    // แถวซ้ำ: แถวที่ชำระแล้วชนะ แถวที่ถูกทิ้งถูกรายงานกลับไปให้ผู้ใช้แก้ไฟล์
    if (!existing.isPaid && row.isPaid) {
      duplicates.push({ rowNo: existing.rowNo, memberNo });
      kept.set(memberNo, row);
    } else {
      duplicates.push({ rowNo: row.rowNo, memberNo });
    }
  }

  return {
    rows: [...kept.values()].sort((a, b) => a.rowNo - b.rowNo),
    duplicates: duplicates.sort((a, b) => a.rowNo - b.rowNo),
  };
}
