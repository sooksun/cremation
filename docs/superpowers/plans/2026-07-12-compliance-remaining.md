# Compliance Remaining Gaps (Phase 1) — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) หรือ superpowers:executing-plans เพื่อ implement ทีละ task. Steps ใช้ checkbox (`- [ ]`).

**Goal:** แก้ 6 ช่องว่าง compliance สูง/กลาง (bug เกษียณ, activeMemberCount ณ payDate, ที่อยู่ structured, approve workflow เต็ม, retention soft-delete, beneficiary priority) ให้ตรงระเบียบ พร้อม backfill ข้อมูลเดิม

**Architecture:** แก้ทีละ domain module (members, death-claims, member-applications, cash-book, bank-accounts) ตาม pattern เดิมของ repo; schema change ผ่าน `prisma db push` (shadow DB ใช้ไม่ได้); ทุก sensitive mutation → AuditLogService, ทุก operational query → SchoolScopeService; backfill เป็น ts-node script แยก มี dry-run

**Tech Stack:** NestJS, Prisma (MySQL 8), jest (ts-jest, rootDir=src), class-validator, Decimal

ที่มา: [design](../specs/2026-07-12-compliance-remaining-design.md) · [audit](../audits/2026-07-12-compliance-audit.md)

## Global Constraints

- **Money:** Prisma Decimal, ปัด `Math.round(x*100)/100` (2 ตำแหน่ง); แปลง `Number(...)` ก่อนคำนวณ
- **Dates:** stored Gregorian; พ.ศ. ที่ UI เท่านั้น (ห้าม convert ใน API)
- **Schema change:** `cd apps/api && npx prisma db push` (ไม่ใช่ migrate dev) — regenerate client อัตโนมัติ. Backup ก่อน: `"D:/laragon/bin/mysql/mysql-8.0.30-winx64/bin/mysqldump.exe" -uroot -h127.0.0.1 -P3306 --default-character-set=utf8mb4 --single-transaction cremation_db > "<scratchpad>/backup_<ts>.sql"`
- **Test:** `cd apps/api && npx jest <path>`; single test `-t "name"`; build check `npx tsc --noEmit -p tsconfig.build.json`
- **mysql client:** `"D:/laragon/bin/mysql/mysql-8.0.30-winx64/bin/mysql.exe" -uroot -h127.0.0.1 cremation_db --default-character-set=utf8mb4 -e "..."`
- **Audit:** `AuditLogService.log({ userId, action, entityType, entityId, schoolId?, metadata?, ipAddress? })` (`common/services/audit-log.service.ts:30`)
- **Scope:** `SchoolScopeService.assertSchoolAccess(user, schoolId)`, `resolveSchoolId(user, requested)` (`common/security/school-scope.service.ts`) — CommonModule เป็น `@Global` (inject ได้เลย)
- **Branch:** `compliance/death-claim-report-fixes`; commit แยกต่อ task
- **Reference pattern:** audit+scope+approve → `death-claims.service.ts:454-516` (`approveDisbursement`)

---

## File Structure

| ไฟล์ | รับผิดชอบ | Task |
|---|---|---|
| `apps/api/src/members/membership-rules.service.ts` | แก้ endReason RETIRED | 1 |
| `apps/api/src/members/membership-rules.service.spec.ts` | test getStatusChangeExtras | 1 |
| `apps/api/prisma/backfill/backfill-retired-reason.ts` | backfill RET→RETIRED | 1 |
| `apps/api/prisma/schema.prisma` | structured address, approve fields, deletedAt, beneficiary unique | 2,4,5,6 |
| `apps/api/src/member-applications/member-applications.service.ts` | map address structured + approve/reject workflow | 2,4 |
| `apps/api/src/member-applications/member-applications.controller.ts` | actor/ip + reject route | 4 |
| `apps/api/src/death-claims/death-claims.service.ts` | recompute snapshot ณ payDate | 3 |
| `apps/api/src/cash-book/cash-book.service.ts` | soft-delete + filter | 5 |
| `apps/api/src/bank-accounts/bank-accounts.service.ts` | soft-delete + filter | 5 |
| `apps/api/src/members/dto/beneficiary.dto.ts`, `dto/create-member.dto.ts` | validate priority | 6 |
| `apps/api/src/members/beneficiaries.service.ts` | dup priority guard | 6 |
| `apps/api/prisma/backfill/dedupe-beneficiary-priority.ts` | dedupe ก่อน unique | 6 |
| web (approve UI) | หน้า admin อนุมัติ/ปฏิเสธ | 4 |

---

## Task 1: #6 เกษียณ — endReason RETIRED (TDD)

**Files:**
- Modify: `apps/api/src/members/membership-rules.service.ts:70-88`
- Test: `apps/api/src/members/membership-rules.service.spec.ts`
- Create: `apps/api/prisma/backfill/backfill-retired-reason.ts`

**Interfaces:**
- `getStatusChangeExtras(newStatus: MemberStatus, memberTypeCode?: string, date?: string)` → `{ resignDate?, deathDate?, membershipEndReason? }` — เมื่อ `RESIGNED + memberTypeCode==='RET'` ต้องได้ `membershipEndReason = MembershipEndReason.RETIRED`

