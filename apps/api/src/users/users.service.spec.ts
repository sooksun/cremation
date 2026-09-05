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
  const service = new UsersService(prisma as never, { log: jest.fn() } as never, {
    canAccessAllSchools: () => true,
    assertResourceSchoolAccess: jest.fn(),
  } as never);

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

describe('UsersService school admin guards', () => {
  const prisma = {
    user: {
      findUnique: jest.fn(),
      update: jest.fn(),
    },
    member: {
      findUnique: jest.fn(),
    },
  };
  const service = new UsersService(prisma as never, { log: jest.fn() } as never, {
    canAccessAllSchools: () => true,
    assertResourceSchoolAccess: jest.fn(),
  } as never);

  const schoolAdmin = {
    id: 'user-admin-20',
    username: 'admin20',
    role: Role.SCHOOL_ADMIN,
    schoolId: 'school-20',
    memberId: null,
  };

  beforeEach(() => {
    jest.clearAllMocks();
    prisma.user.findUnique.mockResolvedValue(schoolAdmin);
    prisma.user.update.mockImplementation(async ({ data }) => ({
      ...schoolAdmin,
      ...data,
      passwordHash: 'x',
    }));
  });

  // ย้ายผู้ดูแลข้ามโรงเรียนทางนี้ได้ = โรงเรียนปลายทางมีผู้ดูแลสองคน
  // ซึ่งขัดกฎโรงเรียนละหนึ่งผู้ดูแลที่ SchoolAdminsService บังคับไว้
  it('ไม่ให้ย้ายผู้ดูแลโรงเรียนไปสังกัดโรงเรียนอื่นผ่าน PATCH /users/:id', async () => {
    await expect(service.update('user-admin-20', { schoolId: 'school-99' })).rejects.toThrow(
      'ผู้ดูแลโรงเรียนให้จัดการผ่านเมนูผู้ดูแลโรงเรียน',
    );
    expect(prisma.user.update).not.toHaveBeenCalled();
  });

  it('ไม่ให้ย้ายกลุ่มของผู้ดูแลโรงเรียนผ่านเส้นทางเดียวกัน', async () => {
    await expect(service.update('user-admin-20', { groupId: 'group-9' })).rejects.toThrow(
      'ผู้ดูแลโรงเรียนให้จัดการผ่านเมนูผู้ดูแลโรงเรียน',
    );
    expect(prisma.user.update).not.toHaveBeenCalled();
  });

  // PATCH /users/:id/signature เรียกเมธอดเดียวกันโดยส่งแค่ signature
  // ถ้ากันแบบเหมารวม ผู้ดูแลโรงเรียนจะบันทึกลายเซ็นตัวเองไม่ได้
  it('ยังให้ผู้ดูแลโรงเรียนบันทึกลายเซ็นของตัวเองได้', async () => {
    await expect(
      service.update('user-admin-20', { signature: 'data:image/png;base64,AA' }),
    ).resolves.toEqual(expect.objectContaining({ signature: 'data:image/png;base64,AA' }));
    expect(prisma.user.update).toHaveBeenCalled();
  });

  it('ยังกันการตั้งบทบาทเป็นผู้ดูแลโรงเรียนจากผู้ใช้ทั่วไป', async () => {
    prisma.user.findUnique.mockResolvedValue({ ...schoolAdmin, role: Role.FINANCE });
    await expect(
      service.update('user-admin-20', { role: Role.SCHOOL_ADMIN }),
    ).rejects.toThrow('ผู้ดูแลโรงเรียนให้จัดการผ่านเมนูผู้ดูแลโรงเรียน');
  });
});
