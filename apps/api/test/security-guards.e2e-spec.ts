jest.mock('bcrypt', () => ({
  compare: jest.fn().mockResolvedValue(true),
  hash: jest.fn().mockResolvedValue('$2b$10$mockedhash'),
}));

import {
  ExecutionContext,
  INestApplication,
  UnauthorizedException,
  ValidationPipe,
} from '@nestjs/common';
import { Test } from '@nestjs/testing';
import request from 'supertest';
import { AppModule } from '../src/app.module';
import { JwtAuthGuard } from '../src/auth/guards/jwt-auth.guard';
import { PrismaService } from '../src/prisma/prisma.service';
import { Role } from '@prisma/client';

/**
 * ครอบช่องโหว่ที่หลุดมาได้เพราะเทสต์เดิมสร้าง ExecutionContext เองทั้งหมด
 * จึงไม่เคยพิสูจน์ว่า guard/interceptor ทำงานจริงในลำดับของ Nest
 */
describe('Security guards (e2e)', () => {
  let app: INestApplication;

  const VIEWER_USER = {
    id: 'viewer-id',
    username: 'viewer',
    passwordHash: '$2b$10$SECRETHASH',
    fullName: 'ผู้ดู',
    role: Role.VIEWER,
    schoolId: 'school-a',
    isActive: true,
    signature: null,
    mustChangePassword: false,
    school: null,
    member: null,
  };

  const prismaMock: any = {
    user: {
      findUnique: jest.fn().mockResolvedValue(VIEWER_USER),
      update: jest.fn().mockResolvedValue({ ...VIEWER_USER, signature: 'x' }),
    },
    auditLog: { create: jest.fn().mockResolvedValue({}) },
    $transaction: jest.fn((ops: unknown[]) => Promise.all(ops as Promise<unknown>[])),
  };

  const asRole = (role: Role, schoolId: string | null) => ({
    id: role === Role.VIEWER ? 'viewer-id' : `${role}-id`,
    username: role.toLowerCase(),
    role,
    schoolId,
  });

  beforeAll(async () => {
    process.env.JWT_SECRET = 'test-jwt-secret-at-least-32-characters-long';

    const moduleFixture = await Test.createTestingModule({ imports: [AppModule] })
      .overrideProvider(PrismaService)
      .useValue(prismaMock)
      .overrideGuard(JwtAuthGuard)
      .useValue({
        canActivate(context: ExecutionContext) {
          const req = context.switchToHttp().getRequest();
          const auth = req.headers?.authorization as string | undefined;
          if (!auth?.startsWith('Bearer ')) {
            throw new UnauthorizedException();
          }
          if (auth.includes('viewer')) req.user = asRole(Role.VIEWER, 'school-a');
          else if (auth.includes('finance-b')) req.user = asRole(Role.FINANCE, 'school-b');
          else req.user = asRole(Role.ADMIN, null);
          return true;
        },
      })
      .compile();

    app = moduleFixture.createNestApplication();
    app.setGlobalPrefix('api');
    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        transform: true,
        forbidNonWhitelisted: true,
        transformOptions: { enableImplicitConversion: true },
      }),
    );
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  beforeEach(() => {
    prismaMock.user.update.mockClear();
  });

  // VIEWER อ่านอย่างเดียวต้องถูกบังคับทั้งระบบ ไม่ใช่เฉพาะ route ที่บังเอิญมี @Roles
  it('บล็อก VIEWER ไม่ให้เขียน แม้ route จะไม่มี @Roles', async () => {
    await request(app.getHttpServer())
      .post('/api/auth/me/signature')
      .set('authorization', 'Bearer viewer-token')
      .send({ signature: 'data:image/png;base64,AAAA' })
      .expect(403);

    expect(prismaMock.user.update).not.toHaveBeenCalled();
  });

  it('ยังให้ VIEWER อ่านได้ตามปกติ', async () => {
    await request(app.getHttpServer())
      .get('/api/auth/me')
      .set('authorization', 'Bearer viewer-token')
      .expect(200);
  });

  it('ยังให้ VIEWER เขียนได้เฉพาะ route ที่ติด @AllowViewerWrite', async () => {
    const res = await request(app.getHttpServer())
      .post('/api/auth/change-password')
      .set('authorization', 'Bearer viewer-token')
      .send({ currentPassword: 'x', newPassword: 'y' });

    expect(res.status).not.toBe(403);
  });

  it('GET /users/:id ต้องไม่ส่ง passwordHash ออกไป', async () => {
    const res = await request(app.getHttpServer())
      .get('/api/users/viewer-id')
      .set('authorization', 'Bearer admin-token')
      .expect(200);

    expect(res.body).not.toHaveProperty('passwordHash');
    expect(JSON.stringify(res.body)).not.toContain('SECRETHASH');
  });

  it('PATCH /users/:id/signature ต้องผ่าน DTO validation', async () => {
    await request(app.getHttpServer())
      .patch('/api/users/viewer-id/signature')
      .set('authorization', 'Bearer admin-token')
      .send({ signature: 'totally-not-an-image' })
      .expect(400);

    expect(prismaMock.user.update).not.toHaveBeenCalled();
  });

  it('PATCH /users/:id/signature ต้องกันการแก้ข้ามโรงเรียน', async () => {
    await request(app.getHttpServer())
      .patch('/api/users/viewer-id/signature')
      .set('authorization', 'Bearer finance-b-token')
      .send({ signature: 'data:image/png;base64,AAAA' })
      .expect(403);

    expect(prismaMock.user.update).not.toHaveBeenCalled();
  });
});
