import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateBankAccountDto, UpdateBankAccountDto } from './dto/bank-account.dto';

@Injectable()
export class BankAccountsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateBankAccountDto) {
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

    return this.prisma.bankAccount.create({ data: dto });
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

  async update(id: string, dto: UpdateBankAccountDto) {
    await this.findById(id);

    // If setting as default, unset other defaults
    if (dto.isDefault) {
      await this.prisma.bankAccount.updateMany({
        where: { isDefault: true, id: { not: id } },
        data: { isDefault: false },
      });
    }

    return this.prisma.bankAccount.update({
      where: { id },
      data: dto,
    });
  }

  async remove(id: string) {
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

    const [receipts, payments] = await Promise.all([
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
    ]);

    // Combine and sort by date
    const transactions = [
      ...receipts.map((r) => ({
        id: r.id,
        date: r.date,
        type: 'DEPOSIT' as const,
        description: r.description || `ใบเสร็จ ${r.receiptNo}`,
        amount: Number(r.amount),
        reference: r.receiptNo,
        school: r.school?.name || null,
      })),
      ...payments.map((p) => ({
        id: p.id,
        date: p.date,
        type: 'WITHDRAWAL' as const,
        description: p.description || `ใบสำคัญจ่าย ${p.voucherNo}`,
        amount: -Number(p.amount),
        reference: p.voucherNo,
        school: p.school?.name || null,
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

    const [receiptsSum, paymentsSum] = await Promise.all([
      this.prisma.receipt.aggregate({
        where: { bankAccountId: id },
        _sum: { amount: true },
      }),
      this.prisma.paymentVoucher.aggregate({
        where: { bankAccountId: id },
        _sum: { amount: true },
      }),
    ]);

    const totalDeposits = Number(receiptsSum._sum.amount || 0);
    const totalWithdrawals = Number(paymentsSum._sum.amount || 0);

    return {
      totalDeposits,
      totalWithdrawals,
      balance: totalDeposits - totalWithdrawals,
    };
  }
}
