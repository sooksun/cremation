import { randomInt } from 'crypto';

export function generateTemporaryPassword(length = 16): string {
  // Ensure it meets strong password policy: upper, lower, digit, special
  const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const lower = 'abcdefghijklmnopqrstuvwxyz';
  const digits = '0123456789';
  const special = '!@#$%^&*(),.?":{}|<>_-+=~`[]\\;\'/';
  const all = upper + lower + digits + special;

  const chars: string[] = [];
  // Guarantee at least one of each
  chars.push(upper[randomInt(upper.length)]);
  chars.push(lower[randomInt(lower.length)]);
  chars.push(digits[randomInt(digits.length)]);
  chars.push(special[randomInt(special.length)]);

  for (let i = chars.length; i < length; i++) {
    chars.push(all[randomInt(all.length)]);
  }

  // Fisher-Yates shuffle using a CSPRNG
  for (let i = chars.length - 1; i > 0; i--) {
    const j = randomInt(i + 1);
    [chars[i], chars[j]] = [chars[j], chars[i]];
  }

  return chars.slice(0, length).join('');
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