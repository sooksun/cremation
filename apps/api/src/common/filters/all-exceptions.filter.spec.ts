import { BadRequestException, HttpStatus, NotFoundException } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { AllExceptionsFilter } from './all-exceptions.filter';

function buildHost() {
  const json = jest.fn();
  const status = jest.fn(() => ({ json }));
  const host: any = {
    switchToHttp: () => ({
      getResponse: () => ({ status }),
      getRequest: () => ({ url: '/api/members', method: 'POST' }),
    }),
  };
  return { host, status, json };
}

describe('AllExceptionsFilter', () => {
  const filter = new AllExceptionsFilter();
  const logger = { error: jest.fn(), warn: jest.fn() };
  // logger เป็นฟิลด์ภายในโดยตั้งใจ (กัน Nest resolve dependency ไม่ได้ตอน boot)
  // เทสต์จึงสลับตัวจริงออกเพื่อดูว่าเขียน log ครบ
  (filter as unknown as { logger: unknown }).logger = logger;

  beforeEach(() => jest.clearAllMocks());

  it('ส่ง HttpException ต่อไปตามเดิม ไม่เปลี่ยนรูปร่าง', () => {
    const { host, status, json } = buildHost();

    filter.catch(new NotFoundException('ไม่พบสมาชิก'), host);

    expect(status).toHaveBeenCalledWith(HttpStatus.NOT_FOUND);
    expect(json).toHaveBeenCalledWith(
      expect.objectContaining({ message: 'ไม่พบสมาชิก', statusCode: 404 }),
    );
  });

  // ValidationPipe ส่ง message เป็น array — เว็บอ่าน data.message ตรง ๆ
  // ถ้า filter แปลงเป็นข้อความเดียว ข้อความบอกช่องที่กรอกผิดจะหายไปทั้งหมด
  it('คง message ที่เป็น array ของ ValidationPipe ไว้', () => {
    const { host, json } = buildHost();

    filter.catch(new BadRequestException({ statusCode: 400, message: ['ก', 'ข'], error: 'Bad Request' }), host);

    expect(json).toHaveBeenCalledWith(expect.objectContaining({ message: ['ก', 'ข'] }));
  });

  it('ข้อมูลซ้ำจาก Prisma กลายเป็น 409 พร้อมข้อความภาษาไทย', () => {
    const { host, status, json } = buildHost();
    const err = new Prisma.PrismaClientKnownRequestError('dup', {
      code: 'P2002',
      clientVersion: '5.22.0',
      meta: { target: ['memberNo'] },
    });

    filter.catch(err, host);

    expect(status).toHaveBeenCalledWith(HttpStatus.CONFLICT);
    expect(json.mock.calls[0][0].message).toContain('มีอยู่แล้ว');
    expect(json.mock.calls[0][0].message).toContain('memberNo');
  });

  it('ไม่พบแถวจาก Prisma กลายเป็น 404', () => {
    const { host, status } = buildHost();
    const err = new Prisma.PrismaClientKnownRequestError('missing', {
      code: 'P2025',
      clientVersion: '5.22.0',
    });

    filter.catch(err, host);

    expect(status).toHaveBeenCalledWith(HttpStatus.NOT_FOUND);
  });

  it('ผิดกฎ foreign key กลายเป็น 400', () => {
    const { host, status } = buildHost();
    const err = new Prisma.PrismaClientKnownRequestError('fk', {
      code: 'P2003',
      clientVersion: '5.22.0',
    });

    filter.catch(err, host);

    expect(status).toHaveBeenCalledWith(HttpStatus.BAD_REQUEST);
  });

  // ข้อความต้องเป็นภาษาไทยให้เข้าชุดกับที่เหลือของระบบ และรายละเอียดภายใน
  // ต้องอยู่ใน log ฝั่งเซิร์ฟเวอร์เท่านั้น
  it('ข้อผิดพลาดที่ไม่รู้จักตอบข้อความกลาง ๆ และบันทึกของจริงไว้ฝั่งเซิร์ฟเวอร์', () => {
    const { host, status, json } = buildHost();
    const err = new Error('Invalid `prisma.user.findMany()` invocation in /app/src/x.ts:10');

    filter.catch(err, host);

    expect(status).toHaveBeenCalledWith(HttpStatus.INTERNAL_SERVER_ERROR);
    const body = json.mock.calls[0][0];
    expect(body.message).toBe('เกิดข้อผิดพลาดภายในระบบ');
    expect(JSON.stringify(body)).not.toContain('prisma.user.findMany');
    expect(logger.error).toHaveBeenCalled();
  });

  it('ใส่เส้นทางที่ผิดพลาดไว้ในผลลัพธ์เพื่อให้ไล่ปัญหาได้', () => {
    const { host, json } = buildHost();

    filter.catch(new Error('boom'), host);

    expect(json.mock.calls[0][0].path).toBe('/api/members');
  });
});
