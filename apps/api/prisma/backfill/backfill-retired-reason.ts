import { PrismaClient, MemberStatus, MembershipEndReason } from '@prisma/client';

// Backfill: ครูเกษียณ (RET) ที่ลาออก/เกษียณไปก่อนหน้านี้ถูกบันทึก membershipEndReason
// เป็น RESIGNED (หรือ null) เพราะ bug — set ให้เป็น RETIRED ตามระเบียบ ข้อ 9.1.3
//
// รัน (dry-run): cd apps/api && npx ts-node --project tsconfig.json prisma/backfill/backfill-retired-reason.ts
// รันจริง:       ... prisma/backfill/backfill-retired-reason.ts --apply
const APPLY = process.argv.includes('--apply');

async function main() {
  const prisma = new PrismaClient();
  try {
    const retResigned = await prisma.member.findMany({
      where: {
        status: MemberStatus.RESIGNED,
        associationMember: { memberType: { code: 'RET' } },
      },
      select: { id: true, memberNo: true, membershipEndReason: true },
    });

    const needFix = retResigned.filter(
      (m) => m.membershipEndReason !== MembershipEndReason.RETIRED,
    );

    console.log(
      `พบ RET + RESIGNED ทั้งหมด ${retResigned.length} ราย — ต้องแก้เป็น RETIRED ${needFix.length} ราย`,
    );
    needFix.forEach((m) =>
      console.log(`  ${m.memberNo}: ${m.membershipEndReason ?? 'null'} -> RETIRED`),
    );

    if (needFix.length === 0) {
      console.log('ไม่มีรายการต้องแก้');
      return;
    }
    if (!APPLY) {
      console.log('\nDRY-RUN — ใส่ --apply เพื่อเขียนจริง');
      return;
    }

    const res = await prisma.member.updateMany({
      where: { id: { in: needFix.map((m) => m.id) } },
      data: { membershipEndReason: MembershipEndReason.RETIRED },
    });
    console.log(`\nอัปเดตแล้ว ${res.count} ราย`);
  } finally {
    await prisma.$disconnect();
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
