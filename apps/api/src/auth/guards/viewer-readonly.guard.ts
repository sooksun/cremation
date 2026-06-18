import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Role } from '@prisma/client';
import { ALLOW_VIEWER_WRITE_KEY } from '../decorators/allow-viewer-write.decorator';

const READ_METHODS = new Set(['GET', 'HEAD', 'OPTIONS']);

@Injectable()
export class ViewerReadOnlyGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    if (this.reflector.getAllAndOverride<boolean>(ALLOW_VIEWER_WRITE_KEY, [
      context.getHandler(),
      context.getClass(),
    ])) {
      return true;
    }

    const request = context.switchToHttp().getRequest();
    const user = request.user as { role?: Role } | undefined;

    if (!user?.role || user.role !== Role.VIEWER) {
      return true;
    }

    if (READ_METHODS.has(request.method?.toUpperCase())) {
      return true;
    }

    throw new ForbiddenException('สิทธิ์ดูอย่างเดียว ไม่สามารถแก้ไขข้อมูลได้');
  }
}