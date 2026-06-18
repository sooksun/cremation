# Plan – Cremation Welfare Management System for Teachers

## Phase 0 – Setup & Infrastructure
- [x] Initialize monorepo with apps/api (NestJS) and apps/web (Next.js).
- [x] Setup TailwindCSS in web app.
- [x] Configure Prisma with MySQL connection.
- [x] Create base Prisma schema and run initial migration.
- [x] Implement basic auth (login, JWT, roles: ADMIN, FINANCE, ACCOUNTING, GROUP_LEADER, VIEWER).

## Phase 1 – Master Data & Users
- [x] Users & Roles module.
- [x] School management.
- [x] MemberType management.
- [x] Groups (collection groups / units).
- [x] Chart of Accounts & bank accounts.

## Phase 2 – Member Registry
- [x] Member CRUD (create, read, update, soft delete).
- [x] Beneficiary management (up to 3 per member).
- [x] Member status transitions (ACTIVE ↔ ARREARS, RESIGNED, DECEASED).
- [x] Import/export member list (CSV).

## Phase 3 – Contributions & Monthly Welfare
- [x] ContributionPeriod setup (rate per member, service fee).
- [x] MemberContribution generation per period (based on active members).
- [x] Record payments per member (cash / bank, collector).
- [x] Arrears tracking & simple reminder list.

## Phase 4 – Death Claims & Benefit Calculation
- [x] DeathClaim creation from a deceased member.
- [x] Benefit calculation logic (use number of active members * welfare rate minus fees).
- [x] DeathBenefitPayment recording (link to payment voucher & bank).
- [x] Printable / exportable death claim form.

## Phase 5 – Finance & Accounting
- [x] Receipts (member payments, other income).
- [x] Payment vouchers (death benefit, expenses).
- [x] Automatic ledger entries for each receipt/voucher.
- [x] Trial balance, balance sheet, P&L (basic versions).

## Phase 6 – Bank & Assets
- [x] Deposit and withdrawal operations against bank accounts.
- [x] Bank balance reports.
- [ ] Asset & depreciation model (basic list + yearly depreciation).

## Phase 7 – Reporting & Period Closing
- [x] Daily reports: cash/bank movement, receipts, payments.
- [x] Monthly reports: member stats, arrears, income & expense summary.
- [x] Yearly reports: member statistics and welfare summary.
- [x] Period closing utilities (mark period closed, prevent editing).

## Phase 8 – Upgrade: สมาชิกสมาคม & Dashboard รายบุคคล (ก.พ. 2568)
- [x] ทะเบียนสมาชิกสมาคมผู้ประกอบวิชาชีพ อำเภอแม่ฟ้าหลวง (CRUD)
- [x] Dashboard สรุปข้อมูลสมาชิกรายบุคคล
- [x] เอกสารสเปกใน doc/
- [x] โครงสร้างข้อมูล: สมาชิกสมาคมเป็นหลัก สมาชิกฌาปนกิจอ้างอิงจากสมาชิกสมาคม

## Phase 9 – UX Polish & Hardening
- [x] Sidebar menu with 8 main sections mapped from legacy app.
- [x] School + year selector pinned in the top bar.
- [x] Role-based menu visibility.
- [x] Error handling, access-denied pages, loading states.
- [x] Basic e2e tests for critical flows.

## Phase A – Security Hardening (มิ.ย. 2569) [x]
- JWT secret validation, httpOnly cookie auth, school scoping, GROUP_LEADER scope, PII masking, rate limiting, helmet/CORS, mustChangePassword, audit log

## Phase B – Missing Features (มิ.ย. 2569) [x]
- Death claim print, CSV import/export, financial statements, bank transactions, period close guard, death benefit calculator, daily report

## Phase C – Quality & Stability (มิ.ย. 2569) [x]
- Unit tests, E2E critical flow, remove debug logging, update docs, error boundary, access-denied page, VIEWER read-only guard

## Phase D – Production Ready (มิ.ย. 2569) [x]
- [x] Dockerfile.api / Dockerfile.web / docker-compose.prod.yml
- [x] Daily DB backup script (`backup/backup.sh`)
- [x] NPM reverse proxy config (`deploy/npm-proxy-host.md`)
- [x] CI pipeline (`.github/workflows/ci.yml`)
- [x] Prisma binaryTargets for Docker OpenSSL