# Import สมาชิกฌาปนกิจ (clean + re-import) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** ล้างข้อมูลสมาชิกเดิมใน `cremation_db` แล้ว import สมาชิกฌาปนกิจ 603 คนจาก `doc/member/2.ฌาปนกิจ มฟล.xls` พร้อม enrich ข้อมูลจากอีก 3 ไฟล์ด้วยเลขบัตรประชาชน

**Architecture:** สคริปต์ TypeScript one-off ใน `apps/api/scripts/import-cremation-members/` รันด้วย ts-node. อ่าน Excel ด้วย SheetJS (`xlsx`, มีใน repo แล้ว) เป็น in-memory lookups → ล้างข้อมูลเดิม → build member records (แยกชื่อ + enrich) → insert ผ่าน Prisma → validate. Pure logic แยกไฟล์ทดสอบด้วย standalone ts-node assertion.

**Tech Stack:** TypeScript, ts-node, Prisma Client (`@prisma/client`), SheetJS (`xlsx` ^0.18.5), MySQL 8, `node:assert`

## Global Constraints

- **โครงสร้างไฟล์:** ทุกไฟล์อยู่ใน `apps/api/scripts/import-cremation-members/` — path ทั้งหมดในแผนนี้ relative ต่อ `apps/api/`
- **รันสคริปต์:** `npx ts-node --project tsconfig.json scripts/import-cremation-members/<file>.ts` (รันจากใน `apps/api/`)
- **Dates:** DB เก็บ Gregorian/ISO เท่านั้น — `joinDate` = `new Date('2026-01-01T00:00:00.000Z')` (1 ม.ค. 2569)
- **คำนำหน้า:** คงคำนำหน้าติดกับ `firstName` (เช่น `"นางสาวศิริพร"`), `lastName` = นามสกุลล้วน
- **memberNo:** running `M0001`–`M0603` เรียงตามลำดับแถวใน F1 (`M` + เลข 4 หลัก zero-pad)
- **ล้างเฉพาะ:** Beneficiary, ProtectedPerson, MemberContribution, LedgerEntry, DeathBenefitPayment, DeathClaim, Receipt, PaymentVoucher, Member, AssociationMember — **ห้ามแตะ** School, MemberType, SchoolCluster, Group, User, Account, BankAccount, ContributionPeriod, WelfareSettings, AppSetting, Asset, CashBook, BankTransaction
- **Fail loud:** ถ้า school code ใดของสมาชิก resolve ไม่ได้ (ไม่ใช่กลุ่ม 41 คน) → throw error พร้อมรายการ ห้ามเดา
- **DB creds (dev):** host `localhost`, user `root`, password ว่าง, db `cremation_db` (จาก `apps/api/.env` `DATABASE_URL`)
- **mysql/mysqldump binary:** `D:/laragon/bin/mysql/mysql-8.0.30-winx64/bin/` (Laragon)

### ไฟล์ต้นทาง (relative ต่อ repo root)
- F1: `doc/member/2.ฌาปนกิจ มฟล.xls` — sheet `Sheet1`, header row: `person_id | name | money`
- F2: `doc/member/new_teacher_in_saocr3.xls` — sheets `ขรก`, `ลจ.`, header: `Id personal | Name | Acc. | Branch | Remark`
- F3: `doc/member/new_ข้อมูลครู อ.แม่ฟ้าหลวง.xls` — sheet 0, **ไม่มี header**, cols: `[0]=เลขบัตร [1]=ชื่อ [2]=รหัสโรงเรียน`
- F4: `doc/member/member_data.xlsx` — 31 sheets (โรงเรียนละ sheet), R0-R1 หัวรายงาน, R3 header `ที่|ชื่อ-สกุล|ตำแหน่ง|เบอร์โทร`, R4+ ข้อมูล

Path จากใน `apps/api/`: `path.join(__dirname, '../../../../doc/member/<file>')` (scripts/import-cremation-members → apps/api → cremation root คือ `../../../`; ยืนยันด้วย `fs.existsSync` ใน Task 2)

---

## File Structure

| ไฟล์ | responsibility |
|---|---|
| `name-utils.ts` | pure: แยกชื่อไทย, normalize เลขบัตร, สร้าง name key |
| `name-utils.test.ts` | standalone assertion สำหรับ name-utils |
| `sources.ts` | อ่าน 4 ไฟล์ Excel → typed lookups (`SourceData`) |
| `sources.test.ts` | standalone: อ่านไฟล์จริง assert จำนวนแถว |
| `school-map.ts` | `ensureUnknownSchool`, `buildCodeToSchoolId` (code→schoolId + hardcode 410/417) |
| `build-records.ts` | `buildMemberRecords` — รวม enrich logic → `MemberRecord[]` |
| `build-records.test.ts` | standalone: build จากไฟล์จริง assert counts/ไม่ซ้ำ |
| `cleanup.ts` | `cleanupMemberData` — null-out refs + delete ตามรายการ |
| `index.ts` | main: backup → cleanup → build → insert → validate + report |

---

## Task 1: name-utils (pure functions) — แยกชื่อ / normalize เลขบัตร

**Files:**
- Create: `scripts/import-cremation-members/name-utils.ts`
- Test: `scripts/import-cremation-members/name-utils.test.ts`

**Interfaces:**
- Produces:
  - `normalizeIdCard(raw: unknown): string | null` — คืนเลข 13 หลัก (strip non-digit) หรือ null
  - `parseThaiName(raw: string): { firstName: string; lastName: string }` — คงคำนำหน้าใน firstName
  - `nameKey(raw: unknown): string | null` — strip คำนำหน้า + ช่องว่างทั้งหมด (ใช้ join by name)
  - `TITLES: string[]` — รายการคำนำหน้า (longest-first)

- [ ] **Step 1: เขียน test ที่ fail**

สร้าง `name-utils.test.ts`:

