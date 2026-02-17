// prisma/seed.ts
import { PrismaClient, Role, MemberStatus, ReceiptType, PaymentType, AccountType } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  // 1) Base schools
  const schoolA = await prisma.school.create({
    data: {
      code: 'SCH001',
      name: 'โรงเรียนบ้านพญาไพร',
      district: 'แม่ฟ้าหลวง',
      province: 'เชียงราย',
    },
  });

  const schoolB = await prisma.school.create({
    data: {
      code: 'SCH002',
      name: 'โรงเรียนบ้านตัวอย่าง',
      district: 'เมือง',
      province: 'เชียงราย',
    },
  });

  // 2) Member types
  const regularTeacher = await prisma.memberType.create({
    data: { code: 'REG', name: 'ครูประจำการ' },
  });

  const retiredTeacher = await prisma.memberType.create({
    data: { code: 'RET', name: 'ครูเกษียณ' },
  });

  const staff = await prisma.memberType.create({
    data: { code: 'STF', name: 'บุคลากรสนับสนุน' },
  });

  // 3) Groups
  const groupA1 = await prisma.group.create({
    data: {
      schoolId: schoolA.id,
      code: 'G01',
      name: 'กลุ่มบ้านพญาไพร 1',
    },
  });

  const groupB1 = await prisma.group.create({
    data: {
      schoolId: schoolB.id,
      code: 'G02',
      name: 'กลุ่มโรงเรียนบ้านตัวอย่าง 1',
    },
  });

  // 4) Admin user
  const admin = await prisma.user.create({
    data: {
      username: 'admin',
      // TODO: replace with hashed password by auth module, for now simple placeholder.
      passwordHash: '$2b$10$abcdefghijklmnopqrstuv', // fake hash – should be updated
      fullName: 'System Admin',
      role: Role.ADMIN,
    },
  });

  console.log('Created admin user:', admin.username);

  // 5) Chart of accounts (minimal)
  const cash = await prisma.account.create({
    data: { code: '101', name: 'เงินสด', type: AccountType.ASSET },
  });
  const bank = await prisma.account.create({
    data: { code: '102', name: 'เงินฝากธนาคาร', type: AccountType.ASSET },
  });
  const welfareRevenue = await prisma.account.create({
    data: { code: '401', name: 'รายได้เงินสงเคราะห์', type: AccountType.INCOME },
  });
  const serviceRevenue = await prisma.account.create({
    data: { code: '402', name: 'รายได้ค่าบริการ', type: AccountType.INCOME },
  });
  const deathBenefitExpense = await prisma.account.create({
    data: { code: '501', name: 'ค่าใช้จ่ายเงินสงเคราะห์ศพ', type: AccountType.EXPENSE },
  });

  // 6) Bank account (single fund - use schoolA as default)
  const mainBankA = await prisma.bankAccount.create({
    data: {
      schoolId: schoolA.id,
      bankName: 'ธนาคารกรุงไทย',
      accountNo: '123-4-56789-0',
      accountName: 'กองทุนฌาปณกิจครู',
      isDefault: true,
      description: 'บัญชีหลักกองทุนฌาปณกิจ',
    },
  });

  // 7) Members
  const member1 = await prisma.member.create({
    data: {
      memberNo: 'M0001',
      schoolId: schoolA.id,
      memberTypeId: regularTeacher.id,
      groupId: groupA1.id,
      firstName: 'สมชาย',
      lastName: 'ใจดี',
      joinDate: new Date('2018-05-01'),
      status: MemberStatus.ACTIVE,
      phone: '0812345678',
      beneficiaries: {
        create: [
          {
            fullName: 'นางสมศรี ใจดี',
            relationship: 'คู่สมรส',
            phone: '0899998888',
            priority: 1,
          },
        ],
      },
    },
  });

  const member2 = await prisma.member.create({
    data: {
      memberNo: 'M0002',
      schoolId: schoolA.id,
      memberTypeId: staff.id,
      groupId: groupA1.id,
      firstName: 'วิไล',
      lastName: 'สุขสันต์',
      joinDate: new Date('2019-03-10'),
      status: MemberStatus.ACTIVE,
    },
  });

  const member3 = await prisma.member.create({
    data: {
      memberNo: 'M0003',
      schoolId: schoolB.id,
      memberTypeId: retiredTeacher.id,
      groupId: groupB1.id,
      firstName: 'เกษียณ',
      lastName: 'มีสุข',
      joinDate: new Date('2010-01-01'),
      status: MemberStatus.ACTIVE,
    },
  });

  // 8) Contribution period (Dec 2024)
  const periodDec = await prisma.contributionPeriod.create({
    data: {
      year: 2024,
      month: 12,
      welfareRate: 100.0,
      serviceFee: 10.0,
    },
  });

  // Helper to create contribution
  async function createContribution(memberId: string, schoolId: string) {
    const welfareAmount = 100.0;
    const serviceAmount = 10.0;
    const totalAmount = welfareAmount + serviceAmount;

    const receipt = await prisma.receipt.create({
      data: {
        receiptNo: `R${Date.now()}${Math.floor(Math.random() * 1000)}`,
        schoolId,
        date: new Date('2024-12-05'),
        type: ReceiptType.MEMBER_CONTRIBUTION,
        amount: totalAmount,
        description: 'ชำระเงินสงเคราะห์ประจำเดือน 12/2567',
        bankAccountId: mainBankA.id,
      },
    });

    await prisma.memberContribution.create({
      data: {
        memberId,
        periodId: periodDec.id,
        schoolId,
        welfareAmount,
        serviceAmount,
        totalAmount,
        paidAmount: totalAmount,
        paidDate: new Date('2024-12-05'),
        receiptId: receipt.id,
      },
    });

    // Simple ledger: debit bank, credit revenue (welfare+service)
    await prisma.ledgerEntry.createMany({
      data: [
        {
          accountId: bank.id,
          date: new Date('2024-12-05'),
          description: 'รับเงินสงเคราะห์ประจำเดือน',
          debit: totalAmount,
          credit: 0,
          receiptId: receipt.id,
        },
        {
          accountId: welfareRevenue.id,
          date: new Date('2024-12-05'),
          description: 'รายได้เงินสงเคราะห์',
          debit: 0,
          credit: welfareAmount,
          receiptId: receipt.id,
        },
        {
          accountId: serviceRevenue.id,
          date: new Date('2024-12-05'),
          description: 'รายได้ค่าบริการ',
          debit: 0,
          credit: serviceAmount,
          receiptId: receipt.id,
        },
      ],
    });
  }

  await createContribution(member1.id, schoolA.id);
  await createContribution(member2.id, schoolA.id);
  await createContribution(member3.id, schoolB.id);

  // 9) Example death claim for member1
  const claim = await prisma.deathClaim.create({
    data: {
      memberId: member1.id,
      schoolId: schoolA.id,
      claimNo: 'DC-0001',
      reportedDate: new Date('2024-12-10'),
      deathDate: new Date('2024-12-08'),
      causeOfDeath: 'อุบัติเหตุ',
      mainBeneficiary: 'นางสมศรี ใจดี',
      beneficiaryPhone: '0899998888',
      activeMemberCount: 3,
      welfareRate: 100.0,
      totalContribution: 300.0,
      associationSupport: 20000.0,
      otherDeductions: 500.0,
      netToPay: 20000.0 + 300.0 - 500.0,
    },
  });

  const payment = await prisma.paymentVoucher.create({
    data: {
      voucherNo: 'PV-0001',
      schoolId: schoolA.id,
      date: new Date('2024-12-15'),
      type: PaymentType.DEATH_BENEFIT,
      description: 'จ่ายเงินสงเคราะห์ศพ ครูสมชาย ใจดี',
      amount: claim.netToPay,
      bankAccountId: mainBankA.id,
    },
  });

  // Link death benefit payment
  const benefitPayment = await prisma.deathBenefitPayment.create({
    data: {
      deathClaimId: claim.id,
      payDate: new Date('2024-12-15'),
      method: 'BANK_TRANSFER',
      bankAccountId: mainBankA.id,
      amount: claim.netToPay,
      voucherId: payment.id,
    },
  });

  // Ledger for payment: credit bank, debit death benefit expense
  await prisma.ledgerEntry.createMany({
    data: [
      {
        accountId: deathBenefitExpense.id,
        date: new Date('2024-12-15'),
        description: 'จ่ายเงินสงเคราะห์ศพ',
        debit: claim.netToPay,
        credit: 0,
        paymentId: payment.id,
      },
      {
        accountId: bank.id,
        date: new Date('2024-12-15'),
        description: 'จ่ายเงินสงเคราะห์ศพ',
        debit: 0,
        credit: claim.netToPay,
        paymentId: payment.id,
      },
    ],
  });

  console.log('Seed completed with sample data.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
