import {
  CallHandler,
  ExecutionContext,
  ForbiddenException,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Observable } from 'rxjs';
import { isViewerWriteBlocked } from '../../auth/guards/viewer-readonly.rule';

/**
 * บังคับ "VIEWER อ่านอย่างเดียว" ทั้งระบบ
 *
 * ต้องเป็น interceptor ไม่ใช่ global guard: NestJS รัน global guard ก่อน guard
 * ระดับ controller เสมอ แต่ req.user ถูกเซ็ตโดย JwtAuthGuard ซึ่งอยู่ระดับ controller
 * ตอนที่ global guard ทำงาน req.user จึงยัง undefined และการเช็คบทบาทกลายเป็น no-op
 * interceptor รันหลัง guard ครบทุกตัว จึงเห็น req.user จริง (SchoolScopeInterceptor
 * อาศัยลำดับเดียวกันนี้อยู่แล้ว)
 */
@Injectable()
export class ViewerReadOnlyInterceptor implements NestInterceptor {
  constructor(private readonly reflector: Reflector) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    if (isViewerWriteBlocked(context, this.reflector)) {
      throw new ForbiddenException('สิทธิ์ดูอย่างเดียว ไม่สามารถแก้ไขข้อมูลได้');
    }
    return next.handle();
  }
}