```typescript
import assert from 'node:assert';
import { normalizeIdCard, parseThaiName, nameKey } from './name-utils';

// normalizeIdCard
assert.strictEqual(normalizeIdCard('1501100007745'), '1501100007745');
assert.strictEqual(normalizeIdCard('1-5011-00007-74-5'), '1501100007745');
assert.strictEqual(normalizeIdCard('  3569900071638 '), '3569900071638');
assert.strictEqual(normalizeIdCard('123'), null);
assert.strictEqual(normalizeIdCard(null), null);
assert.strictEqual(normalizeIdCard(undefined), null);
assert.strictEqual(normalizeIdCard(1501100007745), '1501100007745'); // number input

// parseThaiName — คงคำนำหน้าใน firstName
assert.deepStrictEqual(parseThaiName('นางสาวศิริพร  ดวงดี'), { firstName: 'นางสาวศิริพร', lastName: 'ดวงดี' });
assert.deepStrictEqual(parseThaiName('นายเกรียงศักดิ์  ฝึกฝน'), { firstName: 'นายเกรียงศักดิ์', lastName: 'ฝึกฝน' });
assert.deepStrictEqual(parseThaiName('นาง  สมพร  ใจดี  มาก'), { firstName: 'นางสมพร', lastName: 'ใจดี มาก' });
assert.deepStrictEqual(parseThaiName('ว่าที่ร้อยตรีบรรจง สุทธสม'), { firstName: 'ว่าที่ร้อยตรีบรรจง', lastName: 'สุทธสม' });
// ไม่มีคำนำหน้า → firstName = token แรก
assert.deepStrictEqual(parseThaiName('สมชาย ใจดี'), { firstName: 'สมชาย', lastName: 'ใจดี' });
// ไม่มีนามสกุล
assert.deepStrictEqual(parseThaiName('นายสมชาย'), { firstName: 'นายสมชาย', lastName: '' });

// nameKey — strip title + ทุก whitespace
assert.strictEqual(nameKey('นางสาวศิริพร  ดวงดี'), 'ศิริพรดวงดี');
assert.strictEqual(nameKey('นาย เกรียงศักดิ์ ฝึกฝน'), 'เกรียงศักดิ์ฝึกฝน');
assert.strictEqual(nameKey(''), null);

console.log('name-utils: all assertions passed');
```

- [ ] **Step 2: รัน test ให้เห็น fail**

Run: `cd apps/api && npx ts-node --project tsconfig.json scripts/import-cremation-members/name-utils.test.ts`
Expected: FAIL — `Cannot find module './name-utils'`

- [ ] **Step 3: เขียน implementation ขั้นต่ำ**

สร้าง `name-utils.ts`:

```typescript
// คำนำหน้า เรียงยาว→สั้น เพื่อ match แบบ greedy (เช่น "นางสาว" ก่อน "นาง")
export const TITLES: string[] = [
  'ว่าที่ร้อยเอก', 'ว่าที่ร้อยโท', 'ว่าที่ร้อยตรี',
  'นางสาว', 'นาง', 'นาย',
  'ดร.', 'จ.ส.อ.', 'พ.จ.อ.', 'ส.อ.', 'ร.ต.',
];

export function normalizeIdCard(raw: unknown): string | null {
  if (raw === null || raw === undefined) return null;
  const digits = String(raw).replace(/\D/g, '');
  return digits.length === 13 ? digits : null;
}

/** คืนคำนำหน้าที่ match (longest-first) หรือ '' */
function detectTitle(s: string): string {
  for (const t of TITLES) {
    if (s.startsWith(t)) return t;
  }
  return '';
}

export function parseThaiName(raw: string): { firstName: string; lastName: string } {
  const collapsed = String(raw ?? '').replace(/\s+/g, ' ').trim();
  const title = detectTitle(collapsed.replace(/\s+/g, '')); // เทียบแบบไม่มีช่องว่าง
  // ตัด title ออกจากต้นสตริง (คำนำหน้าอาจมีช่องว่างคั่นจากชื่อ)
  let rest = collapsed;
  if (title) {
    // ลบ title ที่ต้นสตริงโดยไม่สนช่องว่างภายใน title
    const re = new RegExp('^' + title.split('').map((c) => c.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')).join('\\s*') + '\\s*');
    rest = collapsed.replace(re, '').trim();
  }
  const parts = rest.split(' ').filter(Boolean);
  const first = parts.length > 0 ? parts[0] : '';
  const last = parts.slice(1).join(' ');
  return { firstName: title + first, lastName: last };
}

export function nameKey(raw: unknown): string | null {
  if (raw === null || raw === undefined) return null;
  let s = String(raw);
  for (const t of TITLES) s = s.split(t).join('');
  s = s.replace(/\s+/g, '');
  return s.length > 0 ? s : null;
}
```

- [ ] **Step 4: รัน test ให้ผ่าน**

Run: `cd apps/api && npx ts-node --project tsconfig.json scripts/import-cremation-members/name-utils.test.ts`
Expected: PASS — `name-utils: all assertions passed`

- [ ] **Step 5: Commit**

```bash
git add apps/api/scripts/import-cremation-members/name-utils.ts apps/api/scripts/import-cremation-members/name-utils.test.ts
git commit -m "feat(import): add Thai name + id-card parsing utils for member import"
```

---

## Task 2: sources — อ่าน 4 ไฟล์ Excel → typed lookups

**Files:**
- Create: `scripts/import-cremation-members/sources.ts`
- Test: `scripts/import-cremation-members/sources.test.ts`

