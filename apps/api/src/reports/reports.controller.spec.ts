import { ReportsController } from './reports.controller';

describe('ReportsController date-range parsing', () => {
  const reportsService = {
    getResignationReport: jest.fn().mockResolvedValue({}),
    getReceiptsLedger: jest.fn().mockResolvedValue({}),
    getDisbursementLedger: jest.fn().mockResolvedValue({}),
    getMemberRegistryReport: jest.fn().mockResolvedValue({}),
    getDeathBenefitReport: jest.fn().mockResolvedValue({}),
  };
  const schoolScope = {
    resolveSchoolId: jest.fn().mockReturnValue(undefined),
  };

  const controller = new ReportsController(reportsService as never, schoolScope as never);
  const req = { user: { id: 'u1', role: 'ADMIN' } } as never;

  beforeEach(() => jest.clearAllMocks());

  it('extends a resignation report endDate to the end of that UTC day', async () => {
    await controller.getResignationReport(req, '2026-01-01', '2026-01-31');

    const [, endDateArg] = reportsService.getResignationReport.mock.calls[0];
    expect(endDateArg.toISOString()).toBe('2026-01-31T23:59:59.999Z');
  });

  it('extends a receipts-ledger endDate to the end of that UTC day', async () => {
    await controller.getReceiptsLedger(req, '2026-01-01', '2026-01-31');

    const [, endDateArg] = reportsService.getReceiptsLedger.mock.calls[0];
    expect(endDateArg.toISOString()).toBe('2026-01-31T23:59:59.999Z');
  });

  it('extends a disbursement-ledger endDate to the end of that UTC day', async () => {
    await controller.getDisbursementLedger(req, '2026-01-01', '2026-01-31');

    const [, endDateArg] = reportsService.getDisbursementLedger.mock.calls[0];
    expect(endDateArg.toISOString()).toBe('2026-01-31T23:59:59.999Z');
  });

  it('extends a member-registry endDate to the end of that UTC day', async () => {
    await controller.getMemberRegistryReport(req, 'coverage', '2026-01-01', '2026-01-31');

    const [, , endDateArg] = reportsService.getMemberRegistryReport.mock.calls[0];
    expect(endDateArg.toISOString()).toBe('2026-01-31T23:59:59.999Z');
  });

  it('extends a death-benefits date-range endDate to the end of that UTC day', async () => {
    await controller.getDeathBenefitReport(req, undefined, '2026-01-01', '2026-01-31');

    const [rangeArg] = reportsService.getDeathBenefitReport.mock.calls[0];
    expect(rangeArg.endDate.toISOString()).toBe('2026-01-31T23:59:59.999Z');
  });

  it('leaves startDate at the start of the day', async () => {
    await controller.getResignationReport(req, '2026-01-01', '2026-01-31');

    const [startDateArg] = reportsService.getResignationReport.mock.calls[0];
    expect(startDateArg.toISOString()).toBe('2026-01-01T00:00:00.000Z');
  });
});
