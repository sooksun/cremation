import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { DeathClaimStatus, MemberStatus, Role } from '@prisma/client';
import { applyIdCardMask } from '../common/utils/pii.util';

@Injectable()
export class ReportsService {
  constructor(private readonly prisma: PrismaService) {}

  // Dashboard summary
  async getDashboard(schoolId?: string, year?: number) {
    const where = schoolId ? { schoolId } : {};
    const targetYear = year || new Date().getFullYear();
    const currentMonth = new Date().getMonth();

    const [totalMembers, activeMembers, deceasedMembers, deathClaimsThisYear, receiptsThisMonth, paymentsThisMonth] =
      await Promise.all([
        this.prisma.member.count({ where }),
        this.prisma.member.count({ where: { ...where, status: MemberStatus.ACTIVE } }),
        this.prisma.member.count({ where: { ...where, status: MemberStatus.DECEASED } }),
        this.prisma.deathClaim.count({
          where: {
            ...where,
            reportedDate: {
              gte: new Date(`${targetYear}-01-01`),
              lt: new Date(`${targetYear + 1}-01-01`),
            },
          },
        }),
        this.prisma.receipt.aggregate({
          where: {
            ...where,
            date: {
              gte: new Date(targetYear, currentMonth, 1),
              lt: new Date(targetYear, currentMonth + 1, 1),
            },
          },
          _sum: { amount: true },
          _count: true,
        }),
        this.prisma.paymentVoucher.aggregate({
          where: {
            ...where,
            date: {
              gte: new Date(targetYear, currentMonth, 1),
              lt: new Date(targetYear, currentMonth + 1, 1),
            },
          },
          _sum: { amount: true },
          _count: true,
        }),
      ]);

    return {
      members: {
        total: totalMembers,
        active: activeMembers,
        deceased: deceasedMembers,
        resigned: await this.prisma.member.count({ where: { ...where, status: MemberStatus.RESIGNED } }),
        arrears: await this.prisma.member.count({ where: { ...where, status: MemberStatus.ARREARS } }),
      },
      deathClaims: {
        thisYear: deathClaimsThisYear,
      },
      finance: {
        receiptsThisMonth: {
          count: receiptsThisMonth._count,
          amount: Number(receiptsThisMonth._sum.amount || 0),
        },
        paymentsThisMonth: {
          count: paymentsThisMonth._count,
          amount: Number(paymentsThisMonth._sum.amount || 0),
        },
      },
    };
  }

  // Member statistics by school
  async getMemberStats(year?: number) {
    const joinedFilter = year
      ? { joinDate: { gte: new Date(`${year}-01-01`), lt: new Date(`${year + 1}-01-01`) } }
      : {};

    const bySchool = await this.prisma.member.groupBy({
      by: ['schoolId', 'status'],
      _count: true,
    });

    const schools = await this.prisma.school.findMany({
      where: { isActive: true },
    });

    return schools.map((school) => {
      const schoolStats = bySchool.filter((s) => s.schoolId === school.id);
      return {
        school,
        stats: {
          total: schoolStats.reduce((sum, s) => sum + s._count, 0),
          byStatus: schoolStats.map((s) => ({ status: s.status, count: s._count })),
        },
      };
    });
  }

  // Contribution collection report
  async getContributionReport(periodId: string, schoolId?: string) {
    const where: any = { periodId };
    if (schoolId) where.schoolId = schoolId;

    const contributions = await this.prisma.memberContribution.findMany({
      where,
      include: {
        member: {
          select: {
            id: true,
            memberNo: true,
            group: true,
            associationMember: { select: { firstName: true, lastName: true } },
          },
        },
        school: true,
      },
    });

    const summary = {
      total: contributions.length,
      paid: contributions.filter((c) => Number(c.paidAmount) > 0).length,
      unpaid: contributions.filter((c) => Number(c.paidAmount) === 0).length,
      totalAmount: contributions.reduce((sum, c) => sum + Number(c.totalAmount), 0),
      paidAmount: contributions.reduce((sum, c) => sum + Number(c.paidAmount), 0),
    };

    // Group by school
    const bySchool = contributions.reduce(
      (acc, c) => {
        if (!acc[c.schoolId]) {
          acc[c.schoolId] = {
            school: c.school,
            total: 0,
            paid: 0,
            unpaid: 0,
            totalAmount: 0,
            paidAmount: 0,
          };
        }
        acc[c.schoolId].total++;
        if (Number(c.paidAmount) > 0) {
          acc[c.schoolId].paid++;
          acc[c.schoolId].paidAmount += Number(c.paidAmount);
        } else {
          acc[c.schoolId].unpaid++;
        }
        acc[c.schoolId].totalAmount += Number(c.totalAmount);
        return acc;
      },
      {} as Record<string, any>,
    );

    return {
      summary,
      bySchool: Object.values(bySchool),
      details: contributions,
    };
  }

