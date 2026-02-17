import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateBeneficiaryDto, UpdateBeneficiaryDto } from './dto/beneficiary.dto';

@Injectable()
export class BeneficiariesService {
  constructor(private readonly prisma: PrismaService) {}

  async create(memberId: string, dto: CreateBeneficiaryDto) {
    // Count existing beneficiaries to set default priority
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

  async update(id: string, dto: UpdateBeneficiaryDto) {
    const beneficiary = await this.prisma.beneficiary.findUnique({ where: { id } });

    if (!beneficiary) {
      throw new NotFoundException('ไม่พบผู้รับผลประโยชน์');
    }

    return this.prisma.beneficiary.update({
      where: { id },
      data: dto,
    });
  }

  async remove(id: string) {
    const beneficiary = await this.prisma.beneficiary.findUnique({ where: { id } });

    if (!beneficiary) {
      throw new NotFoundException('ไม่พบผู้รับผลประโยชน์');
    }

    await this.prisma.beneficiary.delete({ where: { id } });
    return { message: 'ลบผู้รับผลประโยชน์สำเร็จ' };
  }
}

