# Monthly Collection Reconcile Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** หลังอัปโหลดไฟล์เก็บเงินรายเดือน ระบบต้องรายงานได้ว่างวดนั้น "ขาดใครบ้าง" พร้อมเหตุผล แทนที่จะตรวจแค่แถวที่มีในไฟล์

**Architecture:** แยกงานใหม่ออกเป็นสองหน่วยเล็กที่ทดสอบแยกได้ — `payment-file.parser.ts` แปลงไฟล์ (.xlsx/.xls/.csv) เป็นแถวข้อมูล และ `payment-reconciliation.service.ts` เทียบรายชื่อที่ควรเก็บกับสิ่งที่อยู่ในไฟล์ ตัวเดิม `ContributionsService` (1,336 บรรทัด) ยังทำหน้าที่บันทึกชำระ/ออกใบเสร็จเหมือนเดิม controller เป็นคนเรียกทั้งสองต่อกัน ฝั่งเว็บแยก modal และแผงผลลัพธ์ออกจาก `matrix/page.tsx` (911 บรรทัด) เป็น component ของตัวเอง

**Tech Stack:** NestJS 10, Prisma/MySQL, `xlsx@^0.18.5` (มีอยู่แล้วใน apps/api), Jest, Next.js 15 App Router, TanStack Query, react-toastify

**Spec:** [docs/superpowers/specs/2026-08-13-monthly-collection-reconcile-design.md](../specs/2026-08-13-monthly-collection-reconcile-design.md)

## Global Constraints

- ทุกคำสั่ง jest รันจาก `apps/api`: `cd apps/api && npx jest <path>`
- คอลัมน์บังคับในไฟล์: `เลขสมาชิก` — ไม่มีถือว่าไฟล์ผิด โยน `BadRequestException`
- ค่า `สถานะ` ที่ถือว่าชำระแล้ว: `ชำระแล้ว`, `ชำระ`, `paid` (ตรงกับ `contributions.service.ts:1119`)
- ขนาดไฟล์อัปโหลดสูงสุด 5 MB
- สมาชิกที่นับเข้า `expected`: `status ∈ { ACTIVE, ARREARS }` เท่านั้น
- `SchoolScopeService.resolveSchoolId(actor)` เป็นด่านสุดท้ายเสมอ — ห้ามเชื่อ `fullDistrict` จาก client
- ห้ามเรียก `markArrearsForPeriod` เพื่อ mark คนที่ขาด (มันเหมารวมทั้งงวด — `contributions.service.ts:550`)
- ห้ามผูก `sendArrearsNoticeForPeriod` เข้ากับ flow อัปโหลด (มันตัดสมาชิกภาพได้ — `contributions.service.ts:569`)
- เงินในฐานข้อมูลเป็น Prisma `Decimal` แปลงเป็น `number` ที่ขอบระบบด้วย `Number(...)`
- วันที่ใน API เป็น Gregorian แปลงเป็น พ.ศ. เฉพาะที่ UI
- ห้ามเหลือ `console.log` / `console.error` ในโค้ดที่ merge
- Role ที่เข้าถึงได้: `ADMIN`, `SCHOOL_ADMIN`, `FINANCE`

---

### Task 1: PaymentFileParser — แปลงไฟล์เป็นแถวข้อมูล

**Files:**
- Create: `apps/api/src/contributions/payment-file.parser.ts`
- Test: `apps/api/src/contributions/payment-file.parser.spec.ts`

**Interfaces:**
- Consumes: `xlsx@^0.18.5`, `BadRequestException` จาก `@nestjs/common`
- Produces:
  ```ts
  export interface ParsedPaymentRow { rowNo: number; memberNo: string; isPaid: boolean; amount?: number }
  export interface ParsedDuplicate { rowNo: number; memberNo: string }
  export interface ParsedPaymentFile { rows: ParsedPaymentRow[]; duplicates: ParsedDuplicate[] }
  export function parsePaymentFile(buffer: Buffer): ParsedPaymentFile
  ```
  `rowNo` คือเลขบรรทัดจริงในไฟล์ โดยแถว header = 1 ข้อมูลแถวแรก = 2

- [ ] **Step 1: Write the failing test**

สร้าง `apps/api/src/contributions/payment-file.parser.spec.ts`

```ts
import { BadRequestException } from '@nestjs/common';
import * as XLSX from 'xlsx';
import { parsePaymentFile } from './payment-file.parser';

function xlsxBuffer(rows: string[][]): Buffer {
  const sheet = XLSX.utils.aoa_to_sheet(rows);
  const book = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(book, sheet, 'Sheet1');
  return XLSX.write(book, { type: 'buffer', bookType: 'xlsx' }) as Buffer;
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd apps/api && npx jest src/contributions/payment-file.parser.spec.ts`
Expected: FAIL — `Cannot find module './payment-file.parser'`

- [ ] **Step 3: Write minimal implementation**

สร้าง `apps/api/src/contributions/payment-file.parser.ts`

```ts
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

export function parsePaymentFile(buffer: Buffer): ParsedPaymentFile {
  const book = XLSX.read(buffer, { type: 'buffer' });
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
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd apps/api && npx jest src/contributions/payment-file.parser.spec.ts`
Expected: PASS — 7 tests

- [ ] **Step 5: Commit**

```bash
git add apps/api/src/contributions/payment-file.parser.ts apps/api/src/contributions/payment-file.parser.spec.ts
git commit -m "feat(contributions): parse payment file (.xlsx/.csv) with row numbers and duplicate detection"
```

---

### Task 2: PaymentReconciliationService — เทียบว่าใครขาด

**Files:**
- Create: `apps/api/src/contributions/payment-reconciliation.service.ts`
- Test: `apps/api/src/contributions/payment-reconciliation.service.spec.ts`

**Interfaces:**
- Consumes: `ParsedPaymentFile` จาก Task 1, `PrismaService`, `SchoolScopeService` (`resolveSchoolId`), `AppSettingsService` (`isServiceFeeEnabled()`, `effectiveServiceFee(fee, enabled)`), `ScopedUser`
- Produces:
  ```ts
  export type MissingReason = 'NOT_IN_FILE' | 'IN_FILE_NOT_PAID';
  export interface MissingRow {
    memberId: string; contributionId: string | null; memberNo: string; fullName: string;
    schoolId: string; schoolCode: string; schoolName: string; groupName: string;
    amountDue: number; reason: MissingReason;
  }
  export interface ReconcileResult {
    scope: { fullDistrict: boolean; schools: Array<{ id: string; code: string; name: string }> };
    summary: {
      expected: number; paid: number; alreadyPaid: number; missingFromFile: number;
      inFileNotPaid: number; unknownInFile: number; markedArrears: number;
    };
    missing: MissingRow[];
    unknown: Array<{ rowNo: number; memberNo: string }>;
  }
  class PaymentReconciliationService {
    reconcile(params: {
      periodId: string; parsed: ParsedPaymentFile; paidNowMemberNos: Set<string>;
      actor?: ScopedUser; fullDistrict: boolean;
    }): Promise<ReconcileResult>
  }
  ```
  `summary.markedArrears` ในงานนี้คืนค่า `0` เสมอ — Task 3 เป็นคนเติมค่าจริง

- [ ] **Step 1: Write the failing test**

สร้าง `apps/api/src/contributions/payment-reconciliation.service.spec.ts`

