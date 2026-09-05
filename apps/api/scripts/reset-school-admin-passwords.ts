/**
 * ตั้งรหัสผ่านใหม่ให้ผู้ดูแลโรงเรียนทั้งชุด (31 โรงเรียนจริง SCH_001..SCH_031)
 *
 * เลือกบัญชีจาก "รหัสโรงเรียน" ไม่ใช่ชื่อผู้ใช้ จึงใช้ได้ทั้งก่อนและหลังเปลี่ยนชื่อ
 * เป็น admin01..admin31 และไม่แตะบัญชีข้อมูลตัวอย่าง (SCH001..SCH004) หรือส่วนกลาง
 *
 * ใช้:
 *   # 1) ดูก่อนว่าจะกระทบบัญชีไหนบ้าง ไม่เขียนและไม่สร้างรหัส
 *   npx ts-node --project tsconfig.json scripts/reset-school-admin-passwords.ts
 *
 *   # 2) เขียนจริง สุ่มรหัสไม่ซ้ำกันให้แต่ละบัญชี (แนะนำ)
 *   APPLY=1 npx ts-node --project tsconfig.json scripts/reset-school-admin-passwords.ts
 *
 *   # 3) เขียนจริง ใช้รหัสเดียวกันทุกบัญชี (สะดวกตอนแจกครั้งแรก แต่ปลอดภัยน้อยกว่า)
 *   APPLY=1 RESET_PASSWORD='รหัสร่วม' npx ts-node --project tsconfig.json scripts/reset-school-admin-passwords.ts
 *
 * ตัวเลือกอื่น:
 *   RESET_USERNAMES=admin01,admin05   จำกัดเฉพาะบางบัญชี (คั่นด้วยจุลภาค)
 *   MUST_CHANGE=0                     ไม่บังคับเปลี่ยนรหัสตอนเข้าครั้งแรก (ค่าเริ่มต้นคือบังคับ)
 *
 * รหัสผ่านพิมพ์ออกครั้งเดียวเท่านั้น อ่านย้อนหลังไม่ได้เพราะเก็บเป็น bcrypt hash
 * ให้ส่ง output ลงไฟล์ไว้ก่อน เช่นต่อท้ายคำสั่งด้วย  | tee ~/school-admin-passwords.tsv
 */
import { PrismaClient, Role } from '@prisma/client';
import * as bcrypt from 'bcrypt';
import {
  generateTemporaryPassword,
  validateStrongPassword,
} from '../src/common/utils/password.util';

const prisma = new PrismaClient();

// รหัสโรงเรียนจริงคือ SCH_001_... เท่านั้น (มีตัวคั่นแล้วตามด้วยตัวเลข)
const REAL_SCHOOL_CODE = /^SCH[_-]\d/i;

