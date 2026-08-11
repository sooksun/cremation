import { BadRequestException, Injectable, Logger, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateCashBookDto, UpdateCashBookDto } from './dto/cash-book.dto';
import { SchoolScopeService, ScopedUser } from '../common/security/school-scope.service';
import { AuditLogService } from '../common/services/audit-log.service';
import { AuditAction, Prisma } from '@prisma/client';

@Injectable()
export class CashBookService {
  private readonly logger = new Logger(CashBookService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly schoolScope: SchoolScopeService,
    private readonly auditLog: AuditLogService,
  ) {}

  // ไม่มี AuditAction เฉพาะสำหรับ CashBook — ใช้ตัวที่ใกล้เคียงที่สุดตามทิศทางเงิน
  // (IN ~ รับเงิน/RECEIPT, OUT ~ จ่ายเงิน/PAYMENT_VOUCHER) ส่วน operation จริง (create/update/remove)
  // ระบุใน metadata แทน เนื่องจาก schema ไม่มี action UPDATE/DELETE ของ entity นี้
  private resolveCashBookAuditAction(type: string): AuditAction {
    return type === 'OUT' ? AuditAction.PAYMENT_VOUCHER_CREATE : AuditAction.RECEIPT_CREATE;
  }

  async create(dto: CreateCashBookDto, actor?: ScopedUser) {
    let schoolId: string | undefined;

    if (actor) {
      if (this.schoolScope.canAccessAllSchools(actor)) {
        if (!dto.schoolId) {
          throw new BadRequestException('ผู้ดูแลระบบต้องระบุโรงเรียน');
        }
        schoolId = dto.schoolId;
      } else {
        if (!actor.schoolId) {
          throw new BadRequestException('ผู้ใช้นี้ไม่ได้ผูกกับโรงเรียน');
        }
        schoolId = actor.schoolId; // ห้ามเชื่อ dto.schoolId สำหรับ role ที่ไม่ใช่ ADMIN
      }
    } else {
      schoolId = dto.schoolId;
      if (!schoolId) {
        throw new BadRequestException('ต้องระบุโรงเรียน');
      }
    }

    const entry = await this.prisma.cashBook.create({
      data: {
        date: new Date(dto.date),
        type: dto.type,
        amount: dto.amount,
        description: dto.description,
        receiptId: dto.receiptId,
        paymentId: dto.paymentId,
        schoolId,
      },
      include: { school: true },
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: this.resolveCashBookAuditAction(entry.type),
        entityType: 'CashBook',
        entityId: entry.id,
        schoolId: entry.schoolId,
        metadata: { operation: 'create', type: entry.type, amount: Number(entry.amount) },
      });
    }

    return entry;
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

    const updated = await this.prisma.cashBook.update({
      where: { id },
      data: {
        date: dto.date ? new Date(dto.date) : undefined,
        type: dto.type,
        amount: dto.amount,
        description: dto.description,
      },
      include: { school: true },
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: this.resolveCashBookAuditAction(updated.type),
        entityType: 'CashBook',
        entityId: updated.id,
        schoolId: updated.schoolId,
        metadata: { operation: 'update', type: updated.type, amount: Number(updated.amount) },
      });
    }

    return updated;
  }

  async remove(id: string, actor?: ScopedUser) {
    const entry = await this.findById(id, actor);
    // soft-delete — เก็บหลักฐาน 10 ปี (ข้อบังคับสมาคม ข้อ 30) แทนลบถาวร
    const removed = await this.prisma.cashBook.update({
      where: { id },
      data: { deletedAt: new Date() },
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: this.resolveCashBookAuditAction(entry.type),
        entityType: 'CashBook',
        entityId: id,
        schoolId: entry.schoolId,
        metadata: { operation: 'remove', type: entry.type, amount: Number(entry.amount) },
      });
    }

    return removed;
  }

  // Auto create from receipt/payment if cash — เรียกจาก receipts/payments service (อาจอยู่ใน $transaction)
  async createFromReceipt(receipt: any, tx: Prisma.TransactionClient = this.prisma) {
    if (receipt.bankAccountId) return null; // bank, not cash

    if (!receipt.schoolId) {
      this.logger.warn(
        `createFromReceipt: receipt ${receipt.receiptNo ?? receipt.id} ไม่มี schoolId — ข้ามการสร้างรายการสมุดเงินสด`,
      );
      return null;
    }

    const data = {
      schoolId: receipt.schoolId,
      date: receipt.date,
      type: 'IN',
      amount: receipt.amount,
      description: `รับเงินสด ${receipt.receiptNo}`,
      receiptId: receipt.id,
    };
    // กัน unique(receiptId) ชนกับแถวที่ soft-deleted — reactivate แทนสร้างใหม่
    const existing = await tx.cashBook.findFirst({ where: { receiptId: receipt.id } });
    if (existing) {
      return tx.cashBook.update({
        where: { id: existing.id },
        data: { ...data, deletedAt: null },
      });
    }
    return tx.cashBook.create({ data });
  }

  async createFromPayment(payment: any, tx: Prisma.TransactionClient = this.prisma) {
    if (payment.bankAccountId) return null;

    if (!payment.schoolId) {
      this.logger.warn(
        `createFromPayment: payment ${payment.voucherNo ?? payment.id} ไม่มี schoolId — ข้ามการสร้างรายการสมุดเงินสด`,
      );
      return null;
    }

    const data = {
      schoolId: payment.schoolId,
      date: payment.date,
      type: 'OUT',
      amount: payment.amount,
      description: `จ่ายเงินสด ${payment.voucherNo}`,
      paymentId: payment.id,
    };
    // กัน unique(paymentId) ชนกับแถวที่ soft-deleted — reactivate แทนสร้างใหม่
    const existing = await tx.cashBook.findFirst({ where: { paymentId: payment.id } });
    if (existing) {
      return tx.cashBook.update({
        where: { id: existing.id },
        data: { ...data, deletedAt: null },
      });
    }
    return tx.cashBook.create({ data });
  }
}