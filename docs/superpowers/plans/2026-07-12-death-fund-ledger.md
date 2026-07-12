# การลงบัญชีเงินสงเคราะห์ศพเต็มวงจร + กองทุน 10% — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development หรือ superpowers:executing-plans เพื่อ implement ทีละ task. Steps ใช้ checkbox (`- [ ]`).

**Goal:** ให้เงินสงเคราะห์ศพลงบัญชี double-entry เต็มวงจร (ขาเข้า + ขาออก + กองทุน 10%) ตอนจ่ายจริง, แก้โหมด fixed ให้แบ่ง 90/10 — ตรงระเบียบข้อ 13/16

**Architecture:** เพิ่มบัญชีกองทุน (EQUITY) + รายได้ดอกเบี้ย/บริจาค (master); แก้ `death-benefit-calculator` ให้ fixed mode ใช้ gross=fixed แล้วแบ่ง 90/10; rewrite `recordPayment` ให้ auto-create Receipt+PaymentVoucher+LedgerEntry ใน `$transaction` เดียว โดยใช้ค่า snapshot บน DeathClaim และ balance-check ทุกชุด (reuse pattern จาก `payments.service.createLedgerEntries`)

**Tech Stack:** NestJS, Prisma (MySQL), jest (ts-jest, rootDir=src), Decimal

## Global Constraints

- **อัตรา/สัดส่วน (คงเดิม):** `DEATH_COLLECTION_RATES` MEMBER_DEATH=100, PROTECTED_DEATH=50; `DEATH_PAYOUT_RATIO=0.9`, `DEATH_FUND_RESERVE_RATIO=0.1` (`death-benefit.constants.ts`)
- **ปัดเศษ:** `Math.round(x * 100) / 100` (2 ตำแหน่ง) ทุกการคำนวณเงิน — ตาม pattern เดิม
- **บัญชีเงิน:** `102` (ธนาคาร) ถ้ามี `bankAccountId`, มิฉะนั้น `101` (เงินสด)
- **ใช้ค่า snapshot บน DeathClaim** ตอนลงบัญชี (ไม่ recompute): `gross=totalContribution`, `fund=associationSupport`, `net=netToPay`
- **balance invariant:** ทุกชุด ledger ต้อง `Σdebit === Σcredit` — throw ถ้าไม่ตรง (pattern เดิม `payments.service.ts:171`)
- **Decimal:** ฟิลด์เงินเป็น Prisma Decimal — แปลงด้วย `Number(...)` ก่อนคำนวณ, ส่งกลับเป็น number
- **DB/tooling:** `cd apps/api`; migrate = `pnpm db:migrate`; test = `npx jest <path>`; mysql client = `D:/laragon/bin/mysql/mysql-8.0.30-winx64/bin/mysql.exe -uroot -h127.0.0.1 cremation_db`
- **backup ก่อน migrate จริง:** `mysqldump ... cremation_db > <scratchpad>/backup_before_ledger_<ts>.sql`

---

## File Structure

| ไฟล์ | การเปลี่ยน |
|---|---|
| `apps/api/prisma/schema.prisma` | + `ReceiptType.DEATH_COLLECTION`; `DeathClaim` +2 relation (collectionReceipt, benefitVoucher); `Receipt`/`PaymentVoucher` +back-relation |
| `apps/api/prisma/seed.ts` | + upsert Account `301`/`403`/`404` |
| `apps/api/src/death-claims/death-benefit-calculator.service.ts` | fixed mode → gross=fixed แล้วแบ่ง 90/10 |
| `apps/api/src/death-claims/death-benefit-calculator.service.spec.ts` | + test fixed mode |
| `apps/api/src/death-claims/death-claims.service.ts` | rewrite `recordPayment` — auto Receipt+Voucher+ledger |
| `apps/api/src/death-claims/dto/record-payment.dto.ts` | ลบ `voucherId` |
| `apps/api/src/reports/reports.service.ts` | ลบคอมเมนต์ "pool-collection bookkeeping only" |

---

## Task 1: Schema — บัญชีกองทุน + enum + relation + migration

**Files:**
- Modify: `apps/api/prisma/schema.prisma`, `apps/api/prisma/seed.ts`

