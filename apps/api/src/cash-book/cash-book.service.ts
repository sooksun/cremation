import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateCashBookDto, UpdateCashBookDto } from './dto/cash-book.dto';
import { SchoolScopeService, ScopedUser } from '../common/security/school-scope.service';

@Injectable()
export class CashBookService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly schoolScope: SchoolScopeService,
  ) {}

  async create(dto: CreateCashBookDto, actor?: ScopedUser) {
    if (actor) {
      const schoolId = actor.schoolId;
      if (schoolId) {
        this.schoolScope.assertSchoolAccess(actor, schoolId);
      }
    }

    return this.prisma.cashBook.create({
      data: {
        date: new Date(dto.date),
        type: dto.type,
        amount: dto.amount,
        description: dto.description,
        receiptId: dto.receiptId,
        paymentId: dto.paymentId,
        schoolId: actor?.schoolId || '', // fallback, but should be set
      },
      include: { school: true },
    });
  }

  async findAll(schoolId?: string, actor?: ScopedUser) {
    const effectiveSchoolId = this.schoolScope.resolveSchoolId(actor as any, schoolId);
    const where: any = {};
    if (effectiveSchoolId) where.schoolId = effectiveSchoolId;

    return this.prisma.cashBook.findMany({
      where,
      include: { school: { select: { id: true, name: true } } },
      orderBy: { date: 'desc' },
    });
  }

  async findById(id: string, actor?: ScopedUser) {
    const entry = await this.prisma.cashBook.findUnique({
      where: { id },
      include: { school: true },
    });
    if (!entry) throw new NotFoundException('ไม่พบรายการเงินสด');

    if (actor) {
      this.schoolScope.assertSchoolAccess(actor, entry.schoolId);
    }
    return entry;
  }

  async update(id: string, dto: UpdateCashBookDto, actor?: ScopedUser) {
    await this.findById(id, actor);

    return this.prisma.cashBook.update({
      where: { id },
      data: {
        date: dto.date ? new Date(dto.date) : undefined,
        type: dto.type,
        amount: dto.amount,
        description: dto.description,
      },
      include: { school: true },
    });
  }

  async remove(id: string, actor?: ScopedUser) {
    await this.findById(id, actor);
    return this.prisma.cashBook.delete({ where: { id } });
  }

  // Auto create from receipt/payment if cash
  async createFromReceipt(receipt: any) {
    if (receipt.bankAccountId) return null; // bank, not cash

    return this.prisma.cashBook.create({
      data: {
        schoolId: receipt.schoolId,
        date: receipt.date,
        type: 'IN',
        amount: receipt.amount,
        description: `รับเงินสด ${receipt.receiptNo}`,
        receiptId: receipt.id,
      },
    });
  }

  async createFromPayment(payment: any) {
    if (payment.bankAccountId) return null;

    return this.prisma.cashBook.create({
      data: {
        schoolId: payment.schoolId,
        date: payment.date,
        type: 'OUT',
        amount: payment.amount,
        description: `จ่ายเงินสด ${payment.voucherNo}`,
        paymentId: payment.id,
      },
    });
  }
}