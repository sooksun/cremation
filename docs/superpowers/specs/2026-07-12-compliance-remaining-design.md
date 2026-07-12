# Design: แก้ช่องว่าง compliance ที่เหลือ (สูง + กลาง) — เฟส 1

วันที่: 2026-07-12
สถานะ: รอ review
ที่มา: compliance audit [2026-07-12-compliance-audit.md](../audits/2026-07-12-compliance-audit.md)
Branch: `compliance/death-claim-report-fixes`
ก่อนหน้า: เฟส 0 (WIP ค้าง) commit แล้ว — #9 deadline วันแจ้ง, #12 checklist/พวงหรีด, #4 report security, members guards

## 1. ขอบเขต

แก้ 6 รายการ bug/compliance ที่ชัดเจน (เรียงตาม audit: สูง → กลาง):

| # | ระดับ | รายการ |
|---|---|---|
| #6 | 🟠 สูง | bug เกษียณถูกตีเป็น RESIGNED (9.1.3) |
| #7 | 🟠 สูง | activeMemberCount นับผิดจังหวะ (16/20) |
| #5 | 🟠 สูง | ที่อยู่ทะเบียนราษฎรถูกยุบเป็น string เดียว (ใบสมัคร) |
| #4 | 🟠 สูง | approve workflow ไม่มี audit/reject/scope/ผู้อนุมัติ/คำรับรอง (15) |
| #11 | 🟡 กลาง | CashBook/BankTransaction ลบถาวร ไม่มี retention (ref2 30) |
| #19 | 🟡 กลาง | ลำดับผู้รับเงินไม่ validate (19) |

**นอกขอบเขต (เลื่อน — policy):** #8 ระบบอัตราซ้อน, #10 ข้อบังคับสมาคม ref2 (กิตติมศักดิ์/ค่าบำรุงรายปี/ลาออกอนุมัติ)

## 2. จุดตัดสินที่ยืนยันแล้ว (จากผู้ใช้)

- **#7:** คำนวณ activeMemberCount + snapshot ใหม่ **ตอนจ่ายจริง (payDate)** ด้วยสถานะปัจจุบัน ณ จังหวะจ่าย (ไม่ reconstruct ย้อนวัน — schema ไม่รองรับประวัติสถานะ)
- **#6:** แนวทาง Minimal — คงสถานะ `RESIGNED`, แก้ให้ `membershipEndReason = RETIRED` เมื่อเป็นครูเกษียณ (ไม่เพิ่ม MemberStatus ใหม่ / ไม่กระทบ UI)
- **#4:** ทำเต็ม — backend hardening + คำรับรอง ผอ./กรรมการ + web UI (อนุมัติ/ปฏิเสธ)
- **Backfill:** เขียน script cleanup/backfill แยก ให้ผู้ใช้ review + รันเอง (ไม่รวมใน migration อัตโนมัติ)

## 3. รายละเอียดแต่ละรายการ

### #6 — bug เกษียณ (Minimal)

**ปัจจุบัน:** `getStatusChangeExtras` ([membership-rules.service.ts:77-85](../../../apps/api/src/members/membership-rules.service.ts)) ลำดับ `if/else if` ผิด — เงื่อนไข `RESIGNED && date` จับก่อน branch `RESIGNED && memberTypeCode==='RET'` เสมอ → `membershipEndReason` เป็น `RESIGNED` ไม่เคยเป็น `RETIRED`. enum `MembershipEndReason.RETIRED` มีอยู่แล้ว (schema:139-144).

**แก้:** รวมเงื่อนไข RET เข้ากับ branch `RESIGNED + date` — ถ้า `memberTypeCode === 'RET'` ตั้ง `membershipEndReason = RETIRED` (พร้อม `resignDate`) มิฉะนั้น `RESIGNED`. จุดแก้เดียว ไม่ต้อง migration/UI.

**เสี่ยง:** ต่ำ. รายงาน `resignations` byReason จะแยก "เกษียณ" ถูกทันที.
**Test:** unit `getStatusChangeExtras(RESIGNED, 'RET', date)` → `RETIRED`; `getStatusChangeExtras(RESIGNED, 'STF', date)` → `RESIGNED`.
**Backfill:** `Member` ที่ `memberType.code='RET' AND status=RESIGNED` → set `membershipEndReason=RETIRED`.

### #7 — activeMemberCount ณ payDate

