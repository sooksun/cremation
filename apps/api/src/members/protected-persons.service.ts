import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateProtectedPersonDto, UpdateProtectedPersonDto } from './dto/protected-person.dto';
import { SchoolScopeService, ScopedUser } from '../common/security/school-scope.service';

@Injectable()
export class ProtectedPersonsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly schoolScope: SchoolScopeService,
  ) {}

  async findByMember(memberId: string, actor?: ScopedUser) {
    await this.assertMemberAccess(actor, memberId);
    return this.prisma.protectedPerson.findMany({
      where: { memberId },
      orderBy: [{ isActive: 'desc' }, { createdAt: 'asc' }],
    });
  }

  async create(memberId: string, dto: CreateProtectedPersonDto, actor?: ScopedUser) {
    await this.assertMemberAccess(actor, memberId);
    return this.prisma.protectedPerson.create({
      data: {
        memberId,
        fullName: dto.fullName,
        relationship: dto.relationship,
        nationalId: dto.nationalId,
        phone: dto.phone,
      },
    });
  }

  async update(id: string, dto: UpdateProtectedPersonDto, actor?: ScopedUser) {
    const person = await this.ensureExists(id);
    await this.assertMemberAccess(actor, person.memberId);
    return this.prisma.protectedPerson.update({
      where: { id },
      data: {
        fullName: dto.fullName,
        relationship: dto.relationship,
        nationalId: dto.nationalId,
        phone: dto.phone,
        isActive: dto.isActive,
        endedAt: dto.isActive === false ? new Date() : dto.isActive === true ? null : undefined,
        endReason: dto.endReason,
      },
    });
  }

  async remove(id: string, actor?: ScopedUser) {
    const person = await this.ensureExists(id);
    await this.assertMemberAccess(actor, person.memberId);
    await this.prisma.protectedPerson.delete({ where: { id } });
    return { message: 'ลบผู้ได้รับการคุ้มครองสำเร็จ' };
  }

  async syncForMember(
    memberId: string,
    persons: {
      fullName: string;
      relationship: import('@prisma/client').ProtectedRelationship;
      nationalId?: string;
      phone?: string;
    }[],
  ) {
    await this.prisma.protectedPerson.deleteMany({ where: { memberId } });
    if (persons.length === 0) return [];
    await this.prisma.protectedPerson.createMany({
      data: persons.map((p) => ({
        memberId,
        fullName: p.fullName,
        relationship: p.relationship,
        nationalId: p.nationalId,
        phone: p.phone,
      })),
    });
    return this.findByMember(memberId);
  }

  private async assertMemberAccess(actor: ScopedUser | undefined, memberId: string): Promise<void> {
    if (!actor) return;

    const member = await this.prisma.member.findUnique({
      where: { id: memberId },
      select: { schoolId: true },
    });
    if (!member) {
      throw new NotFoundException('ไม่พบสมาชิก');
    }
    this.schoolScope.assertSchoolAccess(actor, member.schoolId);
  }

  private async ensureExists(id: string) {
    const person = await this.prisma.protectedPerson.findUnique({ where: { id } });
    if (!person) throw new NotFoundException('ไม่พบผู้ได้รับการคุ้มครอง');
    return person;
  }
}