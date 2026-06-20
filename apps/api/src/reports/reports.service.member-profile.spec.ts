import { ForbiddenException } from '@nestjs/common';
import { Role } from '@prisma/client';
import { ReportsService } from './reports.service';

describe('ReportsService.getMemberProfile access', () => {
  const member = {
    id: 'member-1',
    memberNo: 'M001',
    schoolId: 'school-1',
    school: { id: 'school-1', name: 'School' },
    associationMember: null,
    group: null,
    beneficiaries: [],
    contributions: [],
    deathClaims: [],
    joinDate: new Date('2020-01-01'),
    status: 'ACTIVE',
  };
  const prisma = {
    member: { findUnique: jest.fn().mockResolvedValue(member) },
  };
  const schoolScope = {
    assertMemberSelfAccess: jest.fn(),
    assertSchoolAccess: jest.fn(),
  };
  const service = new ReportsService(prisma as never, schoolScope as never);

  beforeEach(() => jest.clearAllMocks());

  it('checks both member identity and school scope', async () => {
    const actor = {
      id: 'user-1',
      role: Role.MEMBER,
      memberId: 'member-1',
      schoolId: 'school-1',
    };

    await service.getMemberProfile('member-1', actor);

    expect(schoolScope.assertMemberSelfAccess).toHaveBeenCalledWith(
      actor,
      'member-1',
    );
    expect(schoolScope.assertSchoolAccess).toHaveBeenCalledWith(actor, 'school-1');
  });

  it('propagates denial for another member id', async () => {
    schoolScope.assertMemberSelfAccess.mockImplementationOnce(() => {
      throw new ForbiddenException();
    });

    await expect(
      service.getMemberProfile('member-2', {
        id: 'user-1',
        role: Role.MEMBER,
        memberId: 'member-1',
        schoolId: 'school-1',
      }),
    ).rejects.toThrow(ForbiddenException);
  });
});
