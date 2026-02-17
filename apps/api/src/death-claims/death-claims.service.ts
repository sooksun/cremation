import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { DocumentNumberService, DocumentType } from '../common/document-number.service';
import { MembersService } from '../members/members.service';
import { CreateDeathClaimDto } from './dto/create-death-claim.dto';
import { RecordBenefitPaymentDto } from './dto/record-payment.dto';
import { MemberStatus } from '@prisma/client';

@Injectable()
export class DeathClaimsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly documentNumberService: DocumentNumberService,
    private readonly membersService: MembersService,
  ) {}

  async create(dto: CreateDeathClaimDto) {
    // Verify member exists and is ACTIVE
    const member = await this.membersService.findById(dto.memberId);

    if (member.status === MemberStatus.DECEASED) {
      throw new BadRequestException('สมาชิกนี้เสียชีวิตแล้ว');
    }

    // Get active members count for calculation
    const activeMemberCount = await this.prisma.member.count({
      where: { status: MemberStatus.ACTIVE },
    });

    // Default welfare rate per member
    const welfareRate = dto.welfareRate || 20.0;
    const totalContribution = activeMemberCount * welfareRate;
    const associationSupport = dto.associationSupport || 0;
    const otherDeductions = dto.otherDeductions || 0;
    const netToPay = totalContribution + associationSupport - otherDeductions;

    // Generate claim number
    const claimNo = await this.documentNumberService.generateNumber(DocumentType.DEATH_CLAIM);

    // Create death claim
    const deathClaim = await this.prisma.deathClaim.create({
      data: {
        memberId: dto.memberId,
        schoolId: dto.schoolId,
        claimNo,
        reportedDate: new Date(dto.reportedDate),
        deathDate: new Date(dto.deathDate),
        causeOfDeath: dto.causeOfDeath,
        mainBeneficiary: dto.mainBeneficiary,
        beneficiaryPhone: dto.beneficiaryPhone,
        activeMemberCount,
        welfareRate,
        totalContribution,
        associationSupport,
        otherDeductions,
        netToPay,
      },
      include: {
        member: {
          include: {
            school: true,
            memberType: true,
            beneficiaries: true,
          },
        },
        school: true,
      },
    });

    // Update member status to DECEASED
    await this.membersService.changeStatus(dto.memberId, MemberStatus.DECEASED, dto.deathDate);

    return deathClaim;
  }

  async findAll(schoolId?: string, year?: number) {
    const where: any = {};
    if (schoolId) where.schoolId = schoolId;
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
            firstName: true,
            lastName: true,
            memberType: true,
          },
        },
        school: true,
        payment: {
          include: { bankAccount: true },
        },
      },
      orderBy: { reportedDate: 'desc' },
    });
  }

  async findById(id: string) {
    const claim = await this.prisma.deathClaim.findUnique({
      where: { id },
      include: {
        member: {
          include: {
            school: true,
            memberType: true,
            beneficiaries: { orderBy: { priority: 'asc' } },
            group: true,
          },
        },
        school: true,
        payment: {
          include: { bankAccount: true, voucher: true },
        },
      },
    });

    if (!claim) {
      throw new NotFoundException('ไม่พบรายการแจ้งเสียชีวิต');
    }

    return claim;
  }

  async recordPayment(id: string, dto: RecordBenefitPaymentDto) {
    const claim = await this.findById(id);

    if (claim.payment) {
      throw new BadRequestException('รายการนี้จ่ายเงินแล้ว');
    }

    return this.prisma.deathBenefitPayment.create({
      data: {
        deathClaimId: id,
        payDate: new Date(dto.payDate),
        method: dto.method,
        bankAccountId: dto.bankAccountId,
        amount: dto.amount || claim.netToPay,
        voucherId: dto.voucherId,
      },
      include: { deathClaim: true, bankAccount: true, voucher: true },
    });
  }

  async getStats(year?: number) {
    const where: any = {};
    if (year) {
      where.reportedDate = {
        gte: new Date(`${year}-01-01`),
        lt: new Date(`${year + 1}-01-01`),
      };
    }

    const [totalClaims, totalPaid, unpaid] = await Promise.all([
      this.prisma.deathClaim.count({ where }),
      this.prisma.deathClaim.count({
        where: { ...where, payment: { isNot: null } },
      }),
      this.prisma.deathClaim.count({
        where: { ...where, payment: null },
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
      totalOtherDeductions: Number(amounts._sum?.otherDeductions || 0),
    };
  }

}
