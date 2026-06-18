import { BadRequestException } from '@nestjs/common';
import { MemberStatus } from '@prisma/client';
import { MemberApplicationsService } from './member-applications.service';

describe('MemberApplicationsService.submit', () => {
  const school = { id: 'school-1', name: 'โรงเรียนแม่ฟ้าหลวง', code: 'MFH' };
  const memberType = { id: 'type-1', code: 'REG' };

  const prisma = {
    school: { findMany: jest.fn(), findUnique: jest.fn() },
    memberType: { findUnique: jest.fn() },
    associationMember: { findFirst: jest.fn(), create: jest.fn() },
    member: { findUnique: jest.fn(), create: jest.fn() },
  };

  const documentNumberService = {
    generateNumber: jest.fn().mockResolvedValue('M0001'),
  };

  const membershipRules = {
    buildCreateMembershipFields: jest.fn().mockReturnValue({
      membershipClass: 'ORDINARY',
      applicationDeadline: new Date('2025-02-01'),
      applicationSubmittedAt: new Date(),
      consecutiveArrearsPeriods: 0,
    }),
    buildProtectedPersonsFromForm: jest.fn().mockReturnValue([]),
  };

  const protectedPersons = { syncForMember: jest.fn() };

  const service = new MemberApplicationsService(
    prisma as never,
    documentNumberService as never,
    membershipRules as never,
    protectedPersons as never,
  );

  const baseDto = {
    type: 'ordinary' as const,
    fullName: 'สมชาย ใจดี',
    governmentAgency: 'โรงเรียนแม่ฟ้าหลวง',
    applicationDate: '2025-01-01',
    beneficiaries: [],
    bloodRelatives: [],
  };

  beforeEach(() => {
    jest.clearAllMocks();
    prisma.school.findMany.mockResolvedValue([school]);
    prisma.school.findUnique.mockResolvedValue(school);
    prisma.memberType.findUnique.mockResolvedValue(memberType);
    prisma.associationMember.findFirst.mockResolvedValue(null);
    prisma.associationMember.create.mockResolvedValue({
      id: 'am-1',
      schoolId: school.id,
    });
    prisma.member.findUnique.mockResolvedValue(null);
    prisma.member.create.mockResolvedValue({
      id: 'member-1',
      memberNo: 'M0001',
      status: MemberStatus.SUSPENDED,
      membershipClass: 'ORDINARY',
      applicationDeadline: new Date('2025-02-01'),
      school: { name: school.name },
    });
  });

  it('creates member as SUSPENDED pending staff approval', async () => {
    const result = await service.submit(baseDto as never);

    expect(prisma.member.create).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({ status: MemberStatus.SUSPENDED }),
      }),
    );
    expect(result.status).toBe(MemberStatus.SUSPENDED);
  });

  it('rejects fuzzy school lookup', async () => {
    await expect(
      service.submit({ ...baseDto, governmentAgency: 'แม่ฟ้าหลวง' } as never),
    ).rejects.toThrow(BadRequestException);
    expect(prisma.member.create).not.toHaveBeenCalled();
  });
});