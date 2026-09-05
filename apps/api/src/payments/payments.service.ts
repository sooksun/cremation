import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { DocumentNumberService, DocumentType } from '../common/document-number.service';
import { CreatePaymentDto } from './dto/create-payment.dto';
import { AuditAction, PaymentType, Prisma } from '@prisma/client';
import { PAYMENT_EXPENSE_ACCOUNT, FALLBACK_EXPENSE_ACCOUNT } from '../common/ledger-account-map';
import { SchoolScopeService, ScopedUser } from '../common/security/school-scope.service';
import { AuditLogService } from '../common/services/audit-log.service';
import { CashBookService } from '../cash-book/cash-book.service';

@Injectable()
export class PaymentsService {
  private readonly logger = new Logger(PaymentsService.name);

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

    // เลขเอกสารสร้างนอก transaction (pattern เดียวกับ death-claims.service.ts)
    const voucherNo = await this.documentNumberService.generateNumber(DocumentType.PAYMENT_VOUCHER);

    const payment = await this.prisma.$transaction(async (tx) => {
      const created = await tx.paymentVoucher.create({
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

      await this.createLedgerEntries(created, tx);

      if (!created.bankAccountId) {
        await this.cashBook.createFromPayment(created, tx);
      }

      return created;
    });

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

    // ใบสำคัญจ่ายออกในนามสมาคมและหักจากเงินรายได้ 10% ที่หักเข้าสมาคม
    // เงินก้อนนี้เป็นของสมาคมทั้งก้อน ไม่ได้แยกตามโรงเรียน จึงไม่กรองด้วย schoolId
    const associationIncome = await this.prisma.memberContribution.aggregate({
      where: {
        paidAmount: { gt: 0 },
        ...(startDate && endDate ? { paidDate: { gte: startDate, lte: endDate } } : {}),
      },
      _sum: { serviceAmount: true },
    });

    const totalPaid = Number(total._sum.amount || 0);
    const income = Number(associationIncome._sum.serviceAmount || 0);

    return {
      byType: byType.map((item) => ({
        type: item.type,
        count: item._count,
        amount: Number(item._sum.amount || 0),
      })),
      total: {
        count: total._count,
        amount: totalPaid,
      },
      associationIncome: {
        amount: income,
        remaining: income - totalPaid,
      },
    };
  }

  private async createLedgerEntries(payment: any, tx: Prisma.TransactionClient = this.prisma) {
    // Get accounts
    const cashAccount = await tx.account.findFirst({ where: { code: '101' } });
    const bankAccount = await tx.account.findFirst({ where: { code: '102' } });
    const deathBenefitExpense = await tx.account.findFirst({ where: { code: '501' } });

    if (!cashAccount || !deathBenefitExpense) {
      const missing = [!cashAccount && '101 (เงินสด)', !deathBenefitExpense && '501 (ค่าใช้จ่ายเงินสงเคราะห์ศพ)']
        .filter(Boolean)
        .join(', ');
      this.logger.warn(
        `createLedgerEntries: ไม่พบบัญชี ${missing} — ข้ามการบันทึกบัญชีสำหรับใบสำคัญจ่าย ${payment.voucherNo}`,
      );
      return;
    }

    const creditAccountId = payment.bankAccountId ? bankAccount?.id : cashAccount.id;

    // เดิม if ตรงนี้กำหนดค่าเดิมทับตัวเอง ทำให้ OPERATING_EXPENSE / BANK_FEE / OTHER
    // ถูกลงเป็น "ค่าใช้จ่ายเงินสงเคราะห์ศพ" ทั้งหมด รายงานค่าใช้จ่ายจึงผิดทุกใบที่ไม่ใช่เงินสงเคราะห์
    const expenseCode = PAYMENT_EXPENSE_ACCOUNT[payment.type as PaymentType] ?? FALLBACK_EXPENSE_ACCOUNT;
    let debitAccountId = deathBenefitExpense.id;
    if (expenseCode !== FALLBACK_EXPENSE_ACCOUNT) {
      const expenseAccount = await tx.account.findFirst({ where: { code: expenseCode } });
      if (expenseAccount) {
        debitAccountId = expenseAccount.id;
      } else {
        this.logger.warn(
          `createLedgerEntries: ไม่พบบัญชี ${expenseCode} สำหรับใบสำคัญจ่ายประเภท ${payment.type} — ใช้ ${FALLBACK_EXPENSE_ACCOUNT} แทน (รัน prisma db seed เพื่อเพิ่มบัญชีที่ขาด)`,
        );
      }
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

      await tx.ledgerEntry.createMany({ data: entries });
    } else {
      this.logger.warn(
        `createLedgerEntries: ไม่พบบัญชี 102 (เงินฝากธนาคาร) — ข้ามการบันทึกบัญชีสำหรับใบสำคัญจ่าย ${payment.voucherNo}`,
      );
    }
  }
}