**Interfaces:**
- Consumes: `normalizeIdCard`, `nameKey` (Task 1)
- Produces:
  - `interface F2Info { type: 'ขรก' | 'ลจ.'; acc: string; branch: string; remark: string }`
  - `interface F4Info { position: string; phone: string; sheet: string }`
  - `interface SourceData {`
    - `f1: { idCard: string; rawName: string }[]` — เรียงตามไฟล์, กรอง money≠'100' ออกแล้ว, เฉพาะ idCard valid
    - `f2ById: Map<string, F2Info>`
    - `f3IdToCode: Map<string, string>` — เลขบัตร → รหัสโรงเรียน
    - `f3IdToName: Map<string, string>`
    - `f4NameToInfo: Map<string, F4Info>` — nameKey → info (เก็บครั้งแรกที่เจอ)
    - `f4SheetToTitle: Map<string, string>` — ชื่อ sheet → R1 (ชื่อโรงเรียนเต็ม)
    - `f4SheetNames: string[]`
  - `}`
  - `readAllSources(): SourceData`
  - `DOC_DIR: string` — absolute path ของ `doc/member`

- [ ] **Step 1: เขียน test ที่ fail**

สร้าง `sources.test.ts`:

```typescript
import assert from 'node:assert';
import * as fs from 'fs';
import { readAllSources, DOC_DIR } from './sources';

assert.ok(fs.existsSync(DOC_DIR), `DOC_DIR must exist: ${DOC_DIR}`);
const s = readAllSources();

// F1: 603 สมาชิกจริง (กรอง total row money=60300 ออกแล้ว)
assert.strictEqual(s.f1.length, 603, `f1 length = ${s.f1.length}`);
assert.ok(/^\d{13}$/.test(s.f1[0].idCard), 'f1[0].idCard is 13 digits');

// F2: ขรก ~2180 + ลจ ~18
assert.ok(s.f2ById.size >= 2190 && s.f2ById.size <= 2200, `f2 size = ${s.f2ById.size}`);
assert.ok(['ขรก', 'ลจ.'].includes([...s.f2ById.values()][0].type));

// F3: 609 คน มีรหัสโรงเรียน
assert.strictEqual(s.f3IdToCode.size, 609, `f3 size = ${s.f3IdToCode.size}`);

// F4: 31 sheets
assert.strictEqual(s.f4SheetNames.length, 31, `f4 sheets = ${s.f4SheetNames.length}`);
assert.ok(s.f4NameToInfo.size >= 700, `f4 names = ${s.f4NameToInfo.size}`);

console.log('sources: all assertions passed', {
  f1: s.f1.length, f2: s.f2ById.size, f3: s.f3IdToCode.size,
  f4names: s.f4NameToInfo.size, f4sheets: s.f4SheetNames.length,
});
```

- [ ] **Step 2: รัน test ให้เห็น fail**

Run: `cd apps/api && npx ts-node --project tsconfig.json scripts/import-cremation-members/sources.test.ts`
Expected: FAIL — `Cannot find module './sources'`

- [ ] **Step 3: เขียน implementation**

สร้าง `sources.ts`:

```typescript
import * as path from 'path';
import * as fs from 'fs';
import * as XLSX from 'xlsx';
import { normalizeIdCard, nameKey } from './name-utils';

export const DOC_DIR = path.join(__dirname, '../../../../doc/member');

const F1 = path.join(DOC_DIR, '2.ฌาปนกิจ มฟล.xls');
const F2 = path.join(DOC_DIR, 'new_teacher_in_saocr3.xls');
const F3 = path.join(DOC_DIR, 'new_ข้อมูลครู อ.แม่ฟ้าหลวง.xls');
const F4 = path.join(DOC_DIR, 'member_data.xlsx');

export interface F2Info { type: 'ขรก' | 'ลจ.'; acc: string; branch: string; remark: string }
export interface F4Info { position: string; phone: string; sheet: string }
export interface SourceData {
  f1: { idCard: string; rawName: string }[];
  f2ById: Map<string, F2Info>;
  f3IdToCode: Map<string, string>;
  f3IdToName: Map<string, string>;
  f4NameToInfo: Map<string, F4Info>;
  f4SheetToTitle: Map<string, string>;
  f4SheetNames: string[];
}

function cell(v: unknown): string {
  if (v === null || v === undefined) return '';
  const s = String(v).trim();
  return s === 'nan' ? '' : s;
}

/** อ่าน sheet เป็น array-of-arrays (raw, ไม่ใช้ header) */
function rows(file: string, sheet: string): unknown[][] {
  const wb = XLSX.readFile(file, { codepage: 65001 });
  const ws = wb.Sheets[sheet];
  return XLSX.utils.sheet_to_json(ws, { header: 1, raw: false, defval: '' }) as unknown[][];
}
function sheetNames(file: string): string[] {
  return XLSX.readFile(file, { bookSheets: true }).SheetNames;
}

export function readAllSources(): SourceData {
  // --- F1 ฌาปนกิจ: header row 0 = person_id|name|money ---
  const f1rows = rows(F1, 'Sheet1');
  const f1: { idCard: string; rawName: string }[] = [];
  for (let i = 1; i < f1rows.length; i++) {
    const r = f1rows[i];
    if (cell(r[2]) !== '100') continue; // ตัด total row (money=60300) และแถวว่าง
    const id = normalizeIdCard(r[0]);
    if (!id) continue;
    f1.push({ idCard: id, rawName: cell(r[1]) });
  }

  // --- F2 saocr3: 2 sheets, header row 0 ---
  const f2ById = new Map<string, F2Info>();
  for (const sh of ['ขรก', 'ลจ.'] as const) {
    const rr = rows(F2, sh);
    for (let i = 1; i < rr.length; i++) {
      const r = rr[i];
      const id = normalizeIdCard(r[0]);
      if (!id) continue;
      f2ById.set(id, { type: sh, acc: cell(r[2]), branch: cell(r[3]), remark: cell(r[4]) });
    }
  }

  // --- F3 แม่ฟ้าหลวง: sheet 0, ไม่มี header ---
  const f3Sheet = sheetNames(F3)[0];
  const f3rows = rows(F3, f3Sheet);
  const f3IdToCode = new Map<string, string>();
  const f3IdToName = new Map<string, string>();
  for (const r of f3rows) {
    const id = normalizeIdCard(r[0]);
    if (!id) continue;
    f3IdToCode.set(id, cell(r[2]));
    f3IdToName.set(id, cell(r[1]));
  }

  // --- F4 member_data: 31 sheets ---
  const f4SheetNames = sheetNames(F4);
  const f4NameToInfo = new Map<string, F4Info>();
  const f4SheetToTitle = new Map<string, string>();
  for (const sh of f4SheetNames) {
    const rr = rows(F4, sh);
    f4SheetToTitle.set(sh.trim(), rr.length > 1 ? cell(rr[1][0]) : '');
    for (const r of rr) {
      const c0 = cell(r[0]);
      const c1 = cell(r[1]);
      if (!/^\d+$/.test(c0) || !c1) continue; // แถวข้อมูล: col0 เป็นลำดับตัวเลข
      const k = nameKey(c1);
      if (!k || f4NameToInfo.has(k)) continue;
      // ตำแหน่ง/เบอร์: บาง sheet มีคอลัมน์เกิน (ชื่อแยก 2 ช่อง) — เก็บ 2 คอลัมน์ท้ายแบบ heuristic
      const position = cell(r[2]);
      const phone = cell(r[3]) || cell(r[r.length - 1]);
      f4NameToInfo.set(k, { position, phone, sheet: sh.trim() });
    }
  }

  return { f1, f2ById, f3IdToCode, f3IdToName, f4NameToInfo, f4SheetToTitle, f4SheetNames };
}
```

