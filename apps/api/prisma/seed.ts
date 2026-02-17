// prisma/seed.ts
import { PrismaClient, Role, MemberStatus, ReceiptType, PaymentType, AccountType } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting seed...');
  
  // ตรวจสอบ database connection
  try {
    await prisma.$connect();
    console.log('✅ Database connected successfully');
  } catch (error) {
    console.error('❌ Database connection failed:', error);
    throw error;
  }
  
  // ตรวจสอบว่า database มีอยู่จริง
  try {
    await prisma.$queryRaw`SELECT 1`;
    console.log('✅ Database is accessible');
  } catch (error) {
    console.error('❌ Database access failed. Please check:');
    console.error('   1. Database name in DATABASE_URL is lowercase (cremation_db)');
    console.error('   2. Database exists: CREATE DATABASE cremation_db;');
    console.error('   3. MySQL service is running: sudo systemctl status mysql');
    throw error;
  }

  // 1) Base schools (upsert = สร้างหรือใช้ของเดิม ถ้ามีอยู่แล้ว)
  const schoolA = await prisma.school.upsert({
    where: { code: 'SCH001' },
    create: { code: 'SCH001', name: 'โรงเรียนบ้านพญาไพร', district: 'แม่ฟ้าหลวง', province: 'เชียงราย' },
    update: {},
  });

  const schoolB = await prisma.school.upsert({
    where: { code: 'SCH002' },
    create: { code: 'SCH002', name: 'โรงเรียนบ้านตัวอย่าง', district: 'เมือง', province: 'เชียงราย' },
    update: {},
  });

  const schoolC = await prisma.school.upsert({
    where: { code: 'SCH003' },
    create: { code: 'SCH003', name: 'โรงเรียนวัดป่างาม', district: 'แม่สาย', province: 'เชียงราย' },
    update: {},
  });

  console.log('✅ Schools ready');

  // 2) Member types (upsert)
  const regularTeacher = await prisma.memberType.upsert({
    where: { code: 'REG' },
    create: { code: 'REG', name: 'ครูประจำการ', description: 'ครูที่ปฏิบัติงานอยู่' },
    update: {},
  });

  const retiredTeacher = await prisma.memberType.upsert({
    where: { code: 'RET' },
    create: { code: 'RET', name: 'ครูเกษียณ', description: 'ครูที่เกษียณอายุราชการแล้ว' },
    update: {},
  });

  const staff = await prisma.memberType.upsert({
    where: { code: 'STF' },
    create: { code: 'STF', name: 'บุคลากรสนับสนุน', description: 'บุคลากรทางการศึกษาอื่นๆ' },
    update: {},
  });

  console.log('✅ Member types ready');

  // 3) Groups (สร้างเท่าที่ยังไม่มี)
  const groupA1 =
    (await prisma.group.findFirst({ where: { schoolId: schoolA.id, code: 'G01' } })) ??
    (await prisma.group.create({
      data: { schoolId: schoolA.id, code: 'G01', name: 'กลุ่มบ้านพญาไพร 1' },
    }));

  const groupA2 =
    (await prisma.group.findFirst({ where: { schoolId: schoolA.id, code: 'G02' } })) ??
    (await prisma.group.create({
      data: { schoolId: schoolA.id, code: 'G02', name: 'กลุ่มบ้านพญาไพร 2' },
    }));

  const groupB1 =
    (await prisma.group.findFirst({ where: { schoolId: schoolB.id, code: 'G01' } })) ??
    (await prisma.group.create({
      data: { schoolId: schoolB.id, code: 'G01', name: 'กลุ่มโรงเรียนบ้านตัวอย่าง 1' },
    }));

  const groupC1 =
    (await prisma.group.findFirst({ where: { schoolId: schoolC.id, code: 'G01' } })) ??
    (await prisma.group.create({
      data: { schoolId: schoolC.id, code: 'G01', name: 'กลุ่มวัดป่างาม 1' },
    }));

  console.log('✅ Groups ready');

  // 4) Admin user (password: 1234) - upsert
  const hashedPassword = await bcrypt.hash('1234', 10);

  const admin = await prisma.user.upsert({
    where: { username: 'admin' },
    create: { username: 'admin', passwordHash: hashedPassword, fullName: 'ผู้ดูแลระบบ', role: Role.ADMIN },
    update: {},
  });

  await prisma.user.upsert({
    where: { username: 'finance' },
    create: {
      username: 'finance',
      passwordHash: hashedPassword,
      fullName: 'เจ้าหน้าที่การเงิน',
      role: Role.FINANCE,
      schoolId: schoolA.id,
    },
    update: {},
  });

  await prisma.user.upsert({
    where: { username: 'account' },
    create: {
      username: 'account',
      passwordHash: hashedPassword,
      fullName: 'เจ้าหน้าที่บัญชี',
      role: Role.ACCOUNTING,
      schoolId: schoolA.id,
    },
    update: {},
  });

  console.log('✅ Users ready (admin/1234, finance/1234, account/1234)');

  // 5) Chart of accounts (minimal) - upsert
  const cash = await prisma.account.upsert({
    where: { code: '101' },
    create: { code: '101', name: 'เงินสด', type: AccountType.ASSET },
    update: {},
  });
  const bank = await prisma.account.upsert({
    where: { code: '102' },
    create: { code: '102', name: 'เงินฝากธนาคาร', type: AccountType.ASSET },
    update: {},
  });
  const welfareRevenue = await prisma.account.upsert({
    where: { code: '401' },
    create: { code: '401', name: 'รายได้เงินสงเคราะห์', type: AccountType.INCOME },
    update: {},
  });
  const serviceRevenue = await prisma.account.upsert({
    where: { code: '402' },
    create: { code: '402', name: 'รายได้ค่าบริการ', type: AccountType.INCOME },
    update: {},
  });
  const deathBenefitExpense = await prisma.account.upsert({
    where: { code: '501' },
    create: { code: '501', name: 'ค่าใช้จ่ายเงินสงเคราะห์ศพ', type: AccountType.EXPENSE },
    update: {},
  });

  console.log('✅ Chart of accounts ready');

  // 6) Bank accounts - บัญชีกลางของกองทุน (Single Fund) - upsert
  const mainBank = await prisma.bankAccount.upsert({
    where: { accountNo: '123-4-56789-0' },
    create: {
      bankName: 'ธนาคารกรุงไทย',
      accountNo: '123-4-56789-0',
      accountName: 'กองทุนฌาปนกิจสงเคราะห์ครูและบุคลากรทางการศึกษา อ.แม่ฟ้าหลวง',
      description: 'บัญชีหลัก',
      isDefault: true,
    },
    update: {},
  });

  await prisma.bankAccount.upsert({
    where: { accountNo: '234-5-67890-1' },
    create: {
      bankName: 'ธนาคารกรุงเทพ',
      accountNo: '234-5-67890-1',
      accountName: 'กองทุนฌาปนกิจสงเคราะห์ครูฯ (บัญชีสำรอง)',
      description: 'บัญชีสำรอง',
      isDefault: false,
    },
    update: {},
  });

  console.log('✅ Bank accounts ready (Central Fund)');

  // 7) Members - School A
  const member1 = await prisma.member.create({
    data: {
      memberNo: 'M0001',
      schoolId: schoolA.id,
      memberTypeId: regularTeacher.id,
      groupId: groupA1.id,
      firstName: 'สมชาย',
      lastName: 'ใจดี',
      idCardNo: '1-5709-99999-01-1',
      phone: '0812345678',
      joinDate: new Date('2018-05-01'),
      status: MemberStatus.ACTIVE,
      beneficiaries: {
        create: [
          { fullName: 'นางสมศรี ใจดี', relationship: 'คู่สมรส', phone: '0899998888', priority: 1 },
          { fullName: 'ด.ช.สมหวัง ใจดี', relationship: 'บุตร', phone: '0899998889', priority: 2 },
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
      idCardNo: '1-5709-99999-02-2',
      phone: '0823456789',
      joinDate: new Date('2019-03-10'),
      status: MemberStatus.ACTIVE,
    },
  });

  const member3 = await prisma.member.create({
    data: {
      memberNo: 'M0003',
      schoolId: schoolA.id,
      memberTypeId: regularTeacher.id,
      groupId: groupA2.id,
      firstName: 'ประสิทธิ์',
      lastName: 'มั่นคง',
      idCardNo: '1-5709-99999-03-3',
      phone: '0834567890',
      joinDate: new Date('2015-06-15'),
      status: MemberStatus.ACTIVE,
    },
  });

  const member4 = await prisma.member.create({
    data: {
      memberNo: 'M0004',
      schoolId: schoolA.id,
      memberTypeId: retiredTeacher.id,
      groupId: groupA1.id,
      firstName: 'สมปอง',
      lastName: 'สงบ',
      idCardNo: '1-5709-99999-04-4',
      phone: '0845678901',
      joinDate: new Date('2000-01-01'),
      status: MemberStatus.ACTIVE,
    },
  });

  // Members - School B
  const member5 = await prisma.member.create({
    data: {
      memberNo: 'M0005',
      schoolId: schoolB.id,
      memberTypeId: retiredTeacher.id,
      groupId: groupB1.id,
      firstName: 'เกษียณ',
      lastName: 'มีสุข',
      idCardNo: '1-5709-99999-05-5',
      joinDate: new Date('2010-01-01'),
      status: MemberStatus.ACTIVE,
      beneficiaries: {
        create: [
          { fullName: 'นางสาวสุข มีสุข', relationship: 'บุตร', phone: '0888888888', priority: 1 },
        ],
      },
    },
  });

  const member6 = await prisma.member.create({
    data: {
      memberNo: 'M0006',
      schoolId: schoolB.id,
      memberTypeId: regularTeacher.id,
      groupId: groupB1.id,
      firstName: 'สุดา',
      lastName: 'รักเรียน',
      idCardNo: '1-5709-99999-06-6',
      phone: '0856789012',
      joinDate: new Date('2020-08-01'),
      status: MemberStatus.ARREARS,
    },
  });

  // Members - School C
  await prisma.member.create({
    data: {
      memberNo: 'M0007',
      schoolId: schoolC.id,
      memberTypeId: regularTeacher.id,
      groupId: groupC1.id,
      firstName: 'มานะ',
      lastName: 'พัฒนา',
      idCardNo: '1-5709-99999-07-7',
      phone: '0867890123',
      joinDate: new Date('2021-05-01'),
      status: MemberStatus.ACTIVE,
    },
  });

  await prisma.member.create({
    data: {
      memberNo: 'M0008',
      schoolId: schoolC.id,
      memberTypeId: staff.id,
      groupId: groupC1.id,
      firstName: 'พิมพ์',
      lastName: 'สวย',
      joinDate: new Date('2022-02-15'),
      status: MemberStatus.ACTIVE,
    },
  });

  console.log('✅ Created members with beneficiaries');

  // 8) Contribution periods - upsert
  const period2024Nov = await prisma.contributionPeriod.upsert({
    where: { year_month: { year: 2024, month: 11 } },
    create: { year: 2024, month: 11, welfareRate: 100.0, serviceFee: 10.0, isClosed: true },
    update: {},
  });

  const period2024Dec = await prisma.contributionPeriod.upsert({
    where: { year_month: { year: 2024, month: 12 } },
    create: { year: 2024, month: 12, welfareRate: 100.0, serviceFee: 10.0 },
    update: {},
  });

  const period2025Jan = await prisma.contributionPeriod.upsert({
    where: { year_month: { year: 2025, month: 1 } },
    create: { year: 2025, month: 1, welfareRate: 100.0, serviceFee: 10.0 },
    update: {},
  });

  console.log('✅ Contribution periods ready');

  // 9) Sample contributions for Dec 2024 (ข้ามถ้ามีอยู่แล้ว)
  const existingReceipt = await prisma.receipt.findUnique({ where: { receiptNo: 'R202412-M0001' } });
  if (!existingReceipt) {
  const welfareAmount = 100.0;
  const serviceAmount = 10.0;
  const totalAmount = welfareAmount + serviceAmount;

  const activeMembers = [member1, member2, member3, member4, member5];

  for (const member of activeMembers) {
    const receipt = await prisma.receipt.create({
      data: {
        receiptNo: `R202412-${member.memberNo}`,
        schoolId: member.schoolId,
        date: new Date('2024-12-05'),
        type: ReceiptType.MEMBER_CONTRIBUTION,
        amount: totalAmount,
        description: `ชำระเงินสงเคราะห์ประจำเดือน 12/2567 - ${member.firstName} ${member.lastName}`,
        bankAccountId: mainBank.id,
      },
    });

    await prisma.memberContribution.create({
      data: {
        memberId: member.id,
        periodId: period2024Dec.id,
        schoolId: member.schoolId,
        welfareAmount,
        serviceAmount,
        totalAmount,
        paidAmount: totalAmount,
        paidDate: new Date('2024-12-05'),
        receiptId: receipt.id,
      },
    });

    // Ledger entries
    await prisma.ledgerEntry.createMany({
      data: [
        {
          accountId: bank.id,
          date: new Date('2024-12-05'),
          description: `รับเงินสงเคราะห์ ${member.firstName} ${member.lastName}`,
          debit: totalAmount,
          credit: 0,
          receiptId: receipt.id,
        },
        {
          accountId: welfareRevenue.id,
          date: new Date('2024-12-05'),
          description: `รายได้เงินสงเคราะห์ ${member.firstName} ${member.lastName}`,
          debit: 0,
          credit: welfareAmount,
          receiptId: receipt.id,
        },
        {
          accountId: serviceRevenue.id,
          date: new Date('2024-12-05'),
          description: `รายได้ค่าบริการ ${member.firstName} ${member.lastName}`,
          debit: 0,
          credit: serviceAmount,
          receiptId: receipt.id,
        },
      ],
    });
  }

  // Create unpaid contribution (arrears) for member6
  await prisma.memberContribution.create({
    data: {
      memberId: member6.id,
      periodId: period2024Dec.id,
      schoolId: member6.schoolId,
      welfareAmount,
      serviceAmount,
      totalAmount,
      paidAmount: 0,
      isArrears: true,
    },
  });

  console.log('✅ Created contributions and receipts');

  // 10) Example death claim for member1
  const claim = await prisma.deathClaim.create({
    data: {
      memberId: member1.id,
      schoolId: schoolA.id,
      claimNo: 'DC-2024-0001',
      reportedDate: new Date('2024-12-10'),
      deathDate: new Date('2024-12-08'),
      causeOfDeath: 'โรคประจำตัว',
      mainBeneficiary: 'นางสมศรี ใจดี',
      beneficiaryPhone: '0899998888',
      activeMemberCount: 50, // จำนวนสมาชิก ณ ขณะนั้น
      welfareRate: 20.0, // อัตราต่อคน
      totalContribution: 1000.0, // 50 * 20
      associationSupport: 19500.0, // เงินสมทบจากสมาคม
      otherDeductions: 500.0,
      netToPay: 20000.0, // ยอดสุทธิจ่าย
    },
  });

  // Update member1 status to DECEASED
  await prisma.member.update({
    where: { id: member1.id },
    data: { status: MemberStatus.DECEASED, deathDate: new Date('2024-12-08') },
  });

  // Create payment voucher for death benefit
  const payment = await prisma.paymentVoucher.create({
    data: {
      voucherNo: 'PV-2024-0001',
      schoolId: schoolA.id,
      date: new Date('2024-12-15'),
      type: PaymentType.DEATH_BENEFIT,
      description: `จ่ายเงินสงเคราะห์ศพ ${member1.firstName} ${member1.lastName}`,
      amount: 20000.0,
      bankAccountId: mainBank.id,
    },
  });

  // Link death benefit payment
  await prisma.deathBenefitPayment.create({
    data: {
      deathClaimId: claim.id,
      payDate: new Date('2024-12-15'),
      method: 'BANK_TRANSFER',
      bankAccountId: mainBank.id,
      amount: 20000.0,
      voucherId: payment.id,
    },
  });

  // Ledger for payment
  await prisma.ledgerEntry.createMany({
    data: [
      {
        accountId: deathBenefitExpense.id,
        date: new Date('2024-12-15'),
        description: `จ่ายเงินสงเคราะห์ศพ ${member1.firstName} ${member1.lastName}`,
        debit: 20000.0,
        credit: 0,
        paymentId: payment.id,
      },
      {
        accountId: bank.id,
        date: new Date('2024-12-15'),
        description: `จ่ายเงินสงเคราะห์ศพ ${member1.firstName} ${member1.lastName}`,
        debit: 0,
        credit: 20000.0,
        paymentId: payment.id,
      },
    ],
  });

  console.log('✅ Created death claim and payment');
  } else {
    console.log('⏭️ Sample contributions/death claim already exist, skipped');
  }

  console.log('');
  console.log('🎉 Seed completed successfully!');
  console.log('');
  console.log('📋 Test accounts:');
  console.log('   - admin / 1234 (ผู้ดูแลระบบ)');
  console.log('   - finance / 1234 (เจ้าหน้าที่การเงิน)');
  console.log('   - account / 1234 (เจ้าหน้าที่บัญชี)');
}

main()
  .catch((e) => {
    console.error('❌ Seed error:', e);
    console.error('');
    console.error('💡 Troubleshooting tips:');
    console.error('   1. Check DATABASE_URL in .env file (use lowercase database name)');
    console.error('   2. Ensure database exists: CREATE DATABASE cremation_db;');
    console.error('   3. Check MySQL case sensitivity: SHOW VARIABLES LIKE "lower_case_table_names";');
    console.error('   4. Verify Prisma Client is generated: npx prisma generate');
    console.error('   5. Check MySQL service: sudo systemctl status mysql');
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });

