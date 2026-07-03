import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { MembersService } from '../members/members.service';
import { MembershipRulesService } from '../members/membership-rules.service';
import { CreatePeriodDto, UpdatePeriodDto } from './dto/period.dto';
import { RecordPaymentDto } from './dto/payment.dto';
import { Decimal } from '@prisma/client/runtime/library';
import { AuditAction, MemberStatus, ReceiptType } from '@prisma/client';
import { DocumentNumberService, DocumentType } from '../common/document-number.service';
import { BankAccountsService } from '../bank-accounts/bank-accounts.service';
import { SchoolScopeService, ScopedUser } from '../common/security/school-scope.service';
import { AuditLogService } from '../common/services/audit-log.service';
import { AppSettingsService } from '../common/services/app-settings.service';

export interface PaidBySchoolSummary {
  schoolId: string;
  schoolName: string;
  schoolCode: string;
  paidCount: number;
  paidAmount: number;
}

@Injectable()
export class ContributionsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly membersService: MembersService,
    private readonly membershipRules: MembershipRulesService,
    private readonly documentNumberService: DocumentNumberService,
    private readonly bankAccountsService: BankAccountsService,
    private readonly schoolScope: SchoolScopeService,
    private readonly auditLog: AuditLogService,
    private readonly appSettings: AppSettingsService,
  ) {}

  async getSettings() {
    const serviceFeeEnabled = await this.appSettings.isServiceFeeEnabled();
    return { serviceFeeEnabled };
  }

  async updateSettings(serviceFeeEnabled: boolean) {
    return this.appSettings.setServiceFeeEnabled(serviceFeeEnabled);
  }

  private async resolvePeriodAmounts(period: { welfareRate: Decimal | number; serviceFee: Decimal | number }) {
    const serviceFeeEnabled = await this.appSettings.isServiceFeeEnabled();
    const welfareRate = Number(period.welfareRate);
    const serviceFee = this.appSettings.effectiveServiceFee(Number(period.serviceFee), serviceFeeEnabled);
    return { welfareRate, serviceFee, totalAmount: welfareRate + serviceFee, serviceFeeEnabled };
  }

  private async getContributionLedgerAccounts() {
    const [cashAccount, bankAccount, welfareRevenue, serviceRevenue] = await Promise.all([
      this.prisma.account.findFirst({ where: { code: '101' } }),
      this.prisma.account.findFirst({ where: { code: '102' } }),
      this.prisma.account.findFirst({ where: { code: '401' } }),
      this.prisma.account.findFirst({ where: { code: '402' } }),
    ]);
    return { cashAccount, bankAccount, welfareRevenue, serviceRevenue };
  }

  private async getDefaultBankAccountId(): Promise<string | undefined> {
    try {
      const defaultBankAccount = await this.bankAccountsService.findDefault();
      if (defaultBankAccount?.id) {
        const verify = await this.prisma.bankAccount.findUnique({
          where: { id: defaultBankAccount.id },
          select: { id: true },
        });
        return verify?.id;
      }
    } catch {}
    return undefined;
  }

  private buildContributionLedgerEntries(params: {
    debitAccountId: string;
    welfareRevenueId: string;
    serviceRevenueId: string;
    paidDate: Date;
    amount: number;
    welfareAmount: number;
    serviceAmount: number;
    receiptId: string;
    memberLabel: string;
  }) {
    const entries = [
      {
        accountId: params.debitAccountId,
        date: params.paidDate,
        description: `รับเงินสงเคราะห์ ${params.memberLabel}`,
        debit: params.amount,
        credit: 0,
        receiptId: params.receiptId,
      },
      {
        accountId: params.welfareRevenueId,
        date: params.paidDate,
        description: `รายได้เงินสงเคราะห์ ${params.memberLabel}`,
        debit: 0,
        credit: params.welfareAmount,
        receiptId: params.receiptId,
      },
    ];

    if (params.serviceAmount > 0) {
      entries.push({
        accountId: params.serviceRevenueId,
        date: params.paidDate,
        description: `รายได้ค่าบริการ ${params.memberLabel}`,
        debit: 0,
        credit: params.serviceAmount,
        receiptId: params.receiptId,
      });
    }

    // Double-entry validation inside builder
    const totalDebit = entries.reduce((s, e) => s + Number(e.debit || 0), 0);
    const totalCredit = entries.reduce((s, e) => s + Number(e.credit || 0), 0);
    if (Math.abs(totalDebit - totalCredit) > 0.01) {
      throw new Error(`Double-entry violation in contribution ledger: Debit ${totalDebit} != Credit ${totalCredit}`);
    }

    return entries;
  }

  // Period Management
  async createPeriod(dto: CreatePeriodDto) {
    const existing = await this.prisma.contributionPeriod.findUnique({
      where: { year_month: { year: dto.year, month: dto.month } },
    });

    if (existing) {
      throw new BadRequestException('งวดนี้มีอยู่แล้ว');
    }

    return this.prisma.contributionPeriod.create({
      data: {
        year: dto.year,
        month: dto.month,
        welfareRate: dto.welfareRate,
        serviceFee: dto.serviceFee ?? 0,
      },
    });
  }

  async findAllPeriods(year?: number) {
    return this.prisma.contributionPeriod.findMany({
      where: year ? { year } : undefined,
      include: {
        _count: { select: { contributions: true } },
      },
      orderBy: [{ year: 'desc' }, { month: 'desc' }],
    });
  }

  async findPeriodById(id: string) {
    const period = await this.prisma.contributionPeriod.findUnique({
      where: { id },
    });

    if (!period) {
      throw new NotFoundException('ไม่พบงวด');
    }

    return period;
  }

  private assertPeriodOpen(period: { isClosed: boolean }, action: string) {
    if (period.isClosed) {
      throw new BadRequestException(`งวดนี้ปิดแล้ว ไม่สามารถ${action}ได้`);
    }
  }

  async updatePeriod(id: string, dto: UpdatePeriodDto) {
    const period = await this.findPeriodById(id);
    this.assertPeriodOpen(period, 'แก้ไขงวด');
    return this.prisma.contributionPeriod.update({
      where: { id },
      data: dto,
    });
  }

  async closePeriod(id: string, actor?: ScopedUser) {
    const period = await this.findPeriodById(id);
    const updated = await this.prisma.contributionPeriod.update({
      where: { id },
      data: { isClosed: true },
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.CONTRIBUTION_PERIOD_CLOSE,
        entityType: 'ContributionPeriod',
        entityId: id,
        schoolId: period ? undefined : undefined, // periods are global? but filter by school in practice
        metadata: { year: period.year, month: period.month },
      });
    }

    return updated;
  }

  // Generate contributions for all active members
  async generateContributions(periodId: string, schoolId?: string) {
    const period = await this.findPeriodById(periodId);

    if (period.isClosed) {
      throw new BadRequestException('งวดนี้ปิดแล้ว ไม่สามารถสร้างรายการได้');
    }

    const where: any = {
      status: { in: [MemberStatus.ACTIVE, MemberStatus.ARREARS] },
    };
    if (schoolId) where.schoolId = schoolId;

    const activeMembers = await this.prisma.member.findMany({ where });

    const { welfareRate, serviceFee, totalAmount } = await this.resolvePeriodAmounts(period);

    // Create contributions for each member
    const results = await Promise.all(
      activeMembers.map(async (member) => {
        const existing = await this.prisma.memberContribution.findUnique({
          where: { memberId_periodId: { memberId: member.id, periodId } },
        });

        if (existing) return null;

        return this.prisma.memberContribution.create({
          data: {
            memberId: member.id,
            periodId,
            schoolId: member.schoolId,
            welfareAmount: welfareRate,
            serviceAmount: serviceFee,
            totalAmount,
          },
        });
      }),
    );

    const created = results.filter(Boolean).length;
    return { message: `สร้างรายการเงินสงเคราะห์ ${created} รายการ`, created };
  }

  // Get contributions for a period
  async getContributionsByPeriod(periodId: string, schoolId?: string) {
    const where: any = { periodId };
    if (schoolId) where.schoolId = schoolId;

    return this.prisma.memberContribution.findMany({
      where,
      include: {
        member: {
          select: {
            id: true,
            memberNo: true,
            group: true,
            associationMember: { select: { firstName: true, lastName: true, phone: true } },
          },
        },
        school: true,
        receipt: true,
      },
      orderBy: [{ school: { name: 'asc' } }, { member: { memberNo: 'asc' } }],
    });
  }

  // Record payment for a contribution
  async recordPayment(
    id: string,
    dto: RecordPaymentDto,
    actor?: ScopedUser,
    ipAddress?: string,
  ) {
    const contribution = await this.prisma.memberContribution.findUnique({
      where: { id },
      include: {
        period: true,
        member: { select: { groupId: true } },
      },
    });

    if (!contribution) {
      throw new NotFoundException('ไม่พบรายการเงินสงเคราะห์');
    }

    if (contribution.period.isClosed) {
      throw new BadRequestException('งวดนี้ปิดแล้ว ไม่สามารถบันทึกการชำระได้');
    }

    if (actor) {
      this.schoolScope.assertSchoolAccess(actor, contribution.schoolId);
      await this.schoolScope.assertGroupLeaderCanPay(actor, contribution);
    }

    const result = await this.prisma.memberContribution.update({
      where: { id },
      data: {
        paidAmount: dto.amount,
        paidDate: new Date(dto.paidDate),
        receiptId: dto.receiptId,
        isArrears: false,
      },
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.CONTRIBUTION_PAYMENT,
        entityType: 'MemberContribution',
        entityId: id,
        schoolId: contribution.schoolId,
        metadata: { amount: dto.amount, paidDate: dto.paidDate },
        ipAddress,
      });
    }

    if (dto.amount > 0) {
      await this.membershipRules.resetArrearsTracking(contribution.memberId);
    }

    return result;
  }

  // Batch record payments for multiple contributions
  async batchRecordPayments(
    payments: Array<{ contributionId: string; amount: number; paidDate?: string; receiptId?: string }>,
    actor?: ScopedUser,
    ipAddress?: string,
  ) {
    if (!payments || payments.length === 0) {
      throw new BadRequestException('ไม่มีรายการที่ต้องบันทึก');
    }

    const defaultBankAccountId = await this.getDefaultBankAccountId();
    const { cashAccount, bankAccount, welfareRevenue, serviceRevenue } = await this.getContributionLedgerAccounts();

    const results: Array<{ contributionId: string; success: boolean; error?: string }> = [];

    for (const payment of payments) {
      if (!payment.contributionId) {
        results.push({
          contributionId: payment.contributionId || 'unknown',
          success: false,
          error: 'ไม่มี contributionId',
        });
        continue;
      }

      const contribution = await this.prisma.memberContribution.findUnique({
        where: { id: payment.contributionId },
        include: {
          period: true,
          member: { include: { associationMember: true } },
        },
      });

      if (!contribution) {
        results.push({ contributionId: payment.contributionId, success: false, error: 'ไม่พบรายการ' });
        continue;
      }

      if (contribution.period.isClosed) {
        results.push({
          contributionId: payment.contributionId,
          success: false,
          error: `งวด ${contribution.period.month}/${contribution.period.year} ปิดแล้ว กรุณาเปิดงวดก่อนบันทึกการชำระเงิน`,
        });
        continue;
      }

      if (!contribution.member) {
        results.push({ contributionId: payment.contributionId, success: false, error: 'ไม่พบข้อมูลสมาชิก' });
        continue;
      }

      if (actor) {
        try {
          this.schoolScope.assertSchoolAccess(actor, contribution.schoolId);
          await this.schoolScope.assertGroupLeaderCanPay(actor, {
            schoolId: contribution.schoolId,
            member: { groupId: contribution.member.groupId ?? null },
          });
        } catch (err: any) {
          results.push({
            contributionId: payment.contributionId,
            success: false,
            error: err.message || 'ไม่มีสิทธิ์บันทึกการชำระ',
          });
          continue;
        }
      }

      try {
        if (payment.amount === 0 || payment.amount === null || payment.amount === undefined) {
          await this.prisma.memberContribution.update({
            where: { id: payment.contributionId },
            data: {
              paidAmount: 0,
              paidDate: null,
              receiptId: null,
              isArrears: true,
            },
          });
          results.push({ contributionId: payment.contributionId, success: true });
          continue;
        }

        let receiptId = payment.receiptId || contribution.receiptId;
        const paidDate = payment.paidDate ? new Date(payment.paidDate) : new Date();
        const amount = Number(payment.amount);

        if (!receiptId) {
          const receiptNo = await this.documentNumberService.generateNumber(DocumentType.RECEIPT);

          const receiptData: {
            receiptNo: string;
            schoolId: string;
            date: Date;
            type: ReceiptType;
            description: string;
            amount: number;
            bankAccountId?: string;
          } = {
            receiptNo,
            schoolId: contribution.schoolId,
            date: paidDate,
            type: ReceiptType.MEMBER_CONTRIBUTION,
            description: `ชำระเงินสงเคราะห์ประจำเดือน ${contribution.period.month}/${contribution.period.year} - ${contribution.member.associationMember?.firstName ?? ''} ${contribution.member.associationMember?.lastName ?? ''} (${contribution.member.memberNo})`,
            amount,
          };

          if (defaultBankAccountId) {
            receiptData.bankAccountId = defaultBankAccountId;
          }

          const receipt = await this.prisma.receipt.create({ data: receiptData });
          receiptId = receipt.id;

          if (cashAccount && welfareRevenue && serviceRevenue) {
            const welfareAmount = Number(contribution.welfareAmount);
            const serviceAmount = Number(contribution.serviceAmount);
            const memberLabel =
              `${contribution.member.associationMember?.firstName ?? ''} ${contribution.member.associationMember?.lastName ?? ''}`.trim()
              || contribution.member.memberNo;

            await this.prisma.ledgerEntry.createMany({
              data: this.buildContributionLedgerEntries({
                debitAccountId: bankAccount?.id || cashAccount.id,
                welfareRevenueId: welfareRevenue.id,
                serviceRevenueId: serviceRevenue.id,
                paidDate,
                amount,
                welfareAmount,
                serviceAmount,
                receiptId: receipt.id,
                memberLabel,
              }),
            });
          }
        }

        await this.prisma.memberContribution.update({
          where: { id: payment.contributionId },
          data: {
            paidAmount: amount,
            paidDate,
            receiptId: receiptId || null,
            isArrears: false,
          },
        });

        await this.membershipRules.resetArrearsTracking(contribution.memberId);
        results.push({ contributionId: payment.contributionId, success: true });
      } catch (error: any) {
        const errorMessage = error.message || error.code || String(error);
        results.push({
          contributionId: payment.contributionId,
          success: false,
          error: errorMessage,
        });
      }
    }

    const successCount = results.filter((r) => r.success).length;
    const failCount = results.filter((r) => !r.success).length;

    if (actor && successCount > 0) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.BATCH_PAYMENT,
        entityType: 'MemberContribution',
        entityId: 'batch',
        metadata: {
          total: payments.length,
          success: successCount,
          failed: failCount,
        },
        ipAddress,
      });
    }

    return {
      total: payments.length,
      success: successCount,
      failed: failCount,
      results,
    };
  }

  // Get arrears by school/group
  async getArrears(schoolId?: string, periodId?: string, actor?: ScopedUser) {
    const scopedSchoolId = actor
      ? this.schoolScope.resolveSchoolId(actor, schoolId)
      : schoolId;
    const where: any = {
      paidAmount: 0,
      isArrears: true,
    };

    if (scopedSchoolId) where.schoolId = scopedSchoolId;
    if (periodId) where.periodId = periodId;

    return this.prisma.memberContribution.findMany({
      where,
      include: {
        member: {
          select: {
            id: true,
            memberNo: true,
            group: true,
            associationMember: { select: { firstName: true, lastName: true, phone: true } },
          },
        },
        period: true,
        school: true,
      },
      orderBy: [{ period: { year: 'asc' } }, { period: { month: 'asc' } }],
    });
  }

  // Mark unpaid contributions as arrears
  async markArrearsForPeriod(periodId: string, actor?: ScopedUser) {
    const period = await this.findPeriodById(periodId);
    this.assertPeriodOpen(period, 'ทำเครื่องหมายค้างชำระ');
    const scopedSchoolId = actor ? this.schoolScope.resolveSchoolId(actor) : undefined;
    const result = await this.prisma.memberContribution.updateMany({
      where: {
        periodId,
        paidAmount: 0,
        ...(scopedSchoolId ? { schoolId: scopedSchoolId } : {}),
      },
      data: {
        isArrears: true,
      },
    });

    return { message: `ทำเครื่องหมายค้างชำระ ${result.count} รายการ`, count: result.count };
  }

  async sendArrearsNoticeForPeriod(periodId: string, actor?: ScopedUser) {
    const period = await this.findPeriodById(periodId);
    this.assertPeriodOpen(period, 'แจ้งเตือนค้างชำระ');
    const scopedSchoolId = actor ? this.schoolScope.resolveSchoolId(actor) : undefined;
    const arrearsResult = await this.markArrearsForPeriod(periodId, actor);
    const noticeResult = await this.membershipRules.processArrearsAfterNotice(
      periodId,
      scopedSchoolId,
    );
    return {
      message: `แจ้งเตือนค้างชำระ ${noticeResult.noticeSent} ราย, สิ้นสุดสมาชิกภาพ ${noticeResult.terminated} ราย`,
      markedArrears: arrearsResult.count,
      ...noticeResult,
    };
  }

  async getPeriodSummaryBySchool(periodId: string, schoolId?: string) {
    const contributions = await this.prisma.memberContribution.findMany({
      where: {
        periodId,
        ...(schoolId ? { schoolId } : {}),
      },
      include: {
        school: { select: { id: true, name: true, code: true } },
      },
    });

    const bySchool = new Map<
      string,
      {
        schoolId: string;
        schoolName: string;
        schoolCode: string;
        totalMembers: number;
        paidMembers: number;
        unpaidMembers: number;
        totalAmount: number;
        paidAmount: number;
      }
    >();

    for (const row of contributions) {
      const key = row.schoolId;
      const current = bySchool.get(key) ?? {
        schoolId: row.school.id,
        schoolName: row.school.name,
        schoolCode: row.school.code,
        totalMembers: 0,
        paidMembers: 0,
        unpaidMembers: 0,
        totalAmount: 0,
        paidAmount: 0,
      };

      current.totalMembers += 1;
      current.totalAmount += Number(row.totalAmount);
      current.paidAmount += Number(row.paidAmount);

      if (Number(row.paidAmount) > 0) {
        current.paidMembers += 1;
      } else {
        current.unpaidMembers += 1;
      }

      bySchool.set(key, current);
    }

    const schools = Array.from(bySchool.values()).sort((a, b) =>
      a.schoolName.localeCompare(b.schoolName, 'th'),
    );

    return {
      schools,
      totals: {
        totalMembers: schools.reduce((sum, s) => sum + s.totalMembers, 0),
        paidMembers: schools.reduce((sum, s) => sum + s.paidMembers, 0),
        unpaidMembers: schools.reduce((sum, s) => sum + s.unpaidMembers, 0),
        totalAmount: schools.reduce((sum, s) => sum + s.totalAmount, 0),
        paidAmount: schools.reduce((sum, s) => sum + s.paidAmount, 0),
      },
    };
  }

  async payAllContributionsInPeriod(
    periodId: string,
    actor?: ScopedUser,
    ipAddress?: string,
  ) {
    const period = await this.findPeriodById(periodId);
    if (period.isClosed) {
      throw new BadRequestException('งวดนี้ปิดแล้ว ไม่สามารถบันทึกการชำระได้');
    }

    const scopedSchoolId = actor ? this.schoolScope.resolveSchoolId(actor) : undefined;
    const unpaid = await this.prisma.memberContribution.findMany({
      where: {
        periodId,
        paidAmount: 0,
        ...(scopedSchoolId ? { schoolId: scopedSchoolId } : {}),
      },
      include: {
        school: { select: { id: true, name: true, code: true } },
        member: { select: { groupId: true } },
      },
      orderBy: [{ school: { name: 'asc' } }, { member: { memberNo: 'asc' } }],
    });

    if (unpaid.length === 0) {
      throw new BadRequestException('ไม่มีรายการที่ยังไม่ชำระในงวดนี้');
    }

    const paidDate = new Date().toISOString();
    const payments = unpaid.map((row) => ({
      contributionId: row.id,
      amount: Number(row.totalAmount),
      paidDate,
    }));

    const batchResult = await this.batchRecordPayments(payments, actor, ipAddress);

    const successIds = new Set(
      batchResult.results.filter((r) => r.success).map((r) => r.contributionId),
    );

    const paidBySchool: Record<string, PaidBySchoolSummary> = {};

    for (const row of unpaid) {
      if (!successIds.has(row.id)) continue;
      const key = row.schoolId;
      if (!paidBySchool[key]) {
        paidBySchool[key] = {
          schoolId: row.school.id,
          schoolName: row.school.name,
          schoolCode: row.school.code,
          paidCount: 0,
          paidAmount: 0,
        };
      }
      paidBySchool[key].paidCount += 1;
      paidBySchool[key].paidAmount += Number(row.totalAmount);
    }

    const periodSummaryBySchool = await this.getPeriodSummaryBySchool(periodId, scopedSchoolId);

    return {
      message: `บันทึกการชำระ ${batchResult.success} รายการ`,
      batch: batchResult,
      newlyPaidBySchool: Object.values(paidBySchool).sort((a, b) =>
        a.schoolName.localeCompare(b.schoolName, 'th'),
      ) as PaidBySchoolSummary[],
      periodSummaryBySchool,
    };
  }

  // Get summary for a period
  async getPeriodSummary(periodId: string, schoolId?: string) {
    const where: any = { periodId };
    if (schoolId) where.schoolId = schoolId;

    const [totalContributions, paidContributions, totalAmount, paidAmount] = await Promise.all([
      this.prisma.memberContribution.count({ where }),
      this.prisma.memberContribution.count({ where: { ...where, paidAmount: { gt: 0 } } }),
      this.prisma.memberContribution.aggregate({
        where,
        _sum: { totalAmount: true },
      }),
      this.prisma.memberContribution.aggregate({
        where,
        _sum: { paidAmount: true },
      }),
    ]);

    return {
      totalContributions,
      paidContributions,
      unpaidContributions: totalContributions - paidContributions,
      totalAmount: Number(totalAmount._sum.totalAmount || 0),
      paidAmount: Number(paidAmount._sum.paidAmount || 0),
      unpaidAmount:
        Number(totalAmount._sum.totalAmount || 0) - Number(paidAmount._sum.paidAmount || 0),
    };
  }

  // =============================================
  // CONTRIBUTION MATRIX - ตารางการชำระเงินรายเดือน
  // =============================================
  async getContributionMatrix(year: number, schoolId?: string) {
    // Get all periods for the year
    const periods = await this.prisma.contributionPeriod.findMany({
      where: { year },
      orderBy: { month: 'asc' },
    });

    // Get all members (filter by school if provided)
    const memberWhere: any = {
      status: { in: [MemberStatus.ACTIVE, MemberStatus.ARREARS] },
    };
    if (schoolId) memberWhere.schoolId = schoolId;

    const members = await this.prisma.member.findMany({
      where: memberWhere,
      include: {
        school: { select: { id: true, name: true, code: true } },
        associationMember: { include: { memberType: { select: { name: true } } } },
        group: { select: { name: true } },
      },
      orderBy: [{ school: { name: 'asc' } }, { memberNo: 'asc' }],
    });

    // Get all contributions for this year
    const contributions = await this.prisma.memberContribution.findMany({
      where: {
        period: { year },
        ...(schoolId && { schoolId }),
      },
      select: {
        id: true,
        memberId: true,
        periodId: true,
        paidAmount: true,
        paidDate: true,
        totalAmount: true,
        isArrears: true,
      },
    });

    // Create a map for quick lookup
    const contributionMap = new Map<string, typeof contributions[0]>();
    contributions.forEach((c) => {
      contributionMap.set(`${c.memberId}-${c.periodId}`, c);
    });

    // Build matrix data
    const matrixData = members.map((member) => {
      const monthlyData: Record<number, { 
        status: 'paid' | 'unpaid' | 'arrears' | 'none';
        amount?: number;
        paidDate?: string;
        contributionId?: string;
        periodId?: string;
      }> = {};

      let totalPaid = 0;
      let totalUnpaid = 0;

      // Check each month
      for (let month = 1; month <= 12; month++) {
        const period = periods.find((p) => p.month === month);
        if (!period) {
          monthlyData[month] = { status: 'none' };
          continue;
        }

        const contribution = contributionMap.get(`${member.id}-${period.id}`);
        if (!contribution) {
          monthlyData[month] = { 
            status: 'none',
            periodId: period.id,
          };
        } else if (Number(contribution.paidAmount) > 0) {
          monthlyData[month] = {
            status: 'paid',
            amount: Number(contribution.paidAmount),
            paidDate: contribution.paidDate?.toISOString(),
            contributionId: contribution.id,
            periodId: contribution.periodId,
          };
          totalPaid += Number(contribution.paidAmount);
        } else if (contribution.isArrears) {
          monthlyData[month] = {
            status: 'arrears',
            amount: Number(contribution.totalAmount),
            contributionId: contribution.id,
            periodId: contribution.periodId,
          };
          totalUnpaid += Number(contribution.totalAmount);
        } else {
          monthlyData[month] = {
            status: 'unpaid',
            amount: Number(contribution.totalAmount),
            contributionId: contribution.id,
            periodId: contribution.periodId,
          };
          totalUnpaid += Number(contribution.totalAmount);
        }
      }

      return {
        member: {
          id: member.id,
          memberNo: member.memberNo,
          firstName: member.associationMember?.firstName,
          lastName: member.associationMember?.lastName,
          school: member.school,
          memberType: member.associationMember?.memberType?.name,
          group: member.group?.name,
        },
        monthlyData,
        summary: {
          totalPaid,
          totalUnpaid,
          paidMonths: Object.values(monthlyData).filter((m) => m.status === 'paid').length,
          unpaidMonths: Object.values(monthlyData).filter((m) => m.status === 'unpaid' || m.status === 'arrears').length,
        },
      };
    });

    // Calculate summary by school
    const schoolSummary = new Map<string, {
      schoolId: string;
      schoolName: string;
      schoolCode: string;
      totalMembers: number;
      totalPaid: number;
      totalUnpaid: number;
      monthlyStats: Record<number, { paid: number; unpaid: number; total: number }>;
    }>();

    matrixData.forEach((row) => {
      const schoolId = row.member.school.id;
      if (!schoolSummary.has(schoolId)) {
        schoolSummary.set(schoolId, {
          schoolId,
          schoolName: row.member.school.name,
          schoolCode: row.member.school.code,
          totalMembers: 0,
          totalPaid: 0,
          totalUnpaid: 0,
          monthlyStats: {},
        });
        for (let m = 1; m <= 12; m++) {
          schoolSummary.get(schoolId)!.monthlyStats[m] = { paid: 0, unpaid: 0, total: 0 };
        }
      }

      const summary = schoolSummary.get(schoolId)!;
      summary.totalMembers++;
      summary.totalPaid += row.summary.totalPaid;
      summary.totalUnpaid += row.summary.totalUnpaid;

      Object.entries(row.monthlyData).forEach(([month, data]) => {
        const m = parseInt(month);
        if (data.status === 'paid') {
          summary.monthlyStats[m].paid++;
        } else if (data.status === 'unpaid' || data.status === 'arrears') {
          summary.monthlyStats[m].unpaid++;
        }
        if (data.status !== 'none') {
          summary.monthlyStats[m].total++;
        }
      });
    });

    const serviceFeeEnabled = await this.appSettings.isServiceFeeEnabled();

    return {
      year,
      serviceFeeEnabled,
      periods: periods.map((p) => ({
        id: p.id,
        month: p.month,
        welfareRate: Number(p.welfareRate),
        serviceFee: Number(p.serviceFee),
        isClosed: p.isClosed,
      })),
      members: matrixData,
      schoolSummary: Array.from(schoolSummary.values()),
      totalSummary: {
        totalMembers: matrixData.length,
        totalPaid: matrixData.reduce((sum, m) => sum + m.summary.totalPaid, 0),
        totalUnpaid: matrixData.reduce((sum, m) => sum + m.summary.totalUnpaid, 0),
      },
    };
  }

  // Get schools for filter
  async getSchoolsWithContributions(year: number) {
    const schools = await this.prisma.school.findMany({
      where: { isActive: true },
      include: {
        _count: {
          select: {
            members: {
              where: { status: { in: [MemberStatus.ACTIVE, MemberStatus.ARREARS] } },
            },
          },
        },
      },
      orderBy: { name: 'asc' },
    });

    return schools.map((s) => ({
      id: s.id,
      code: s.code,
      name: s.name,
      memberCount: s._count.members,
    }));
  }

  // =============================================
  // EXCEL TEMPLATE & UPLOAD
  // =============================================
  
  /**
   * สร้าง template Excel สำหรับสมาชิกที่หักผ่านเงินเดือน
   */
  async generatePaymentTemplate(year: number, month: number) {
    // หา period
    const period = await this.prisma.contributionPeriod.findUnique({
      where: { year_month: { year, month } },
    });

    if (!period) {
      throw new NotFoundException(`ไม่พบงวดสำหรับเดือน ${month} ปี ${year}`);
    }

    // ดึงสมาชิกที่หักผ่านเงินเดือน (ACTIVE + ARREARS ที่ยังไม่ตัดสมาชิกภาพ)
    const members = await this.prisma.member.findMany({
      where: {
        status: { in: [MemberStatus.ACTIVE, MemberStatus.ARREARS] },
        salaryDeduction: true,
      },
      include: {
        school: { select: { code: true, name: true } },
        associationMember: { include: { memberType: { select: { name: true } } } },
        contributions: {
          where: { periodId: period.id },
          select: { id: true, totalAmount: true, paidAmount: true },
        },
      },
      orderBy: [{ school: { name: 'asc' } }, { memberNo: 'asc' }],
    });

    const { totalAmount: defaultTotalAmount, serviceFeeEnabled } = await this.resolvePeriodAmounts(period);

    const excelData = members.map((member) => {
      const contribution = member.contributions[0];
      return {
        'เลขสมาชิก': member.memberNo,
        'ชื่อ': member.associationMember?.firstName ?? '',
        'นามสกุล': member.associationMember?.lastName ?? '',
        'โรงเรียน': member.school.name,
        'รหัสโรงเรียน': member.school.code,
        'ประเภท': member.associationMember?.memberType?.name ?? '',
        'ยอดที่ต้องชำระ': contribution ? Number(contribution.totalAmount) : defaultTotalAmount,
        'สถานะ': contribution && Number(contribution.paidAmount) > 0 ? 'ชำระแล้ว' : 'ยังไม่ชำระ',
      };
    });

    return {
      serviceFeeEnabled,
      period: {
        id: period.id,
        year: period.year,
        month: period.month,
        welfareRate: Number(period.welfareRate),
        serviceFee: Number(period.serviceFee),
      },
      members: excelData,
      totalMembers: members.length,
    };
  }

  /**
   * ประมวลผล Excel ที่ upload มาและบันทึกการชำระเงิน
   */
  async processPaymentUpload(
    year: number,
    month: number,
    excelData: Array<{
      เลขสมาชิก: string;
      ชื่อ?: string;
      นามสกุล?: string;
      โรงเรียน?: string;
      รหัสโรงเรียน?: string;
      ยอดที่ต้องชำระ?: number;
      สถานะ?: string;
    }>,
    actor?: ScopedUser,
  ) {
    // หา period
    const period = await this.prisma.contributionPeriod.findUnique({
      where: { year_month: { year, month } },
    });

    if (!period) {
      throw new NotFoundException(`ไม่พบงวดสำหรับเดือน ${month} ปี ${year}`);
    }

    this.assertPeriodOpen(period, 'อัปโหลดการชำระเงิน');

    const results = {
      success: 0,
      failed: 0,
      notFound: 0,
      errors: [] as Array<{ memberNo: string; error: string }>,
    };

    // ประมวลผลแต่ละแถว
    for (const row of excelData) {
      try {
        // หาสมาชิกจากเลขสมาชิก
        const member = await this.prisma.member.findFirst({
          where: { memberNo: row.เลขสมาชิก },
          include: {
            associationMember: true,
            contributions: {
              where: { periodId: period.id },
            },
          },
        });

        if (!member) {
          results.notFound++;
          results.errors.push({
            memberNo: row.เลขสมาชิก,
            error: 'ไม่พบสมาชิก',
          });
          continue;
        }

        if (actor) {
          try {
            this.schoolScope.assertSchoolAccess(actor, member.schoolId);
          } catch {
            results.failed++;
            results.errors.push({
              memberNo: row.เลขสมาชิก,
              error: 'ไม่มีสิทธิ์บันทึกการชำระสำหรับโรงเรียนนี้',
            });
            continue;
          }
        }

        // หา contribution
        let contribution = member.contributions[0];

        // ถ้ายังไม่มี contribution ให้สร้างใหม่
        if (!contribution) {
          const { welfareRate, serviceFee, totalAmount } = await this.resolvePeriodAmounts(period);

          contribution = await this.prisma.memberContribution.create({
            data: {
              memberId: member.id,
              periodId: period.id,
              schoolId: member.schoolId,
              welfareAmount: welfareRate,
              serviceAmount: serviceFee,
              totalAmount,
              paidAmount: 0,
            },
          });
        }

        // ถ้า status เป็น "ชำระแล้ว" ให้บันทึกการชำระและสร้างใบเสร็จรับเงิน
        if (row.สถานะ === 'ชำระแล้ว' || row.สถานะ === 'ชำระ' || row.สถานะ === 'paid') {
          const amount = row.ยอดที่ต้องชำระ || Number(contribution.totalAmount);
          const paidDate = contribution.paidDate || new Date();

          // ตรวจสอบว่ามี receiptId อยู่แล้วหรือไม่
          let receiptId = contribution.receiptId;

          // ถ้ายังไม่มี receiptId ให้สร้าง receipt ใหม่
          if (!receiptId) {
            // สร้างใบเสร็จรับเงิน
            const receiptNo = await this.documentNumberService.generateNumber(DocumentType.RECEIPT);
            
            const defaultBankAccountId = await this.getDefaultBankAccountId();
            const { cashAccount, bankAccount, welfareRevenue, serviceRevenue } = await this.getContributionLedgerAccounts();

            // สร้าง receipt - ไม่ส่ง bankAccountId ถ้าไม่มีหรือไม่ถูกต้อง
            const receiptData: {
              receiptNo: string;
              schoolId: string;
              date: Date;
              type: ReceiptType;
              description: string;
              amount: number;
              bankAccountId?: string;
            } = {
              receiptNo,
              schoolId: member.schoolId,
              date: paidDate,
              type: ReceiptType.MEMBER_CONTRIBUTION,
              description: `ชำระเงินสงเคราะห์ประจำเดือน ${month}/${year} - ${member.associationMember?.firstName ?? ''} ${member.associationMember?.lastName ?? ''} (${member.memberNo})`,
              amount: amount,
            };

            // เพิ่ม bankAccountId เฉพาะเมื่อมี default bank account และ ID ถูกต้อง
            if (defaultBankAccountId) {
              receiptData.bankAccountId = defaultBankAccountId;
            }

            const receipt = await this.prisma.receipt.create({
              data: receiptData,
            });

            receiptId = receipt.id;

            if (cashAccount && welfareRevenue && serviceRevenue) {
              const debitAccountId = bankAccount?.id || cashAccount.id;
              const welfareAmount = Number(contribution.welfareAmount);
              const serviceAmount = Number(contribution.serviceAmount);
              const memberLabel = `${member.associationMember?.firstName ?? ''} ${member.associationMember?.lastName ?? ''}`.trim()
                || member.memberNo;

              await this.prisma.ledgerEntry.createMany({
                data: this.buildContributionLedgerEntries({
                  debitAccountId,
                  welfareRevenueId: welfareRevenue.id,
                  serviceRevenueId: serviceRevenue.id,
                  paidDate,
                  amount,
                  welfareAmount,
                  serviceAmount,
                  receiptId: receipt.id,
                  memberLabel,
                }),
              });
            }
          }

          // อัปเดต contribution พร้อม receiptId (ถ้ายังไม่มี)
          await this.prisma.memberContribution.update({
            where: { id: contribution.id },
            data: {
              paidAmount: amount,
              paidDate: paidDate,
              receiptId: receiptId,
              isArrears: false,
            },
          });

          results.success++;
        } else {
          // ถ้ายังไม่ชำระ ให้ตั้งเป็น unpaid
          await this.prisma.memberContribution.update({
            where: { id: contribution.id },
            data: {
              paidAmount: 0,
              paidDate: null,
              receiptId: null,
              isArrears: false,
            },
          });

          results.success++;
        }
      } catch (error) {
        results.failed++;
        results.errors.push({
          memberNo: row.เลขสมาชิก,
          error: error instanceof Error ? error.message : String(error),
        });
      }
    }

    return results;
  }

  /**
   * สร้าง receipt สำหรับรายการที่ชำระแล้วแต่ยังไม่มี receiptId (backfill)
   */
  async backfillReceiptsForPaidContributions() {
    const results = {
      success: 0,
      failed: 0,
      errors: [] as Array<{ contributionId: string; error: string }>,
    };

    try {
      // หารายการที่ชำระแล้วแต่ยังไม่มี receiptId
      const paidContributions = await this.prisma.memberContribution.findMany({
        where: {
          paidAmount: { gt: 0 },
          receiptId: null,
          paidDate: { not: null },
        },
        include: {
          member: { include: { associationMember: true } },
          period: true,
        },
      });

      const defaultBankAccountId = await this.getDefaultBankAccountId();
      const { cashAccount, bankAccount, welfareRevenue, serviceRevenue } = await this.getContributionLedgerAccounts();

      for (const contribution of paidContributions) {
        try {
          const amount = Number(contribution.paidAmount);
          const paidDate = contribution.paidDate || new Date();
          const member = contribution.member;
          const period = contribution.period;

          // สร้างใบเสร็จรับเงิน
          const receiptNo = await this.documentNumberService.generateNumber(DocumentType.RECEIPT);

          // สร้าง receipt - ไม่ส่ง bankAccountId ถ้าไม่มีหรือไม่ถูกต้อง
          const receiptData: {
            receiptNo: string;
            schoolId: string;
            date: Date;
            type: ReceiptType;
            description: string;
            amount: number;
            bankAccountId?: string;
          } = {
            receiptNo,
            schoolId: member.schoolId,
            date: paidDate,
            type: ReceiptType.MEMBER_CONTRIBUTION,
            description: `ชำระเงินสงเคราะห์ประจำเดือน ${period.month}/${period.year} - ${member.associationMember?.firstName ?? ''} ${member.associationMember?.lastName ?? ''} (${member.memberNo})`,
            amount: amount,
          };

          // เพิ่ม bankAccountId เฉพาะเมื่อมี default bank account และ ID ถูกต้อง
          if (defaultBankAccountId) {
            receiptData.bankAccountId = defaultBankAccountId;
          }


          const receipt = await this.prisma.receipt.create({
            data: receiptData,
          });

          if (cashAccount && welfareRevenue && serviceRevenue) {
            const debitAccountId = bankAccount?.id || cashAccount.id;
            const welfareAmount = Number(contribution.welfareAmount);
            const serviceAmount = Number(contribution.serviceAmount);
            const memberLabel = `${member.associationMember?.firstName ?? ''} ${member.associationMember?.lastName ?? ''}`.trim()
              || member.memberNo;

            await this.prisma.ledgerEntry.createMany({
              data: this.buildContributionLedgerEntries({
                debitAccountId,
                welfareRevenueId: welfareRevenue.id,
                serviceRevenueId: serviceRevenue.id,
                paidDate,
                amount,
                welfareAmount,
                serviceAmount,
                receiptId: receipt.id,
                memberLabel,
              }),
            });
          }

          await this.prisma.memberContribution.update({
            where: { id: contribution.id },
            data: {
              receiptId: receipt.id,
            },
          });

          results.success++;
        } catch (error) {
          results.failed++;
          results.errors.push({
            contributionId: contribution.id,
            error: error instanceof Error ? error.message : String(error),
          });
        }
      }

      return results;
    } catch (error) {
      throw new BadRequestException(
        `เกิดข้อผิดพลาดในการสร้าง receipt: ${error instanceof Error ? error.message : String(error)}`,
      );
    }
  }
}