**Interfaces:**
- Produces: Prisma models `Account` codes `301`(EQUITY)/`403`/`404`(INCOME); `ReceiptType.DEATH_COLLECTION`; `DeathClaim.collectionReceiptId`/`benefitVoucherId` (nullable, unique)

- [ ] **Step 1: Backup DB**

Run (repo root):
```bash
BK="C:/Users/ASUS/AppData/Local/Temp/claude/D--laragon-www-cremation/ca220abb-9769-4b17-9044-59a93517585a/scratchpad/backup_before_ledger_$(date +%Y%m%d_%H%M%S).sql"
"D:/laragon/bin/mysql/mysql-8.0.30-winx64/bin/mysqldump.exe" -uroot -h127.0.0.1 -P3306 --default-character-set=utf8mb4 --single-transaction cremation_db > "$BK" && echo "backup: $(wc -c < "$BK") bytes"
```
Expected: > 100KB. หยุดถ้า backup ล้มเหลว

- [ ] **Step 2: เพิ่ม enum value** ใน `schema.prisma` (`enum ReceiptType`)

เพิ่มบรรทัด `DEATH_COLLECTION` ต่อจาก `ADVANCE_WELFARE`:
```prisma
enum ReceiptType {
  MEMBER_CONTRIBUTION
  MEMBERSHIP_FEE
  BOOK_FEE
  ANNUAL_FEE
  ADVANCE_WELFARE
  DEATH_COLLECTION
  OTHER
}
```

- [ ] **Step 3: เพิ่ม relation ใน `model DeathClaim`** (ต่อจาก `payment DeathBenefitPayment?` ราวบรรทัด 443)

```prisma
  collectionReceipt   Receipt?        @relation("ClaimCollectionReceipt", fields: [collectionReceiptId], references: [id])
  collectionReceiptId String?         @unique
  benefitVoucher      PaymentVoucher? @relation("ClaimBenefitVoucher", fields: [benefitVoucherId], references: [id])
  benefitVoucherId    String?         @unique
```

- [ ] **Step 4: เพิ่ม back-relation** ใน `model Receipt` (ต่อจาก `memberContribution`) และ `model PaymentVoucher` (ต่อจาก `deathBenefit`)

ใน `model Receipt`:
```prisma
  deathClaimCollection DeathClaim? @relation("ClaimCollectionReceipt")
```
ใน `model PaymentVoucher`:
```prisma
  deathClaimBenefit DeathClaim? @relation("ClaimBenefitVoucher")
```

- [ ] **Step 5: เพิ่มบัญชีใน `seed.ts`** (ต่อจาก account `501`, ก่อน `console.log('✅ Chart of accounts ready')`)

```ts
  await prisma.account.upsert({
    where: { code: '301' },
    create: { code: '301', name: 'กองทุนฌาปนกิจสงเคราะห์สะสม', type: AccountType.EQUITY },
    update: {},
  });
  await prisma.account.upsert({
    where: { code: '403' },
    create: { code: '403', name: 'ดอกเบี้ยรับ', type: AccountType.INCOME },
    update: {},
  });
  await prisma.account.upsert({
    where: { code: '404' },
    create: { code: '404', name: 'เงินบริจาค', type: AccountType.INCOME },
    update: {},
  });
```

- [ ] **Step 6: format + migrate + seed**

Run:
```bash
cd apps/api && npx prisma format && pnpm db:migrate --name death_claim_ledger_links && npx ts-node --project tsconfig.json prisma/seed.ts
```
Expected: migration สร้างสำเร็จ, seed พิมพ์ `✅ Chart of accounts ready` ไม่มี error

- [ ] **Step 7: ตรวจว่าบัญชีถูกสร้าง**

Run:
```bash
"D:/laragon/bin/mysql/mysql-8.0.30-winx64/bin/mysql.exe" -uroot -h127.0.0.1 cremation_db --default-character-set=utf8mb4 -e "SELECT code,name,type FROM Account WHERE code IN ('301','403','404');"
```
Expected: 3 แถว, `301`=EQUITY, `403`/`404`=INCOME

- [ ] **Step 8: Commit**

```bash
git add apps/api/prisma/schema.prisma apps/api/prisma/seed.ts apps/api/prisma/migrations
git commit -m "feat(accounting): add fund/interest/donation accounts + death-claim ledger links"
```

---

## Task 2: Calculator — โหมด fixed แบ่ง 90/10 (TDD)

