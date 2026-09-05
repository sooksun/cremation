/**
 * เปลี่ยนชื่อผู้ใช้ของผู้ดูแลโรงเรียนให้เป็นรูปแบบ admin + ลำดับโรงเรียน 2 หลัก
 * (admin01, admin02, ...) ตามกฎเดียวกับ buildDefaultSchoolAdminUsername
 *
 * ใช้:
 *   npx ts-node --project tsconfig.json scripts/rename-school-admin-usernames.ts        # ดูผลก่อน ไม่เขียนจริง
 *   APPLY=1 npx ts-node --project tsconfig.json scripts/rename-school-admin-usernames.ts # เขียนจริง
 *
 * ปลอดภัยเมื่อรันซ้ำ: บัญชีที่ชื่อถูกต้องแล้วจะถูกข้าม และจะไม่เขียนอะไรเลย
 * ถ้าตรวจพบชื่อปลายทางซ้ำกันเอง หรือชนกับผู้ใช้อื่นที่ไม่ใช่เจ้าของชื่อนั้น
 */
import { PrismaClient, Role } from '@prisma/client';
import { buildDefaultSchoolAdminUsername } from '../src/school-admins/school-admins.service';

const prisma = new PrismaClient();

async function main() {
  const apply = process.env.APPLY === '1';

  const admins = await prisma.user.findMany({
    where: { role: Role.SCHOOL_ADMIN, schoolId: { not: null } },
    select: {
      id: true,
      username: true,
      fullName: true,
      school: { select: { code: true, name: true } },
    },
    orderBy: { username: 'asc' },
  });

  const planned: { id: string; from: string; to: string; code: string }[] = [];
  const unchanged: string[] = [];

  for (const admin of admins) {
    const code = admin.school?.code ?? '';
    const target = buildDefaultSchoolAdminUsername(code);
    if (target === admin.username) {
      unchanged.push(admin.username);
      continue;
    }
    planned.push({ id: admin.id, from: admin.username, to: target, code });
  }

  // ชื่อปลายทางต้องไม่ซ้ำกันเอง
  const seen = new Map<string, string>();
  for (const p of planned) {
    const dup = seen.get(p.to);
    if (dup) {
      throw new Error(`ชื่อปลายทางซ้ำกัน: '${p.to}' มาจากทั้ง '${dup}' และ '${p.from}'`);
    }
    seen.set(p.to, p.from);
  }

  // ชื่อปลายทางต้องไม่ชนกับผู้ใช้อื่นที่ไม่อยู่ในแผน
  const plannedIds = new Set(planned.map((p) => p.id));
  for (const p of planned) {
    const taken = await prisma.user.findUnique({
      where: { username: p.to },
      select: { id: true, username: true, role: true },
    });
    if (taken && !plannedIds.has(taken.id)) {
      throw new Error(`ชื่อ '${p.to}' ถูกใช้โดยผู้ใช้อื่นแล้ว (role ${taken.role})`);
    }
  }

  console.log(`ผู้ดูแลโรงเรียนทั้งหมด ${admins.length} บัญชี`);
  console.log(`ชื่อถูกต้องอยู่แล้ว ${unchanged.length} บัญชี`);
  console.log(`ต้องเปลี่ยนชื่อ ${planned.length} บัญชี`);
  for (const p of planned) {
    console.log(`  ${p.from}  ->  ${p.to}   [${p.code}]`);
  }

  if (!apply) {
    console.log('\n(ยังไม่เขียนจริง — ใส่ APPLY=1 เพื่อบันทึก)');
    return;
  }

  if (planned.length === 0) {
    console.log('\nไม่มีอะไรต้องเปลี่ยน');
    return;
  }

  // เปลี่ยนทั้งชุดในทรานแซกชันเดียว ถ้าพลาดกลางทางจะไม่เหลือชื่อครึ่ง ๆ กลาง ๆ
  await prisma.$transaction(
    planned.map((p) =>
      prisma.user.update({ where: { id: p.id }, data: { username: p.to } }),
    ),
  );

  console.log(`\nเปลี่ยนชื่อเรียบร้อย ${planned.length} บัญชี`);
}

main()
  .catch((err) => {
    console.error('ล้มเหลว:', err instanceof Error ? err.message : err);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