- [ ] **Step 1: อ่าน code ปัจจุบัน** `membership-rules.service.ts:70-108` เพื่อยืนยันโครง `getStatusChangeExtras` และ enum import (`MembershipEndReason`)

- [ ] **Step 2: เขียน failing tests** — เพิ่มใน `membership-rules.service.spec.ts` (describe ใหม่ `getStatusChangeExtras`)

```ts
describe('getStatusChangeExtras', () => {
  it('sets RETIRED reason for RET member resigning with date', () => {
    const extras = service.getStatusChangeExtras(MemberStatus.RESIGNED, 'RET', '2026-05-01');
    expect(extras.membershipEndReason).toBe(MembershipEndReason.RETIRED);
    expect(extras.resignDate).toEqual(new Date('2026-05-01'));
  });
  it('sets RESIGNED reason for non-RET member resigning with date', () => {
    const extras = service.getStatusChangeExtras(MemberStatus.RESIGNED, 'STF', '2026-05-01');
    expect(extras.membershipEndReason).toBe(MembershipEndReason.RESIGNED);
  });
  it('sets DECEASED reason with deathDate', () => {
    const extras = service.getStatusChangeExtras(MemberStatus.DECEASED, 'ORD', '2026-05-01');
    expect(extras.membershipEndReason).toBe(MembershipEndReason.DECEASED);
    expect(extras.deathDate).toEqual(new Date('2026-05-01'));
  });
});
```
> ตรวจว่า `getStatusChangeExtras` เป็น public/accessible จาก test (ถ้า private ให้เรียกผ่าน spy หรือเปลี่ยนเป็น public — ปัจจุบันถูกเรียกจาก members.service ภายนอก ควร public อยู่แล้ว)

- [ ] **Step 3: รัน test ให้ fail** — `cd apps/api && npx jest src/members/membership-rules.service.spec.ts -t "getStatusChangeExtras"` — Expected: test แรก FAIL (ได้ RESIGNED แทน RETIRED)

- [ ] **Step 4: แก้ implementation** — `membership-rules.service.ts:77-85` แทน block เดิมด้วย

```ts
    if (newStatus === MemberStatus.RESIGNED && date) {
      extras.resignDate = new Date(date);
      extras.membershipEndReason =
        memberTypeCode === 'RET'
          ? MembershipEndReason.RETIRED
          : MembershipEndReason.RESIGNED;
    } else if (newStatus === MemberStatus.DECEASED && date) {
      extras.deathDate = new Date(date);
      extras.membershipEndReason = MembershipEndReason.DECEASED;
    } else if (newStatus === MemberStatus.RESIGNED && memberTypeCode === 'RET') {
      extras.membershipEndReason = MembershipEndReason.RETIRED;
    }
```
> รวมเงื่อนไข RET เข้ากับ branch แรก (จับก่อน) — branch ที่ 3 คงไว้กันเคส RET+RESIGNED ที่ไม่มี date

- [ ] **Step 5: รัน test ให้ผ่าน** — `npx jest src/members/membership-rules.service.spec.ts` — Expected: PASS ทั้งไฟล์

- [ ] **Step 6: เขียน backfill script** — `apps/api/prisma/backfill/backfill-retired-reason.ts`

```ts
import { PrismaClient, MemberStatus, MembershipEndReason } from '@prisma/client';

// รัน: cd apps/api && npx ts-node --project tsconfig.json prisma/backfill/backfill-retired-reason.ts [--apply]
// default = dry-run (พิมพ์อย่างเดียว). ใส่ --apply เพื่อเขียนจริง
const APPLY = process.argv.includes('--apply');

(async () => {
  const prisma = new PrismaClient();
  try {
    const targets = await prisma.member.findMany({
      where: {
        status: MemberStatus.RESIGNED,
        membershipEndReason: { not: MembershipEndReason.RETIRED },
        associationMember: { memberType: { code: 'RET' } },
      },
      select: { id: true, memberNo: true, membershipEndReason: true },
    });
    console.log(`พบ ${targets.length} รายการ RET+RESIGNED ที่ reason != RETIRED`);
    targets.forEach((t) => console.log(`  ${t.memberNo}: ${t.membershipEndReason} -> RETIRED`));
    if (!APPLY) { console.log('DRY-RUN — ใส่ --apply เพื่อเขียนจริง'); return; }
    const ids = targets.map((t) => t.id);
    const res = await prisma.member.updateMany({
      where: { id: { in: ids } },
      data: { membershipEndReason: MembershipEndReason.RETIRED },
    });
    console.log(`อัปเดตแล้ว ${res.count} รายการ`);
  } finally {
    await prisma.$disconnect();
  }
})();
```

- [ ] **Step 7: dry-run backfill** — `cd apps/api && npx ts-node --project tsconfig.json prisma/backfill/backfill-retired-reason.ts` — Expected: พิมพ์รายการ ไม่เขียน DB (ไม่ต้อง --apply ตอนนี้ ปล่อยให้ user รันเอง)

- [ ] **Step 8: Commit**

```bash
git add apps/api/src/members/membership-rules.service.ts apps/api/src/members/membership-rules.service.spec.ts apps/api/prisma/backfill/backfill-retired-reason.ts
git commit -m "fix(members): retired teachers get RETIRED end reason (art.9.1.3) + backfill script"
```

