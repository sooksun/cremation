---
name: verify
description: Runtime verification recipe for the cremation system — how to boot the API against the local dev DB, get an authenticated session, and drive endpoints.
---

# Verifying the cremation system at runtime

## Build / launch

- API: `pnpm dev:api` (repo root, background) → NestJS on `http://localhost:3001`, global prefix `api`. Boot needs MySQL `cremation_db` on localhost:3306 (Laragon) and `apps/api/.env` (already present). Hot-reloads on edit (`nest start --watch`).
- Web: `pnpm dev:web` → :3000. Pages are client-side React Query; curl can't render them — verify the API surface, or drive with a browser.

## Auth handle

- Seed users have random passwords (`generateTemporaryPassword`) — you cannot log in as them.
- Recipe: create temp users directly with a Node script **run from `apps/api/`** (module resolution — scripts outside the repo can't `require('@prisma/client')`):
  upsert `verify_admin` (ADMIN) / `verify_finance` (FINANCE + schoolId) with a bcrypt hash of a known password, `mustChangePassword: false`.
- Login: `POST /api/auth/login {username,password}` — the JWT is set as an httpOnly **cookie**, not in the body. Use `curl -c jar.txt` then `-b jar.txt` for subsequent calls.
- Cleanup: temp users acquire `AuditLog` rows (USER_LOGIN, REPORT_GENERATE, …) with an FK — delete their auditLog rows first, then the users.

## Useful fixtures in the dev DB

Query with a temp Prisma script: first `School`, a `DECEASED` member (for locked-record guard probes), first `ContributionPeriod`. There may be no `RESIGNED` member seeded.

## Gotchas

- `prisma migrate dev` FAILS in this repo: migration `20250217000000_add_association_member` sorts before `20251126144339_init`, so shadow-DB replay breaks. Hand-author the migration SQL (enum changes must relist ALL values) and apply with `prisma migrate deploy`, following `prisma/migrations/20260622084428_*`.
- `pnpm lint` is broken in both apps (no ESLint config) — use `pnpm build:api` / `pnpm build:web` as the type gate.
