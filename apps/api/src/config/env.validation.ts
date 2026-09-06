export function validateEnv(): void {
  const secret = process.env.JWT_SECRET;
  if (!secret || secret.length < 32) {
    throw new Error(
      'JWT_SECRET must be set and at least 32 characters long. Generate with: openssl rand -base64 48',
    );
  }

  if (process.env.NODE_ENV === 'production') {
    if (process.env.ALLOW_ALL_ORIGINS === 'true') {
      throw new Error('ALLOW_ALL_ORIGINS must not be enabled in production');
    }
    const origins = process.env.CORS_ORIGINS || process.env.FRONTEND_URL;
    if (!origins) {
      throw new Error('CORS_ORIGINS or FRONTEND_URL must be set in production');
    }
  }

  const assistantEnabled = process.env.ASSISTANT_ENABLED !== '0';
  if (process.env.NODE_ENV === 'production' && assistantEnabled && !process.env.OPENROUTER_API_KEY) {
    throw new Error(
      'OPENROUTER_API_KEY must be set when ASSISTANT_ENABLED is on (set ASSISTANT_ENABLED=0 to disable the chatbot)',
    );
  }
}

export function getJwtSecret(): string {
  const secret = process.env.JWT_SECRET;
  if (!secret || secret.length < 32) {
    throw new Error('JWT_SECRET is not configured');
  }
  return secret;
}
/**
 * อายุของ JWT ในรูปแบบที่ไลบรารี ms เข้าใจ เช่น 7d, 12h, 30m หรือวินาทีเป็นตัวเลข
 *
 * ตั้งแต่ @nestjs/jwt 11 ชนิดของ expiresIn รัดเป็น template literal ของ ms
 * ถ้าส่งค่าที่ผิดรูปเข้าไป ms จะโยน error ตอนสร้าง token คือผู้ใช้ล็อกอินไม่ได้
 * ทั้งระบบ และจะรู้ตอนมีคนใช้จริงเท่านั้น จึงตรวจตั้งแต่ตอนบูตแทน
 */
export function getJwtExpiresIn(): `${number}${'s' | 'm' | 'h' | 'd'}` | number {
  const raw = process.env.JWT_EXPIRES_IN?.trim();
  if (!raw) return '7d';

  if (/^\d+$/.test(raw)) return Number(raw);

  const match = /^(\d+)(s|m|h|d)$/.exec(raw);
  if (!match) {
    throw new Error(
      `JWT_EXPIRES_IN ต้องเป็นตัวเลขวินาที หรือตัวเลขตามด้วย s/m/h/d เช่น 7d — ได้รับ "${raw}"`,
    );
  }
  return raw as `${number}${'s' | 'm' | 'h' | 'd'}`;
}
