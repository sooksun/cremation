import {
  BadRequestException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { UsersService } from '../users/users.service';
import { LoginDto } from './dto/login.dto';
import { ChangePasswordDto } from './dto/change-password.dto';
import { validateStrongPassword } from '../common/utils/password.util';
import { PrismaService } from '../prisma/prisma.service';

export interface JwtPayload {
  sub: string;
  username: string;
  role: string;
  schoolId?: string;
  memberId?: string;
}

export interface AuthUser {
  id: string;
  username: string;
  fullName: string;
  role: string;
  schoolId?: string;
  schoolName?: string;
  groupId?: string;
  memberId?: string;
  mustChangePassword: boolean;
}

export interface AuthResponse {
  user: AuthUser;
}

@Injectable()
export class AuthService {
  constructor(
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
    private readonly prisma: PrismaService,
  ) {}

  async login(loginDto: LoginDto): Promise<{ accessToken: string; user: AuthUser }> {
    const { username, password } = loginDto;

    const user = await this.usersService.findByUsername(username);
    if (!user) {
      throw new UnauthorizedException('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง');
    }

    // Check account lock
    const lockedUntil = (user as any).lockedUntil;
    if (lockedUntil && new Date(lockedUntil) > new Date()) {
      const minutesLeft = Math.ceil((new Date(lockedUntil).getTime() - Date.now()) / 60000);
      throw new UnauthorizedException(`บัญชีถูกระงับชั่วคราว โปรดลองใหม่อีก ${minutesLeft} นาที`);
    }

    const isPasswordValid = await bcrypt.compare(password, user.passwordHash);

    if (!isPasswordValid) {
      // Increment failed attempts
      const currentAttempts = (user as any).failedLoginAttempts || 0;
      const newAttempts = currentAttempts + 1;
      const updateData: any = { failedLoginAttempts: newAttempts };

      if (newAttempts >= 5) {
        // Lock for 15 minutes
        updateData.lockedUntil = new Date(Date.now() + 15 * 60 * 1000);
        updateData.failedLoginAttempts = 0; // reset after lock
      }

      await this.prisma.user.update({
        where: { id: user.id },
        data: updateData,
      });

      throw new UnauthorizedException('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง');
    }

    // Success: reset counters
    if ((user as any).failedLoginAttempts > 0 || lockedUntil) {
      await this.prisma.user.update({
        where: { id: user.id },
        data: { failedLoginAttempts: 0, lockedUntil: null },
      });
    }

    const payload: JwtPayload = {
      sub: user.id,
      username: user.username,
      role: user.role,
      schoolId: user.schoolId || undefined,
      ...(user.memberId ? { memberId: user.memberId } : {}),
    };

    const accessToken = this.jwtService.sign(payload);

    return {
      accessToken,
      user: this.toAuthUser(user),
    };
  }

  async changePassword(userId: string, dto: ChangePasswordDto): Promise<AuthUser> {
    const user = await this.usersService.findById(userId);

    const isCurrentValid = await bcrypt.compare(dto.currentPassword, user.passwordHash);
    if (!isCurrentValid) {
      throw new BadRequestException('รหัสผ่านปัจจุบันไม่ถูกต้อง');
    }

    const validation = validateStrongPassword(dto.newPassword);
    if (!validation.valid) {
      throw new BadRequestException(validation.errors.join(', '));
    }

    if (dto.newPassword === dto.currentPassword) {
      throw new BadRequestException('รหัสผ่านใหม่ต้องแตกต่างจากรหัสผ่านปัจจุบัน');
    }

    const updated = await this.usersService.update(userId, {
      password: dto.newPassword,
      mustChangePassword: false,
    });

    return this.toAuthUser(updated);
  }

  async validateUser(payload: JwtPayload) {
    const user = await this.usersService.findById(payload.sub);
    if (!user) {
      throw new UnauthorizedException('ผู้ใช้ไม่พบในระบบ');
    }
    return user;
  }

  toAuthUser(user: {
    id: string;
    username: string;
    fullName: string;
    role: string;
    schoolId?: string | null;
    groupId?: string | null;
    memberId?: string | null;
    mustChangePassword?: boolean;
    school?: { name: string } | null;
  }): AuthUser {
    return {
      id: user.id,
      username: user.username,
      fullName: user.fullName,
      role: user.role,
      schoolId: user.schoolId || undefined,
      schoolName: user.school?.name,
      groupId: user.groupId || undefined,
      memberId: user.memberId || undefined,
      mustChangePassword: user.mustChangePassword ?? false,
    };
  }
}