  // Financial summary report
  async getFinancialSummary(startDate: Date, endDate: Date, schoolId?: string) {
    const where = schoolId ? { schoolId } : {};
    const dateFilter = { date: { gte: startDate, lte: endDate } };

    const [receipts, payments] = await Promise.all([
      this.prisma.receipt.groupBy({
        by: ['type'],
        where: { ...where, ...dateFilter },
        _sum: { amount: true },
        _count: true,
      }),
      this.prisma.paymentVoucher.groupBy({
        by: ['type'],
        where: { ...where, ...dateFilter },
        _sum: { amount: true },
        _count: true,
      }),
    ]);

    const totalReceipts = receipts.reduce((sum, r) => sum + Number(r._sum.amount || 0), 0);
    const totalPayments = payments.reduce((sum, p) => sum + Number(p._sum.amount || 0), 0);

    return {
      period: { startDate, endDate },
      income: {
        byType: receipts.map((r) => ({
          type: r.type,
          count: r._count,
          amount: Number(r._sum.amount || 0),
        })),
        total: totalReceipts,
      },
      expense: {
        byType: payments.map((p) => ({
          type: p.type,
          count: p._count,
          amount: Number(p._sum.amount || 0),
        })),
        total: totalPayments,
      },
      netIncome: totalReceipts - totalPayments,
    };
  }

  async getDailyMovement(date: Date, schoolId?: string) {
    const start = new Date(date);
    start.setHours(0, 0, 0, 0);
    const end = new Date(date);
    end.setHours(23, 59, 59, 999);

    const receiptWhere: any = { date: { gte: start, lte: end } };
    const paymentWhere: any = { date: { gte: start, lte: end } };
    if (schoolId) {
      receiptWhere.schoolId = schoolId;
      paymentWhere.schoolId = schoolId;
    }

    const [receipts, payments, bankTransactions] = await Promise.all([
      this.prisma.receipt.findMany({
        where: receiptWhere,
        include: { school: true, bankAccount: true },
        orderBy: { date: 'asc' },
      }),
      this.prisma.paymentVoucher.findMany({
        where: paymentWhere,
        include: { school: true, bankAccount: true },
        orderBy: { date: 'asc' },
      }),
      this.prisma.bankTransaction.findMany({
        where: { date: { gte: start, lte: end } },
        include: { bankAccount: true },
        orderBy: { date: 'asc' },
      }),
    ]);

    const cashIn =
      receipts.reduce((s, r) => s + Number(r.amount), 0) +
      bankTransactions
        .filter((t) => t.type === 'DEPOSIT')
        .reduce((s, t) => s + Number(t.amount), 0);

    const cashOut =
      payments.reduce((s, p) => s + Number(p.amount), 0) +
      bankTransactions
        .filter((t) => t.type === 'WITHDRAWAL')
        .reduce((s, t) => s + Number(t.amount), 0);

    return {
      date: start,
      receipts: receipts.map((r) => ({
        id: r.id,
        receiptNo: r.receiptNo,
        type: r.type,
        amount: Number(r.amount),
        school: r.school?.name,
        bankAccount: r.bankAccount?.bankName,
      })),
      payments: payments.map((p) => ({
        id: p.id,
        voucherNo: p.voucherNo,
        type: p.type,
        amount: Number(p.amount),
        school: p.school?.name,
        bankAccount: p.bankAccount?.bankName,
      })),
      bankTransactions: bankTransactions.map((t) => ({
        id: t.id,
        transactionNo: t.transactionNo,
        type: t.type,
        amount: Number(t.amount),
        bankAccount: t.bankAccount.bankName,
        description: t.description,
      })),
      summary: {
        cashIn,
        cashOut,
        netMovement: cashIn - cashOut,
        receiptCount: receipts.length,
        paymentCount: payments.length,
        bankTxnCount: bankTransactions.length,
      },
    };
  }