```ts
import { MemberStatus, Role } from '@prisma/client';
import { PaymentReconciliationService } from './payment-reconciliation.service';
import { PrismaService } from '../prisma/prisma.service';
import { SchoolScopeService } from '../common/security/school-scope.service';
import { AppSettingsService } from '../common/services/app-settings.service';
import type { ParsedPaymentFile } from './payment-file.parser';

const PERIOD = { id: 'p1', year: 2026, month: 8, isClosed: false, welfareRate: 100, serviceFee: 0 };

function member(overrides: {
  memberNo: string; schoolId: string; schoolCode: string; paidAmount?: number;
}) {
  return {
    id: `id-${overrides.memberNo}`,
    memberNo: overrides.memberNo,
    schoolId: overrides.schoolId,
    school: { id: overrides.schoolId, code: overrides.schoolCode, name: `ร.ร.${overrides.schoolCode}` },
    group: { name: 'กลุ่ม 1' },
    associationMember: { firstName: 'ชื่อ', lastName: overrides.memberNo },
    contributions: [
      { id: `c-${overrides.memberNo}`, totalAmount: 100, paidAmount: overrides.paidAmount ?? 0 },
    ],
  };
}

function parsed(rows: Array<{ rowNo: number; memberNo: string; isPaid: boolean }>): ParsedPaymentFile {
  return { rows, duplicates: [] };
}

describe('PaymentReconciliationService', () => {
  let service: PaymentReconciliationService;
  let prisma: {
    contributionPeriod: { findUnique: jest.Mock };
    member: { findMany: jest.Mock };
  };
  let resolveSchoolId: jest.Mock;

  beforeEach(() => {
    prisma = {
      contributionPeriod: { findUnique: jest.fn().mockResolvedValue(PERIOD) },
      member: { findMany: jest.fn() },
    };
    resolveSchoolId = jest.fn().mockReturnValue(undefined);

    service = new PaymentReconciliationService(
      prisma as unknown as PrismaService,
      { resolveSchoolId } as unknown as SchoolScopeService,
      {
        isServiceFeeEnabled: jest.fn().mockResolvedValue(false),
        effectiveServiceFee: jest.fn((fee: number, enabled: boolean) => (enabled ? fee : 0)),
      } as unknown as AppSettingsService,
    );
  });

  it('นับ expected เฉพาะโรงเรียนที่ปรากฏในไฟล์', async () => {
    // ครั้งแรก = หาสมาชิกจากเลขในไฟล์, ครั้งที่สอง = ดึง expected
    prisma.member.findMany
      .mockResolvedValueOnce([{ id: 'id-M1', memberNo: 'M1', schoolId: 's1' }])
      .mockResolvedValueOnce([
        member({ memberNo: 'M1', schoolId: 's1', schoolCode: 'A', paidAmount: 100 }),
        member({ memberNo: 'M2', schoolId: 's1', schoolCode: 'A' }),
      ]);

    const result = await service.reconcile({
      periodId: 'p1',
      parsed: parsed([{ rowNo: 2, memberNo: 'M1', isPaid: true }]),
      paidNowMemberNos: new Set(['M1']),
      fullDistrict: false,
    });

    expect(prisma.member.findMany.mock.calls[1][0].where.schoolId).toEqual({ in: ['s1'] });
    expect(result.summary.expected).toBe(2);
    expect(result.summary.paid).toBe(1);
    expect(result.summary.missingFromFile).toBe(1);
    expect(result.missing[0]).toMatchObject({ memberNo: 'M2', reason: 'NOT_IN_FILE', amountDue: 100 });
  });

  it('fullDistrict = true โดย ADMIN ดึงสมาชิกทุกโรงเรียน', async () => {
    prisma.member.findMany
      .mockResolvedValueOnce([{ id: 'id-M1', memberNo: 'M1', schoolId: 's1' }])
      .mockResolvedValueOnce([member({ memberNo: 'M1', schoolId: 's1', schoolCode: 'A', paidAmount: 100 })]);

    await service.reconcile({
      periodId: 'p1',
      parsed: parsed([{ rowNo: 2, memberNo: 'M1', isPaid: true }]),
      paidNowMemberNos: new Set(['M1']),
      actor: { id: 'u1', role: Role.ADMIN },
      fullDistrict: true,
    });

    expect(prisma.member.findMany.mock.calls[1][0].where.schoolId).toBeUndefined();
  });

  it('SCHOOL_ADMIN ส่ง fullDistrict = true มา ก็ยังถูกบังคับที่โรงเรียนตัวเอง', async () => {
    resolveSchoolId.mockReturnValue('s9');
    prisma.member.findMany
      .mockResolvedValueOnce([{ id: 'id-M1', memberNo: 'M1', schoolId: 's1' }])
      .mockResolvedValueOnce([]);

    const result = await service.reconcile({
      periodId: 'p1',
      parsed: parsed([{ rowNo: 2, memberNo: 'M1', isPaid: true }]),
      paidNowMemberNos: new Set(),
      actor: { id: 'u2', role: Role.SCHOOL_ADMIN, schoolId: 's9' },
      fullDistrict: true,
    });

    expect(prisma.member.findMany.mock.calls[1][0].where.schoolId).toEqual({ in: ['s9'] });
    expect(result.scope.fullDistrict).toBe(false);
  });

  it('อยู่ในไฟล์แต่ยังไม่ชำระ ได้เหตุผล IN_FILE_NOT_PAID', async () => {
    prisma.member.findMany
      .mockResolvedValueOnce([{ id: 'id-M1', memberNo: 'M1', schoolId: 's1' }])
      .mockResolvedValueOnce([member({ memberNo: 'M1', schoolId: 's1', schoolCode: 'A' })]);

    const result = await service.reconcile({
      periodId: 'p1',
      parsed: parsed([{ rowNo: 2, memberNo: 'M1', isPaid: false }]),
      paidNowMemberNos: new Set(),
      fullDistrict: false,
    });

    expect(result.summary.inFileNotPaid).toBe(1);
    expect(result.missing[0].reason).toBe('IN_FILE_NOT_PAID');
  });

  it('คนที่ชำระอยู่ก่อนแล้วแต่ไม่มีในไฟล์ ไม่ถือว่าขาด', async () => {
    prisma.member.findMany
      .mockResolvedValueOnce([{ id: 'id-M1', memberNo: 'M1', schoolId: 's1' }])
      .mockResolvedValueOnce([
        member({ memberNo: 'M1', schoolId: 's1', schoolCode: 'A', paidAmount: 100 }),
        member({ memberNo: 'M2', schoolId: 's1', schoolCode: 'A', paidAmount: 100 }),
      ]);

    const result = await service.reconcile({
      periodId: 'p1',
      parsed: parsed([{ rowNo: 2, memberNo: 'M1', isPaid: true }]),
      paidNowMemberNos: new Set(['M1']),
      fullDistrict: false,
    });

    expect(result.summary.alreadyPaid).toBe(1);
    expect(result.summary.missingFromFile).toBe(0);
    expect(result.missing).toEqual([]);
  });

  it('เลขสมาชิกในไฟล์ที่ไม่มีในระบบ เข้ากอง unknown พร้อมเลขบรรทัด', async () => {
    prisma.member.findMany.mockResolvedValueOnce([]).mockResolvedValueOnce([]);

    const result = await service.reconcile({
      periodId: 'p1',
      parsed: parsed([{ rowNo: 7, memberNo: 'M9999', isPaid: true }]),
      paidNowMemberNos: new Set(),
      fullDistrict: false,
    });

    expect(result.summary.unknownInFile).toBe(1);
    expect(result.unknown).toEqual([{ rowNo: 7, memberNo: 'M9999' }]);
  });

  it('ดึง expected เฉพาะสมาชิกที่ยังมีสภาพ', async () => {
    prisma.member.findMany
      .mockResolvedValueOnce([{ id: 'id-M1', memberNo: 'M1', schoolId: 's1' }])
      .mockResolvedValueOnce([]);

    await service.reconcile({
      periodId: 'p1',
      parsed: parsed([{ rowNo: 2, memberNo: 'M1', isPaid: true }]),
      paidNowMemberNos: new Set(),
      fullDistrict: false,
    });

    expect(prisma.member.findMany.mock.calls[1][0].where.status).toEqual({
      in: [MemberStatus.ACTIVE, MemberStatus.ARREARS],
    });
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd apps/api && npx jest src/contributions/payment-reconciliation.service.spec.ts`
Expected: FAIL — `Cannot find module './payment-reconciliation.service'`

- [ ] **Step 3: Write minimal implementation**

สร้าง `apps/api/src/contributions/payment-reconciliation.service.ts`

