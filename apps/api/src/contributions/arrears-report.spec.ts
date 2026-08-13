import { ContributionsService } from './contributions.service';
import { PrismaService } from '../prisma/prisma.service';
import { MembersService } from '../members/members.service';
import { MembershipRulesService } from '../members/membership-rules.service';
import { DocumentNumberService } from '../common/document-number.service';
import { BankAccountsService } from '../bank-accounts/bank-accounts.service';
import { SchoolScopeService } from '../common/security/school-scope.service';
import { AuditLogService } from '../common/services/audit-log.service';
import { AppSettingsService } from '../common/services/app-settings.service';

/**
 * I6: ตั้งแต่การชำระไม่ครบยอดถูกบังคับให้คง isArrears = true ไว้ (I2)
 * รายงานค้างชำระที่ยังกรอง paidAmount: 0 ด้วย จะมองไม่เห็นคนที่จ่ายมาบางส่วน
 * ทั้งที่ระบบทำเครื่องหมายว่ายังค้างอยู่ — isArrears ต้องเป็นธงเดียวที่ตัดสิน
 */
describe('ContributionsService.getArrears — คนจ่ายไม่ครบต้องอยู่ในรายงานค้างชำระ', () => {
  const ROWS = [
    // จ่ายมาบางส่วน 50 จาก 105 — ระบบยังทำเครื่องหมายค้างชำระไว้
    { id: 'c-partial', schoolId: 's1', paidAmount: 50, totalAmount: 105, isArrears: true },
    // ยังไม่จ่ายเลย
    { id: 'c-unpaid', schoolId: 's1', paidAmount: 0, totalAmount: 105, isArrears: true },
    // จ่ายครบแล้ว ไม่ค้าง
    { id: 'c-paid', schoolId: 's1', paidAmount: 105, totalAmount: 105, isArrears: false },
  ];

  function matches(row: Record<string, unknown>, where: Record<string, unknown>) {
    return Object.entries(where).every(([key, value]) => row[key] === value);
  }

  function buildService() {
    const findMany = jest.fn(async ({ where }: { where: Record<string, unknown> }) =>
      ROWS.filter((row) => matches(row, where)),
    );

    const service = new ContributionsService(
      { memberContribution: { findMany } } as unknown as PrismaService,
      {} as MembersService,
      {} as MembershipRulesService,
      {} as DocumentNumberService,
      {} as BankAccountsService,
      { resolveSchoolId: jest.fn((_actor, schoolId?: string) => schoolId) } as unknown as SchoolScopeService,
      { log: jest.fn() } as unknown as AuditLogService,
      {} as AppSettingsService,
    );

    return { service, findMany };
  }

  it('รายการที่จ่ายมาบางส่วนแต่ยังค้าง ต้องขึ้นในรายงานค้างชำระ', async () => {
    const { service } = buildService();

    const result = (await service.getArrears()) as Array<{ id: string }>;

    expect(result.map((r) => r.id)).toContain('c-partial');
  });

  it('รายการที่ยังไม่จ่ายเลยยังต้องขึ้นเหมือนเดิม และรายการที่จ่ายครบต้องไม่ขึ้น', async () => {
    const { service } = buildService();

    const result = (await service.getArrears()) as Array<{ id: string }>;

    expect(result.map((r) => r.id).sort()).toEqual(['c-partial', 'c-unpaid']);
  });

  it('ไม่กรองด้วย paidAmount อีกต่อไป — isArrears เป็นธงเดียวที่ตัดสิน', async () => {
    const { service, findMany } = buildService();

    await service.getArrears();

    expect(findMany.mock.calls[0][0].where).toEqual({ isArrears: true });
  });

  it('ยังคงจำกัดขอบเขตตามโรงเรียนและงวดที่ระบุ', async () => {
    const { service, findMany } = buildService();

    await service.getArrears('s1', 'p1', { id: 'u1', role: 'ADMIN' } as never);

    expect(findMany.mock.calls[0][0].where).toEqual({
      isArrears: true,
      schoolId: 's1',
      periodId: 'p1',
    });
  });
});