- [ ] **Step 4: รัน test ให้ผ่าน**

Run: `cd apps/api && npx ts-node --project tsconfig.json scripts/import-cremation-members/sources.test.ts`
Expected: PASS — `sources: all assertions passed { f1: 603, f2: ~2198, f3: 609, ... }`

> ถ้า f1 ≠ 603: ตรวจ codepage / total row filter. ถ้า path ผิด: แก้ `DOC_DIR` ให้ `fs.existsSync` ผ่าน (ลอง `../../../../doc/member` vs `../../../doc/member`).

- [ ] **Step 5: Commit**

```bash
git add apps/api/scripts/import-cremation-members/sources.ts apps/api/scripts/import-cremation-members/sources.test.ts
git commit -m "feat(import): read 4 source Excel files into typed lookups"
```

---

## Task 3: school-map — code→schoolId + โรงเรียน "ไม่ระบุ"

**Files:**
- Create: `scripts/import-cremation-members/school-map.ts`

**Interfaces:**
- Consumes: `SourceData`, `nameKey` (Task 1/2), `PrismaClient`
- Produces:
  - `ensureUnknownSchool(prisma: PrismaClient): Promise<string>` — upsert School `SCH_UNKNOWN` คืน id
  - `buildCodeToSchoolId(prisma: PrismaClient, s: SourceData): Promise<Map<string, string>>` — รหัส(401–433)→schoolId
  - `schoolNameKey(raw: string): string` — normalize ชื่อโรงเรียน (strip `โรงเรียน`/`รร.`/ช่องว่าง/วงเล็บ/จุด)

- [ ] **Step 1: เขียน implementation**

สร้าง `school-map.ts`:

```typescript
import { PrismaClient } from '@prisma/client';
import { nameKey } from './name-utils';
import type { SourceData } from './sources';

/** override สำหรับ 2 รหัสที่ auto-match ไม่ได้ (F4 sheet บ้านกลางแยกชื่อ 2 คอลัมน์) */
const HARDCODE_CODE_TO_SCHOOLNAME: Record<string, string> = {
  '410': 'ห้วยอื้น',
  '417': 'บ้านกลาง',
};

export function schoolNameKey(raw: string): string {
  let s = String(raw ?? '');
  s = s.replace(/โรงเรียน/g, '').replace(/รร\./g, '');
  s = s.replace(/[()（）.\s]/g, '');
  return s;
}

export async function ensureUnknownSchool(prisma: PrismaClient): Promise<string> {
  const existing = await prisma.school.findUnique({ where: { code: 'SCH_UNKNOWN' } });
  if (existing) return existing.id;
  const created = await prisma.school.create({
    data: { code: 'SCH_UNKNOWN', name: 'ไม่ระบุ/ส่วนกลาง', district: 'แม่ฟ้าหลวง', province: 'เชียงราย' },
  });
  return created.id;
}

export async function buildCodeToSchoolId(prisma: PrismaClient, s: SourceData): Promise<Map<string, string>> {
  const dbSchools = await prisma.school.findMany({ select: { id: true, code: true, name: true } });
  // index DB schools by normalized name key (เฉพาะ SCH_ ของจริง)
  const dbByKey = new Map<string, { id: string; name: string }>();
  for (const sc of dbSchools) {
    if (!sc.code.startsWith('SCH_')) continue;
    dbByKey.set(schoolNameKey(sc.name), { id: sc.id, name: sc.name });
  }
  const findDbByContains = (needleKey: string): string | null => {
    for (const [k, v] of dbByKey) if (k.includes(needleKey) || needleKey.includes(k)) return v.id;
    return null;
  };

  // code → dominant F4 sheet (จากคนใน F3 ที่ code นั้น แล้ว match ชื่อใน F4)
  const codeSheetVotes = new Map<string, Map<string, number>>();
  for (const [id, code] of s.f3IdToCode) {
    const k = nameKey(s.f3IdToName.get(id) ?? '');
    if (!k) continue;
    const info = s.f4NameToInfo.get(k);
    if (!info) continue;
    if (!codeSheetVotes.has(code)) codeSheetVotes.set(code, new Map());
    const m = codeSheetVotes.get(code)!;
    m.set(info.sheet, (m.get(info.sheet) ?? 0) + 1);
  }

  const codeToSchool = new Map<string, string>();
  const allCodes = new Set(s.f3IdToCode.values());
  const unresolved: string[] = [];

  for (const code of allCodes) {
    if (!code) continue;
    // 1) hardcode override
    if (HARDCODE_CODE_TO_SCHOOLNAME[code]) {
      const hit = findDbByContains(schoolNameKey(HARDCODE_CODE_TO_SCHOOLNAME[code]));
      if (hit) { codeToSchool.set(code, hit); continue; }
    }
    // 2) auto: dominant sheet → sheet title (R1) หรือ sheet name → DB school
    const votes = codeSheetVotes.get(code);
    if (votes && votes.size > 0) {
      const topSheet = [...votes.entries()].sort((a, b) => b[1] - a[1])[0][0];
      const title = s.f4SheetToTitle.get(topSheet) ?? '';
      const hit = findDbByContains(schoolNameKey(title)) ?? findDbByContains(schoolNameKey(topSheet));
      if (hit) { codeToSchool.set(code, hit); continue; }
    }
    unresolved.push(code);
  }

  if (unresolved.length > 0) {
    throw new Error(`buildCodeToSchoolId: ไม่สามารถ map school code: ${unresolved.join(', ')} — ต้องเพิ่ม HARDCODE`);
  }
  return codeToSchool;
}
```

