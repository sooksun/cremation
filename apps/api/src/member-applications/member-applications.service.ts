import { BadRequestException, Injectable } from '@nestjs/common';
import { MemberStatus } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { DocumentNumberService, DocumentType } from '../common/document-number.service';
import { MembershipRulesService } from '../members/membership-rules.service';
import { ProtectedPersonsService } from '../members/protected-persons.service';
import { resolveMembershipClass, splitFullName } from '../members/membership.constants';
import { SubmitApplicationDto } from './dto/submit-application.dto';
import {
  matchSchoolByAgency,
  schoolLookupErrorMessage,
} from './member-applications-school.util';

@Injectable()
export class MemberApplicationsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly documentNumberService: DocumentNumberService,
    private readonly membershipRules: MembershipRulesService,
    private readonly protectedPersons: ProtectedPersonsService,
  ) {}

  async submit(dto: SubmitApplicationDto) {
    const school = await this.resolveSchoolByAgency(dto.governmentAgency);

    const { firstName, lastName } = splitFullName(dto.fullName);
    const memberTypeCode = dto.type === 'ordinary' ? 'REG' : 'STF';
    const memberType = await this.prisma.memberType.findUnique({
      where: { code: memberTypeCode },
    });
    if (!memberType) {
      throw new BadRequestException('ไม่พบประเภทสมาชิกในระบบ');
    }

    if (dto.nationalId) {
      const duplicate = await this.prisma.associationMember.findFirst({
        where: { schoolId: school.id, idCardNo: dto.nationalId },
        include: { cremationMember: true },
      });
      if (duplicate?.cremationMember) {
        throw new BadRequestException('มีใบสมัคร/สมาชิกที่ใช้เลขบัตรประชาชนนี้แล้ว');
      }
    }

    const joinDate = dto.applicationDate ? new Date(dto.applicationDate) : new Date();
    const address = this.formatAddress(dto.contactAddress ?? dto.registeredAddress);
    const phone = dto.contactAddress?.phone ?? dto.registeredAddress?.phone;

    const membershipClass = resolveMembershipClass({
      memberTypeCode,
      formType: dto.type,
      salaryDeduction: dto.type === 'ordinary',
    });

    const existingAm = dto.nationalId
      ? await this.prisma.associationMember.findFirst({
          where: { schoolId: school.id, idCardNo: dto.nationalId },
        })
      : null;

    const associationMember =
      existingAm ??
      (await this.prisma.associationMember.create({
        data: {
          schoolId: school.id,
          memberTypeId: memberType.id,
          firstName,
          lastName,
          idCardNo: dto.nationalId,
          birthDate: dto.birthDate ? new Date(dto.birthDate) : undefined,
          address,
          phone,
          associationJoinDate: joinDate,
        },
      }));

    const existingMember = await this.prisma.member.findUnique({
      where: { associationMemberId: associationMember.id },
    });
    if (existingMember) {
      throw new BadRequestException('สมาชิกนี้มีในระบบแล้ว');
    }

    const memberNo =
      dto.memberNo?.trim() ||
      (await this.documentNumberService.generateNumber(DocumentType.MEMBER));

    const membershipFields = this.membershipRules.buildCreateMembershipFields({
      joinDate,
      memberTypeCode,
      salaryDeduction: dto.type === 'ordinary',
      membershipClass,
      applicationSubmittedAt: new Date(),
    });

    const beneficiaryRows = (dto.beneficiaries ?? [])
      .filter((b) => b.name?.trim())
      .slice(0, 3)
      .map((b, i) => ({
        fullName: b.name!.trim(),
        relationship: b.relationship?.trim() || '-',
        phone: b.phone,
        priority: i + 1,
      }));

    const protectedInputs = this.membershipRules.buildProtectedPersonsFromForm({
      maritalStatus: dto.maritalStatus,
      spouseName: dto.spouseName,
      bloodRelatives: (dto.bloodRelatives ?? [])
        .filter((r) => r.name?.trim())
        .map((r) => ({ name: r.name!.trim(), relationship: r.relationship ?? '' })),
    });

    const member = await this.prisma.member.create({
      data: {
        associationMemberId: associationMember.id,
        memberNo,
        schoolId: school.id,
        joinDate,
        status: MemberStatus.SUSPENDED,
        salaryDeduction: dto.type === 'ordinary',
        ...membershipFields,
        beneficiaries: beneficiaryRows.length
          ? { create: beneficiaryRows }
          : undefined,
      },
      include: {
        school: true,
        associationMember: { include: { memberType: true } },
        beneficiaries: { orderBy: { priority: 'asc' } },
      },
    });

    if (protectedInputs.length > 0) {
      await this.protectedPersons.syncForMember(member.id, protectedInputs);
    }

    return {
      message: 'ส่งใบสมัครสำเร็จ เจ้าหน้าที่จะตรวจสอบและยืนยันสมาชิกภาพ',
      memberId: member.id,
      memberNo: member.memberNo,
      status: member.status,
      membershipClass: member.membershipClass,
      applicationDeadline: member.applicationDeadline,
      school: member.school.name,
    };
  }

  private async resolveSchoolByAgency(agency: string) {
    const schools = await this.prisma.school.findMany({
      where: { isActive: true },
      select: { id: true, name: true, code: true },
    });

    const match = matchSchoolByAgency(agency, schools);
    if (match.kind !== 'one') {
      throw new BadRequestException(schoolLookupErrorMessage(match));
    }

    const school = await this.prisma.school.findUnique({ where: { id: match.school.id } });
    if (!school) {
      throw new BadRequestException('ไม่พบโรงเรียนในระบบ');
    }
    return school;
  }

  private formatAddress(addr?: {
    houseNo?: string;
    moo?: string;
    road?: string;
    soi?: string;
    subdistrict?: string;
    district?: string;
    province?: string;
    zip?: string;
    phone?: string;
  }) {
    if (!addr) return undefined;
    const parts = [
      addr.houseNo && `เลขที่ ${addr.houseNo}`,
      addr.moo && `หมู่ ${addr.moo}`,
      addr.road && `ถนน ${addr.road}`,
      addr.soi && `ซอย ${addr.soi}`,
      addr.subdistrict && `ต.${addr.subdistrict}`,
      addr.district && `อ.${addr.district}`,
      addr.province && `จ.${addr.province}`,
      addr.zip,
    ].filter(Boolean);
    return parts.length ? parts.join(' ') : undefined;
  }
}