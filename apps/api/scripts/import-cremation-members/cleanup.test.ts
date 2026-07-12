import assert from 'node:assert';
import { PrismaClient } from '@prisma/client';
import { cleanupMemberData } from './cleanup';

// หมายเหตุ: test นี้ลบข้อมูลจริง — รันหลัง backup (Task 6 Step 1) เท่านั้น
(async () => {
  const prisma = new PrismaClient();
  try {
    const { before, after } = await cleanupMemberData(prisma);
    console.log('cleanup before:', before);
    console.log('cleanup after :', after);
    for (const [t, n] of Object.entries(after)) assert.strictEqual(n, 0, `${t} should be 0, got ${n}`);
    console.log('cleanup: all target tables empty');
  } finally {
    await prisma.$disconnect();
  }
})();