```ts
import { Injectable, NotFoundException } from '@nestjs/common';
import { MemberStatus } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { ScopedUser, SchoolScopeService } from '../common/security/school-scope.service';
import { AppSettingsService } from '../common/services/app-settings.service';
import type { ParsedPaymentFile } from './payment-file.parser';

export type MissingReason = 'NOT_IN_FILE' | 'IN_FILE_NOT_PAID';

export interface MissingRow {
  memberId: string;
  contributionId: string | null;
  memberNo: string;
  fullName: string;
  schoolId: string;
  schoolCode: string;
  schoolName: string;
  groupName: string;
  amountDue: number;
  reason: MissingReason;
}

export interface ReconcileResult {
  scope: { fullDistrict: boolean; schools: Array<{ id: string; code: string; name: string }> };
  summary: {
    expected: number;
    paid: number;
    alreadyPaid: number;
    missingFromFile: number;
    inFileNotPaid: number;
    unknownInFile: number;
    markedArrears: number;
  };
  missing: MissingRow[];
  unknown: Array<{ rowNo: number; memberNo: string }>;
}

@Injectable()
export class PaymentReconciliationService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly schoolScope: SchoolScopeService,
    private readonly appSettings: AppSettingsService,
  ) {}

  async reconcile(params: {
    periodId: string;
    parsed: ParsedPaymentFile;
    paidNowMemberNos: Set<string>;
    actor?: ScopedUser;
    fullDistrict: boolean;
  }): Promise<ReconcileResult> {
    const period = await this.prisma.contributionPeriod.findUnique({
      where: { id: params.periodId },
    });
    if (!period) {
      throw new NotFoundException('ไม่พบงวดที่ระบุ');
    }

    const fileMemberNos = [...new Set(params.parsed.rows.map((row) => row.memberNo))];
    const membersInFile = await this.prisma.member.findMany({
      where: { memberNo: { in: fileMemberNos } },
      select: { id: true, memberNo: true, schoolId: true },
    });

    const knownNos = new Set(membersInFile.map((m) => m.memberNo));
    const unknown = params.parsed.rows
      .filter((row) => !knownNos.has(row.memberNo))
      .map((row) => ({ rowNo: row.rowNo, memberNo: row.memberNo }));

    // ด่านสุดท้ายของสิทธิ์ — SCHOOL_ADMIN ถูกบังคับที่โรงเรียนตัวเองเสมอ ไม่ว่า client ส่งอะไรมา
    const forcedSchoolId = params.actor
      ? this.schoolScope.resolveSchoolId(params.actor)
      : undefined;
    const schoolIdsInFile = [...new Set(membersInFile.map((m) => m.schoolId))];

    let schoolIds: string[] | undefined;
    let effectiveFullDistrict = false;
    if (forcedSchoolId) {
      schoolIds = [forcedSchoolId];
    } else if (params.fullDistrict) {
      schoolIds = undefined;
      effectiveFullDistrict = true;
    } else {
      schoolIds = schoolIdsInFile;
    }

    const expectedMembers = await this.prisma.member.findMany({
      where: {
        status: { in: [MemberStatus.ACTIVE, MemberStatus.ARREARS] },
        ...(schoolIds ? { schoolId: { in: schoolIds } } : {}),
      },
      select: {
        id: true,
        memberNo: true,
        schoolId: true,
        school: { select: { id: true, code: true, name: true } },
        group: { select: { name: true } },
        associationMember: { select: { firstName: true, lastName: true } },
        contributions: {
          where: { periodId: params.periodId },
          select: { id: true, totalAmount: true, paidAmount: true },
        },
      },
      orderBy: [{ school: { name: 'asc' } }, { memberNo: 'asc' }],
    });

    const { totalAmount: defaultAmount } = await this.resolveAmounts(period);
    const fileMemberNoSet = new Set(fileMemberNos);

    const missing: MissingRow[] = [];
    const schools = new Map<string, { id: string; code: string; name: string }>();
    let paid = 0;
    let alreadyPaid = 0;

    for (const member of expectedMembers) {
      schools.set(member.school.id, member.school);
      const contribution = member.contributions[0];
      const isPaid = contribution ? Number(contribution.paidAmount) > 0 : false;

      if (isPaid) {
        if (params.paidNowMemberNos.has(member.memberNo)) paid++;
        else alreadyPaid++;
        continue;
      }

      missing.push({
        memberId: member.id,
        contributionId: contribution?.id ?? null,
        memberNo: member.memberNo,
        fullName: `${member.associationMember?.firstName ?? ''} ${member.associationMember?.lastName ?? ''}`.trim(),
        schoolId: member.schoolId,
        schoolCode: member.school.code,
        schoolName: member.school.name,
        groupName: member.group?.name ?? '',
        amountDue: contribution ? Number(contribution.totalAmount) : defaultAmount,
        reason: fileMemberNoSet.has(member.memberNo) ? 'IN_FILE_NOT_PAID' : 'NOT_IN_FILE',
      });
    }

    return {
      scope: { fullDistrict: effectiveFullDistrict, schools: [...schools.values()] },
      summary: {
        expected: expectedMembers.length,
        paid,
        alreadyPaid,
        missingFromFile: missing.filter((m) => m.reason === 'NOT_IN_FILE').length,
        inFileNotPaid: missing.filter((m) => m.reason === 'IN_FILE_NOT_PAID').length,
        unknownInFile: unknown.length,
        markedArrears: 0,
      },
      missing,
      unknown,
    };
  }

  private async resolveAmounts(period: { welfareRate: unknown; serviceFee: unknown }) {
    const serviceFeeEnabled = await this.appSettings.isServiceFeeEnabled();
    const welfareRate = Number(period.welfareRate);
    const serviceFee = this.appSettings.effectiveServiceFee(
      Number(period.serviceFee),
      serviceFeeEnabled,
    );
    return { welfareRate, serviceFee, totalAmount: welfareRate + serviceFee };
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd apps/api && npx jest src/contributions/payment-reconciliation.service.spec.ts`
Expected: PASS — 7 tests

- [ ] **Step 5: Commit**

```bash
git add apps/api/src/contributions/payment-reconciliation.service.ts apps/api/src/contributions/payment-reconciliation.service.spec.ts
git commit -m "feat(contributions): reconcile expected members against uploaded payment file"
```

---

### Task 3: บันทึกค้างชำระเฉพาะคนที่ขาด

**Files:**
- Modify: `apps/api/src/contributions/payment-reconciliation.service.ts` (เพิ่มเมธอด + เรียกจาก `reconcile`)
- Test: `apps/api/src/contributions/payment-reconciliation.service.spec.ts` (เพิ่ม describe block)

**Interfaces:**
- Consumes: `MissingRow[]` จาก Task 2
- Produces:
  ```ts
  markMissingAsArrears(periodId: string, missing: MissingRow[]): Promise<number>
  ```
  และ `reconcile()` รับ param เพิ่ม `autoMarkArrears: boolean` แล้วเติม `summary.markedArrears`
  สมาชิกที่ยังไม่มีแถว `MemberContribution` ของงวดนั้น จะถูกสร้างแถวใหม่ให้ก่อน (paidAmount = 0,
  isArrears = true) เพื่อให้ค้างชำระมองเห็นได้จริงในรายงาน

- [ ] **Step 1: Write the failing test**

เพิ่มท้ายไฟล์ `payment-reconciliation.service.spec.ts` (ภายใน `describe('PaymentReconciliationService')` เดิม)
และเพิ่ม mock ที่ `beforeEach` ให้ `prisma` มี `memberContribution`

```ts
  // เพิ่มใน beforeEach: prisma.memberContribution
  //   memberContribution: { updateMany: jest.fn().mockResolvedValue({ count: 0 }), createMany: jest.fn() },

  describe('autoMarkArrears', () => {
    it('ตั้ง isArrears เฉพาะ contribution ของคนที่ขาด ไม่ใช่ทั้งงวด', async () => {
      prisma.member.findMany
        .mockResolvedValueOnce([{ id: 'id-M1', memberNo: 'M1', schoolId: 's1' }])
        .mockResolvedValueOnce([
          member({ memberNo: 'M1', schoolId: 's1', schoolCode: 'A', paidAmount: 100 }),
          member({ memberNo: 'M2', schoolId: 's1', schoolCode: 'A' }),
        ]);
      prisma.memberContribution.updateMany.mockResolvedValue({ count: 1 });

      const result = await service.reconcile({
        periodId: 'p1',
        parsed: parsed([{ rowNo: 2, memberNo: 'M1', isPaid: true }]),
        paidNowMemberNos: new Set(['M1']),
        fullDistrict: false,
        autoMarkArrears: true,
      });

      expect(prisma.memberContribution.updateMany).toHaveBeenCalledWith({
        where: { id: { in: ['c-M2'] }, paidAmount: 0 },
        data: { isArrears: true },
      });
      expect(result.summary.markedArrears).toBe(1);
    });

    it('สร้างแถว contribution ให้คนที่ขาดแต่ยังไม่มีแถวของงวดนั้น', async () => {
      const noContribution = member({ memberNo: 'M3', schoolId: 's1', schoolCode: 'A' });
      noContribution.contributions = [];
      prisma.member.findMany
        .mockResolvedValueOnce([{ id: 'id-M1', memberNo: 'M1', schoolId: 's1' }])
        .mockResolvedValueOnce([noContribution]);
      prisma.memberContribution.createMany.mockResolvedValue({ count: 1 });

      const result = await service.reconcile({
        periodId: 'p1',
        parsed: parsed([{ rowNo: 2, memberNo: 'M1', isPaid: true }]),
        paidNowMemberNos: new Set(),
        fullDistrict: false,
        autoMarkArrears: true,
      });

      expect(prisma.memberContribution.createMany).toHaveBeenCalledWith({
        data: [
          {
            memberId: 'id-M3',
            periodId: 'p1',
            schoolId: 's1',
            welfareAmount: 100,
            serviceAmount: 0,
            totalAmount: 100,
            paidAmount: 0,
            isArrears: true,
          },
        ],
      });
      expect(result.summary.markedArrears).toBe(1);
    });

    it('autoMarkArrears = false ไม่แตะฐานข้อมูล', async () => {
      prisma.member.findMany
        .mockResolvedValueOnce([{ id: 'id-M1', memberNo: 'M1', schoolId: 's1' }])
        .mockResolvedValueOnce([member({ memberNo: 'M2', schoolId: 's1', schoolCode: 'A' })]);

      const result = await service.reconcile({
        periodId: 'p1',
        parsed: parsed([{ rowNo: 2, memberNo: 'M1', isPaid: true }]),
        paidNowMemberNos: new Set(),
        fullDistrict: false,
        autoMarkArrears: false,
      });

      expect(prisma.memberContribution.updateMany).not.toHaveBeenCalled();
      expect(prisma.memberContribution.createMany).not.toHaveBeenCalled();
      expect(result.summary.markedArrears).toBe(0);
    });
  });
```

