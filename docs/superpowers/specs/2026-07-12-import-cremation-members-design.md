# Design: Import สมาชิกฌาปนกิจ อ.แม่ฟ้าหลวง (clean + re-import)

วันที่: 2026-07-12
สถานะ: รอ review

## 1. เป้าหมาย

ล้างข้อมูลสมาชิกเดิมใน `cremation_db` ทั้งหมด แล้ว import **สมาชิกฌาปนกิจ 603 คน**
จากไฟล์ `doc/member/2.ฌาปนกิจ มฟล.xls` เข้าใหม่ พร้อม enrich ข้อมูล (โรงเรียน, ประเภทสมาชิก,
บัญชีธนาคาร, ตำแหน่ง, เบอร์โทร) จากไฟล์อื่นด้วยเลขบัตรประชาชน

## 2. แหล่งข้อมูล (4 ไฟล์ใน `doc/member/`)

| ชื่อย่อ | ไฟล์ | จำนวน | มีเลขบัตร | บทบาท |
|---|---|---|:---:|---|
| **F1** | `2.ฌาปนกิจ มฟล.xls` | 603 | ✅ | **master** — รายชื่อสมาชิกฌาปนกิจจริงที่จะ import |
| **F3** | `new_ข้อมูลครู อ.แม่ฟ้าหลวง.xls` | 609 | ✅ | map เลขบัตร → รหัสโรงเรียน (401–433) |
| **F2** | `new_teacher_in_saocr3.xls` (sheet `ขรก`, `ลจ.`) | 2,198 | ✅ | enrich ประเภท(ขรก/ลจ) + เลขบัญชี + สาขา + สังกัด |
| **F4** | `member_data.xlsx` (31 sheets) | 720 | ❌ | enrich ตำแหน่ง + เบอร์โทร (match ด้วยชื่อ) |

รูปแบบไฟล์: F1/F2/F3 เป็น OLE2 (`.xls` จริง → engine `xlrd`); F4 เป็น `.xlsx` (engine `openpyxl`).
F1 มี 1 แถวเป็นยอดรวม (money=60300) ต้องกรองออก → เหลือ 603 แถวสมาชิกจริง.
F3 ไม่มี header row (col0=เลขบัตร, col1=ชื่อ, col2=รหัสโรงเรียน).
F4 แต่ละ sheet มีหัวรายงาน 3 แถว + header (`ที่ | ชื่อ-สกุล | ตำแหน่ง | เบอร์โทร`) แล้วจึงเป็นข้อมูล.

## 3. สถานะ DB ปัจจุบัน (ก่อนล้าง)

- `Member` = 756, `AssociationMember` = 757 — **735/757 ไม่มี idCardNo** (import จาก F4 เมื่อ 17 ก.พ.)
- `memberNo` ซ้ำ 16 รายการ (data quality เดิมเสีย → เหตุผลที่ต้อง re-import)
- `School` = 35: **SCH_001–SCH_031** (31 โรงเรียนจริงของแม่ฟ้าหลวง, **เก็บไว้**) + SCH001–SCH004 (seed ตัวอย่าง)
- `MemberType` = 4: `REG` (ครูประจำการ), `RET` (ครูเกษียณ), `STF` (บุคลากรสนับสนุน), `PERM` (ลูกจ้างประจำ)

## 4. โมเดลปลายทาง (2 ชั้น)

ต่อสมาชิก 1 คน สร้าง 2 record:

**AssociationMember** (ต้นทางข้อมูลบุคคล)
- `schoolId` (บังคับ) ← จาก mapping §5
- `memberTypeId` (บังคับ) ← จาก §6
- `firstName`, `lastName` ← แยกจากคอลัมน์ name (§7)
- `idCardNo` ← person_id (13 หลัก)
- `phone` ← เบอร์โทรจาก F4 (ถ้ามี)
- `position` ← ตำแหน่งจาก F4 (ถ้ามี, ตัดไม่เกิน 100 ตัวอักษร)
- `notes` ← "บัญชีธนาคาร: {acc} สาขา {branch}" จาก F2 (ถ้ามี) + สังกัดจริง (สำหรับคนนอกอำเภอ)
- ฟิลด์อื่น (`birthDate`, `address`, `associationJoinDate`, `associationMemberNo`) = null

