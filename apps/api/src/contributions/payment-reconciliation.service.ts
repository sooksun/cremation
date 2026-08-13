import { Injectable, NotFoundException } from '@nestjs/common';
import { MemberStatus } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { ScopedUser, SchoolScopeService } from '../common/security/school-scope.service';
import { AppSettingsService } from '../common/services/app-settings.service';
import type { ParsedPaymentFile } from './payment-file.parser';

export type MissingReason = 'NOT_IN_FILE' | 'IN_FILE_NOT_PAID';

export interface MissingRow {
  memberId: string;
  contributionId: string | null;
  memberNo: string;
  fullName: string;
  schoolId: string;
  schoolCode: string;
  schoolName: string;
  groupName: string;
  amountDue: number;
  reason: MissingReason;
}

export interface ReconcileResult {
  scope: { fullDistrict: boolean; schools: Array<{ id: string; code: string; name: string }> };
  summary: {
    expected: number;
    paid: number;
    alreadyPaid: number;
    missingFromFile: number;
    inFileNotPaid: number;
    unknownInFile: number;
    markedArrears: number;
  };
  missing: MissingRow[];
  unknown: Array<{ rowNo: number; memberNo: string }>;
}

@Injectable()
export class PaymentReconciliationService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly schoolScope: SchoolScopeService,
    private readonly appSettings: AppSettingsService,
  ) {}

  async reconcile(params: {
    periodId: string;
    parsed: ParsedPaymentFile;
    paidNowMemberNos: Set<string>;
    actor?: ScopedUser;
    fullDistrict: boolean;
    autoMarkArrears: boolean;
  }): Promise<ReconcileResult> {
    const period = await this.prisma.contributionPeriod.findUnique({
      where: { id: params.periodId },
    });
    if (!period) {
      throw new NotFoundException('ไม่พบงวดที่ระบุ');
    }

    const fileMemberNos = [...new Set(params.parsed.rows.map((row) => row.memberNo))];
    const membersInFile = await this.prisma.member.findMany({
      where: { memberNo: { in: fileMemberNos } },
      select: { id: true, memberNo: true, schoolId: true },
    });

    const knownNos = new Set(membersInFile.map((m) => m.memberNo));
    const unknown = params.parsed.rows
      .filter((row) => !knownNos.has(row.memberNo))
      .map((row) => ({ rowNo: row.rowNo, memberNo: row.memberNo }));

    // ด่านสุดท้ายของสิทธิ์ — SCHOOL_ADMIN ถูกบังคับที่โรงเรียนตัวเองเสมอ ไม่ว่า client ส่งอะไรมา
    const forcedSchoolId = params.actor
      ? this.schoolScope.resolveSchoolId(params.actor)
      : undefined;
    const schoolIdsInFile = [...new Set(membersInFile.map((m) => m.schoolId))];

    let schoolIds: string[] | undefined;
    let effectiveFullDistrict = false;
    if (forcedSchoolId) {
      schoolIds = [forcedSchoolId];
    } else if (params.fullDistrict) {
      schoolIds = undefined;
      effectiveFullDistrict = true;
    } else {
      schoolIds = schoolIdsInFile;
    }

    const expectedMembers = await this.prisma.member.findMany({
      where: {
        status: { in: [MemberStatus.ACTIVE, MemberStatus.ARREARS] },
        ...(schoolIds ? { schoolId: { in: schoolIds } } : {}),
      },
      select: {
        id: true,
        memberNo: true,
        schoolId: true,
        school: { select: { id: true, code: true, name: true } },
        group: { select: { name: true } },
        associationMember: { select: { firstName: true, lastName: true } },
        contributions: {
          where: { periodId: params.periodId },
          select: { id: true, totalAmount: true, paidAmount: true },
        },
      },
      orderBy: [{ school: { name: 'asc' } }, { memberNo: 'asc' }],
    });

    const { totalAmount: defaultAmount } = await this.resolveAmounts(period);
    const fileMemberNoSet = new Set(fileMemberNos);

    const missing: MissingRow[] = [];
    const schools = new Map<string, { id: string; code: string; name: string }>();
    let paid = 0;
    let alreadyPaid = 0;

    for (const member of expectedMembers) {
      schools.set(member.school.id, member.school);
      const contribution = member.contributions[0];
      const isPaid = contribution ? Number(contribution.paidAmount) > 0 : false;

      if (isPaid) {
        if (params.paidNowMemberNos.has(member.memberNo)) paid++;
        else alreadyPaid++;
        continue;
      }

      missing.push({
        memberId: member.id,
        contributionId: contribution?.id ?? null,
        memberNo: member.memberNo,
        fullName: `${member.associationMember?.firstName ?? ''} ${member.associationMember?.lastName ?? ''}`.trim(),
        schoolId: member.schoolId,
        schoolCode: member.school.code,
        schoolName: member.school.name,
        groupName: member.group?.name ?? '',
        amountDue: contribution ? Number(contribution.totalAmount) : defaultAmount,
        reason: fileMemberNoSet.has(member.memberNo) ? 'IN_FILE_NOT_PAID' : 'NOT_IN_FILE',
      });
    }

    const markedArrears = params.autoMarkArrears
      ? await this.markMissingAsArrears(params.periodId, missing, defaultAmount, period)
      : 0;

    return {
      scope: { fullDistrict: effectiveFullDistrict, schools: [...schools.values()] },
      summary: {
        expected: expectedMembers.length,
        paid,
        alreadyPaid,
        missingFromFile: missing.filter((m) => m.reason === 'NOT_IN_FILE').length,
        inFileNotPaid: missing.filter((m) => m.reason === 'IN_FILE_NOT_PAID').length,
        unknownInFile: unknown.length,
        markedArrears,
      },
      missing,
      unknown,
    };
  }

  /**
   * ตั้งธงค้างชำระให้เฉพาะคนที่ขาด — ห้ามใช้ markArrearsForPeriod เพราะตัวนั้นเหมารวม
   * ทุกคนที่ยังไม่จ่ายทั้งงวด ซึ่งกว้างกว่าขอบเขตที่ไฟล์ครอบคลุม
   */
  private async markMissingAsArrears(
    periodId: string,
    missing: MissingRow[],
    defaultAmount: number,
    period: { welfareRate: unknown; serviceFee: unknown },
  ): Promise<number> {
    if (missing.length === 0) return 0;

    const existingIds = missing
      .map((row) => row.contributionId)
      .filter((id): id is string => id !== null);
    const withoutContribution = missing.filter((row) => row.contributionId === null);

    let marked = 0;

    if (existingIds.length > 0) {
      const updated = await this.prisma.memberContribution.updateMany({
        where: { id: { in: existingIds }, paidAmount: 0 },
        data: { isArrears: true },
      });
      marked += updated.count;
    }

    if (withoutContribution.length > 0) {
      const { welfareRate, serviceFee } = await this.resolveAmounts(period);
      const created = await this.prisma.memberContribution.createMany({
        data: withoutContribution.map((row) => ({
          memberId: row.memberId,
          periodId,
          schoolId: row.schoolId,
          welfareAmount: welfareRate,
          serviceAmount: serviceFee,
          totalAmount: defaultAmount,
          paidAmount: 0,
          isArrears: true,
        })),
      });
      marked += created.count;
    }

    return marked;
  }

  private async resolveAmounts(period: { welfareRate: unknown; serviceFee: unknown }) {
    const serviceFeeEnabled = await this.appSettings.isServiceFeeEnabled();
    const welfareRate = Number(period.welfareRate);
    const serviceFee = this.appSettings.effectiveServiceFee(
      Number(period.serviceFee),
      serviceFeeEnabled,
    );
    return { welfareRate, serviceFee, totalAmount: welfareRate + serviceFee };
  }
}