  // Death benefit summary
  async getDeathBenefitReport(year: number, schoolId?: string) {
    const where: any = {
      reportedDate: {
        gte: new Date(`${year}-01-01`),
        lt: new Date(`${year + 1}-01-01`),
      },
    };
    if (schoolId) where.schoolId = schoolId;

    const claims = await this.prisma.deathClaim.findMany({
      where,
      include: {
        member: {
          select: {
            id: true,
            memberNo: true,
            associationMember: { select: { firstName: true, lastName: true } },
          },
        },
        school: true,
        payment: true,
      },
      orderBy: { reportedDate: 'asc' },
    });

    const now = new Date();
    const summary = {
      totalClaims: claims.length,
      paid: claims.filter((c) => c.payment).length,
      unpaid: claims.filter((c) => !c.payment).length,
      totalNetToPay: claims.reduce((sum, c) => sum + Number(c.netToPay), 0),
      totalPaid: claims
        .filter((c) => c.payment)
        .reduce((sum, c) => sum + Number(c.payment!.amount), 0),
      totalFundReserve: claims.reduce((sum, c) => sum + Number(c.associationSupport), 0),
      totalCollected: claims.reduce((sum, c) => sum + Number(c.collectedAmount), 0),
      overdueCollection: claims.filter(
        (c) =>
          !c.payment &&
          ['REPORTED', 'COLLECTING'].includes(c.status) &&
          c.collectionDeadline < now,
      ).length,
      overdueDocuments: claims.filter(
        (c) =>
          !c.payment &&
          !c.documentsComplete &&
          c.documentDeadline < now,
      ).length,
    };

    return { summary, claims };
  }

