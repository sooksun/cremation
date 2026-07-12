import { PrismaClient } from '@prisma/client';

// ตารางที่ล้าง (ข้อมูล transactional ของสมาชิก/การเงิน — ทั้งหมดเป็นข้อมูล test)
const DELETE_TABLES = [
  'Beneficiary', 'ProtectedPerson', 'MemberContribution', 'LedgerEntry',
  'DeathBenefitPayment', 'DeathClaim', 'Receipt', 'PaymentVoucher',
  'Member', 'AssociationMember',
];

async function count(prisma: PrismaClient, table: string): Promise<number> {
  const rows = await prisma.$queryRawUnsafe<{ n: bigint }[]>(`SELECT COUNT(*) AS n FROM \`${table}\``);
  return Number(rows[0].n);
}

export async function cleanupMemberData(prisma: PrismaClient) {
  const snapshot = async () => {
    const o: Record<string, number> = {};
    for (const t of DELETE_TABLES) o[t] = await count(prisma, t);
    return o;
  };
  const before = await snapshot();

  await prisma.$transaction(async (tx) => {
    await tx.$executeRawUnsafe('SET FOREIGN_KEY_CHECKS = 0');
    // null-out refs ที่อ้าง Member แต่ไม่ลบตัวเอง
    await tx.$executeRawUnsafe('UPDATE `Group` SET leaderId = NULL');
    await tx.$executeRawUnsafe('UPDATE `User` SET memberId = NULL');
    for (const t of DELETE_TABLES) {
      await tx.$executeRawUnsafe(`DELETE FROM \`${t}\``);
    }
    await tx.$executeRawUnsafe('SET FOREIGN_KEY_CHECKS = 1');
  });

  const after = await snapshot();
  return { before, after };
}
