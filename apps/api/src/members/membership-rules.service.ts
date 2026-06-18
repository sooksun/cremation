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
  ): Record<string, unknown> {
    const extras: Record<string, unknown> = {};

    if (newStatus === MemberStatus.RESIGNED && date) {
      extras.resignDate = new Date(date);
      extras.membershipEndReason = MembershipEndReason.RESIGNED;
    } else if (newStatus === MemberStatus.DECEASED && date) {
      extras.deathDate = new Date(date);
      extras.membershipEndReason = MembershipEndReason.DECEASED;
    } else if (newStatus === MemberStatus.RESIGNED && memberTypeCode === 'RET') {
      extras.membershipEndReason = MembershipEndReason.RETIRED;
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

  async processArrearsAfterNotice(periodId: string) {
    const period = await this.prisma.contributionPeriod.findUnique({
      where: { id: periodId },
    });
    if (!period) return { noticeSent: 0, terminated: 0 };

    const arrearsContributions = await this.prisma.memberContribution.findMany({
      where: { periodId, isArrears: true, paidAmount: 0 },
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

      if (!member.arrearsNoticeSentAt) {
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

      const nextCount = member.consecutiveArrearsPeriods + 1;
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