แก้ signature ของ `reconcile` ในเทสต์เดิมทั้ง 7 เคสให้ส่ง `autoMarkArrears: false` ด้วย

- [ ] **Step 2: Run test to verify it fails**

Run: `cd apps/api && npx jest src/contributions/payment-reconciliation.service.spec.ts`
Expected: FAIL — `prisma.memberContribution.updateMany` ไม่ถูกเรียก และ `markedArrears` เป็น 0

- [ ] **Step 3: Write minimal implementation**

ใน `payment-reconciliation.service.ts` แก้ signature และเติมเมธอด

```ts
  async reconcile(params: {
    periodId: string;
    parsed: ParsedPaymentFile;
    paidNowMemberNos: Set<string>;
    actor?: ScopedUser;
    fullDistrict: boolean;
    autoMarkArrears: boolean;
  }): Promise<ReconcileResult> {
```

แทนที่ `markedArrears: 0` ด้วยการคำนวณจริง โดยก่อน `return` ให้ใส่

```ts
    const markedArrears = params.autoMarkArrears
      ? await this.markMissingAsArrears(params.periodId, missing, defaultAmount, period)
      : 0;
```

แล้วเพิ่มเมธอด

```ts
  /**
   * ตั้งธงค้างชำระให้เฉพาะคนที่ขาด — ห้ามใช้ markArrearsForPeriod เพราะตัวนั้นเหมารวม
   * ทุกคนที่ยังไม่จ่ายทั้งงวด ซึ่งกว้างกว่าขอบเขตที่ไฟล์ครอบคลุม
   */
  private async markMissingAsArrears(
    periodId: string,
    missing: MissingRow[],
    defaultAmount: number,
    period: { welfareRate: unknown; serviceFee: unknown },
  ): Promise<number> {
    if (missing.length === 0) return 0;

    const existingIds = missing
      .map((row) => row.contributionId)
      .filter((id): id is string => id !== null);
    const withoutContribution = missing.filter((row) => row.contributionId === null);

    let marked = 0;

    if (existingIds.length > 0) {
      const updated = await this.prisma.memberContribution.updateMany({
        where: { id: { in: existingIds }, paidAmount: 0 },
        data: { isArrears: true },
      });
      marked += updated.count;
    }

    if (withoutContribution.length > 0) {
      const { welfareRate, serviceFee } = await this.resolveAmounts(period);
      const created = await this.prisma.memberContribution.createMany({
        data: withoutContribution.map((row) => ({
          memberId: row.memberId,
          periodId,
          schoolId: row.schoolId,
          welfareAmount: welfareRate,
          serviceAmount: serviceFee,
          totalAmount: defaultAmount,
          paidAmount: 0,
          isArrears: true,
        })),
      });
      marked += created.count;
    }

    return marked;
  }
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd apps/api && npx jest src/contributions/payment-reconciliation.service.spec.ts`
Expected: PASS — 10 tests

- [ ] **Step 5: Commit**

```bash
git add apps/api/src/contributions/payment-reconciliation.service.ts apps/api/src/contributions/payment-reconciliation.service.spec.ts
git commit -m "feat(contributions): flag only the missing members as arrears after upload"
```

---

### Task 4: ต่อ parser + reconciliation เข้ากับ endpoint upload

**Files:**
- Modify: `apps/api/src/contributions/contributions.controller.ts:193-206`
- Modify: `apps/api/src/contributions/contributions.module.ts`
- Modify: `apps/api/package.json` (devDependency `@types/multer`)
- Test: `apps/api/src/contributions/contributions.controller.spec.ts` (สร้างใหม่)

**Interfaces:**
- Consumes: `parsePaymentFile` (Task 1), `PaymentReconciliationService.reconcile` (Task 2-3),
  `ContributionsService.processPaymentUpload` (ของเดิม `contributions.service.ts:1030`)
- Produces: response ของ `POST /contributions/upload` ที่รวมผล reconcile เข้ากับ field เดิม
  (`success`, `failed`, `notFound`, `errors`) เพื่อไม่ให้หน้าจอปัจจุบันพัง

- [ ] **Step 1: ติดตั้ง type ของ multer**

`FileInterceptor` ต้องการ type `Express.Multer.File` ซึ่งยังไม่มีในโปรเจกต์

```bash
cd apps/api && pnpm add -D @types/multer
```

- [ ] **Step 2: Write the failing test**

สร้าง `apps/api/src/contributions/contributions.controller.spec.ts`

```ts
import { ContributionsController } from './contributions.controller';
import { ContributionsService } from './contributions.service';
import { PaymentReconciliationService } from './payment-reconciliation.service';
import * as XLSX from 'xlsx';

function xlsxFile(rows: string[][]): Express.Multer.File {
  const sheet = XLSX.utils.aoa_to_sheet(rows);
  const book = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(book, sheet, 'Sheet1');
  return {
    buffer: XLSX.write(book, { type: 'buffer', bookType: 'xlsx' }) as Buffer,
    originalname: 'payment.xlsx',
  } as Express.Multer.File;
}

describe('ContributionsController.uploadPaymentFile', () => {
  let controller: ContributionsController;
  let contributions: { processPaymentUpload: jest.Mock; findPeriodByYearMonth: jest.Mock };
  let reconciliation: { reconcile: jest.Mock };

  beforeEach(() => {
    contributions = {
      processPaymentUpload: jest
        .fn()
        .mockResolvedValue({ success: 1, failed: 0, notFound: 0, errors: [] }),
      findPeriodByYearMonth: jest.fn().mockResolvedValue({ id: 'p1' }),
    };
    reconciliation = {
      reconcile: jest.fn().mockResolvedValue({
        scope: { fullDistrict: false, schools: [] },
        summary: {
          expected: 2, paid: 1, alreadyPaid: 0, missingFromFile: 1,
          inFileNotPaid: 0, unknownInFile: 0, markedArrears: 1,
        },
        missing: [{ memberNo: 'M2', reason: 'NOT_IN_FILE' }],
        unknown: [],
      }),
    };

    controller = new ContributionsController(
      contributions as unknown as ContributionsService,
      reconciliation as unknown as PaymentReconciliationService,
    );
  });

  it('อ่านไฟล์ที่แนบมา แล้วคืนทั้งผล reconcile และ field เดิม', async () => {
    const file = xlsxFile([
      ['เลขสมาชิก', 'สถานะ'],
      ['M0001', 'ชำระแล้ว'],
    ]);

    const result = await controller.uploadPaymentFile(
      file,
      { year: '2026', month: '8', fullDistrict: 'false', autoMarkArrears: 'true' },
      { user: { id: 'u1', role: 'ADMIN' } } as never,
    );

    expect(contributions.processPaymentUpload).toHaveBeenCalled();
    expect(reconciliation.reconcile).toHaveBeenCalledWith(
      expect.objectContaining({ periodId: 'p1', fullDistrict: false, autoMarkArrears: true }),
    );
    expect(result.summary.missingFromFile).toBe(1);
    expect(result.success).toBe(1);
    expect(result.errors).toEqual([]);
  });

  it('ยังรับ body JSON แบบเดิมได้เมื่อไม่มีไฟล์แนบ', async () => {
    const result = await controller.uploadPaymentFile(
      undefined as unknown as Express.Multer.File,
      { year: '2026', month: '8', data: [{ เลขสมาชิก: 'M0001', สถานะ: 'ชำระแล้ว' }] },
      { user: { id: 'u1', role: 'ADMIN' } } as never,
    );

    expect(contributions.processPaymentUpload).toHaveBeenCalled();
    expect(result.success).toBe(1);
  });

  it('รายงานแถวที่เลขสมาชิกซ้ำเข้า errors', async () => {
    const file = xlsxFile([
      ['เลขสมาชิก', 'สถานะ'],
      ['M0001', 'ยังไม่ชำระ'],
      ['M0001', 'ชำระแล้ว'],
    ]);

    const result = await controller.uploadPaymentFile(
      file,
      { year: '2026', month: '8' },
      { user: { id: 'u1', role: 'ADMIN' } } as never,
    );

    expect(result.errors).toContainEqual(
      expect.objectContaining({ memberNo: 'M0001', error: expect.stringContaining('ซ้ำ') }),
    );
  });
});
```

