# Design: การลงบัญชีเงินสงเคราะห์ศพเต็มวงจร + กองทุน 10%

วันที่: 2026-07-12
สถานะ: รอ review
ที่มา: แก้ 3 ช่องว่างวิกฤตจาก compliance audit ([2026-07-12-compliance-audit.md](../audits/2026-07-12-compliance-audit.md))

## 1. เป้าหมาย

แก้ 3 ช่องว่างวิกฤตด้านการเงินให้ตรงระเบียบข้อ 13/16:
1. **เงินกองทุน 10% ลงบัญชีจริง** — post เข้า LedgerEntry + เพิ่มบัญชีกองทุนสะสม
2. **โหมด fixed-amount แบ่ง 90/10** — เลิกจ่ายเต็มจำนวน ให้หัก 10% เข้ากองทุนเหมือนโหมดปกติ
3. **การจ่ายเงินสงเคราะห์ auto-สร้าง Receipt + PaymentVoucher + ledger** — เต็มวงจร ณ จังหวะจ่ายจริง

## 2. จุดตัดสินใจที่ยืนยันแล้ว

- โหมด fixed: `welfareAmountPerCase` = **ยอดเก็บรวมต่อศพ (gross)** → `netToPay = fixed × 0.9`, `fundReserve = fixed × 0.1`
- บัญชีกองทุน = **EQUITY** (ทุนสะสม)
- ledger ทั้ง 3 ชุด (ขาเข้า + ขาออก + กองทุน) ลงพร้อมกัน **ตอนจ่ายจริง** (`recordPayment`) ใน transaction เดียว
- ขอบเขตรอบนี้: 3 ช่องวิกฤตเท่านั้น — บัญชี 403/404 สร้างเป็น master ไว้ แต่ยังไม่ทำ flow ดอกเบี้ย/บริจาคอัตโนมัติ

## 3. สภาพปัจจุบัน (ที่ต้องแก้)

- ผังบัญชี ([seed.ts:229-250](../../../apps/api/prisma/seed.ts)): `101` เงินสด, `102` ธนาคาร, `401` รายได้สงเคราะห์, `402` รายได้ค่าบริการ, `501` ค่าใช้จ่ายสงเคราะห์ศพ — **ไม่มีบัญชีกองทุน**
- `associationSupport` (10%) เป็น snapshot + รายงานเท่านั้น ([reports.service.ts:419](../../../apps/api/src/reports/reports.service.ts)) — ไม่ post ledger
- `death-benefit-calculator.service.ts:66-69`: โหมด fixed จ่าย `fixedAmount` เต็ม ข้าม 90/10
- `death-claims.service.ts:543-562` (`recordPayment`): สร้างแค่ `DeathBenefitPayment`, `voucherId` มาจาก dto (optional) — ไม่มี ledger/voucher/receipt
- `LedgerEntry` ผูก `Receipt`/`PaymentVoucher` เท่านั้น ([schema.prisma:502-516](../../../apps/api/prisma/schema.prisma)) — ไม่ผูก `DeathClaim`
- Pattern ที่ reuse ได้: `payments.service.ts:131` / `receipts.service.ts:142` `createLedgerEntries` (double-entry + balance check + `DocumentNumberService`)

## 4. การเปลี่ยน Schema

### 4.1 ผังบัญชีใหม่ (seed.ts — upsert เพิ่ม 3 บัญชี)
| code | name | type |
|---|---|---|
| `301` | กองทุนฌาปนกิจสงเคราะห์สะสม | `EQUITY` |
| `403` | ดอกเบี้ยรับ | `INCOME` |
| `404` | เงินบริจาค | `INCOME` |

### 4.2 DeathClaim ผูกเอกสาร (migration)
เพิ่มใน `model DeathClaim`:
```prisma
collectionReceipt   Receipt?        @relation("ClaimCollectionReceipt", fields: [collectionReceiptId], references: [id])
collectionReceiptId String?         @unique
benefitVoucher      PaymentVoucher? @relation("ClaimBenefitVoucher", fields: [benefitVoucherId], references: [id])
benefitVoucherId    String?         @unique
```
เพิ่ม back-relation ใน `Receipt` และ `PaymentVoucher` ตามลำดับ (opposite relation fields).
> ต้อง `npx prisma format` → `pnpm db:migrate` (migration ชื่อ `death_claim_ledger_links`)

## 5. การแก้ Calculator (fixed → 90/10)

