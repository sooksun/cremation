import { PrismaClient } from '@prisma/client';
import { readAllSources } from './sources';
import { ensureUnknownSchool, buildCodeToSchoolId } from './school-map';
import { buildMemberRecords } from './build-records';
import { cleanupMemberData } from './cleanup';

const JOIN_DATE = new Date('2026-01-01T00:00:00.000Z');

async function main() {
  const prisma = new PrismaClient();
  try {
    console.log('=== อ่านไฟล์ต้นทาง ===');
    const s = readAllSources();
    console.log({ f1: s.f1.length, f2: s.f2ById.size, f3: s.f3IdToCode.size, f4sheets: s.f4SheetNames.length });

    console.log('=== เตรียม school map ===');
    const unknownSchoolId = await ensureUnknownSchool(prisma);
    const codeToSchool = await buildCodeToSchoolId(prisma, s);
    console.log({ mappedCodes: codeToSchool.size, unknownSchoolId });

    console.log('=== build member records ===');
    const { records, stats } = buildMemberRecords(s, codeToSchool, unknownSchoolId);
    console.log('build stats:', stats);
    if (records.length !== 603) throw new Error(`คาดหวัง 603 records ได้ ${records.length}`);
    if (stats.duplicateIdCards.length) console.warn('⚠️ idCard ซ้ำใน F1:', stats.duplicateIdCards);

    // memberType code → id
    const types = await prisma.memberType.findMany({ select: { id: true, code: true } });
    const typeId = new Map(types.map((t) => [t.code, t.id]));
    if (!typeId.has('REG') || !typeId.has('PERM')) throw new Error('ขาด MemberType REG/PERM — รัน prisma db seed ก่อน');

    console.log('=== ล้างข้อมูลเดิม ===');
    const clean = await cleanupMemberData(prisma);
    console.log('cleanup before:', clean.before);
    console.log('cleanup after :', clean.after);

    console.log('=== insert 603 สมาชิก ===');
    let inserted = 0;
    for (const r of records) {
      await prisma.$transaction(async (tx) => {
        const am = await tx.associationMember.create({
          data: {
            schoolId: r.schoolId,
            memberTypeId: typeId.get(r.memberTypeCode)!,
            firstName: r.firstName,
            lastName: r.lastName,
            idCardNo: r.idCard,
            phone: r.phone,
            position: r.position,
            notes: r.notes,
          },
        });
        await tx.member.create({
          data: {
            associationMemberId: am.id,
            memberNo: r.memberNo,
            schoolId: r.schoolId,
            joinDate: JOIN_DATE,
            status: 'ACTIVE',
            salaryDeduction: r.salaryDeduction,
          },
        });
      });
      inserted++;
    }
    console.log(`inserted ${inserted}`);

    console.log('=== validate ===');
    const [mCount, amCount] = [await prisma.member.count(), await prisma.associationMember.count()];
    const distinctNo = await prisma.$queryRawUnsafe<{ n: bigint }[]>('SELECT COUNT(DISTINCT memberNo) AS n FROM `Member`');
    const nullId = await prisma.associationMember.count({ where: { idCardNo: null } });
    const byType = await prisma.associationMember.groupBy({ by: ['memberTypeId'], _count: true });
    const bySchool = await prisma.member.groupBy({ by: ['schoolId'], _count: true });
    console.log({ mCount, amCount, distinctMemberNo: Number(distinctNo[0].n), nullIdCard: nullId, schools: bySchool.length });

    // assertions
    const errs: string[] = [];
    if (mCount !== 603) errs.push(`Member count ${mCount} ≠ 603`);
    if (amCount !== 603) errs.push(`AssociationMember count ${amCount} ≠ 603`);
    if (Number(distinctNo[0].n) !== 603) errs.push(`distinct memberNo ${Number(distinctNo[0].n)} ≠ 603`);
    if (nullId !== 0) errs.push(`มี idCardNo null ${nullId} รายการ`);
    if (errs.length) throw new Error('validation ล้มเหลว:\n' + errs.join('\n'));

    console.log('✅ import สำเร็จ: 603 สมาชิก, memberNo ไม่ซ้ำ, idCard ครบ');
    console.log('byType:', byType.map((t) => ({ type: [...typeId].find(([, id]) => id === t.memberTypeId)?.[0], n: t._count })));
  } finally {
    await prisma.$disconnect();
  }
}

main().catch((e) => { console.error(e); process.exit(1); });
