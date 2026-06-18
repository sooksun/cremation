import { Injectable } from '@nestjs/common';
import { AuditAction, Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

export interface AuditLogInput {
  userId: string;
  action: AuditAction;
  entityType: string;
  entityId: string;
  schoolId?: string;
  metadata?: Prisma.InputJsonValue;
  ipAddress?: string;
}

export interface AuditLogQuery {
  action?: AuditAction;
  entityType?: string;
  entityId?: string;
  schoolId?: string;
  userId?: string;
  from?: Date;
  to?: Date;
  limit?: number;
}

@Injectable()
export class AuditLogService {
  constructor(private readonly prisma: PrismaService) {}

  async log(input: AuditLogInput): Promise<void> {
    await this.prisma.auditLog.create({
      data: {
        userId: input.userId,
        action: input.action,
        entityType: input.entityType,
        entityId: input.entityId,
        schoolId: input.schoolId,
        metadata: input.metadata,
        ipAddress: input.ipAddress,
      },
    });
  }

  async findMany(query: AuditLogQuery) {
    const where: Prisma.AuditLogWhereInput = {};
    if (query.action) where.action = query.action;
    if (query.entityType) where.entityType = query.entityType;
    if (query.entityId) where.entityId = query.entityId;
    if (query.schoolId) where.schoolId = query.schoolId;
    if (query.userId) where.userId = query.userId;
    if (query.from || query.to) {
      where.createdAt = {};
      if (query.from) where.createdAt.gte = query.from;
      if (query.to) where.createdAt.lte = query.to;
    }

    return this.prisma.auditLog.findMany({
      where,
      include: {
        user: { select: { id: true, fullName: true, role: true } },
      },
      orderBy: { createdAt: 'desc' },
      take: query.limit ?? 100,
    });
  }
}