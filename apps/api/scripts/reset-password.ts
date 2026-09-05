/**
 * ตั้งรหัสผ่านใหม่ให้ผู้ใช้หนึ่งบัญชี
 *
 * มีไว้สำหรับกรณีที่เข้าระบบไม่ได้แล้ว (ลืมรหัส หรือรหัสถูกเขียนทับ) แทนการรัน
 * `prisma db seed` ซึ่งเคยถูกใช้ผิดวัตถุประสงค์จนรีเซ็ตรหัสผ่านของทุกบัญชีพร้อมกัน
 *
 * ใช้:
 *   RESET_USERNAME=admin RESET_PASSWORD='รหัสใหม่' npx ts-node scripts/reset-password.ts
 *
 * รหัสผ่านรับผ่าน environment variable ไม่ใช่ argument เพื่อไม่ให้ติดอยู่ใน
 * shell history หรือ process list ของเครื่อง
 */
import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';
import { validateStrongPassword } from '../src/common/utils/password.util';

const prisma = new PrismaClient();

async function main() {
  const username = process.env.RESET_USERNAME;
  const password = process.env.RESET_PASSWORD;

  if (!username || !password) {
    throw new Error('ต้องระบุทั้ง RESET_USERNAME และ RESET_PASSWORD');
  }

  const check = validateStrongPassword(password);
  if (!check.valid) {
    throw new Error(`รหัสผ่านไม่ผ่านเกณฑ์: ${check.errors.join(', ')}`);
  }

  const user = await prisma.user.findUnique({ where: { username } });
  if (!user) {
    throw new Error(`ไม่พบผู้ใช้ '${username}'`);
  }

  await prisma.user.update({
    where: { username },
    data: {
      passwordHash: await bcrypt.hash(password, 10),
      // ปลดล็อกบัญชีที่ถูกล็อกจากการกรอกรหัสผิดหลายครั้งไปด้วย
      failedLoginAttempts: 0,
      lockedUntil: null,
    },
  });

  console.log(`ตั้งรหัสผ่านใหม่ให้ '${username}' (${user.role}) เรียบร้อย`);
}

main()
  .catch((err) => {
    console.error('ล้มเหลว:', err instanceof Error ? err.message : err);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
