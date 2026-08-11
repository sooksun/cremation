import { generateTemporaryPassword, validateStrongPassword } from './password.util';

describe('generateTemporaryPassword', () => {
  it('generates a password of the requested length', () => {
    expect(generateTemporaryPassword(16)).toHaveLength(16);
    expect(generateTemporaryPassword(8)).toHaveLength(8);
    expect(generateTemporaryPassword(32)).toHaveLength(32);
  });

  it('defaults to length 16 when no argument is given', () => {
    expect(generateTemporaryPassword()).toHaveLength(16);
  });

  it('always contains at least one upper, lower, digit, and special character', () => {
    for (let i = 0; i < 50; i++) {
      const password = generateTemporaryPassword();
      const validation = validateStrongPassword(password);
      expect(validation.valid).toBe(true);
      expect(validation.errors).toEqual([]);
    }
  });

  it('produces unique passwords across repeated calls (no collisions from weak RNG)', () => {
    const passwords = new Set<string>();
    for (let i = 0; i < 100; i++) {
      passwords.add(generateTemporaryPassword());
    }
    expect(passwords.size).toBeGreaterThanOrEqual(99);
  });
});
