jest.mock('bcrypt', () => ({
  compare: jest.fn(),
  hash: jest.fn(),
}));

import { UnauthorizedException, BadRequestException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { AuthService } from './auth.service';
import { UsersService } from '../users/users.service';

describe('AuthService', () => {
  let service: AuthService;
  let usersService: jest.Mocked<Pick<UsersService, 'findByUsername' | 'findById' | 'update'>>;
  let jwtService: jest.Mocked<Pick<JwtService, 'sign'>>;

  const mockUser = {
    id: 'user-1',
    username: 'admin',
    passwordHash: 'hashed',
    fullName: 'ผู้ดูแลระบบ',
    role: 'ADMIN',
    schoolId: null,
    groupId: null,
    mustChangePassword: false,
    school: null,
  };

  beforeEach(() => {
    usersService = {
      findByUsername: jest.fn(),
      findById: jest.fn(),
      update: jest.fn(),
    };
    jwtService = { sign: jest.fn().mockReturnValue('jwt-token') };
    service = new AuthService(
      usersService as unknown as UsersService,
      jwtService as unknown as JwtService,
    );
  });

  describe('login', () => {
    it('returns token and user on valid credentials', async () => {
      usersService.findByUsername.mockResolvedValue(mockUser as never);
      (bcrypt.compare as jest.Mock).mockResolvedValue(true);

      const result = await service.login({ username: 'admin', password: 'secret' });

      expect(result.accessToken).toBe('jwt-token');
      expect(result.user.username).toBe('admin');
      expect(jwtService.sign).toHaveBeenCalledWith({
        sub: 'user-1',
        username: 'admin',
        role: 'ADMIN',
        schoolId: undefined,
      });
    });

    it('returns the linked member id in a MEMBER session', async () => {
      usersService.findByUsername.mockResolvedValue({
        ...mockUser,
        username: 'member001',
        role: 'MEMBER',
        memberId: 'member-1',
        schoolId: 'school-1',
      } as never);
      (bcrypt.compare as jest.Mock).mockResolvedValue(true);

      const result = await service.login({
        username: 'member001',
        password: 'secret',
      });

      expect(result.user.memberId).toBe('member-1');
      expect(jwtService.sign).toHaveBeenCalledWith(
        expect.objectContaining({ memberId: 'member-1' }),
      );
    });

    it('throws when user not found', async () => {
      usersService.findByUsername.mockResolvedValue(null);

      await expect(
        service.login({ username: 'nobody', password: 'x' }),
      ).rejects.toThrow(UnauthorizedException);
    });

    it('throws when password is invalid', async () => {
      usersService.findByUsername.mockResolvedValue(mockUser as never);
      (bcrypt.compare as jest.Mock).mockResolvedValue(false);

      await expect(
        service.login({ username: 'admin', password: 'wrong' }),
      ).rejects.toThrow(UnauthorizedException);
    });
  });

  describe('changePassword', () => {
    it('updates password when current password is correct', async () => {
      usersService.findById.mockResolvedValue(mockUser as never);
      (bcrypt.compare as jest.Mock).mockResolvedValue(true);
      usersService.update.mockResolvedValue({
        ...mockUser,
        mustChangePassword: false,
      } as never);

      const result = await service.changePassword('user-1', {
        currentPassword: 'old',
        newPassword: 'newSecure1!',
      });

      expect(usersService.update).toHaveBeenCalledWith('user-1', {
        password: 'newSecure1!',
        mustChangePassword: false,
      });
      expect(result.mustChangePassword).toBe(false);
    });

    it('throws when current password is wrong', async () => {
      usersService.findById.mockResolvedValue(mockUser as never);
      (bcrypt.compare as jest.Mock).mockResolvedValue(false);

      await expect(
        service.changePassword('user-1', {
          currentPassword: 'wrong',
          newPassword: 'newSecure1!',
        }),
      ).rejects.toThrow(BadRequestException);
    });
  });
});
