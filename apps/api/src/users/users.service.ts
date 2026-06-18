import { Injectable, ConflictException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createUserDto: CreateUserDto) {
    const existing = await this.prisma.user.findUnique({
      where: { username: createUserDto.username },
    });

    if (existing) {
      throw new ConflictException('ชื่อผู้ใช้นี้ถูกใช้งานแล้ว');
    }

    const passwordHash = await bcrypt.hash(createUserDto.password, 10);

    const user = await this.prisma.user.create({
      data: {
        username: createUserDto.username,
        passwordHash,
        fullName: createUserDto.fullName,
        role: createUserDto.role,
        schoolId: createUserDto.schoolId,
        groupId: createUserDto.groupId,
        mustChangePassword: true,
      },
      include: {
        school: true,
      },
    });

    const { passwordHash: _, ...result } = user;
    return result;
  }

  async findAll(schoolId?: string) {
    const users = await this.prisma.user.findMany({
      where: schoolId ? { schoolId } : undefined,
      include: { school: true },
      orderBy: { createdAt: 'desc' },
    });

    return users.map(({ passwordHash, ...user }) => user);
  }

  async findById(id: string) {
    const user = await this.prisma.user.findUnique({
      where: { id },
      include: { school: true },
    });

    if (!user) {
      throw new NotFoundException('ไม่พบผู้ใช้');
    }

    return user;
  }

  async findByUsername(username: string) {
    return this.prisma.user.findUnique({
      where: { username },
      include: { school: true },
    });
  }

  async update(id: string, updateUserDto: UpdateUserDto) {
    const user = await this.findById(id);

    const data: any = {};
    
    if (updateUserDto.fullName !== undefined) {
      data.fullName = updateUserDto.fullName;
    }
    if (updateUserDto.role !== undefined) {
      data.role = updateUserDto.role;
    }
    if (updateUserDto.schoolId !== undefined) {
      data.schoolId = updateUserDto.schoolId;
    }
    if (updateUserDto.signature !== undefined) {
      data.signature = updateUserDto.signature;
    }

    if (updateUserDto.password) {
      data.passwordHash = await bcrypt.hash(updateUserDto.password, 10);
    }
    if (updateUserDto.groupId !== undefined) {
      data.groupId = updateUserDto.groupId;
    }
    if (updateUserDto.mustChangePassword !== undefined) {
      data.mustChangePassword = updateUserDto.mustChangePassword;
    }

    const updated = await this.prisma.user.update({
      where: { id },
      data,
      include: { school: true },
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

