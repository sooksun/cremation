import { Injectable } from '@nestjs/common';
import { NOT_VOIDED } from '../common/receipt-filter';
import {
  AssociationMemberStatus,
  MemberStatus,
  MembershipEndReason,
  Prisma,
} from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { SchoolScopeService, ScopedUser } from '../common/security/school-scope.service';

const MONTHS = Array.from({ length: 12 }, (_, i) => i + 1);

const toNumber = (v: Prisma.Decimal | number | null | undefined) => Number(v ?? 0);

@Injectable()
export class DashboardsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly schoolScope: SchoolScopeService,
  ) {}

  /** ภาพรวมสมาชิก / ประเภทสมาชิก / โรงเรียน */
  async getMembersDashboard(schoolId?: string, actor?: ScopedUser) {
    const scopedSchoolId = actor
      ? this.schoolScope.resolveSchoolId(actor, schoolId)
      : schoolId;
    const memberWhere: Prisma.MemberWhereInput = scopedSchoolId
      ? { schoolId: scopedSchoolId }
      : {};
    const amWhere: Prisma.AssociationMemberWhereInput = scopedSchoolId
      ? { schoolId: scopedSchoolId }
      : {};

    const now = new Date();
    const startOfYear = new Date(now.getFullYear(), 0, 1);
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

    const [
      totalAssociation,
      totalCremation,
      byStatus,
      byClass,
      byMemberType,
      associationByStatus,
      byEndReason,
      joinedThisYear,
      joinedThisMonth,
      endedThisYear,
      withoutGroup,
      withoutBeneficiary,
      missingIdCard,
      missingBirthDate,
      missingPhone,
      schools,
      clusters,
    ] = await Promise.all([
      this.prisma.associationMember.count({ where: amWhere }),
      this.prisma.member.count({ where: memberWhere }),
      this.prisma.member.groupBy({ by: ['status'], where: memberWhere, _count: true }),
      this.prisma.member.groupBy({ by: ['membershipClass'], where: memberWhere, _count: true }),
      this.prisma.associationMember.groupBy({
        by: ['memberTypeId'],
        where: amWhere,
        _count: true,
      }),
      this.prisma.associationMember.groupBy({ by: ['status'], where: amWhere, _count: true }),
      this.prisma.associationMember.groupBy({
        by: ['membershipEndReason'],
        where: { ...amWhere, status: AssociationMemberStatus.ENDED },
        _count: true,
      }),
      this.prisma.member.count({ where: { ...memberWhere, joinDate: { gte: startOfYear } } }),
      this.prisma.member.count({ where: { ...memberWhere, joinDate: { gte: startOfMonth } } }),
      this.prisma.associationMember.count({
        where: { ...amWhere, membershipEndDate: { gte: startOfYear } },
      }),
      this.prisma.member.count({ where: { ...memberWhere, groupId: null } }),
      this.prisma.member.count({ where: { ...memberWhere, beneficiaries: { none: {} } } }),
      this.prisma.associationMember.count({ where: { ...amWhere, idCardNo: null } }),
      this.prisma.associationMember.count({ where: { ...amWhere, birthDate: null } }),
      this.prisma.associationMember.count({ where: { ...amWhere, phone: null } }),
      this.prisma.school.findMany({
        where: {
          isActive: true,
          ...(scopedSchoolId ? { id: scopedSchoolId } : {}),
          associationMembers: { some: {} },
        },
        select: {
          id: true,
          name: true,
          cluster: { select: { id: true, name: true } },
          _count: { select: { associationMembers: true, members: true, groups: true } },
        },
      }),
      this.prisma.schoolCluster.findMany({
        select: {
          id: true,
          name: true,
          schools: { select: { _count: { select: { associationMembers: true } } } },
        },
      }),
    ]);

    const memberTypes = await this.prisma.memberType.findMany({
      where: { id: { in: byMemberType.map((t) => t.memberTypeId) } },
      select: { id: true, code: true, name: true },
    });
    const typeNameById = new Map(memberTypes.map((t) => [t.id, t]));

    const countOf = <T extends string>(
      rows: Array<{ _count: number } & Record<string, unknown>>,
      key: string,
      value: T,
    ) => rows.find((r) => r[key] === value)?._count ?? 0;

    return {
      summary: {
        associationMembers: totalAssociation,
        cremationMembers: totalCremation,
        // สมาชิกสมาคมที่ยังไม่ได้เข้าฌาปนกิจ — ไม่ใช่ทุกคนที่สมัคร
        notInCremationFund: totalAssociation - totalCremation,
        joinedThisYear,
        joinedThisMonth,
        endedThisYear,
        activeSchools: schools.length,
      },
      byStatus: (Object.values(MemberStatus) as MemberStatus[]).map((status) => ({
        status,
        count: countOf(byStatus, 'status', status),
      })),
      byMembershipClass: byClass.map((c) => ({
        membershipClass: c.membershipClass,
        count: c._count,
      })),
      byMemberType: byMemberType
        .map((t) => ({
          memberTypeId: t.memberTypeId,
          code: typeNameById.get(t.memberTypeId)?.code ?? '-',
          name: typeNameById.get(t.memberTypeId)?.name ?? 'ไม่ระบุ',
          count: t._count,
        }))
        .sort((a, b) => b.count - a.count),
      associationStatus: {
        active: countOf(associationByStatus, 'status', AssociationMemberStatus.ACTIVE),
        ended: countOf(associationByStatus, 'status', AssociationMemberStatus.ENDED),
        byReason: byEndReason
          .filter((r) => r.membershipEndReason)
          .map((r) => ({
            reason: r.membershipEndReason as MembershipEndReason,
            count: r._count,
          }))
          .sort((a, b) => b.count - a.count),
      },
      // ช่องโหว่ข้อมูลที่ทำให้ทำงานจริงไม่ได้ — ไม่มีผู้รับเงินก็จ่ายค่าฌาปนกิจไม่ได้
      dataGaps: {
        withoutGroup,
        withoutBeneficiary,
        missingIdCard,
        missingBirthDate,
        missingPhone,
      },
      bySchool: schools
        .map((s) => ({
          schoolId: s.id,
          name: s.name,
          clusterName: s.cluster?.name ?? null,
          associationMembers: s._count.associationMembers,
          cremationMembers: s._count.members,
          groups: s._count.groups,
        }))
        .sort((a, b) => b.associationMembers - a.associationMembers),
      byCluster: clusters
        .map((c) => ({
          clusterId: c.id,
          name: c.name,
          schools: c.schools.length,
          members: c.schools.reduce((sum, s) => sum + s._count.associationMembers, 0),
        }))
        .sort((a, b) => b.members - a.members),
    };
  }

  /** ภาพรวมการเงิน — เงินเข้า/ออก/สะสม รายเดือน และรายคน */
  async getFinanceDashboard(year: number, schoolId?: string, actor?: ScopedUser) {
    const scopedSchoolId = actor
      ? this.schoolScope.resolveSchoolId(actor, schoolId)
      : schoolId;
    const schoolFilter = scopedSchoolId ? { schoolId: scopedSchoolId } : {};

    const yearStart = new Date(year, 0, 1);
    const nextYearStart = new Date(year + 1, 0, 1);
    const inYear = { gte: yearStart, lt: nextYearStart };

    const [
      receiptsByMonth,
      paymentsByMonth,
      openingReceipts,
      openingPayments,
      receiptsByType,
      paymentsByType,
      periods,
      bankAccounts,
    ] = await Promise.all([
      this.prisma.receipt.groupBy({
        by: ['date'],
        where: { ...schoolFilter, ...NOT_VOIDED, date: inYear },
        _sum: { amount: true },
      }),
      this.prisma.paymentVoucher.groupBy({
        by: ['date'],
        where: { ...schoolFilter, date: inYear },
        _sum: { amount: true },
      }),
      // ยอดยกมา = เงินเข้า-ออกทั้งหมดก่อนต้นปี เพื่อให้ยอดสะสมต่อเนื่องข้ามปี
      this.prisma.receipt.aggregate({
        where: { ...schoolFilter, ...NOT_VOIDED, date: { lt: yearStart } },
        _sum: { amount: true },
      }),
      this.prisma.paymentVoucher.aggregate({
        where: { ...schoolFilter, date: { lt: yearStart } },
        _sum: { amount: true },
      }),
      this.prisma.receipt.groupBy({
        by: ['type'],
        where: { ...schoolFilter, ...NOT_VOIDED, date: inYear },
        _sum: { amount: true },
        _count: true,
      }),
      this.prisma.paymentVoucher.groupBy({
        by: ['type'],
        where: { ...schoolFilter, date: inYear },
        _sum: { amount: true },
        _count: true,
      }),
      this.prisma.contributionPeriod.findMany({
        where: { year },
        orderBy: { month: 'asc' },
        select: { id: true, year: true, month: true, welfareRate: true, serviceFee: true, isClosed: true },
      }),
      this.prisma.bankAccount.findMany({
        where: { isActive: true },
        select: { id: true, bankName: true, accountNo: true, accountName: true },
      }),
    ]);

    const sumByMonth = (
      rows: Array<{ date: Date; _sum: { amount: Prisma.Decimal | null } }>,
    ) => {
      const acc = new Map<number, number>();
      for (const r of rows) {
        const m = r.date.getMonth() + 1;
        acc.set(m, (acc.get(m) ?? 0) + toNumber(r._sum.amount));
      }
      return acc;
    };

    const inflowByMonth = sumByMonth(receiptsByMonth);
    const outflowByMonth = sumByMonth(paymentsByMonth);

    const opening = toNumber(openingReceipts._sum.amount) - toNumber(openingPayments._sum.amount);
    let running = opening;
    const monthly = MONTHS.map((month) => {
      const inflow = inflowByMonth.get(month) ?? 0;
      const outflow = outflowByMonth.get(month) ?? 0;
      running += inflow - outflow;
      return { month, inflow, outflow, net: inflow - outflow, accumulated: running };
    });

    const totalInflow = monthly.reduce((s, m) => s + m.inflow, 0);
    const totalOutflow = monthly.reduce((s, m) => s + m.outflow, 0);

    // สถานะเก็บเงินรายงวด — ต้องเก็บเท่าไร เก็บได้แล้วเท่าไร ค้างเท่าไร
    const periodStatus = await Promise.all(
      periods.map(async (p) => {
        const agg = await this.prisma.memberContribution.aggregate({
          where: { periodId: p.id, ...schoolFilter },
          _sum: { totalAmount: true, paidAmount: true },
          _count: true,
        });
        const unpaid = await this.prisma.memberContribution.count({
          where: { periodId: p.id, ...schoolFilter, paidAmount: { lte: 0 } },
        });
        const due = toNumber(agg._sum.totalAmount);
        const paid = toNumber(agg._sum.paidAmount);
        return {
          periodId: p.id,
          year: p.year,
          month: p.month,
          welfareRate: toNumber(p.welfareRate),
          isClosed: p.isClosed,
          members: agg._count,
          due,
          paid,
          outstanding: due - paid,
          unpaidMembers: unpaid,
        };
      }),
    );

    // รายคน: ใครค้างมากสุด
    const arrearsRows = await this.prisma.memberContribution.groupBy({
      by: ['memberId'],
      where: { ...schoolFilter, period: { year } },
      _sum: { totalAmount: true, paidAmount: true },
      _count: true,
    });
    const outstandingByMember = arrearsRows
      .map((r) => ({
        memberId: r.memberId,
        periods: r._count,
        due: toNumber(r._sum.totalAmount),
        paid: toNumber(r._sum.paidAmount),
        outstanding: toNumber(r._sum.totalAmount) - toNumber(r._sum.paidAmount),
      }))
      .filter((r) => r.outstanding > 0)
      .sort((a, b) => b.outstanding - a.outstanding)
      .slice(0, 20);

    const memberRows = outstandingByMember.length
      ? await this.prisma.member.findMany({
          where: { id: { in: outstandingByMember.map((m) => m.memberId) } },
          select: {
            id: true,
            memberNo: true,
            school: { select: { name: true } },
            group: { select: { name: true } },
            associationMember: { select: { firstName: true, lastName: true } },
          },
        })
      : [];
    const memberById = new Map(memberRows.map((m) => [m.id, m]));

    return {
      year,
      openingBalance: opening,
      summary: {
        totalInflow,
        totalOutflow,
        net: totalInflow - totalOutflow,
        closingBalance: opening + totalInflow - totalOutflow,
      },
      monthly,
      byReceiptType: receiptsByType
        .map((r) => ({ type: r.type, count: r._count, amount: toNumber(r._sum.amount) }))
        .sort((a, b) => b.amount - a.amount),
      byPaymentType: paymentsByType
        .map((r) => ({ type: r.type, count: r._count, amount: toNumber(r._sum.amount) }))
        .sort((a, b) => b.amount - a.amount),
      periodStatus,
      topOutstandingMembers: outstandingByMember.map((r) => {
        const m = memberById.get(r.memberId);
        return {
          memberId: r.memberId,
          memberNo: m?.memberNo ?? '-',
          fullName: m
            ? `${m.associationMember.firstName} ${m.associationMember.lastName}`
            : 'ไม่พบข้อมูล',
          schoolName: m?.school.name ?? '-',
          groupName: m?.group?.name ?? null,
          periods: r.periods,
          due: r.due,
          paid: r.paid,
          outstanding: r.outstanding,
        };
      }),
      bankAccounts,
    };
  }
}
