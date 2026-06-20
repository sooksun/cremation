import {
  ExecutionContext,
  ForbiddenException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { AuthGuard } from '@nestjs/passport';
import { Role } from '@prisma/client';
import { ALLOW_MEMBER_ACCESS_KEY } from '../decorators/allow-member-access.decorator';
import { SKIP_MUST_CHANGE_PASSWORD_KEY } from '../decorators/skip-must-change-password.decorator';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  constructor(private readonly reflector: Reflector) {
    super();
  }

  canActivate(context: ExecutionContext) {
    return super.canActivate(context);
  }

  handleRequest(err: any, user: any, info: any, context: ExecutionContext) {
    if (err || !user) {
      throw err || new UnauthorizedException('กรุณาเข้าสู่ระบบก่อน');
    }

    const memberAccessAllowed = this.reflector.getAllAndOverride<boolean>(
      ALLOW_MEMBER_ACCESS_KEY,
      [context.getHandler(), context.getClass()],
    );
    if (user.role === Role.MEMBER && !memberAccessAllowed) {
      throw new ForbiddenException('บัญชีสมาชิกเข้าถึงได้เฉพาะข้อมูลของตนเอง');
    }

    const skipMustChangePassword = this.reflector.getAllAndOverride<boolean>(
      SKIP_MUST_CHANGE_PASSWORD_KEY,
      [context.getHandler(), context.getClass()],
    );
    if (user.mustChangePassword && !skipMustChangePassword) {
      throw new ForbiddenException('กรุณาเปลี่ยนรหัสผ่านก่อนใช้งานระบบ');
    }

    return user;
  }
}
