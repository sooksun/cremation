import { getJwtExpiresIn } from './env.validation';

/**
 * ตั้งแต่ @nestjs/jwt 11 ชนิดของ expiresIn รัดเป็นรูปแบบที่ไลบรารี ms เข้าใจ
 * ค่าที่ผิดรูปจะทำให้ ms โยน error ตอนสร้าง token คือทุกคนล็อกอินไม่ได้
 * และจะรู้ตอนมีคนใช้จริงเท่านั้น จึงต้องตรวจให้ล้มตั้งแต่ตอนบูตแทน
 */
describe('getJwtExpiresIn', () => {
  const original = process.env.JWT_EXPIRES_IN;

  afterEach(() => {
    if (original === undefined) delete process.env.JWT_EXPIRES_IN;
    else process.env.JWT_EXPIRES_IN = original;
  });

  it('ไม่ตั้งค่าไว้ ใช้ค่าเริ่มต้น 7 วัน', () => {
    delete process.env.JWT_EXPIRES_IN;
    expect(getJwtExpiresIn()).toBe('7d');
  });

  it('ค่าว่างหรือเว้นวรรคล้วน ใช้ค่าเริ่มต้น', () => {
    process.env.JWT_EXPIRES_IN = '   ';
    expect(getJwtExpiresIn()).toBe('7d');
  });

  it.each([['7d'], ['12h'], ['30m'], ['45s']])('รับรูปแบบ %s', (value) => {
    process.env.JWT_EXPIRES_IN = value;
    expect(getJwtExpiresIn()).toBe(value);
  });

  it('ตัวเลขล้วนถือเป็นวินาที และคืนเป็นตัวเลข', () => {
    process.env.JWT_EXPIRES_IN = '3600';
    expect(getJwtExpiresIn()).toBe(3600);
  });

  it.each([['abc'], ['7 days'], ['7dd'], ['-1d'], ['d7']])(
    'ค่าผิดรูป %s ต้องล้มพร้อมบอกว่าผิดตรงไหน',
    (value) => {
      process.env.JWT_EXPIRES_IN = value;
      expect(() => getJwtExpiresIn()).toThrow(/JWT_EXPIRES_IN/);
    },
  );
});