---

## Task 2: #5 ที่อยู่ structured (TDD)

**Files:**
- Modify: `apps/api/prisma/schema.prisma` (model `AssociationMember`)
- Modify: `apps/api/src/member-applications/member-applications.service.ts:46-74`
- Test: `apps/api/src/member-applications/member-applications.service.spec.ts`

**Interfaces:**
- Produces: `AssociationMember` มี field `registeredHouseNo/Moo/Road/Soi/Subdistrict/District/Province/Zip` + `contactHouseNo/...Zip` (ทั้งหมด `String?`); คง `address String?` เป็น derived
- Consumes: `AddressDto` (submit-application.dto.ts:13-23) — structured ครบอยู่แล้ว

- [ ] **Step 1: Backup DB** (ก่อน schema change แรกของ session)

```bash
BK="<scratchpad>/backup_address_$(date +%Y%m%d_%H%M%S).sql"
"D:/laragon/bin/mysql/mysql-8.0.30-winx64/bin/mysqldump.exe" -uroot -h127.0.0.1 -P3306 --default-character-set=utf8mb4 --single-transaction cremation_db > "$BK" && echo "backup: $(wc -c < "$BK") bytes"
```
Expected: > 100KB

- [ ] **Step 2: เพิ่ม field ใน schema** — `model AssociationMember` (schema.prisma:270-289) ต่อจาก `address String?`

```prisma
  // ที่อยู่ทะเบียนราษฎร (structured — ระเบียบ ใบสมัคร)
  registeredHouseNo     String?
  registeredMoo         String?
  registeredRoad        String?
  registeredSoi         String?
  registeredSubdistrict String?
  registeredDistrict    String?
  registeredProvince    String?
  registeredZip         String?
  // ที่อยู่ติดต่อได้ (structured)
  contactHouseNo        String?
  contactMoo            String?
  contactRoad           String?
  contactSoi            String?
  contactSubdistrict    String?
  contactDistrict       String?
  contactProvince       String?
  contactZip            String?
```

- [ ] **Step 3: db push + regenerate** — `cd apps/api && npx prisma format && npx prisma db push` — Expected: "in sync" + generated client

- [ ] **Step 4: เขียน failing test** — `member-applications.service.spec.ts` (เพิ่ม test; ตรวจ mock `associationMember.create` รับ field structured)

```ts
it('persists registered + contact address as structured fields', async () => {
  const created = await captureAssociationMemberCreate(); // helper อ่าน arg ของ prisma.associationMember.create mock
  const dto = buildSubmitDto({
    registeredAddress: { houseNo: '99', moo: '2', subdistrict: 'แม่ฟ้าหลวง', district: 'แม่ฟ้าหลวง', province: 'เชียงราย', zip: '57240' },
    contactAddress: { houseNo: '10', road: 'พหลโยธิน', province: 'เชียงราย', zip: '57000', phone: '0810000000' },
  });
  await service.submit(dto);
  expect(created.registeredHouseNo).toBe('99');
  expect(created.registeredSubdistrict).toBe('แม่ฟ้าหลวง');
  expect(created.contactRoad).toBe('พหลโยธิน');
  expect(created.address).toContain('99'); // derived ยังถูกสร้าง
});
```
> ปรับ helper ตาม pattern spec เดิม (`member-applications.service.spec.ts:9-14` มี prisma mock — ต้องเพิ่ม field ใน mock return ถ้าจำเป็น)

- [ ] **Step 5: รัน test ให้ fail** — `npx jest src/member-applications/member-applications.service.spec.ts -t "structured"` — Expected: FAIL (field undefined)

- [ ] **Step 6: แก้ service** — `member-applications.service.ts:46-74`

```ts
    const reg = dto.registeredAddress;
    const con = dto.contactAddress ?? dto.registeredAddress;
    const address = this.formatAddress(con); // derived string คงไว้
    const phone = con?.phone ?? reg?.phone;
```
และใน object ที่ create `associationMember` (data) เพิ่ม mapping:

```ts
        registeredHouseNo: reg?.houseNo, registeredMoo: reg?.moo, registeredRoad: reg?.road,
        registeredSoi: reg?.soi, registeredSubdistrict: reg?.subdistrict, registeredDistrict: reg?.district,
        registeredProvince: reg?.province, registeredZip: reg?.zip,
        contactHouseNo: con?.houseNo, contactMoo: con?.moo, contactRoad: con?.road,
        contactSoi: con?.soi, contactSubdistrict: con?.subdistrict, contactDistrict: con?.district,
        contactProvince: con?.province, contactZip: con?.zip,
```

- [ ] **Step 7: รัน test + build** — `npx jest src/member-applications && npx tsc --noEmit -p tsconfig.build.json` — Expected: PASS + exit 0

- [ ] **Step 8: Commit**

```bash
git add apps/api/prisma/schema.prisma apps/api/src/member-applications/member-applications.service.ts apps/api/src/member-applications/member-applications.service.spec.ts
git commit -m "feat(member-applications): persist structured registered + contact address (art. ใบสมัคร)"
```

---

## Task 3: #7 activeMemberCount recompute ณ payDate (TDD)

