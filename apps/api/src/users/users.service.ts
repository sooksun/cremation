import {
  BadRequestException,
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Role } from '@prisma/client';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../prisma/prisma.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  private async getMemberForAccount(memberId: string, currentUserId?: string) {
    const member = await this.prisma.member.findUnique({
      where: { id: memberId },
      include: {
        associationMember: true,
        user: { select: { id: true } },
      },
    });

    if (!member) {
      throw new NotFoundException('ไม่พบสมาชิกที่เลือก');
    }
    if (member.user && member.user.id !== currentUserId) {
      throw new ConflictException('สมาชิกนี้มีบัญชีผู้ใช้แล้ว');
    }
    return member;
  }

  async create(dto: CreateUserDto) {
    if (dto.role === Role.SCHOOL_ADMIN) {
      throw new BadRequestException(
        'ผู้ดูแลโรงเรียนให้จัดการผ่านเมนูผู้ดูแลโรงเรียน (โรงเรียนละ 1 คน)',
      );
    }
    if (dto.role === Role.MEMBER && !dto.memberId) {
      throw new BadRequestException('กรุณาเลือกสมาชิก');
    }
    if (dto.role !== Role.MEMBER && dto.memberId) {
      throw new BadRequestException('memberId ใช้ได้เฉพาะบัญชีสมาชิก');
    }

    const existing = await this.prisma.user.findUnique({
      where: { username: dto.username },
    });
    if (existing) {
      throw new ConflictException('ชื่อผู้ใช้นี้ถูกใช้งานแล้ว');
    }

    const member = dto.memberId
      ? await this.getMemberForAccount(dto.memberId)
      : null;
    const passwordHash = await bcrypt.hash(dto.password, 10);
    const user = await this.prisma.user.create({
      data: {
        username: dto.username,
        passwordHash,
        fullName: dto.fullName,
        role: dto.role,
        schoolId: member?.schoolId ?? dto.schoolId,
        groupId: member ? null : dto.groupId,
        memberId: member?.id,
        mustChangePassword: true,
      },
      include: {
        school: true,
        member: { include: { associationMember: true } },
      },
    });

    const { passwordHash: _, ...result } = user;
    return result;
  }

  async findAll(schoolId?: string) {
    const users = await this.prisma.user.findMany({
      where: {
        role: { not: Role.SCHOOL_ADMIN },
        ...(schoolId ? { schoolId } : {}),
      },
      include: {
        school: true,
        member: { include: { associationMember: true } },
      },
      orderBy: { createdAt: 'desc' },
    });
    return users.map(({ passwordHash, ...user }) => user);
  }

  async findById(id: string) {
    const user = await this.prisma.user.findUnique({
      where: { id },
      include: {
        school: true,
        member: { include: { associationMember: true } },
      },
    });
    if (!user) {
      throw new NotFoundException('ไม่พบผู้ใช้');
    }
    return user;
  }

  async findByUsername(username: string) {
    return this.prisma.user.findUnique({
      where: { username },
      include: {
        school: true,
        member: { include: { associationMember: true } },
      },
    });
  }

  async update(id: string, dto: UpdateUserDto) {
    const user = await this.findById(id);
    const nextRole = dto.role ?? user.role;

    if (
      dto.role !== undefined &&
      (dto.role === Role.SCHOOL_ADMIN || user.role === Role.SCHOOL_ADMIN)
    ) {
      throw new BadRequestException(
        'ผู้ดูแลโรงเรียนให้จัดการผ่านเมนูผู้ดูแลโรงเรียน',
      );
    }

    const data: Record<string, unknown> = {};
    if (dto.fullName !== undefined) data.fullName = dto.fullName;
    if (dto.role !== undefined) data.role = dto.role;
    if (dto.signature !== undefined) data.signature = dto.signature;
    if (dto.mustChangePassword !== undefined) {
      data.mustChangePassword = dto.mustChangePassword;
    }
    if (dto.password) data.passwordHash = await bcrypt.hash(dto.password, 10);

    if (nextRole === Role.MEMBER) {
      const memberId = dto.memberId ?? user.memberId;
      if (!memberId) {
        throw new BadRequestException('กรุณาเลือกสมาชิก');
      }
      const member = await this.getMemberForAccount(memberId, id);
      data.memberId = member.id;
      data.schoolId = member.schoolId;
      data.groupId = null;
    } else {
      if (dto.memberId) {
        throw new BadRequestException('memberId ใช้ได้เฉพาะบัญชีสมาชิก');
      }
      if (user.memberId) data.memberId = null;
      if (dto.schoolId !== undefined) data.schoolId = dto.schoolId;
      if (dto.groupId !== undefined) data.groupId = dto.groupId;
    }

    const updated = await this.prisma.user.update({
      where: { id },
      data,
      include: {
        school: true,
        member: { include: { associationMember: true } },
      },
    });
    const { passwordHash, ...result } = updated;
    return result;
  }

  async remove(id: string) {
    await this.findById(id);
    await this.prisma.user.delete({ where: { id } });
    return { message: 'ลบผู้ใช้สำเร็จ' };
  }
}
