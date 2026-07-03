import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { DocumentNumberService, DocumentType } from '../common/document-number.service';
import { MembersService } from '../members/members.service';

import { CreateDeathClaimDto } from './dto/create-death-claim.dto';
import { RecordBenefitPaymentDto } from './dto/record-payment.dto';
import {
  AuditAction,
  DeathClaimStatus,
  DeathClaimType,
  DeceasedType,
  MemberStatus,
  Prisma,
} from '@prisma/client';
import { SchoolScopeService, ScopedUser } from '../common/security/school-scope.service';
import { AuditLogService } from '../common/services/audit-log.service';
import { DeathBenefitCalculatorService } from './death-benefit-calculator.service';
import {
  relationshipMatchesDeceasedType,
  resolveDeceasedType,
  toClaimType,
} from './death-claim-deceased.constants';
import { UpdateDeathClaimWorkflowDto } from './dto/update-workflow.dto';
import { UpdateDeathClaimDocumentsDto } from './dto/update-documents.dto';
import {
  buildDefaultDocumentChecklist,
  computeWorkflowDeadlines,
  deriveStatusAfterCollection,
  isChecklistComplete,
  parseDocumentChecklist,
  resolveWorkflowStatus,
} from './death-claim-workflow.constants';

@Injectable()
export class DeathClaimsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly documentNumberService: DocumentNumberService,
    private readonly membersService: MembersService,

    private readonly schoolScope: SchoolScopeService,
    private readonly auditLog: AuditLogService,
    private readonly benefitCalculator: DeathBenefitCalculatorService,
  ) {}

  async previewCalculation(params: {
    claimType?: DeathClaimType;
    excludeMemberId?: string;
    otherDeductions?: number;
  }) {
    return this.benefitCalculator.calculate({
      claimType: params.claimType,
      excludeMemberId: params.excludeMemberId,
      otherDeductions: params.otherDeductions,
    });
  }

  async create(dto: CreateDeathClaimDto, actor?: ScopedUser, ipAddress?: string) {
    const member = await this.membersService.findById(dto.memberId);

    if (dto.schoolId !== member.schoolId) {
      throw new BadRequestException('โรงเรียนไม่ตรงกับข้อมูลสมาชิก');
    }

    if (actor) {
      this.schoolScope.assertSchoolAccess(actor, dto.schoolId);
    }

    const claimType =
      dto.claimType ??
      (dto.deceasedType ? toClaimType(dto.deceasedType) : DeathClaimType.MEMBER_DEATH);
    const deceasedType = resolveDeceasedType(claimType, dto.deceasedType);

    if (claimType === DeathClaimType.MEMBER_DEATH) {
      if (member.status === MemberStatus.DECEASED) {
        throw new BadRequestException('สมาชิกนี้เสียชีวิตแล้ว');
      }
    } else {
      await this.validateProtectedDeath(dto, deceasedType);
    }

    const am = member.associationMember;
    const memberFullName = am ? `${am.firstName} ${am.lastName}` : member.memberNo;
    const mainBeneficiary =
      claimType === DeathClaimType.PROTECTED_DEATH
        ? dto.mainBeneficiary?.trim() || memberFullName
        : dto.mainBeneficiary;

    const protectedContext =
      claimType === DeathClaimType.PROTECTED_DEATH
        ? await this.resolveProtectedPerson(dto, deceasedType)
        : null;

    const calc = await this.benefitCalculator.calculate({
      claimType,
      excludeMemberId:
        claimType === DeathClaimType.MEMBER_DEATH ? dto.memberId : undefined,
      otherDeductions: dto.otherDeductions,
    });

    const claimNo = await this.documentNumberService.generateNumber(DocumentType.DEATH_CLAIM);

    const reportedDate = new Date(dto.reportedDate);
    const deathDate = new Date(dto.deathDate);
    const workflow = computeWorkflowDeadlines({
      deathDate,
      reportedDate,
      membershipClass: member.membershipClass,
      salaryDeduction: member.salaryDeduction,
    });
    const documentChecklist = buildDefaultDocumentChecklist({
      claimType,
      membershipClass: member.membershipClass,
      salaryDeduction: member.salaryDeduction,
    });

    const openClaim = await this.prisma.deathClaim.findFirst({
      where: { memberId: dto.memberId, payment: null },
    });
    if (openClaim) {
      throw new BadRequestException(
        'มีรายการแจ้งเสียชีวิตที่ยังดำเนินการอยู่สำหรับสมาชิกนี้',
      );
    }

    const claimData = {
      memberId: dto.memberId,
      schoolId: dto.schoolId,
      claimNo,
      claimType,
      deceasedType: protectedContext?.deceasedType ?? deceasedType,
      deceasedName: protectedContext?.deceasedName ?? dto.deceasedName,
      relationshipNote: dto.relationshipNote,
      protectedPersonId: protectedContext?.protectedPersonId,
      reportedDate,
      deathDate,
      causeOfDeath: dto.causeOfDeath,
      mainBeneficiary,
      beneficiaryPhone: dto.beneficiaryPhone,
      activeMemberCount: calc.payingMemberCount,
      welfareRate: calc.collectionRate,
      totalContribution: calc.grossCollected,
      associationSupport: calc.fundReserve,
      payoutRatio: calc.payoutRatio,
      otherDeductions: calc.otherDeductions,
      netToPay: calc.netToPay,
      isFixedBenefit: calc.isFixedAmount ?? false,
      fixedBenefitAmount: calc.fixedAmount != null ? new Prisma.Decimal(calc.fixedAmount) : null,
      status: DeathClaimStatus.REPORTED,
      collectionChannel: workflow.collectionChannel,
      notifyAuthorityDeadline: workflow.notifyAuthorityDeadline,
      collectionDeadline: workflow.collectionDeadline,
      documentDeadline: workflow.documentDeadline,
      paymentDeadline: workflow.paymentDeadline,
      documentChecklist: documentChecklist as unknown as Prisma.InputJsonValue,
    };

    const deathClaim = await this.prisma.$transaction(async (tx) => {
      const claim = await tx.deathClaim.create({
        data: claimData,
        include: this.claimInclude,
      });

      if (claimType === DeathClaimType.MEMBER_DEATH) {
        await this.membersService.markMemberDeceasedInTransaction(
          tx,
          dto.memberId,
          dto.deathDate,
        );
      } else if (protectedContext?.protectedPersonId) {
        await tx.protectedPerson.update({
          where: { id: protectedContext.protectedPersonId },
          data: {
            isActive: false,
            endedAt: new Date(dto.deathDate),
            endReason: `เสียชีวิต (${protectedContext.deceasedName})`,
          },
        });
      }

      return claim;
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.DEATH_CLAIM_CREATE,
        entityType: 'DeathClaim',
        entityId: deathClaim.id,
        schoolId: dto.schoolId,
        metadata: {
          claimNo: deathClaim.claimNo,
          netToPay: Number(deathClaim.netToPay),
          claimType: calc.claimType,
          deceasedType: deathClaim.deceasedType,
          collectionRate: calc.collectionRate,
        },
        ipAddress,
      });
    }

    return deathClaim;
  }

  private claimInclude = {
    member: {
      include: {
        school: true,
        associationMember: { include: { memberType: true } },
        beneficiaries: true,
        protectedPersons: true,
      },
    },
    school: true,
    protectedPerson: true,
    approvedBy: { select: { id: true, fullName: true, role: true } },
  };

  private async validateProtectedDeath(dto: CreateDeathClaimDto, deceasedType: DeceasedType) {
    if (deceasedType === DeceasedType.MEMBER) {
      throw new BadRequestException('ประเภทผู้เสียชีวิตไม่ถูกต้องสำหรับเคลมญาติที่คุ้มครอง');
    }
    if (!dto.protectedPersonId) {
      throw new BadRequestException('กรุณาเลือกผู้เสียชีวิตจากรายชื่อผู้ได้รับการคุ้มครอง');
    }
  }

  private async resolveProtectedPerson(dto: CreateDeathClaimDto, deceasedType: DeceasedType) {
    const person = await this.prisma.protectedPerson.findFirst({
      where: { id: dto.protectedPersonId, memberId: dto.memberId, isActive: true },
    });
    if (!person) {
      throw new BadRequestException('ไม่พบผู้ได้รับการคุ้มครองที่ยังมีสิทธิ');
    }
    if (!relationshipMatchesDeceasedType(person.relationship, deceasedType)) {
      throw new BadRequestException('ประเภทผู้เสียชีวิตไม่ตรงกับความสัมพันธ์ที่คุ้มครอง');
    }
    return {
      protectedPersonId: person.id,
      deceasedName: person.fullName,
      deceasedType,
    };
  }

  async findAll(schoolId?: string, year?: number, actor?: ScopedUser) {
    const scopedSchoolId = actor
      ? this.schoolScope.resolveSchoolId(actor, schoolId)
      : schoolId;
    const where: any = {};
    if (scopedSchoolId) where.schoolId = scopedSchoolId;
    if (year) {
      where.reportedDate = {
        gte: new Date(`${year}-01-01`),
        lt: new Date(`${year + 1}-01-01`),
      };
    }

    return this.prisma.deathClaim.findMany({
      where,
      include: {
        member: {
          select: {
            id: true,
            memberNo: true,
            associationMember: { select: { firstName: true, lastName: true, memberType: true } },
          },
        },
        school: true,
        protectedPerson: true,
        payment: {
          include: { bankAccount: true },
        },
      },
      orderBy: { reportedDate: 'desc' },
    });
  }

  async findById(id: string, actor?: ScopedUser) {
    const claim = await this.prisma.deathClaim.findUnique({
      where: { id },
      include: {
        ...this.claimInclude,
        payment: {
          include: { bankAccount: true, voucher: true },
        },
      },
    });

    if (!claim) {
      throw new NotFoundException('ไม่พบรายการแจ้งเสียชีวิต');
    }

    if (actor) {
      this.schoolScope.assertSchoolAccess(actor, claim.schoolId);
    }

    return claim;
  }

  async getPrintData(id: string, actor?: ScopedUser) {
    const claim = await this.findById(id, actor);
    const am = claim.member.associationMember;

    return {
      ...claim,
      printMeta: {
        printedAt: new Date().toISOString(),
        memberFullName: am ? `${am.firstName} ${am.lastName}` : '',
        schoolName: claim.school.name,
      },
    };
  }

  async updateWorkflow(
    id: string,
    dto: UpdateDeathClaimWorkflowDto,
    actor?: ScopedUser,
    ipAddress?: string,
  ) {
    const claim = await this.findById(id, actor);

    if (claim.status === DeathClaimStatus.PAID || claim.payment) {
      throw new BadRequestException('รายการนี้จ่ายเงินแล้ว ไม่สามารถแก้ไข workflow ได้');
    }

    if (dto.startCollecting && claim.status !== DeathClaimStatus.REPORTED) {
      throw new BadRequestException(
        'สามารถเริ่มเก็บเงินได้เฉพาะรายการที่สถานะ "แจ้งแล้ว" เท่านั้น',
      );
    }

    const targetAmount = Number(claim.totalContribution);
    const collectedAmountChanged = dto.collectedAmount !== undefined;
    const collectedAmount = collectedAmountChanged
      ? dto.collectedAmount!
      : Number(claim.collectedAmount);

    const status = resolveWorkflowStatus({
      currentStatus: claim.status,
      collectedAmount,
      targetAmount,
      documentsComplete: claim.documentsComplete,
      startCollecting: dto.startCollecting,
      collectedAmountChanged,
    });

    const collectionCompletedAt =
      collectedAmount >= targetAmount
        ? claim.collectionCompletedAt ?? new Date()
        : null;

    const updated = await this.prisma.deathClaim.update({
      where: { id },
      data: {
        status,
        collectedAmount,
        collectionCompletedAt,
        workflowNotes: dto.workflowNotes,
      },
      include: {
        ...this.claimInclude,
        payment: { include: { bankAccount: true, voucher: true } },
      },
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.DEATH_CLAIM_CREATE,
        entityType: 'DeathClaim',
        entityId: id,
        schoolId: claim.schoolId,
        metadata: { workflow: true, status, collectedAmount },
        ipAddress,
      });
    }

    return updated;
  }

  async updateDocuments(
    id: string,
    dto: UpdateDeathClaimDocumentsDto,
    actor?: ScopedUser,
    ipAddress?: string,
  ) {
    const claim = await this.findById(id, actor);

    if (claim.status === DeathClaimStatus.PAID || claim.payment) {
      throw new BadRequestException('รายการนี้จ่ายเงินแล้ว ไม่สามารถแก้ไขเอกสารได้');
    }

    const checklist = parseDocumentChecklist(claim.documentChecklist);
    const now = new Date().toISOString();
    const itemMap = new Map(dto.items.map((i) => [i.key, i.checked]));

    const updatedChecklist = checklist.map((item) => {
      if (!itemMap.has(item.key)) return item;
      const checked = itemMap.get(item.key)!;
      return {
        ...item,
        checked,
        checkedAt: checked ? now : undefined,
      };
    });

    const documentsComplete =
      dto.documentsComplete ?? isChecklistComplete(updatedChecklist);

    const targetAmount = Number(claim.totalContribution);
    const collectedAmount = Number(claim.collectedAmount);
    let status = claim.status;
    if (documentsComplete && collectedAmount >= targetAmount) {
      status = DeathClaimStatus.READY_TO_PAY;
    } else if (collectedAmount >= targetAmount) {
      status = DeathClaimStatus.FUND_COMPLETE;
    }

    const updated = await this.prisma.deathClaim.update({
      where: { id },
      data: {
        documentChecklist: updatedChecklist as unknown as Prisma.InputJsonValue,
        documentsComplete,
        status,
      },
      include: {
        ...this.claimInclude,
        payment: { include: { bankAccount: true, voucher: true } },
      },
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.DEATH_CLAIM_CREATE,
        entityType: 'DeathClaim',
        entityId: id,
        schoolId: claim.schoolId,
        metadata: { documents: true, documentsComplete },
        ipAddress,
      });
    }

    return updated;
  }

  async approveDisbursement(
    id: string,
    actor?: ScopedUser,
    ipAddress?: string,
  ) {
    if (!actor) {
      throw new BadRequestException('ไม่พบข้อมูลผู้อนุมัติ');
    }

    const claim = await this.findById(id, actor);

    if (claim.payment) {
      throw new BadRequestException('รายการนี้จ่ายเงินแล้ว');
    }

    if (claim.approvedAt) {
      throw new BadRequestException('รายการนี้ได้รับการอนุมัติเบิกแล้ว');
    }

    if (claim.status !== DeathClaimStatus.READY_TO_PAY) {
      throw new BadRequestException('รายการยังไม่พร้อมอนุมัติเบิก (ต้องเก็บเงินและเอกสารครบ)');
    }

    const approver = await this.prisma.user.findUnique({
      where: { id: actor.id },
      select: { id: true, fullName: true, signature: true, role: true },
    });

    if (!approver?.signature) {
      throw new BadRequestException('กรุณาลงลายเซ็นอิเล็กทรอนิกส์ก่อนอนุมัติเบิก (ข้อ 13.6)');
    }

    const updated = await this.prisma.deathClaim.update({
      where: { id },
      data: {
        approvedById: approver.id,
        approvedAt: new Date(),
        approverName: approver.fullName,
        approverSignature: approver.signature,
      },
      include: {
        ...this.claimInclude,
        approvedBy: { select: { id: true, fullName: true, role: true } },
        payment: { include: { bankAccount: true, voucher: true } },
      },
    });

    await this.auditLog.log({
      userId: actor.id,
      action: AuditAction.DEATH_CLAIM_APPROVE,
      entityType: 'DeathClaim',
      entityId: id,
      schoolId: claim.schoolId,
      metadata: {
        claimNo: claim.claimNo,
        approverName: approver.fullName,
        netToPay: Number(claim.netToPay),
      },
      ipAddress,
    });

    return updated;
  }

  async recordPayment(
    id: string,
    dto: RecordBenefitPaymentDto,
    actor?: ScopedUser,
    ipAddress?: string,
  ) {
    const claim = await this.findById(id, actor);

    if (claim.payment) {
      throw new BadRequestException('รายการนี้จ่ายเงินแล้ว');
    }

    if (!claim.approvedAt) {
      throw new BadRequestException('ยังไม่ได้รับการอนุมัติเบิก (ข้อ 13.6) ไม่สามารถจ่ายเงินได้');
    }

    if (!claim.documentsComplete) {
      throw new BadRequestException('เอกสารยังไม่ครบตามข้อ 17 ไม่สามารถจ่ายเงินได้');
    }

    const collectedAmount = Number(claim.collectedAmount);
    const targetAmount = Number(claim.totalContribution);
    if (collectedAmount < targetAmount) {
      throw new BadRequestException('ยอดเก็บเงินยังไม่ครบ ไม่สามารถจ่ายเงินได้');
    }

    const netToPay = Number(claim.netToPay);
    if (dto.amount !== undefined && Number(dto.amount) !== netToPay) {
      throw new BadRequestException('จำนวนเงินจ่ายต้องตรงกับยอดสุทธิที่คำนวณไว้');
    }

    const payment = await this.prisma.$transaction(async (tx) => {
      const created = await tx.deathBenefitPayment.create({
        data: {
          deathClaimId: id,
          payDate: new Date(dto.payDate),
          method: dto.method,
          bankAccountId: dto.bankAccountId,
          amount: dto.amount ?? netToPay,
          voucherId: dto.voucherId,
        },
        include: { deathClaim: true, bankAccount: true, voucher: true },
      });

      await tx.deathClaim.update({
        where: { id },
        data: { status: DeathClaimStatus.PAID },
      });

      return created;
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.DEATH_CLAIM_PAYMENT,
        entityType: 'DeathBenefitPayment',
        entityId: payment.id,
        schoolId: claim.schoolId,
        metadata: { deathClaimId: id, amount: Number(payment.amount) },
        ipAddress,
      });
    }

    return payment;
  }

  async getStats(year?: number, actor?: ScopedUser) {
    const scopedSchoolId = actor
      ? this.schoolScope.resolveSchoolId(actor, undefined)
      : undefined;
    const where: any = {};
    if (scopedSchoolId) where.schoolId = scopedSchoolId;
    if (year) {
      where.reportedDate = {
        gte: new Date(`${year}-01-01`),
        lt: new Date(`${year + 1}-01-01`),
      };
    }

    const now = new Date();
    const [totalClaims, totalPaid, unpaid, byStatus, overdueCollection, overdueDocuments] =
      await Promise.all([
      this.prisma.deathClaim.count({ where }),
      this.prisma.deathClaim.count({
        where: { ...where, payment: { isNot: null } },
      }),
      this.prisma.deathClaim.count({
        where: { ...where, payment: null },
      }),
      this.prisma.deathClaim.groupBy({
        by: ['status'],
        where,
        _count: true,
      }),
      this.prisma.deathClaim.count({
        where: {
          ...where,
          status: { in: [DeathClaimStatus.REPORTED, DeathClaimStatus.COLLECTING] },
          collectionDeadline: { lt: now },
        },
      }),
      this.prisma.deathClaim.count({
        where: {
          ...where,
          status: { notIn: [DeathClaimStatus.PAID, DeathClaimStatus.READY_TO_PAY] },
          documentDeadline: { lt: now },
          documentsComplete: false,
        },
      }),
    ]);

    const amounts = await this.prisma.deathClaim.aggregate({
      where,
      _sum: {
        totalContribution: true,
        associationSupport: true,
        otherDeductions: true,
        netToPay: true,
      },
    });

    const paidAmounts = await this.prisma.deathBenefitPayment.aggregate({
      where: { deathClaim: where },
      _sum: { amount: true },
    });

    return {
      totalClaims,
      totalPaid,
      unpaid,
      totalNetToPay: Number(amounts._sum?.netToPay || 0),
      totalAmountPaid: Number(paidAmounts._sum?.amount || 0),
      totalContribution: Number(amounts._sum?.totalContribution || 0),
      totalFundReserve: Number(amounts._sum?.associationSupport || 0),
      totalOtherDeductions: Number(amounts._sum?.otherDeductions || 0),
      byStatus: Object.fromEntries(byStatus.map((s) => [s.status, s._count])),
      overdueCollection,
      overdueDocuments,
    };
  }
}