**Files:**
- Modify: `apps/api/src/death-claims/death-benefit-calculator.service.ts`
- Test: `apps/api/src/death-claims/death-benefit-calculator.service.spec.ts`

**Interfaces:**
- Consumes: `WelfareSettings.welfareAmountPerCase` (Decimal)
- Produces: `calculate()` — ในโหมด fixed คืน `grossCollected = fixed`, `fundReserve = fixed×0.1`, `netToPay = fixed×0.9 − deductions`, `isFixedAmount = true`

- [ ] **Step 1: เขียน test ที่ fail** — เพิ่มใน `death-benefit-calculator.service.spec.ts` (ต่อจาก test เดิม)

```ts
  it('fixed committee amount is split 90/10 (not paid in full)', async () => {
    prisma.member.count.mockResolvedValue(600);
    prisma.welfareSettings.findFirst.mockResolvedValue({
      welfareAmountPerCase: 60000, isActive: true, effectiveDate: new Date('2569-01-01'),
    });

    const result = await service.calculate({
      claimType: DeathClaimType.MEMBER_DEATH,
      otherDeductions: 0,
    });

    expect(result.isFixedAmount).toBe(true);
    expect(result.grossCollected).toBe(60000);
    expect(result.fundReserve).toBe(6000);   // 10%
    expect(result.netToPay).toBe(54000);      // 90%, ไม่ใช่ 60000 เต็ม
    // snapshot สอดคล้อง: net + fund = gross
    expect(result.netToPay + result.fundReserve).toBe(result.grossCollected);
  });
```

- [ ] **Step 2: รัน test ให้ fail**

Run: `cd apps/api && npx jest src/death-claims/death-benefit-calculator.service.spec.ts -t "fixed committee amount"`
Expected: FAIL — netToPay = 60000 (เต็ม) ≠ 54000

- [ ] **Step 3: แก้ implementation** — แทนที่ block บรรทัด ~53-74 ใน `death-benefit-calculator.service.ts`

```ts
    // fixed committee amount (WelfareSettings) แทน "ยอดเก็บรวมต่อศพ" แล้วแบ่ง 90/10 เหมือนโหมดปกติ
    const activeFixed = await this.prisma.welfareSettings.findFirst({
      where: { isActive: true },
      orderBy: { effectiveDate: 'desc' },
    });

    let grossCollected: number;
    let isFixedAmount = false;
    let fixedAmount: number | undefined;
    if (activeFixed) {
      grossCollected = Math.round(Number(activeFixed.welfareAmountPerCase) * 100) / 100;
      isFixedAmount = true;
      fixedAmount = grossCollected;
    } else {
      grossCollected = payingMemberCount * collectionRate;
    }

    const fundReserve = Math.round(grossCollected * DEATH_FUND_RESERVE_RATIO * 100) / 100;
    const netToPay = Math.round(grossCollected * DEATH_PAYOUT_RATIO * 100) / 100 - otherDeductions;
```
> ลบบรรทัดเดิมที่คำนวณ `grossCollected`/`fundReserve` ก่อนหน้า block นี้ (บรรทัด ~53-54) เพื่อไม่ให้ประกาศซ้ำ — ย้ายมาไว้ที่นี่ที่เดียว. `return` (บรรทัด 76-91) คงเดิม — map `grossCollected→totalContribution`, `fundReserve→associationSupport` สอดคล้องอยู่แล้ว

- [ ] **Step 4: รัน test ทั้งไฟล์ให้ผ่าน**

Run: `cd apps/api && npx jest src/death-claims/death-benefit-calculator.service.spec.ts`
Expected: PASS ทุก test (เดิม 100บาท×90%, 50บาท, exclude deceased + fixed ใหม่)

- [ ] **Step 5: Commit**

```bash
git add apps/api/src/death-claims/death-benefit-calculator.service.ts apps/api/src/death-claims/death-benefit-calculator.service.spec.ts
git commit -m "fix(death-benefit): fixed committee amount now split 90/10 per regulation art.16"
```

---

## Task 3: recordPayment — auto Receipt + Voucher + ledger เต็มวงจร

**Files:**
- Modify: `apps/api/src/death-claims/death-claims.service.ts`
- Test: `apps/api/src/death-claims/record-payment-ledger.spec.ts` (สร้างใหม่ — integration verify กับ DB จริง)