- [ ] **Step 2: เขียน test แบบ inline (verify กับ DB จริง)**

สร้าง `school-map.test.ts`:

```typescript
import assert from 'node:assert';
import { PrismaClient } from '@prisma/client';
import { readAllSources } from './sources';
import { ensureUnknownSchool, buildCodeToSchoolId } from './school-map';

(async () => {
  const prisma = new PrismaClient();
  try {
    const s = readAllSources();
    const unknownId = await ensureUnknownSchool(prisma);
    assert.ok(unknownId, 'unknown school id');
    const map = await buildCodeToSchoolId(prisma, s);
    // ทุกรหัสใน F3 ต้อง map ได้ (ไม่ throw) และ 410/417 ต้องอยู่
    assert.ok(map.size >= 29, `mapped codes = ${map.size}`);
    assert.ok(map.has('410') && map.has('417'), 'hardcode 410/417 mapped');
    console.log('school-map: passed', { mappedCodes: map.size, unknownId });
  } finally {
    await prisma.$disconnect();
  }
})();
```

- [ ] **Step 3: รัน test**

Run: `cd apps/api && npx ts-node --project tsconfig.json scripts/import-cremation-members/school-map.test.ts`
Expected: PASS — `school-map: passed { mappedCodes: 31, ... }`

> ⚠️ test นี้สร้าง School `SCH_UNKNOWN` จริงใน DB (idempotent — upsert). ถ้า throw เรื่อง unresolved code: เพิ่ม code นั้นใน `HARDCODE_CODE_TO_SCHOOLNAME` พร้อมชื่อโรงเรียนที่ตรงกับ DB

- [ ] **Step 4: Commit**

```bash
git add apps/api/scripts/import-cremation-members/school-map.ts apps/api/scripts/import-cremation-members/school-map.test.ts
git commit -m "feat(import): map school codes to DB schools + ensure unknown school"
```

---

## Task 4: build-records — รวม enrich logic → MemberRecord[]

**Files:**
- Create: `scripts/import-cremation-members/build-records.ts`
- Test: `scripts/import-cremation-members/build-records.test.ts`

**Interfaces:**
- Consumes: `SourceData` (Task 2), `parseThaiName`, `normalizeIdCard` (Task 1), code→schoolId map + unknownId (Task 3)
- Produces:
  - `interface MemberRecord {`
    - `idCard: string; firstName: string; lastName: string;`
    - `schoolId: string; memberTypeCode: 'REG' | 'PERM'; memberNo: string;`
    - `phone: string | null; position: string | null; notes: string | null;`
    - `salaryDeduction: boolean;`
  - `}`
  - `interface BuildResult { records: MemberRecord[]; stats: { withSchoolCode: number; unknownSchool: number; enrichedBank: number; enrichedPosition: number; typeReg: number; typePerm: number; duplicateIdCards: string[] } }`
  - `buildMemberRecords(s: SourceData, codeToSchool: Map<string,string>, unknownSchoolId: string, memberTypeIdByCode: Map<'REG'|'PERM', string>): BuildResult`

  > หมายเหตุ: build-records คืน `memberTypeCode` (logical) — การแปลงเป็น `memberTypeId` ทำใน index.ts. ตัด param `memberTypeIdByCode` ออก (ไม่ใช้ในชั้นนี้) เพื่อความ pure. **แก้ interface: `buildMemberRecords(s, codeToSchool, unknownSchoolId): BuildResult`**

- [ ] **Step 1: เขียน test ที่ fail**

สร้าง `build-records.test.ts`:

```typescript
import assert from 'node:assert';
import { PrismaClient } from '@prisma/client';
import { readAllSources } from './sources';
import { ensureUnknownSchool, buildCodeToSchoolId } from './school-map';
import { buildMemberRecords } from './build-records';

(async () => {
  const prisma = new PrismaClient();
  try {
    const s = readAllSources();
    const unknownId = await ensureUnknownSchool(prisma);
    const codeMap = await buildCodeToSchoolId(prisma, s);
    const { records, stats } = buildMemberRecords(s, codeMap, unknownId);

    assert.strictEqual(records.length, 603, `records = ${records.length}`);
    // memberNo unique + รูปแบบถูก
    const nos = new Set(records.map((r) => r.memberNo));
    assert.strictEqual(nos.size, 603, 'memberNo unique');
    assert.strictEqual(records[0].memberNo, 'M0001');
    assert.strictEqual(records[602].memberNo, 'M0603');
    // idCard: valid 13 หลักทุกตัว
    assert.ok(records.every((r) => /^\d{13}$/.test(r.idCard)), 'all idCard 13 digits');
    // school resolution: 41 คนเข้า unknown
    assert.strictEqual(stats.unknownSchool, 41, `unknownSchool = ${stats.unknownSchool}`);
    assert.strictEqual(stats.withSchoolCode, 562, `withSchoolCode = ${stats.withSchoolCode}`);
    // type: ~571 REG จาก ขรก, ~1 PERM จาก ลจ (31 ไม่รู้ = REG)
    assert.ok(stats.typePerm >= 1, `typePerm = ${stats.typePerm}`);
    assert.strictEqual(stats.typeReg + stats.typePerm, 603, 'type total = 603');
    // firstName คงคำนำหน้า
    assert.ok(records.every((r) => r.firstName.length > 0 && r.lastName !== undefined));
    // ไม่มี idCard ซ้ำ (ถ้ามี report ไว้)
    console.log('build-records: passed', stats);
  } finally {
    await prisma.$disconnect();
  }
})();
```

