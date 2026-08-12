# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Cremation Welfare Management System (ระบบฌาปนกิจสงเคราะห์ครู) — multi-school, multi-year welfare
association system. Domain details (entities, business rules, benefit calculation) live in
[context.md](context.md); roadmap in [plan.md](plan.md); task tracking in [tasks.md](tasks.md).
Read these before major feature work — they take precedence over this file for domain rules.

pnpm monorepo: `apps/api` (NestJS + Prisma + MySQL) and `apps/web` (Next.js 15 App Router).

## Commands

Run from repo root (pnpm workspace filters target each app):

```bash
pnpm dev              # both apps
pnpm dev:api          # NestJS on :3001 (nest start --watch)
pnpm dev:web          # Next.js on :3000

pnpm build:api / pnpm build:web
pnpm lint             # both apps

pnpm db:generate      # prisma generate
pnpm db:migrate       # prisma migrate dev
pnpm db:seed          # ts-node prisma/seed.ts
pnpm db:studio        # prisma studio

pnpm test             # apps/api jest unit tests
pnpm test:e2e         # apps/api e2e (test/critical-flow.e2e-spec.ts)
```

Single test file / single test (run inside `apps/api`):

```bash
cd apps/api
npx jest src/death-claims/death-benefit-calculator.service.spec.ts
npx jest src/death-claims/death-benefit-calculator.service.spec.ts -t "test name"
npx jest --config ./test/jest-e2e.json -t "test name"
```

Schema changes: edit `apps/api/prisma/schema.prisma` → `npx prisma format` → `pnpm db:migrate` →
update `apps/api/prisma/seed.ts` to stay in sync.

The `prisma/` directory at repo root is legacy/deprecated — the active schema is
`apps/api/prisma/schema.prisma`.

## Architecture

### Backend (`apps/api/src`)

One NestJS module per domain area, each wired into `app.module.ts`: `auth`, `users`, `schools`,
`school-clusters`, `member-types`, `groups`, `association-members`, `members`,
`member-applications`, `contributions`, `death-claims`, `accounts`, `bank-accounts`, `assets`,
`cash-book`, `receipts`, `payments`, `reports`, `audit-logs`, `school-admins`.

**Person model is two-layered**: `AssociationMember` is the source-of-truth for a person's
identity (name, ID card, school, member type) — not everyone in the association joins the
cremation fund. `Member` (สมาชิกฌาปนกิจ) references an `AssociationMember` 1:1 and adds only
cremation-fund-specific fields (status, join/resign/death dates, group, beneficiaries). When
touching member data, decide which layer a field belongs to.

**Global guard/interceptor stack** (registered in `app.module.ts`, applies to every request):
- `ThrottlerGuard` — rate limiting (100 req/60s default)
- `ViewerReadOnlyGuard` — blocks mutating requests for `VIEWER` role globally
- `SchoolScopeInterceptor` — enforces school-scoped data access

**Auth/RBAC** (`src/auth`):
- Roles enum (`Role` in Prisma schema): `ADMIN`, `SCHOOL_ADMIN`, `FINANCE`, `ACCOUNTING`,
  `GROUP_LEADER`, `VIEWER`, `MEMBER`.
- Per-route: `@UseGuards(JwtAuthGuard)` at controller level, `@UseGuards(RolesGuard)` +
  `@Roles(Role.X, Role.Y)` per mutating endpoint.
- `src/common/security/school-scope.service.ts` (`SchoolScopeService`) is the source of truth for
  scoping logic — `assertSchoolAccess`, `assertResourceSchoolAccess`, `resolveSchoolId`,
  `assertMemberSelfAccess` (for `MEMBER`-role self-service accounts), `assertGroupLeaderCanPay`
  (group leaders can only record payment for members in their own group). Reuse these rather than
  re-deriving scoping checks in services.
- `MEMBER` role is a self-service login tied 1:1 to a `Member` record (`User.memberId`) — scoped
  to their own data only.
