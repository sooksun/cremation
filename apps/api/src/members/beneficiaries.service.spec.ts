import { BadRequestException } from '@nestjs/common';
import { validate } from 'class-validator';
import { plainToInstance } from 'class-transformer';
import { BeneficiariesService } from './beneficiaries.service';
import { CreateBeneficiaryDto } from './dto/beneficiary.dto';

describe('BeneficiariesService (art.19 priority)', () => {
  const prisma = {
    beneficiary: {
      count: jest.fn(),
      create: jest.fn(),
      findFirst: jest.fn(),
      findUnique: jest.fn(),
      update: jest.fn(),
    },
    member: { findUnique: jest.fn() },
  };
  const schoolScope = {
    assertMemberSelfAccess: jest.fn(),
    assertSchoolAccess: jest.fn(),
  };
  const service = new BeneficiariesService(prisma as never, schoolScope as never);

  beforeEach(() => jest.clearAllMocks());

  it('rejects duplicate priority within a member', async () => {
    prisma.beneficiary.findFirst.mockResolvedValue({ id: 'b0', priority: 1 });

    await expect(
      service.create('m1', { fullName: 'ก', relationship: 'บุตร', priority: 1 } as never),
    ).rejects.toThrow(BadRequestException);
    expect(prisma.beneficiary.create).not.toHaveBeenCalled();
  });

  it('creates when priority is not duplicated', async () => {
    prisma.beneficiary.findFirst.mockResolvedValue(null);
    prisma.beneficiary.count.mockResolvedValue(1);
    prisma.beneficiary.create.mockResolvedValue({ id: 'b1', priority: 2 });

    await service.create('m1', { fullName: 'ก', relationship: 'บุตร', priority: 2 } as never);
    expect(prisma.beneficiary.create).toHaveBeenCalled();
  });

  it('rejects priority out of range 1-3 via DTO validation', async () => {
    const dto = plainToInstance(CreateBeneficiaryDto, {
      fullName: 'ก',
      relationship: 'บุตร',
      priority: 5,
    });
    const errors = await validate(dto);
    expect(errors.some((e) => e.property === 'priority')).toBe(true);
  });
});
