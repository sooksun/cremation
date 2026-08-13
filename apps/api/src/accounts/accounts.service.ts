import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateAccountDto, UpdateAccountDto } from './dto/account.dto';
import { AccountType } from '@prisma/client';
import { AuditLogService } from '../common/services/audit-log.service';
import { AuditAction } from '@prisma/client';
import { ScopedUser } from '../common/security/school-scope.service';

@Injectable()
export class AccountsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly auditLog: AuditLogService,
  ) {}

  async create(dto: CreateAccountDto, actor?: ScopedUser) {
    const existing = await this.prisma.account.findUnique({
      where: { code: dto.code },
    });

    if (existing) {
      throw new ConflictException('รหัสบัญชีนี้มีอยู่แล้ว');
    }

    const account = await this.prisma.account.create({ data: dto });

    await this.auditLog.log({
      userId: actor ? actor.id : 'system',
      action: AuditAction.ACCOUNT_CREATE,
      entityType: 'Account',
      entityId: account.id,
      metadata: { code: account.code, name: account.name, type: account.type },
    });

    return account;
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

  async update(id: string, dto: UpdateAccountDto, actor?: ScopedUser) {
    await this.findById(id);
    const updated = await this.prisma.account.update({ where: { id }, data: dto });

    await this.auditLog.log({
      userId: actor ? actor.id : 'system',
      action: AuditAction.ACCOUNT_UPDATE,
      entityType: 'Account',
      entityId: id,
      metadata: { updatedFields: Object.keys(dto) },
    });

    return updated;
  }

  async remove(id: string, actor?: ScopedUser) {
    await this.findById(id);
    const acc = await this.prisma.account.findUnique({ where: { id } });

    await this.auditLog.log({
      userId: actor ? actor.id : 'system',
      action: AuditAction.ACCOUNT_UPDATE,
      entityType: 'Account',
      entityId: id,
      metadata: { action: 'deactivate', code: acc?.code },
    });

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

    let grandTotalDebit = 0;
    let grandTotalCredit = 0;

    const result = accounts.map((account) => {
      const totalDebit = account.entries.reduce((sum, e) => sum + Number(e.debit), 0);
      const totalCredit = account.entries.reduce((sum, e) => sum + Number(e.credit), 0);

      grandTotalDebit += totalDebit;
      grandTotalCredit += totalCredit;

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

    return {
      accounts: result,
      totals: {
        debit: grandTotalDebit,
        credit: grandTotalCredit,
        isBalanced: Math.abs(grandTotalDebit - grandTotalCredit) < 0.01,
        difference: grandTotalDebit - grandTotalCredit,
      },
    };
  }

  // Get ledger for specific account
  /**
   * Validate that a set of ledger entries forms a balanced double-entry transaction.
   * Throws if not balanced.
   */
  validateDoubleEntry(entries: Array<{ debit: number; credit: number }>) {
    const totalDebit = entries.reduce((sum, e) => sum + Number(e.debit || 0), 0);
    const totalCredit = entries.reduce((sum, e) => sum + Number(e.credit || 0), 0);

    if (Math.abs(totalDebit - totalCredit) > 0.01) {
      throw new Error(`Double-entry violation: Debit ${totalDebit} != Credit ${totalCredit}`);
    }
    return true;
  }

  async getJournal(startDate?: Date, endDate?: Date, schoolId?: string) {
    const where: any = {};
    if (startDate && endDate) where.date = { gte: startDate, lte: endDate };
    if (schoolId) {
      // Note: ledger doesn't directly have school, but we can join via receipt/payment if needed
      // For simplicity, return all or filter via related
    }

    const entries = await this.prisma.ledgerEntry.findMany({
      where,
      include: {
        account: true,
        receipt: { include: { school: true } },
        payment: { include: { school: true } },
      },
      orderBy: [{ date: 'asc' }, { createdAt: 'asc' }],
    });

    // Group by date + receipt/payment for "journal" feel
    const journal: any[] = [];
    let current: any = null;

    for (const entry of entries as any[]) {
      const transKey = entry.receiptId || entry.paymentId || entry.id;
      if (!current || current.transId !== transKey) {
        current = {
          transId: transKey,
          date: entry.date,
          description: entry.description,
          reference: entry.receipt?.receiptNo || entry.payment?.voucherNo || '',
          school: entry.receipt?.school?.name || entry.payment?.school?.name || '',
          entries: [],
          totalDebit: 0,
          totalCredit: 0,
        };
        journal.push(current);
      }
      current.entries.push({
        accountCode: entry.account?.code,
        accountName: entry.account?.name,
        debit: Number(entry.debit),
        credit: Number(entry.credit),
      });
      current.totalDebit += Number(entry.debit);
      current.totalCredit += Number(entry.credit);
    }

    return journal;
  }

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

  async getBalanceSheet(asOfDate?: Date, schoolId?: string) {
    const endDate = asOfDate || new Date();
    const tb = await this.getTrialBalance(undefined, endDate);
    const accounts = tb.accounts || [];

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
    const liabilitiesAndEquity = totalLiabilities + totalEquity;

    // Group 11: Include Fixed Assets from Asset model (book value) — compute BEFORE use
    const assetWhere: any = { status: 'ACTIVE' };
    if (schoolId) assetWhere.schoolId = schoolId;
    const fixedAssetsRaw = await this.prisma.asset.findMany({ where: assetWhere });
    const fixedAssets = fixedAssetsRaw.map((a) => {
      const book = Number(a.originalCost) - Number(a.accumulatedDep || 0);
      return {
        code: a.code || 'FIXED',
        name: a.name,
        originalCost: Number(a.originalCost),
        accumulatedDep: Number(a.accumulatedDep || 0),
        balance: Math.max(0, book),
      };
    });
    const totalFixedAssets = fixedAssets.reduce((s, a) => s + a.balance, 0);

    const isBalanced = Math.abs(totalAssets + totalFixedAssets - liabilitiesAndEquity) < 0.01;

    return {
      asOfDate: endDate,
      assets: [...assets, ...fixedAssets.map(f => ({ code: f.code, name: f.name + ' (คงเหลือ)', balance: f.balance })) ],
      liabilities,
      equity,
      fixedAssets,
      totals: {
        assets: totalAssets + totalFixedAssets,
        liabilities: totalLiabilities,
        equity: totalEquity,
        liabilitiesAndEquity,
        fixedAssetsNet: totalFixedAssets,
      },
      isBalanced,
      difference: totalAssets + totalFixedAssets - liabilitiesAndEquity,
      // Include trial balance check
      trialBalanceCheck: tb.totals,
    };
  }

  async getProfitAndLoss(startDate: Date, endDate: Date) {
    const tb = await this.getTrialBalance(startDate, endDate);
    const accounts = tb.accounts || [];

    const income = accounts
      .filter((a) => a.type === AccountType.INCOME)
      .map((a) => ({ code: a.code, name: a.name, amount: a.balance }));

    const expenses = accounts
      .filter((a) => a.type === AccountType.EXPENSE)
      .map((a) => ({ code: a.code, name: a.name, amount: a.balance }));

    const totalIncome = income.reduce((s, a) => s + a.amount, 0);
    const totalExpenses = expenses.reduce((s, a) => s + a.amount, 0);
    const netProfit = totalIncome - totalExpenses;

    return {
      startDate,
      endDate,
      income,
      expenses,
      totals: {
        income: totalIncome,
        expenses: totalExpenses,
        netProfit,
      },
      // Link to trial balance verification
      trialBalanceCheck: tb.totals,
    };
  }

  // Period Closing for Accounting - Group 7
  async closeAccountingYear(year: number, schoolId?: string) {
    const startDate = new Date(year, 0, 1);
    const endDate = new Date(year + 1, 0, 1);

    const pl = await this.getProfitAndLoss(startDate, endDate);

    // Find closing accounts (create if not exist in real app, here assume)
    const incomeSummary = await this.prisma.account.findFirst({ where: { code: '399' } }); // Income Summary
    const retainedEarnings = await this.prisma.account.findFirst({ where: { code: '310' } }); // Retained Earnings / ทุนสะสม

    if (!incomeSummary || !retainedEarnings) {
      throw new Error('Missing closing accounts. Please ensure account codes 399 (Income Summary) and 310 (Retained Earnings) exist.');
    }

    const entries: any[] = [];
    const closeDate = new Date(year, 11, 31);

    // Close Income (revenues) - Debit Revenue, Credit Summary
    // ยอดติดลบ (เช่น กลับรายการมากกว่ารายได้ที่รับจริง) ต้องกลับข้างเดบิต/เครดิต
    // ไม่งั้นบัญชีนั้นไม่ถูกล้าง แต่ netProfit รวมยอดติดลบไว้แล้ว → 399 เหลือยอดค้างข้ามปี
    for (const inc of pl.income) {
      const acc = await this.prisma.account.findFirst({ where: { code: inc.code } });
      if (acc && inc.amount !== 0) {
        const magnitude = Math.abs(inc.amount);
        const positive = inc.amount > 0;
        const description = `ปิดรายได้ ${inc.name} ประจำปี ${year}`;
        entries.push({
          accountId: acc.id,
          date: closeDate,
          description,
          debit: positive ? magnitude : 0,
          credit: positive ? 0 : magnitude,
        });
        entries.push({
          accountId: incomeSummary.id,
          date: closeDate,
          description,
          debit: positive ? 0 : magnitude,
          credit: positive ? magnitude : 0,
        });
      }
    }

    // Close Expenses - Credit Expense, Debit Summary
    for (const exp of pl.expenses) {
      const acc = await this.prisma.account.findFirst({ where: { code: exp.code } });
      if (acc && exp.amount !== 0) {
        const magnitude = Math.abs(exp.amount);
        const positive = exp.amount > 0;
        const description = `ปิดค่าใช้จ่าย ${exp.name} ประจำปี ${year}`;
        entries.push({
          accountId: acc.id,
          date: closeDate,
          description,
          debit: positive ? 0 : magnitude,
          credit: positive ? magnitude : 0,
        });
        entries.push({
          accountId: incomeSummary.id,
          date: closeDate,
          description,
          debit: positive ? magnitude : 0,
          credit: positive ? 0 : magnitude,
        });
      }
    }

    // Close Income Summary to Retained Earnings
    const net = pl.totals.netProfit;
    if (net !== 0) {
      if (net > 0) {
        // Profit
        entries.push({
          accountId: incomeSummary.id,
          date: closeDate,
          description: `ปิดสรุปกำไรสุทธิ ปี ${year}`,
          debit: net,
          credit: 0,
        });
        entries.push({
          accountId: retainedEarnings.id,
          date: closeDate,
          description: `ปิดสรุปกำไรสุทธิ ปี ${year}`,
          debit: 0,
          credit: net,
        });
      } else {
        // Loss
        entries.push({
          accountId: incomeSummary.id,
          date: closeDate,
          description: `ปิดสรุปขาดทุนสุทธิ ปี ${year}`,
          debit: 0,
          credit: -net,
        });
        entries.push({
          accountId: retainedEarnings.id,
          date: closeDate,
          description: `ปิดสรุปขาดทุนสุทธิ ปี ${year}`,
          debit: -net,
          credit: 0,
        });
      }
    }

    if (entries.length > 0) {
      await this.prisma.ledgerEntry.createMany({ data: entries });
    }

    return {
      message: `ปิดบัญชีประจำปี ${year} สำเร็จ`,
      netProfit: net,
      closingEntriesCreated: entries.length,
      entries: entries.slice(0, 5), // sample
    };
  }
}