- [ ] **Step 3: Run test to verify it fails**

Run: `cd apps/api && npx jest src/contributions/contributions.controller.spec.ts`
Expected: FAIL — constructor รับ argument เดียว และยังไม่มี `findPeriodByYearMonth`

- [ ] **Step 4: เพิ่มเมธอดหา period จาก ปี/เดือน**

ใน `contributions.service.ts` เพิ่ม (วางถัดจาก `findPeriodById`)

```ts
  async findPeriodByYearMonth(year: number, month: number) {
    const period = await this.prisma.contributionPeriod.findUnique({
      where: { year_month: { year, month } },
    });
    if (!period) {
      throw new NotFoundException(`ไม่พบงวดสำหรับเดือน ${month} ปี ${year}`);
    }
    return period;
  }
```

- [ ] **Step 5: เขียน endpoint ใหม่**

แทนที่ `contributions.controller.ts:193-206` ด้วย

```ts
  @Post('upload')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  @UseInterceptors(FileInterceptor('file', { limits: { fileSize: 5 * 1024 * 1024 } }))
  async uploadPaymentFile(
    @UploadedFile() file: Express.Multer.File | undefined,
    @Body() body: UploadPaymentDto,
    @Request() req: { user: ScopedUser },
  ) {
    const year = Number(body.year);
    const month = Number(body.month);
    const fullDistrict = body.fullDistrict === 'true' || body.fullDistrict === true;
    const autoMarkArrears = !(body.autoMarkArrears === 'false' || body.autoMarkArrears === false);

    const period = await this.contributionsService.findPeriodByYearMonth(year, month);

    const parsed = file
      ? parsePaymentFile(file.buffer)
      : {
          rows: (body.data ?? []).map((row, index) => ({
            rowNo: index + 2,
            memberNo: String(row['เลขสมาชิก'] ?? '').trim(),
            isPaid: isPaidStatus(row['สถานะ']),
            amount: row['ยอดที่ต้องชำระ'] ? Number(row['ยอดที่ต้องชำระ']) : undefined,
          })).filter((row) => row.memberNo !== ''),
          duplicates: [],
        };

    const uploadResult = await this.contributionsService.processPaymentUpload(
      year,
      month,
      parsed.rows.map((row) => ({
        เลขสมาชิก: row.memberNo,
        ยอดที่ต้องชำระ: row.amount,
        สถานะ: row.isPaid ? 'ชำระแล้ว' : 'ยังไม่ชำระ',
      })),
      req.user,
    );

    const reconcileResult = await this.reconciliationService.reconcile({
      periodId: period.id,
      parsed,
      paidNowMemberNos: new Set(parsed.rows.filter((r) => r.isPaid).map((r) => r.memberNo)),
      actor: req.user,
      fullDistrict,
      autoMarkArrears,
    });

    return {
      ...reconcileResult,
      success: uploadResult.success,
      failed: uploadResult.failed,
      notFound: uploadResult.notFound,
      errors: [
        ...uploadResult.errors,
        ...parsed.duplicates.map((dup) => ({
          memberNo: dup.memberNo,
          error: `เลขสมาชิกซ้ำในไฟล์ (บรรทัด ${dup.rowNo}) — ระบบใช้แถวเดียวเท่านั้น`,
        })),
      ],
    };
  }
```

เพิ่ม import ที่หัวไฟล์

```ts
import { UploadedFile, UseInterceptors } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { parsePaymentFile, isPaidStatus } from './payment-file.parser';
import { PaymentReconciliationService } from './payment-reconciliation.service';
import { UploadPaymentDto } from './dto/upload-payment.dto';
```

และเพิ่ม constructor parameter

```ts
  constructor(
    private readonly contributionsService: ContributionsService,
    private readonly reconciliationService: PaymentReconciliationService,
  ) {}
```

- [ ] **Step 6: สร้าง DTO**

สร้าง `apps/api/src/contributions/dto/upload-payment.dto.ts`

```ts
import { IsOptional, IsNumberString, IsArray } from 'class-validator';

export class UploadPaymentDto {
  @IsNumberString()
  year!: string;

  @IsNumberString()
  month!: string;

  /** multipart ส่งมาเป็น string เสมอ */
  @IsOptional()
  fullDistrict?: string | boolean;

  @IsOptional()
  autoMarkArrears?: string | boolean;

  /** รูปแบบเดิม: ส่งแถวเป็น JSON โดยไม่แนบไฟล์ */
  @IsOptional()
  @IsArray()
  data?: Array<Record<string, string | number | undefined>>;
}
```

- [ ] **Step 7: ลงทะเบียน provider**

ใน `contributions.module.ts` เพิ่ม `PaymentReconciliationService` เข้า `providers`

```ts
import { PaymentReconciliationService } from './payment-reconciliation.service';

@Module({
  imports: [MembersModule, ReceiptsModule, CommonModule, BankAccountsModule],
  controllers: [ContributionsController],
  providers: [ContributionsService, PaymentReconciliationService],
  exports: [ContributionsService],
})
export class ContributionsModule {}
```

- [ ] **Step 8: Run tests to verify they pass**

Run: `cd apps/api && npx jest src/contributions`
Expected: PASS — ทุกไฟล์ใน contributions รวมของเดิมด้วย

- [ ] **Step 9: Commit**

```bash
git add apps/api/src/contributions apps/api/package.json ../../pnpm-lock.yaml
git commit -m "feat(contributions): accept real Excel upload and return reconciliation result"
```

---

### Task 5: Template .xlsx ที่รวมสมาชิกทุกคน

**Files:**
- Modify: `apps/api/src/contributions/contributions.service.ts:970-1025` (`generatePaymentTemplate`)
- Modify: `apps/api/src/contributions/contributions.controller.ts:180-191` (`getPaymentTemplate`)
- Create: `apps/api/src/contributions/payment-workbook.ts`
- Test: `apps/api/src/contributions/payment-workbook.spec.ts`

**Interfaces:**
- Produces:
  ```ts
  export function buildWorkbookBuffer(sheetName: string, rows: Array<Record<string, string | number>>): Buffer
  ```
  ใช้ทั้ง Task 5 (template) และ Task 6 (รายชื่อที่ขาด)

- [ ] **Step 1: Write the failing test**

สร้าง `apps/api/src/contributions/payment-workbook.spec.ts`

```ts
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd apps/api && npx jest src/contributions/payment-workbook.spec.ts`
Expected: FAIL — `Cannot find module './payment-workbook'`

- [ ] **Step 3: Write minimal implementation**

สร้าง `apps/api/src/contributions/payment-workbook.ts`

```ts
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
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd apps/api && npx jest src/contributions/payment-workbook.spec.ts`
Expected: PASS — 2 tests

- [ ] **Step 5: แก้ template ให้รวมสมาชิกทุกคน**

ใน `contributions.service.ts` แก้ `generatePaymentTemplate` — ลบ `salaryDeduction: true` ออกจาก
`where` (บรรทัด 984) และเพิ่ม `salaryDeduction: true` เข้า `select` ของ member เพื่อใช้ทำคอลัมน์ใหม่
แล้วเพิ่มคอลัมน์ใน `excelData`

```ts
      const contribution = member.contributions[0];
      return {
        'เลขสมาชิก': member.memberNo,
        'ชื่อ': member.associationMember?.firstName ?? '',
        'นามสกุล': member.associationMember?.lastName ?? '',
        'โรงเรียน': member.school.name,
        'รหัสโรงเรียน': member.school.code,
        'ประเภท': member.associationMember?.memberType?.name ?? '',
        'วิธีชำระ': member.salaryDeduction ? 'หักเงินเดือน' : 'จ่ายเอง',
        'ยอดที่ต้องชำระ': contribution ? Number(contribution.totalAmount) : defaultTotalAmount,
        'สถานะ': contribution && Number(contribution.paidAmount) > 0 ? 'ชำระแล้ว' : 'ยังไม่ชำระ',
      };
```

- [ ] **Step 6: ให้ endpoint ออกไฟล์ .xlsx**

แทนที่ `contributions.controller.ts:180-191`

```ts
  @Get('template')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  async getPaymentTemplate(
    @Query('year') year: number,
    @Query('month') month: number,
    @Query('format') format: string | undefined,
    @Res({ passthrough: true }) res: Response,
  ) {
    const resolvedYear = Number(year) || new Date().getFullYear();
    const resolvedMonth = Number(month) || new Date().getMonth() + 1;
    const template = await this.contributionsService.generatePaymentTemplate(
      resolvedYear,
      resolvedMonth,
    );

    if (format === 'json') {
      return template;
    }

    const buffer = buildWorkbookBuffer('รายชื่อเก็บเงิน', template.members);
    res.setHeader(
      'Content-Type',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    );
    res.setHeader(
      'Content-Disposition',
      `attachment; filename="payment-template-${resolvedYear}-${String(resolvedMonth).padStart(2, '0')}.xlsx"`,
    );
    return new StreamableFile(buffer);
  }
```