**Files:**
- Modify: `apps/api/src/death-claims/death-claims.service.ts` (`recordPayment` ~:543-620)
- Test: `apps/api/src/death-claims/death-benefit-calculator.service.spec.ts` หรือ `death-claims-transactions.service.spec.ts`

**Interfaces:**
- Consumes: `benefitCalculator.calculate({ claimType, otherDeductions, excludeMemberId })` → `{ payingMemberCount, grossCollected, fundReserve, netToPay, welfareRate, isFixedAmount }`
- Produces: `recordPayment` — recompute แล้ว update `DeathClaim` snapshot (`activeMemberCount, totalContribution, associationSupport, netToPay, welfareRate`) **ก่อน** post ledger; ledger ใช้ค่าใหม่

- [ ] **Step 1: อ่าน `recordPayment` ปัจจุบัน** `death-claims.service.ts:543-620` — ยืนยันจุดอ่าน snapshot (`gross = Number(claim.totalContribution)` ฯลฯ) และจุด post ledger + balance check

- [ ] **Step 2: เขียน failing test** — ตรวจว่า recordPayment เรียก calculator ใหม่และ update snapshot ก่อน post ledger. เพิ่มใน `death-claims-transactions.service.spec.ts` (mock calculator คืนค่าใหม่ที่ต่างจาก snapshot เดิม, assert `deathClaim.update` ถูกเรียกด้วย activeMemberCount ใหม่ และ ledger รวม = gross ใหม่)

```ts
it('recomputes member count + snapshot at payment time (payDate), then posts ledger', async () => {
  // claim snapshot เดิม gross=50000 (500 คน) ; ณ payDate calculator คืน 480 คน gross=48000
  calculator.calculate.mockResolvedValue({
    payingMemberCount: 480, grossCollected: 48000, fundReserve: 4800,
    netToPay: 43200, welfareRate: 100, isFixedAmount: false,
  });
  await service.recordPayment(claimId, { amount: undefined, payDate: '2026-06-01', method: 'CASH' }, actor);
  // snapshot update ด้วยค่าใหม่
  expect(deathClaimUpdate).toHaveBeenCalledWith(expect.objectContaining({
    data: expect.objectContaining({ activeMemberCount: 480, totalContribution: 48000, associationSupport: 4800, netToPay: 43200 }),
  }));
  // ledger สมดุลด้วย gross ใหม่ 48000
  expect(ledgerBalanced(48000, 43200, 4800)).toBe(true);
});
```
> ปรับตาม mock harness ของ spec เดิม (transactions spec มี tx mock)

- [ ] **Step 3: รัน test ให้ fail** — `npx jest src/death-claims/death-claims-transactions.service.spec.ts -t "recomputes member count"` — Expected: FAIL

- [ ] **Step 4: แก้ `recordPayment`** — ก่อน block post ledger เพิ่ม recompute:

```ts
    // #7 art.16 — คำนวณจำนวนสมาชิกร่วมจ่าย + ยอดใหม่ ณ วันจ่ายจริง (payDate)
    const calc = await this.benefitCalculator.calculate({
      claimType: claim.claimType,
      otherDeductions: Number(claim.otherDeductions ?? 0),
      excludeMemberId: claim.claimType === DeathClaimType.MEMBER_DEATH ? claim.memberId : undefined,
    });
    const gross = calc.grossCollected;
    const fund = calc.fundReserve;
    const net = Number(dto.amount ?? calc.netToPay);
```
แทนบรรทัดที่อ่าน `gross/fund/net` จาก snapshot เดิม. แล้วใน `$transaction` เพิ่ม update snapshot ก่อน createMany ledger:

```ts
      await tx.deathClaim.update({
        where: { id },
        data: {
          activeMemberCount: calc.payingMemberCount,
          totalContribution: gross, associationSupport: fund,
          netToPay: calc.netToPay, welfareRate: calc.welfareRate,
        },
      });
```
> ค่าที่ post ledger (`gross/fund/net`) ต้องเป็นชุดเดียวกับที่ update snapshot — balance check เดิมยังทำงานกับค่าใหม่

- [ ] **Step 5: รัน test + build** — `npx jest src/death-claims && npx tsc --noEmit -p tsconfig.build.json` — Expected: PASS (เดิม + ใหม่) + exit 0

- [ ] **Step 6: Commit**

```bash
git add apps/api/src/death-claims/death-claims.service.ts apps/api/src/death-claims/death-claims-transactions.service.spec.ts
git commit -m "fix(death-claim): recompute member count + snapshot at payDate before ledger (art.16)"
```

---

## Task 4: #4 approve workflow เต็ม + web UI

> Task ใหญ่ — แบ่ง 4 ช่วง (schema → service → controller/e2e → web). commit ท้ายแต่ละช่วงได้

**Files:**
- Modify: `apps/api/prisma/schema.prisma` (model `Member`, `User`, enum `AuditAction`, enum ใหม่ `ApplicationStatus`)
- Modify: `apps/api/src/member-applications/member-applications.service.ts` (constructor + approve/reject + list/get scope)
- Modify: `apps/api/src/member-applications/member-applications.controller.ts`
- Test: `apps/api/src/member-applications/member-applications.service.spec.ts`, `member-applications.controller.spec.ts` (สร้าง)
- Web: หน้า admin รายการใบสมัคร + อนุมัติ/ปฏิเสธ + คำรับรอง

