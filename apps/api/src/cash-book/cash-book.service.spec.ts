import { CashBookService } from './cash-book.service';
import { SchoolScopeService } from '../common/security/school-scope.service';
import { Role } from '@prisma/client';

describe('CashBookService (soft-delete retention, ref2 art.30)', () => {
  const prisma = {
    cashBook: {
      findFirst: jest.fn(),
      findMany: jest.fn(),
      findUnique: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
      create: jest.fn(),
      count: jest.fn(),
    },
  };
  const schoolScope = new SchoolScopeService();
  const service = new CashBookService(prisma as never, schoolScope);
  const actor = { id: 'u1', role: Role.ADMIN, schoolId: null };

  beforeEach(() => jest.clearAllMocks());

  it('soft-deletes instead of hard delete', async () => {
    prisma.cashBook.findFirst.mockResolvedValue({ id: 'c1', schoolId: 's1' });

    await service.remove('c1', actor as never);

    expect(prisma.cashBook.update).toHaveBeenCalledWith({
      where: { id: 'c1' },
      data: { deletedAt: expect.any(Date) },
    });
    expect(prisma.cashBook.delete).not.toHaveBeenCalled();
  });

  it('excludes soft-deleted rows from findAll', async () => {
    prisma.cashBook.findMany.mockResolvedValue([]);

    await service.findAll('s1', actor as never);

    expect(prisma.cashBook.findMany).toHaveBeenCalledWith(
      expect.objectContaining({ where: expect.objectContaining({ deletedAt: null }) }),
    );
  });

  it('reactivates a soft-deleted cashbook when re-creating from the same receipt', async () => {
    prisma.cashBook.findFirst.mockResolvedValue({ id: 'c1', deletedAt: new Date() });
    prisma.cashBook.update.mockResolvedValue({ id: 'c1' });

    await service.createFromReceipt({
      id: 'r1',
      schoolId: 's1',
      date: new Date(),
      amount: 100,
      receiptNo: 'R1',
    });

    expect(prisma.cashBook.update).toHaveBeenCalledWith(
      expect.objectContaining({ where: { id: 'c1' }, data: expect.objectContaining({ deletedAt: null }) }),
    );
    expect(prisma.cashBook.create).not.toHaveBeenCalled();
  });
});