เพิ่ม import: `StreamableFile`, `Res` จาก `@nestjs/common`, `Response` จาก `express`,
`buildWorkbookBuffer` จาก `./payment-workbook`

- [ ] **Step 7: Run tests**

Run: `cd apps/api && npx jest src/contributions`
Expected: PASS ทั้งหมด

- [ ] **Step 8: Commit**

```bash
git add apps/api/src/contributions
git commit -m "feat(contributions): serve payment template as real xlsx covering every active member"
```

---

### Task 6: ดาวน์โหลดรายชื่อที่ขาดเป็น .xlsx

**Files:**
- Modify: `apps/api/src/contributions/contributions.controller.ts` (เพิ่ม endpoint)
- Modify: `apps/api/src/contributions/payment-reconciliation.service.ts` (เพิ่มเมธอด export)
- Test: `apps/api/src/contributions/payment-reconciliation.service.spec.ts` (เพิ่ม describe block)

**Interfaces:**
- Consumes: `MissingRow` (Task 2), `buildWorkbookBuffer` (Task 5)
- Produces:
  ```ts
  buildMissingWorkbook(missing: MissingRow[], actor?: ScopedUser): Promise<Buffer>
  ```
  ตรวจซ้ำว่าทุก `memberNo` อยู่ในขอบเขตโรงเรียนของผู้ใช้ก่อนสร้างไฟล์ — กันคนส่ง payload ปลอมเพื่อ
  ดูดรายชื่อข้ามโรงเรียน

- [ ] **Step 1: Write the failing test**

เพิ่มใน `payment-reconciliation.service.spec.ts`

```ts
  describe('buildMissingWorkbook', () => {
    const row = {
      memberId: 'id-M2', contributionId: 'c-M2', memberNo: 'M2', fullName: 'ชื่อ M2',
      schoolId: 's1', schoolCode: 'A', schoolName: 'ร.ร.A', groupName: 'กลุ่ม 1',
      amountDue: 100, reason: 'NOT_IN_FILE' as const,
    };

    it('สร้างไฟล์ที่อ่านกลับได้ตามรายชื่อที่ส่งมา', async () => {
      prisma.member.findMany.mockResolvedValueOnce([{ memberNo: 'M2', schoolId: 's1' }]);

      const buffer = await service.buildMissingWorkbook([row]);

      const XLSX = await import('xlsx');
      const book = XLSX.read(buffer, { type: 'buffer' });
      const rows = XLSX.utils.sheet_to_json<Record<string, unknown>>(book.Sheets[book.SheetNames[0]]);
      expect(rows[0]).toMatchObject({ เลขสมาชิก: 'M2', เหตุผล: 'ไม่มีในไฟล์' });
    });

    it('ตัดรายชื่อที่อยู่นอกขอบเขตโรงเรียนของผู้ใช้ทิ้ง', async () => {
      resolveSchoolId.mockReturnValue('s9');
      prisma.member.findMany.mockResolvedValueOnce([]);

      const buffer = await service.buildMissingWorkbook([row], {
        id: 'u2', role: Role.SCHOOL_ADMIN, schoolId: 's9',
      });

      const XLSX = await import('xlsx');
      const book = XLSX.read(buffer, { type: 'buffer' });
      const rows = XLSX.utils.sheet_to_json(book.Sheets[book.SheetNames[0]]);
      expect(rows).toEqual([]);
    });
  });
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd apps/api && npx jest src/contributions/payment-reconciliation.service.spec.ts`
Expected: FAIL — `service.buildMissingWorkbook is not a function`

- [ ] **Step 3: Write minimal implementation**

เพิ่มใน `payment-reconciliation.service.ts`

```ts
import { buildWorkbookBuffer } from './payment-workbook';

const REASON_LABEL: Record<MissingReason, string> = {
  NOT_IN_FILE: 'ไม่มีในไฟล์',
  IN_FILE_NOT_PAID: 'อยู่ในไฟล์ แต่ยังไม่ชำระ',
};

  async buildMissingWorkbook(missing: MissingRow[], actor?: ScopedUser): Promise<Buffer> {
    const forcedSchoolId = actor ? this.schoolScope.resolveSchoolId(actor) : undefined;

    // ตรวจซ้ำกับฐานข้อมูล ไม่เชื่อ payload ที่ client ส่งกลับมา
    const allowed = await this.prisma.member.findMany({
      where: {
        memberNo: { in: missing.map((row) => row.memberNo) },
        ...(forcedSchoolId ? { schoolId: forcedSchoolId } : {}),
      },
      select: { memberNo: true, schoolId: true },
    });
    const allowedNos = new Set(allowed.map((m) => m.memberNo));

    const rows = missing
      .filter((row) => allowedNos.has(row.memberNo))
      .map((row) => ({
        เลขสมาชิก: row.memberNo,
        'ชื่อ-สกุล': row.fullName,
        โรงเรียน: row.schoolName,
        กลุ่มเก็บเงิน: row.groupName,
        ยอดที่ต้องชำระ: row.amountDue,
        เหตุผล: REASON_LABEL[row.reason],
      }));

    return buildWorkbookBuffer('รายชื่อที่ขาด', rows);
  }
```

- [ ] **Step 4: เพิ่ม endpoint**

ใน `contributions.controller.ts`

```ts
  @Post('periods/:id/missing/export')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  async exportMissing(
    @Param('id') id: string,
    @Body() body: { missing: MissingRow[] },
    @Request() req: { user: ScopedUser },
    @Res({ passthrough: true }) res: Response,
  ) {
    const buffer = await this.reconciliationService.buildMissingWorkbook(
      body.missing ?? [],
      req.user,
    );
    res.setHeader(
      'Content-Type',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    );
    res.setHeader('Content-Disposition', `attachment; filename="missing-${id}.xlsx"`);
    return new StreamableFile(buffer);
  }
```

เพิ่ม import `MissingRow` จาก `./payment-reconciliation.service`

- [ ] **Step 5: Run tests**

Run: `cd apps/api && npx jest src/contributions`
Expected: PASS ทั้งหมด

- [ ] **Step 6: Commit**

```bash
git add apps/api/src/contributions
git commit -m "feat(contributions): export the missing-member list as xlsx with scope re-check"
```

---

### Task 7: หน้าเว็บ — modal อัปโหลด

**Files:**
- Create: `apps/web/src/app/(dashboard)/contributions/matrix/UploadPaymentModal.tsx`

**Interfaces:**
- Consumes: `api` จาก `@/lib/api`, `showError` จาก `@/lib/toast`
  (หมายเหตุ: **อย่าใช้** `canSelectAllSchools` จาก `@/lib/school-scope` เพื่อคุม checkbox ทั้งอำเภอ —
  ฟังก์ชันนั้นคืน true เฉพาะ `ADMIN` แต่ spec ให้ `FINANCE` เห็นด้วย ผู้เรียกต้องส่ง
  `canUseFullDistrict` เข้ามาเอง)
- Produces:
  ```tsx
  export interface ReconcileResponse {
    scope: { fullDistrict: boolean; schools: Array<{ id: string; code: string; name: string }> };
    summary: { expected: number; paid: number; alreadyPaid: number; missingFromFile: number;
               inFileNotPaid: number; unknownInFile: number; markedArrears: number };
    missing: Array<{ memberNo: string; fullName: string; schoolCode: string; schoolName: string;
                     groupName: string; amountDue: number; reason: 'NOT_IN_FILE' | 'IN_FILE_NOT_PAID' }>;
    unknown: Array<{ rowNo: number; memberNo: string }>;
    success: number; failed: number; notFound: number;
    errors: Array<{ memberNo: string; error: string }>;
  }
  export function UploadPaymentModal(props: {
    year: number; month: number; canUseFullDistrict: boolean;
    onClose: () => void; onDone: (result: ReconcileResponse) => void;
  }): JSX.Element
  ```

- [ ] **Step 1: เขียน component**

