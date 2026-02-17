import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { MemberStatus } from '@prisma/client';

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
            firstName: true,
            lastName: true,
            group: true,
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
          select: { id: true, memberNo: true, firstName: true, lastName: true },
        },
        school: true,
        payment: true,
      },
      orderBy: { reportedDate: 'asc' },
    });

    const summary = {
      totalClaims: claims.length,
      paid: claims.filter((c) => c.payment).length,
      unpaid: claims.filter((c) => !c.payment).length,
      totalNetToPay: claims.reduce((sum, c) => sum + Number(c.netToPay), 0),
      totalPaid: claims
        .filter((c) => c.payment)
        .reduce((sum, c) => sum + Number(c.payment!.amount), 0),
    };

    return { summary, claims };
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
          byType: {
            member: 0, // ไม่มีข้อมูลประเภทใน schema ปัจจุบัน
            parent: 0,
            child: 0,
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
      where: { payment: null },
      include: { member: true, school: true },
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
        welfareRate: 20, // อัตราพื้นฐาน 20 บาท/คน
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
  async getMemberProfile(memberId: string) {
    const member = await this.prisma.member.findUnique({
      where: { id: memberId },
      include: {
        school: true,
        memberType: true,
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

    return {
      member: {
        id: member.id,
        memberNo: member.memberNo,
        fullName: `${member.firstName} ${member.lastName}`,
        firstName: member.firstName,
        lastName: member.lastName,
        idCardNo: member.idCardNo,
        phone: member.phone,
        address: member.address,
        birthDate: member.birthDate,
        joinDate: member.joinDate,
        status: member.status,
        school: member.school,
        memberType: member.memberType,
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