`death-benefit-calculator.service.ts` — แก้ block โหมด fixed ให้ gross = fixed แล้วแบ่ง 90/10:
```ts
let grossCollected: number;
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
ผล: ทั้งสองโหมดใช้ path เดียว `net = gross×0.9 − deductions`, `fund = gross×0.1`.
Snapshot บน DeathClaim จึงสอดคล้องเสมอ: `totalContribution = grossCollected`, `associationSupport = fundReserve`, `netToPay = netToPay`.

## 6. การลงบัญชีตอน `recordPayment` (หัวใจ)

หลังผ่าน gate เดิม (approved + documentsComplete + collectedAmount ≥ target) — ใน `$transaction` เดียว:

**ใช้ค่า snapshot บน DeathClaim** (ไม่ recompute): `gross = totalContribution`, `fund = associationSupport`, `net = netToPay`.
บัญชีเงิน: `moneyAccount` = `102` ถ้ามี `dto.bankAccountId` มิฉะนั้น `101`.

1. สร้าง `Receipt` (ขาเข้า) — `receiptNo` จาก DocumentNumberService, `type = ADVANCE_WELFARE`, `amount = gross`, `date = payDate`
   - Ledger: **Dr** moneyAccount `gross` / **Cr** `401` รายได้สงเคราะห์ `gross`
2. สร้าง `PaymentVoucher` (ขาออก) — `voucherNo` จาก DocumentNumberService, `type = DEATH_BENEFIT`, `amount = net`, `date = payDate`
   - Ledger: **Dr** `501` ค่าสงเคราะห์ศพ `net` / **Cr** moneyAccount `net`
3. กันเข้ากองทุน 10% — ledger ผูก voucher (ข้อ 2)
   - **Dr** `401` รายได้สงเคราะห์ `fund` / **Cr** `301` กองทุนสะสม `fund`
4. สร้าง `DeathBenefitPayment` (เดิม) + set `voucherId` = voucher ใหม่, ผูก `DeathClaim.collectionReceiptId`/`benefitVoucherId`
5. update `DeathClaim.status = PAID`
6. balance check ทุกชุด (`totalDebit === totalCredit`) — throw ถ้าไม่ balance (เหมือน pattern เดิม)

**ผลลัพธ์บัญชี** (gross 60,000 / net 54,000 / fund 6,000, ไม่มี deductions):
- moneyAccount: +60,000 −54,000 = **+6,000** (เงินคงเหลือในกองทุน)
- `401`: +60,000 −6,000 = +54,000 ; `501`: +54,000 → หักลบ P&L = 0 (pass-through)
- `301` กองทุนสะสม: **+6,000** (equity) ✓ balanced

### หมายเหตุ edge case
- **otherDeductions > 0**: `net = gross×0.9 − deductions` → voucher จ่ายน้อยลง, เงินเหลือในบัญชีเพิ่มตามส่วน deductions. รอบนี้ปล่อยส่วนต่างค้างในบัญชีเงิน (ไม่แยกบัญชีค่าธรรมเนียม) — ระบุใน test ว่า balance ยังถูกต้อง; แยกบัญชีค่าธรรมเนียมไว้ทำภายหลัง
- **ทำครั้งเดียว/กันซ้ำ**: `recordPayment` มี guard `claim.payment` อยู่แล้ว → ไม่สร้างซ้ำ
- **rollback**: ทุกอย่างใน `$transaction` เดียว — ล้มเหลวชุดใดชุดหนึ่ง rollback ทั้งหมด

## 7. ผลกระทบต่อโค้ดอื่น

- `record-payment.dto.ts`: `voucherId` เดิม (optional input) — เลิกใช้ (ระบบ generate เอง) หรือคงไว้เป็น manual override; เสนอ**เลิกรับ** เพื่อกันความสับสน
- `reports.service.ts:419-424`: ลบคอมเมนต์ "pool-collection bookkeeping only" เพราะกองทุนลงบัญชีจริงแล้ว; ตรวจว่ารายงาน death-fund-reserve ยังตรง (อ่านจาก snapshot เดิม — ไม่กระทบ)
- Balance sheet / trial balance: บัญชี `301` จะปรากฏเป็น EQUITY — ตรวจว่ารายงานงบดุลรวม EQUITY ถูก

## 8. การทดสอบ

- **calculator**: fixed mode → `net = fixed×0.9`, `fund = fixed×0.1`, `gross = fixed` (แก้/เพิ่ม spec ที่ `death-benefit-calculator.service.spec.ts`)
- **recordPayment (integration)**: หลังจ่าย → มี Receipt(gross)+Voucher(net) + 4 ledger entries; ผลรวมแต่ละบัญชีตรงตาราง §6; `301` = fund; ทุกชุด balance
- **balance invariant**: `Σdebit = Σcredit` ต่อเอกสาร
- **กันซ้ำ**: จ่ายซ้ำ → error ไม่สร้าง ledger เพิ่ม
- **โหมดปกติ vs fixed**: ทั้งสองให้ ledger โครงเดียวกัน

## 9. นอกขอบเขต (YAGNI — รอบนี้ไม่ทำ)

- Flow ดอกเบี้ยรับ (403) / เงินบริจาค (404) อัตโนมัติ — สร้างบัญชี master ไว้เท่านั้น
- แยกบัญชีค่าธรรมเนียม/หัก (otherDeductions) เป็นรายได้เบ็ดเตล็ด
- การลงบัญชีตอน "เก็บเงินรายคน" ระหว่างงวด (รอบนี้ลง gross รวมตอนจ่าย ตามที่ตกลง)
- ปรับ deadline วันแจ้ง, checklist ข้อ 17, workflow อนุมัติสมาชิก (ช่องว่างคนละกลุ่ม)

## 10. จุดเสี่ยง / ต้องยืนยันตอน implement

- ตรวจ relation name ซ้ำใน schema (`Receipt`/`PaymentVoucher` มี relation กับ MemberContribution/DeathBenefitPayment อยู่แล้ว — ต้องตั้งชื่อ relation ใหม่ไม่ชน)
- `ReceiptType.ADVANCE_WELFARE` เหมาะกับเงินเก็บสงเคราะห์ศพหรือควรเพิ่ม enum ใหม่ (`DEATH_COLLECTION`) — ตรวจตอน implement
- ยืนยันว่า `createLedgerEntries` เดิมของ receipts/payments ไม่ถูกเรียกซ้ำ (เราสร้าง ledger เองใน recordPayment ไม่ผ่าน service create ปกติ)