- PII masking (`src/common/utils/pii.util.ts`): ID card / national ID numbers are masked for all
  roles except `ADMIN`, `SCHOOL_ADMIN`, `FINANCE` — use `applyIdCardMask` /
  `applyNationalIdMask` when returning these entities from a service.
- `AuditLogService` (`src/common/services/audit-log.service.ts`) — sensitive mutations (role
  changes, death claim approval, PII edits, settings changes) should log via `AuditAction` enum
  values; check an existing service (e.g. `death-claims.service.ts`) for the call pattern before
  adding a new mutation.
- `DocumentNumberService` (`src/common/document-number.service.ts`) generates all document
  numbers (receipts `R202412-M0001`, vouchers `PV-2024-0001`, member no `M0001`, period
  `CP-202412`, death claims `DC-2024-0001`, bank txns `BT-2024-0001`) — always use this instead of
  hand-rolling sequence numbers.

**Money math**: all monetary fields are Prisma `Decimal`. Death benefit calculation logic lives
in `death-claims/death-benefit-calculator.service.ts` — it is snapshotted onto the `DeathClaim`
row at creation time (active member count, rate, totals) rather than recomputed live, so historical
claims stay correct even if rates change later.

**Dates**: stored/queried as Gregorian (ISO) throughout the API and DB. Thai Buddhist Era (พ.ศ.)
conversion happens only at the `apps/web` UI boundary — never convert in `apps/api`.

### Frontend (`apps/web/src`)

- App Router; almost all authenticated pages live under `app/(dashboard)/<domain>` (one folder per
  module, mirroring the API's domain split — `members`, `contributions`, `death-claims`, etc).
- `lib/api.ts` — shared axios instance (`api`), auto-redirects to `/login` on 401 and to
  `/change-password` on the "must change password" 403. Domain TypeScript interfaces
  (`Member`, `School`, etc.) are also colocated here.
- `lib/route-access.ts` — client-side route gating per role (`ROLE_BLOCKED_PREFIXES`,
  `isPathAllowedForRole`); mirrors (but does not replace) server-side `RolesGuard` checks. Update
  both when changing what a role can reach.
- `store/` — Zustand (`useAuthStore` holds session/role/school/member scoping used across the app).
- State/data fetching: TanStack Query on top of the axios client.
- PDF/export generation: `lib/export-pdf.ts`, `lib/membership-register-pdf.ts` (pdf-lib + fontkit
  for Thai fonts), `lib/export-csv.ts`.

## Security & multi-tenancy invariants

- Every operational query must filter by `schoolId` (or be explicitly global, like `MemberType`,
  `BankAccount`, `Account`) — see `SchoolScopeService` for the enforcement helpers.
- `JWT_SECRET` must be ≥32 chars; boot fails fast via `validateEnv()` (`src/config/env.validation.ts`)
  if missing, and in production also requires `CORS_ORIGINS`/`FRONTEND_URL` and forbids
  `ALLOW_ALL_ORIGINS`.
- Passwords hashed with bcrypt (`common/utils/password.util.ts`); never return `passwordHash` from
  an API response.
- CSP/HSTS/helmet hardening is prod-only (relaxed in dev for local debugging) — see `main.ts`.

## Deployment

Docker/Ubuntu/NPM production deploy conventions (port allocation, Prisma binaryTargets, pnpm
deploy gotchas, NPM proxy host setup) are documented in the global CLAUDE.md and
[SETUP_UBUNTU.md](SETUP_UBUNTU.md) — consult those before touching `Dockerfile.api`,
`Dockerfile.web`, or `docker-compose.prod.yml`.

Server access details (SSH host/user/key, real deploy path and ports) live in `CLAUDE.local.md`
at the repo root — gitignored, since this repository is public. Read it before any deploy or
log-reading task; the host and ports in `SETUP_UBUNTU.md` are stale. Never copy its contents into
a tracked file.