- [ ] **Step 2: รัน test ให้เห็น fail**

Run: `cd apps/api && npx ts-node --project tsconfig.json scripts/import-cremation-members/build-records.test.ts`
Expected: FAIL — `Cannot find module './build-records'`

- [ ] **Step 3: เขียน implementation**

สร้าง `build-records.ts`:

```typescript
import { parseThaiName } from './name-utils';
import type { SourceData } from './sources';

export interface MemberRecord {
  idCard: string;
  firstName: string;
  lastName: string;
  schoolId: string;
  memberTypeCode: 'REG' | 'PERM';
  memberNo: string;
  phone: string | null;
  position: string | null;
  notes: string | null;
  salaryDeduction: boolean;
}

export interface BuildResult {
  records: MemberRecord[];
  stats: {
    withSchoolCode: number;
    unknownSchool: number;
    enrichedBank: number;
    enrichedPosition: number;
    typeReg: number;
    typePerm: number;
    duplicateIdCards: string[];
  };
}

function memberNo(i: number): string {
  return 'M' + String(i + 1).padStart(4, '0');
}

export function buildMemberRecords(
  s: SourceData,
  codeToSchool: Map<string, string>,
  unknownSchoolId: string,
): BuildResult {
  const records: MemberRecord[] = [];
  const stats = {
    withSchoolCode: 0, unknownSchool: 0, enrichedBank: 0, enrichedPosition: 0,
    typeReg: 0, typePerm: 0, duplicateIdCards: [] as string[],
  };
  const seen = new Set<string>();

  s.f1.forEach((row, i) => {
    const { idCard, rawName } = row;
    if (seen.has(idCard)) { stats.duplicateIdCards.push(idCard); return; }
    seen.add(idCard);

    const { firstName, lastName } = parseThaiName(rawName);

    // --- school ---
    const code = s.f3IdToCode.get(idCard);
    let schoolId: string;
    if (code && codeToSchool.has(code)) {
      schoolId = codeToSchool.get(code)!;
      stats.withSchoolCode++;
    } else {
      schoolId = unknownSchoolId;
      stats.unknownSchool++;
    }

    // --- type (from F2) ---
    const f2 = s.f2ById.get(idCard);
    const memberTypeCode: 'REG' | 'PERM' = f2?.type === 'ลจ.' ? 'PERM' : 'REG';
    if (memberTypeCode === 'PERM') stats.typePerm++; else stats.typeReg++;

    // --- enrich: notes (bank + สังกัดจริงถ้าเข้า unknown), phone, position ---
    const noteParts: string[] = [];
    let salaryDeduction = false;
    if (f2 && f2.acc) {
      noteParts.push(`บัญชีธนาคาร: ${f2.acc}${f2.branch ? ` สาขา ${f2.branch}` : ''}`);
      salaryDeduction = true;
      stats.enrichedBank++;
    }
    if (schoolId === unknownSchoolId && f2 && f2.remark) {
      noteParts.push(`สังกัดเดิม: ${f2.remark}`);
    }

    const f4 = s.f4NameToInfo.get(require('./name-utils').nameKey(rawName) ?? '');
    let position: string | null = null;
    let phone: string | null = null;
    if (f4) {
      position = f4.position ? f4.position.slice(0, 100) : null;
      phone = f4.phone || null;
      if (position) stats.enrichedPosition++;
    }

    records.push({
      idCard, firstName, lastName, schoolId, memberTypeCode,
      memberNo: memberNo(i),
      phone, position,
      notes: noteParts.length ? noteParts.join(' | ') : null,
      salaryDeduction,
    });
  });

  return { records, stats };
}
```

> **หมายเหตุ implementation:** เปลี่ยน `require('./name-utils').nameKey` เป็น import ปกติที่หัวไฟล์ — เพิ่ม `import { parseThaiName, nameKey } from './name-utils';` แล้วเรียก `nameKey(rawName)` ตรง ๆ. (แก้ตอนพิมพ์จริง — อย่าใช้ `require` กลางไฟล์)

แก้บรรทัด import หัวไฟล์เป็น:
```typescript
import { parseThaiName, nameKey } from './name-utils';
```
และบรรทัด f4 lookup เป็น:
```typescript
    const f4 = s.f4NameToInfo.get(nameKey(rawName) ?? '');
```

- [ ] **Step 4: รัน test ให้ผ่าน**

Run: `cd apps/api && npx ts-node --project tsconfig.json scripts/import-cremation-members/build-records.test.ts`
Expected: PASS — `build-records: passed { withSchoolCode: 562, unknownSchool: 41, typePerm: 1, ... }`

> ถ้า unknownSchool ≠ 41: ตรวจว่า codeToSchool มีครบทุก code (บาง code ใน F3 อาจ map ไม่ได้ → คนตกไป unknown เกิน). ดู stats แล้วเทียบกับผลวิเคราะห์ (562/41)

- [ ] **Step 5: Commit**

