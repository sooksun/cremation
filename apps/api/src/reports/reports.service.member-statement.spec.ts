import { ReportsService } from './reports.service';

describe('ReportsService.getMemberStatement', () => {
  const prisma = {
    member: { findUnique: jest.fn() },
  };
  const schoolScope = {
    assertMemberSelfAccess: jest.fn(),
    assertSchoolAccess: jest.fn(),
  };

  const service = new ReportsService(prisma as never, schoolScope as never, {} as never, {} as never);
  const actor = { id: 'u1', role: 'ADMIN', memberId: 'member-1', schoolId: 'school-1' } as never;

  beforeEach(() => jest.clearAllMocks());

  const baseMember = {
    id: 'member-1',
    memberNo: 'M001',
    schoolId: 'school-1',
    school: { name: 'School A' },
    associationMember: { firstName: 'A', lastName: 'B' },
    joinDate: new Date('2020-01-01'),
    deathClaims: [],
  };

  it('does not accumulate floating-point drift in the running total', async () => {
    prisma.member.findUnique.mockResolvedValue({
      ...baseMember,
      contributions: [
        {
          paidAmount: 0.1,
          paidDate: new Date('2026-01-01'),
          createdAt: new Date('2026-01-01'),
          period: { year: 2026, month: 1 },
        },
        {
          paidAmount: 0.2,
          paidDate: new Date('2026-02-01'),
          createdAt: new Date('2026-02-01'),
          period: { year: 2026, month: 2 },
        },
      ],
    });

    const result = await service.getMemberStatement('member-1', actor);

    expect(result!.statement[1].runningTotal).toBe(0.3);
  });

  it('returns Gregorian periodYear/periodMonth instead of a Buddhist-Era year baked into description', async () => {
    prisma.member.findUnique.mockResolvedValue({
      ...baseMember,
      contributions: [
        {
          paidAmount: 100,
          paidDate: new Date('2026-03-01'),
          createdAt: new Date('2026-03-01'),
          period: { year: 2026, month: 3 },
        },
      ],
    });

    const result = await service.getMemberStatement('member-1', actor);

    expect(result!.statement[0].periodYear).toBe(2026);
    expect(result!.statement[0].periodMonth).toBe(3);
    expect(result!.statement[0].description).not.toContain('2569');
  });
});
