/**
 * สร้างข้อมูลตัวอย่าง: การชำระเงินรายเดือนย้อนหลัง + เคสเสียชีวิตของสมาชิกสมมติ
 *
 *   node tools/seed-example-transactions.js            # dry run — รายงานอย่างเดียว ไม่เขียน
 *   node tools/seed-example-transactions.js --apply    # เขียนจริง
 *   node tools/seed-example-transactions.js --cleanup  # ลบเฉพาะข้อมูลที่สคริปต์นี้สร้าง
 *
 * ทุกอย่างที่สคริปต์สร้างติดธง TEST ไว้เสมอ จึงลบทิ้งได้โดยไม่แตะข้อมูลจริง:
 *   Member.memberNo        ขึ้นต้น TEST-
 *   AssociationMember      ชื่อขึ้นต้น [ทดสอบ]
 *   Receipt.receiptNo      รูปแบบ R<YYYYMM>-S#### (ของจริงใช้ -M####)
 *   DeathClaim.claimNo     ขึ้นต้น DC-TEST-
 */
const { PrismaClient } = require('@prisma/client');

const APPLY = process.argv.includes('--apply');
const CLEANUP = process.argv.includes('--cleanup');

const TEST_NAME_PREFIX = '[ทดสอบ]';
const TEST_MEMBER_PREFIX = 'TEST-';
const TEST_CLAIM_PREFIX = 'DC-TEST-';
const SEED_RECEIPT_MARK = '-S';

/** งวดที่ต้องมี: ม.ค.–ส.ค. 2026 (พ.ศ. 2569) อัตราอิงจาก 2 งวดจริงที่มีอยู่แล้ว */
const MONTHS = [1, 2, 3, 4, 5, 6, 7, 8];
const rateFor = (month) => (month <= 5 ? { welfareRate: 100, serviceFee: 5 } : { welfareRate: 200, serviceFee: 0 });

/** ข้อ 13.1 / 13.2 — สมาชิกตาย 100/คน, ญาติสายตรง 50/คน; ข้อ 16 — จ่าย 90% เข้ากองทุน 10% */
const RATE_MEMBER_DEATH = 100;
const RATE_PROTECTED_DEATH = 50;
const PAYOUT_RATIO = 0.9;
const FUND_RATIO = 0.1;

const ARREARS_RATE = 0.04; // ~4% ค้างชำระต่อวด

const FIRST = ['สมชาย', 'สมหญิง', 'ประเสริฐ', 'บุญมี', 'วิไล', 'อนงค์', 'ถาวร', 'จันทร์เพ็ญ', 'ประยูร', 'สุนีย์',
  'ไพโรจน์', 'มาลี', 'สุชาติ', 'อารีย์', 'วิชัย', 'ลำดวน', 'ธงชัย', 'พเยาว์', 'สมบูรณ์', 'ระเบียบ'];
const LAST = ['ใจดี', 'ศรีทอง', 'แก้วมณี', 'บุญเรือง', 'ทองสุข', 'พงษ์ไพร', 'คำแสน', 'วงศ์คำ', 'สอนดี', 'มั่นคง'];

/** สุ่มแบบกำหนดผลได้ (deterministic) เพื่อให้รันซ้ำได้ผลเดิม */
function seededInt(str, mod) {
  let h = 2166136261;
  for (let i = 0; i < str.length; i++) {
    h ^= str.charCodeAt(i);
    h = Math.imul(h, 16777619);
  }
  return Math.abs(h) % mod;
}

