import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateBankAccountDto, UpdateBankAccountDto } from './dto/bank-account.dto';
import { CreateBankTransactionDto, UpdateBankTransactionDto } from './dto/bank-transaction.dto';
import { DocumentNumberService, DocumentType } from '../common/document-number.service';
import { AuditLogService } from '../common/services/audit-log.service';
import { AuditAction } from '@prisma/client';
import { ScopedUser } from '../common/security/school-scope.service';

@Injectable()
export class BankAccountsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly documentNumberService: DocumentNumberService,
    private readonly auditLog: AuditLogService,
  ) {}

  async create(dto: CreateBankAccountDto, actor?: ScopedUser) {
    // Check if accountNo already exists
    const existing = await this.prisma.bankAccount.findUnique({
      where: { accountNo: dto.accountNo },
    });

    if (existing) {
      throw new BadRequestException('เลขบัญชีนี้มีในระบบแล้ว');
    }

    // If this is set as default, unset other defaults
    if (dto.isDefault) {
      await this.prisma.bankAccount.updateMany({
        where: { isDefault: true },
        data: { isDefault: false },
      });
    }

    const account = await this.prisma.bankAccount.create({ data: dto });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.BANK_ACCOUNT_CREATE,
        entityType: 'BankAccount',
        entityId: account.id,
        metadata: { bankName: account.bankName, accountNo: account.accountNo },
      });
    }
    return account;
  }

  async findAll() {
    return this.prisma.bankAccount.findMany({
      where: { isActive: true },
      orderBy: [{ isDefault: 'desc' }, { bankName: 'asc' }],
    });
  }

  async findAllIncludeInactive() {
    return this.prisma.bankAccount.findMany({
      orderBy: [{ isDefault: 'desc' }, { isActive: 'desc' }, { bankName: 'asc' }],
    });
  }

  async findById(id: string) {
    const bankAccount = await this.prisma.bankAccount.findUnique({
      where: { id },
    });

    if (!bankAccount) {
      throw new NotFoundException('ไม่พบบัญชีธนาคาร');
    }

    return bankAccount;
  }

  async findDefault() {
    const defaultAccount = await this.prisma.bankAccount.findFirst({
      where: { isDefault: true, isActive: true },
    });

    if (!defaultAccount) {
      // If no default, return first active account
      return this.prisma.bankAccount.findFirst({
        where: { isActive: true },
        orderBy: { createdAt: 'asc' },
      });
    }

    return defaultAccount;
  }

  async update(id: string, dto: UpdateBankAccountDto, actor?: ScopedUser) {
    await this.findById(id);

    // If setting as default, unset other defaults
    if (dto.isDefault) {
      await this.prisma.bankAccount.updateMany({
        where: { isDefault: true, id: { not: id } },
        data: { isDefault: false },
      });
    }

    const updated = await this.prisma.bankAccount.update({
      where: { id },
      data: dto,
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.BANK_ACCOUNT_UPDATE,
        entityType: 'BankAccount',
        entityId: id,
        metadata: { updatedFields: Object.keys(dto) },
      });
    }
    return updated;
  }

  async remove(id: string, actor?: ScopedUser) {
    const account = await this.findById(id);
    
    // Don't allow deleting default account unless it's the last one
    if (account.isDefault) {
      const otherAccounts = await this.prisma.bankAccount.count({
        where: { isActive: true, id: { not: id } },
      });
      
      if (otherAccounts > 0) {
        throw new BadRequestException('ไม่สามารถปิดบัญชีหลักได้ กรุณาเปลี่ยนบัญชีหลักก่อน');
      }
    }

    await this.prisma.bankAccount.update({
      where: { id },
      data: { isActive: false, isDefault: false },
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.BANK_ACCOUNT_DELETE,
        entityType: 'BankAccount',
        entityId: id,
        metadata: { bankName: account.bankName, accountNo: account.accountNo },
      });
    }
    return { message: 'ปิดใช้งานบัญชีธนาคารสำเร็จ' };
  }

  async setDefault(id: string) {
    await this.findById(id);
    
    // Unset all defaults
    await this.prisma.bankAccount.updateMany({
      where: { isDefault: true },
      data: { isDefault: false },
    });

    // Set new default
    return this.prisma.bankAccount.update({
      where: { id },
      data: { isDefault: true, isActive: true },
    });
  }

  // Get transactions for bank account
  async getTransactions(id: string, startDate?: Date, endDate?: Date) {
    await this.findById(id);

    const dateFilter: any = {};
    if (startDate && endDate) {
      dateFilter.date = { gte: startDate, lte: endDate };
    }

    const [receipts, payments, manualTxns] = await Promise.all([
      this.prisma.receipt.findMany({
        where: { bankAccountId: id, ...dateFilter },
        include: { school: true },
        orderBy: { date: 'asc' },
      }),
      this.prisma.paymentVoucher.findMany({
        where: { bankAccountId: id, ...dateFilter },
        include: { school: true },
        orderBy: { date: 'asc' },
      }),
      this.prisma.bankTransaction.findMany({
        where: {
          bankAccountId: id,
          deletedAt: null,
          ...(startDate && endDate ? { date: dateFilter.date } : {}),
        },
        orderBy: { date: 'asc' },
      }),
    ]);

    const transactions = [
      ...receipts.map((r) => ({
        id: r.id,
        date: r.date,
        type: 'DEPOSIT' as const,
        source: 'receipt' as const,
        description: r.description || `ใบเสร็จ ${r.receiptNo}`,
        amount: Number(r.amount),
        reference: r.receiptNo,
        school: r.school?.name || null,
      })),
      ...payments.map((p) => ({
        id: p.id,
        date: p.date,
        type: 'WITHDRAWAL' as const,
        source: 'payment' as const,
        description: p.description || `ใบสำคัญจ่าย ${p.voucherNo}`,
        amount: -Number(p.amount),
        reference: p.voucherNo,
        school: p.school?.name || null,
      })),
      ...manualTxns.map((t) => ({
        id: t.id,
        date: t.date,
        type: t.type,
        source: 'manual' as const,
        description: t.description || `ธุรกรรม ${t.transactionNo}`,
        amount: t.type === 'DEPOSIT' ? Number(t.amount) : -Number(t.amount),
        reference: t.transactionNo,
        school: null,
      })),
    ].sort((a, b) => a.date.getTime() - b.date.getTime());

    // Calculate running balance
    let balance = 0;
    return transactions.map((t) => {
      balance += t.amount;
      return { ...t, balance };
    });
  }

  // Get account balance
  async getBalance(id: string) {
    await this.findById(id);

    const [receiptsSum, paymentsSum, manualDeposits, manualWithdrawals] = await Promise.all([
      this.prisma.receipt.aggregate({
        where: { bankAccountId: id },
        _sum: { amount: true },
      }),
      this.prisma.paymentVoucher.aggregate({
        where: { bankAccountId: id },
        _sum: { amount: true },
      }),
      this.prisma.bankTransaction.aggregate({
        where: { bankAccountId: id, type: 'DEPOSIT', deletedAt: null },
        _sum: { amount: true },
      }),
      this.prisma.bankTransaction.aggregate({
        where: { bankAccountId: id, type: 'WITHDRAWAL', deletedAt: null },
        _sum: { amount: true },
      }),
    ]);

    const totalDeposits =
      Number(receiptsSum._sum.amount || 0) + Number(manualDeposits._sum.amount || 0);
    const totalWithdrawals =
      Number(paymentsSum._sum.amount || 0) + Number(manualWithdrawals._sum.amount || 0);

    return {
      totalDeposits,
      totalWithdrawals,
      balance: totalDeposits - totalWithdrawals,
    };
  }

  async listManualTransactions(bankAccountId?: string) {
    return this.prisma.bankTransaction.findMany({
      where: bankAccountId ? { bankAccountId, deletedAt: null } : { deletedAt: null },
      include: { bankAccount: true },
      orderBy: { date: 'desc' },
    });
  }

  async createManualTransaction(dto: CreateBankTransactionDto) {
    await this.findById(dto.bankAccountId);
    const transactionNo = await this.documentNumberService.generateNumber(
      DocumentType.BANK_TRANSACTION,
    );

    return this.prisma.bankTransaction.create({
      data: {
        transactionNo,
        bankAccountId: dto.bankAccountId,
        date: new Date(dto.date),
        type: dto.type,
        amount: dto.amount,
        description: dto.description,
      },
      include: { bankAccount: true },
    });
  }

  async updateManualTransaction(id: string, dto: UpdateBankTransactionDto) {
    const txn = await this.prisma.bankTransaction.findFirst({ where: { id, deletedAt: null } });
    if (!txn) {
      throw new NotFoundException('ไม่พบรายการธุรกรรม');
    }

    return this.prisma.bankTransaction.update({
      where: { id },
      data: {
        date: dto.date ? new Date(dto.date) : undefined,
        type: dto.type,
        amount: dto.amount,
        description: dto.description,
      },
      include: { bankAccount: true },
    });
  }

  async removeManualTransaction(id: string) {
    const txn = await this.prisma.bankTransaction.findFirst({ where: { id, deletedAt: null } });
    if (!txn) {
      throw new NotFoundException('ไม่พบรายการธุรกรรม');
    }
    // soft-delete — เก็บหลักฐาน 10 ปี (ข้อบังคับสมาคม ข้อ 30) แทนลบถาวร
    await this.prisma.bankTransaction.update({
      where: { id },
      data: { deletedAt: new Date() },
    });
    return { message: 'ลบรายการธุรกรรมสำเร็จ' };
  }
}
