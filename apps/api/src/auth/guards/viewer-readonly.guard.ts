import { CanActivate, ExecutionContext, ForbiddenException, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { isViewerWriteBlocked } from './viewer-readonly.rule';

@Injectable()
export class ViewerReadOnlyGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    if (isViewerWriteBlocked(context, this.reflector)) {
      throw new ForbiddenException('สิทธิ์ดูอย่างเดียว ไม่สามารถแก้ไขข้อมูลได้');
    }
    return true;
  }
}