**Interfaces:**
- Produces: `approveApplication(id, actor, ip, cert?: { directorName?, committeeName? })`, `rejectApplication(id, actor, ip, reason)`; `Member` มี `applicationStatus, approvedById, approvedAt, approverName, directorCertifiedName/At, committeeCertifiedName/At, rejectedById, rejectedAt, rejectReason`

### ช่วง 4A: schema

- [ ] **Step 1: Backup DB** (เหมือน Task 2 Step 1)

- [ ] **Step 2: เพิ่ม enum + fields** — schema.prisma

```prisma
enum ApplicationStatus {
  PENDING
  APPROVED
  REJECTED
}
```
ใน `enum AuditAction` เพิ่ม `MEMBER_APPLICATION_APPROVE` และ `MEMBER_APPLICATION_REJECT`.
ใน `model Member` เพิ่ม:
```prisma
  applicationStatus      ApplicationStatus?
  approvedBy             User?     @relation("MemberApprover", fields: [approvedById], references: [id])
  approvedById           String?
  approvedAt             DateTime?
  approverName           String?
  directorCertifiedName  String?
  directorCertifiedAt    DateTime?
  committeeCertifiedName String?
  committeeCertifiedAt   DateTime?
  rejectedById           String?
  rejectedAt             DateTime?
  rejectReason           String?
```
ใน `model User` เพิ่ม back-relation: `approvedApplications Member[] @relation("MemberApprover")`

- [ ] **Step 3: db push** — `cd apps/api && npx prisma format && npx prisma db push` — Expected: in sync + client generated

- [ ] **Step 4: Commit schema** — `git add apps/api/prisma/schema.prisma && git commit -m "feat(schema): member application approve/reject/certify fields (art.15)"`

### ช่วง 4B: service

- [ ] **Step 5: failing tests** — `member-applications.service.spec.ts` เพิ่ม describe `approveApplication`/`rejectApplication`: (a) approve บันทึก approver + audit + applicationStatus=APPROVED + status=ACTIVE; (b) reject บันทึก reason + audit + applicationStatus=REJECTED คง SUSPENDED; (c) actor ต่าง school → throw (assertSchoolAccess). ต้องขยาย prisma mock ให้มี `member.update`, และ mock `schoolScope.assertSchoolAccess`, `auditLog.log`

```ts
it('approve records approver, cert, audit and activates', async () => {
  prisma.member.findUnique.mockResolvedValue({ id: 'm1', schoolId: 's1', applicationSubmittedAt: new Date() });
  await service.approveApplication('m1', actorAdmin, '127.0.0.1', { directorName: 'ผอ.ก', committeeName: 'กก.ข' });
  expect(prisma.member.update).toHaveBeenCalledWith(expect.objectContaining({
    data: expect.objectContaining({
      status: 'ACTIVE', applicationStatus: 'APPROVED',
      approvedById: actorAdmin.id, directorCertifiedName: 'ผอ.ก', committeeCertifiedName: 'กก.ข',
    }),
  }));
  expect(auditLog.log).toHaveBeenCalledWith(expect.objectContaining({ action: 'MEMBER_APPLICATION_APPROVE', entityId: 'm1' }));
});
it('reject records reason + audit, keeps SUSPENDED', async () => {
  prisma.member.findUnique.mockResolvedValue({ id: 'm1', schoolId: 's1', applicationSubmittedAt: new Date() });
  await service.rejectApplication('m1', actorAdmin, '127.0.0.1', 'เอกสารไม่ครบ');
  expect(prisma.member.update).toHaveBeenCalledWith(expect.objectContaining({
    data: expect.objectContaining({ applicationStatus: 'REJECTED', rejectReason: 'เอกสารไม่ครบ' }),
  }));
});
it('throws when actor school differs', async () => {
  prisma.member.findUnique.mockResolvedValue({ id: 'm1', schoolId: 's2', applicationSubmittedAt: new Date() });
  schoolScope.assertSchoolAccess.mockImplementation(() => { throw new ForbiddenException(); });
  await expect(service.approveApplication('m1', actorSchoolAdmin, '127.0.0.1')).rejects.toThrow();
});
```

- [ ] **Step 6: รัน fail** — `npx jest src/member-applications/member-applications.service.spec.ts -t "approve|reject|school"` — Expected: FAIL

- [ ] **Step 7: inject + implement** — constructor เพิ่ม `private readonly schoolScope: SchoolScopeService, private readonly auditLog: AuditLogService`; แทน `approveApplication` + เพิ่ม `rejectApplication`:

