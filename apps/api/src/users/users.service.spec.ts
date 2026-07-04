jest.mock('bcrypt', () => ({ hash: jest.fn() }));

import { ConflictException } from '@nestjs/common';
import { Role } from '@prisma/client';
import * as bcrypt from 'bcrypt';
import { UsersService } from './users.service';

describe('UsersService member accounts', () => {
  const prisma = {
    user: {
      findUnique: jest.fn(),
      create: jest.fn(),
    },
    member: {
      findUnique: jest.fn(),
    },
  };
  const service = new UsersService(prisma as never, { log: jest.fn() } as never);

  beforeEach(() => {
    jest.clearAllMocks();
    prisma.user.findUnique.mockResolvedValue(null);
    (bcrypt.hash as jest.Mock).mockResolvedValue('hashed-password');
  });

  it('links MEMBER to the selected member and derives its school', async () => {
    prisma.member.findUnique.mockResolvedValue({
      id: 'member-1',
      schoolId: 'school-1',
      associationMember: {},
      user: null,
    });
    prisma.user.create.mockImplementation(async ({ data }) => ({
      id: 'user-1',
      ...data,
      passwordHash: 'hashed-password',
      school: { id: 'school-1' },
      member: { id: 'member-1' },
    }));

    await service.create({
      username: 'member001',
      password: 'securePass1!',
      fullName: 'Test Member',
      role: Role.MEMBER,
      memberId: 'member-1',
      schoolId: 'untrusted-school',
    });

    expect(prisma.user.create).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          role: Role.MEMBER,
          memberId: 'member-1',
          schoolId: 'school-1',
          groupId: null,
        }),
      }),
    );
  });

  it('rejects a second account for the same member', async () => {
    prisma.member.findUnique.mockResolvedValue({
      id: 'member-1',
      schoolId: 'school-1',
      associationMember: {},
      user: { id: 'existing-user' },
    });

    await expect(
      service.create({
        username: 'member002',
        password: 'securePass1!',
        fullName: 'Test Member',
        role: Role.MEMBER,
        memberId: 'member-1',
      }),
    ).rejects.toThrow(ConflictException);
  });
});
