import { ForbiddenException, Injectable, Logger, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { DocumentNumberService, DocumentType } from '../common/document-number.service';
import { CreateReceiptDto } from './dto/create-receipt.dto';
import { AuditAction, Prisma, ReceiptType, Role } from '@prisma/client';
import { SchoolScopeService, ScopedUser } from '../common/security/school-scope.service';
import { AuditLogService } from '../common/services/audit-log.service';
import { CashBookService } from '../cash-book/cash-book.service';

@Injectable()
export class ReceiptsService {
  private readonly logger = new Logger(ReceiptsService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly documentNumberService: DocumentNumberService,
    private readonly auditLog: AuditLogService,
    private readonly schoolScope: SchoolScopeService,
    private readonly cashBook: CashBookService,
  ) {}

  async create(dto: CreateReceiptDto, actor?: ScopedUser, ipAddress?: string) {
    if (actor && dto.schoolId) {
      this.schoolScope.assertSchoolAccess(actor, dto.schoolId);
    }

    // เลขเอกสารสร้างนอก transaction (pattern เดียวกับ death-claims.service.ts)
    const receiptNo = await this.documentNumberService.generateNumber(DocumentType.RECEIPT);

    const receipt = await this.prisma.$transaction(async (tx) => {
      const created = await tx.receipt.create({
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

      await this.createLedgerEntries(created, tx);

      if (!created.bankAccountId) {
        await this.cashBook.createFromReceipt(created, tx);
      }

      return created;
    });

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
        memberContribution: {
          include: {
            member: { include: { associationMember: true, school: true } },
            period: true,
          },
        },
      },
    });

    if (!receipt) {
      throw new NotFoundException('ไม่พบใบเสร็จ');
    }

    if (actor) {
      if (actor.role === Role.MEMBER) {
        if (receipt.memberContribution?.memberId !== actor.memberId) {
          throw new ForbiddenException('บัญชีสมาชิกเข้าถึงได้เฉพาะใบเสร็จของตนเอง');
        }
      } else {
        this.schoolScope.assertResourceSchoolAccess(actor, receipt.schoolId);
      }
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

  private async createLedgerEntries(receipt: any, tx: Prisma.TransactionClient = this.prisma) {
    // Get accounts
    const cashAccount = await tx.account.findFirst({ where: { code: '101' } });
    const bankAccount = await tx.account.findFirst({ where: { code: '102' } });
    const welfareRevenue = await tx.account.findFirst({ where: { code: '401' } });
    const serviceRevenue = await tx.account.findFirst({ where: { code: '402' } });

    if (!cashAccount || !welfareRevenue) {
      const missing = [!cashAccount && '101 (เงินสด)', !welfareRevenue && '401 (รายได้เงินสงเคราะห์)']
        .filter(Boolean)
        .join(', ');
      this.logger.warn(
        `createLedgerEntries: ไม่พบบัญชี ${missing} — ข้ามการบันทึกบัญชีสำหรับใบเสร็จ ${receipt.receiptNo}`,
      );
      return;
    }

    const debitAccountId = receipt.bankAccountId ? bankAccount?.id : cashAccount.id;
    let creditAccountId = welfareRevenue.id;

    // Determine credit account based on receipt type
    if (receipt.type === ReceiptType.MEMBER_CONTRIBUTION) {
      creditAccountId = welfareRevenue.id;
    }

    if (debitAccountId && creditAccountId) {
      const entries = [
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
      ];

      // Double-entry validation
      const totalDebit = entries.reduce((s, e) => s + Number(e.debit), 0);
      const totalCredit = entries.reduce((s, e) => s + Number(e.credit), 0);
      if (Math.abs(totalDebit - totalCredit) > 0.01) {
        throw new Error(`Double-entry violation in Receipt ${receipt.receiptNo}: Debit ${totalDebit} != Credit ${totalCredit}`);
      }

      await tx.ledgerEntry.createMany({ data: entries });
    } else {
      this.logger.warn(
        `createLedgerEntries: ไม่พบบัญชี 102 (เงินฝากธนาคาร) — ข้ามการบันทึกบัญชีสำหรับใบเสร็จ ${receipt.receiptNo}`,
      );
    }
  }
}

