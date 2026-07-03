import { randomBytes } from 'crypto';

export function generateTemporaryPassword(length = 16): string {
  // Ensure it meets strong password policy: upper, lower, digit, special
  const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const lower = 'abcdefghijklmnopqrstuvwxyz';
  const digits = '0123456789';
  const special = '!@#$%^&*(),.?":{}|<>_-+=~`[]\\;\'/';
  const all = upper + lower + digits + special;

  let password = '';
  // Guarantee at least one of each
  password += upper[Math.floor(Math.random() * upper.length)];
  password += lower[Math.floor(Math.random() * lower.length)];
  password += digits[Math.floor(Math.random() * digits.length)];
  password += special[Math.floor(Math.random() * special.length)];

  const bytes = randomBytes(length - 4);
  for (let i = 0; i < bytes.length; i++) {
    password += all[bytes[i] % all.length];
  }

  // Shuffle
  return password.split('').sort(() => Math.random() - 0.5).join('').slice(0, length);
}

export interface PasswordValidationResult {
  valid: boolean;
  errors: string[];
}

/**
 * Enforce strong password policy:
 * - At least 8 characters
 * - At least 1 uppercase letter
 * - At least 1 lowercase letter
 * - At least 1 number
 * - At least 1 special character
 */
export function validateStrongPassword(password: string): PasswordValidationResult {
  const errors: string[] = [];

  if (!password || password.length < 8) {
    errors.push('รหัสผ่านต้องมีความยาวอย่างน้อย 8 ตัวอักษร');
  }
  if (!/[A-Z]/.test(password)) {
    errors.push('รหัสผ่านต้องมีตัวอักษรภาษาอังกฤษพิมพ์ใหญ่ (A-Z) อย่างน้อย 1 ตัว');
  }
  if (!/[a-z]/.test(password)) {
    errors.push('รหัสผ่านต้องมีตัวอักษรภาษาอังกฤษพิมพ์เล็ก (a-z) อย่างน้อย 1 ตัว');
  }
  if (!/[0-9]/.test(password)) {
    errors.push('รหัสผ่านต้องมีตัวเลข (0-9) อย่างน้อย 1 ตัว');
  }
  if (!/[!@#$%^&*(),.?":{}|<>_\-+=~`[\]\\;'/]/.test(password)) {
    errors.push('รหัสผ่านต้องมีอักขระพิเศษอย่างน้อย 1 ตัว (เช่น ! @ # $ % ^ & *)');
  }

  return {
    valid: errors.length === 0,
    errors,
  };
}

export function getPasswordPolicyDescription(): string {
  return 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร, มีตัวพิมพ์ใหญ่, ตัวพิมพ์เล็ก, ตัวเลข และอักขระพิเศษ';
}