  async getBoardMonthlyReport(year: number, month: number, schoolId?: string) {
    const startOfMonth = new Date(year, month - 1, 1);
    const endOfMonth = new Date(year, month, 0, 23, 59, 59, 999);
    const memberWhere = schoolId ? { schoolId } : {};
    const now = new Date();

    const [
      totalMembers,
      activeMembers,
      newMembers,
      resignedMembers,
      deceasedMembers,
      arrearsMembers,
      receipts,
      payments,
      deathClaims,
      contributions,
      pendingApproval,
      overdueWorkflow,
    ] = await Promise.all([
      this.prisma.member.count({ where: memberWhere }),
      this.prisma.member.count({ where: { ...memberWhere, status: MemberStatus.ACTIVE } }),
      this.prisma.member.count({
        where: { ...memberWhere, joinDate: { gte: startOfMonth, lte: endOfMonth } },
      }),
      this.prisma.member.count({
        where: {
          ...memberWhere,
          status: MemberStatus.RESIGNED,
          resignDate: { gte: startOfMonth, lte: endOfMonth },
        },
      }),
      this.prisma.member.count({
        where: {
          ...memberWhere,
          status: MemberStatus.DECEASED,
          deathDate: { gte: startOfMonth, lte: endOfMonth },
        },
      }),
      this.prisma.member.count({ where: { ...memberWhere, status: MemberStatus.ARREARS } }),
      this.prisma.receipt.aggregate({
        where: {
          ...(schoolId ? { schoolId } : {}),
          date: { gte: startOfMonth, lte: endOfMonth },
        },
        _sum: { amount: true },
        _count: true,
      }),
      this.prisma.paymentVoucher.aggregate({
        where: {
          ...(schoolId ? { schoolId } : {}),
          date: { gte: startOfMonth, lte: endOfMonth },
        },
        _sum: { amount: true },
        _count: true,
      }),
      this.prisma.deathClaim.findMany({
        where: {
          ...(schoolId ? { schoolId } : {}),
          reportedDate: { gte: startOfMonth, lte: endOfMonth },
        },
        include: {
          member: {
            select: {
              memberNo: true,
              associationMember: { select: { firstName: true, lastName: true } },
            },
          },
          school: { select: { name: true } },
          payment: true,
          approvedBy: { select: { fullName: true } },
        },
        orderBy: { reportedDate: 'asc' },
      }),
      this.prisma.memberContribution.aggregate({
        where: {
          ...(schoolId ? { schoolId } : {}),
          period: { year, month },
        },
        _sum: { totalAmount: true, paidAmount: true },
        _count: true,
      }),
      this.prisma.deathClaim.count({
        where: {
          ...(schoolId ? { schoolId } : {}),
          status: DeathClaimStatus.READY_TO_PAY,
          approvedAt: null,
          payment: null,
        },
      }),
      this.prisma.deathClaim.count({
        where: {
          ...(schoolId ? { schoolId } : {}),
          payment: null,
          status: { not: DeathClaimStatus.PAID },
          OR: [
            { collectionDeadline: { lt: now }, status: { in: [DeathClaimStatus.REPORTED, DeathClaimStatus.COLLECTING] } },
            { documentDeadline: { lt: now }, documentsComplete: false },
          ],
        },
      }),
    ]);

    const receiptTotal = Number(receipts._sum.amount || 0);
    const paymentTotal = Number(payments._sum.amount || 0);
    const fundReserve = deathClaims.reduce((sum, c) => sum + Number(c.associationSupport), 0);

    return {
      period: { year, month, label: `${month}/${year + 543}` },
      members: {
        total: totalMembers,
        active: activeMembers,
        newThisMonth: newMembers,
        resignedThisMonth: resignedMembers,
        deceasedThisMonth: deceasedMembers,
        arrears: arrearsMembers,
      },
      finance: {
        receipts: receiptTotal,
        receiptCount: receipts._count,
        payments: paymentTotal,
        paymentCount: payments._count,
        net: receiptTotal - paymentTotal,
      },
      contributions: {
        totalDue: Number(contributions._sum.totalAmount || 0),
        totalPaid: Number(contributions._sum.paidAmount || 0),
        memberCount: contributions._count,
        collectionRate:
          Number(contributions._sum.totalAmount || 0) > 0
            ? Number(contributions._sum.paidAmount || 0) / Number(contributions._sum.totalAmount || 0)
            : 0,
      },
      deathClaims: {
        count: deathClaims.length,
        fundReserve,
        paid: deathClaims.filter((c) => c.payment).length,
        pending: deathClaims.filter((c) => !c.payment).length,
        pendingApproval,
        overdueWorkflow,
        items: deathClaims.map((c) => ({
          id: c.id,
          claimNo: c.claimNo,
          memberName: c.member.associationMember
            ? `${c.member.associationMember.firstName} ${c.member.associationMember.lastName}`
            : c.member.memberNo,
          schoolName: c.school.name,
          reportedDate: c.reportedDate,
          netToPay: Number(c.netToPay),
          status: c.status,
          approved: !!c.approvedAt,
          approverName: c.approverName,
          paid: !!c.payment,
        })),
      },
      generatedAt: new Date().toISOString(),
    };
  }

  async getDeathFundReserveReport(year: number, schoolId?: string) {
    const where: any = {
      reportedDate: {
        gte: new Date(`${year}-01-01`),
        lt: new Date(`${year + 1}-01-01`),
      },
    };
    if (schoolId) where.schoolId = schoolId;

    const claims = await this.prisma.deathClaim.findMany({
      where,
      select: {
        id: true,
        claimNo: true,
        claimType: true,
        reportedDate: true,
        associationSupport: true,
        totalContribution: true,
        collectedAmount: true,
        status: true,
        school: { select: { id: true, name: true, code: true } },
      },
      orderBy: { reportedDate: 'asc' },
    });

    const bySchool = new Map<
      string,
      { schoolName: string; schoolCode: string; fundReserve: number; claimCount: number }
    >();

    for (const claim of claims) {
      const key = claim.school.id;
      const existing = bySchool.get(key) ?? {
        schoolName: claim.school.name,
        schoolCode: claim.school.code,
        fundReserve: 0,
        claimCount: 0,
      };
      existing.fundReserve += Number(claim.associationSupport);
      existing.claimCount += 1;
      bySchool.set(key, existing);
    }

    return {
      year,
      totalFundReserve: claims.reduce((sum, c) => sum + Number(c.associationSupport), 0),
      totalClaims: claims.length,
      bySchool: [...bySchool.values()].sort((a, b) => b.fundReserve - a.fundReserve),
      claims,
    };
  }