```bash
git add apps/api/scripts/import-cremation-members/build-records.ts apps/api/scripts/import-cremation-members/build-records.test.ts
git commit -m "feat(import): build enriched member records from sources"
```

---

## Task 5: cleanup — ล้างข้อมูลสมาชิกเดิมอย่างปลอดภัย

**Files:**
- Create: `scripts/import-cremation-members/cleanup.ts`

**Interfaces:**
- Consumes: `PrismaClient`
- Produces:
  - `cleanupMemberData(prisma: PrismaClient): Promise<{ before: Record<string, number>; after: Record<string, number> }>`

- [ ] **Step 1: เขียน implementation**

สร้าง `cleanup.ts`:

```typescript
import { PrismaClient } from '@prisma/client';

// ตารางที่ล้าง (ข้อมูล transactional ของสมาชิก/การเงิน — ทั้งหมดเป็นข้อมูล test)
const DELETE_TABLES = [
  'Beneficiary', 'ProtectedPerson', 'MemberContribution', 'LedgerEntry',
  'DeathBenefitPayment', 'DeathClaim', 'Receipt', 'PaymentVoucher',
  'Member', 'AssociationMember',
];

async function count(prisma: PrismaClient, table: string): Promise<number> {
  const rows = await prisma.$queryRawUnsafe<{ n: bigint }[]>(`SELECT COUNT(*) AS n FROM \`${table}\``);
  return Number(rows[0].n);
}

export async function cleanupMemberData(prisma: PrismaClient) {
  const snapshot = async () => {
    const o: Record<string, number> = {};
    for (const t of DELETE_TABLES) o[t] = await count(prisma, t);
    return o;
  };
  const before = await snapshot();

  await prisma.$transaction(async (tx) => {
    await tx.$executeRawUnsafe('SET FOREIGN_KEY_CHECKS = 0');
    // null-out refs ที่อ้าง Member แต่ไม่ลบตัวเอง
    await tx.$executeRawUnsafe('UPDATE `Group` SET leaderId = NULL');
    await tx.$executeRawUnsafe('UPDATE `User` SET memberId = NULL');
    for (const t of DELETE_TABLES) {
      await tx.$executeRawUnsafe(`DELETE FROM \`${t}\``);
    }
    await tx.$executeRawUnsafe('SET FOREIGN_KEY_CHECKS = 1');
  });

  const after = await snapshot();
  return { before, after };
}
```

- [ ] **Step 2: เขียน guarded test (ต้อง backup ก่อน)**

สร้าง `cleanup.test.ts` — **หมายเหตุ: test นี้ลบข้อมูลจริง ต้อง backup ก่อน (Task 6 Step 1)**. เนื้อหา test:

```typescript
import assert from 'node:assert';
import { PrismaClient } from '@prisma/client';
import { cleanupMemberData } from './cleanup';

(async () => {
  const prisma = new PrismaClient();
  try {
    const { before, after } = await cleanupMemberData(prisma);
    console.log('cleanup before:', before);
    console.log('cleanup after:', after);
    for (const [t, n] of Object.entries(after)) assert.strictEqual(n, 0, `${t} should be 0, got ${n}`);
    console.log('cleanup: all target tables empty');
  } finally {
    await prisma.$disconnect();
  }
})();
```

- [ ] **Step 3: (ยังไม่รัน — รันใน Task 6 หลัง backup) ตรวจ compile**

Run: `cd apps/api && npx tsc --noEmit --project tsconfig.json` (หรือ `npx ts-node -T` transpile check)
Expected: ไม่มี type error ใน cleanup.ts

- [ ] **Step 4: Commit**

```bash
git add apps/api/scripts/import-cremation-members/cleanup.ts apps/api/scripts/import-cremation-members/cleanup.test.ts
git commit -m "feat(import): safe cleanup of member/financial data (keep masters)"
```

---

## Task 6: index — orchestration + backup + insert + validate (รันจริง)

**Files:**
- Create: `scripts/import-cremation-members/index.ts`

**Interfaces:**
- Consumes: ทุก module ข้างบน

- [ ] **Step 1: Backup DB (บังคับก่อนรันจริง)**

Run (จาก repo root, bash):
```bash
BK="doc/member/_backup_cremation_db_$(date +%Y%m%d_%H%M%S).sql"
"D:/laragon/bin/mysql/mysql-8.0.30-winx64/bin/mysqldump.exe" -uroot -h127.0.0.1 -P3306 --default-character-set=utf8mb4 cremation_db > "$BK"
echo "backup: $BK ($(wc -c < "$BK") bytes)"
```
Expected: ไฟล์ backup ขนาด > 100KB. **ถ้า backup ไม่สำเร็จ หยุด — อย่ารัน import**

- [ ] **Step 2: เขียน index.ts**

สร้าง `index.ts`:

```typescript
import { PrismaClient } from '@prisma/client';
import { readAllSources } from './sources';
import { ensureUnknownSchool, buildCodeToSchoolId } from './school-map';
import { buildMemberRecords } from './build-records';
import { cleanupMemberData } from './cleanup';

const JOIN_DATE = new Date('2026-01-01T00:00:00.000Z');

