import { ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Role } from '@prisma/client';
import { ViewerReadOnlyGuard } from './viewer-readonly.guard';
import { ALLOW_VIEWER_WRITE_KEY } from '../decorators/allow-viewer-write.decorator';

describe('ViewerReadOnlyGuard', () => {
  let guard: ViewerReadOnlyGuard;
  let reflector: jest.Mocked<Pick<Reflector, 'getAllAndOverride'>>;

  const createContext = (method: string, user?: { role: Role }) => ({
    switchToHttp: () => ({
      getRequest: () => ({ method, user }),
    }),
    getHandler: () => ({}),
    getClass: () => ({}),
  });

  beforeEach(() => {
    reflector = { getAllAndOverride: jest.fn().mockReturnValue(false) };
    guard = new ViewerReadOnlyGuard(reflector as unknown as Reflector);
  });

  it('allows GET for VIEWER', () => {
    const ctx = createContext('GET', { role: Role.VIEWER });
    expect(guard.canActivate(ctx as never)).toBe(true);
  });

  it('blocks POST for VIEWER', () => {
    const ctx = createContext('POST', { role: Role.VIEWER });
    expect(() => guard.canActivate(ctx as never)).toThrow(ForbiddenException);
  });

  it('allows POST for ADMIN', () => {
    const ctx = createContext('POST', { role: Role.ADMIN });
    expect(guard.canActivate(ctx as never)).toBe(true);
  });

  it('allows POST for VIEWER when AllowViewerWrite is set', () => {
    reflector.getAllAndOverride.mockImplementation((key) =>
      key === ALLOW_VIEWER_WRITE_KEY ? true : false,
    );
    const ctx = createContext('POST', { role: Role.VIEWER });
    expect(guard.canActivate(ctx as never)).toBe(true);
  });
});