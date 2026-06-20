import { randomBytes } from 'crypto';

export function generateTemporaryPassword(length = 16): string {
  return randomBytes(length).toString('base64url').slice(0, length);
}