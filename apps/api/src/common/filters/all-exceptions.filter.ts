import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Prisma } from '@prisma/client';

/**
 * ตัวจับข้อผิดพลาดตัวสุดท้ายของทั้ง API
 *
 * เดิมไม่มี filter เลย ข้อผิดพลาดของ Prisma ที่ service ไม่ได้ดักไว้จึงกลายเป็น
 * 500 "Internal server error" ทั้งหมด ผู้ใช้ที่กรอกเลขสมาชิกซ้ำหรืออ้างถึงแถวที่
 * ถูกลบไปแล้วเห็นแค่ "ระบบผิดพลาด" ทั้งที่เป็นความผิดของข้อมูลที่กรอก ไม่ใช่ของระบบ
 * (ตัวจัดการมาตรฐานของ Nest ไม่ได้รั่วข้อความดิบออกมาอยู่แล้ว — ตรวจแล้ว)
 *
 * หน้าที่ของ filter นี้มีสามอย่าง
 * 1. ปล่อย HttpException ผ่านไปเหมือนเดิมทุกประการ ข้อความที่ service ตั้งใจสื่อสาร
 *    กับผู้ใช้ (รวมถึง array ของ ValidationPipe) ต้องไม่ถูกแตะ
 * 2. แปลงข้อผิดพลาดที่รู้จักของ Prisma เป็นสถานะและข้อความภาษาไทยที่ผู้ใช้เข้าใจ
 * 3. ที่เหลือตอบ 500 ด้วยข้อความภาษาไทยกลาง ๆ และบันทึกของจริงไว้ฝั่งเซิร์ฟเวอร์
 */
@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  // ตั้งเป็นฟิลด์ ไม่รับผ่าน constructor — Nest จะพยายาม resolve พารามิเตอร์ของ
  // provider ที่ลงทะเบียนด้วย useClass เสมอ และ Logger ไม่ได้อยู่ใน providers
  // จะทำให้แอปพังตั้งแต่ boot ซึ่ง unit test จับไม่ได้
  private readonly logger = new Logger(AllExceptionsFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();
    const request = ctx.getRequest();
    const path = request?.url;

    if (exception instanceof HttpException) {
      const status = exception.getStatus();
      const body = exception.getResponse();

      // getResponse() คืน string เมื่อสร้างด้วยข้อความล้วน และคืน object เมื่อมาจาก
      // ValidationPipe หรือถูกสร้างด้วย object เอง — ต้องคง message เดิมไว้ทั้งสองแบบ
      // เพราะหน้าเว็บอ่าน data.message ตรง ๆ ทุกที่
      const payload =
        typeof body === 'string'
          ? { statusCode: status, message: body }
          : { statusCode: status, ...(body as Record<string, unknown>) };

      return response.status(status).json({ ...payload, path });
    }

    const mapped = this.mapPrismaError(exception);
    if (mapped) {
      this.logger.warn(`${mapped.code} ที่ ${path}: ${mapped.message}`);
      return response.status(mapped.status).json({
        statusCode: mapped.status,
        message: mapped.message,
        path,
      });
    }

    // บันทึกของจริงไว้ฝั่งเซิร์ฟเวอร์เท่านั้น ไม่ส่งออกไปกับ response
    this.logger.error(
      `ข้อผิดพลาดที่ไม่ได้จัดการที่ ${request?.method ?? '?'} ${path}`,
      exception instanceof Error ? exception.stack : String(exception),
    );

    return response.status(HttpStatus.INTERNAL_SERVER_ERROR).json({
      statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
      message: 'เกิดข้อผิดพลาดภายในระบบ',
      path,
    });
  }

  private mapPrismaError(
    exception: unknown,
  ): { status: number; message: string; code: string } | null {
    if (!(exception instanceof Prisma.PrismaClientKnownRequestError)) {
      return null;
    }

    const fields = Array.isArray(exception.meta?.target)
      ? (exception.meta?.target as string[]).join(', ')
      : undefined;

    switch (exception.code) {
      case 'P2002':
        return {
          status: HttpStatus.CONFLICT,
          code: exception.code,
          message: fields
            ? `ข้อมูล ${fields} นี้มีอยู่แล้วในระบบ`
            : 'ข้อมูลนี้มีอยู่แล้วในระบบ',
        };
      case 'P2025':
        return {
          status: HttpStatus.NOT_FOUND,
          code: exception.code,
          message: 'ไม่พบข้อมูลที่ต้องการ',
        };
      case 'P2003':
        return {
          status: HttpStatus.BAD_REQUEST,
          code: exception.code,
          message: 'ข้อมูลอ้างอิงไม่ถูกต้อง หรือถูกใช้งานอยู่จึงลบไม่ได้',
        };
      case 'P2000':
        return {
          status: HttpStatus.BAD_REQUEST,
          code: exception.code,
          message: 'ข้อมูลที่กรอกยาวเกินกว่าที่ระบบรองรับ',
        };
      default:
        return null;
    }
  }
}
