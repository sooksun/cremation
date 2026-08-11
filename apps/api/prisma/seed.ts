// prisma/seed.ts
import {
  PrismaClient,
  Role,
  MemberStatus,
  ReceiptType,
  PaymentType,
  AccountType,
  DeathClaimType,
  DeathClaimStatus,
  DeceasedType,
  MembershipClass,
  ProtectedRelationship,
} from '@prisma/client';
import {
  buildDefaultDocumentChecklist,
  computeWorkflowDeadlines,
} from '../src/death-claims/death-claim-workflow.constants';
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

  // 1) School clusters (กลุ่มโรงเรียน)
  const clusterMfl = await prisma.schoolCluster.upsert({
    where: { code: 'CL01' },
    create: { code: 'CL01', name: 'กลุ่มโรงเรียนอำเภอแม่ฟ้าหลวง' },
    update: {},
  });

  const clusterOther = await prisma.schoolCluster.upsert({
    where: { code: 'CL02' },
    create: { code: 'CL02', name: 'กลุ่มโรงเรียนอำเภออื่น' },
    update: {},
  });

  console.log('✅ School clusters ready');

  // 2) Base schools (upsert = สร้างหรือใช้ของเดิม ถ้ามีอยู่แล้ว)
  const schoolA = await prisma.school.upsert({
    where: { code: 'SCH001' },
    create: {
      code: 'SCH001',
      name: 'โรงเรียนบ้านพญาไพร',
      district: 'แม่ฟ้าหลวง',
      province: 'เชียงราย',
      clusterId: clusterMfl.id,
    },
    update: { clusterId: clusterMfl.id },
  });

  const schoolB = await prisma.school.upsert({
    where: { code: 'SCH002' },
    create: {
      code: 'SCH002',
      name: 'โรงเรียนบ้านตัวอย่าง',
      district: 'เมือง',
      province: 'เชียงราย',
      clusterId: clusterOther.id,
    },
    update: { clusterId: clusterOther.id },
  });

  const schoolC = await prisma.school.upsert({
    where: { code: 'SCH003' },
    create: {
      code: 'SCH003',
      name: 'โรงเรียนวัดป่างาม',
      district: 'แม่สาย',
      province: 'เชียงราย',
      clusterId: clusterOther.id,
    },
    update: { clusterId: clusterOther.id },
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

  await prisma.memberType.upsert({
    where: { code: 'PERM' },
    create: { code: 'PERM', name: 'ลูกจ้างประจำ', description: 'ลูกจ้างประจำของหน่วยงาน/โรงเรียน (สมาชิกสามัญ)' },
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

  // 4) Users — unique passwords (set SEED_ADMIN_PASSWORD for deterministic admin login in dev)
  const { generateTemporaryPassword } = await import('../src/common/utils/password.util');
  const seedPasswords: string[] = [];

  const adminPassword = process.env.SEED_ADMIN_PASSWORD || generateTemporaryPassword();
  const adminHash = await bcrypt.hash(adminPassword, 10);
  seedPasswords.push(`admin / ${adminPassword}`);

  const admin = await prisma.user.upsert({
    where: { username: 'admin' },
    create: {
      username: 'admin',
      passwordHash: adminHash,
      fullName: 'ผู้ดูแลระบบ',
      role: Role.ADMIN,
      mustChangePassword: false,
    },
    update: { passwordHash: adminHash, mustChangePassword: false },
  });

  for (const [username, fullName, role, schoolId] of [
    ['finance', 'เจ้าหน้าที่การเงิน', Role.FINANCE, schoolA.id],
    ['account', 'เจ้าหน้าที่บัญชี', Role.ACCOUNTING, schoolA.id],
  ] as const) {
    const password = generateTemporaryPassword();
    const passwordHash = await bcrypt.hash(password, 10);
    seedPasswords.push(`${username} / ${password}`);
    await prisma.user.upsert({
      where: { username },
      create: {
        username,
        passwordHash,
        fullName,
        role,
        schoolId,
        mustChangePassword: true,
      },
      update: { passwordHash, mustChangePassword: true },
    });
  }

  const seedSchools = [schoolA, schoolB, schoolC];
  for (const school of seedSchools) {
    const schoolAdminUsername = `admin-${school.code.toLowerCase()}`;
    const password = generateTemporaryPassword();
    const passwordHash = await bcrypt.hash(password, 10);
    seedPasswords.push(`${schoolAdminUsername} / ${password}`);
    await prisma.user.upsert({
      where: { username: schoolAdminUsername },
      create: {
        username: schoolAdminUsername,
        passwordHash,
        fullName: `ผู้ดูแล ${school.name}`,
        role: Role.SCHOOL_ADMIN,
        schoolId: school.id,
        mustChangePassword: true,
      },
      update: {
        role: Role.SCHOOL_ADMIN,
        schoolId: school.id,
        fullName: `ผู้ดูแล ${school.name}`,
        passwordHash,
        mustChangePassword: true,
      },
    });
  }

  console.log('✅ Users ready (unique passwords — copy from log below)');
  for (const line of seedPasswords) {
    console.log(`   ${line}`);
  }

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
  // กองทุนสะสม 10% (ข้อ 13.5.2/16) + แหล่งงบดำเนินงานตามข้อ 13.5
  await prisma.account.upsert({
    where: { code: '301' },
    create: { code: '301', name: 'กองทุนฌาปนกิจสงเคราะห์สะสม', type: AccountType.EQUITY },
    update: {},
  });
  await prisma.account.upsert({
    where: { code: '403' },
    create: { code: '403', name: 'ดอกเบี้ยรับ', type: AccountType.INCOME },
    update: {},
  });
  await prisma.account.upsert({
    where: { code: '404' },
    create: { code: '404', name: 'เงินบริจาค', type: AccountType.INCOME },
    update: {},
  });
  // ค่าเสื่อมราคา (assets.service.ts recordDepreciation ใช้ 503/152 — ไม่มีใน seed เดิม)
  await prisma.account.upsert({
    where: { code: '503' },
    create: { code: '503', name: 'ค่าเสื่อมราคา', type: AccountType.EXPENSE },
    update: {},
  });
  // บัญชีสะสมหักค่าเสื่อมราคา — contra-asset แต่ schema ไม่มี AccountType แยก จึงใช้ ASSET
  // ให้สอดคล้องกับ convention รหัส 1xx เดิม (101, 102 = ASSET)
  await prisma.account.upsert({
    where: { code: '152' },
    create: { code: '152', name: 'ค่าเสื่อมราคาสะสม', type: AccountType.ASSET },
    update: {},
  });
  // ทุนสะสม (accumulated capital)
  await prisma.account.upsert({
    where: { code: '310' },
    create: { code: '310', name: 'ทุนสะสม', type: AccountType.EQUITY },
    update: {},
  });
  // สรุปรายได้-ค่าใช้จ่าย / กำไรสะสม (income summary / retained earnings — บัญชีปิดงวด)
  await prisma.account.upsert({
    where: { code: '399' },
    create: { code: '399', name: 'สรุปรายได้-ค่าใช้จ่าย (กำไรสะสม)', type: AccountType.EQUITY },
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

  // 7) สมาชิกสมาคม (ข้อมูลหลัก) — สร้างก่อน แล้วค่อยสร้างสมาชิกฌาปนกิจที่อ้างอิง (idempotent)
  const am1 = (await prisma.associationMember.findFirst({ where: { schoolId: schoolA.id, firstName: 'สมชาย', lastName: 'ใจดี' } })) ?? await prisma.associationMember.create({
    data: {
      schoolId: schoolA.id,
      memberTypeId: regularTeacher.id,
      firstName: 'สมชาย',
      lastName: 'ใจดี',
      idCardNo: '1-5709-99999-01-1',
      phone: '0812345678',
      associationJoinDate: new Date('2018-05-01'),
    },
  });
  const am2 = (await prisma.associationMember.findFirst({ where: { schoolId: schoolA.id, firstName: 'วิไล', lastName: 'สุขสันต์' } })) ?? await prisma.associationMember.create({
    data: {
      schoolId: schoolA.id,
      memberTypeId: staff.id,
      firstName: 'วิไล',
      lastName: 'สุขสันต์',
      idCardNo: '1-5709-99999-02-2',
      phone: '0823456789',
      associationJoinDate: new Date('2019-03-10'),
    },
  });
  const am3 = (await prisma.associationMember.findFirst({ where: { schoolId: schoolA.id, firstName: 'ประสิทธิ์', lastName: 'มั่นคง' } })) ?? await prisma.associationMember.create({
    data: {
      schoolId: schoolA.id,
      memberTypeId: regularTeacher.id,
      firstName: 'ประสิทธิ์',
      lastName: 'มั่นคง',
      idCardNo: '1-5709-99999-03-3',
      phone: '0834567890',
      associationJoinDate: new Date('2015-06-15'),
    },
  });
  const am4 = (await prisma.associationMember.findFirst({ where: { schoolId: schoolA.id, firstName: 'สมปอง', lastName: 'สงบ' } })) ?? await prisma.associationMember.create({
    data: {
      schoolId: schoolA.id,
      memberTypeId: retiredTeacher.id,
      firstName: 'สมปอง',
      lastName: 'สงบ',
      idCardNo: '1-5709-99999-04-4',
      phone: '0845678901',
      associationJoinDate: new Date('2000-01-01'),
    },
  });
  const am5 = (await prisma.associationMember.findFirst({ where: { schoolId: schoolB.id, firstName: 'เกษียณ', lastName: 'มีสุข' } })) ?? await prisma.associationMember.create({
    data: {
      schoolId: schoolB.id,
      memberTypeId: retiredTeacher.id,
      firstName: 'เกษียณ',
      lastName: 'มีสุข',
      idCardNo: '1-5709-99999-05-5',
      associationJoinDate: new Date('2010-01-01'),
    },
  });
  const am6 = (await prisma.associationMember.findFirst({ where: { schoolId: schoolB.id, firstName: 'สุดา', lastName: 'รักเรียน' } })) ?? await prisma.associationMember.create({
    data: {
      schoolId: schoolB.id,
      memberTypeId: regularTeacher.id,
      firstName: 'สุดา',
      lastName: 'รักเรียน',
      idCardNo: '1-5709-99999-06-6',
      phone: '0856789012',
      associationJoinDate: new Date('2020-08-01'),
    },
  });
  const am7 = (await prisma.associationMember.findFirst({ where: { schoolId: schoolC.id, firstName: 'มานะ', lastName: 'พัฒนา' } })) ?? await prisma.associationMember.create({
    data: {
      schoolId: schoolC.id,
      memberTypeId: regularTeacher.id,
      firstName: 'มานะ',
      lastName: 'พัฒนา',
      idCardNo: '1-5709-99999-07-7',
      phone: '0867890123',
      associationJoinDate: new Date('2021-05-01'),
    },
  });
  const am8 = (await prisma.associationMember.findFirst({ where: { schoolId: schoolC.id, firstName: 'พิมพ์', lastName: 'สวย' } })) ?? await prisma.associationMember.create({
    data: {
      schoolId: schoolC.id,
      memberTypeId: staff.id,
      firstName: 'พิมพ์',
      lastName: 'สวย',
      associationJoinDate: new Date('2022-02-15'),
    },
  });
  // สมาชิกสมาคมที่ยังไม่เข้าร่วมฌาปนกิจ (ตัวอย่าง)
  if (!(await prisma.associationMember.findFirst({ where: { schoolId: schoolA.id, firstName: 'ทดสอบ', lastName: 'เฉพาะสมาคม' } }))) {
    await prisma.associationMember.create({
      data: {
        schoolId: schoolA.id,
        memberTypeId: regularTeacher.id,
        firstName: 'ทดสอบ',
        lastName: 'เฉพาะสมาคม',
        associationJoinDate: new Date('2024-01-01'),
      },
    });
  }

  console.log('✅ Created association members');

  // 8) สมาชิกฌาปนกิจ — อ้างอิงจากสมาชิกสมาคม (ทุกคนในฌาปนกิจต้องเป็นสมาชิกสมาคม) (idempotent)
  const member1Join = new Date('2018-05-01');
  const member1Deadline = new Date(member1Join);
  member1Deadline.setDate(member1Deadline.getDate() + 30);

  const member1 = (await prisma.member.findFirst({ where: { associationMemberId: am1.id } })) ?? await prisma.member.create({
    data: {
      associationMemberId: am1.id,
      memberNo: 'M0001',
      schoolId: schoolA.id,
      groupId: groupA1.id,
      joinDate: member1Join,
      status: MemberStatus.ACTIVE,
      membershipClass: MembershipClass.ORDINARY,
      salaryDeduction: true,
      applicationSubmittedAt: member1Join,
      applicationDeadline: member1Deadline,
      beneficiaries: {
        create: [
          { fullName: 'นางสมศรี ใจดี', relationship: 'คู่สมรส', phone: '0899998888', priority: 1 },
          { fullName: 'ด.ช.สมหวัง ใจดี', relationship: 'บุตร', phone: '0899998889', priority: 2 },
        ],
      },
      protectedPersons: {
        create: [
          { fullName: 'นางสมศรี ใจดี', relationship: ProtectedRelationship.SPOUSE, phone: '0899998888' },
          { fullName: 'ด.ช.สมหวัง ใจดี', relationship: ProtectedRelationship.CHILD, phone: '0899998889' },
        ],
      },
    },
  });
  await prisma.member.update({
    where: { id: member1.id },
    data: {
      membershipClass: MembershipClass.ORDINARY,
      salaryDeduction: true,
      applicationSubmittedAt: member1Join,
      applicationDeadline: member1Deadline,
    },
  });

  const member2Join = new Date('2019-03-10');
  const member2Deadline = new Date(member2Join);
  member2Deadline.setDate(member2Deadline.getDate() + 30);

  const member2 = (await prisma.member.findFirst({ where: { associationMemberId: am2.id } })) ?? await prisma.member.create({
    data: {
      associationMemberId: am2.id,
      memberNo: 'M0002',
      schoolId: schoolA.id,
      groupId: groupA1.id,
      joinDate: member2Join,
      status: MemberStatus.ACTIVE,
      membershipClass: MembershipClass.CONTRIBUTORY,
      applicationDeadline: member2Deadline,
    },
  });
  await prisma.member.update({
    where: { id: member2.id },
    data: {
      membershipClass: MembershipClass.CONTRIBUTORY,
      applicationDeadline: member2Deadline,
    },
  });
  const member3 = (await prisma.member.findFirst({ where: { associationMemberId: am3.id } })) ?? await prisma.member.create({
    data: {
      associationMemberId: am3.id,
      memberNo: 'M0003',
      schoolId: schoolA.id,
      groupId: groupA2.id,
      joinDate: new Date('2015-06-15'),
      status: MemberStatus.ACTIVE,
      membershipClass: MembershipClass.ORDINARY,
      protectedPersons: {
        create: [
          { fullName: 'นายบิดา มั่นคง', relationship: ProtectedRelationship.PARENT },
          { fullName: 'นางมารดา มั่นคง', relationship: ProtectedRelationship.PARENT },
        ],
      },
    },
  });
  if (!(await prisma.protectedPerson.findFirst({ where: { memberId: member3.id } }))) {
    await prisma.protectedPerson.createMany({
      data: [
        { memberId: member3.id, fullName: 'นายบิดา มั่นคง', relationship: ProtectedRelationship.PARENT },
        { memberId: member3.id, fullName: 'นางมารดา มั่นคง', relationship: ProtectedRelationship.PARENT },
      ],
    });
  }
  const member4 = (await prisma.member.findFirst({ where: { associationMemberId: am4.id } })) ?? await prisma.member.create({
    data: {
      associationMemberId: am4.id,
      memberNo: 'M0004',
      schoolId: schoolA.id,
      groupId: groupA1.id,
      joinDate: new Date('2000-01-01'),
      status: MemberStatus.ACTIVE,
    },
  });
  const member5 = (await prisma.member.findFirst({ where: { associationMemberId: am5.id } })) ?? await prisma.member.create({
    data: {
      associationMemberId: am5.id,
      memberNo: 'M0005',
      schoolId: schoolB.id,
      groupId: groupB1.id,
      joinDate: new Date('2010-01-01'),
      status: MemberStatus.ACTIVE,
      beneficiaries: {
        create: [
          { fullName: 'นางสาวสุข มีสุข', relationship: 'บุตร', phone: '0888888888', priority: 1 },
        ],
      },
    },
  });
  const member6 = (await prisma.member.findFirst({ where: { associationMemberId: am6.id } })) ?? await prisma.member.create({
    data: {
      associationMemberId: am6.id,
      memberNo: 'M0006',
      schoolId: schoolB.id,
      groupId: groupB1.id,
      joinDate: new Date('2020-08-01'),
      status: MemberStatus.ARREARS,
    },
  });
  if (!(await prisma.member.findFirst({ where: { associationMemberId: am7.id } }))) {
  await prisma.member.create({
    data: {
      associationMemberId: am7.id,
      memberNo: 'M0007',
      schoolId: schoolC.id,
      groupId: groupC1.id,
      joinDate: new Date('2021-05-01'),
      status: MemberStatus.ACTIVE,
    },
  });
  }
  if (!(await prisma.member.findFirst({ where: { associationMemberId: am8.id } }))) {
  await prisma.member.create({
    data: {
      associationMemberId: am8.id,
      memberNo: 'M0008',
      schoolId: schoolC.id,
      groupId: groupC1.id,
      joinDate: new Date('2022-02-15'),
      status: MemberStatus.ACTIVE,
    },
  });
  }

  console.log('✅ Created cremation members (linked to association members)');

  // 9) Contribution periods - upsert
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

  // 10) Sample contributions for Dec 2024 (ข้ามถ้ามีอยู่แล้ว)
  const existingReceipt = await prisma.receipt.findUnique({ where: { receiptNo: 'R202412-M0001' } });
  if (!existingReceipt) {
  const welfareAmount = 100.0;
  const serviceAmount = 10.0;
  const totalAmount = welfareAmount + serviceAmount;

  const activeMembers = [member1, member2, member3, member4, member5];
  const activeAssociationMembers = [am1, am2, am3, am4, am5];

  for (let i = 0; i < activeMembers.length; i++) {
    const member = activeMembers[i];
    const am = activeAssociationMembers[i];
    const receipt = await prisma.receipt.create({
      data: {
        receiptNo: `R202412-${member.memberNo}`,
        schoolId: member.schoolId,
        date: new Date('2024-12-05'),
        type: ReceiptType.MEMBER_CONTRIBUTION,
        amount: totalAmount,
        description: `ชำระเงินสงเคราะห์ประจำเดือน 12/2567 - ${am.firstName} ${am.lastName}`,
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
          description: `รับเงินสงเคราะห์ ${am.firstName} ${am.lastName}`,
          debit: totalAmount,
          credit: 0,
          receiptId: receipt.id,
        },
        {
          accountId: welfareRevenue.id,
          date: new Date('2024-12-05'),
          description: `รายได้เงินสงเคราะห์ ${am.firstName} ${am.lastName}`,
          debit: 0,
          credit: welfareAmount,
          receiptId: receipt.id,
        },
        {
          accountId: serviceRevenue.id,
          date: new Date('2024-12-05'),
          description: `รายได้ค่าบริการ ${am.firstName} ${am.lastName}`,
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

  // 11) Example death claim for member1
  const reportedDate = new Date('2024-12-10');
  const deathDate = new Date('2024-12-08');
  const workflow = computeWorkflowDeadlines({
    deathDate,
    reportedDate,
    membershipClass: MembershipClass.ORDINARY,
    salaryDeduction: true,
  });
  const documentChecklist = buildDefaultDocumentChecklist({
    claimType: DeathClaimType.MEMBER_DEATH,
    membershipClass: MembershipClass.ORDINARY,
    salaryDeduction: true,
  }).map((item) => ({ ...item, checked: true }));

  const claim = await prisma.deathClaim.create({
    data: {
      memberId: member1.id,
      schoolId: schoolA.id,
      claimNo: 'DC-2024-0001',
      reportedDate,
      deathDate,
      causeOfDeath: 'โรคประจำตัว',
      mainBeneficiary: 'นางสมศรี ใจดี',
      beneficiaryPhone: '0899998888',
      claimType: DeathClaimType.MEMBER_DEATH,
      deceasedType: DeceasedType.MEMBER,
      activeMemberCount: 50,
      welfareRate: 100.0,
      totalContribution: 5000.0,
      associationSupport: 500.0,
      payoutRatio: 0.9,
      otherDeductions: 0,
      netToPay: 4500.0,
      status: DeathClaimStatus.PAID,
      collectionChannel: workflow.collectionChannel,
      notifyAuthorityDeadline: workflow.notifyAuthorityDeadline,
      collectionDeadline: workflow.collectionDeadline,
      documentDeadline: workflow.documentDeadline,
      paymentDeadline: workflow.paymentDeadline,
      collectedAmount: 5000.0,
      collectionCompletedAt: new Date('2024-12-12'),
      documentsComplete: true,
      documentChecklist,
    },
  });

  await prisma.deathClaim.update({
    where: { id: claim.id },
    data: {
      approvedById: admin.id,
      approvedAt: new Date('2024-12-14'),
      approverName: admin.fullName,
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
      description: `จ่ายเงินสงเคราะห์ศพ ${am1.firstName} ${am1.lastName}`,
      amount: 4500.0,
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
      amount: 4500.0,
      voucherId: payment.id,
    },
  });

  // Ledger for payment
  await prisma.ledgerEntry.createMany({
    data: [
      {
        accountId: deathBenefitExpense.id,
        date: new Date('2024-12-15'),
        description: `จ่ายเงินสงเคราะห์ศพ ${am1.firstName} ${am1.lastName}`,
        debit: 4500.0,
        credit: 0,
        paymentId: payment.id,
      },
      {
        accountId: bank.id,
        date: new Date('2024-12-15'),
        description: `จ่ายเงินสงเคราะห์ศพ ${am1.firstName} ${am1.lastName}`,
        debit: 0,
        credit: 4500.0,
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

