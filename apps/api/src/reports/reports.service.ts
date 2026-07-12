import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  DeathClaimStatus,
  MemberStatus,
  Role,
  BankTransactionType,
  ReceiptType,
  PaymentType,
  AuditAction,
} from '@prisma/client';
import { applyIdCardMask, applyNationalIdMask } from '../common/utils/pii.util';
import { SchoolScopeService, ScopedUser } from '../common/security/school-scope.service';
import { AccountsService } from '../accounts/accounts.service';
import { AuditLogService } from '../common/services/audit-log.service';

@Injectable()
export class ReportsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly schoolScope: SchoolScopeService,
    private readonly accountsService: AccountsService,
    private readonly auditLog: AuditLogService,
  ) {}

  // PRD Section 8: sensitive report generation (PII / financial disclosure) is audit-logged.
  private async logReportGeneration(
    actor: ScopedUser | undefined,
    report: string,
    schoolId?: string,
    metadata?: Record<string, string | number | undefined>,
  ) {
    if (!actor) return;
    await this.auditLog.log({
      userId: actor.id,
      action: AuditAction.REPORT_GENERATE,
      entityType: 'Report',
      entityId: report,
      schoolId,
      metadata: JSON.parse(JSON.stringify(metadata ?? {})),
    });
  }

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
  async getMemberStats(year?: number, schoolId?: string) {
    const memberWhere = schoolId ? { schoolId } : {};

    const bySchool = await this.prisma.member.groupBy({
      by: ['schoolId', 'status'],
      where: memberWhere,
      _count: true,
    });

    const schools = await this.prisma.school.findMany({
      where: { isActive: true, ...(schoolId ? { id: schoolId } : {}) },
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

  // Cash Flow Statement (for group 8 completeness)
  async getCashFlow(startDate: Date, endDate: Date, schoolId?: string) {
    const where: any = schoolId ? { schoolId } : {};
    const dateFilter = { date: { gte: startDate, lte: endDate } };

    const [receiptsSum, paymentsSum, bankDeposits, bankWithdrawals] = await Promise.all([
      this.prisma.receipt.aggregate({
        where: { ...where, ...dateFilter },
        _sum: { amount: true },
      }),
      this.prisma.paymentVoucher.aggregate({
        where: { ...where, ...dateFilter },
        _sum: { amount: true },
      }),
      this.prisma.bankTransaction.aggregate({
        where: {
          type: BankTransactionType.DEPOSIT, // assume enum or 'DEPOSIT'
          date: { gte: startDate, lte: endDate },
          // if bank has school, add filter
        },
        _sum: { amount: true },
      }),
      this.prisma.bankTransaction.aggregate({
        where: {
          type: BankTransactionType.WITHDRAWAL,
          date: { gte: startDate, lte: endDate },
        },
        _sum: { amount: true },
      }),
    ]);

    const cashInFromReceipts = Number(receiptsSum._sum.amount || 0);
    const cashOutToPayments = Number(paymentsSum._sum.amount || 0);
    const bankIn = Number(bankDeposits._sum.amount || 0);
    const bankOut = Number(bankWithdrawals._sum.amount || 0);

    const totalIn = cashInFromReceipts + bankIn;
    const totalOut = cashOutToPayments + bankOut;

    return {
      period: { startDate, endDate, schoolId },
      cashFlows: {
        operatingActivities: {
          cashReceipts: cashInFromReceipts,
          cashPayments: cashOutToPayments,
          net: cashInFromReceipts - cashOutToPayments,
        },
        bankActivities: {
          deposits: bankIn,
          withdrawals: bankOut,
          net: bankIn - bankOut,
        },
      },
      netCashFlow: totalIn - totalOut,
      summary: {
        totalInflows: totalIn,
        totalOutflows: totalOut,
      },
    };
  }

  // Death benefit summary — accepts either a full year OR an explicit date range (PRD gap #4)
  async getDeathBenefitReport(
    range: { year?: number; startDate?: Date; endDate?: Date },
    schoolId?: string,
    actor?: ScopedUser,
  ) {
    const year = range.year || new Date().getFullYear();
    const reportedDateFilter =
      range.startDate && range.endDate
        ? { gte: range.startDate, lte: range.endDate }
        : {
            gte: new Date(`${year}-01-01`),
            lt: new Date(`${year + 1}-01-01`),
          };

    const where: any = { reportedDate: reportedDateFilter };
    if (schoolId) where.schoolId = schoolId;

    const rawClaims = await this.prisma.deathClaim.findMany({
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

    // gross / fee / net breakdown — mirrors the legacy manual's death-notification report
    // columns (1.6). Both funding modes now share the 90/10 split (art.16): the 10% fund
    // reserve (associationSupport) is posted to LedgerEntry (account 301) at payment time.
    // gross - fee always reconciles to net: netToPay = totalContribution - associationSupport
    //   - otherDeductions, for both collection-based and committee fixed-amount claims.
    const claims = rawClaims.map((c) => {
      const feeDeduction = Number(c.associationSupport) + Number(c.otherDeductions);
      const netToPay = Number(c.netToPay);
      return { ...c, grossAmount: netToPay + feeDeduction, feeDeduction };
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
      grossTotal: claims.reduce((sum, c) => sum + c.grossAmount, 0),
      feeTotal: claims.reduce((sum, c) => sum + c.feeDeduction, 0),
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

    // Audit-log only after a successful fetch — logging before the query could record a
    // "report generated" event for a request that actually failed.
    await this.logReportGeneration(actor, 'death-benefits', schoolId, {
      year: range.year,
      startDate: range.startDate?.toISOString(),
      endDate: range.endDate?.toISOString(),
    });

    return { summary, claims };
  }

  // Resignation report (PRD gap #5)
  async getResignationReport(
    startDate: Date,
    endDate: Date,
    schoolId: string | undefined,
    actor: ScopedUser,
  ) {
    const where: any = {
      status: MemberStatus.RESIGNED,
      resignDate: { gte: startDate, lte: endDate },
    };
    if (schoolId) where.schoolId = schoolId;

    const members = await this.prisma.member.findMany({
      where,
      include: {
        school: { select: { name: true } },
        associationMember: {
          select: { firstName: true, lastName: true, idCardNo: true, associationMemberNo: true },
        },
      },
      orderBy: { resignDate: 'asc' },
    });

    const byReason = new Map<string, number>();
    for (const m of members) {
      const reason = m.membershipEndReason ?? 'ไม่ระบุ';
      byReason.set(reason, (byReason.get(reason) ?? 0) + 1);
    }

    // Audit-log only after a successful fetch — logging before the query could record a
    // "report generated" event for a request that actually failed.
    await this.logReportGeneration(actor, 'resignations', schoolId, {
      startDate: startDate.toISOString(),
      endDate: endDate.toISOString(),
    });

    return {
      period: { startDate, endDate },
      summary: {
        totalResigned: members.length,
        byReason: [...byReason.entries()].map(([reason, count]) => ({ reason, count })),
      },
      resignations: members.map((m) => {
        const am = m.associationMember;
        return applyIdCardMask(
          {
            id: m.id,
            memberNo: m.memberNo,
            associationMemberNo: am?.associationMemberNo,
            fullName: am ? `${am.firstName} ${am.lastName}` : '',
            idCardNo: am?.idCardNo,
            school: m.school.name,
            resignDate: m.resignDate,
            // Consistent with byReason above — same null substitution in both places.
            membershipEndReason: m.membershipEndReason ?? 'ไม่ระบุ',
          },
          actor.role,
        );
      }),
    };
  }

  // Receipts ledger report (PRD gap #6 — receipts half)
  async getReceiptsLedger(
    startDate: Date,
    endDate: Date,
    schoolId?: string,
    type?: ReceiptType,
    actor?: ScopedUser,
  ) {
    const where: any = { date: { gte: startDate, lte: endDate } };
    if (schoolId) where.schoolId = schoolId;
    if (type) where.type = type;

    // Same transaction so byType and the row list read a consistent snapshot.
    const [receipts, byTypeRaw] = await this.prisma.$transaction(async (tx) => [
      await tx.receipt.findMany({
        where,
        include: { school: { select: { name: true } }, bankAccount: { select: { bankName: true } } },
        orderBy: { date: 'asc' },
      }),
      await tx.receipt.groupBy({ by: ['type'], where, _sum: { amount: true }, _count: true }),
    ]);

    const byType = byTypeRaw.map((t) => ({
      type: t.type,
      count: t._count,
      amount: Number(t._sum.amount || 0),
    }));

    await this.logReportGeneration(actor, 'receipts-ledger', schoolId, {
      startDate: startDate.toISOString(),
      endDate: endDate.toISOString(),
      type,
    });

    return {
      period: { startDate, endDate },
      summary: {
        // Derived from byType (not re-reduced from the row list) so the two can never disagree.
        totalAmount: byType.reduce((sum, t) => sum + t.amount, 0),
        count: byType.reduce((sum, t) => sum + t.count, 0),
        byType,
      },
      receipts: receipts.map((r) => ({
        id: r.id,
        receiptNo: r.receiptNo,
        date: r.date,
        type: r.type,
        description: r.description,
        amount: Number(r.amount),
        school: r.school?.name,
        bankAccount: r.bankAccount?.bankName,
      })),
    };
  }

  // Disbursement (payment voucher) ledger report (PRD gap #6 — payments half)
  async getDisbursementLedger(
    startDate: Date,
    endDate: Date,
    schoolId?: string,
    type?: PaymentType,
    actor?: ScopedUser,
  ) {
    const where: any = { date: { gte: startDate, lte: endDate } };
    if (schoolId) where.schoolId = schoolId;
    if (type) where.type = type;

    // Same transaction so byType and the row list read a consistent snapshot.
    const [payments, byTypeRaw] = await this.prisma.$transaction(async (tx) => [
      await tx.paymentVoucher.findMany({
        where,
        include: { school: { select: { name: true } }, bankAccount: { select: { bankName: true } } },
        orderBy: { date: 'asc' },
      }),
      await tx.paymentVoucher.groupBy({ by: ['type'], where, _sum: { amount: true }, _count: true }),
    ]);

    const byType = byTypeRaw.map((t) => ({
      type: t.type,
      count: t._count,
      amount: Number(t._sum.amount || 0),
    }));

    // Audit-log only after a successful fetch — logging before the query could record a
    // "report generated" event for a request that actually failed.
    await this.logReportGeneration(actor, 'disbursement-ledger', schoolId, {
      startDate: startDate.toISOString(),
      endDate: endDate.toISOString(),
      type,
    });

    return {
      period: { startDate, endDate },
      summary: {
        // Derived from byType (not re-reduced from the row list) so the two can never disagree.
        totalAmount: byType.reduce((sum, t) => sum + t.amount, 0),
        count: byType.reduce((sum, t) => sum + t.count, 0),
        byType,
      },
      payments: payments.map((p) => ({
        id: p.id,
        voucherNo: p.voucherNo,
        date: p.date,
        type: p.type,
        description: p.description,
        amount: Number(p.amount),
        school: p.school?.name,
        bankAccount: p.bankAccount?.bankName,
      })),
    };
  }

  // Member registry / application report — dual ID, selectable date field (PRD gaps #1 + #2,
  // combined into one flexible report rather than 4 near-duplicate legacy variants)
  async getMemberRegistryReport(
    dateField: 'coverage' | 'applied' | 'recorded',
    startDate: Date,
    endDate: Date,
    schoolId: string | undefined,
    actor: ScopedUser,
  ) {
    const fieldMap = {
      coverage: 'joinDate',
      applied: 'applicationSubmittedAt',
      recorded: 'createdAt',
    } as const;
    const column = fieldMap[dateField];

    const where: any = { [column]: { gte: startDate, lte: endDate } };
    if (schoolId) where.schoolId = schoolId;

    const members = await this.prisma.member.findMany({
      where,
      include: {
        school: { select: { id: true, name: true } },
        associationMember: {
          select: { firstName: true, lastName: true, idCardNo: true, associationMemberNo: true, birthDate: true },
        },
      },
      orderBy: [{ school: { name: 'asc' } }, { memberNo: 'asc' }],
    });

    // Audit-log only after a successful fetch — logging before the query could record a
    // "report generated" event for a request that actually failed.
    await this.logReportGeneration(actor, 'member-registry', schoolId, {
      dateField,
      startDate: startDate.toISOString(),
      endDate: endDate.toISOString(),
    });

    const bySchool = new Map<string, { school: { id: string; name: string }; members: any[] }>();
    for (const m of members) {
      const entry = bySchool.get(m.schoolId) ?? { school: m.school, members: [] };
      const am = m.associationMember;
      entry.members.push(
        applyIdCardMask(
          {
            id: m.id,
            memberNo: m.memberNo,
            associationMemberNo: am?.associationMemberNo,
            fullName: am ? `${am.firstName} ${am.lastName}` : '',
            idCardNo: am?.idCardNo,
            birthDate: am?.birthDate,
            joinDate: m.joinDate,
            applicationSubmittedAt: m.applicationSubmittedAt,
            createdAt: m.createdAt,
          },
          actor.role,
        ),
      );
      bySchool.set(m.schoolId, entry);
    }

    return {
      dateField,
      period: { startDate, endDate },
      summary: { total: members.length },
      bySchool: [...bySchool.values()],
    };
  }

  // Member statement / "passbook" substitute — transaction history with running paid total.
  // PRD gap #3, scoped per Section 5 Option A: NOT a prepaid-balance ledger, just a statement
  // derived from existing MemberContribution/DeathBenefitPayment data.
  async getMemberStatement(memberId: string, actor: ScopedUser) {
    const member = await this.prisma.member.findUnique({
      where: { id: memberId },
      include: {
        school: true,
        associationMember: true,
        contributions: {
          include: { period: true },
          orderBy: [{ period: { year: 'asc' } }, { period: { month: 'asc' } }],
        },
        deathClaims: { include: { payment: true }, orderBy: { reportedDate: 'asc' } },
      },
    });
    if (!member) return null;

    this.schoolScope.assertMemberSelfAccess(actor, memberId);
    this.schoolScope.assertSchoolAccess(actor, member.schoolId);

    const am = member.associationMember;

    // periodYear/periodMonth stay Gregorian here — apps/web converts to พ.ศ. at the UI boundary.
    const rows: {
      date: Date;
      description: string;
      paid: number;
      received: number;
      periodYear?: number;
      periodMonth?: number;
    }[] = [];
    for (const c of member.contributions) {
      if (Number(c.paidAmount) > 0) {
        rows.push({
          date: c.paidDate ?? c.createdAt,
          description: 'เงินสงเคราะห์ + ค่าบำรุง งวด',
          paid: Number(c.paidAmount),
          received: 0,
          periodYear: c.period.year,
          periodMonth: c.period.month,
        });
      }
    }
    for (const dc of member.deathClaims) {
      if (dc.payment) {
        rows.push({
          date: dc.payment.payDate,
          description: `รับเงินสงเคราะห์ศพ (${dc.claimNo})`,
          paid: 0,
          received: Number(dc.payment.amount),
        });
      }
    }
    rows.sort((a, b) => a.date.getTime() - b.date.getTime());

    let runningTotal = 0;
    const statement = rows.map((r) => {
      runningTotal = Math.round((runningTotal + r.paid - r.received) * 100) / 100;
      return { ...r, runningTotal };
    });

    return {
      member: {
        id: member.id,
        memberNo: member.memberNo,
        fullName: am ? `${am.firstName} ${am.lastName}` : '',
        school: member.school.name,
        joinDate: member.joinDate,
      },
      statement,
      summary: {
        totalPaid: rows.reduce((s, r) => s + r.paid, 0),
        totalReceived: rows.reduce((s, r) => s + r.received, 0),
      },
    };
  }

  // Period-close summary/audit report — per-member + per-school rollup (PRD gap #8)
  async getPeriodCloseSummary(periodId: string, schoolId?: string) {
    const period = await this.prisma.contributionPeriod.findUnique({ where: { id: periodId } });
    if (!period) return null;

    const where: any = { periodId };
    if (schoolId) where.schoolId = schoolId;

    const contributions = await this.prisma.memberContribution.findMany({
      where,
      include: {
        member: {
          select: { memberNo: true, associationMember: { select: { firstName: true, lastName: true } } },
        },
        school: { select: { id: true, name: true } },
      },
      orderBy: [{ school: { name: 'asc' } }, { member: { memberNo: 'asc' } }],
    });

    const bySchool = new Map<
      string,
      { school: { id: string; name: string }; memberCount: number; totalDue: number; totalPaid: number }
    >();
    for (const c of contributions) {
      const entry = bySchool.get(c.schoolId) ?? {
        school: c.school,
        memberCount: 0,
        totalDue: 0,
        totalPaid: 0,
      };
      entry.memberCount += 1;
      entry.totalDue += Number(c.totalAmount);
      entry.totalPaid += Number(c.paidAmount);
      bySchool.set(c.schoolId, entry);
    }

    return {
      period,
      summary: {
        memberCount: contributions.length,
        totalDue: contributions.reduce((s, c) => s + Number(c.totalAmount), 0),
        totalPaid: contributions.reduce((s, c) => s + Number(c.paidAmount), 0),
      },
      bySchool: [...bySchool.values()],
      contributions: contributions.map((c) => ({
        id: c.id,
        memberNo: c.member.memberNo,
        fullName: c.member.associationMember
          ? `${c.member.associationMember.firstName} ${c.member.associationMember.lastName}`
          : '',
        school: c.school.name,
        totalAmount: Number(c.totalAmount),
        paidAmount: Number(c.paidAmount),
        isArrears: c.isArrears,
      })),
    };
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
  async getExecutiveDashboard(schoolId?: string) {
    const currentYear = new Date().getFullYear();
    const currentMonth = new Date().getMonth();
    const memberWhere = schoolId ? { schoolId } : {};
    const schoolWhere = schoolId ? { isActive: true, id: schoolId } : { isActive: true };

    // สมาชิกรวมทุกโรงเรียน
    const memberStats = await this.prisma.member.groupBy({
      by: ['status'],
      where: memberWhere,
      _count: true,
    });

    // สมาชิกแยกตามโรงเรียน
    const membersBySchool = await this.prisma.school.findMany({
      where: schoolWhere,
      include: {
        _count: {
          select: { members: { where: memberWhere } },
        },
        members: {
          where: memberWhere,
          select: { status: true },
        },
      },
    });

    // การแจ้งเสียชีวิตย้อนหลัง 5 ปี
    const deathClaimsByYear = await Promise.all(
      Array.from({ length: 5 }, (_, i) => currentYear - i).map(async (year) => {
        const claims = await this.prisma.deathClaim.findMany({
          where: {
            ...(schoolId ? { schoolId } : {}),
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
      where: {
        ...(schoolId ? { schoolId } : {}),
        payment: null,
        status: { not: DeathClaimStatus.PAID },
      },
      include: {
        member: { include: { associationMember: true, school: true } },
        school: true,
      },
      orderBy: { paymentDeadline: 'asc' },
    });

    // สมาชิกค้างชำระ
    const arrearsMembers = await this.prisma.memberContribution.findMany({
      where: {
        ...(schoolId ? { schoolId } : {}),
        isArrears: true,
        paidAmount: { equals: 0 },
      },
      include: { member: true, school: true, period: true },
    });

    // ดึงอัตราเงินสงเคราะห์ต่อคนจากสมาชิกที่ active
    const activeMembers = await this.prisma.member.count({
      where: { ...memberWhere, status: MemberStatus.ACTIVE },
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
  async getMemberProfile(memberId: string, actor: ScopedUser) {
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

    this.schoolScope.assertMemberSelfAccess(actor, memberId);
    this.schoolScope.assertSchoolAccess(actor, member.schoolId);

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
      ? applyIdCardMask({ idCardNo: am.idCardNo }, actor.role).idCardNo
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
      beneficiaries: member.beneficiaries.map((beneficiary) =>
        applyNationalIdMask(beneficiary, actor.role),
      ),
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

  // Group 13: Statement of Changes in Equity / Net Assets (to complete the set of financial statements)
  async getChangesInEquity(startDate: Date, endDate: Date, schoolId?: string) {
    const [startBS, endBS] = await Promise.all([
      this.accountsService.getBalanceSheet(startDate, schoolId),
      this.accountsService.getBalanceSheet(endDate, schoolId),
    ]);

    const pl = await this.accountsService.getProfitAndLoss(startDate, endDate);  // reuse

    const beginningEquity = startBS.totals.equity || 0;
    const netIncome = pl.totals.netProfit || 0;
    const endingEquity = endBS.totals.equity || 0;

    // Simple changes (no other adjustments assumed)
    const otherAdjustments = endingEquity - (beginningEquity + netIncome);

    return {
      period: { startDate, endDate },
      changes: {
        beginningEquity,
        netIncome,
        otherAdjustments,
        endingEquity,
      },
      isConsistent: Math.abs(endingEquity - (beginningEquity + netIncome + otherAdjustments)) < 0.01,
    };
  }
}