**Member** (สมาชิกฌาปนกิจ)
- `associationMemberId` ← 1:1 กับ record ข้างบน
- `memberNo` ← running `M0001`–`M0603` (เรียงตามลำดับใน F1)
- `schoolId` ← เท่ากับ AssociationMember.schoolId
- `groupId` = null (ไฟล์ไม่มีข้อมูลกลุ่มย่อย)
- `joinDate` = **2026-01-01** (1 ม.ค. 2569)
- `status` = `ACTIVE`
- `membershipClass` = `CONTRIBUTORY` (default)
- `salaryDeduction` = `true` ถ้ามีเลขบัญชีจาก F2 (หักผ่านเงินเดือน), มิฉะนั้น `false`

## 5. การหาโรงเรียน (schoolId)

1. **562 คน** — เลขบัตรอยู่ใน F3 → ได้รหัส 401–433 → map เข้า School เดิมใน DB
   - mapping รหัส → School สร้างจาก: รหัส → (คนในรหัสนั้น) → sheet ใน F4 (match ชื่อ) → School (match ชื่อ normalize)
   - ยืนยันแล้ว: 29/29 รหัสที่มีสมาชิก map ได้ direct
   - **รหัส 410 → บ้านห้วยอื้น (SCH_016), รหัส 417 → บ้านกลาง (SCH_021)** — hardcode 2 mapping นี้ (auto-match ด้วยชื่อไม่ติดเพราะ F4 sheet บ้านกลางแยกชื่อ 2 คอลัมน์)
2. **41 คน** — เลขบัตรไม่อยู่ใน F3 → ใส่โรงเรียนพิเศษ **"ไม่ระบุ/ส่วนกลาง"**
   - สร้าง School ใหม่ 1 แห่ง: code `SCH_UNKNOWN`, name `ไม่ระบุ/ส่วนกลาง`, district `แม่ฟ้าหลวง`, province `เชียงราย`
   - ในกลุ่มนี้ 10 คนมีสังกัดจริงใน F2 → บันทึกสังกัดเดิมลง `notes` เพื่อไม่ให้ข้อมูลหาย (แต่ schoolId ยังชี้ SCH_UNKNOWN)

## 6. การหาประเภทสมาชิก (memberTypeId)

จับคู่เลขบัตรกับ F2:
- อยู่ใน sheet `ขรก` (ข้าราชการ) → `REG` — ~571 คน
- อยู่ใน sheet `ลจ.` (ลูกจ้าง) → `PERM` — ~1 คน
- ไม่อยู่ใน F2 (31 คน) → default `REG`

## 7. การแยกชื่อ (name → firstName / lastName)

คอลัมน์ name = "คำนำหน้า + ชื่อ + นามสกุล" (เว้นวรรคคั่น, อาจมีช่องว่างซ้อน)
1. normalize ช่องว่างซ้อนเป็นช่องว่างเดียว
2. ระบุคำนำหน้าจาก list (`นางสาว`, `นาง`, `นาย`, `ว่าที่ร้อยตรี/เอก/โท`, `ดร.`, `จ.ส.อ.`, `ส.อ.`, `ร.ต.`, `พ.จ.อ.`) โดย match แบบยาวสุดก่อน
3. ส่วนที่เหลือหลังคำนำหน้า: token แรก = ชื่อจริง, token ที่เหลือ = นามสกุล
4. `firstName` = คำนำหน้า + ชื่อจริง (เช่น `"นางสาวศิริพร"`), `lastName` = นามสกุล (เช่น `"ดวงดี"`)

> ตัดสินใจ: คงคำนำหน้าไว้ติดกับ `firstName` เพราะ schema ไม่มีฟิลด์ `title` แยก — หลีกเลี่ยงการสูญเสีย
> คำนำหน้า และตรงกับ pattern ข้อมูลเดิมที่เคย import มา (ตรวจสอบ pattern จริงใน DB ก่อน implement เพื่อ
> ยืนยันความสอดคล้องกับ UI/report — ถ้าเดิมแยก title จะปรับตาม)

## 8. กลยุทธ์การล้างข้อมูล (cleanup)

ล้างเฉพาะข้อมูลสมาชิกและตารางลูกที่อ้างถึง Member/AssociationMember — **ไม่แตะ** School, MemberType,
SchoolCluster, Group, User, Account, BankAccount

**ตรวจ FK จริงแล้ว** (2026-07-12) — ตารางที่ต้องล้าง (ข้อมูล transactional ของสมาชิก/การเงิน ทั้งหมดเป็นข้อมูล test):
`Beneficiary` (10), `ProtectedPerson` (5), `MemberContribution` (1519), `LedgerEntry` (ผูก Receipt/Voucher),
`DeathBenefitPayment` (1), `DeathClaim` (1), `Receipt` (760), `PaymentVoucher` (1), `Member` (756),
`AssociationMember` (757)

