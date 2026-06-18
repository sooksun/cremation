import { ForbiddenException, Injectable } from '@nestjs/common';
import { Role } from '@prisma/client';

export interface ScopedUser {
  id: string;
  role: Role;
  schoolId?: string | null;
  groupId?: string | null;
}

@Injectable()
export class SchoolScopeService {
  canAccessAllSchools(user: ScopedUser): boolean {
    return user.role === Role.ADMIN;
  }

  assertSchoolAccess(user: ScopedUser, schoolId: string): void {
    if (this.canAccessAllSchools(user)) {
      return;
    }
    if (!user.schoolId) {
      throw new ForbiddenException('ผู้ใช้ไม่มีสิทธิ์เข้าถึงข้อมูลโรงเรียนนี้');
    }
    if (user.schoolId !== schoolId) {
      throw new ForbiddenException('ไม่มีสิทธิ์เข้าถึงข้อมูลโรงเรียนนี้');
    }
  }

  resolveSchoolId(user: ScopedUser, requestedSchoolId?: string): string | undefined {
    if (this.canAccessAllSchools(user)) {
      return requestedSchoolId;
    }
    if (user.schoolId) {
      if (requestedSchoolId && requestedSchoolId !== user.schoolId) {
        throw new ForbiddenException('ไม่มีสิทธิ์เข้าถึงข้อมูลโรงเรียนนี้');
      }
      return user.schoolId;
    }
    return requestedSchoolId;
  }

  async assertGroupLeaderCanPay(
    user: ScopedUser,
    contribution: { schoolId: string; member: { groupId: string | null } },
  ): Promise<void> {
    if (user.role !== Role.GROUP_LEADER) {
      return;
    }
    if (!user.groupId) {
      throw new ForbiddenException('หัวหน้ากลุ่มยังไม่ได้กำหนดกลุ่มในระบบ');
    }
    this.assertSchoolAccess(user, contribution.schoolId);
    if (!contribution.member.groupId || contribution.member.groupId !== user.groupId) {
      throw new ForbiddenException('ไม่มีสิทธิ์บันทึกการชำระสำหรับสมาชิกนอกกลุ่มของคุณ');
    }
  }
}