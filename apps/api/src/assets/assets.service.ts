import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateAssetDto, UpdateAssetDto, RecordDepreciationDto } from './dto/asset.dto';
import { SchoolScopeService, ScopedUser } from '../common/security/school-scope.service';
import { AuditLogService } from '../common/services/audit-log.service';
import { AuditAction } from '@prisma/client';

@Injectable()
export class AssetsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly schoolScope: SchoolScopeService,
    private readonly auditLog: AuditLogService,
  ) {}

  async create(dto: CreateAssetDto, actor?: ScopedUser) {
    const dtoAny = dto as any;
    if (actor && dtoAny.schoolId) {
      this.schoolScope.assertSchoolAccess(actor, dtoAny.schoolId);
    }

    const schoolId = dtoAny.schoolId || actor?.schoolId;

    const asset = await this.prisma.asset.create({
      data: {
        ...dto,
        purchaseDate: new Date(dto.purchaseDate),
        originalCost: dto.originalCost,
        salvageValue: dto.salvageValue || 0,
        accumulatedDep: 0,
        schoolId: schoolId || undefined,
      },
      include: { school: true },
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.ASSET_CREATE,
        entityType: 'Asset',
        entityId: asset.id,
        schoolId: asset.schoolId,
        metadata: { name: asset.name, cost: Number(asset.originalCost) },
      });
    }
    return asset;
  }

  async findAll(schoolId?: string, actor?: ScopedUser) {
    const where: any = { status: 'ACTIVE' };
    const effectiveSchoolId = this.schoolScope.resolveSchoolId(actor as any, schoolId);
    if (effectiveSchoolId) where.schoolId = effectiveSchoolId;

    return this.prisma.asset.findMany({
      where,
      include: { school: { select: { id: true, name: true, code: true } } },
      orderBy: { purchaseDate: 'desc' },
    });
  }

  async findById(id: string, actor?: ScopedUser) {
    const asset = await this.prisma.asset.findUnique({
      where: { id },
      include: { school: true },
    });
    if (!asset) throw new NotFoundException('ไม่พบสินทรัพย์');

    if (actor) {
      this.schoolScope.assertSchoolAccess(actor, asset.schoolId);
    }
    return asset;
  }

  async update(id: string, dto: UpdateAssetDto, actor?: ScopedUser) {
    await this.findById(id, actor);

    const data: any = { ...dto };
    if (dto.purchaseDate) data.purchaseDate = new Date(dto.purchaseDate);
    if (dto.disposalDate) data.disposalDate = new Date(dto.disposalDate);

    const updated = await this.prisma.asset.update({
      where: { id },
      data,
      include: { school: true },
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.ASSET_UPDATE,
        entityType: 'Asset',
        entityId: id,
        schoolId: updated.schoolId,
        metadata: { updatedFields: Object.keys(dto) },
      });
    }
    return updated;
  }

  async remove(id: string, actor?: ScopedUser) {
    await this.findById(id, actor);
    const asset = await this.prisma.asset.findUnique({ where: { id } });
    const updated = await this.prisma.asset.update({
      where: { id },
      data: { status: 'DISPOSED' },
    });

    if (actor && asset) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.ASSET_DISPOSE,
        entityType: 'Asset',
        entityId: id,
        schoolId: asset.schoolId,
        metadata: { name: asset.name, status: 'DISPOSED' },
      });
    }
    return updated;
  }

  // Calculate straight-line depreciation for a year
  calculateAnnualDepreciation(asset: any, year?: number): number {
    const cost = Number(asset.originalCost);
    const salvage = Number(asset.salvageValue || 0);
    const life = asset.usefulLifeYears;
    if (!life || life <= 0) return 0;

    const dep = (cost - salvage) / life;
    return Math.round(dep * 100) / 100;
  }

  // Get current book value
  getBookValue(asset: any): number {
    const cost = Number(asset.originalCost);
    const accum = Number(asset.accumulatedDep || 0);
    return Math.max(0, Math.round((cost - accum) * 100) / 100);
  }

  // Record depreciation for the year (updates accumulated + creates ledger if accounts exist)
  async recordDepreciation(id: string, dto: RecordDepreciationDto, actor?: ScopedUser) {
    const asset = await this.findById(id, actor);
    const year = dto.year || new Date().getFullYear();

    const annualDep = dto.amount ?? this.calculateAnnualDepreciation(asset, year);
    if (annualDep <= 0) {
      return { message: 'ไม่มีการคำนวณค่าเสื่อมราคา', asset };
    }

    const newAccum = Number(asset.accumulatedDep || 0) + annualDep;

    // Try to create ledger entry for depreciation (debit expense, credit accum)
    // Find typical accounts (can be configured later)
    const depExpense = await this.prisma.account.findFirst({ where: { code: '503' } }); // Depreciation Expense
    const accumDepContra = await this.prisma.account.findFirst({ where: { code: '152' } }); // Accumulated Depreciation

    let ledgerCreated = false;
    if (depExpense && accumDepContra) {
      await this.prisma.ledgerEntry.createMany({
        data: [
          {
            accountId: depExpense.id,
            date: new Date(year, 11, 31), // end of year
            description: `ค่าเสื่อมราคา ${asset.name} ปี ${year}`,
            debit: annualDep,
            credit: 0,
          },
          {
            accountId: accumDepContra.id,
            date: new Date(year, 11, 31),
            description: `ค่าเสื่อมราคา ${asset.name} ปี ${year}`,
            debit: 0,
            credit: annualDep,
          },
        ],
      });
      ledgerCreated = true;
    }

    const updated = await this.prisma.asset.update({
      where: { id },
      data: { accumulatedDep: newAccum },
      include: { school: true },
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.ASSET_DEPRECIATION_RECORD,
        entityType: 'Asset',
        entityId: id,
        schoolId: updated.schoolId,
        metadata: { year, amount: annualDep },
      });
    }

    return {
      message: `บันทึกค่าเสื่อมราคา ${annualDep} สำหรับปี ${year}`,
      asset: updated,
      bookValue: this.getBookValue(updated),
      ledgerCreated,
    };
  }

  // Depreciation schedule for one asset (basic yearly projection)
  getDepreciationSchedule(asset: any) {
    const cost = Number(asset.originalCost);
    const salvage = Number(asset.salvageValue || 0);
    const life = asset.usefulLifeYears;
    const annual = this.calculateAnnualDepreciation(asset);

    const schedule = [];
    let accum = 0;
    for (let y = 1; y <= life; y++) {
      accum = Math.min(accum + annual, cost - salvage);
      const book = Math.max(0, cost - accum);
      schedule.push({
        year: new Date(asset.purchaseDate).getFullYear() + y,
        depreciation: Math.round(annual * 100) / 100,
        accumulated: Math.round(accum * 100) / 100,
        bookValue: Math.round(book * 100) / 100,
      });
    }
    return schedule;
  }
}