async function cleanup(prisma) {
  const members = await prisma.member.findMany({
    where: { memberNo: { startsWith: TEST_MEMBER_PREFIX } },
    select: { id: true, associationMemberId: true },
  });
  const memberIds = members.map((m) => m.id);
  const assocIds = members.map((m) => m.associationMemberId);

  const claims = await prisma.deathClaim.deleteMany({ where: { claimNo: { startsWith: TEST_CLAIM_PREFIX } } });
  const seedReceipts = await prisma.receipt.findMany({
    where: { receiptNo: { contains: SEED_RECEIPT_MARK } },
    select: { id: true },
  });
  const seedReceiptIds = seedReceipts.map((r) => r.id);

  // เก็บ id ของ contribution ที่ผูกกับใบเสร็จของสคริปต์ไว้ก่อน แล้วค่อยตัดความสัมพันธ์
  const paidBySeed = await prisma.memberContribution.findMany({
    where: { receiptId: { in: seedReceiptIds } },
    select: { id: true },
  });
  const ledger = await prisma.ledgerEntry.deleteMany({ where: { receiptId: { in: seedReceiptIds } } });
  await prisma.memberContribution.updateMany({
    where: { receiptId: { in: seedReceiptIds } },
    data: { receiptId: null },
  });

  // รายการค้างชำระที่สคริปต์สร้าง ไม่มีใบเสร็จให้ยึด จึงจำกัดขอบเขตด้วยงวดที่สคริปต์แตะเท่านั้น
  // (ปลอดภัยตราบใดที่ยังไม่มีการบันทึกค้างชำระของจริงในงวด ม.ค.–ส.ค. 2026)
  const seededPeriods = await prisma.contributionPeriod.findMany({
    where: { year: 2026, month: { in: MONTHS } },
    select: { id: true },
  });
  const contributions = await prisma.memberContribution.deleteMany({
    where: {
      OR: [
        { id: { in: paidBySeed.map((c) => c.id) } },
        { memberId: { in: memberIds } },
        {
          periodId: { in: seededPeriods.map((p) => p.id) },
          receiptId: null,
          paidAmount: 0,
          isArrears: true,
        },
      ],
    },
  });
  const receipts = await prisma.receipt.deleteMany({ where: { id: { in: seedReceiptIds } } });
  await prisma.protectedPerson.deleteMany({ where: { memberId: { in: memberIds } } });
  await prisma.member.deleteMany({ where: { id: { in: memberIds } } });
  const assoc = await prisma.associationMember.deleteMany({ where: { id: { in: assocIds } } });

  console.log(JSON.stringify({
    mode: 'cleanup',
    deathClaims: claims.count,
    ledgerEntries: ledger.count,
    contributions: contributions.count,
    receipts: receipts.count,
    testMembers: assoc.count,
  }, null, 2));
}

