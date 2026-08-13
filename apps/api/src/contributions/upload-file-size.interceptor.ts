import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
  PayloadTooLargeException,
} from '@nestjs/common';
import { Observable, catchError, throwError } from 'rxjs';

export const MAX_UPLOAD_BYTES = 5 * 1024 * 1024;

export const FILE_TOO_LARGE_MESSAGE =
  'ไฟล์มีขนาดเกิน 5 MB — กรุณาลดขนาดไฟล์ หรือแยกอัปโหลดทีละโรงเรียน';

function isFileTooLarge(error: unknown): boolean {
  if (error instanceof PayloadTooLargeException) return true;
  return (
    typeof error === 'object' &&
    error !== null &&
    (error as { code?: unknown }).code === 'LIMIT_FILE_SIZE'
  );
}

/**
 * ต้องวางไว้ "ก่อน" FileInterceptor ใน @UseInterceptors เพื่อให้ครอบข้อผิดพลาดของ multer ได้
 * ไฟล์ที่เกินลิมิตจะกลายเป็น MulterError (หรือ PayloadTooLargeException ข้อความอังกฤษจาก Nest)
 * ซึ่งหน้าเว็บอ่านแล้วไม่รู้เรื่อง จึงแปลงเป็นข้อความไทยที่ระบุลิมิตชัดเจน
 */
@Injectable()
export class UploadFileSizeInterceptor implements NestInterceptor {
  intercept(_context: ExecutionContext, next: CallHandler): Observable<unknown> {
    return next.handle().pipe(
      catchError((error: unknown) =>
        throwError(() =>
          isFileTooLarge(error) ? new PayloadTooLargeException(FILE_TOO_LARGE_MESSAGE) : error,
        ),
      ),
    );
  }
}
