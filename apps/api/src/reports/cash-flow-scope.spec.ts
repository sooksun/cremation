import { ReportsService } from './reports.service';
import { PrismaService } from '../prisma/prisma.service';
import { SchoolScopeService } from '../common/security/school-scope.service';
import { AccountsService } from '../accounts/accounts.service';
import { AuditLogService } from '../common/services/audit-log.service';

/**
 * BankTransaction ไม่มีคอลัมน์ schoolId — กรองตามโรงเรียนไม่ได้เลย
 * เดิมสองรายงานนี้เอายอดธนาคารทั้งสมาคมไปบวกกับใบเสร็จของโรงเรียนเดียว
 * แล้วคืน schoolId กลับมาราวกับกรองครบ ตัวเลขที่ได้จึงไม่ใช่ของใครทั้งนั้น
 */
describe('ReportsService — ขอบเขตโรงเรียนของงบกระแสเงินสดและรายงานรายวัน', () => {
  const START = new Date('2026-01-01');
  const END = new Date('2026-01-31');

  const RECEIPTS = [{ amount: 1000 }, { amount: 500 }]; // รวม 1,500
  const PAYMENTS = [{ amount: 300 }]; // รวม 300
  const DEPOSITS = 9000;
  const WITHDRAWALS = 2000;

  function buildPrisma() {
    const bankTxnWheres: any[] = [];

    const prisma: any = {
      receipt: {
        aggregate: jest.fn().mockResolvedValue({ _sum: { amount: 1500 } }),
        findMany: jest.fn().mockResolvedValue(
          RECEIPTS.map((r, i) => ({
            id: `r${i}`,
            receiptNo: `R${i}`,
            type: 'CONTRIBUTION',
            amount: r.amount,
            school: null,
            bankAccount: null,
          })),
        ),
      },
      paymentVoucher: {
        aggregate: jest.fn().mockResolvedValue({ _sum: { amount: 300 } }),
        findMany: jest.fn().mockResolvedValue(
          PAYMENTS.map((p, i) => ({
            id: `p${i}`,
            voucherNo: `PV${i}`,
            type: 'EXPENSE',
            amount: p.amount,
            school: null,
            bankAccount: null,
          })),
        ),
      },
      bankTransaction: {
        aggregate: jest.fn().mockImplementation(({ where }: any) => {
          bankTxnWheres.push(where);
          return Promise.resolve({
            _sum: { amount: where.type === 'DEPOSIT' ? DEPOSITS : WITHDRAWALS },
          });
        }),
        findMany: jest.fn().mockImplementation(({ where }: any) => {
          bankTxnWheres.push(where);
          return Promise.resolve([
            {
              id: 'bt1',
              transactionNo: 'BT1',
              type: 'DEPOSIT',
              amount: DEPOSITS,
              bankAccount: { bankName: 'ธ.กรุงไทย' },
              description: null,
            },
            {
              id: 'bt2',
              transactionNo: 'BT2',
              type: 'WITHDRAWAL',
              amount: WITHDRAWALS,
              bankAccount: { bankName: 'ธ.กรุงไทย' },
              description: null,
            },
          ]);
        }),
      },
    };

    const service = new ReportsService(
      prisma as unknown as PrismaService,
      {} as SchoolScopeService,
      {} as AccountsService,
      { log: jest.fn() } as unknown as AuditLogService,
    );

    return { service, prisma, bankTxnWheres };
  }

  describe('getCashFlow', () => {
    it('เลือกโรงเรียน — ยอดสุทธิต้องไม่เอายอดธนาคารทั้งสมาคมมาปน', async () => {
      const { service } = buildPrisma();

      const result = await service.getCashFlow(START, END, 'school-1');

      expect(result.cashFlows.operatingActivities.net).toBe(1200);
      expect(result.netCashFlow).toBe(1200);
      expect(result.summary.totalInflows).toBe(1500);
      expect(result.summary.totalOutflows).toBe(300);
    });

    it('เลือกโรงเรียน — ยังแสดงยอดธนาคารได้ แต่ต้องติดป้ายว่าเป็นของทั้งสมาคม', async () => {
      const { service } = buildPrisma();

      const result = await service.getCashFlow(START, END, 'school-1');

      expect(result.cashFlows.bankActivities.deposits).toBe(DEPOSITS);
      expect(result.cashFlows.bankActivities.withdrawals).toBe(WITHDRAWALS);
      expect(result.cashFlows.bankActivities.includedInTotals).toBe(false);
      expect(result.scope).toMatchObject({
        schoolId: 'school-1',
        operatingActivities: 'SCHOOL',
        bankActivities: 'ASSOCIATION',
      });
    });

    it('ไม่เลือกโรงเรียน — ทุกยอดเป็นของทั้งสมาคมเหมือนกัน จึงรวมยอดธนาคารได้', async () => {
      const { service } = buildPrisma();

      const result = await service.getCashFlow(START, END);

      expect(result.cashFlows.bankActivities.includedInTotals).toBe(true);
      expect(result.summary.totalInflows).toBe(1500 + DEPOSITS);
      expect(result.summary.totalOutflows).toBe(300 + WITHDRAWALS);
      expect(result.netCashFlow).toBe(1500 + DEPOSITS - (300 + WITHDRAWALS));
      expect(result.scope).toMatchObject({
        schoolId: null,
        operatingActivities: 'ASSOCIATION',
        bankActivities: 'ASSOCIATION',
      });
    });

    it('ต้องไม่นับรายการเดินบัญชีที่ถูกลบ', async () => {
      const { service, bankTxnWheres } = buildPrisma();

      await service.getCashFlow(START, END, 'school-1');

      expect(bankTxnWheres.length).toBeGreaterThan(0);
      for (const where of bankTxnWheres) {
        expect(where).toMatchObject({ deletedAt: null });
      }
    });
  });

  describe('getDailyMovement', () => {
    it('เลือกโรงเรียน — เงินรับ/เงินจ่ายต้องเป็นของโรงเรียนล้วน', async () => {
      const { service } = buildPrisma();

      const result = await service.getDailyMovement(START, 'school-1');

      expect(result.summary.cashIn).toBe(1500);
      expect(result.summary.cashOut).toBe(300);
      expect(result.summary.netMovement).toBe(1200);
      expect(result.summary.bankIn).toBe(DEPOSITS);
      expect(result.summary.bankOut).toBe(WITHDRAWALS);
      expect(result.summary.bankIncludedInTotals).toBe(false);
      expect(result.scope).toMatchObject({
        schoolId: 'school-1',
        receiptsAndPayments: 'SCHOOL',
        bankTransactions: 'ASSOCIATION',
      });
    });

    it('ไม่เลือกโรงเรียน — รวมยอดธนาคารเข้ายอดรวมได้', async () => {
      const { service } = buildPrisma();

      const result = await service.getDailyMovement(START);

      expect(result.summary.cashIn).toBe(1500 + DEPOSITS);
      expect(result.summary.cashOut).toBe(300 + WITHDRAWALS);
      expect(result.summary.bankIncludedInTotals).toBe(true);
    });

    it('ต้องไม่นับรายการเดินบัญชีที่ถูกลบ', async () => {
      const { service, bankTxnWheres } = buildPrisma();

      await service.getDailyMovement(START, 'school-1');

      expect(bankTxnWheres.length).toBeGreaterThan(0);
      for (const where of bankTxnWheres) {
        expect(where).toMatchObject({ deletedAt: null });
      }
    });
  });
});
