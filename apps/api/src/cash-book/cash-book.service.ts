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
    const where: any = { deletedAt: null };
    if (effectiveSchoolId) where.schoolId = effectiveSchoolId;

    return this.prisma.cashBook.findMany({
      where,
      include: { school: { select: { id: true, name: true } } },
      orderBy: { date: 'desc' },
    });
  }

  async findById(id: string, actor?: ScopedUser) {
    const entry = await this.prisma.cashBook.findFirst({
      where: { id, deletedAt: null },
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
    // soft-delete — เก็บหลักฐาน 10 ปี (ข้อบังคับสมาคม ข้อ 30) แทนลบถาวร
    return this.prisma.cashBook.update({
      where: { id },
      data: { deletedAt: new Date() },
    });
  }

  // Auto create from receipt/payment if cash
  async createFromReceipt(receipt: any) {
    if (receipt.bankAccountId) return null; // bank, not cash

    const data = {
      schoolId: receipt.schoolId,
      date: receipt.date,
      type: 'IN',
      amount: receipt.amount,
      description: `รับเงินสด ${receipt.receiptNo}`,
      receiptId: receipt.id,
    };
    // กัน unique(receiptId) ชนกับแถวที่ soft-deleted — reactivate แทนสร้างใหม่
    const existing = await this.prisma.cashBook.findFirst({ where: { receiptId: receipt.id } });
    if (existing) {
      return this.prisma.cashBook.update({
        where: { id: existing.id },
        data: { ...data, deletedAt: null },
      });
    }
    return this.prisma.cashBook.create({ data });
  }

  async createFromPayment(payment: any) {
    if (payment.bankAccountId) return null;

    const data = {
      schoolId: payment.schoolId,
      date: payment.date,
      type: 'OUT',
      amount: payment.amount,
      description: `จ่ายเงินสด ${payment.voucherNo}`,
      paymentId: payment.id,
    };
    // กัน unique(paymentId) ชนกับแถวที่ soft-deleted — reactivate แทนสร้างใหม่
    const existing = await this.prisma.cashBook.findFirst({ where: { paymentId: payment.id } });
    if (existing) {
      return this.prisma.cashBook.update({
        where: { id: existing.id },
        data: { ...data, deletedAt: null },
      });
    }
    return this.prisma.cashBook.create({ data });
  }
}