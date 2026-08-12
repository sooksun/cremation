import { Injectable } from '@nestjs/common';
import {
  MembershipClass,
  MembershipEndReason,
  MemberStatus,
  ProtectedRelationship,
} from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import {
  ARREARS_TERMINATION_PERIODS,
  computeApplicationDeadline,
  parseProtectedRelationship,
  resolveMembershipClass,
} from './membership.constants';

export interface ProtectedPersonInput {
  fullName: string;
  relationship: ProtectedRelationship;
  nationalId?: string;
  phone?: string;
}

@Injectable()
export class MembershipRulesService {
  constructor(private readonly prisma: PrismaService) {}

  inferMembershipClass(
    memberTypeCode: string,
    salaryDeduction?: boolean,
    explicitClass?: MembershipClass,
  ): MembershipClass {
    return resolveMembershipClass({ memberTypeCode, salaryDeduction, explicitClass });
  }

  buildProtectedPersonsFromForm(params: {
    maritalStatus?: 'single' | 'married';
    spouseName?: string;
    bloodRelatives?: { name: string; relationship: string }[];
  }): ProtectedPersonInput[] {
    const persons: ProtectedPersonInput[] = [];
    const seen = new Set<string>();

    const add = (fullName: string, relationship: ProtectedRelationship) => {
      const key = `${relationship}:${fullName.trim()}`;
      if (!fullName.trim() || seen.has(key)) return;
      seen.add(key);
      persons.push({ fullName: fullName.trim(), relationship });
    };

    if (params.maritalStatus === 'married' && params.spouseName?.trim()) {
      add(params.spouseName, ProtectedRelationship.SPOUSE);
    }

    for (const rel of params.bloodRelatives ?? []) {
      if (!rel.name?.trim()) continue;
      const parsed = parseProtectedRelationship(rel.relationship);
      if (parsed) add(rel.name, parsed);
    }

    return persons;
  }

  async deactivateProtectedPersons(memberId: string, endReason: string) {
    await this.prisma.protectedPerson.updateMany({
      where: { memberId, isActive: true },
      data: { isActive: false, endedAt: new Date(), endReason },
    });
  }

  getStatusChangeExtras(
    newStatus: MemberStatus,
    memberTypeCode?: string,
    date?: string,
    explicitEndReason?: MembershipEndReason,
  ): Record<string, unknown> {
    const extras: Record<string, unknown> = {};

    // กู้คืนสมาชิกกลับมาปกติ — ล้างร่องรอยการสิ้นสุดสมาชิกภาพทิ้ง ไม่งั้นจะค้างอยู่ในรายการที่ย้ายออก
    if (newStatus === MemberStatus.ACTIVE) {
      extras.resignDate = null;
      extras.deathDate = null;
      extras.membershipEndReason = null;
      return extras;
    }

    if (newStatus === MemberStatus.RESIGNED && date) {
      // ครูเกษียณ (RET) แยกเหตุสิ้นสุดสมาชิกภาพเป็น RETIRED ตามระเบียบ ข้อ 9.1.3
      extras.resignDate = new Date(date);
      extras.membershipEndReason =
        memberTypeCode === 'RET'
          ? MembershipEndReason.RETIRED
          : MembershipEndReason.RESIGNED;
    } else if (newStatus === MemberStatus.DECEASED && date) {
      extras.deathDate = new Date(date);
      extras.membershipEndReason = MembershipEndReason.DECEASED;
    } else if (newStatus === MemberStatus.RESIGNED && memberTypeCode === 'RET') {
      extras.membershipEndReason = MembershipEndReason.RETIRED;
    }

    // เหตุที่ผู้ใช้ระบุเอง (เช่น TRANSFERRED ย้ายออกนอกเขต) ชนะค่าที่อนุมานได้
    // แต่ห้ามขัดกับข้อเท็จจริงว่าสมาชิกเสียชีวิต
    if (explicitEndReason && newStatus !== MemberStatus.DECEASED) {
      extras.membershipEndReason = explicitEndReason;
    }

    return extras;
  }

