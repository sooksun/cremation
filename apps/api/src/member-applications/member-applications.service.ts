import { BadRequestException, Injectable } from '@nestjs/common';
import { MemberStatus, ApplicationStatus, AuditAction } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { DocumentNumberService, DocumentType } from '../common/document-number.service';
import { SchoolScopeService, ScopedUser } from '../common/security/school-scope.service';
import { AuditLogService } from '../common/services/audit-log.service';
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
    private readonly schoolScope: SchoolScopeService,
    private readonly auditLog: AuditLogService,
  ) {}

  // Public: รายชื่อโรงเรียน active สำหรับ dropdown หน้าใบสมัคร (ไม่ต้อง login)
  async listSchoolsForRegistration() {
    return this.prisma.school.findMany({
      where: { isActive: true },
      select: { id: true, name: true, code: true },
      orderBy: { name: 'asc' },
    });
  }

  async submit(dto: SubmitApplicationDto) {
    const school = dto.schoolId
      ? await this.resolveSchoolById(dto.schoolId)
      : await this.resolveSchoolByAgency(dto.governmentAgency);

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
    const reg = dto.registeredAddress;
    const con = dto.contactAddress ?? dto.registeredAddress;
    const address = this.formatAddress(con); // derived string — คงไว้เพื่อ backward-compat การแสดงผล
    const phone = con?.phone ?? reg?.phone;

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
          registeredHouseNo: reg?.houseNo,
          registeredMoo: reg?.moo,
          registeredRoad: reg?.road,
          registeredSoi: reg?.soi,
          registeredSubdistrict: reg?.subdistrict,
          registeredDistrict: reg?.district,
          registeredProvince: reg?.province,
          registeredZip: reg?.zip,
          contactHouseNo: con?.houseNo,
          contactMoo: con?.moo,
          contactRoad: con?.road,
          contactSoi: con?.soi,
          contactSubdistrict: con?.subdistrict,
          contactDistrict: con?.district,
          contactProvince: con?.province,
          contactZip: con?.zip,
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
        nationalId: b.nationalId,
        houseNo: b.houseNo,
        moo: b.moo,
        road: b.road,
        soi: b.soi,
        subdistrict: b.subdistrict,
        district: b.district,
        province: b.province,
        zip: b.zip,
        phone: b.phone,
        contactPerson: b.contactPerson,
        contactPhone: b.contactPhone,
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

  private async resolveSchoolById(schoolId: string) {
    const school = await this.prisma.school.findFirst({
      where: { id: schoolId, isActive: true },
    });
    if (!school) {
      throw new BadRequestException('ไม่พบโรงเรียนที่เลือกในระบบ');
    }
    return school;
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

  // Admin: list recent applications (members with application data)
  async listApplications(schoolId?: string, limit = 20, actor?: ScopedUser) {
    const scopedSchoolId = actor
      ? this.schoolScope.resolveSchoolId(actor, schoolId)
      : schoolId;
    const where: any = {
      applicationSubmittedAt: { not: null },
    };
    if (scopedSchoolId) where.schoolId = scopedSchoolId;

    return this.prisma.member.findMany({
      where,
      take: limit,
      orderBy: { applicationSubmittedAt: 'desc' },
      include: {
        school: { select: { id: true, name: true, code: true } },
        associationMember: {
          include: { memberType: { select: { name: true } } },
        },
        beneficiaries: true,
      },
    });
  }

  async getApplication(id: string, actor?: ScopedUser) {
    const member = await this.prisma.member.findUnique({
      where: { id },
      include: {
        school: true,
        associationMember: { include: { memberType: true } },
        beneficiaries: true,
        protectedPersons: true,
      },
    });
    if (!member || !member.applicationSubmittedAt) {
      throw new BadRequestException('ไม่พบใบสมัคร');
    }
    if (actor) this.schoolScope.assertSchoolAccess(actor, member.schoolId);
    return member;
  }

  async approveApplication(
    id: string,
    actor?: ScopedUser,
    ipAddress?: string,
    cert?: { directorName?: string; committeeName?: string },
  ) {
    if (!actor) throw new BadRequestException('ไม่พบข้อมูลผู้อนุมัติ');
    const member = await this.prisma.member.findUnique({ where: { id } });
    if (!member || !member.applicationSubmittedAt) {
      throw new BadRequestException('ไม่พบใบสมัคร');
    }
    this.schoolScope.assertSchoolAccess(actor, member.schoolId);

    const approver = await this.prisma.user.findUnique({
      where: { id: actor.id },
      select: { fullName: true },
    });
    const now = new Date();
    const updated = await this.prisma.member.update({
      where: { id },
      data: {
        status: MemberStatus.ACTIVE,
        applicationStatus: ApplicationStatus.APPROVED,
        approvedById: actor.id,
        approvedAt: now,
        approverName: approver?.fullName,
        directorCertifiedName: cert?.directorName,
        directorCertifiedAt: cert?.directorName ? now : undefined,
        committeeCertifiedName: cert?.committeeName,
        committeeCertifiedAt: cert?.committeeName ? now : undefined,
      },
    });
    await this.auditLog.log({
      userId: actor.id,
      action: AuditAction.MEMBER_APPLICATION_APPROVE,
      entityType: 'Member',
      entityId: id,
      schoolId: member.schoolId,
      metadata: {
        memberNo: member.memberNo,
        directorName: cert?.directorName,
        committeeName: cert?.committeeName,
      },
      ipAddress,
    });
    return { message: 'อนุมัติใบสมัครและเปิดใช้งานสมาชิกแล้ว', member: updated };
  }

  async rejectApplication(
    id: string,
    actor?: ScopedUser,
    ipAddress?: string,
    reason?: string,
  ) {
    if (!actor) throw new BadRequestException('ไม่พบข้อมูลผู้ปฏิเสธ');
    const member = await this.prisma.member.findUnique({ where: { id } });
    if (!member || !member.applicationSubmittedAt) {
      throw new BadRequestException('ไม่พบใบสมัคร');
    }
    this.schoolScope.assertSchoolAccess(actor, member.schoolId);

    const updated = await this.prisma.member.update({
      where: { id },
      data: {
        applicationStatus: ApplicationStatus.REJECTED,
        rejectedById: actor.id,
        rejectedAt: new Date(),
        rejectReason: reason,
      },
    });
    await this.auditLog.log({
      userId: actor.id,
      action: AuditAction.MEMBER_APPLICATION_REJECT,
      entityType: 'Member',
      entityId: id,
      schoolId: member.schoolId,
      metadata: { memberNo: member.memberNo, reason },
      ipAddress,
    });
    return { message: 'ปฏิเสธใบสมัครแล้ว', member: updated };
  }
}