async function main() {
  const apply = process.env.APPLY === '1';
  const sharedPassword = process.env.RESET_PASSWORD;
  const mustChangePassword = process.env.MUST_CHANGE !== '0';
  const onlyUsernames = (process.env.RESET_USERNAMES ?? '')
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean);

  if (sharedPassword) {
    const check = validateStrongPassword(sharedPassword);
    if (!check.valid) {
      throw new Error(`รหัสผ่านไม่ผ่านเกณฑ์: ${check.errors.join(', ')}`);
    }
  }

  const admins = (
    await prisma.user.findMany({
      where: {
        role: Role.SCHOOL_ADMIN,
        schoolId: { not: null },
        ...(onlyUsernames.length ? { username: { in: onlyUsernames } } : {}),
      },
      select: {
        id: true,
        username: true,
        fullName: true,
        school: { select: { code: true, name: true } },
      },
    })
  )
    .filter((a) => REAL_SCHOOL_CODE.test(a.school?.code ?? ''))
    .sort((a, b) => (a.school?.code ?? '').localeCompare(b.school?.code ?? ''));

  if (onlyUsernames.length) {
    const found = new Set(admins.map((a) => a.username));
    const missing = onlyUsernames.filter((u) => !found.has(u));
    if (missing.length) {
      throw new Error(`ไม่พบบัญชีผู้ดูแลโรงเรียนจริงชื่อ: ${missing.join(', ')}`);
    }
  }

  // เตือนถ้าโรงเรียนจริงบางแห่งยังไม่มีผู้ดูแล
  if (!onlyUsernames.length) {
    const schools = await prisma.school.findMany({ select: { code: true, name: true } });
    const realSchools = schools.filter((s) => REAL_SCHOOL_CODE.test(s.code));
    const covered = new Set(admins.map((a) => a.school?.code));
    const uncovered = realSchools.filter((s) => !covered.has(s.code));
    if (uncovered.length) {
      console.log(`หมายเหตุ: โรงเรียนจริง ${uncovered.length} แห่งยังไม่มีผู้ดูแล`);
      for (const s of uncovered) console.log(`  - ${s.code}  ${s.name}`);
      console.log('');
    }
  }

  console.log(`พบผู้ดูแลโรงเรียนจริง ${admins.length} บัญชี`);
  console.log(
    sharedPassword
      ? 'โหมดรหัสผ่าน: ใช้รหัสเดียวกันทุกบัญชี'
      : 'โหมดรหัสผ่าน: สุ่มรหัสไม่ซ้ำกันรายบัญชี',
  );
  console.log(
    mustChangePassword
      ? 'บังคับเปลี่ยนรหัสเมื่อเข้าระบบครั้งแรก'
      : 'ไม่บังคับเปลี่ยนรหัสเมื่อเข้าระบบครั้งแรก',
  );
  console.log('');

  if (!apply) {
    console.log('รายชื่อบัญชีที่จะถูกตั้งรหัสใหม่ (ยังไม่เขียน — ใส่ APPLY=1 เพื่อบันทึก)');
    console.log('ชื่อผู้ใช้\tผู้ดูแล\tโรงเรียน');
    for (const a of admins) {
      console.log(`${a.username}\t${a.fullName}\t${a.school?.name ?? ''}`);
    }
    return;
  }

  if (admins.length === 0) {
    console.log('ไม่มีบัญชีให้ตั้งรหัสใหม่');
    return;
  }

  const rows = await Promise.all(
    admins.map(async (a) => {
      const password = sharedPassword ?? generateTemporaryPassword();
      return { admin: a, password, hash: await bcrypt.hash(password, 10) };
    }),
  );

  // เขียนทั้งชุดในทรานแซกชันเดียว ถ้าพลาดกลางทางจะไม่เหลือรหัสปนกันคนละชุด
  await prisma.$transaction(
    rows.map((r) =>
      prisma.user.update({
        where: { id: r.admin.id },
        data: {
          passwordHash: r.hash,
          mustChangePassword,
          // ปลดบัญชีที่ถูกล็อกจากการกรอกรหัสผิดหลายครั้งไปด้วย
          failedLoginAttempts: 0,
          lockedUntil: null,
        },
      }),
    ),
  );

  console.log('รหัสผ่านใหม่ — แสดงครั้งเดียว เก็บไว้ก่อนปิดหน้าจอ');
  console.log('ชื่อผู้ใช้\tผู้ดูแล\tโรงเรียน\tรหัสผ่าน');
  for (const r of rows) {
    console.log(
      `${r.admin.username}\t${r.admin.fullName}\t${r.admin.school?.name ?? ''}\t${r.password}`,
    );
  }
  // บรรทัดปิดท้ายไว้ตรวจว่า output ไม่ถูกตัด
  console.log(`\nตั้งรหัสผ่านใหม่เรียบร้อย ${rows.length} บัญชี (ต้องเห็นรหัสครบ ${rows.length} บรรทัด)`);
}

main()
  .catch((err) => {
    console.error('ล้มเหลว:', err instanceof Error ? err.message : err);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