  async applyStatusSideEffects(
    memberId: string,
    newStatus: MemberStatus,
    memberTypeCode?: string,
  ) {
    if (
      newStatus === MemberStatus.DECEASED ||
      newStatus === MemberStatus.RESIGNED ||
      (newStatus === MemberStatus.SUSPENDED && memberTypeCode === 'RET')
    ) {
      const reason =
        memberTypeCode === 'RET' && newStatus === MemberStatus.RESIGNED
          ? 'เกษียณอายุ'
          : newStatus === MemberStatus.DECEASED
            ? 'สมาชิกเสียชีวิต'
            : 'สิ้นสุดสมาชิกภาพ';
      await this.deactivateProtectedPersons(memberId, reason);
    }
  }

  buildCreateMembershipFields(params: {
    joinDate: Date;
    memberTypeCode: string;
    salaryDeduction?: boolean;
    membershipClass?: MembershipClass;
    applicationSubmittedAt?: Date;
  }) {
    const membershipClass = resolveMembershipClass({
      memberTypeCode: params.memberTypeCode,
      salaryDeduction: params.salaryDeduction,
      explicitClass: params.membershipClass,
    });

    return {
      membershipClass,
      applicationDeadline: computeApplicationDeadline(params.joinDate),
      applicationSubmittedAt: params.applicationSubmittedAt ?? null,
      consecutiveArrearsPeriods: 0,
    };
  }

  async resetArrearsTracking(memberId: string) {
    await this.prisma.member.update({
      where: { id: memberId },
      data: {
        consecutiveArrearsPeriods: 0,
        arrearsNoticeSentAt: null,
        status: MemberStatus.ACTIVE,
      },
    });
  }

  async processArrearsAfterNotice(periodId: string, schoolId?: string) {
    const period = await this.prisma.contributionPeriod.findUnique({
      where: { id: periodId },
    });
    if (!period) return { noticeSent: 0, terminated: 0 };

    const arrearsContributions = await this.prisma.memberContribution.findMany({
      where: {
        periodId,
        isArrears: true,
        paidAmount: 0,
        arrearsNoticeSentAt: null,
        ...(schoolId ? { schoolId } : {}),
      },
      include: {
        member: {
          include: { associationMember: { include: { memberType: true } } },
        },
      },
    });

    const now = new Date();
    let noticeSent = 0;
    let terminated = 0;

    for (const contribution of arrearsContributions) {
      const member = contribution.member;
      if (member.membershipClass !== MembershipClass.CONTRIBUTORY) continue;
      if (member.status !== MemberStatus.ACTIVE && member.status !== MemberStatus.ARREARS) {
        continue;
      }

      await this.prisma.memberContribution.update({
        where: { id: contribution.id },
        data: { arrearsNoticeSentAt: now },
      });

      const isFirstNotice = !member.arrearsNoticeSentAt;
      const nextCount = isFirstNotice ? 1 : member.consecutiveArrearsPeriods + 1;

      if (isFirstNotice) {
        await this.prisma.member.update({
          where: { id: member.id },
          data: {
            arrearsNoticeSentAt: now,
            status: MemberStatus.ARREARS,
            consecutiveArrearsPeriods: 1,
          },
        });
        noticeSent++;
        continue;
      }

      if (nextCount >= ARREARS_TERMINATION_PERIODS) {
        await this.prisma.member.update({
          where: { id: member.id },
          data: {
            status: MemberStatus.RESIGNED,
            resignDate: now,
            membershipEndReason: MembershipEndReason.ARREARS_TERMINATED,
            consecutiveArrearsPeriods: nextCount,
          },
        });
        await this.deactivateProtectedPersons(member.id, 'ค้างชำระ 3 งวด');
        terminated++;
      } else {
        await this.prisma.member.update({
          where: { id: member.id },
          data: {
            status: MemberStatus.ARREARS,
            consecutiveArrearsPeriods: nextCount,
          },
        });
      }
    }

    return { noticeSent, terminated };
  }
}