```tsx
'use client';

import { useState } from 'react';
import { Upload, X } from 'lucide-react';
import { api } from '@/lib/api';
import { showError } from '@/lib/toast';

export interface ReconcileResponse {
  scope: { fullDistrict: boolean; schools: Array<{ id: string; code: string; name: string }> };
  summary: {
    expected: number; paid: number; alreadyPaid: number; missingFromFile: number;
    inFileNotPaid: number; unknownInFile: number; markedArrears: number;
  };
  missing: Array<{
    memberNo: string; fullName: string; schoolCode: string; schoolName: string;
    groupName: string; amountDue: number; reason: 'NOT_IN_FILE' | 'IN_FILE_NOT_PAID';
  }>;
  unknown: Array<{ rowNo: number; memberNo: string }>;
  success: number; failed: number; notFound: number;
  errors: Array<{ memberNo: string; error: string }>;
}

export function UploadPaymentModal({
  year, month, canUseFullDistrict, onClose, onDone,
}: {
  year: number; month: number; canUseFullDistrict: boolean;
  onClose: () => void; onDone: (result: ReconcileResponse) => void;
}) {
  const [file, setFile] = useState<File | null>(null);
  const [fullDistrict, setFullDistrict] = useState(false);
  const [autoMarkArrears, setAutoMarkArrears] = useState(true);
  const [busy, setBusy] = useState(false);

  const submit = async () => {
    if (!file) {
      showError('กรุณาเลือกไฟล์ก่อน');
      return;
    }
    setBusy(true);
    try {
      const form = new FormData();
      form.append('file', file);
      form.append('year', String(year));
      form.append('month', String(month));
      form.append('fullDistrict', String(fullDistrict));
      form.append('autoMarkArrears', String(autoMarkArrears));

      const response = await api.post<ReconcileResponse>('/contributions/upload', form, {
        headers: { 'Content-Type': 'multipart/form-data' },
      });
      onDone(response.data);
    } catch (error) {
      const message =
        (error as { response?: { data?: { message?: string } } }).response?.data?.message ??
        'อัปโหลดไม่สำเร็จ';
      showError(message);
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl w-full max-w-md p-5">
        <div className="flex items-center justify-between mb-4">
          <h2 className="font-semibold text-slate-800">อัปโหลดไฟล์เก็บเงิน</h2>
          <button onClick={onClose} className="p-1 text-slate-400 hover:text-slate-600">
            <X size={18} />
          </button>
        </div>

        <input
          type="file"
          accept=".csv,.xlsx,.xls"
          onChange={(e) => setFile(e.target.files?.[0] ?? null)}
          className="w-full border border-slate-200 rounded-xl p-2 text-sm"
        />

        <label className="flex items-center gap-2 mt-4 text-sm text-slate-700">
          <input
            type="checkbox"
            checked={autoMarkArrears}
            onChange={(e) => setAutoMarkArrears(e.target.checked)}
          />
          บันทึกค้างชำระอัตโนมัติให้คนที่ขาด
        </label>

        {canUseFullDistrict && (
          <label className="flex items-center gap-2 mt-2 text-sm text-slate-700">
            <input
              type="checkbox"
              checked={fullDistrict}
              onChange={(e) => setFullDistrict(e.target.checked)}
            />
            ไฟล์นี้คือรายชื่อครบทั้งอำเภอ
          </label>
        )}

        <button
          onClick={submit}
          disabled={busy || !file}
          className="mt-5 w-full bg-primary-600 text-white rounded-xl py-2 text-sm font-medium disabled:opacity-40 flex items-center justify-center gap-2"
        >
          <Upload size={16} />
          {busy ? 'กำลังตรวจสอบ…' : 'ตรวจสอบและบันทึก'}
        </button>
      </div>
    </div>
  );
}
```

- [ ] **Step 2: ตรวจว่า build ผ่าน**

Run: `pnpm build:web`
Expected: สำเร็จ ไม่มี type error

- [ ] **Step 3: Commit**

```bash
git add "apps/web/src/app/(dashboard)/contributions/matrix/UploadPaymentModal.tsx"
git commit -m "feat(web): payment upload modal with full-district and auto-arrears options"
```

---

### Task 8: หน้าเว็บ — แผงผลการกระทบยอด

**Files:**
- Create: `apps/web/src/app/(dashboard)/contributions/matrix/ReconcileResultPanel.tsx`

**Interfaces:**
- Consumes: `ReconcileResponse` จาก Task 7, `api`, `showError`
- Produces:
  ```tsx
  export function ReconcileResultPanel(props: {
    result: ReconcileResponse; periodId: string; onClose: () => void; onSendNotice: () => void;
  }): JSX.Element
  ```

- [ ] **Step 1: เขียน component**

```tsx
'use client';

import { useMemo } from 'react';
import { AlertTriangle, Download, X } from 'lucide-react';
import { api } from '@/lib/api';
import { showError } from '@/lib/toast';
import type { ReconcileResponse } from './UploadPaymentModal';

const REASON_LABEL = {
  NOT_IN_FILE: 'ไม่มีในไฟล์',
  IN_FILE_NOT_PAID: 'อยู่ในไฟล์ แต่ยังไม่ชำระ',
} as const;

const REASON_CLASS = {
  NOT_IN_FILE: 'bg-red-50 text-red-700',
  IN_FILE_NOT_PAID: 'bg-amber-50 text-amber-700',
} as const;

export function ReconcileResultPanel({
  result, periodId, onClose, onSendNotice,
}: {
  result: ReconcileResponse; periodId: string; onClose: () => void; onSendNotice: () => void;
}) {
  const bySchool = useMemo(() => {
    const map = new Map<string, ReconcileResponse['missing']>();
    for (const row of result.missing) {
      const list = map.get(row.schoolName) ?? [];
      list.push(row);
      map.set(row.schoolName, list);
    }
    return [...map.entries()];
  }, [result.missing]);

  const missingCount = result.missing.length;

  const download = async () => {
    try {
      const response = await api.post(
        `/contributions/periods/${periodId}/missing/export`,
        { missing: result.missing },
        { responseType: 'blob' },
      );
      const url = URL.createObjectURL(response.data as Blob);
      const link = document.createElement('a');
      link.href = url;
      link.download = 'รายชื่อที่ขาด.xlsx';
      link.click();
      URL.revokeObjectURL(url);
    } catch {
      showError('ดาวน์โหลดรายชื่อไม่สำเร็จ');
    }
  };

  return (
    <div className="bg-white rounded-2xl border border-slate-200 p-5 mt-4">
      <div className="flex items-center justify-between mb-4">
        <h2 className="font-semibold text-slate-800">ผลการกระทบยอด</h2>
        <button onClick={onClose} className="p-1 text-slate-400 hover:text-slate-600">
          <X size={18} />
        </button>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-4">
        {[
          { label: 'ต้องเก็บ', value: result.summary.expected, tone: 'text-slate-800' },
          { label: 'เก็บได้', value: result.summary.paid + result.summary.alreadyPaid, tone: 'text-emerald-600' },
          { label: 'ขาด', value: missingCount, tone: 'text-red-600' },
          { label: 'ไม่รู้จัก', value: result.summary.unknownInFile, tone: 'text-amber-600' },
        ].map((card) => (
          <div key={card.label} className="rounded-xl bg-slate-50 p-3">
            <p className="text-xs text-slate-500">{card.label}</p>
            <p className={`text-2xl font-semibold ${card.tone}`}>{card.value}</p>
          </div>
        ))}
      </div>

      {missingCount > 0 && (
        <div className="flex items-center gap-2 rounded-xl bg-amber-50 text-amber-800 px-4 py-3 text-sm mb-4">
          <AlertTriangle size={18} />
          ขาด {missingCount} คน — ตรวจรายชื่อด้านล่างก่อนปิดงวด
          {result.summary.markedArrears > 0 && ` (บันทึกค้างชำระแล้ว ${result.summary.markedArrears} ราย)`}
        </div>
      )}

      {bySchool.map(([schoolName, rows]) => (
        <details key={schoolName} open className="mb-3">
          <summary className="cursor-pointer text-sm font-medium text-slate-700">
            {schoolName} — ขาด {rows.length} คน
          </summary>
          <table className="w-full text-sm mt-2">
            <thead>
              <tr className="text-left text-slate-500">
                <th className="py-1">เลขสมาชิก</th>
                <th>ชื่อ-สกุล</th>
                <th>กลุ่ม</th>
                <th className="text-right">ยอด</th>
                <th>เหตุผล</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((row) => (
                <tr key={row.memberNo} className="border-t border-slate-100">
                  <td className="py-1">{row.memberNo}</td>
                  <td>{row.fullName}</td>
                  <td>{row.groupName}</td>
                  <td className="text-right">{row.amountDue.toLocaleString('th-TH')}</td>
                  <td>
                    <span className={`px-2 py-0.5 rounded-lg text-xs ${REASON_CLASS[row.reason]}`}>
                      {REASON_LABEL[row.reason]}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </details>
      ))}

      {result.unknown.length > 0 && (
        <div className="mt-4">
          <p className="text-sm font-medium text-slate-700 mb-1">ไม่รู้จักในระบบ</p>
          <ul className="text-sm text-slate-600 list-disc pl-5">
            {result.unknown.map((row) => (
              <li key={`${row.rowNo}-${row.memberNo}`}>
                บรรทัด {row.rowNo}: {row.memberNo}
              </li>
            ))}
          </ul>
        </div>
      )}

      {result.errors.length > 0 && (
        <div className="mt-4">
          <p className="text-sm font-medium text-red-700 mb-1">รายการที่มีปัญหา</p>
          <ul className="text-sm text-red-600 list-disc pl-5">
            {result.errors.map((row, index) => (
              <li key={`${row.memberNo}-${index}`}>
                {row.memberNo}: {row.error}
              </li>
            ))}
          </ul>
        </div>
      )}

      <div className="flex flex-wrap gap-2 mt-5">
        <button
          onClick={download}
          disabled={missingCount === 0}
          className="flex items-center gap-2 border border-slate-200 rounded-xl px-4 py-2 text-sm disabled:opacity-40"
        >
          <Download size={16} />
          ดาวน์โหลดรายชื่อที่ขาด
        </button>
        <button
          onClick={onSendNotice}
          disabled={missingCount === 0}
          className="border border-amber-300 text-amber-800 rounded-xl px-4 py-2 text-sm disabled:opacity-40"
        >
          แจ้งเตือนค้างชำระ
        </button>
      </div>
    </div>
  );
}
```