**ปัจจุบัน:** `calculate()` ([death-benefit-calculator.service.ts:46-51](../../../apps/api/src/death-claims/death-benefit-calculator.service.ts)) นับ `status ∈ {ACTIVE, ARREARS}` (ไม่มี date filter) ถูกเรียกตอน **create claim** ([death-claims.service.ts:95,141](../../../apps/api/src/death-claims/death-claims.service.ts)) แล้ว snapshot; `recordPayment` (~:549-552) อ่าน snapshot เดิมไปโพสต์บัญชี.

**แก้:** ใน `recordPayment` — **recompute** `calculate()` ณ จังหวะจ่าย (สถานะปัจจุบัน) → update snapshot fields (`activeMemberCount`, `totalContribution`, `associationSupport`, `netToPay`, `welfareRate`) **ก่อน** post ledger → ledger ใช้ค่าใหม่. ค่าตอน create ยังคงเป็น "ประมาณการ/target เก็บเงิน"; ยอดจ่ายจริง finalize ณ payDate ตามระเบียบข้อ 16.

**เสี่ยง:**
- ยอด target (create) อาจ ≠ ยอดจ่าย (payDate) ถ้าจำนวนสมาชิกเปลี่ยน — เป็นพฤติกรรมที่ถูกต้องตามระเบียบ แต่ต้องสื่อสารใน UI (แสดง "ประมาณการ" vs "ยอดจ่ายจริง")
- โหมด fixed-amount: จำนวนสมาชิกไม่กระทบเงิน → recompute แก้แค่เลข `activeMemberCount` เชิงแสดงผล
- ต้อง recompute **ก่อน** double-entry balance check (ปัจจุบัน check ที่ ~:606-610)

**Test:** recordPayment → snapshot ถูก recompute; ledger สมดุลด้วยค่าใหม่; fixed mode ไม่เปลี่ยนยอดเงิน.

### #5 — ที่อยู่ structured

**ปัจจุบัน:** DTO `AddressDto` ([submit-application.dto.ts:13-23](../../../apps/api/src/member-applications/dto/submit-application.dto.ts)) รับ structured ครบ (2 ชุด: `registeredAddress`, `contactAddress`) แต่ service ([member-applications.service.ts:46-47](../../../apps/api/src/member-applications/member-applications.service.ts)) `formatAddress(contactAddress ?? registeredAddress)` → ยุบเป็น string เดียว ทิ้ง registered. schema `AssociationMember` (schema:270-289) มีแค่ `address String?`. (web `/register` ส่งครบอยู่แล้ว)

**แก้:**
- schema: เพิ่มคอลัมน์ structured ใน `AssociationMember` — 2 ชุด: `registered{HouseNo,Moo,Road,Soi,Subdistrict,District,Province,Zip}` + `contact{...}` (เลียนแบบ `Beneficiary` ที่มี structured อยู่แล้ว)
- service: map field structured ทั้ง 2 ชุดลง DB; คง `address String?` เป็น derived (เก็บ `formatAddress` ไว้เป็น string สรุปเพื่อ backward-compat การพิมพ์/แสดงผลเดิม)
- แสดงผล: จุดที่อ่าน `AssociationMember.address` ยังอ่าน derived string ได้ (ไม่ break)

**เสี่ยง:** ข้อมูลเดิม (address string) parse กลับ structured ยาก → ปล่อย structured เป็น null สำหรับแถวเก่า (ยอมรับได้). ฝั่ง web ไม่ต้องแก้เพื่อเก็บข้อมูล.
**Test:** submit → registered + contact structured ถูกเก็บครบแยกกัน; derived `address` ยังถูกสร้าง.

### #4 — approve workflow เต็ม (+ web UI)

**ปัจจุบัน:** "ใบสมัคร" = `Member` ที่ `applicationSubmittedAt != null` + `status=SUSPENDED` (ไม่มี model แยก). `approveApplication(id)` ([member-applications.service.ts:240-250](../../../apps/api/src/member-applications/member-applications.service.ts)) แค่ set `status=ACTIVE` — ไม่รับ actor, ไม่ audit, ไม่ scope, ไม่บันทึกผู้อนุมัติ, ไม่มี reject. `listApplications`/`getApplication` รับ `schoolId` จาก query ตรง ๆ ไม่ผ่าน `SchoolScopeService`.

