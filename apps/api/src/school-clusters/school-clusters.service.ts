import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateSchoolClusterDto } from './dto/create-school-cluster.dto';
import { UpdateSchoolClusterDto } from './dto/update-school-cluster.dto';

@Injectable()
export class SchoolClustersService {
  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateSchoolClusterDto) {
    const existing = await this.prisma.schoolCluster.findUnique({
      where: { code: dto.code },
    });
    if (existing) {
      throw new ConflictException('รหัสกลุ่มนี้ถูกใช้งานแล้ว');
    }

    return this.prisma.schoolCluster.create({ data: dto });
  }

  async findAll() {
    return this.prisma.schoolCluster.findMany({
      include: {
        _count: { select: { schools: true } },
        schools: {
          where: { isActive: true },
          select: {
            id: true,
            _count: { select: { associationMembers: true } },
          },
        },
      },
      orderBy: { name: 'asc' },
    }).then((clusters) =>
      clusters.map((cluster) => ({
        ...cluster,
        _count: {
          schools: cluster._count.schools,
          members: cluster.schools.reduce(
            (sum, school) => sum + school._count.associationMembers,
            0,
          ),
        },
        schools: undefined,
      })),
    );
  }

  async findHierarchy() {
    const schoolInclude = {
      where: { isActive: true },
      orderBy: { name: 'asc' as const },
      include: {
        _count: { select: { associationMembers: true } },
        associationMembers: {
          orderBy: [{ firstName: 'asc' as const }, { lastName: 'asc' as const }],
          select: {
            id: true,
            firstName: true,
            lastName: true,
            associationMemberNo: true,
            memberType: { select: { name: true } },
          },
        },
      },
    };

    const clusters = await this.prisma.schoolCluster.findMany({
      include: { schools: schoolInclude },
      orderBy: { name: 'asc' },
    });

    const unassignedSchools = await this.prisma.school.findMany({
      where: { isActive: true, clusterId: null },
      orderBy: { name: 'asc' },
      include: {
        _count: { select: { associationMembers: true } },
        associationMembers: {
          orderBy: [{ firstName: 'asc' }, { lastName: 'asc' }],
          select: {
            id: true,
            firstName: true,
            lastName: true,
            associationMemberNo: true,
            memberType: { select: { name: true } },
          },
        },
      },
    });

    return { clusters, unassignedSchools };
  }

  async findById(id: string) {
    const cluster = await this.prisma.schoolCluster.findUnique({
      where: { id },
      include: {
        schools: {
          where: { isActive: true },
          orderBy: { name: 'asc' },
        },
        _count: { select: { schools: true } },
      },
    });

    if (!cluster) {
      throw new NotFoundException('ไม่พบกลุ่ม');
    }

    return cluster;
  }

  async update(id: string, dto: UpdateSchoolClusterDto) {
    await this.findById(id);
    return this.prisma.schoolCluster.update({
      where: { id },
      data: dto,
    });
  }

  async remove(id: string) {
    const cluster = await this.findById(id);
    if (cluster.schools.length > 0) {
      throw new ConflictException('ไม่สามารถลบกลุ่มที่มีโรงเรียนสังกัดอยู่');
    }
    await this.prisma.schoolCluster.delete({ where: { id } });
    return { message: 'ลบกลุ่มสำเร็จ' };
  }
}