```ts
  async approveApplication(id: string, actor: ScopedUser, ipAddress?: string, cert?: { directorName?: string; committeeName?: string }) {
    const member = await this.prisma.member.findUnique({ where: { id } });
    if (!member || !member.applicationSubmittedAt) throw new BadRequestException('ไม่พบใบสมัคร');
    this.schoolScope.assertSchoolAccess(actor, member.schoolId);
    const updated = await this.prisma.member.update({
      where: { id },
      data: {
        status: MemberStatus.ACTIVE, applicationStatus: ApplicationStatus.APPROVED,
        approvedById: actor.id, approvedAt: new Date(), approverName: actor.name ?? undefined,
        directorCertifiedName: cert?.directorName, directorCertifiedAt: cert?.directorName ? new Date() : undefined,
        committeeCertifiedName: cert?.committeeName, committeeCertifiedAt: cert?.committeeName ? new Date() : undefined,
      },
    });
    await this.auditLog.log({ userId: actor.id, action: AuditAction.MEMBER_APPLICATION_APPROVE, entityType: 'Member', entityId: id, schoolId: member.schoolId, ipAddress });
    return { message: 'อนุมัติใบสมัครและเปิดใช้งานสมาชิกแล้ว', member: updated };
  }

  async rejectApplication(id: string, actor: ScopedUser, ipAddress?: string, reason?: string) {
    const member = await this.prisma.member.findUnique({ where: { id } });
    if (!member || !member.applicationSubmittedAt) throw new BadRequestException('ไม่พบใบสมัคร');
    this.schoolScope.assertSchoolAccess(actor, member.schoolId);
    const updated = await this.prisma.member.update({
      where: { id },
      data: { applicationStatus: ApplicationStatus.REJECTED, rejectedById: actor.id, rejectedAt: new Date(), rejectReason: reason },
    });
    await this.auditLog.log({ userId: actor.id, action: AuditAction.MEMBER_APPLICATION_REJECT, entityType: 'Member', entityId: id, schoolId: member.schoolId, ipAddress, metadata: { reason } });
    return { message: 'ปฏิเสธใบสมัครแล้ว', member: updated };
  }
```
และใน `listApplications`/`getApplication` เพิ่ม `const scoped = this.schoolScope.resolveSchoolId(actor, schoolId)` ใช้ scoped ใน where. (ตรวจ `ScopedUser` มี `name` — ถ้าไม่มี ใช้ field ที่มี เช่น `username`)

- [ ] **Step 8: รัน pass + build** — `npx jest src/member-applications && npx tsc --noEmit -p tsconfig.build.json` — Expected: PASS + exit 0

- [ ] **Step 9: Commit service** — `git commit -m "feat(member-applications): approve/reject with scope + audit + certification (art.15)"`

### ช่วง 4C: controller + e2e

- [ ] **Step 10: แก้ controller** — `member-applications.controller.ts`: approve/reject รับ `@Request() req`, ส่ง `req.user, req.ip`; เพิ่ม `@Post(':id/reject') @Roles(ADMIN, SCHOOL_ADMIN)`; approve รับ body `{ directorName?, committeeName? }`; reject รับ body `{ reason }`; list/getOne ส่ง `req.user`

```ts
  @Post(':id/approve')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN)
  approve(@Param('id') id: string, @Body() body: ApproveApplicationDto, @Request() req: { user: ScopedUser; ip: string }) {
    return this.service.approveApplication(id, req.user, req.ip, body);
  }

  @Post(':id/reject')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN)
  reject(@Param('id') id: string, @Body() body: RejectApplicationDto, @Request() req: { user: ScopedUser; ip: string }) {
    return this.service.rejectApplication(id, req.user, req.ip, body.reason);
  }
```
สร้าง DTO `dto/approve-application.dto.ts` (`directorName?`, `committeeName?` optional string) และ `dto/reject-application.dto.ts` (`reason` string `@IsNotEmpty`)

- [ ] **Step 11: e2e test** — `test/critical-flow.e2e-spec.ts` เพิ่ม: viewer/other-school approve → 403; admin approve → 200

- [ ] **Step 12: build + test** — `npx jest && npx tsc --noEmit -p tsconfig.build.json` — Expected: PASS + exit 0

- [ ] **Step 13: Commit** — `git commit -m "feat(member-applications): approve/reject endpoints with actor + reject DTO"`

### ช่วง 4D: web UI

- [ ] **Step 14: อ่าน pattern หน้า list เดิม** เช่น `apps/web/src/app/(dashboard)/members/page.tsx` (table + api call) และ `lib/api.ts` เพื่อทำหน้าใหม่ตาม pattern

- [ ] **Step 15: สร้างหน้า** `apps/web/src/app/(dashboard)/member-applications/page.tsx` — ตาราง Member ที่ `applicationStatus=PENDING`/`applicationSubmittedAt!=null`, ปุ่มอนุมัติ (modal กรอก directorName/committeeName) + ปฏิเสธ (modal กรอก reason); เรียก `POST /member-applications/:id/approve|reject`

- [ ] **Step 16: route-access** — `apps/web/src/lib/route-access.ts` เพิ่ม `/member-applications` ใน blocked prefixes ของ role ที่ไม่ใช่ ADMIN/SCHOOL_ADMIN (VIEWER, GROUP_LEADER, FINANCE, ACCOUNTING)

- [ ] **Step 17: web build** — `cd apps/web && npx tsc --noEmit` — Expected: exit 0. verify ใน browser preview ตาม verification workflow (login admin → เปิดหน้า → อนุมัติ 1 รายการ → เห็น audit)

- [ ] **Step 18: Commit web** — `git commit -m "feat(web): admin member-application approve/reject page with certification"`

---

## Task 5: #19 beneficiary priority (backfill → unique → validate) (TDD)