**แก้ (อ้าง pattern `death-claims.approveDisbursement:454-516`):**
- **schema `Member`:** เพิ่ม
  - อนุมัติ: `approvedById String?` + relation `approvedBy User? @relation("MemberApprover")`, `approvedAt DateTime?`, `approverName String?`
  - คำรับรอง: `directorCertifiedName String?`, `directorCertifiedAt DateTime?`, `committeeCertifiedName String?`, `committeeCertifiedAt DateTime?`
  - ปฏิเสธ: `rejectedById String?`, `rejectedAt DateTime?`, `rejectReason String?`
  - สถานะใบสมัคร: เพิ่ม enum `ApplicationStatus { PENDING, APPROVED, REJECTED }` + field `applicationStatus ApplicationStatus?` (แยกจาก MemberStatus lifecycle — ไม่ปนสถานะสมาชิก)
  - `User`: back-relation `approvedApplications Member[] @relation("MemberApprover")`
- **enum `AuditAction`:** เพิ่ม `MEMBER_APPLICATION_APPROVE`, `MEMBER_APPLICATION_REJECT`
- **service:** inject `SchoolScopeService` + `AuditLogService` (CommonModule เป็น `@Global` — inject ได้เลย);
  - `approveApplication(id, actor, ip, cert?)` — assertSchoolAccess, บันทึก approver + คำรับรอง, audit log, set `applicationStatus=APPROVED` + `status=ACTIVE`
  - `rejectApplication(id, actor, ip, reason)` — assertSchoolAccess, บันทึก reject, audit log, set `applicationStatus=REJECTED` (คง `status=SUSPENDED`)
  - `listApplications`/`getApplication` — ใส่ scope enforcement (`resolveSchoolId`/`assertSchoolAccess`)
- **controller:** `@Request() req` ส่ง `req.user, req.ip`; route ใหม่ `POST :id/reject`; ส่ง user เข้า list/getOne
- **web:** หน้า admin รายการใบสมัคร + ปุ่มอนุมัติ/ปฏิเสธ + ฟอร์มกรอกคำรับรอง ผอ./กรรมการ + เหตุผลปฏิเสธ (ยังไม่มีหน้านี้)

**เสี่ยง:** งานใหญ่สุด (schema + service + controller + web). ข้อมูลเดิมที่ approve ไปแล้วไม่มี approver (nullable รองรับ). ต้องมี route-access gating หน้าใหม่.
**Test:** approve/reject — scope, audit, approver persisted; unauthorized school → 403.

### #11 — retention (soft-delete)

**ปัจจุบัน:** `CashBook.remove` ([cash-book.service.ts:75-78](../../../apps/api/src/cash-book/cash-book.service.ts)) และ `BankTransaction.removeManualTransaction` ([bank-accounts.service.ts:313-320](../../../apps/api/src/bank-accounts/bank-accounts.service.ts)) เป็น hard delete. ไม่มี `deletedAt` ทั้ง repo.

**แก้:**
- schema: `CashBook` + `BankTransaction` เพิ่ม `deletedAt DateTime?`
- service: `remove` → `update({ deletedAt })` แทน `delete`; เพิ่ม `deletedAt: null` ในทุก query อ่าน (findAll/findById/aggregate/statement/reconcile)
- audit log ผู้ลบ (soft-delete) — ทั้งสอง service ปัจจุบันไม่เขียน audit
- (ทางเลือก) จำกัดสิทธิ์ลบให้สมมาตร (ปัจจุบัน BankTxn ลบได้ถึง FINANCE/SCHOOL_ADMIN, CashBook เฉพาะ ADMIN)

**เสี่ยง:** CashBook ผูก `receiptId`/`paymentId` แบบ `@unique` (schema:611-612) → soft-delete แถวเดิมแล้วสร้างใหม่จาก receipt เดิมจะชน unique. แก้ด้วยการเช็ค/reactivate แถว soft-deleted แทนสร้างใหม่ ใน `createFromReceipt`/`createFromPayment`.
**Test:** remove → deletedAt set, ไม่โผล่ใน list/รวมยอด; reactivate จาก receipt เดิมไม่ชน unique.

### #19 — beneficiary priority

**ปัจจุบัน:** `Beneficiary.priority Int` (schema:322-341) ไม่มี `@@unique([memberId, priority])`. DTO ([beneficiary.dto.ts:16-18](../../../apps/api/src/members/dto/beneficiary.dto.ts), create-member `BeneficiaryInput`) ไม่ validate. `mainBeneficiary` ใน DeathClaim เป็น free string (schema:413).

