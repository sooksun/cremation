import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { MembersService } from '../members/members.service';
import { CreatePeriodDto, UpdatePeriodDto } from './dto/period.dto';
import { RecordPaymentDto } from './dto/payment.dto';
import { Decimal } from '@prisma/client/runtime/library';
import { MemberStatus, ReceiptType } from '@prisma/client';
import { DocumentNumberService, DocumentType } from '../common/document-number.service';
import { BankAccountsService } from '../bank-accounts/bank-accounts.service';

@Injectable()
export class ContributionsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly membersService: MembersService,
    private readonly documentNumberService: DocumentNumberService,
    private readonly bankAccountsService: BankAccountsService,
  ) {}

  // Period Management
  async createPeriod(dto: CreatePeriodDto) {
    const existing = await this.prisma.contributionPeriod.findUnique({
      where: { year_month: { year: dto.year, month: dto.month } },
    });

    if (existing) {
      throw new BadRequestException('งวดนี้มีอยู่แล้ว');
    }

    return this.prisma.contributionPeriod.create({
      data: {
        year: dto.year,
        month: dto.month,
        welfareRate: dto.welfareRate,
        serviceFee: dto.serviceFee,
      },
    });
  }

  async findAllPeriods(year?: number) {
    return this.prisma.contributionPeriod.findMany({
      where: year ? { year } : undefined,
      include: {
        _count: { select: { contributions: true } },
      },
      orderBy: [{ year: 'desc' }, { month: 'desc' }],
    });
  }

  async findPeriodById(id: string) {
    const period = await this.prisma.contributionPeriod.findUnique({
      where: { id },
    });

    if (!period) {
      throw new NotFoundException('ไม่พบงวด');
    }

    return period;
  }

  async updatePeriod(id: string, dto: UpdatePeriodDto) {
    await this.findPeriodById(id);
    return this.prisma.contributionPeriod.update({
      where: { id },
      data: dto,
    });
  }

  async closePeriod(id: string) {
    await this.findPeriodById(id);
    return this.prisma.contributionPeriod.update({
      where: { id },
      data: { isClosed: true },
    });
  }

  // Generate contributions for all active members
  async generateContributions(periodId: string, schoolId?: string) {
    const period = await this.findPeriodById(periodId);

    if (period.isClosed) {
      throw new BadRequestException('งวดนี้ปิดแล้ว ไม่สามารถสร้างรายการได้');
    }

    // Get all active members
    const where: any = { status: MemberStatus.ACTIVE };
    if (schoolId) where.schoolId = schoolId;

    const activeMembers = await this.prisma.member.findMany({ where });

    const welfareRate = Number(period.welfareRate);
    const serviceFee = Number(period.serviceFee);
    const totalAmount = welfareRate + serviceFee;

    // Create contributions for each member
    const results = await Promise.all(
      activeMembers.map(async (member) => {
        const existing = await this.prisma.memberContribution.findUnique({
          where: { memberId_periodId: { memberId: member.id, periodId } },
        });

        if (existing) return null;

        return this.prisma.memberContribution.create({
          data: {
            memberId: member.id,
            periodId,
            schoolId: member.schoolId,
            welfareAmount: welfareRate,
            serviceAmount: serviceFee,
            totalAmount,
          },
        });
      }),
    );

    const created = results.filter(Boolean).length;
    return { message: `สร้างรายการเงินสงเคราะห์ ${created} รายการ`, created };
  }

  // Get contributions for a period
  async getContributionsByPeriod(periodId: string, schoolId?: string) {
    const where: any = { periodId };
    if (schoolId) where.schoolId = schoolId;

    return this.prisma.memberContribution.findMany({
      where,
      include: {
        member: {
          select: {
            id: true,
            memberNo: true,
            firstName: true,
            lastName: true,
            phone: true,
            group: true,
          },
        },
        school: true,
        receipt: true,
      },
      orderBy: [{ school: { name: 'asc' } }, { member: { memberNo: 'asc' } }],
    });
  }

  // Record payment for a contribution
  async recordPayment(id: string, dto: RecordPaymentDto) {
    const contribution = await this.prisma.memberContribution.findUnique({
      where: { id },
      include: { period: true },
    });

    if (!contribution) {
      throw new NotFoundException('ไม่พบรายการเงินสงเคราะห์');
    }

    if (contribution.period.isClosed) {
      throw new BadRequestException('งวดนี้ปิดแล้ว ไม่สามารถบันทึกการชำระได้');
    }

    return this.prisma.memberContribution.update({
      where: { id },
      data: {
        paidAmount: dto.amount,
        paidDate: new Date(dto.paidDate),
        receiptId: dto.receiptId,
        isArrears: false,
      },
    });
  }

  // Batch record payments for multiple contributions
  async batchRecordPayments(payments: Array<{ contributionId: string; amount: number; paidDate?: string; receiptId?: string }>) {
    if (!payments || payments.length === 0) {
      throw new BadRequestException('ไม่มีรายการที่ต้องบันทึก');
    }

    // ดึงบัญชีธนาคาร (BankAccount) - บัญชีกลางของกองทุน (ดึงครั้งเดียวสำหรับทุก payment)
    let defaultBankAccountId: string | undefined = undefined;
    try {
      const defaultBankAccount = await this.bankAccountsService.findDefault();
      if (defaultBankAccount?.id) {
        const verifyBankAccount = await this.prisma.bankAccount.findUnique({
          where: { id: defaultBankAccount.id },
          select: { id: true },
        });
        if (verifyBankAccount?.id) {
          defaultBankAccountId = verifyBankAccount.id;
        }
      }
    } catch (error) {
      console.warn('ไม่พบบัญชีธนาคารเริ่มต้น:', error);
    }

    // ดึงบัญชีสำหรับ ledger entries (Account - บัญชีแยกประเภท) (ดึงครั้งเดียว)
    const cashAccount = await this.prisma.account.findFirst({ where: { code: '101' } });
    const bankAccount = await this.prisma.account.findFirst({ where: { code: '102' } });
    const welfareRevenue = await this.prisma.account.findFirst({ where: { code: '401' } });
    const serviceRevenue = await this.prisma.account.findFirst({ where: { code: '402' } });

    const results = await Promise.all(
      payments.map(async (payment) => {
        if (!payment.contributionId) {
          return { contributionId: payment.contributionId || 'unknown', success: false, error: 'ไม่มี contributionId' };
        }

        console.log(`Processing payment for contribution ${payment.contributionId}, amount: ${payment.amount}`);
        
        const contribution = await this.prisma.memberContribution.findUnique({
          where: { id: payment.contributionId },
          include: { 
            period: true,
            member: true,
          },
        });

        if (!contribution) {
          console.error(`Contribution not found: ${payment.contributionId}`);
          return { contributionId: payment.contributionId, success: false, error: 'ไม่พบรายการ' };
        }

        if (contribution.period.isClosed) {
          console.error(`Period is closed for contribution ${payment.contributionId}`);
          console.error(`Period details: ${contribution.period.month}/${contribution.period.year}, isClosed: ${contribution.period.isClosed}`);
          return { 
            contributionId: payment.contributionId, 
            success: false, 
            error: `งวด ${contribution.period.month}/${contribution.period.year} ปิดแล้ว กรุณาเปิดงวดก่อนบันทึกการชำระเงิน` 
          };
        }

        if (!contribution.member) {
          console.error(`Member not found for contribution ${payment.contributionId}`);
          return { contributionId: payment.contributionId, success: false, error: 'ไม่พบข้อมูลสมาชิก' };
        }

        try {
          // If amount is 0, cancel the payment
          if (payment.amount === 0 || payment.amount === null || payment.amount === undefined) {
            await this.prisma.memberContribution.update({
              where: { id: payment.contributionId },
              data: {
                paidAmount: 0,
                paidDate: null,
                receiptId: null,
                isArrears: true, // Mark as arrears when payment is cancelled
              },
            });
            return { contributionId: payment.contributionId, success: true };
          }

          // ถ้ามี amount > 0 ให้สร้าง receipt (ถ้ายังไม่มี receiptId)
          let receiptId = payment.receiptId || contribution.receiptId;
          const paidDate = payment.paidDate ? new Date(payment.paidDate) : new Date();
          const amount = Number(payment.amount);

          // ถ้ายังไม่มี receiptId ให้สร้าง receipt ใหม่
          if (!receiptId) {
            try {
              console.log(`Creating receipt for contribution ${payment.contributionId}, amount: ${amount}`);
              const receiptNo = await this.documentNumberService.generateNumber(DocumentType.RECEIPT);
              
              const receiptData: {
                receiptNo: string;
                schoolId: string;
                date: Date;
                type: ReceiptType;
                description: string;
                amount: number;
                bankAccountId?: string;
              } = {
                receiptNo,
                schoolId: contribution.member.schoolId,
                date: paidDate,
                type: ReceiptType.MEMBER_CONTRIBUTION,
                description: `ชำระเงินสงเคราะห์ประจำเดือน ${contribution.period.month}/${contribution.period.year} - ${contribution.member.firstName} ${contribution.member.lastName} (${contribution.member.memberNo})`,
                amount: amount,
              };

              if (defaultBankAccountId) {
                receiptData.bankAccountId = defaultBankAccountId;
              }

              console.log('Receipt data:', {
                receiptNo: receiptData.receiptNo,
                schoolId: receiptData.schoolId,
                bankAccountId: receiptData.bankAccountId || 'undefined',
                amount: receiptData.amount,
              });

              const receipt = await this.prisma.receipt.create({
                data: receiptData,
              });

              receiptId = receipt.id;
              console.log(`Receipt created successfully: ${receipt.id}`);

              // สร้าง ledger entries (แยก welfare และ service revenue)
              if (cashAccount && bankAccount && welfareRevenue && serviceRevenue) {
                const welfareAmount = Number(contribution.welfareAmount);
                const serviceAmount = Number(contribution.serviceAmount);

                await this.prisma.ledgerEntry.createMany({
                  data: [
                    {
                      accountId: bankAccount.id,
                      date: paidDate,
                      description: `รับเงินสงเคราะห์ - ${contribution.member.memberNo}`,
                      debit: amount,
                      credit: 0,
                      receiptId: receipt.id,
                    },
                    {
                      accountId: welfareRevenue.id,
                      date: paidDate,
                      description: `รายได้สงเคราะห์ - ${contribution.member.memberNo}`,
                      debit: 0,
                      credit: welfareAmount,
                      receiptId: receipt.id,
                    },
                    {
                      accountId: serviceRevenue.id,
                      date: paidDate,
                      description: `รายได้ค่าบริการ - ${contribution.member.memberNo}`,
                      debit: 0,
                      credit: serviceAmount,
                      receiptId: receipt.id,
                    },
                  ],
                });
                console.log(`Ledger entries created for receipt ${receipt.id}`);
              } else {
                console.warn('Missing accounts for ledger entries:', {
                  cashAccount: !!cashAccount,
                  bankAccount: !!bankAccount,
                  welfareRevenue: !!welfareRevenue,
                  serviceRevenue: !!serviceRevenue,
                });
              }
            } catch (receiptError: any) {
              console.error(`Error creating receipt for contribution ${payment.contributionId}:`, receiptError);
              console.error('Receipt error details:', {
                message: receiptError.message,
                code: receiptError.code,
                meta: receiptError.meta,
              });
              // ยังคงบันทึก payment แม้ว่าจะสร้าง receipt ไม่สำเร็จ
              // แต่จะ throw error เพื่อให้ frontend รู้ว่ามีปัญหา
              throw new Error(`ไม่สามารถสร้าง receipt ได้: ${receiptError.message || String(receiptError)}`);
            }
          }

          // อัปเดต contribution
          await this.prisma.memberContribution.update({
            where: { id: payment.contributionId },
            data: {
              paidAmount: amount,
              paidDate: paidDate,
              receiptId: receiptId || null,
              isArrears: false,
            },
          });

          return { contributionId: payment.contributionId, success: true };
        } catch (error: any) {
          console.error(`Error updating contribution ${payment.contributionId}:`, error);
          console.error('Error details:', {
            message: error.message,
            code: error.code,
            meta: error.meta,
            stack: error.stack,
          });
          const errorMessage = error.message || error.code || String(error);
          return { 
            contributionId: payment.contributionId, 
            success: false, 
            error: errorMessage 
          };
        }
      }),
    );

    const successCount = results.filter((r) => r.success).length;
    const failCount = results.filter((r) => !r.success).length;

    return {
      total: payments.length,
      success: successCount,
      failed: failCount,
      results,
    };
  }

  // Get arrears by school/group
  async getArrears(schoolId?: string, periodId?: string) {
    const where: any = {
      paidAmount: 0,
      isArrears: true,
    };

    if (schoolId) where.schoolId = schoolId;
    if (periodId) where.periodId = periodId;

    return this.prisma.memberContribution.findMany({
      where,
      include: {
        member: {
          select: {
            id: true,
            memberNo: true,
            firstName: true,
            lastName: true,
            phone: true,
            group: true,
          },
        },
        period: true,
        school: true,
      },
      orderBy: [{ period: { year: 'asc' } }, { period: { month: 'asc' } }],
    });
  }

  // Mark unpaid contributions as arrears
  async markArrearsForPeriod(periodId: string) {
    const result = await this.prisma.memberContribution.updateMany({
      where: {
        periodId,
        paidAmount: 0,
      },
      data: {
        isArrears: true,
      },
    });

    return { message: `ทำเครื่องหมายค้างชำระ ${result.count} รายการ`, count: result.count };
  }

  // Get summary for a period
  async getPeriodSummary(periodId: string, schoolId?: string) {
    const where: any = { periodId };
    if (schoolId) where.schoolId = schoolId;

    const [totalContributions, paidContributions, totalAmount, paidAmount] = await Promise.all([
      this.prisma.memberContribution.count({ where }),
      this.prisma.memberContribution.count({ where: { ...where, paidAmount: { gt: 0 } } }),
      this.prisma.memberContribution.aggregate({
        where,
        _sum: { totalAmount: true },
      }),
      this.prisma.memberContribution.aggregate({
        where,
        _sum: { paidAmount: true },
      }),
    ]);

    return {
      totalContributions,
      paidContributions,
      unpaidContributions: totalContributions - paidContributions,
      totalAmount: Number(totalAmount._sum.totalAmount || 0),
      paidAmount: Number(paidAmount._sum.paidAmount || 0),
      unpaidAmount:
        Number(totalAmount._sum.totalAmount || 0) - Number(paidAmount._sum.paidAmount || 0),
    };
  }

  // =============================================
  // CONTRIBUTION MATRIX - ตารางการชำระเงินรายเดือน
  // =============================================
  async getContributionMatrix(year: number, schoolId?: string) {
    // Get all periods for the year
    const periods = await this.prisma.contributionPeriod.findMany({
      where: { year },
      orderBy: { month: 'asc' },
    });

    // Get all members (filter by school if provided)
    const memberWhere: any = { status: MemberStatus.ACTIVE };
    if (schoolId) memberWhere.schoolId = schoolId;

    const members = await this.prisma.member.findMany({
      where: memberWhere,
      include: {
        school: { select: { id: true, name: true, code: true } },
        memberType: { select: { name: true } },
        group: { select: { name: true } },
      },
      orderBy: [{ school: { name: 'asc' } }, { memberNo: 'asc' }],
    });

    // Get all contributions for this year
    const contributions = await this.prisma.memberContribution.findMany({
      where: {
        period: { year },
        ...(schoolId && { schoolId }),
      },
      select: {
        id: true,
        memberId: true,
        periodId: true,
        paidAmount: true,
        paidDate: true,
        totalAmount: true,
        isArrears: true,
      },
    });

    // Create a map for quick lookup
    const contributionMap = new Map<string, typeof contributions[0]>();
    contributions.forEach((c) => {
      contributionMap.set(`${c.memberId}-${c.periodId}`, c);
    });

    // Build matrix data
    const matrixData = members.map((member) => {
      const monthlyData: Record<number, { 
        status: 'paid' | 'unpaid' | 'arrears' | 'none';
        amount?: number;
        paidDate?: string;
        contributionId?: string;
        periodId?: string;
      }> = {};

      let totalPaid = 0;
      let totalUnpaid = 0;

      // Check each month
      for (let month = 1; month <= 12; month++) {
        const period = periods.find((p) => p.month === month);
        if (!period) {
          monthlyData[month] = { status: 'none' };
          continue;
        }

        const contribution = contributionMap.get(`${member.id}-${period.id}`);
        if (!contribution) {
          monthlyData[month] = { 
            status: 'none',
            periodId: period.id,
          };
        } else if (Number(contribution.paidAmount) > 0) {
          monthlyData[month] = {
            status: 'paid',
            amount: Number(contribution.paidAmount),
            paidDate: contribution.paidDate?.toISOString(),
            contributionId: contribution.id,
            periodId: contribution.periodId,
          };
          totalPaid += Number(contribution.paidAmount);
        } else if (contribution.isArrears) {
          monthlyData[month] = {
            status: 'arrears',
            amount: Number(contribution.totalAmount),
            contributionId: contribution.id,
            periodId: contribution.periodId,
          };
          totalUnpaid += Number(contribution.totalAmount);
        } else {
          monthlyData[month] = {
            status: 'unpaid',
            amount: Number(contribution.totalAmount),
            contributionId: contribution.id,
            periodId: contribution.periodId,
          };
          totalUnpaid += Number(contribution.totalAmount);
        }
      }

      return {
        member: {
          id: member.id,
          memberNo: member.memberNo,
          firstName: member.firstName,
          lastName: member.lastName,
          school: member.school,
          memberType: member.memberType?.name,
          group: member.group?.name,
        },
        monthlyData,
        summary: {
          totalPaid,
          totalUnpaid,
          paidMonths: Object.values(monthlyData).filter((m) => m.status === 'paid').length,
          unpaidMonths: Object.values(monthlyData).filter((m) => m.status === 'unpaid' || m.status === 'arrears').length,
        },
      };
    });

    // Calculate summary by school
    const schoolSummary = new Map<string, {
      schoolId: string;
      schoolName: string;
      schoolCode: string;
      totalMembers: number;
      totalPaid: number;
      totalUnpaid: number;
      monthlyStats: Record<number, { paid: number; unpaid: number; total: number }>;
    }>();

    matrixData.forEach((row) => {
      const schoolId = row.member.school.id;
      if (!schoolSummary.has(schoolId)) {
        schoolSummary.set(schoolId, {
          schoolId,
          schoolName: row.member.school.name,
          schoolCode: row.member.school.code,
          totalMembers: 0,
          totalPaid: 0,
          totalUnpaid: 0,
          monthlyStats: {},
        });
        for (let m = 1; m <= 12; m++) {
          schoolSummary.get(schoolId)!.monthlyStats[m] = { paid: 0, unpaid: 0, total: 0 };
        }
      }

      const summary = schoolSummary.get(schoolId)!;
      summary.totalMembers++;
      summary.totalPaid += row.summary.totalPaid;
      summary.totalUnpaid += row.summary.totalUnpaid;

      Object.entries(row.monthlyData).forEach(([month, data]) => {
        const m = parseInt(month);
        if (data.status === 'paid') {
          summary.monthlyStats[m].paid++;
        } else if (data.status === 'unpaid' || data.status === 'arrears') {
          summary.monthlyStats[m].unpaid++;
        }
        if (data.status !== 'none') {
          summary.monthlyStats[m].total++;
        }
      });
    });

    return {
      year,
      periods: periods.map((p) => ({
        id: p.id,
        month: p.month,
        welfareRate: Number(p.welfareRate),
        serviceFee: Number(p.serviceFee),
        isClosed: p.isClosed,
      })),
      members: matrixData,
      schoolSummary: Array.from(schoolSummary.values()),
      totalSummary: {
        totalMembers: matrixData.length,
        totalPaid: matrixData.reduce((sum, m) => sum + m.summary.totalPaid, 0),
        totalUnpaid: matrixData.reduce((sum, m) => sum + m.summary.totalUnpaid, 0),
      },
    };
  }

  // Get schools for filter
  async getSchoolsWithContributions(year: number) {
    const schools = await this.prisma.school.findMany({
      where: { isActive: true },
      include: {
        _count: {
          select: {
            members: { where: { status: MemberStatus.ACTIVE } },
          },
        },
      },
      orderBy: { name: 'asc' },
    });

    return schools.map((s) => ({
      id: s.id,
      code: s.code,
      name: s.name,
      memberCount: s._count.members,
    }));
  }

  // =============================================
  // EXCEL TEMPLATE & UPLOAD
  // =============================================
  
  /**
   * สร้าง template Excel สำหรับสมาชิกที่หักผ่านเงินเดือน
   */
  async generatePaymentTemplate(year: number, month: number) {
    // หา period
    const period = await this.prisma.contributionPeriod.findUnique({
      where: { year_month: { year, month } },
    });

    if (!period) {
      throw new NotFoundException(`ไม่พบงวดสำหรับเดือน ${month} ปี ${year}`);
    }

    // ดึงสมาชิกที่หักผ่านเงินเดือนและมีสถานะ ACTIVE
    const members = await this.prisma.member.findMany({
      where: {
        status: MemberStatus.ACTIVE,
        salaryDeduction: true,
      },
      include: {
        school: { select: { code: true, name: true } },
        memberType: { select: { name: true } },
        contributions: {
          where: { periodId: period.id },
          select: { id: true, totalAmount: true, paidAmount: true },
        },
      },
      orderBy: [{ school: { name: 'asc' } }, { memberNo: 'asc' }],
    });

    // สร้างข้อมูลสำหรับ Excel
    const excelData = members.map((member) => {
      const contribution = member.contributions[0];
      return {
        'เลขสมาชิก': member.memberNo,
        'ชื่อ': member.firstName,
        'นามสกุล': member.lastName,
        'โรงเรียน': member.school.name,
        'รหัสโรงเรียน': member.school.code,
        'ประเภท': member.memberType.name,
        'ยอดที่ต้องชำระ': contribution ? Number(contribution.totalAmount) : Number(period.welfareRate) + Number(period.serviceFee),
        'สถานะ': contribution && Number(contribution.paidAmount) > 0 ? 'ชำระแล้ว' : 'ยังไม่ชำระ',
      };
    });

    return {
      period: {
        id: period.id,
        year: period.year,
        month: period.month,
        welfareRate: Number(period.welfareRate),
        serviceFee: Number(period.serviceFee),
      },
      members: excelData,
      totalMembers: members.length,
    };
  }

  /**
   * ประมวลผล Excel ที่ upload มาและบันทึกการชำระเงิน
   */
  async processPaymentUpload(
    year: number,
    month: number,
    excelData: Array<{
      เลขสมาชิก: string;
      ชื่อ?: string;
      นามสกุล?: string;
      โรงเรียน?: string;
      รหัสโรงเรียน?: string;
      ยอดที่ต้องชำระ?: number;
      สถานะ?: string;
    }>,
  ) {
    // หา period
    const period = await this.prisma.contributionPeriod.findUnique({
      where: { year_month: { year, month } },
    });

    if (!period) {
      throw new NotFoundException(`ไม่พบงวดสำหรับเดือน ${month} ปี ${year}`);
    }

    const results = {
      success: 0,
      failed: 0,
      notFound: 0,
      errors: [] as Array<{ memberNo: string; error: string }>,
    };

    // ประมวลผลแต่ละแถว
    for (const row of excelData) {
      try {
        // หาสมาชิกจากเลขสมาชิก
        const member = await this.prisma.member.findFirst({
          where: { memberNo: row.เลขสมาชิก },
          include: {
            contributions: {
              where: { periodId: period.id },
            },
          },
        });

        if (!member) {
          results.notFound++;
          results.errors.push({
            memberNo: row.เลขสมาชิก,
            error: 'ไม่พบสมาชิก',
          });
          continue;
        }

        // หา contribution
        let contribution = member.contributions[0];

        // ถ้ายังไม่มี contribution ให้สร้างใหม่
        if (!contribution) {
          const welfareRate = Number(period.welfareRate);
          const serviceFee = Number(period.serviceFee);
          const totalAmount = welfareRate + serviceFee;

          contribution = await this.prisma.memberContribution.create({
            data: {
              memberId: member.id,
              periodId: period.id,
              schoolId: member.schoolId,
              welfareAmount: welfareRate,
              serviceAmount: serviceFee,
              totalAmount,
              paidAmount: 0,
            },
          });
        }

        // ถ้า status เป็น "ชำระแล้ว" ให้บันทึกการชำระและสร้างใบเสร็จรับเงิน
        if (row.สถานะ === 'ชำระแล้ว' || row.สถานะ === 'ชำระ' || row.สถานะ === 'paid') {
          const amount = row.ยอดที่ต้องชำระ || Number(contribution.totalAmount);
          const paidDate = contribution.paidDate || new Date();

          // ตรวจสอบว่ามี receiptId อยู่แล้วหรือไม่
          let receiptId = contribution.receiptId;

          // ถ้ายังไม่มี receiptId ให้สร้าง receipt ใหม่
          if (!receiptId) {
            // สร้างใบเสร็จรับเงิน
            const receiptNo = await this.documentNumberService.generateNumber(DocumentType.RECEIPT);
            
            // ดึงบัญชีธนาคาร (BankAccount) - บัญชีกลางของกองทุน
            let defaultBankAccountId: string | undefined = undefined;
            try {
              const defaultBankAccount = await this.bankAccountsService.findDefault();
              if (defaultBankAccount?.id) {
                // ตรวจสอบว่า bankAccountId มีอยู่ในฐานข้อมูลจริงหรือไม่
                const verifyBankAccount = await this.prisma.bankAccount.findUnique({
                  where: { id: defaultBankAccount.id },
                  select: { id: true },
                });
                if (verifyBankAccount?.id) {
                  defaultBankAccountId = verifyBankAccount.id;
                  console.log(`ใช้ BankAccount ID: ${defaultBankAccountId}`);
                } else {
                  console.warn(`BankAccount ID ${defaultBankAccount.id} ไม่พบในฐานข้อมูล`);
                }
              } else {
                console.log('ไม่พบ default bank account - จะสร้าง receipt โดยไม่มี bankAccountId');
              }
            } catch (error) {
              console.warn('ไม่พบบัญชีธนาคารเริ่มต้น:', error);
            }
            
            // ดึงบัญชีสำหรับ ledger entries (Account - บัญชีแยกประเภท)
            const cashAccount = await this.prisma.account.findFirst({ where: { code: '101' } });
            const bankAccount = await this.prisma.account.findFirst({ where: { code: '102' } });
            const welfareRevenue = await this.prisma.account.findFirst({ where: { code: '401' } });
            const serviceRevenue = await this.prisma.account.findFirst({ where: { code: '402' } });

            // สร้าง receipt - ไม่ส่ง bankAccountId ถ้าไม่มีหรือไม่ถูกต้อง
            const receiptData: {
              receiptNo: string;
              schoolId: string;
              date: Date;
              type: ReceiptType;
              description: string;
              amount: number;
              bankAccountId?: string;
            } = {
              receiptNo,
              schoolId: member.schoolId,
              date: paidDate,
              type: ReceiptType.MEMBER_CONTRIBUTION,
              description: `ชำระเงินสงเคราะห์ประจำเดือน ${month}/${year} - ${member.firstName} ${member.lastName} (${member.memberNo})`,
              amount: amount,
            };

            // เพิ่ม bankAccountId เฉพาะเมื่อมี default bank account และ ID ถูกต้อง
            if (defaultBankAccountId) {
              receiptData.bankAccountId = defaultBankAccountId;
            }

            // Log สำหรับ debugging
            console.log('Creating receipt with data:', {
              receiptNo: receiptData.receiptNo,
              schoolId: receiptData.schoolId,
              bankAccountId: receiptData.bankAccountId || 'undefined (will be null)',
              hasBankAccountId: !!receiptData.bankAccountId,
            });

            const receipt = await this.prisma.receipt.create({
              data: receiptData,
            });

            receiptId = receipt.id;

            // สร้าง ledger entries (แยก welfare และ service revenue)
            if (cashAccount && welfareRevenue && serviceRevenue) {
              const debitAccountId = bankAccount?.id || cashAccount.id;
              const welfareAmount = Number(contribution.welfareAmount);
              const serviceAmount = Number(contribution.serviceAmount);

              await this.prisma.ledgerEntry.createMany({
                data: [
                  {
                    accountId: debitAccountId,
                    date: paidDate,
                    description: `รับเงินสงเคราะห์ ${member.firstName} ${member.lastName}`,
                    debit: amount,
                    credit: 0,
                    receiptId: receipt.id,
                  },
                  {
                    accountId: welfareRevenue.id,
                    date: paidDate,
                    description: `รายได้เงินสงเคราะห์ ${member.firstName} ${member.lastName}`,
                    debit: 0,
                    credit: welfareAmount,
                    receiptId: receipt.id,
                  },
                  {
                    accountId: serviceRevenue.id,
                    date: paidDate,
                    description: `รายได้ค่าบริการ ${member.firstName} ${member.lastName}`,
                    debit: 0,
                    credit: serviceAmount,
                    receiptId: receipt.id,
                  },
                ],
              });
            }
          }

          // อัปเดต contribution พร้อม receiptId (ถ้ายังไม่มี)
          await this.prisma.memberContribution.update({
            where: { id: contribution.id },
            data: {
              paidAmount: amount,
              paidDate: paidDate,
              receiptId: receiptId,
              isArrears: false,
            },
          });

          results.success++;
        } else {
          // ถ้ายังไม่ชำระ ให้ตั้งเป็น unpaid
          await this.prisma.memberContribution.update({
            where: { id: contribution.id },
            data: {
              paidAmount: 0,
              paidDate: null,
              receiptId: null,
              isArrears: false,
            },
          });

          results.success++;
        }
      } catch (error) {
        results.failed++;
        results.errors.push({
          memberNo: row.เลขสมาชิก,
          error: error instanceof Error ? error.message : String(error),
        });
      }
    }

    return results;
  }

  /**
   * สร้าง receipt สำหรับรายการที่ชำระแล้วแต่ยังไม่มี receiptId (backfill)
   */
  async backfillReceiptsForPaidContributions() {
    const results = {
      success: 0,
      failed: 0,
      errors: [] as Array<{ contributionId: string; error: string }>,
    };

    try {
      // หารายการที่ชำระแล้วแต่ยังไม่มี receiptId
      const paidContributions = await this.prisma.memberContribution.findMany({
        where: {
          paidAmount: { gt: 0 },
          receiptId: null,
          paidDate: { not: null },
        },
        include: {
          member: true,
          period: true,
        },
      });

      // ดึงบัญชีธนาคาร (BankAccount) - บัญชีกลางของกองทุน
      let defaultBankAccountId: string | undefined = undefined;
      try {
        const defaultBankAccount = await this.bankAccountsService.findDefault();
        if (defaultBankAccount?.id) {
          // ตรวจสอบว่า bankAccountId มีอยู่ในฐานข้อมูลจริงหรือไม่
          const verifyBankAccount = await this.prisma.bankAccount.findUnique({
            where: { id: defaultBankAccount.id },
            select: { id: true },
          });
          if (verifyBankAccount?.id) {
            defaultBankAccountId = verifyBankAccount.id;
            console.log(`ใช้ BankAccount ID: ${defaultBankAccountId}`);
          } else {
            console.warn(`BankAccount ID ${defaultBankAccount.id} ไม่พบในฐานข้อมูล`);
          }
        } else {
          console.log('ไม่พบ default bank account - จะสร้าง receipt โดยไม่มี bankAccountId');
        }
      } catch (error) {
        console.warn('ไม่พบบัญชีธนาคารเริ่มต้น:', error);
      }
      
      // ดึงบัญชีสำหรับ ledger entries (Account - บัญชีแยกประเภท)
      const cashAccount = await this.prisma.account.findFirst({ where: { code: '101' } });
      const bankAccount = await this.prisma.account.findFirst({ where: { code: '102' } });
      const welfareRevenue = await this.prisma.account.findFirst({ where: { code: '401' } });
      const serviceRevenue = await this.prisma.account.findFirst({ where: { code: '402' } });

      for (const contribution of paidContributions) {
        try {
          const amount = Number(contribution.paidAmount);
          const paidDate = contribution.paidDate || new Date();
          const member = contribution.member;
          const period = contribution.period;

          // สร้างใบเสร็จรับเงิน
          const receiptNo = await this.documentNumberService.generateNumber(DocumentType.RECEIPT);

          // สร้าง receipt - ไม่ส่ง bankAccountId ถ้าไม่มีหรือไม่ถูกต้อง
          const receiptData: {
            receiptNo: string;
            schoolId: string;
            date: Date;
            type: ReceiptType;
            description: string;
            amount: number;
            bankAccountId?: string;
          } = {
            receiptNo,
            schoolId: member.schoolId,
            date: paidDate,
            type: ReceiptType.MEMBER_CONTRIBUTION,
            description: `ชำระเงินสงเคราะห์ประจำเดือน ${period.month}/${period.year} - ${member.firstName} ${member.lastName} (${member.memberNo})`,
            amount: amount,
          };

          // เพิ่ม bankAccountId เฉพาะเมื่อมี default bank account และ ID ถูกต้อง
          if (defaultBankAccountId) {
            receiptData.bankAccountId = defaultBankAccountId;
          }

          // Log สำหรับ debugging
          console.log('Creating receipt with data:', {
            receiptNo: receiptData.receiptNo,
            schoolId: receiptData.schoolId,
            bankAccountId: receiptData.bankAccountId || 'undefined (will be null)',
            hasBankAccountId: !!receiptData.bankAccountId,
          });

          // Log สำหรับ debugging
          console.log('Creating receipt with data:', {
            receiptNo: receiptData.receiptNo,
            schoolId: receiptData.schoolId,
            bankAccountId: receiptData.bankAccountId || 'null',
            hasBankAccountId: !!receiptData.bankAccountId,
          });

          const receipt = await this.prisma.receipt.create({
            data: receiptData,
          });

          // สร้าง ledger entries (แยก welfare และ service revenue)
          if (cashAccount && welfareRevenue && serviceRevenue) {
            const debitAccountId = bankAccount?.id || cashAccount.id;
            const welfareAmount = Number(contribution.welfareAmount);
            const serviceAmount = Number(contribution.serviceAmount);

            await this.prisma.ledgerEntry.createMany({
              data: [
                {
                  accountId: debitAccountId,
                  date: paidDate,
                  description: `รับเงินสงเคราะห์ ${member.firstName} ${member.lastName}`,
                  debit: amount,
                  credit: 0,
                  receiptId: receipt.id,
                },
                {
                  accountId: welfareRevenue.id,
                  date: paidDate,
                  description: `รายได้เงินสงเคราะห์ ${member.firstName} ${member.lastName}`,
                  debit: 0,
                  credit: welfareAmount,
                  receiptId: receipt.id,
                },
                {
                  accountId: serviceRevenue.id,
                  date: paidDate,
                  description: `รายได้ค่าบริการ ${member.firstName} ${member.lastName}`,
                  debit: 0,
                  credit: serviceAmount,
                  receiptId: receipt.id,
                },
              ],
            });
          }

          // อัปเดต contribution พร้อม receiptId
          await this.prisma.memberContribution.update({
            where: { id: contribution.id },
            data: {
              receiptId: receipt.id,
            },
          });

          results.success++;
        } catch (error) {
          results.failed++;
          results.errors.push({
            contributionId: contribution.id,
            error: error instanceof Error ? error.message : String(error),
          });
        }
      }

      return results;
    } catch (error) {
      throw new BadRequestException(
        `เกิดข้อผิดพลาดในการสร้าง receipt: ${error instanceof Error ? error.message : String(error)}`,
      );
    }
  }
}

