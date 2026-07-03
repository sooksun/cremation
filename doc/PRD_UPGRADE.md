# PRD — Cremation Welfare System Upgrade (against legacy `doc/manual.pdf`)

**Date:** 2026-07-03
**Source material:** `doc/manual.pdf` (37-page user manual for "tca1.ifsct.net", the legacy
"Cremation Good App" reference system operated by a savings-cooperative federation, dated 2012),
cross-checked against current implementation (`apps/api`, `apps/web`), `context.md`, `plan.md`,
`doc/SYSTEM_AUDIT_REPORT.md` (2026-06-22).
**Status:** Draft for review — no code changes made yet.

## 1. Background

`context.md` already names "Cremation Good App" as this project's legacy reference (9 menu
groups). `doc/manual.pdf` is that legacy app's user manual. It documents two things:

- **Pages 1–19**: data-entry screens (new application, edit application, member registry
  view/edit, resignation/death reporting, bulk group payment) and Firefox pop-up-blocker
  troubleshooting (obsolete — reports opened as PDF in a new browser tab).
- **Pages 20–37**: a report catalog — Group 1 "รายงานประจำวัน" (7 on-demand reports, 1.1–1.7),
  Group 2 "รายงานประจำวันเดือน" (4 monthly reports, 2.1–2.4), and Group 3 "รายงานประจำวันปี"
  (yearly reports — referenced in the nav but never expanded in the manual; content unknown).

Important caveat: the legacy system served **multiple affiliated cooperative associations**
(teachers, police, military, government, etc.) through one multi-tenant portal, keyed by
สมาคม (association) → สาขา/ศูนย์ประสานงาน (branch). The current system is scoped to one
association serving multiple **schools** (`School`, `SchoolCluster`). Treat the manual as a
feature/report catalog to mine for parity, not a literal architecture to copy — some legacy
mechanics (fee %, prepaid-balance model) belong to a different association's rules and must be
verified against this association's actual regulations (ระเบียบ) before being ported as-is.

## 2. Goals

- Reach report/feature parity with the legacy manual where the underlying business need still
  applies to this association, closing gaps identified in Section 4.
- Resolve the open architectural question in Section 5 (prepaid-balance model vs. current
  recurring-billing model) before building report parity that assumes one or the other.
- Do not regress existing functionality (Section 6 lists confirmed non-goals / already-covered
  areas).

## 3. Current system snapshot (for reference)

Already implemented and confirmed via code read (`apps/api/src/reports/reports.controller.ts`,
`reports.service.ts`, `members.service.ts`, `death-benefit-calculator.service.ts`,
`contributions.service.ts`):

- Dual ID scheme: `Member.memberNo` (เลขฌาปนกิจ) + `AssociationMember.associationMemberNo`
  (เลขทะเบียนสมาคม) — matches the legacy's two-ID pattern (1.4, 1.6, 1.7 report columns).
- Reports already built: dashboard, member stats, contribution report, financial summary, daily
  movement, cash flow, death-benefit report, board-monthly, death-fund-reserve, executive
  dashboard, finance dashboard, member-profile, changes-in-equity, trial balance.
- Recurring monthly billing model (`ContributionPeriod` + `MemberContribution`): admin sets a
  `welfareRate`/`serviceFee` per period, system bills all active members that amount, tracks
  paid/arrears. This is **not** the same mechanic as the legacy prepaid-balance drawdown (see
  Section 5).
- Death benefit payout ratio is a configurable `payoutRatio` (default 0.9, i.e. 10% total
  deduction) — different from the legacy manual's observed 1%+2%=3% fee split. This is expected:
  they're different associations with different ระเบียบ (regulations); no action needed unless
  the association's actual rules say otherwise.

## 4. Gap analysis vs. `doc/manual.pdf`