  // =============================================
  // EXECUTIVE DASHBOARD - สำหรับผู้บริหาร/บอร์ด
  // =============================================
  async getExecutiveDashboard() {
    const currentYear = new Date().getFullYear();
    const currentMonth = new Date().getMonth();

    // สมาชิกรวมทุกโรงเรียน
    const memberStats = await this.prisma.member.groupBy({
      by: ['status'],
      _count: true,
    });

    // สมาชิกแยกตามโรงเรียน
    const membersBySchool = await this.prisma.school.findMany({
      where: { isActive: true },
      include: {
        _count: {
          select: { members: true },
        },
        members: {
          select: { status: true },
        },
      },
    });

    // การแจ้งเสียชีวิตย้อนหลัง 5 ปี
    const deathClaimsByYear = await Promise.all(
      Array.from({ length: 5 }, (_, i) => currentYear - i).map(async (year) => {
        const claims = await this.prisma.deathClaim.findMany({
          where: {
            reportedDate: {
              gte: new Date(`${year}-01-01`),
              lt: new Date(`${year + 1}-01-01`),
            },
          },
          include: { payment: true },
        });

        return {
          year,
          totalClaims: claims.length,
          totalPaid: claims.filter(c => c.payment).reduce((sum, c) => sum + Number(c.netToPay), 0),
          fundReserve: claims.reduce((sum, c) => sum + Number(c.associationSupport), 0),
          byType: {
            member: claims.filter((c) => c.deceasedType === 'MEMBER').length,
            parent: claims.filter((c) => c.deceasedType === 'PARENT').length,
            child: claims.filter((c) => c.deceasedType === 'CHILD').length,
            spouse: claims.filter((c) => c.deceasedType === 'SPOUSE').length,
          },
        };
      }),
    );

    // รายรับ-รายจ่ายย้อนหลัง 12 เดือน
    const monthlyFinance = await Promise.all(
      Array.from({ length: 12 }, (_, i) => {
        const date = new Date();
        date.setMonth(currentMonth - i);
        return date;
      }).map(async (date) => {
        const startOfMonth = new Date(date.getFullYear(), date.getMonth(), 1);
        const endOfMonth = new Date(date.getFullYear(), date.getMonth() + 1, 0);

        const [receipts, payments] = await Promise.all([
          this.prisma.receipt.aggregate({
            where: { date: { gte: startOfMonth, lte: endOfMonth } },
            _sum: { amount: true },
            _count: true,
          }),
          this.prisma.paymentVoucher.aggregate({
            where: { date: { gte: startOfMonth, lte: endOfMonth } },
            _sum: { amount: true },
            _count: true,
          }),
        ]);

        return {
          month: date.getMonth() + 1,
          year: date.getFullYear(),
          receipts: Number(receipts._sum.amount || 0),
          payments: Number(payments._sum.amount || 0),
          net: Number(receipts._sum.amount || 0) - Number(payments._sum.amount || 0),
        };
      }),
    );

    // เงินค้างจ่าย
    const pendingPayments = await this.prisma.deathClaim.findMany({
      where: { payment: null, status: { not: DeathClaimStatus.PAID } },
      include: {
        member: { include: { associationMember: true, school: true } },
        school: true,
      },
      orderBy: { paymentDeadline: 'asc' },
    });

    // สมาชิกค้างชำระ
    const arrearsMembers = await this.prisma.memberContribution.findMany({
      where: { isArrears: true, paidAmount: { equals: 0 } },
      include: { member: true, school: true, period: true },
    });

    // ดึงอัตราเงินสงเคราะห์ต่อคนจากสมาชิกที่ active
    const activeMembers = await this.prisma.member.count({
      where: { status: MemberStatus.ACTIVE },
    });

    return {
      summary: {
        totalMembers: memberStats.reduce((sum, s) => sum + s._count, 0),
        activeMembers: memberStats.find(s => s.status === 'ACTIVE')?._count || 0,
        deathClaimsThisYear: deathClaimsByYear[0]?.totalClaims || 0,
        pendingPayments: pendingPayments.length,
        pendingPaymentAmount: pendingPayments.reduce((sum, p) => sum + Number(p.netToPay), 0),
        welfareRate: 100,
        fundReserveThisYear: deathClaimsByYear[0]?.fundReserve || 0,
        pendingApproval: pendingPayments.filter((p) => p.status === DeathClaimStatus.READY_TO_PAY && !p.approvedAt).length,
        arrearsCount: arrearsMembers.length,
      },
      membersByStatus: memberStats.map(s => ({
        status: s.status,
        count: s._count,
      })),
      membersBySchool: membersBySchool.map(school => ({
        id: school.id,
        name: school.name,
        total: school._count.members,
        active: school.members.filter(m => m.status === 'ACTIVE').length,
        arrears: school.members.filter(m => m.status === 'ARREARS').length,
        deceased: school.members.filter(m => m.status === 'DECEASED').length,
      })),
      deathClaimsTrend: deathClaimsByYear.reverse(),
      monthlyFinance: monthlyFinance.reverse(),
      pendingPayments: pendingPayments.slice(0, 10),
    };
  }