- [ ] **Step 2: ตรวจว่า build ผ่าน**

Run: `pnpm build:web`
Expected: สำเร็จ

- [ ] **Step 3: Commit**

```bash
git add "apps/web/src/app/(dashboard)/contributions/matrix/ReconcileResultPanel.tsx"
git commit -m "feat(web): reconciliation result panel with missing list grouped by school"
```

---

### Task 9: ต่อเข้าหน้า matrix + ยืนยันจริงบนเบราว์เซอร์

**Files:**
- Modify: `apps/web/src/app/(dashboard)/contributions/matrix/page.tsx:368-466` (แทน `handleDownloadTemplate` และ `handleFileUpload`)

**Interfaces:**
- Consumes: `UploadPaymentModal`, `ReconcileResultPanel`, `ReconcileResponse` จาก Task 7-8

- [ ] **Step 1: แทน handleDownloadTemplate ด้วยการโหลด .xlsx**

```tsx
  const handleDownloadTemplate = async () => {
    try {
      const response = await api.get(
        `/contributions/template?year=${selectedYear}&month=${selectedMonth}`,
        { responseType: 'blob' },
      );
      const url = URL.createObjectURL(response.data as Blob);
      const link = document.createElement('a');
      link.href = url;
      link.download = `Template_การชำระเงิน_${selectedYear + 543}_${THAI_MONTHS_FULL[selectedMonth - 1]}.xlsx`;
      link.click();
      URL.revokeObjectURL(url);
      showSuccess('ดาวน์โหลด Template สำเร็จ');
    } catch {
      showError('เกิดข้อผิดพลาดในการดาวน์โหลด');
    }
  };
```

- [ ] **Step 2: ลบ handleFileUpload เดิมทิ้ง แล้วต่อ component ใหม่**

เพิ่ม state และ import

```tsx
import { UploadPaymentModal, type ReconcileResponse } from './UploadPaymentModal';
import { ReconcileResultPanel } from './ReconcileResultPanel';

  const [reconcileResult, setReconcileResult] = useState<ReconcileResponse | null>(null);
  const [reconcilePeriodId, setReconcilePeriodId] = useState<string>('');
```

แทนที่ modal เดิมด้วย

```tsx
      {showUploadModal && (
        <UploadPaymentModal
          year={selectedYear}
          month={selectedMonth}
          canUseFullDistrict={['ADMIN', 'FINANCE'].includes(user?.role ?? '')}
          onClose={() => setShowUploadModal(false)}
          onDone={(result) => {
            setShowUploadModal(false);
            setReconcileResult(result);
            queryClient.invalidateQueries({ queryKey: ['contribution-matrix'] });
            showSuccess(`บันทึกชำระ ${result.success} รายการ · ขาด ${result.missing.length} คน`);
          }}
        />
      )}

      {reconcileResult && (
        <ReconcileResultPanel
          result={reconcileResult}
          periodId={reconcilePeriodId}
          onClose={() => setReconcileResult(null)}
          onSendNotice={handleSendArrearsNotice}
        />
      )}
```

- [ ] **Step 3: เพิ่มปุ่มแจ้งเตือนที่ต้องยืนยัน**

```tsx
  const handleSendArrearsNotice = async () => {
    if (!reconcilePeriodId || !reconcileResult) return;
    const confirmed = window.confirm(
      `จะแจ้งเตือนค้างชำระ ${reconcileResult.missing.length} ราย\n` +
        'สมาชิกที่ครบเงื่อนไขตามระเบียบอาจถูกตัดสมาชิกภาพจากการดำเนินการนี้ ยืนยันหรือไม่',
    );
    if (!confirmed) return;

    try {
      const response = await api.post(
        `/contributions/periods/${reconcilePeriodId}/send-arrears-notice`,
      );
      showSuccess(response.data.message);
      queryClient.invalidateQueries({ queryKey: ['contribution-matrix'] });
    } catch {
      showError('แจ้งเตือนค้างชำระไม่สำเร็จ');
    }
  };
```

`reconcilePeriodId` มาจาก matrix data ของเดือนที่เลือก — ตั้งค่าตอนเปิด modal ด้วย
`setReconcilePeriodId(matrixData?.periods?.find((p) => p.month === selectedMonth)?.id ?? '')`
ถ้าโครงสร้าง `matrixData` ไม่มี `periods` ให้เรียก `GET /contributions/periods?year=<selectedYear>`
แล้วหาเดือนที่ตรงกัน

- [ ] **Step 4: Build ตรวจ type**

Run: `pnpm build:web`
Expected: สำเร็จ

- [ ] **Step 5: ยืนยันจริงบนเบราว์เซอร์**

1. `preview_start` ด้วย config ของโปรเจกต์ (`.claude/launch.json`)
2. เข้าหน้า `/contributions/matrix` เลือกปี/เดือนที่มีงวดเปิดอยู่
3. กดดาวน์โหลด Template แล้วเปิดไฟล์ที่ได้ ตรวจว่าเป็น .xlsx เปิดได้จริงและมีคอลัมน์ `วิธีชำระ`
4. แก้ไฟล์: ตั้งสถานะเป็น `ชำระแล้ว` ให้ทุกแถว แล้ว **ลบทิ้ง 2 แถว** บันทึกเป็น .xlsx
5. อัปโหลดไฟล์นั้น ตรวจว่าแผงผลขึ้น: `ขาด 2` และตารางแสดง 2 คนนั้นพร้อม badge `ไม่มีในไฟล์`
6. กดดาวน์โหลดรายชื่อที่ขาด เปิดไฟล์ตรวจว่ามี 2 แถว
7. `read_console_messages` ตรวจว่าไม่มี error
8. `computer {action: "screenshot"}` เก็บภาพแผงผลไว้แสดงผู้ใช้

- [ ] **Step 6: Commit**

```bash
git add "apps/web/src/app/(dashboard)/contributions/matrix/page.tsx"
git commit -m "feat(web): wire reconcile flow into contribution matrix page"
```

---

## Self-Review

**ครอบคลุม spec:** ทุกหัวข้อของ spec มี task รองรับ — 5.1 ขอบเขต (Task 2), 5.2 การจำแนก (Task 2),
5.3 API (Task 4-6), 5.4 parser (Task 1), 5.5 arrears/notice (Task 3, Task 9 Step 3),
5.6 หน้าจอ (Task 7-9), แผนทดสอบ 11 เคส (Task 1: 9,10,11 · Task 2: 1-6 · Task 3: 7 · งวดปิด: ของเดิม
`assertPeriodOpen` ใน `processPaymentUpload` ยังทำงานเหมือนเดิมและมีเทสต์เดิมคุมอยู่)

**ชื่อที่ต้องตรงกันข้ามงาน:** `parsePaymentFile` · `ParsedPaymentFile` · `PaymentReconciliationService.reconcile`
· `buildMissingWorkbook` · `buildWorkbookBuffer` · `ReconcileResponse` · `MissingRow` — ใช้ชื่อเดียวกัน
ทุกที่ในแผนนี้แล้ว

**ข้อควรระวังตอนรีวิว:** Task 4 เปลี่ยน constructor ของ controller — ถ้ามีเทสต์อื่นสร้าง controller
ตรง ๆ ต้องแก้ตาม (ตอนเขียนแผนยังไม่มีไฟล์ `contributions.controller.spec.ts` อยู่ก่อน)