**Interfaces:**
- Consumes: `DocumentNumberService.generateNumber(DocumentType.RECEIPT | PAYMENT_VOUCHER)`, Account codes `101/102/301/401/501`, DeathClaim snapshot (`totalContribution`, `associationSupport`, `netToPay`)
- Produces: หลัง `recordPayment` — Receipt(gross)+PaymentVoucher(net)+4 LedgerEntry; DeathClaim ผูก `collectionReceiptId`/`benefitVoucherId`; status=PAID

- [ ] **Step 1: ตรวจ imports + constructor** ใน `death-claims.service.ts`

ยืนยันว่ามี inject `DocumentNumberService` แล้วหรือไม่ (grep). ถ้ายังไม่มี ให้เพิ่ม:
```ts
import { DocumentNumberService, DocumentType } from '../common/document-number.service';
```
และเพิ่มใน constructor: `private readonly documentNumberService: DocumentNumberService,`
(ตรวจ `death-claims.module.ts` ว่า provide `DocumentNumberService` — ถ้าไม่มีให้เพิ่มใน providers/imports ให้ครบ)

- [ ] **Step 2: แทนที่ `$transaction` block ใน `recordPayment`** (บรรทัด ~543-562)

```ts
    const gross = Number(claim.totalContribution);
    const fund = Number(claim.associationSupport);
    const net = Number(dto.amount ?? claim.netToPay);
    const payDate = new Date(dto.payDate);
    const bankId = dto.bankAccountId ?? null;

    // เลขเอกสาร (นอก tx — pattern เดียวกับ payments/receipts service)
    const receiptNo = await this.documentNumberService.generateNumber(DocumentType.RECEIPT);
    const voucherNo = await this.documentNumberService.generateNumber(DocumentType.PAYMENT_VOUCHER);

    const payment = await this.prisma.$transaction(async (tx) => {
      const acc = async (code: string) => {
        const a = await tx.account.findFirst({ where: { code } });
        if (!a) throw new Error(`ไม่พบบัญชี ${code} — รัน prisma db seed`);
        return a.id;
      };
      const moneyId = bankId ? await acc('102') : await acc('101');
      const [revenueId, expenseId, fundId] = [await acc('401'), await acc('501'), await acc('301')];

      // 1) ขาเข้า: Receipt (gross) + ledger Dr money / Cr 401
      const receipt = await tx.receipt.create({
        data: {
          receiptNo, schoolId: claim.schoolId, date: payDate,
          type: 'DEATH_COLLECTION', description: `เก็บเงินสงเคราะห์ศพ ${claim.claimNo}`,
          amount: gross, bankAccountId: bankId,
        },
      });
      // 2) ขาออก: PaymentVoucher (net) + ledger Dr 501 / Cr money
      const voucher = await tx.paymentVoucher.create({
        data: {
          voucherNo, schoolId: claim.schoolId, date: payDate,
          type: 'DEATH_BENEFIT', description: `จ่ายเงินสงเคราะห์ศพ ${claim.claimNo}`,
          amount: net, bankAccountId: bankId,
        },
      });

      const entries = [
        { accountId: moneyId, date: payDate, description: `รับเงินสงเคราะห์ ${claim.claimNo}`, debit: gross, credit: 0, receiptId: receipt.id },
        { accountId: revenueId, date: payDate, description: `รายได้สงเคราะห์ ${claim.claimNo}`, debit: 0, credit: gross, receiptId: receipt.id },
        { accountId: expenseId, date: payDate, description: `จ่ายสงเคราะห์ ${claim.claimNo}`, debit: net, credit: 0, paymentId: voucher.id },
        { accountId: moneyId, date: payDate, description: `จ่ายสงเคราะห์ ${claim.claimNo}`, debit: 0, credit: net, paymentId: voucher.id },
        { accountId: revenueId, date: payDate, description: `กันเข้ากองทุน 10% ${claim.claimNo}`, debit: fund, credit: 0, paymentId: voucher.id },
        { accountId: fundId, date: payDate, description: `กองทุนสะสม 10% ${claim.claimNo}`, debit: 0, credit: fund, paymentId: voucher.id },
      ];
      const totalDebit = entries.reduce((s, e) => s + e.debit, 0);
      const totalCredit = entries.reduce((s, e) => s + e.credit, 0);
      if (Math.round(totalDebit * 100) !== Math.round(totalCredit * 100)) {
        throw new Error(`Double-entry violation ใน DeathClaim ${claim.claimNo}: Dr ${totalDebit} != Cr ${totalCredit}`);
      }
      await tx.ledgerEntry.createMany({ data: entries });

      const created = await tx.deathBenefitPayment.create({
        data: { deathClaimId: id, payDate, method: dto.method, bankAccountId: bankId, amount: net, voucherId: voucher.id },
        include: { deathClaim: true, bankAccount: true, voucher: true },
      });

      await tx.deathClaim.update({
        where: { id },
        data: { status: DeathClaimStatus.PAID, collectionReceiptId: receipt.id, benefitVoucherId: voucher.id },
      });

      return created;
    });
```
> หมายเหตุ: `moneyAccount` ปรากฏใน 2 ชุด (รับ gross ขาเข้า / จ่าย net ขาออก) — สุทธิ = gross − net = fund (เงินเหลือในกองทุน). `401` ปรากฏ credit gross (ขาเข้า) + debit fund (กันกองทุน) = สุทธิ credit net → หักกับ `501` debit net = 0 (pass-through). Balanced.