  // =============================================
  // FINANCE DASHBOARD - สำหรับเจ้าหน้าที่บัญชี
  // =============================================
  async getFinanceDashboard(year: number, schoolId?: string) {
    const where = schoolId ? { schoolId } : {};
    const dateFilter = {
      date: {
        gte: new Date(`${year}-01-01`),
        lt: new Date(`${year + 1}-01-01`),
      },
    };

    // รายรับตามประเภท
    const receiptsByType = await this.prisma.receipt.groupBy({
      by: ['type'],
      where: { ...where, ...dateFilter },
      _sum: { amount: true },
      _count: true,
    });

    // รายจ่ายตามประเภท
    const paymentsByType = await this.prisma.paymentVoucher.groupBy({
      by: ['type'],
      where: { ...where, ...dateFilter },
      _sum: { amount: true },
      _count: true,
    });

    // รายรับรายเดือน
    const monthlyReceipts = await Promise.all(
      Array.from({ length: 12 }, (_, i) => i + 1).map(async (month) => {
        const startOfMonth = new Date(year, month - 1, 1);
        const endOfMonth = new Date(year, month, 0);

        const result = await this.prisma.receipt.aggregate({
          where: { ...where, date: { gte: startOfMonth, lte: endOfMonth } },
          _sum: { amount: true },
        });

        return { month, amount: Number(result._sum.amount || 0) };
      }),
    );

    // รายจ่ายรายเดือน
    const monthlyPayments = await Promise.all(
      Array.from({ length: 12 }, (_, i) => i + 1).map(async (month) => {
        const startOfMonth = new Date(year, month - 1, 1);
        const endOfMonth = new Date(year, month, 0);

        const result = await this.prisma.paymentVoucher.aggregate({
          where: { ...where, date: { gte: startOfMonth, lte: endOfMonth } },
          _sum: { amount: true },
        });

        return { month, amount: Number(result._sum.amount || 0) };
      }),
    );

    // การเก็บเงินสงเคราะห์
    const contributionStats = await this.prisma.memberContribution.groupBy({
      by: ['periodId'],
      where: {
        ...where,
        period: { year },
      },
      _sum: { totalAmount: true, paidAmount: true },
      _count: true,
    });

    const periods = await this.prisma.contributionPeriod.findMany({
      where: { year },
      orderBy: { month: 'asc' },
    });

    // ยอดเงินคงเหลือในบัญชีธนาคาร (กองทุนกลาง - ไม่กรองตาม schoolId)
    const bankAccounts = await this.prisma.bankAccount.findMany({
      where: { isActive: true },
    });

    // เงินสงเคราะห์ศพที่จ่ายไปปีนี้
    const deathBenefitsPaid = await this.prisma.deathBenefitPayment.aggregate({
      where: {
        payDate: {
          gte: new Date(`${year}-01-01`),
          lt: new Date(`${year + 1}-01-01`),
        },
        ...(schoolId ? { deathClaim: { schoolId } } : {}),
      },
      _sum: { amount: true },
      _count: true,
    });

    const totalReceipts = receiptsByType.reduce((sum, r) => sum + Number(r._sum.amount || 0), 0);
    const totalPayments = paymentsByType.reduce((sum, p) => sum + Number(p._sum.amount || 0), 0);

    return {
      year,
      summary: {
        totalReceipts,
        totalPayments,
        netIncome: totalReceipts - totalPayments,
        deathBenefitsPaid: Number(deathBenefitsPaid._sum.amount || 0),
        deathBenefitsCount: deathBenefitsPaid._count,
      },
      receiptsByType: receiptsByType.map(r => ({
        type: r.type,
        count: r._count,
        amount: Number(r._sum.amount || 0),
      })),
      paymentsByType: paymentsByType.map(p => ({
        type: p.type,
        count: p._count,
        amount: Number(p._sum.amount || 0),
      })),
      monthlyData: Array.from({ length: 12 }, (_, i) => ({
        month: i + 1,
        receipts: monthlyReceipts[i].amount,
        payments: monthlyPayments[i].amount,
        net: monthlyReceipts[i].amount - monthlyPayments[i].amount,
      })),
      contributionsByPeriod: periods.map(p => {
        const stats = contributionStats.find(s => s.periodId === p.id);
        return {
          period: p,
          totalExpected: Number(stats?._sum.totalAmount || 0),
          totalPaid: Number(stats?._sum.paidAmount || 0),
          collectionRate: stats?._sum.totalAmount 
            ? Math.round((Number(stats._sum.paidAmount) / Number(stats._sum.totalAmount)) * 100) 
            : 0,
        };
      }),
      bankAccounts,
    };
  }