**Files:**
- Create: `apps/api/prisma/backfill/dedupe-beneficiary-priority.ts`
- Modify: `apps/api/prisma/schema.prisma` (model `Beneficiary` +`@@unique`)
- Modify: `apps/api/src/members/dto/beneficiary.dto.ts`, `dto/create-member.dto.ts`
- Modify: `apps/api/src/members/beneficiaries.service.ts`
- Test: `apps/api/src/members/beneficiaries.service.spec.ts` (สร้างถ้าไม่มี)

**Interfaces:**
- Produces: `Beneficiary` มี `@@unique([memberId, priority])`; DTO `priority` validate `@IsInt @Min(1) @Max(3)`; `beneficiaries.service.create` throw ถ้า priority ซ้ำใน member

- [ ] **Step 1: เขียน dedupe backfill** — `apps/api/prisma/backfill/dedupe-beneficiary-priority.ts` (renumber priority 1..n ตาม createdAt ต่อ member ที่มีซ้ำ; dry-run default)

```ts
import { PrismaClient } from '@prisma/client';
const APPLY = process.argv.includes('--apply');
(async () => {
  const prisma = new PrismaClient();
  try {
    const members = await prisma.beneficiary.groupBy({ by: ['memberId'], _count: { _all: true } });
    let fixed = 0;
    for (const m of members) {
      const rows = await prisma.beneficiary.findMany({ where: { memberId: m.memberId }, orderBy: { createdAt: 'asc' } });
      const prios = rows.map((r) => r.priority);
      if (new Set(prios).size === prios.length) continue; // ไม่ซ้ำ ข้าม
      console.log(`member ${m.memberId}: priorities [${prios}] -> [${rows.map((_, i) => i + 1)}]`);
      if (APPLY) {
        for (let i = 0; i < rows.length; i++) {
          await prisma.beneficiary.update({ where: { id: rows[i].id }, data: { priority: i + 1 } });
        }
      }
      fixed++;
    }
    console.log(`${fixed} members มี priority ซ้ำ` + (APPLY ? ' (แก้แล้ว)' : ' (DRY-RUN, ใส่ --apply เพื่อแก้)'));
  } finally { await prisma.$disconnect(); }
})();
```

- [ ] **Step 2: Backup + dry-run + apply backfill** — backup DB; `npx ts-node --project tsconfig.json prisma/backfill/dedupe-beneficiary-priority.ts` (ดูผล); ถ้ามีซ้ำ รัน `--apply` (จำเป็นก่อน unique migration) — Expected: ไม่มี priority ซ้ำเหลือ. ยืนยัน SQL:
```bash
"D:/laragon/bin/mysql/mysql-8.0.30-winx64/bin/mysql.exe" -uroot -h127.0.0.1 cremation_db --default-character-set=utf8mb4 -e "SELECT memberId, priority, COUNT(*) c FROM Beneficiary GROUP BY memberId, priority HAVING c>1;"
```
Expected: 0 แถว

- [ ] **Step 3: เพิ่ม `@@unique` + db push** — `model Beneficiary` เพิ่ม `@@unique([memberId, priority])`; `npx prisma format && npx prisma db push` — Expected: in sync (fail ถ้ายังมีซ้ำ → กลับ Step 2)

- [ ] **Step 4: เขียน failing test** — `beneficiaries.service.spec.ts`

```ts
it('rejects duplicate priority within a member', async () => {
  prisma.beneficiary.findFirst.mockResolvedValue({ id: 'b0', priority: 1 }); // มี priority 1 อยู่แล้ว
  await expect(service.create('m1', { fullName: 'ก', relationship: 'บุตร', priority: 1 }))
    .rejects.toThrow('ลำดับผู้รับเงินซ้ำ');
});
```

- [ ] **Step 5: รัน fail** — `npx jest src/members/beneficiaries.service.spec.ts` — Expected: FAIL

- [ ] **Step 6: DTO validation** — `beneficiary.dto.ts:16-18` + `create-member.dto.ts` (`BeneficiaryInput`) เปลี่ยน priority เป็น

```ts
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(3)
  priority?: number;
```
(import `IsInt, Min, Max` จาก class-validator)

- [ ] **Step 7: guard ใน service** — `beneficiaries.service.ts` create (ก่อนบันทึก):

```ts
    if (dto.priority) {
      const dup = await this.prisma.beneficiary.findFirst({ where: { memberId, priority: dto.priority } });
      if (dup) throw new BadRequestException('ลำดับผู้รับเงินซ้ำในสมาชิกรายนี้');
    }
```
(update method ก็เพิ่ม guard เทียบ id != current)

- [ ] **Step 8: รัน pass + build** — `npx jest src/members && npx tsc --noEmit -p tsconfig.build.json` — Expected: PASS + exit 0

- [ ] **Step 9: Commit**

```bash
git add apps/api/prisma/schema.prisma apps/api/prisma/backfill/dedupe-beneficiary-priority.ts apps/api/src/members/dto/beneficiary.dto.ts apps/api/src/members/dto/create-member.dto.ts apps/api/src/members/beneficiaries.service.ts apps/api/src/members/beneficiaries.service.spec.ts
git commit -m "feat(beneficiary): unique + validated priority 1-3 (art.19) + dedupe backfill"
```

