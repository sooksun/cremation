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
  ) {}

  async login(loginDto: LoginDto): Promise<{ accessToken: string; user: AuthUser }> {
    const { username, password } = loginDto;

    const user = await this.usersService.findByUsername(username);
    if (!user) {
      throw new UnauthorizedException('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง');
    }

    const isPasswordValid = await bcrypt.compare(password, user.passwordHash);
    if (!isPasswordValid) {
      throw new UnauthorizedException('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง');
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