  // =============================================
  // MEMBER PROFILE - สำหรับสมาชิกรายบุคคล
  // =============================================
  async getMemberProfile(memberId: string, role: Role) {
    const member = await this.prisma.member.findUnique({
      where: { id: memberId },
      include: {
        school: true,
        associationMember: { include: { memberType: true } },
        group: true,
        beneficiaries: { orderBy: { priority: 'asc' } },
        contributions: {
          include: { period: true, receipt: true },
          orderBy: [{ period: { year: 'desc' } }, { period: { month: 'desc' } }],
        },
        deathClaims: {
          include: { payment: true },
        },
      },
    });

    if (!member) return null;

    const am = member.associationMember;

    // สรุปการชำระเงิน
    const totalContributions = member.contributions.length;
    const paidContributions = member.contributions.filter(c => Number(c.paidAmount) > 0).length;
    const totalPaid = member.contributions.reduce((sum, c) => sum + Number(c.paidAmount), 0);
    const arrears = member.contributions.filter(c => c.isArrears && Number(c.paidAmount) === 0);

    // อายุสมาชิก
    const joinDate = new Date(member.joinDate);
    const now = new Date();
    const membershipYears = Math.floor((now.getTime() - joinDate.getTime()) / (365.25 * 24 * 60 * 60 * 1000));

    // สิทธิประโยชน์ที่เคยได้รับ
    const benefitsReceived = member.deathClaims.filter(c => c.payment);

    const idCardForRole = am
      ? applyIdCardMask({ idCardNo: am.idCardNo }, role).idCardNo
      : undefined;

    return {
      member: {
        id: member.id,
        memberNo: member.memberNo,
        fullName: am ? `${am.firstName} ${am.lastName}` : '',
        firstName: am?.firstName,
        lastName: am?.lastName,
        idCardNo: idCardForRole,
        phone: am?.phone,
        address: am?.address,
        birthDate: am?.birthDate,
        joinDate: member.joinDate,
        status: member.status,
        school: member.school,
        memberType: am?.memberType,
        group: member.group,
      },
      beneficiaries: member.beneficiaries,
      summary: {
        membershipYears,
        totalContributions,
        paidContributions,
        paymentRate: totalContributions > 0 ? Math.round((paidContributions / totalContributions) * 100) : 0,
        totalPaid,
        arrearsCount: arrears.length,
        arrearsAmount: arrears.reduce((sum, c) => sum + Number(c.totalAmount), 0),
        benefitsReceived: benefitsReceived.length,
        totalBenefitsAmount: benefitsReceived.reduce((sum, c) => sum + Number(c.payment!.amount), 0),
      },
      recentContributions: member.contributions.slice(0, 12),
      arrears,
      deathClaims: member.deathClaims,
    };
  }
}