async function main() {
  const prisma = new PrismaClient();
  try {
    console.log('=== อ่านไฟล์ต้นทาง ===');
    const s = readAllSources();
    console.log({ f1: s.f1.length, f2: s.f2ById.size, f3: s.f3IdToCode.size, f4sheets: s.f4SheetNames.length });

    console.log('=== เตรียม school map ===');
    const unknownSchoolId = await ensureUnknownSchool(prisma);
    const codeToSchool = await buildCodeToSchoolId(prisma, s);
    console.log({ mappedCodes: codeToSchool.size, unknownSchoolId });

    console.log('=== build member records ===');
    const { records, stats } = buildMemberRecords(s, codeToSchool, unknownSchoolId);
    console.log('build stats:', stats);
    if (records.length !== 603) throw new Error(`คาดหวัง 603 records ได้ ${records.length}`);
    if (stats.duplicateIdCards.length) console.warn('⚠️ idCard ซ้ำใน F1:', stats.duplicateIdCards);

    // memberType code → id
    const types = await prisma.memberType.findMany({ select: { id: true, code: true } });
    const typeId = new Map(types.map((t) => [t.code, t.id]));
    if (!typeId.has('REG') || !typeId.has('PERM')) throw new Error('ขาด MemberType REG/PERM — รัน prisma db seed ก่อน');

    console.log('=== ล้างข้อมูลเดิม ===');
    const clean = await cleanupMemberData(prisma);
    console.log('cleanup before:', clean.before);
    console.log('cleanup after :', clean.after);

    console.log('=== insert 603 สมาชิก ===');
    let inserted = 0;
    for (const r of records) {
      await prisma.$transaction(async (tx) => {
        const am = await tx.associationMember.create({
          data: {
            schoolId: r.schoolId,
            memberTypeId: typeId.get(r.memberTypeCode)!,
            firstName: r.firstName,
            lastName: r.lastName,
            idCardNo: r.idCard,
            phone: r.phone,
            position: r.position,
            notes: r.notes,
          },
        });
        await tx.member.create({
          data: {
            associationMemberId: am.id,
            memberNo: r.memberNo,
            schoolId: r.schoolId,
            joinDate: JOIN_DATE,
            status: 'ACTIVE',
            salaryDeduction: r.salaryDeduction,
          },
        });
      });
      inserted++;
    }
    console.log(`inserted ${inserted}`);

    console.log('=== validate ===');
    const [mCount, amCount] = [await prisma.member.count(), await prisma.associationMember.count()];
    const distinctNo = await prisma.$queryRawUnsafe<{ n: bigint }[]>('SELECT COUNT(DISTINCT memberNo) AS n FROM `Member`');
    const nullId = await prisma.associationMember.count({ where: { idCardNo: null } });
    const byType = await prisma.associationMember.groupBy({ by: ['memberTypeId'], _count: true });
    const bySchool = await prisma.member.groupBy({ by: ['schoolId'], _count: true });
    console.log({ mCount, amCount, distinctMemberNo: Number(distinctNo[0].n), nullIdCard: nullId, schools: bySchool.length });

    // assertions
    const errs: string[] = [];
    if (mCount !== 603) errs.push(`Member count ${mCount} ≠ 603`);
    if (amCount !== 603) errs.push(`AssociationMember count ${amCount} ≠ 603`);
    if (Number(distinctNo[0].n) !== 603) errs.push(`distinct memberNo ${Number(distinctNo[0].n)} ≠ 603`);
    if (nullId !== 0) errs.push(`มี idCardNo null ${nullId} รายการ`);
    if (errs.length) throw new Error('validation ล้มเหลว:\n' + errs.join('\n'));

    console.log('✅ import สำเร็จ: 603 สมาชิก, memberNo ไม่ซ้ำ, idCard ครบ');
    console.log('byType:', byType.map((t) => ({ type: [...typeId].find(([, id]) => id === t.memberTypeId)?.[0], n: t._count })));
  } finally {
    await prisma.$disconnect();
  }
}

main().catch((e) => { console.error(e); process.exit(1); });
```

- [ ] **Step 3: รัน import จริง**

Run: `cd apps/api && npx ts-node --project tsconfig.json scripts/import-cremation-members/index.ts`
Expected: จบด้วย `✅ import สำเร็จ: 603 สมาชิก...` ไม่มี error

- [ ] **Step 4: ยืนยันด้วย SQL อิสระ**

Run (repo root, bash):
```bash
MYSQL="D:/laragon/bin/mysql/mysql-8.0.30-winx64/bin/mysql.exe"
"$MYSQL" -uroot -h127.0.0.1 -P3306 --default-character-set=utf8mb4 cremation_db -e "
SELECT (SELECT COUNT(*) FROM Member) m, (SELECT COUNT(*) FROM AssociationMember) am,
       (SELECT COUNT(DISTINCT memberNo) FROM Member) dno,
       (SELECT COUNT(*) FROM AssociationMember WHERE idCardNo IS NULL) nullid,
       (SELECT COUNT(DISTINCT idCardNo) FROM AssociationMember) did;"
```
Expected: `m=603, am=603, dno=603, nullid=0, did=603`

- [ ] **Step 5: Commit**

```bash
git add apps/api/scripts/import-cremation-members/index.ts
git commit -m "feat(import): orchestrate clean + import of 603 cremation members"
```

---

## Self-Review Notes (ตรวจแล้ว)

- **Spec coverage:** §5 school (Task 3+4), §6 type (Task 4), §7 name (Task 1), §8 cleanup (Task 5), §9 TS/xlsx (Task 2), §10 validation (Task 6 Step 4), enrich bank/phone/position (Task 4). ครบ
- **41-คน rule:** Task 4 test assert `unknownSchool === 41`
- **joinDate:** Global Constraints + index.ts `JOIN_DATE`
- **Idempotency:** cleanup ก่อน insert ทุกครั้ง (Task 6)
- **Type consistency:** `MemberRecord`, `SourceData`, `F2Info`, `F4Info`, `BuildResult` นิยามครั้งเดียว ใช้ตรงกันทุก task
- **แก้ที่ต้องระวังตอนพิมพ์:** build-records.ts ใช้ `import { parseThaiName, nameKey }` (ไม่ใช้ `require` กลางไฟล์ — ระบุใน Task 4 Step 3 หมายเหตุ)

## นอกขอบเขต (YAGNI)
ไม่สร้าง Beneficiary/ProtectedPerson/User, ไม่ import ครูทั้งเขต (F2 enrich เท่านั้น), ไม่แตะ ContributionPeriod/Group assignment
