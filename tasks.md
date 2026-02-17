# Tasks

## 0. Repository & tooling
- [x] Setup monorepo: `apps/api`, `apps/web`, `prisma`.
- [x] Configure TypeScript base config and path aliases.
- [x] Install dependencies:
  - NestJS, Prisma, @prisma/client
  - Next.js, React, TailwindCSS
  - class-validator, bcrypt, jsonwebtoken, etc.

## 1. Prisma & Database
- [x] Implement initial `prisma/schema.prisma` as defined.
- [ ] Run `npx prisma migrate dev --name init`.
- [x] Implement `prisma/seed.ts`:
  - Create schools (3).
  - Create member types.
  - Create groups for each school.
  - Create sample members with different statuses.
  - Create a few contribution periods and contributions.
  - Create at least one death claim and payment.

## 2. Backend – Auth & Users
- [x] Create NestJS app (apps/api).
- [x] Implement User & Auth modules:
  - Register admin user via seed script.
  - JWT login, password hashing.
  - Role-based guards.

## 3. Backend – Master Data
- [x] Schools CRUD endpoints.
- [x] MemberTypes CRUD.
- [x] Groups CRUD.
- [x] ChartOfAccounts + BankAccount endpoints.

## 4. Backend – Members & Beneficiaries
- [x] Member CRUD with filters: by school, status, member type.
- [x] Beneficiary sub-resource.
- [x] Status change endpoints (resign, deceased, arrears).

## 5. Backend – Contributions
- [x] ContributionPeriod endpoints (create, list, close).
- [x] Generate MemberContributions for a period.
- [x] Record payment (link to Receipt).
- [x] List arrears by school / group / period.

## 6. Backend – Death Claims
- [x] Create DeathClaim from member.
- [x] Implement benefit calculation service.
- [x] Record DeathBenefitPayment and link to PaymentVoucher.
- [ ] Exportable DTO for printable form.

## 7. Backend – Finance & Accounting
- [x] Receipt endpoints (with auto ledger creation).
- [x] PaymentVoucher endpoints (with auto ledger).
- [x] Ledger query (by account, date range).
- [x] Trial balance endpoint.

## 8. Frontend – Layout & Navigation
- [x] Global layout with sidebar (menus 1–8).
- [x] School + year selector in top bar.
- [x] Login page and session handling.
- [x] Protected routes with role checks.

## 9. Frontend – Core Screens
- [x] Member list + status badges.
- [x] Schools management page.
- [x] Death claims list with stats.
- [x] Dashboard with KPIs and charts.
- [ ] Member create/edit form.
- [ ] ContributionPeriod list and detail (members & payments).
- [ ] Arrears report page.
- [ ] DeathClaim detail with print-friendly view.

## 10. Documentation & polish
- [x] Keep `README.md` updated.
- [x] Add example environment variables in README.
- [ ] Add a short "data model overview" diagram in docs if needed.
- [ ] Basic e2e tests for critical flows.

---

## Upgrade: สมาชิกสมาคม & Dashboard รายบุคคล
- [x] เพิ่ม model AssociationMember ใน Prisma schema
- [x] Migration add_association_member
- [x] API /association-members (GET list, GET :id, PATCH :id)
- [x] หน้าทะเบียนสมาชิกสมาคม + modal แก้ไข
- [x] เมนู "สมาชิกสมาคม" และลิงก์ "Dashboard รายบุคคล" ในรายการสมาชิก
- [x] doc/UPGRADE_SPEC.md และ doc/ASSOCIATION_MEMBER_SPEC.md

## การวิเคราะห์ doc/ vs ระบบ (ก.พ. 2568)

ดูรายละเอียดใน `doc/ANALYSIS_DOC_VS_SYSTEM.md`

**สรุป:** สเปกใน UPGRADE_SPEC และ ASSOCIATION_MEMBER_SPEC ตรงกับระบบแล้ว  
**ปรับแล้ว:** EXCEL_IMPORT_README อัปเดตให้ตรงกับ excel-to-migration (สร้าง School + Member + AssociationMember)

## Next Priority Tasks

1. [x] Run migration and seed to test the system
2. [ ] Complete member create/edit form
3. [ ] Add contribution period management pages
4. [ ] Add print/export functionality for death claims
5. [ ] Add more reports (arrears, financial statements)