async function main() {
  const prisma = new PrismaClient();
  if (CLEANUP) {
    await cleanup(prisma);
    await prisma.$disconnect();
    return;
  }

  const report = { mode: APPLY ? 'apply' : 'dry-run', periodsCreated: [], testMembersCreated: 0,
    contributions: 0, paid: 0, arrears: 0, receipts: 0, ledgerEntries: 0, deathClaims: [] };

  // ---- 1. งวด ----
  const periods = {};
  for (const month of MONTHS) {
    const existing = await prisma.contributionPeriod.findUnique({ where: { year_month: { year: 2026, month } } });
    if (existing) {
      periods[month] = existing;
      continue;
    }
    const { welfareRate, serviceFee } = rateFor(month);
    report.periodsCreated.push(`2026-${month} (${welfareRate}/${serviceFee})`);
    periods[month] = APPLY
      ? await prisma.contributionPeriod.create({ data: { year: 2026, month, welfareRate, serviceFee } })
      : { id: `dry-${month}`, year: 2026, month, welfareRate, serviceFee };
  }

  // ---- 2. สมาชิกสมมติ ----
  const schools = await prisma.school.findMany({ select: { id: true, name: true }, take: 6, orderBy: { name: 'asc' } });
  const memberType = await prisma.memberType.findFirst();
  const existingTest = await prisma.member.count({ where: { memberNo: { startsWith: TEST_MEMBER_PREFIX } } });

  const testMembers = [];
  const TEST_COUNT = 20;

  // รันซ้ำหลังล้มกลางทาง: หยิบสมาชิกสมมติที่สร้างไว้แล้วมาใช้ต่อ ไม่ใช่ข้ามไปเฉย ๆ
  // (ถ้าปล่อยว่าง ขั้นตอนเคสเสียชีวิตจะไม่ทำงานเลยโดยไม่มีใครรู้)
  if (existingTest > 0) {
    const already = await prisma.member.findMany({
      where: { memberNo: { startsWith: TEST_MEMBER_PREFIX } },
      select: {
        id: true, memberNo: true, schoolId: true,
        associationMember: { select: { firstName: true, lastName: true } },
        protectedPersons: { select: { id: true }, take: 1 },
      },
      orderBy: { memberNo: 'asc' },
    });
    for (const m of already) {
      testMembers.push({
        id: m.id, memberNo: m.memberNo, schoolId: m.schoolId,
        firstName: m.associationMember?.firstName ?? '', lastName: m.associationMember?.lastName ?? '',
        protectedId: m.protectedPersons[0]?.id ?? null,
      });
    }
    report.testMembersReused = testMembers.length;
  }

  for (let i = 0; i < TEST_COUNT; i++) {
    const memberNo = `${TEST_MEMBER_PREFIX}${String(i + 1).padStart(4, '0')}`;
    const firstName = `${TEST_NAME_PREFIX}${FIRST[i % FIRST.length]}`;
    const lastName = LAST[seededInt(memberNo, LAST.length)];
    const school = schools[i % schools.length];
    if (existingTest > 0) break;
    if (!APPLY) {
      testMembers.push({ id: `dry-m-${i}`, memberNo, schoolId: school.id, firstName, lastName, protectedId: `dry-p-${i}` });
      continue;
    }
    const assoc = await prisma.associationMember.create({
      data: { schoolId: school.id, memberTypeId: memberType.id, firstName, lastName,
        position: 'ข้อมูลทดสอบ', associationJoinDate: new Date('2025-12-01') },
    });
    const member = await prisma.member.create({
      data: { associationMemberId: assoc.id, memberNo, schoolId: school.id,
        joinDate: new Date('2025-12-01'), status: 'ACTIVE', salaryDeduction: true },
    });
    const protectedPerson = await prisma.protectedPerson.create({
      data: { memberId: member.id, fullName: `${TEST_NAME_PREFIX}${FIRST[(i + 5) % FIRST.length]} ${lastName}`,
        relationship: i % 2 === 0 ? 'SPOUSE' : 'PARENT' },
    });
    testMembers.push({ id: member.id, memberNo, schoolId: school.id, firstName, lastName, protectedId: protectedPerson.id });
  }
  report.testMembersCreated = testMembers.length;

  // ---- 3. เคสเสียชีวิต: เดือนละ 2-3 ราย สลับ สมาชิกตาย / ญาติตาย ----
  const deathPlan = [];
  let cursor = 0;
  for (const month of MONTHS) {
    const perMonth = 2 + (month % 2); // 2 หรือ 3 ราย
    for (let k = 0; k < perMonth; k++) {
      const subject = testMembers[cursor % Math.max(testMembers.length, 1)];
      if (!subject) continue;
      const isMemberDeath = (cursor % 3 === 0);
      deathPlan.push({ month, subject, isMemberDeath, day: 5 + k * 7 });
      cursor++;
    }
  }
  const deceasedByMonth = new Map();
  for (const d of deathPlan) if (d.isMemberDeath) deceasedByMonth.set(d.subject.memberNo, d.month);

  // ---- 4. เงินสมทบรายเดือน ----
  const realMembers = await prisma.member.findMany({
    where: { status: { in: ['ACTIVE', 'ARREARS'] }, memberNo: { not: { startsWith: TEST_MEMBER_PREFIX } } },
    select: { id: true, memberNo: true, schoolId: true },
  });
  const accounts = await prisma.account.findMany({ where: { code: { in: ['101', '401', '402'] } }, select: { id: true, code: true } });
  const acc = Object.fromEntries(accounts.map((a) => [a.code, a.id]));
  const canLedger = Boolean(acc['101'] && acc['401'] && acc['402']);

  for (const month of MONTHS) {
    const period = periods[month];
    const welfareRate = Number(period.welfareRate);
    const serviceFee = Number(period.serviceFee);
    const total = welfareRate + serviceFee;

    const payers = [
      ...realMembers,
      ...testMembers.filter((t) => !deceasedByMonth.has(t.memberNo) || deceasedByMonth.get(t.memberNo) >= month),
    ];

    let seq = 0;
    for (const m of payers) {
      const unpaid = seededInt(`${m.memberNo}|${month}`, 100) < ARREARS_RATE * 100;
      report.contributions++;
      if (unpaid) report.arrears++; else report.paid++;
      if (!unpaid) {
        report.receipts++;
        if (canLedger) report.ledgerEntries += serviceFee > 0 ? 3 : 2;
      }
      if (!APPLY) continue;

      const existing = await prisma.memberContribution.findUnique({
        where: { memberId_periodId: { memberId: m.id, periodId: period.id } },
      });
      if (existing) continue;

      if (unpaid) {
        await prisma.memberContribution.create({
          data: { memberId: m.id, periodId: period.id, schoolId: m.schoolId,
            welfareAmount: welfareRate, serviceAmount: serviceFee, totalAmount: total,
            paidAmount: 0, isArrears: true },
        });
        continue;
      }

      seq++;
      const paidDate = new Date(Date.UTC(2026, month - 1, 10 + (seq % 15)));
      const receipt = await prisma.receipt.create({
        data: {
          receiptNo: `R2026${String(month).padStart(2, '0')}${SEED_RECEIPT_MARK}${String(seq).padStart(4, '0')}`,
          schoolId: m.schoolId, date: paidDate, type: 'MEMBER_CONTRIBUTION',
          description: `ชำระเงินสงเคราะห์ประจำเดือน ${month}/2026 (${m.memberNo})`, amount: total,
        },
      });
      await prisma.memberContribution.create({
        data: { memberId: m.id, periodId: period.id, schoolId: m.schoolId,
          welfareAmount: welfareRate, serviceAmount: serviceFee, totalAmount: total,
          paidAmount: total, paidDate, receiptId: receipt.id, isArrears: false },
      });
      if (canLedger) {
        await prisma.ledgerEntry.createMany({
          data: [
            { accountId: acc['101'], date: paidDate, description: `รับเงินสงเคราะห์ ${m.memberNo}`, debit: total, credit: 0, receiptId: receipt.id },
            { accountId: acc['401'], date: paidDate, description: `รายได้เงินสงเคราะห์ ${m.memberNo}`, debit: 0, credit: welfareRate, receiptId: receipt.id },
            ...(serviceFee > 0 ? [{ accountId: acc['402'], date: paidDate, description: `รายได้ค่าบำรุง ${m.memberNo}`, debit: 0, credit: serviceFee, receiptId: receipt.id }] : []),
          ],
        });
      }
    }
  }

  // ---- 5. บันทึกเคสเสียชีวิต ----
  let claimSeq = 0;
  for (const d of deathPlan) {
    claimSeq++;
    const deathDate = new Date(Date.UTC(2026, d.month - 1, d.day));
    const rate = d.isMemberDeath ? RATE_MEMBER_DEATH : RATE_PROTECTED_DEATH;
    const payingCount = realMembers.length + testMembers.length - deathPlan.filter(
      (x) => x.isMemberDeath && (x.month < d.month || (x.month === d.month && x.day < d.day)),
    ).length;
    const gross = payingCount * rate;
    const fund = Math.round(gross * FUND_RATIO * 100) / 100;
    const net = Math.round(gross * PAYOUT_RATIO * 100) / 100;
    const claimNo = `${TEST_CLAIM_PREFIX}2026-${String(claimSeq).padStart(4, '0')}`;

    report.deathClaims.push({
      claimNo, month: d.month, type: d.isMemberDeath ? 'MEMBER_DEATH' : 'PROTECTED_DEATH',
      subject: d.subject.memberNo, payingCount, gross, fund, net,
    });
    if (!APPLY) continue;

    // การอัปเดตสถานะสมาชิกทำก่อนเสมอ และเป็น idempotent — ห้ามผูกไว้กับการสร้างเคส
    // ไม่งั้นการรันซ้ำจะทิ้งสมาชิกที่มีเคสเสียชีวิตไว้ในสถานะ ACTIVE
    if (d.isMemberDeath) {
      await prisma.member.update({
        where: { id: d.subject.id },
        data: { status: 'DECEASED', deathDate, membershipEndReason: 'DECEASED' },
      });
    }

    // รันซ้ำได้: ข้ามเคสที่บันทึกไปแล้ว แทนที่จะชนกับ unique ของ claimNo
    const already = await prisma.deathClaim.findUnique({ where: { claimNo } });
    if (already) continue;

    await prisma.deathClaim.create({
      data: {
        memberId: d.subject.id, schoolId: d.subject.schoolId, claimNo,
        claimType: d.isMemberDeath ? 'MEMBER_DEATH' : 'PROTECTED_DEATH',
        deceasedType: d.isMemberDeath ? 'MEMBER' : (claimSeq % 2 === 0 ? 'SPOUSE' : 'PARENT'),
        deceasedName: d.isMemberDeath ? `${d.subject.firstName} ${d.subject.lastName}` : `${TEST_NAME_PREFIX}ญาติของ ${d.subject.memberNo}`,
        protectedPersonId: d.isMemberDeath ? null : d.subject.protectedId,
        relationshipNote: d.isMemberDeath ? null : 'ญาติสายตรงตามข้อ 13.2',
        reportedDate: deathDate, deathDate, causeOfDeath: 'ข้อมูลทดสอบ',
        mainBeneficiary: `${TEST_NAME_PREFIX}ทายาทของ ${d.subject.memberNo}`,
        activeMemberCount: payingCount, welfareRate: rate, totalContribution: gross,
        associationSupport: fund, payoutRatio: PAYOUT_RATIO, otherDeductions: 0, netToPay: net,
        status: 'PAID', collectionChannel: 'SALARY_DEDUCTION',
        collectionDeadline: new Date(Date.UTC(2026, d.month, 5)),
        documentDeadline: new Date(Date.UTC(2026, d.month, 15)),
        paymentDeadline: new Date(Date.UTC(2026, d.month, 30)),
        collectedAmount: gross, collectionCompletedAt: new Date(Date.UTC(2026, d.month, 1)),
        documentsComplete: true, documentChecklist: { deathCertificate: true, idCard: true, bankBook: true },
        workflowNotes: 'สร้างโดยสคริปต์ข้อมูลตัวอย่าง',
      },
    });

    if (d.isMemberDeath) {
      await prisma.member.update({
        where: { id: d.subject.id },
        data: { status: 'DECEASED', deathDate, membershipEndReason: 'DECEASED' },
      });
    }
  }

  console.log(JSON.stringify(report, null, 2));
  await prisma.$disconnect();
}

main().catch((e) => {
  console.error('ERR', e.message);
  process.exit(1);
});
