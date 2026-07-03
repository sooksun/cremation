import {
  Controller,
  Post,
  Body,
  Get,
  UseGuards,
  Request,
  Res,
} from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import { Response } from 'express';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';
import { ChangePasswordDto } from './dto/change-password.dto';
import { UpdateSignatureDto } from './dto/update-signature.dto';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { UsersService } from '../users/users.service';
import { AUTH_COOKIE_NAME, getAuthCookieOptions } from './constants';
import { AllowViewerWrite } from './decorators/allow-viewer-write.decorator';
import { AllowMemberAccess } from './decorators/allow-member-access.decorator';
import { SkipMustChangePassword } from './decorators/skip-must-change-password.decorator';
import { AuditLogService } from '../common/services/audit-log.service';
import { AuditAction } from '@prisma/client';

@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly usersService: UsersService,
    private readonly auditLog: AuditLogService,
  ) {}

  @Post('login')
  @Throttle({ default: { limit: 5, ttl: 60000 } })
  async login(
    @Body() loginDto: LoginDto,
    @Res({ passthrough: true }) res: Response,
    @Request() req: any,
  ) {
    const { accessToken, user } = await this.authService.login(loginDto);

    res.cookie(AUTH_COOKIE_NAME, accessToken, getAuthCookieOptions());

    // Log login activity
    await this.auditLog.log({
      userId: (user as any).id,
      action: AuditAction.USER_LOGIN,
      entityType: 'User',
      entityId: (user as any).id,
      schoolId: (user as any).schoolId,
      metadata: { username: (user as any).username },
      ipAddress: (req as any)?.ip || (req as any)?.headers?.['x-forwarded-for'] || undefined,
    });

    return { user };
  }

  @UseGuards(JwtAuthGuard)
  @SkipMustChangePassword()
  @Post('logout')
  logout(@Res({ passthrough: true }) res: Response) {
    res.clearCookie(AUTH_COOKIE_NAME, getAuthCookieOptions());
    return { message: 'ออกจากระบบสำเร็จ' };
  }

  @UseGuards(JwtAuthGuard)
  @AllowMemberAccess()
  @SkipMustChangePassword()
  @Get('me')
  async getProfile(@Request() req: { user: Record<string, unknown> }) {
    const { passwordHash, ...user } = req.user;
    return this.authService.toAuthUser(user as Parameters<AuthService['toAuthUser']>[0]);
  }

  @UseGuards(JwtAuthGuard)
  @AllowMemberAccess()
  @AllowViewerWrite()
  @SkipMustChangePassword()
  @Throttle({ default: { limit: 3, ttl: 60000 } }) // Limit password changes to 3 per minute
  @Post('change-password')
  async changePassword(
    @Request() req: { user: { id: string; schoolId?: string } },
    @Body() dto: ChangePasswordDto,
  ) {
    const user = await this.authService.changePassword(req.user.id, dto);

    await this.auditLog.log({
      userId: req.user.id,
      action: AuditAction.PASSWORD_CHANGE,
      entityType: 'User',
      entityId: req.user.id,
      schoolId: req.user.schoolId,
      metadata: { action: 'change_password' },
      ipAddress: (req as any)?.ip || (req as any)?.headers?.['x-forwarded-for'] || undefined,
    });

    return { user, message: 'เปลี่ยนรหัสผ่านสำเร็จ' };
  }

  @UseGuards(JwtAuthGuard)
  @AllowMemberAccess()
  @Post('me/signature')
  async updateMySignature(
    @Request() req: { user: { id: string; schoolId?: string } },
    @Body() updateSignatureDto: UpdateSignatureDto,
  ) {
    const result = await this.usersService.update(req.user.id, {
      signature: updateSignatureDto.signature,
    });

    await this.auditLog.log({
      userId: req.user.id,
      action: AuditAction.USER_UPDATE,
      entityType: 'User',
      entityId: req.user.id,
      schoolId: req.user.schoolId,
      metadata: { changedSignature: true },
    });

    return result;
  }
}
