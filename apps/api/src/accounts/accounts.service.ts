import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateAccountDto, UpdateAccountDto } from './dto/account.dto';
import { AccountType } from '@prisma/client';

@Injectable()
export class AccountsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateAccountDto) {
    const existing = await this.prisma.account.findUnique({
      where: { code: dto.code },
    });

    if (existing) {
      throw new ConflictException('รหัสบัญชีนี้มีอยู่แล้ว');
    }

    return this.prisma.account.create({ data: dto });
  }

  async findAll(type?: AccountType) {
    return this.prisma.account.findMany({
      where: type ? { type, isActive: true } : { isActive: true },
      orderBy: { code: 'asc' },
    });
  }

  async findById(id: string) {
    const account = await this.prisma.account.findUnique({ where: { id } });
    if (!account) {
      throw new NotFoundException('ไม่พบบัญชี');
    }
    return account;
  }

  async update(id: string, dto: UpdateAccountDto) {
    await this.findById(id);
    return this.prisma.account.update({ where: { id }, data: dto });
  }

  async remove(id: string) {
    await this.findById(id);
    await this.prisma.account.update({ where: { id }, data: { isActive: false } });
    return { message: 'ปิดใช้งานบัญชีสำเร็จ' };
  }

  // Get trial balance
  async getTrialBalance(startDate?: Date, endDate?: Date) {
    const where: any = {};
    if (startDate && endDate) {
      where.date = { gte: startDate, lte: endDate };
    }

    const accounts = await this.prisma.account.findMany({
      where: { isActive: true },
      include: {
        entries: {
          where,
        },
      },
      orderBy: { code: 'asc' },
    });

    return accounts.map((account) => {
      const totalDebit = account.entries.reduce((sum, e) => sum + Number(e.debit), 0);
      const totalCredit = account.entries.reduce((sum, e) => sum + Number(e.credit), 0);

      return {
        id: account.id,
        code: account.code,
        name: account.name,
        type: account.type,
        debit: totalDebit,
        credit: totalCredit,
        balance: account.type === 'ASSET' || account.type === 'EXPENSE' 
          ? totalDebit - totalCredit 
          : totalCredit - totalDebit,
      };
    });
  }

  // Get ledger for specific account
  async getLedger(accountId: string, startDate?: Date, endDate?: Date) {
    const account = await this.findById(accountId);

    const where: any = { accountId };
    if (startDate && endDate) {
      where.date = { gte: startDate, lte: endDate };
    }

    const entries = await this.prisma.ledgerEntry.findMany({
      where,
      include: {
        receipt: true,
        payment: true,
      },
      orderBy: { date: 'asc' },
    });

    let runningBalance = 0;
    return entries.map((entry) => {
      const movement =
        account.type === 'ASSET' || account.type === 'EXPENSE'
          ? Number(entry.debit) - Number(entry.credit)
          : Number(entry.credit) - Number(entry.debit);
      runningBalance += movement;

      return {
        ...entry,
        runningBalance,
      };
    });
  }

  async getBalanceSheet(asOfDate?: Date) {
    const endDate = asOfDate || new Date();
    const accounts = await this.getTrialBalance(undefined, endDate);

    const group = (type: AccountType) =>
      accounts
        .filter((a) => a.type === type)
        .map((a) => ({
          code: a.code,
          name: a.name,
          balance: a.balance,
        }));

    const assets = group(AccountType.ASSET);
    const liabilities = group(AccountType.LIABILITY);
    const equity = group(AccountType.EQUITY);

    const totalAssets = assets.reduce((s, a) => s + a.balance, 0);
    const totalLiabilities = liabilities.reduce((s, a) => s + a.balance, 0);
    const totalEquity = equity.reduce((s, a) => s + a.balance, 0);

    return {
      asOfDate: endDate,
      assets,
      liabilities,
      equity,
      totals: {
        assets: totalAssets,
        liabilities: totalLiabilities,
        equity: totalEquity,
        liabilitiesAndEquity: totalLiabilities + totalEquity,
      },
    };
  }

  async getProfitAndLoss(startDate: Date, endDate: Date) {
    const accounts = await this.getTrialBalance(startDate, endDate);

    const income = accounts
      .filter((a) => a.type === AccountType.INCOME)
      .map((a) => ({ code: a.code, name: a.name, amount: a.balance }));

    const expenses = accounts
      .filter((a) => a.type === AccountType.EXPENSE)
      .map((a) => ({ code: a.code, name: a.name, amount: a.balance }));

    const totalIncome = income.reduce((s, a) => s + a.amount, 0);
    const totalExpenses = expenses.reduce((s, a) => s + a.amount, 0);

    return {
      startDate,
      endDate,
      income,
      expenses,
      totals: {
        income: totalIncome,
        expenses: totalExpenses,
        netProfit: totalIncome - totalExpenses,
      },
    };
  }
}

