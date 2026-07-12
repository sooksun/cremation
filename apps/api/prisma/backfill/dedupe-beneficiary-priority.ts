import { PrismaClient } from '@prisma/client';

// Backfill: ผู้รับผลประโยชน์ (Beneficiary) ที่มี priority ซ้ำในสมาชิกเดียวกัน (ข้อมูลเก่า
// ก่อนบังคับ @@unique) — renumber priority ใหม่เป็น 1..n ต่อสมาชิก (ต้องรันก่อน migration unique)
//
// รัน (dry-run): cd apps/api && npx ts-node --project tsconfig.json prisma/backfill/dedupe-beneficiary-priority.ts
// รันจริง:       ... prisma/backfill/dedupe-beneficiary-priority.ts --apply
const APPLY = process.argv.includes('--apply');

async function main() {
  const prisma = new PrismaClient();
  try {
    const groups = await prisma.beneficiary.groupBy({ by: ['memberId'] });
    let affected = 0;

    for (const g of groups) {
      const rows = await prisma.beneficiary.findMany({
        where: { memberId: g.memberId },
        orderBy: [{ priority: 'asc' }, { id: 'asc' }],
      });
      const priorities = rows.map((r) => r.priority);
      if (new Set(priorities).size === priorities.length) continue; // ไม่ซ้ำ ข้าม

      affected++;
      console.log(
        `member ${g.memberId}: priorities [${priorities}] -> [${rows.map((_, i) => i + 1)}]`,
      );
      if (APPLY) {
        for (let i = 0; i < rows.length; i++) {
          if (rows[i].priority !== i + 1) {
            await prisma.beneficiary.update({
              where: { id: rows[i].id },
              data: { priority: i + 1 },
            });
          }
        }
      }
    }

    console.log(
      `\n${affected} สมาชิกมี priority ซ้ำ` +
        (APPLY ? ' (แก้แล้ว)' : ' (DRY-RUN — ใส่ --apply เพื่อแก้จริง ก่อนรัน db push unique)'),
    );
  } finally {
    await prisma.$disconnect();
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
