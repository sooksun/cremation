# Plan – Cremation Welfare Management System for Teachers

## Phase 0 – Setup & Infrastructure
- [ ] Initialize monorepo with apps/api (NestJS) and apps/web (Next.js).
- [ ] Setup TailwindCSS in web app.
- [ ] Configure Prisma with MySQL connection.
- [ ] Create base Prisma schema and run initial migration.
- [ ] Implement basic auth (login, JWT, roles: ADMIN, FINANCE, ACCOUNTING, GROUP_LEADER, VIEWER).

## Phase 1 – Master Data & Users
- [ ] Users & Roles module.
- [ ] School management.
- [ ] MemberType management.
- [ ] Groups (collection groups / units).
- [ ] Chart of Accounts & bank accounts.

## Phase 2 – Member Registry
- [ ] Member CRUD (create, read, update, soft delete).
- [ ] Beneficiary management (up to 3 per member).
- [ ] Member status transitions (ACTIVE ↔ ARREARS, RESIGNED, DECEASED).
- [ ] Import/export member list (CSV).

## Phase 3 – Contributions & Monthly Welfare
- [ ] ContributionPeriod setup (rate per member, service fee).
- [ ] MemberContribution generation per period (based on active members).
- [ ] Record payments per member (cash / bank, collector).
- [ ] Arrears tracking & simple reminder list.

## Phase 4 – Death Claims & Benefit Calculation
- [ ] DeathClaim creation from a deceased member.
- [ ] Benefit calculation logic (use number of active members * welfare rate minus fees).
- [ ] DeathBenefitPayment recording (link to payment voucher & bank).
- [ ] Printable / exportable death claim form.

## Phase 5 – Finance & Accounting
- [ ] Receipts (member payments, other income).
- [ ] Payment vouchers (death benefit, expenses).
- [ ] Automatic ledger entries for each receipt/voucher.
- [ ] Trial balance, balance sheet, P&L (basic versions).

## Phase 6 – Bank & Assets
- [ ] Deposit and withdrawal operations against bank accounts.
- [ ] Bank balance reports.
- [ ] Asset & depreciation model (basic list + yearly depreciation).

## Phase 7 – Reporting & Period Closing
- [ ] Daily reports: cash/bank movement, receipts, payments.
- [ ] Monthly reports: member stats, arrears, income & expense summary.
- [ ] Yearly reports: member statistics and welfare summary.
- [ ] Period closing utilities (mark period closed, prevent editing).

## Phase 8 – Upgrade: สมาชิกสมาคม & Dashboard รายบุคคล (ก.พ. 2568)
- [x] ทะเบียนสมาชิกสมาคมผู้ประกอบวิชาชีพ อำเภอแม่ฟ้าหลวง (CRUD)
- [x] Dashboard สรุปข้อมูลสมาชิกรายบุคคล
- [x] เอกสารสเปกใน doc/

## Phase 9 – UX Polish & Hardening
- [ ] Sidebar menu with 8 main sections mapped from legacy app.
- [ ] School + year selector pinned in the top bar.
- [ ] Role-based menu visibility.
- [ ] Error handling, access-denied pages, loading states.
- [ ] Basic e2e tests for critical flows (create member, record contribution, record death claim).
