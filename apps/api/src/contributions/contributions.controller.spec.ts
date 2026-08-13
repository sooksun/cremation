import { ContributionsController } from './contributions.controller';
import { ContributionsService } from './contributions.service';
import { PaymentReconciliationService } from './payment-reconciliation.service';
import * as XLSX from 'xlsx';

function xlsxFile(rows: string[][]): Express.Multer.File {
  const sheet = XLSX.utils.aoa_to_sheet(rows);
  const book = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(book, sheet, 'Sheet1');
  return {
    buffer: XLSX.write(book, { type: 'buffer', bookType: 'xlsx' }) as Buffer,
    originalname: 'payment.xlsx',
  } as Express.Multer.File;
}

describe('ContributionsController.uploadPaymentFile', () => {
  let controller: ContributionsController;
  let contributions: { processPaymentUpload: jest.Mock; findPeriodByYearMonth: jest.Mock };
  let reconciliation: { reconcile: jest.Mock };

  beforeEach(() => {
    contributions = {
      processPaymentUpload: jest
        .fn()
        .mockResolvedValue({ success: 1, failed: 0, notFound: 0, errors: [] }),
      findPeriodByYearMonth: jest.fn().mockResolvedValue({ id: 'p1' }),
    };
    reconciliation = {
      reconcile: jest.fn().mockResolvedValue({
        scope: { fullDistrict: false, schools: [] },
        summary: {
          expected: 2, paid: 1, alreadyPaid: 0, missingFromFile: 1,
          inFileNotPaid: 0, unknownInFile: 0, markedArrears: 1,
        },
        missing: [{ memberNo: 'M2', reason: 'NOT_IN_FILE' }],
        unknown: [],
      }),
    };

    controller = new ContributionsController(
      contributions as unknown as ContributionsService,
      reconciliation as unknown as PaymentReconciliationService,
    );
  });

  it('อ่านไฟล์ที่แนบมา แล้วคืนทั้งผล reconcile และ field เดิม', async () => {
    const file = xlsxFile([
      ['เลขสมาชิก', 'สถานะ'],
      ['M0001', 'ชำระแล้ว'],
    ]);

    const result = await controller.uploadPaymentFile(
      file,
      { year: '2026', month: '8', fullDistrict: 'false', autoMarkArrears: 'true' },
      { user: { id: 'u1', role: 'ADMIN' } } as never,
    );

    expect(contributions.processPaymentUpload).toHaveBeenCalled();
    expect(reconciliation.reconcile).toHaveBeenCalledWith(
      expect.objectContaining({ periodId: 'p1', fullDistrict: false, autoMarkArrears: true }),
    );
    expect(result.summary.missingFromFile).toBe(1);
    expect(result.success).toBe(1);
    expect(result.errors).toEqual([]);
  });

  it('ยังรับ body JSON แบบเดิมได้เมื่อไม่มีไฟล์แนบ', async () => {
    const result = await controller.uploadPaymentFile(
      undefined as unknown as Express.Multer.File,
      { year: '2026', month: '8', data: [{ เลขสมาชิก: 'M0001', สถานะ: 'ชำระแล้ว' }] },
      { user: { id: 'u1', role: 'ADMIN' } } as never,
    );

    expect(contributions.processPaymentUpload).toHaveBeenCalled();
    expect(result.success).toBe(1);
  });

  it('รายงานแถวที่เลขสมาชิกซ้ำเข้า errors', async () => {
    const file = xlsxFile([
      ['เลขสมาชิก', 'สถานะ'],
      ['M0001', 'ยังไม่ชำระ'],
      ['M0001', 'ชำระแล้ว'],
    ]);

    const result = await controller.uploadPaymentFile(
      file,
      { year: '2026', month: '8' },
      { user: { id: 'u1', role: 'ADMIN' } } as never,
    );

    expect(result.errors).toContainEqual(
      expect.objectContaining({ memberNo: 'M0001', error: expect.stringContaining('ซ้ำ') }),
    );
  });

  it('ถ้างวดปิดแล้ว processPaymentUpload ต้อง throw และห้ามเรียก reconcile เลย', async () => {
    const closedPeriodError = new Error('งวดนี้ปิดแล้ว ไม่สามารถอัปโหลดการชำระเงินได้');
    contributions.processPaymentUpload.mockRejectedValue(closedPeriodError);

    const file = xlsxFile([
      ['เลขสมาชิก', 'สถานะ'],
      ['M0001', 'ชำระแล้ว'],
    ]);

    await expect(
      controller.uploadPaymentFile(
        file,
        { year: '2026', month: '8' },
        { user: { id: 'u1', role: 'ADMIN' } } as never,
      ),
    ).rejects.toThrow(closedPeriodError);

    expect(contributions.processPaymentUpload).toHaveBeenCalled();
    expect(reconciliation.reconcile).not.toHaveBeenCalled();
  });
});