| # | Legacy feature (manual section) | Current status | Gap / action |
|---|---|---|---|
| 1 | 1.1/1.2/1.3 — Membership application report, 3 variants filtered by coverage date / application date / data-entry date respectively | `getMemberStats` exists but doesn't expose 3 distinct date-filter variants | **Gap.** Confirm `Member`/`AssociationMember` already store all 3 dates (`joinDate`≈coverage, `applicationSubmittedAt`≈application date — data-entry/`createdAt` timestamp exists). Add a report with a date-field selector (coverage / applied / recorded) rather than 3 separate endpoints. |
| 2 | 1.4 — Member registry report (dual ID, grouped by branch) | Members list page + CSV export exist | **Partial.** Add a formatted/printable registry report grouped by school, showing both ID numbers side by side. |
| 3 | 1.5 — Individual member "passbook" (สมุดประจำตัวสมาชิก): running ledger of fees/deductions with a remaining-balance column, printable, includes beneficiary signature line | `member-profile` report shows payment history + benefits, but no prepaid-balance running total (no such balance exists in this system's model — see Section 5) | **Gap, contingent on Section 5 decision.** If the association wants a "passbook" statement, it can be built from `MemberContribution` + `Receipt`/`DeathBenefitPayment` history without a prepaid-balance concept — a running transaction statement, printable as PDF. |
| 4 | 1.6 — Death notification report (per-death gross/fee/net columns, date-range on death date, summary totals) | `getDeathBenefitReport(year)` exists but is year-scoped, not arbitrary date-range, and needs to be checked for fee-breakdown columns | **Gap.** Add date-range filtering (not just year) and ensure output includes gross amount, deduction amount, and net amount as separate columns with a totals row, matching the report style. |
| 5 | 1.7 — Resignation report (date range, reason, summary count) | No dedicated resignation report found in `reports.service.ts` | **Gap.** `Member.membershipEndReason` / `resignDate` already exist on the model — add a report endpoint filtering by resignation date range. |
| 6 | Menu items "รายงานรับชำระ" (payment/receipts report) and "รายงานการจ่าย" (disbursement report) — referenced in the legacy nav but never detailed in the manual | `Receipt`/`PaymentVoucher` models and CRUD exist, but no dedicated printable receipts-ledger / disbursement-ledger report by date range was found | **Gap.** Add two report endpoints: receipts issued in a date range (by type, with totals) and payments/vouchers issued in a date range (by type, with totals) — standard cash-basis reconciliation reports. |
| 7 | 2.1/2.2 — Monthly deduction report (per-member and per-branch rollup) driven by "N deaths this month × per-death assessment ÷ pool" | `board-monthly` and `getFinanceDashboard` cover monthly aggregates, but the specific "assessment per death this month" mechanic doesn't apply under the current recurring-billing model | **Contingent on Section 5.** Not a direct gap under the current model; revisit if Section 5 changes the contribution mechanic. |
| 8 | 2.3/2.4 — Transaction "posting/cut-off" report (individual and branch-level), tied to a formal monthly batch posting run | `closePeriod` exists (locks a period) but there's no explicit "posting run" audit report showing what changed at cut-off | **Gap, lower priority.** Consider a "period close summary" report (per-school and per-member) generated at the moment a period is closed, for audit/reconciliation purposes — likely overlaps with `doc/SYSTEM_AUDIT_REPORT.md`'s "Period Closing Workflow" recommendation. |
| 9 | 3 — Yearly reports group | Referenced in legacy nav, **never documented in the manual itself** (manual ends after 2.4) | **Unknown — not actionable from this source.** Cannot scope without seeing the live legacy system or another reference. Treat existing yearly aggregates (`getMemberStats(year)`, `getDeathBenefitReport(year)`) as the current best-effort equivalent; do not block other work on this. |
| 10 | Data-entry duplicate-registration guard (warn if a previously-resigned member re-registers) | Not confirmed either way | **Verify.** Check `members.service.ts` create path for a check against previously-existing `RESIGNED`/`DECEASED` `AssociationMember` records before allowing a new `Member` record; add guard if missing. |
| 11 | Locked-record rule: once an application/resignation/death record is "approved," further edits are blocked and must go through the registry-edit screen instead | Current system's status-change endpoints — needs verification | **Verify.** Confirm the API prevents editing a `Member`'s core application fields after status has progressed past initial registration, consistent with the audit log / period-close-lock pattern already in place. |
| 12 | All reports render as generated PDF | `doc/SYSTEM_AUDIT_REPORT.md` already flags "PDF Export ที่สวยและครบ" as a gap (72% complete) | **Already tracked** — fold this PRD's new report list into that existing PDF-export workstream rather than treating as separate. |

## 5. Open decision: contribution/benefit funding model

The legacy manual describes a **prepaid mutual-aid balance model**: each member prepays a lump
sum (เงินสงเคราะห์ล่วงหน้า), and every month the system computes (deaths that month × a fixed
per-death assessment), divides it across the whole membership pool, and deducts each member's
share from their running prepaid balance (report 1.5's passbook, reports 2.1–2.4). When a
member's balance runs low, a bulk "ชำระเงินเป็นกลุ่ม" top-up/renewal cycle collects more.

The current system uses a **period-based recurring billing model**: an admin manually sets a
`welfareRate` per `ContributionPeriod` (month), and every active member is billed that flat
amount for the period, tracked as paid/arrears — the rate is not derived from that period's
actual death count.

These are materially different funding mechanics. Before building report parity items #3 and #7
above, decide:

- **Option A (recommended default — no architecture change):** Keep the current recurring-billing
  model (it already matches `context.md`'s documented business rules and is live in production).
  Build the "passbook" and per-death reports as read-only *statements* derived from existing
  `MemberContribution`/`Receipt`/`DeathBenefitPayment` data, without introducing a prepaid-balance
  ledger.
- **Option B (larger scope):** Introduce a real prepaid-balance ledger per member (new model +
  monthly draw-down job) to match the legacy mechanic exactly. This is a significant schema and
  business-logic change — only pursue if the association has explicitly decided to switch funding
  models, not merely to match the old manual's report format.

**This PRD assumes Option A** unless the user says otherwise; all P1/P2 items below are scoped
accordingly.

## 6. Non-goals / already covered

- Multi-association (multi-tenant-beyond-schools) architecture — out of scope; current system's
  school/cluster scoping is the correct level of tenancy for this association.
- Firefox pop-up-blocker workarounds — obsolete, current system serves reports in-app/downloadable.
- Re-litigating items already tracked in `doc/SYSTEM_AUDIT_REPORT.md` (audit log UI, rate
  limiting/password policy, full double-entry validation, Asset/Depreciation) — those stand as
  separately scoped work; this PRD only adds the manual-specific report gaps above.
- The legacy 1%+2% death-benefit fee split — this is a different association's rule; do not port
  it without an explicit request to change this association's `payoutRatio`/deduction policy.

## 7. Proposed work items (priority order)

**P0 — reporting gaps with clear scope and existing data:**
1. Resignation report (date-range, reason, count) — gap #5.
2. Receipts ledger report + disbursement (payment voucher) ledger report, both date-range with
   totals — gap #6.
3. Death notification report: switch from year-only to date-range filter; confirm gross/fee/net
   columns and totals row — gap #4.

**P1 — reporting gaps needing a small model/format decision:**
4. Member registry report (dual-ID, printable, grouped by school) — gap #2.
5. Application report with selectable date-field (coverage / applied / recorded) — gap #1.
6. Per-member "statement" report (transaction history + running total, printable) as an Option-A
   passbook substitute — gap #3.

**P2 — process verification (may already be satisfied, needs confirmation not necessarily code):**
7. Verify duplicate-registration guard for previously resigned/deceased members — gap #10.
8. Verify locked-record behavior after status changes past initial registration — gap #11.
9. Period-close summary/audit report (individual + school rollup) — gap #8.

**Deferred / not actionable from this source:**
10. Yearly reports group (gap #9) — needs a different reference (live legacy system access or
    stakeholder interview) before it can be scoped.

## 8. Non-functional requirements

- All new reports must respect existing multi-school scoping (`SchoolScopeService`) and PII
  masking rules — no new report should bypass `assertResourceSchoolAccess`/`resolveSchoolId` or
  return unmasked ID card numbers to roles below `ADMIN`/`SCHOOL_ADMIN`/`FINANCE`.
- New reports should reuse the existing PDF-export approach already used for death-claim printing
  and membership register (`apps/web/src/lib/export-pdf.ts`, `membership-register-pdf.ts`) rather
  than introducing a new PDF pipeline.
- Sensitive report generation (death notification, disbursement ledger) should be logged via
  `AuditLogService` consistent with other financially-sensitive actions.

## 9. Open questions for the user

1. Confirm Section 5's assumption (Option A: keep recurring billing, no prepaid-balance ledger).
2. Is there a way to inspect the *live* legacy `tca1.ifsct.net` system (or another manual) to
   scope the undocumented "รายงานประจำวันปี" (yearly reports) and the undocumented
   "รายงานรับชำระ"/"รายงานการจ่าย" report layouts precisely, rather than inferring from data
   already in this system?
3. Should the P0/P1 report items in this PRD be merged into the existing PDF-export workstream
   already tracked in `doc/SYSTEM_AUDIT_REPORT.md`, or tracked as a separate phase in `plan.md`?
