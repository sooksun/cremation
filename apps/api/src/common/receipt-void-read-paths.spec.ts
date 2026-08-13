import { PrismaService } from '../prisma/prisma.service';
import { ReceiptsService } from '../receipts/receipts.service';
import { BankAccountsService } from '../bank-accounts/bank-accounts.service';
import { ReportsService } from '../reports/reports.service';
import { DashboardsService } from '../dashboards/dashboards.service';
import { DocumentNumberService } from './document-number.service';
import { AuditLogService } from './services/audit-log.service';
import { SchoolScopeService } from './security/school-scope.service';
import { CashBookService } from '../cash-book/cash-book.service';
import { AccountsService } from '../accounts/accounts.service';

/**
 * ใบเสร็จที่ยกเลิกยังอยู่ในตาราง (กันเลขที่ถูกออกซ้ำ) แต่ไม่ใช่เงินจริง
 * ทุก query ที่คิดยอดเงินต้องกรอง voidedAt: null ไม่งั้นเงินที่ยกเลิกแล้วจะกลับเข้ารายงาน
 * เทสต์ชุดนี้ดักที่ where ของ query โดยตรง เพราะ where คือพฤติกรรมทั้งหมดของ read path เหล่านี้
 */
describe('read path ของใบเสร็จต้องไม่นับใบที่ยกเลิก', () => {
  function buildPrismaSpy() {
    const receiptWheres: any[] = [];

    const record = (result: any) =>
      jest.fn(async (args: any = {}) => {
        receiptWheres.push(args.where);
        return result;
      });

    const prisma: any = {
      receipt: {
        findMany: record([]),
        aggregate: record({ _sum: { amount: null }, _count: 0 }),
        groupBy: record([]),
      },
      paymentVoucher: {
        findMany: jest.fn(async () => []),
        aggregate: jest.fn(async () => ({ _sum: { amount: null }, _count: 0 })),
        groupBy: jest.fn(async () => []),
      },
      bankTransaction: {
        findMany: jest.fn(async () => []),
        aggregate: jest.fn(async () => ({ _sum: { amount: null } })),
      },
      bankAccount: {
        findUnique: jest.fn(async () => ({ id: 'bank-1', isActive: true })),
        findMany: jest.fn(async () => []),
      },
      contributionPeriod: { findMany: jest.fn(async () => []) },
      memberContribution: {
        groupBy: jest.fn(async () => []),
        aggregate: jest.fn(async () => ({ _sum: { totalAmount: null, paidAmount: null } })),
        findMany: jest.fn(async () => []),
        count: jest.fn(async () => 0),
      },
      member: { count: jest.fn(async () => 0), groupBy: jest.fn(async () => []) },
      deathClaim: { count: jest.fn(async () => 0) },
      $transaction: jest.fn(async (fn: any) => (typeof fn === 'function' ? fn(prisma) : fn)),
    };

    return { prisma, receiptWheres };
  }

  function expectAllExcludeVoided(receiptWheres: any[]) {
    expect(receiptWheres.length).toBeGreaterThan(0);
    for (const where of receiptWheres) {
      expect(where).toMatchObject({ voidedAt: null });
    }
  }

  it('ReceiptsService.getSummary — สรุปยอดต้องไม่รวมใบที่ยกเลิก', async () => {
    const { prisma, receiptWheres } = buildPrismaSpy();
    const service = new ReceiptsService(
      prisma as unknown as PrismaService,
      {} as DocumentNumberService,
      {} as AuditLogService,
      {} as SchoolScopeService,
      {} as CashBookService,
    );

    await service.getSummary('school-1', new Date('2026-01-01'), new Date('2026-01-31'));

    expectAllExcludeVoided(receiptWheres);
  });

  it('BankAccountsService — ยอดคงเหลือและรายการเดินบัญชีต้องไม่รวมใบที่ยกเลิก', async () => {
    const { prisma, receiptWheres } = buildPrismaSpy();
    const service = new BankAccountsService(
      prisma as unknown as PrismaService,
      {} as DocumentNumberService,
      {} as AuditLogService,
    );

    await service.getBalance('bank-1');
    await service.getTransactions('bank-1', new Date('2026-01-01'), new Date('2026-01-31'));

    expectAllExcludeVoided(receiptWheres);
  });

  it('ReportsService — สรุปการเงิน กระแสเงินสด และทะเบียนคุมใบเสร็จ ต้องไม่รวมใบที่ยกเลิก', async () => {
    const { prisma, receiptWheres } = buildPrismaSpy();
    const service = new ReportsService(
      prisma as unknown as PrismaService,
      {} as SchoolScopeService,
      {} as AccountsService,
      { log: jest.fn() } as unknown as AuditLogService,
    );

    const start = new Date('2026-01-01');
    const end = new Date('2026-01-31');
    await service.getFinancialSummary(start, end, 'school-1');
    await service.getCashFlow(start, end, 'school-1');
    await service.getReceiptsLedger(start, end, 'school-1');
    await service.getDailyMovement(start, 'school-1');
    await service.getDashboard('school-1', 2026);

    expectAllExcludeVoided(receiptWheres);
  });

  it('DashboardsService — แดชบอร์ดการเงินต้องไม่รวมใบที่ยกเลิก', async () => {
    const { prisma, receiptWheres } = buildPrismaSpy();
    const service = new DashboardsService(
      prisma as unknown as PrismaService,
      { resolveSchoolId: jest.fn(() => 'school-1') } as unknown as SchoolScopeService,
    );

    await service.getFinanceDashboard(2026);

    expectAllExcludeVoided(receiptWheres);
  });
});
