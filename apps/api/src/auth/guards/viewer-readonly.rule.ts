import { ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Role } from '@prisma/client';
import { ALLOW_VIEWER_WRITE_KEY } from '../decorators/allow-viewer-write.decorator';

const READ_METHODS = new Set(['GET', 'HEAD', 'OPTIONS']);

/**
 * ตรรกะเดียวที่ตัดสินว่า VIEWER เขียนคำขอนี้ได้หรือไม่ — ใช้ร่วมกันระหว่าง
 * ViewerReadOnlyGuard (สำหรับ @UseGuards ระดับ route) และ ViewerReadOnlyInterceptor
 * (ตัวที่ลงทะเบียนแบบ global) เพื่อไม่ให้ตรรกะสองชุดหลุดออกจากกัน
 */
export function isViewerWriteBlocked(context: ExecutionContext, reflector: Reflector): boolean {
  if (
    reflector.getAllAndOverride<boolean>(ALLOW_VIEWER_WRITE_KEY, [
      context.getHandler(),
      context.getClass(),
    ])
  ) {
    return false;
  }

  const request = context.switchToHttp().getRequest();
  const user = request.user as { role?: Role } | undefined;

  if (!user?.role || user.role !== Role.VIEWER) {
    return false;
  }

  return !READ_METHODS.has(request.method?.toUpperCase());
}
