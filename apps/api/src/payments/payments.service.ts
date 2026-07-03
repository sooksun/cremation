import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { DocumentNumberService, DocumentType } from '../common/document-number.service';
import { CreatePaymentDto } from './dto/create-payment.dto';
import { AuditAction, PaymentType } from '@prisma/client';
import { SchoolScopeService, ScopedUser } from '../common/security/school-scope.service';
import { AuditLogService } from '../common/services/audit-log.service';
import { CashBookService } from '../cash-book/cash-book.service';

@Injectable()
export class PaymentsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly documentNumberService: DocumentNumberService,
    private readonly auditLog: AuditLogService,
    private readonly schoolScope: SchoolScopeService,
    private readonly cashBook: CashBookService,
  ) {}

  async create(dto: CreatePaymentDto, actor?: ScopedUser, ipAddress?: string) {
    if (actor && dto.schoolId) {
      this.schoolScope.assertSchoolAccess(actor, dto.schoolId);
    }

    const voucherNo = await this.documentNumberService.generateNumber(DocumentType.PAYMENT_VOUCHER);

    const payment = await this.prisma.paymentVoucher.create({
      data: {
        voucherNo,
        schoolId: dto.schoolId || null,
        date: new Date(dto.date),
        type: dto.type,
        description: dto.description,
        amount: dto.amount,
        bankAccountId: dto.bankAccountId,
      },
      include: { school: true, bankAccount: true },
    });

    await this.createLedgerEntries(payment);

    if (!payment.bankAccountId) {
      await this.cashBook.createFromPayment(payment);
    }

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.PAYMENT_VOUCHER_CREATE,
        entityType: 'PaymentVoucher',
        entityId: payment.id,
        schoolId: payment.schoolId ?? undefined,
        metadata: { voucherNo: payment.voucherNo, amount: Number(payment.amount) },
        ipAddress,
      });
    }

    return payment;
  }

  async findAll(schoolId?: string, type?: PaymentType, startDate?: Date, endDate?: Date) {
    const where: any = {};
    if (schoolId) where.schoolId = schoolId;
    if (type) where.type = type;
    if (startDate && endDate) {
      where.date = { gte: startDate, lte: endDate };
    }

    return this.prisma.paymentVoucher.findMany({
      where,
      include: { school: true, bankAccount: true },
      orderBy: { date: 'desc' },
    });
  }

  async findById(id: string, actor?: ScopedUser) {
    const payment = await this.prisma.paymentVoucher.findUnique({
      where: { id },
      include: {
        school: true,
        bankAccount: true,
        ledgerEntries: { include: { account: true } },
        deathBenefit: { include: { deathClaim: { include: { member: true } } } },
      },
    });

    if (!payment) {
      throw new NotFoundException('ไม่พบใบสำคัญจ่าย');
    }

    if (actor) {
      this.schoolScope.assertResourceSchoolAccess(actor, payment.schoolId);
    }

    return payment;
  }

  async getSummary(schoolId?: string, startDate?: Date, endDate?: Date) {
    const where: any = {};
    if (schoolId) where.schoolId = schoolId;
    if (startDate && endDate) {
      where.date = { gte: startDate, lte: endDate };
    }

    const byType = await this.prisma.paymentVoucher.groupBy({
      by: ['type'],
      where,
      _sum: { amount: true },
      _count: true,
    });

    const total = await this.prisma.paymentVoucher.aggregate({
      where,
      _sum: { amount: true },
      _count: true,
    });

    return {
      byType: byType.map((item) => ({
        type: item.type,
        count: item._count,
        amount: Number(item._sum.amount || 0),
      })),
      total: {
        count: total._count,
        amount: Number(total._sum.amount || 0),
      },
    };
  }

  private async createLedgerEntries(payment: any) {
    // Get accounts
    const cashAccount = await this.prisma.account.findFirst({ where: { code: '101' } });
    const bankAccount = await this.prisma.account.findFirst({ where: { code: '102' } });
    const deathBenefitExpense = await this.prisma.account.findFirst({ where: { code: '501' } });

    if (!cashAccount || !deathBenefitExpense) return;

    const creditAccountId = payment.bankAccountId ? bankAccount?.id : cashAccount.id;
    let debitAccountId = deathBenefitExpense.id;

    // Determine debit account based on payment type
    if (payment.type === PaymentType.DEATH_BENEFIT) {
      debitAccountId = deathBenefitExpense.id;
    }

    if (debitAccountId && creditAccountId) {
      const entries = [
        {
          accountId: debitAccountId,
          date: payment.date,
          description: payment.description || `ใบสำคัญจ่าย ${payment.voucherNo}`,
          debit: payment.amount,
          credit: 0,
          paymentId: payment.id,
        },
        {
          accountId: creditAccountId,
          date: payment.date,
          description: payment.description || `ใบสำคัญจ่าย ${payment.voucherNo}`,
          debit: 0,
          credit: payment.amount,
          paymentId: payment.id,
        },
      ];

      // Double-entry validation
      const totalDebit = entries.reduce((s, e) => s + Number(e.debit), 0);
      const totalCredit = entries.reduce((s, e) => s + Number(e.credit), 0);
      if (Math.abs(totalDebit - totalCredit) > 0.01) {
        throw new Error(`Double-entry violation in PaymentVoucher ${payment.voucherNo}: Debit ${totalDebit} != Credit ${totalCredit}`);
      }

      await this.prisma.ledgerEntry.createMany({ data: entries });
    }
  }
}

