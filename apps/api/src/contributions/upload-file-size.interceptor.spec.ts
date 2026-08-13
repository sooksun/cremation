import { CallHandler, ExecutionContext, PayloadTooLargeException } from '@nestjs/common';
import { lastValueFrom, of, throwError } from 'rxjs';
import { MulterError } from 'multer';
import { UploadFileSizeInterceptor } from './upload-file-size.interceptor';

describe('UploadFileSizeInterceptor', () => {
  const interceptor = new UploadFileSizeInterceptor();
  const context = {} as ExecutionContext;

  function handlerThatThrows(error: unknown): CallHandler {
    return { handle: () => throwError(() => error) };
  }

  it('แปลง MulterError ขนาดไฟล์เกิน เป็น 413 พร้อมข้อความไทยที่บอกลิมิต 5 MB', async () => {
    const result = interceptor.intercept(
      context,
      handlerThatThrows(new MulterError('LIMIT_FILE_SIZE', 'file')),
    );

    await expect(lastValueFrom(result)).rejects.toMatchObject({
      status: 413,
      message: expect.stringContaining('5 MB'),
    });
  });

  it('แปลง PayloadTooLargeException ข้อความอังกฤษของ Nest เป็นข้อความไทย', async () => {
    const result = interceptor.intercept(
      context,
      handlerThatThrows(new PayloadTooLargeException('File too large')),
    );

    await expect(lastValueFrom(result)).rejects.toMatchObject({
      status: 413,
      message: expect.stringContaining('ไฟล์มีขนาดเกิน 5 MB'),
    });
  });

  it('ข้อผิดพลาดอื่นถูกส่งต่อตามเดิม ไม่ถูกกลบ', async () => {
    const original = new Error('อย่างอื่นพัง');

    await expect(
      lastValueFrom(interceptor.intercept(context, handlerThatThrows(original))),
    ).rejects.toBe(original);
  });

  it('คำขอที่ปกติผ่านไปได้เหมือนเดิม', async () => {
    const result = interceptor.intercept(context, { handle: () => of({ ok: true }) });

    await expect(lastValueFrom(result)).resolves.toEqual({ ok: true });
  });
});
