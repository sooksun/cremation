import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateBeneficiaryDto, UpdateBeneficiaryDto } from './dto/beneficiary.dto';
import { SchoolScopeService, ScopedUser } from '../common/security/school-scope.service';

@Injectable()
export class BeneficiariesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly schoolScope: SchoolScopeService,
  ) {}

  async create(memberId: string, dto: CreateBeneficiaryDto, actor?: ScopedUser) {
    await this.assertMemberAccess(actor, memberId);

    const count = await this.prisma.beneficiary.count({ where: { memberId } });

    return this.prisma.beneficiary.create({
      data: {
        memberId,
        fullName: dto.fullName,
        relationship: dto.relationship,
        phone: dto.phone,
        priority: dto.priority || count + 1,
      },
    });
  }

  async update(id: string, dto: UpdateBeneficiaryDto, actor?: ScopedUser) {
    const beneficiary = await this.prisma.beneficiary.findUnique({ where: { id } });

    if (!beneficiary) {
      throw new NotFoundException('ไม่พบผู้รับผลประโยชน์');
    }

    await this.assertMemberAccess(actor, beneficiary.memberId);

    return this.prisma.beneficiary.update({
      where: { id },
      data: dto,
    });
  }

  async remove(id: string, actor?: ScopedUser) {
    const beneficiary = await this.prisma.beneficiary.findUnique({ where: { id } });

    if (!beneficiary) {
      throw new NotFoundException('ไม่พบผู้รับผลประโยชน์');
    }

    await this.assertMemberAccess(actor, beneficiary.memberId);

    await this.prisma.beneficiary.delete({ where: { id } });
    return { message: 'ลบผู้รับผลประโยชน์สำเร็จ' };
  }

  private async assertMemberAccess(actor: ScopedUser | undefined, memberId: string): Promise<void> {
    if (!actor) return;

    this.schoolScope.assertMemberSelfAccess(actor, memberId);

    const member = await this.prisma.member.findUnique({
      where: { id: memberId },
      select: { schoolId: true },
    });
    if (!member) {
      throw new NotFoundException('ไม่พบสมาชิก');
    }
    this.schoolScope.assertSchoolAccess(actor, member.schoolId);
  }
}
