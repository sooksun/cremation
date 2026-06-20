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

@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly usersService: UsersService,
  ) {}

  @Post('login')
  @Throttle({ default: { limit: 5, ttl: 60000 } })
  async login(
    @Body() loginDto: LoginDto,
    @Res({ passthrough: true }) res: Response,
  ) {
    const { accessToken, user } = await this.authService.login(loginDto);

    res.cookie(AUTH_COOKIE_NAME, accessToken, getAuthCookieOptions());

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
  @Post('change-password')
  async changePassword(
    @Request() req: { user: { id: string } },
    @Body() dto: ChangePasswordDto,
  ) {
    const user = await this.authService.changePassword(req.user.id, dto);
    return { user, message: 'เปลี่ยนรหัสผ่านสำเร็จ' };
  }

  @UseGuards(JwtAuthGuard)
  @AllowMemberAccess()
  @Post('me/signature')
  async updateMySignature(
    @Request() req: { user: { id: string } },
    @Body() updateSignatureDto: UpdateSignatureDto,
  ) {
    return await this.usersService.update(req.user.id, {
      signature: updateSignatureDto.signature,
    });
  }
}