---

## Task 6: #11 retention soft-delete (TDD)

**Files:**
- Modify: `apps/api/prisma/schema.prisma` (`CashBook`, `BankTransaction` +`deletedAt`)
- Modify: `apps/api/src/cash-book/cash-book.service.ts`
- Modify: `apps/api/src/bank-accounts/bank-accounts.service.ts`
- Test: `apps/api/src/cash-book/cash-book.service.spec.ts` (สร้าง)

**Interfaces:**
- Produces: `CashBook`/`BankTransaction` มี `deletedAt DateTime?`; `remove` → soft-delete; query อ่านทั้งหมด filter `deletedAt: null`; `createFromReceipt/Payment` reactivate แถว soft-deleted แทนสร้างซ้ำ

- [ ] **Step 1: Backup + schema** — backup DB; `CashBook` (schema:603-617) + `BankTransaction` (schema:487-500) เพิ่ม `deletedAt DateTime?`; `npx prisma format && npx prisma db push`

- [ ] **Step 2: failing test** — `cash-book.service.spec.ts`

```ts
it('soft-deletes instead of hard delete', async () => {
  prisma.cashBook.findFirst.mockResolvedValue({ id: 'c1', schoolId: 's1' });
  await service.remove('c1', actor);
  expect(prisma.cashBook.update).toHaveBeenCalledWith({ where: { id: 'c1' }, data: { deletedAt: expect.any(Date) } });
  expect(prisma.cashBook.delete).not.toHaveBeenCalled();
});
it('excludes soft-deleted rows from list', async () => {
  await service.findAll('s1', actor);
  expect(prisma.cashBook.findMany).toHaveBeenCalledWith(expect.objectContaining({ where: expect.objectContaining({ deletedAt: null }) }));
});
```

- [ ] **Step 3: รัน fail** — `npx jest src/cash-book/cash-book.service.spec.ts` — Expected: FAIL

- [ ] **Step 4: แก้ cash-book.service** — `remove` (:75-78) → `return this.prisma.cashBook.update({ where: { id }, data: { deletedAt: new Date() } })`; ทุก findMany/findFirst/aggregate (`:33-58` และอื่น) เพิ่ม `deletedAt: null` ใน where; `createFromReceipt`/`createFromPayment` (:81-109) — เช็คแถว soft-deleted ที่ผูก `receiptId`/`paymentId` เดิม แล้ว `update({ deletedAt: null, ... })` แทน create (กัน unique ชน)

- [ ] **Step 5: แก้ bank-accounts.service** — `removeManualTransaction` (:313-320) → soft-delete; query list/statement/reconcile ที่อ่าน BankTransaction เพิ่ม `deletedAt: null`

- [ ] **Step 6: audit log** — เพิ่ม `auditLog.log` ใน remove ทั้งสอง (inject ถ้ายังไม่มี — CommonModule global) ด้วย action ที่เหมาะสม (เช่น `CASH_BOOK_DELETE`/มีอยู่แล้วหรือใช้ generic) — ตรวจ enum `AuditAction` ก่อน; ถ้าไม่มีให้เพิ่ม

- [ ] **Step 7: รัน pass + build** — `npx jest src/cash-book src/bank-accounts && npx tsc --noEmit -p tsconfig.build.json` — Expected: PASS + exit 0

- [ ] **Step 8: Commit**

```bash
git add apps/api/prisma/schema.prisma apps/api/src/cash-book apps/api/src/bank-accounts
git commit -m "feat(retention): soft-delete CashBook + BankTransaction with reactivate (ref2 art.30)"
```

---

## Self-Review Notes (ตรวจแล้ว)

- **Spec coverage:** #6 (Task1) · #5 (Task2) · #7 (Task3) · #4 (Task4 A-D) · #19 (Task5) · #11 (Task6). Backfill: retired-reason (Task1), dedupe-priority (Task5). ครบตาม design §5
- **Placeholder scan:** code จริงทุก step; จุดที่ต้องปรับตาม mock harness เดิม (Task2 Step4, Task3 Step2, Task4 Step5) ระบุชัดว่าให้ยึด pattern spec เดิม
- **Type consistency:** `getStatusChangeExtras` (Task1) ↔ `MembershipEndReason.RETIRED`; calculator return shape (Task3) ↔ `payingMemberCount/grossCollected/fundReserve/netToPay/welfareRate`; approve signature (Task4) ↔ controller call; `deletedAt` (Task6) ↔ query filter
- **Dependency order:** Task5 dedupe backfill (Step2) ต้องก่อน `@@unique` (Step3); Task4 schema (4A) ก่อน service (4B); Task3 ต่อยอด death-fund-ledger เฟส 0
- **จุดเสี่ยงที่ต้องยืนยันตอน implement:** `ScopedUser` มี field `name`/`id` (Task4 — ตรวจ type จริง); calculator ต้อง inject ใน death-claims.service อยู่แล้ว (Task3); `AuditAction` มีค่าที่ต้องใช้หรือต้องเพิ่ม (Task4 Step2, Task6 Step6)

## นอกขอบเขต (YAGNI)
#8 ระบบอัตรา, #10 ข้อบังคับสมาคม ref2, member status history table — ไม่ทำรอบนี้
