import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { DocumentNumberService, DocumentType } from '../common/document-number.service';
import { CreateReceiptDto } from './dto/create-receipt.dto';
import { AuditAction, ReceiptType } from '@prisma/client';
import { SchoolScopeService, ScopedUser } from '../common/security/school-scope.service';
import { AuditLogService } from '../common/services/audit-log.service';

@Injectable()
export class ReceiptsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly documentNumberService: DocumentNumberService,
    private readonly auditLog: AuditLogService,
    private readonly schoolScope: SchoolScopeService,
  ) {}

  async create(dto: CreateReceiptDto, actor?: ScopedUser, ipAddress?: string) {
    if (actor && dto.schoolId) {
      this.schoolScope.assertSchoolAccess(actor, dto.schoolId);
    }

    const receiptNo = await this.documentNumberService.generateNumber(DocumentType.RECEIPT);

    const receipt = await this.prisma.receipt.create({
      data: {
        receiptNo,
        schoolId: dto.schoolId || null,
        date: new Date(dto.date),
        type: dto.type,
        description: dto.description,
        amount: dto.amount,
        bankAccountId: dto.bankAccountId,
      },
      include: { school: true, bankAccount: true },
    });

    await this.createLedgerEntries(receipt);

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.RECEIPT_CREATE,
        entityType: 'Receipt',
        entityId: receipt.id,
        schoolId: receipt.schoolId ?? undefined,
        metadata: { receiptNo: receipt.receiptNo, amount: Number(receipt.amount) },
        ipAddress,
      });
    }

    return receipt;
  }

  async findAll(schoolId?: string, type?: ReceiptType, startDate?: Date, endDate?: Date) {
    const where: any = {};
    if (schoolId) where.schoolId = schoolId;
    if (type) where.type = type;
    if (startDate && endDate) {
      where.date = { gte: startDate, lte: endDate };
    }

    return this.prisma.receipt.findMany({
      where,
      include: { school: true, bankAccount: true },
      orderBy: { date: 'desc' },
    });
  }

  async findById(id: string, actor?: ScopedUser) {
    const receipt = await this.prisma.receipt.findUnique({
      where: { id },
      include: {
        school: true,
        bankAccount: true,
        ledgerEntries: { include: { account: true } },
        memberContribution: { include: { member: true, period: true } },
      },
    });

    if (!receipt) {
      throw new NotFoundException('ไม่พบใบเสร็จ');
    }

    if (actor) {
      this.schoolScope.assertResourceSchoolAccess(actor, receipt.schoolId);
    }

    return receipt;
  }

  async getSummary(schoolId?: string, startDate?: Date, endDate?: Date) {
    const where: any = {};
    if (schoolId) where.schoolId = schoolId;
    if (startDate && endDate) {
      where.date = { gte: startDate, lte: endDate };
    }

    const byType = await this.prisma.receipt.groupBy({
      by: ['type'],
      where,
      _sum: { amount: true },
      _count: true,
    });

    const total = await this.prisma.receipt.aggregate({
      where,
      _sum: { amount: true },
      _count: true,
    });

    return {
      byType: byType.map((item) => ({
        type: item.type,
        count: item._count,
        amount: Number(item._sum.amount || 0),
      })),
      total: {
        count: total._count,
        amount: Number(total._sum.amount || 0),
      },
    };
  }

  private async createLedgerEntries(receipt: any) {
    // Get accounts
    const cashAccount = await this.prisma.account.findFirst({ where: { code: '101' } });
    const bankAccount = await this.prisma.account.findFirst({ where: { code: '102' } });
    const welfareRevenue = await this.prisma.account.findFirst({ where: { code: '401' } });
    const serviceRevenue = await this.prisma.account.findFirst({ where: { code: '402' } });

    if (!cashAccount || !welfareRevenue) return;

    const debitAccountId = receipt.bankAccountId ? bankAccount?.id : cashAccount.id;
    let creditAccountId = welfareRevenue.id;

    // Determine credit account based on receipt type
    if (receipt.type === ReceiptType.MEMBER_CONTRIBUTION) {
      creditAccountId = welfareRevenue.id;
    }

    if (debitAccountId && creditAccountId) {
      await this.prisma.ledgerEntry.createMany({
        data: [
          {
            accountId: debitAccountId,
            date: receipt.date,
            description: receipt.description || `ใบเสร็จ ${receipt.receiptNo}`,
            debit: receipt.amount,
            credit: 0,
            receiptId: receipt.id,
          },
          {
            accountId: creditAccountId,
            date: receipt.date,
            description: receipt.description || `ใบเสร็จ ${receipt.receiptNo}`,
            debit: 0,
            credit: receipt.amount,
            receiptId: receipt.id,
          },
        ],
      });
    }
  }
}

