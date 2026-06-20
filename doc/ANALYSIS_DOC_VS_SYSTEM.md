# การวิเคราะห์เปรียบเทียบ doc/ กับระบบปัจจุบัน

**วันที่วิเคราะห์:** กุมภาพันธ์ 2568  
**อัปเดตล่าสุด:** มิถุนายน 2026 — รายการด้านล่างสะท้อนสถานะ ณ ก.พ. 2568; ดู `update_plan.md` สำหรับสถานะปัจจุบัน

**เปลี่ยนแปลงสำคัญหลังก.พ. 2568:**
- Schema: AssociationMember เป็นต้นทางข้อมูลบุคคล, Member อ้าง `associationMemberId`
- Death claim print, PDF สมทบ digitCentersX, school scope P1/P2 — ทำครบแล้ว
- มี `POST /association-members` เพิ่มจากสเปกเดิม

---

## 1. doc/UPGRADE_SPEC.md

| สเปก | สถานะ | หมายเหตุ |
|------|--------|----------|
| Model AssociationMember (1:1 กับ Member) | ✅ ตรง | schema.prisma มีครบ |
| ฟิลด์: associationMemberNo, position, associationJoinDate, notes | ✅ ตรง | รวม schoolId, memberTypeId |
| API CRUD: GET, PATCH | ✅ ตรง | ไม่มี POST – สร้างจาก Member อัตโนมัติ |
| หน้าจอ: รายการ + แก้ไข | ✅ ตรง | /association-members มี modal แก้ไข |
| สร้าง Member → สร้าง AssociationMember อัตโนมัติ | ✅ ตรง | members.service.ts บรรทัด 66 |
| Dashboard สรุปสมาชิกรายบุคคล | ✅ ตรง | /members/[id]/profile มี: อายุสมาชิก, ยอดชำระรวม, อัตราการชำระ, สิทธิประโยชน์, กราฟประวัติการชำระ, รายการค้างชำระ, ประวัติการรับเงินสงเคราะห์ |

---

## 2. doc/ASSOCIATION_MEMBER_SPEC.md

| สเปก | สถานะ | หมายเหตุ |
|------|--------|----------|
| Schema | ✅ ตรง | schoolId, memberTypeId, onDelete: Cascade |
| GET /api/association-members (filter: schoolId, search, status, page, limit) | ✅ ตรง | Controller รองรับครบ |
| GET /api/association-members/:memberId | ✅ ตรง | findByMemberId |
| PATCH /api/association-members/:memberId | ✅ ตรง | update by memberId |
| กฎธุรกิจ: สร้าง Member → สร้าง AssociationMember | ✅ ตรง | ใน members.service |
| กฎธุรกิจ: ลบ Member → ลบ AssociationMember (Cascade) | ✅ ตรง | schema onDelete: Cascade |
| Multi-tenant: filter schoolId | ✅ ตรง | Service ใช้ schoolId ใน where |

---

## 3. doc/EXCEL_IMPORT_README.md

| สเปก | สถานะ | หมายเหตุ |
|------|--------|----------|
| โครงสร้าง Excel (โรงเรียน, header, ข้อมูล) | ✅ ตรง | script รองรับ |
| "Member ต้องมีอยู่แล้วใน DB" | ❌ **ล้าสมัย** | excel-to-migration ปัจจุบันสร้าง Member จาก Excel แล้ว (seed_members_from_excel) |
| ลำดับ: School ก่อน → AssociationMember หลัง | ⚠️ ปรับ | ลำดับจริง: 1) School 2) Member 3) AssociationMember |
| **แนะนำ:** อัปเดต README | - | บอกว่า script สร้าง 3 migrations และ Member มาจาก Excel โดยตรง |

---

## 4. context.md

| หัวข้อ | สถานะ | หมายเหตุ |
|--------|--------|----------|
| School, Member, MemberType, Group, Beneficiary | ✅ ตรง | มีครบใน schema |
| ContributionPeriod, MemberContribution | ✅ ตรง | มีครบ |
| DeathClaim, DeathBenefitPayment | ✅ ตรง | มีครบ |
| Account, LedgerEntry, Receipt, PaymentVoucher | ✅ ตรง | มีครบ |
| BankAccount | ✅ ตรง | ไม่มี CashBook แยก – ใช้ BankAccount |
| CashBook | ⚪ ไม่มี | context ระบุ "optional for future" |
| Asset & Depreciation | ⚪ ไม่มี | context ระบุ "optional" |
| Role: ADMIN, FINANCE, ACCOUNTING, GROUP_LEADER, VIEWER | ✅ ตรง | มีครบ |
| เมนู 9 กลุ่มของ legacy | ⚠️ ปรับ | ปัจจุบันจัดเป็น 3 กลุ่มหลัก (ข้อมูลหลัก, งานสมาคม, งานฌาปนกิจ) |

---

## 5. plan.md & tasks.md

| หัวข้อ | สถานะ |
|--------|--------|
| Phase 8 – สมาชิกสมาคม & Dashboard รายบุคคล | ✅ เสร็จ |
| Phase 9 – UX, เมนู 8 sections | ⚠️ ปรับเป็น 3 กลุ่มหลักแล้ว |
| tasks.md – บางรายการยังไม่ทำ | ดูรายละเอียดด้านล่าง |

---

## สรุปความต่าง / สิ่งที่ควรปรับ

### ที่ควรอัปเดตใน doc/

1. **EXCEL_IMPORT_README.md**
   - แก้จาก "Member ต้องมีอยู่แล้ว" เป็น "script สร้าง School, Member และ AssociationMember จาก Excel"
   - บอกลำดับ migration: 1) seed_schools 2) seed_members 3) seed_association_member
   - บอกว่าต้องมี MemberType (จาก `prisma db seed`) ก่อนรัน migration

### Logic ที่สอดคล้องกับเอกสารแล้ว

- AssociationMember: สร้างอัตโนมัติเมื่อสร้าง Member, ลบแบบ cascade
- API association-members: filter และ PATCH ตรงตาม ASSOCIATION_MEMBER_SPEC
- Dashboard รายบุคคล: มีข้อมูลตาม UPGRADE_SPEC
- โครงสร้าง Excel และการ parse ตรงกับ EXCEL_IMPORT_README (ยกเว้นเรื่อง Member)

### สิ่งที่ยังไม่ได้ทำตาม context/plan (เป็น optional หรือ Phase ถัดไป)

- CashBook, Asset, Depreciation (context ระบุ optional)
- Member create/edit form ที่สมบูรณ์
- Death claim print/export
- E2E tests
