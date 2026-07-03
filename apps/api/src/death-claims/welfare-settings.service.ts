import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { UpdateDeathBenefitFixedDto } from './dto/update-death-benefit-fixed.dto';
import { AuditLogService } from '../common/services/audit-log.service';
import { AuditAction } from '@prisma/client';
import { ScopedUser } from '../common/security/school-scope.service';

@Injectable()
export class WelfareSettingsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly auditLog: AuditLogService,
  ) {}

  async getCurrentDeathBenefitFixed() {
    const setting = await this.prisma.welfareSettings.findFirst({
      where: { isActive: true },
      orderBy: { effectiveDate: 'desc' },
    });

    if (!setting) {
      return null;
    }

    return {
      id: setting.id,
      effectiveDate: setting.effectiveDate,
      welfareAmountPerCase: Number(setting.welfareAmountPerCase),
      description: setting.description,
      isActive: setting.isActive,
    };
  }

  async updateDeathBenefitFixed(dto: UpdateDeathBenefitFixedDto, actor?: ScopedUser) {
    // Deactivate all previous
    await this.prisma.welfareSettings.updateMany({
      where: { isActive: true },
      data: { isActive: false },
    });

    const effectiveDate = dto.effectiveDate ? new Date(dto.effectiveDate) : new Date();

    const created = await this.prisma.welfareSettings.create({
      data: {
        effectiveDate,
        welfareAmountPerCase: dto.welfareAmountPerCase,
        description: dto.description,
        isActive: true,
      },
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.WELFARE_SETTINGS_UPDATE,
        entityType: 'WelfareSettings',
        entityId: created.id,
        metadata: { welfareAmountPerCase: Number(created.welfareAmountPerCase), description: created.description },
      });
    }

    return {
      id: created.id,
      effectiveDate: created.effectiveDate,
      welfareAmountPerCase: Number(created.welfareAmountPerCase),
      description: created.description,
      isActive: created.isActive,
    };
  }
}