**เก็บไว้ (ไม่แตะ):** `School`, `MemberType`, `SchoolCluster`, `Group`, `User`, `Account`, `BankAccount`,
`ContributionPeriod`, `WelfareSettings`, `AppSetting`, `Asset`, `CashBook`, `BankTransaction`

**Null-out ก่อนลบ** (อ้าง Member แต่ไม่ลบตัวเอง): `UPDATE Group SET leaderId=NULL`, `UPDATE User SET memberId=NULL`

วิธี: ครอบใน `prisma.$transaction` — `SET FOREIGN_KEY_CHECKS=0` → null-out refs → `DELETE` แต่ละตาราง →
`SET FOREIGN_KEY_CHECKS=1` (ไม่ต้องกังวลลำดับ FK)

**Safety:** dump `cremation_db` ด้วย `mysqldump` เป็นไฟล์ backup ก่อนรัน cleanup ทุกครั้ง

## 9. อัลกอริทึม (สคริปต์ครั้งเดียว)

ไฟล์: `apps/api/prisma/import-cremation-members.ts` (รันด้วย ts-node ผ่าน Prisma Client)

ขั้นตอน (ครอบใน `prisma.$transaction` เท่าที่ทำได้):
1. โหลด lookup จาก 4 ไฟล์เข้า memory (แปลง .xls → อ่านผ่าน library ที่รองรับ OLE2)
2. สร้าง/หา School `SCH_UNKNOWN`
3. สร้าง code→schoolId map (auto 29 + hardcode 410/417)
4. ล้างข้อมูลเดิม (§8)
5. วน 603 แถวของ F1: แยกชื่อ, resolve school/type/enrich, สร้าง AssociationMember + Member
6. พิมพ์รายงานสรุป (§10)

**Idempotency**: สคริปต์ล้างก่อน insert ทุกครั้ง → รันซ้ำได้ผลเหมือนเดิม (ไม่ append ซ้ำ)

### เครื่องมืออ่าน .xls ในสคริปต์ TS
**ปรับปรุง 2026-07-12:** `apps/api` มี `xlsx` (SheetJS ^0.18.5) ติดตั้งอยู่แล้ว และมี existing script
`scripts/excel-to-migration.ts` ที่ใช้ pattern `import * as XLSX from 'xlsx'` อยู่แล้ว. SheetJS อ่านได้ทั้ง
`.xls` (OLE2) และ `.xlsx` → **ทำเป็น TS ล้วน ไม่ต้องใช้ Python** (เดิม spec เสนอ Python→JSON)

โครงสร้าง: `apps/api/scripts/import-cremation-members/` (โฟลเดอร์เดียว หลายไฟล์ตาม responsibility)
รันด้วย `npx ts-node --project tsconfig.json scripts/import-cremation-members/index.ts` (ตาม pattern
`db:excel-to-migration`). Pure logic (แยกชื่อ, enrich) แยกเป็นไฟล์ที่ test ได้ด้วย standalone ts-node
assertion (jest rootDir ผูก `src/` จึงไม่ครอบ scripts/).

## 10. การตรวจสอบและรายงาน (validation)

หลัง import ต้องได้:
- `Member` count = 603, `AssociationMember` count = 603
- `memberNo` distinct = 603 (ไม่มีซ้ำ)
- `idCardNo` ไม่ null ครบ 603, ไม่มีซ้ำ (ตรวจ duplicate เลขบัตรใน F1 ก่อน)
- สรุป: จำนวนต่อโรงเรียน, จำนวนต่อ memberType, จำนวนที่ enrich บัญชี/ตำแหน่ง/เบอร์ได้, จำนวนเข้า SCH_UNKNOWN

## 11. นอกขอบเขต (YAGNI)

- ไม่สร้าง Beneficiary / ProtectedPerson (ไฟล์ไม่มีข้อมูล)
- ไม่สร้าง User (บัญชี login) ให้สมาชิก
- ไม่ import ครูทั้งเขต (F2 2,198 คน) — F2 ใช้ enrich เท่านั้น
- ไม่แตะ ContributionPeriod / งวดเงินสงเคราะห์
- ไม่จัดกลุ่มย่อย (Group) ให้สมาชิก

## 12. จุดตัดสินใจที่ยืนยันแล้ว

- "สมาชิกใหม่" = สมาชิกฌาปนกิจทั้งหมด 603 คน (F1)
- ล้าง DB เดิมทั้งหมด แล้ว import ใหม่
- enrich เต็มที่ (บัญชี + ตำแหน่ง + เบอร์)
- 41 คนไม่มีโรงเรียน → import ทั้งหมด ใส่ SCH_UNKNOWN
- joinDate = 2026-01-01 (1 ม.ค. 2569)
