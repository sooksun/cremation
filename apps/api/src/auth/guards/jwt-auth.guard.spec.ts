import { ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Role } from '@prisma/client';
import { JwtAuthGuard } from './jwt-auth.guard';

describe('JwtAuthGuard member access policy', () => {
  const context = {
    getHandler: () => () => undefined,
    getClass: () => class TestController {},
  } as unknown as ExecutionContext;

  it('denies MEMBER access unless the endpoint opts in', () => {
    const reflector = {
      getAllAndOverride: jest.fn().mockReturnValue(false),
    } as unknown as Reflector;
    const guard = new JwtAuthGuard(reflector);

    expect(() =>
      guard.handleRequest(null, { role: Role.MEMBER }, null, context),
    ).toThrow(ForbiddenException);
  });

  it('allows MEMBER access on an opted-in endpoint', () => {
    const reflector = {
      getAllAndOverride: jest.fn().mockReturnValue(true),
    } as unknown as Reflector;
    const guard = new JwtAuthGuard(reflector);
    const user = { role: Role.MEMBER, memberId: 'member-1' };

    expect(guard.handleRequest(null, user, null, context)).toBe(user);
  });

  it('does not restrict staff roles', () => {
    const reflector = {
      getAllAndOverride: jest.fn().mockReturnValue(false),
    } as unknown as Reflector;
    const guard = new JwtAuthGuard(reflector);
    const user = { role: Role.ADMIN };

    expect(guard.handleRequest(null, user, null, context)).toBe(user);
  });

  it('blocks users who must change password unless endpoint opts out', () => {
    const reflector = {
      getAllAndOverride: jest
        .fn()
        .mockImplementation((key: string) => key === 'skipMustChangePassword'),
    } as unknown as Reflector;
    const guard = new JwtAuthGuard(reflector);
    const user = { role: Role.SCHOOL_ADMIN, mustChangePassword: true };

    expect(guard.handleRequest(null, user, null, context)).toBe(user);
  });

  it('rejects users who must change password on protected endpoints', () => {
    const reflector = {
      getAllAndOverride: jest.fn().mockReturnValue(false),
    } as unknown as Reflector;
    const guard = new JwtAuthGuard(reflector);

    expect(() =>
      guard.handleRequest(null, { role: Role.FINANCE, mustChangePassword: true }, null, context),
    ).toThrow(ForbiddenException);
  });
});
