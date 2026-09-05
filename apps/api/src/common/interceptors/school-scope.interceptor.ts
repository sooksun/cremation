import {
  CallHandler,
  ExecutionContext,
  ForbiddenException,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { SchoolScopeService } from '../security/school-scope.service';

@Injectable()
export class SchoolScopeInterceptor implements NestInterceptor {
  constructor(private readonly schoolScope: SchoolScopeService) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const req = context.switchToHttp().getRequest();
    const user = req.user;

    if (!user) {
      return next.handle();
    }

    // เรียก resolveSchoolId ทุกกรณีของบทบาทที่ผูกโรงเรียน ไม่ใช่เฉพาะตอน user.schoolId มีค่า
    // เดิมถ้าบัญชีไม่มี schoolId จะไม่เข้าเงื่อนไขไหนเลย แล้ว query หลุดออกไปแบบไม่มีตัวกรอง
    if (req.query?.schoolId) {
      req.query.schoolId = this.schoolScope.resolveSchoolId(user, req.query.schoolId);
    } else if (!this.schoolScope.canAccessAllSchools(user)) {
      req.query.schoolId = this.schoolScope.resolveSchoolId(user, undefined);
    }

    if (req.body && typeof req.body === 'object' && 'schoolId' in req.body && req.body.schoolId) {
      const resolved = this.schoolScope.resolveSchoolId(user, req.body.schoolId);
      if (resolved !== req.body.schoolId && !this.schoolScope.canAccessAllSchools(user)) {
        throw new ForbiddenException('ไม่มีสิทธิ์ระบุโรงเรียนนี้');
      }
      req.body.schoolId = resolved ?? req.body.schoolId;
    }

    return next.handle();
  }
}