import { BadRequestException } from '@nestjs/common';
import { MemberStatus } from '@prisma/client';
import { MemberApplicationsService } from './member-applications.service';

describe('MemberApplicationsService.submit', () => {
  const school = { id: 'school-1', name: 'โรงเรียนแม่ฟ้าหลวง', code: 'MFH' };
  const memberType = { id: 'type-1', code: 'REG' };

  const prisma: any = {
    // submit สร้าง AssociationMember กับ Member ในทรานแซกชันเดียว
    // mock ส่งตัวเองเป็น tx เพราะทดสอบพฤติกรรม ไม่ได้ทดสอบการ rollback จริง
    $transaction: jest.fn(async (fn: (tx: unknown) => unknown) => fn(prisma)),
    school: { findMany: jest.fn(), findUnique: jest.fn() },
    memberType: { findUnique: jest.fn() },
    associationMember: { findFirst: jest.fn(), create: jest.fn() },
    member: { findUnique: jest.fn(), create: jest.fn(), update: jest.fn() },
    user: { findUnique: jest.fn() },
    $queryRawUnsafe: jest.fn(),
  };

  const schoolScope = {
    assertSchoolAccess: jest.fn(),
    resolveSchoolId: jest.fn((_u: unknown, s?: string) => s),
  };
  const auditLog = { log: jest.fn() };

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
    schoolScope as never,
    auditLog as never,
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

  it('persists beneficiary identity, address, and contact fields from the registration form', async () => {
    const beneficiary = {
      name: 'สมหญิง ใจดี',
      relationship: 'คู่สมรส',
      nationalId: '1234567890123',
      houseNo: '99/1',
      moo: '2',
      road: 'ถนนทดสอบ',
      soi: 'ซอยทดสอบ',
      subdistrict: 'แม่ฟ้าหลวง',
      district: 'แม่ฟ้าหลวง',
      province: 'เชียงราย',
      zip: '57110',
      phone: '0812345678',
      contactPerson: 'สมชาย ใจดี',
      contactPhone: '0899999999',
    };

    await service.submit({ ...baseDto, beneficiaries: [beneficiary] } as never);

    expect(prisma.member.create).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          beneficiaries: {
            create: [
              {
                fullName: beneficiary.name,
                relationship: beneficiary.relationship,
                nationalId: beneficiary.nationalId,
                houseNo: beneficiary.houseNo,
                moo: beneficiary.moo,
                road: beneficiary.road,
                soi: beneficiary.soi,
                subdistrict: beneficiary.subdistrict,
                district: beneficiary.district,
                province: beneficiary.province,
                zip: beneficiary.zip,
                phone: beneficiary.phone,
                contactPerson: beneficiary.contactPerson,
                contactPhone: beneficiary.contactPhone,
                priority: 1,
              },
            ],
          },
        }),
      }),
    );
  });

  it('persists registered + contact address as structured fields (art. ใบสมัคร)', async () => {
    await service.submit({
      ...baseDto,
      registeredAddress: {
        houseNo: '99',
        moo: '2',
        subdistrict: 'แม่ฟ้าหลวง',
        district: 'แม่ฟ้าหลวง',
        province: 'เชียงราย',
        zip: '57240',
      },
      contactAddress: {
        houseNo: '10',
        road: 'พหลโยธิน',
        province: 'เชียงราย',
        zip: '57000',
        phone: '0810000000',
      },
    } as never);

    expect(prisma.associationMember.create).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          registeredHouseNo: '99',
          registeredSubdistrict: 'แม่ฟ้าหลวง',
          registeredProvince: 'เชียงราย',
          registeredZip: '57240',
          contactHouseNo: '10',
          contactRoad: 'พหลโยธิน',
          contactZip: '57000',
          phone: '0810000000',
        }),
      }),
    );
  });

  it('rejects fuzzy school lookup', async () => {
    await expect(
      service.submit({ ...baseDto, governmentAgency: 'แม่ฟ้าหลวง' } as never),
    ).rejects.toThrow(BadRequestException);
    expect(prisma.member.create).not.toHaveBeenCalled();
  });

  it('rejects submission if national ID is already registered as a cremation member in any school', async () => {
    prisma.associationMember.findFirst.mockResolvedValueOnce({
      id: 'am-dup',
      idCardNo: '1100701234567',
      schoolId: 'school-other',
      cremationMember: { id: 'm-dup', memberNo: 'M0099', status: MemberStatus.ACTIVE },
    });

    await expect(
      service.submit({ ...baseDto, nationalId: '1-1007-01234-56-7' } as never),
    ).rejects.toThrow(BadRequestException);
    expect(prisma.member.create).not.toHaveBeenCalled();
  });

  describe('checkNationalId', () => {
    it('returns exists true when national ID belongs to an existing cremation member', async () => {
      prisma.associationMember.findFirst.mockResolvedValueOnce({
        id: 'am-1',
        idCardNo: '1100701234567',
        cremationMember: { id: 'm-1', memberNo: 'M0001', status: MemberStatus.ACTIVE },
      });

      const result = await service.checkNationalId('1-1007-01234-56-7');
      expect(result.exists).toBe(true);
      expect(result.isMember).toBe(true);
    });

    it('returns exists false when national ID is not registered with cremation member', async () => {
      prisma.associationMember.findFirst.mockResolvedValueOnce(null);

      const result = await service.checkNationalId('1100709999999');
      expect(result.exists).toBe(false);
      expect(result.isMember).toBe(false);
    });

    it('returns exists false for invalid or short ID', async () => {
      const result = await service.checkNationalId('123');
      expect(result.exists).toBe(false);
      expect(prisma.associationMember.findFirst).not.toHaveBeenCalled();
    });
  });

  describe('searchAddresses', () => {
    it('returns default addresses when query is empty', async () => {
      const defaultMfl = [
        { id: 1, subdistrict: 'เทอดไทย', district: 'แม่ฟ้าหลวง', province: 'เชียงราย', zipCode: '57240' },
      ];
      prisma.$queryRawUnsafe.mockResolvedValueOnce(defaultMfl);

      const result = await service.searchAddresses('');
      expect(prisma.$queryRawUnsafe).toHaveBeenCalledWith(
        expect.stringContaining('province = \'เชียงราย\' AND district = \'แม่ฟ้าหลวง\''),
        20,
      );
      expect(result).toEqual(defaultMfl);
    });

    it('queries matching subdistricts when query is provided', async () => {
      const mockResult = [
        { id: 2, subdistrict: 'แม่สลองนอก', district: 'แม่ฟ้าหลวง', province: 'เชียงราย', zipCode: '57110' },
      ];
      prisma.$queryRawUnsafe.mockResolvedValueOnce(mockResult);

      const result = await service.searchAddresses('แม่สลอง', 10);
      expect(prisma.$queryRawUnsafe).toHaveBeenCalledWith(
        expect.stringContaining('WHERE subdistrict LIKE ?'),
        '%แม่สลอง%',
        '%แม่สลอง%',
        '%แม่สลอง%',
        '%แม่สลอง%',
        'แม่สลอง',
        'แม่สลอง%',
        'แม่สลอง',
        'แม่สลอง%',
        'แม่สลอง',
        10,
      );
      expect(result).toEqual(mockResult);
    });
  });

  describe('approveApplication / rejectApplication (art.15)', () => {
    const actorAdmin = { id: 'admin-1', role: 'ADMIN' };
    const actorOtherSchool = { id: 'sa-2', role: 'SCHOOL_ADMIN', schoolId: 's2' };

    beforeEach(() => {
      prisma.user.findUnique.mockResolvedValue({ id: 'admin-1', fullName: 'ผู้ดูแล ระบบ' });
      prisma.member.update.mockResolvedValue({ id: 'm1', status: MemberStatus.ACTIVE });
    });

    it('approve records approver, certification, audit and activates member', async () => {
      prisma.member.findUnique.mockResolvedValue({
        id: 'm1',
        schoolId: 's1',
        applicationSubmittedAt: new Date(),
      });

      await service.approveApplication('m1', actorAdmin as never, '127.0.0.1', {
        directorName: 'ผอ.ก',
        committeeName: 'กก.ข',
      });

      expect(schoolScope.assertSchoolAccess).toHaveBeenCalledWith(actorAdmin, 's1');
      expect(prisma.member.update).toHaveBeenCalledWith(
        expect.objectContaining({
          where: { id: 'm1' },
          data: expect.objectContaining({
            status: MemberStatus.ACTIVE,
            applicationStatus: 'APPROVED',
            approvedById: 'admin-1',
            approverName: 'ผู้ดูแล ระบบ',
            directorCertifiedName: 'ผอ.ก',
            committeeCertifiedName: 'กก.ข',
          }),
        }),
      );
      expect(auditLog.log).toHaveBeenCalledWith(
        expect.objectContaining({ action: 'MEMBER_APPLICATION_APPROVE', entityId: 'm1' }),
      );
    });

    it('reject records reason + audit without activating', async () => {
      prisma.member.findUnique.mockResolvedValue({
        id: 'm1',
        schoolId: 's1',
        applicationSubmittedAt: new Date(),
      });

      await service.rejectApplication('m1', actorAdmin as never, '127.0.0.1', 'เอกสารไม่ครบ');

      expect(prisma.member.update).toHaveBeenCalledWith(
        expect.objectContaining({
          data: expect.objectContaining({
            applicationStatus: 'REJECTED',
            rejectReason: 'เอกสารไม่ครบ',
            rejectedById: 'admin-1',
          }),
        }),
      );
      expect(auditLog.log).toHaveBeenCalledWith(
        expect.objectContaining({ action: 'MEMBER_APPLICATION_REJECT', entityId: 'm1' }),
      );
    });

    it('throws when actor cannot access the application school', async () => {
      prisma.member.findUnique.mockResolvedValue({
        id: 'm1',
        schoolId: 's1',
        applicationSubmittedAt: new Date(),
      });
      schoolScope.assertSchoolAccess.mockImplementationOnce(() => {
        throw new BadRequestException('no access');
      });

      await expect(
        service.approveApplication('m1', actorOtherSchool as never, '127.0.0.1'),
      ).rejects.toThrow();
      expect(prisma.member.update).not.toHaveBeenCalled();
    });
  });

  /**
   * เดิมสร้าง AssociationMember แล้วค่อยสร้าง Member แยกกัน
   * ถ้าขั้นที่สองล้ม จะเหลือ AssociationMember ที่ไม่มีสมาชิกผูกค้างไว้
   * เป็นแถวขยะชนิดเดียวกับที่เคยต้องตามลบบน production
   */
  it('สร้างคนและสมาชิกในทรานแซกชันเดียว ไม่เหลือข้อมูลค้างเมื่อขั้นที่สองล้ม', async () => {
    prisma.member.create.mockRejectedValueOnce(new Error('memberNo ซ้ำ'));

    await expect(service.submit(baseDto as never)).rejects.toThrow('memberNo ซ้ำ');

    // การสร้างทั้งสองต้องอยู่ในทรานแซกชันเดียวกัน ฐานข้อมูลจึงย้อนกลับให้เอง
    expect(prisma.$transaction).toHaveBeenCalledTimes(1);
    const txCallOrder = prisma.$transaction.mock.invocationCallOrder[0];
    const amCallOrder = prisma.associationMember.create.mock.invocationCallOrder[0];
    expect(amCallOrder).toBeGreaterThan(txCallOrder);
  });

});