**แก้:**
- schema: `Beneficiary` เพิ่ม `@@unique([memberId, priority])` (**หลัง** backfill cleanup ซ้ำ)
- DTO: `priority` เพิ่ม `@IsInt @Min(1) @Max(3)` ทั้ง `beneficiary.dto.ts` + `BeneficiaryInput`
- service: validate priority ไม่ซ้ำ/อยู่ในช่วง 1-3 ก่อนบันทึก — ทั้ง `members.service` (:135-144), `beneficiaries.service` (:13-42), `member-applications.service` (:96-135)
- (ทางเลือก) `DeathClaim` เพิ่ม `beneficiaryId String?` (FK) validate ให้ตรง Beneficiary — คง `mainBeneficiary` string เป็น snapshot; ระวัง PROTECTED_DEATH ที่ผู้รับเป็นสมาชิกเอง (fallback เดิม)

**เสี่ยง:** ข้อมูลเดิม priority ซ้ำ → unique migration fail → **ต้อง backfill cleanup ก่อน**.
**Test:** create beneficiary priority ซ้ำ → error; priority นอก 1-3 → validation fail.

## 4. Backfill scripts (แยก — ผู้ใช้รันเอง)

เขียนเป็น ts-node scripts ใน `apps/api/prisma/backfill/` ให้ review + รันเอง:
1. `backfill-retired-reason.ts` — `Member` RET+RESIGNED → `membershipEndReason=RETIRED` (#6)
2. `dedupe-beneficiary-priority.ts` — หา `Beneficiary` ที่ priority ซ้ำต่อ member แล้ว renumber 1..n ตาม createdAt (#19) — **ต้องรันก่อน** migration `@@unique`

แต่ละ script: dry-run mode (พิมพ์ก่อน) + backup เตือน.

## 5. ลำดับ implement (สูง ก่อน กลาง ตามที่ผู้ใช้เลือก)

กลุ่มสูง (#6, #5, #7, #4) ก่อน — จัดภายในกลุ่มจากง่าย→ใหญ่:
1. **#6 เกษียณ** — logic เดียว + backfill script (เริ่มง่าย, TDD)
2. **#5 ที่อยู่ structured** — schema + service map
3. **#7 activeMemberCount** — recompute ใน recordPayment (กระทบการเงิน — ทำหลัง verify death-fund-ledger เดิม)
4. **#4 approve workflow** — schema + service + controller + web UI (ใหญ่สุดในกลุ่มสูง)

กลุ่มกลาง (#19, #11) ต่อ:
5. **#19 beneficiary** — backfill cleanup ซ้ำ → migration `@@unique` + validation
6. **#11 retention** — schema `deletedAt` + soft-delete + reactivate + query filter

> หมายเหตุ: แต่ละรายการอิสระต่อกัน (ยกเว้น #7 ต่อยอดจาก death-fund-ledger เฟส 0) — ปรับสลับได้ถ้าต้องการ

แต่ละรายการ: TDD (test ก่อน) → implement → build + test → commit แยก. Schema change ใช้ `prisma db push` (ตาม pattern repo — shadow DB ใช้ไม่ได้) + `db push` regenerate client.

## 6. Global constraints

- Money = Prisma Decimal, ปัด `Math.round(x*100)/100`
- Schema change: `npx prisma db push` (ไม่ใช่ migrate dev) + backup DB ก่อน (mysqldump)
- ทุก mutation ที่ sensitive → AuditLogService; ทุก query operational → school scope
- Test: `npx jest <path>`; build check: `tsc --noEmit`
- Decimal/date: stored Gregorian, พ.ศ. ที่ UI เท่านั้น

## 7. นอกขอบเขต (YAGNI รอบนี้)

- #8 ระบบอัตราซ้อน (welfareRate vs constants vs WelfareSettings) — policy
- #10 ข้อบังคับสมาคม ref2 (กิตติมศักดิ์, ค่าบำรุงรายปี, ลาออกอนุมัติ) — policy
- member status history table (reconstruct activeMemberCount ย้อนวันแบบเต็ม) — #7 ใช้ current-status ณ payDate แทน
- แยกบัญชีค่าธรรมเนียม/หัก otherDeductions