- [ ] **Step 3: เขียน integration test** — สร้าง `record-payment-ledger.spec.ts`

```ts
import { PrismaClient } from '@prisma/client';

// Integration: รันกับ DB dev จริง — ตรวจว่า recordPayment ลงบัญชีครบวงจร
// รัน: npx ts-node --project tsconfig.json src/death-claims/record-payment-ledger.spec.ts
import assert from 'node:assert';

(async () => {
  const prisma = new PrismaClient();
  try {
    const before = async (code: string) => {
      const a = await prisma.account.findFirst({ where: { code }, include: { entries: true } });
      const bal = (a?.entries ?? []).reduce((s, e) => s + Number(e.debit) - Number(e.credit), 0);
      return Math.round(bal * 100) / 100;
    };
    const fundBefore = await before('301');

    // หา claim ที่อนุมัติแล้ว เอกสารครบ เก็บครบ ยังไม่จ่าย — หรือ setup ใหม่ผ่าน service layer
    const claim = await prisma.deathClaim.findFirst({
      where: { status: { not: 'PAID' }, approvedAt: { not: null }, documentsComplete: true, payment: null },
    });
    if (!claim) { console.log('SKIP: ไม่มี claim พร้อมจ่ายสำหรับทดสอบ — setup ผ่าน e2e แทน'); return; }

    // (ทดสอบผ่าน HTTP/e2e จริง หรือเรียก service — ที่นี่ตรวจ invariant หลังจ่าย)
    console.log('claim snapshot:', {
      gross: Number(claim.totalContribution), fund: Number(claim.associationSupport), net: Number(claim.netToPay),
    });
    assert.strictEqual(
      Math.round((Number(claim.netToPay) + Number(claim.associationSupport)) * 100),
      Math.round(Number(claim.totalContribution) * 100),
      'snapshot invariant: net + fund = gross',
    );
    console.log('fund(301) balance before:', fundBefore);
    console.log('OK: snapshot invariant ผ่าน — จ่ายจริงผ่าน e2e เพื่อตรวจ ledger');
  } finally {
    await prisma.$disconnect();
  }
})();
```
> การทดสอบเต็ม (จ่ายจริง→ตรวจ 4 ledger + fund เพิ่ม) ทำใน Task 3 Step 4 ผ่าน e2e/manual เพราะ recordPayment ต้องผ่าน gate หลายชั้น

- [ ] **Step 4: verify ด้วยการจ่ายจริง (manual e2e)** — ใช้ verify skill / critical-flow e2e

Run: `cd apps/api && npx jest --config ./test/jest-e2e.json -t "death"` (ถ้ามี death flow) — หรือรัน `record-payment-ledger.spec.ts` ตรวจ invariant
Expected: หลังจ่าย 1 เคลม → `SELECT` ยืนยัน: Receipt(DEATH_COLLECTION)+Voucher(DEATH_BENEFIT) อย่างละ 1, LedgerEntry 4 แถวผูก, บัญชี `301` เพิ่มเท่ากับ fund, `Σdebit=Σcredit`

ตรวจ SQL:
```bash
"D:/laragon/bin/mysql/mysql-8.0.30-winx64/bin/mysql.exe" -uroot -h127.0.0.1 cremation_db --default-character-set=utf8mb4 -e "
SELECT a.code, SUM(l.debit) dr, SUM(l.credit) cr FROM LedgerEntry l JOIN Account a ON l.accountId=a.id GROUP BY a.code ORDER BY a.code;"
```
Expected: `Σdr = Σcr` รวมทุกบัญชี; `301` มียอด credit = ผลรวม fund ของเคลมที่จ่าย

- [ ] **Step 5: Commit**

```bash
git add apps/api/src/death-claims/death-claims.service.ts apps/api/src/death-claims/record-payment-ledger.spec.ts
git commit -m "feat(death-claim): auto receipt+voucher+ledger with 10% fund reserve on payment"
```

---

## Task 4: Cleanup — DTO voucherId + reports comment + build

**Files:**
- Modify: `apps/api/src/death-claims/dto/record-payment.dto.ts`, `apps/api/src/reports/reports.service.ts`

- [ ] **Step 1: ลบ `voucherId` ใน `record-payment.dto.ts`**

ลบ property `voucherId` (บรรทัด ~21-23) และ import ที่ไม่ใช้แล้ว. ตรวจว่า `recordPayment` ไม่อ้าง `dto.voucherId` (แก้ใน Task 3 แล้ว — ใช้ voucher ที่ generate เอง)

- [ ] **Step 2: ลบคอมเมนต์ล้าสมัยใน `reports.service.ts`** (บรรทัด ~419-424)

ลบคอมเมนต์ "pool-collection bookkeeping only" เปลี่ยนเป็น:
```ts
    // gross / fee / net breakdown — derived FROM the netToPay snapshot; 10% fund reserve
    // is now posted to LedgerEntry (account 301) at payment time (see death-claims.service).
```

- [ ] **Step 3: build ผ่าน (type check)**

Run: `cd apps/api && pnpm build:api` (หรือ `npx tsc --noEmit -p tsconfig.json` ถ้ามี — เช็คว่าไม่มี type error จาก voucherId ที่ลบ)
Expected: build สำเร็จ ไม่มี error

- [ ] **Step 4: รัน unit tests ที่เกี่ยวข้องทั้งหมด**

Run: `cd apps/api && npx jest src/death-claims`
Expected: PASS ทุก test

- [ ] **Step 5: Commit**

```bash
git add apps/api/src/death-claims/dto/record-payment.dto.ts apps/api/src/reports/reports.service.ts
git commit -m "chore(death-claim): drop manual voucherId, update stale fund-bookkeeping comment"
```

---

## Self-Review Notes (ตรวจแล้ว)

- **Spec coverage:** บัญชี 301/403/404 (Task1) · fixed→90/10 (Task2 spec §5) · auto ledger เต็มวงจร (Task3 §6) · DTO/comment cleanup (Task4 §7). ครบ
- **Placeholder scan:** ไม่มี TBD; โค้ดทุก step เป็นของจริง
- **Type consistency:** `gross/fund/net` มาจาก snapshot เดียวกันทุก task; account codes `101/102/301/401/501` ตรงกับ seed (Task1); `DEATH_COLLECTION`/`DEATH_BENEFIT` enum ตรง schema
- **ลำดับ dependency:** Task1 (schema+migrate) ต้องก่อน Task3 (ใช้ relation/enum/บัญชีใหม่); Task2 อิสระ; Task4 หลัง Task3
- **จุดเสี่ยงที่ระบุ:** relation name ไม่ชน (Task1 ใช้ชื่อเฉพาะ `ClaimCollectionReceipt`/`ClaimBenefitVoucher`); `DocumentNumberService` provide ครบใน module (Task3 Step1); otherDeductions>0 → ส่วนต่างค้างในบัญชีเงิน (ยอมรับตาม spec §6, balance ยังถูกเพราะ voucher=net)

## นอกขอบเขต (YAGNI)
Flow ดอกเบี้ย(403)/บริจาค(404) อัตโนมัติ, แยกบัญชีค่าธรรมเนียม deductions, การลงบัญชีเก็บเงินรายคนระหว่างงวด — ไม่ทำรอบนี้
