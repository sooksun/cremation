jest.mock('bcrypt', () => ({
  compare: jest.fn().mockResolvedValue(true),
  hash: jest.fn().mockResolvedValue('$2b$10$mockedhash'),
}));

import { ExecutionContext, INestApplication, UnauthorizedException, ValidationPipe } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import cookieParser from 'cookie-parser';
import request from 'supertest';
import { AppModule } from '../src/app.module';
import { JwtAuthGuard } from '../src/auth/guards/jwt-auth.guard';
import { PrismaService } from '../src/prisma/prisma.service';
import { Role } from '@prisma/client';

describe('Critical flow (e2e)', () => {
  let app: INestApplication;
  const prismaMock = {
    user: {
      findUnique: jest.fn(),
      findMany: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
    },
    member: {
      findMany: jest.fn(),
      findUnique: jest.fn(),
      findFirst: jest.fn(),
      count: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
    associationMember: {
      findUnique: jest.fn(),
      findFirst: jest.fn(),
      create: jest.fn(),
    },
    memberType: { findUnique: jest.fn() },
    memberContribution: {
      findUnique: jest.fn(),
      update: jest.fn(),
      findMany: jest.fn(),
    },
    contributionPeriod: {
      findUnique: jest.fn(),
      findFirst: jest.fn(),
      findMany: jest.fn(),
    },
    deathClaim: {
      findMany: jest.fn(),
      create: jest.fn(),
      findUnique: jest.fn(),
    },
    school: {
      findMany: jest.fn().mockResolvedValue([]),
      findUnique: jest.fn(),
    },
    auditLog: {
      create: jest.fn().mockResolvedValue({}),
      findMany: jest.fn().mockResolvedValue([]),
    },
    welfareSettings: {
      findFirst: jest.fn().mockResolvedValue(null),
    },
    $transaction: jest.fn((ops: unknown[]) => Promise.all(ops as Promise<unknown>[])),
  };

  beforeAll(async () => {
    process.env.JWT_SECRET = 'test-jwt-secret-at-least-32-characters-long';

    const passwordHash = '$2b$10$mockedhash';
    prismaMock.user.findUnique.mockImplementation(({ where }: { where: { username?: string; id?: string } }) => {
      if (where.username === 'admin') {
        return Promise.resolve({
          id: 'admin-id',
          username: 'admin',
          passwordHash,
          fullName: 'ผู้ดูแล',
          role: Role.ADMIN,
          schoolId: null,
          groupId: null,
          mustChangePassword: false,
          school: null,
        });
      }
      if (where.username === 'viewer') {
        return Promise.resolve({
          id: 'viewer-id',
          username: 'viewer',
          passwordHash,
          fullName: 'ผู้ดู',
          role: Role.VIEWER,
          schoolId: null,
          groupId: null,
          mustChangePassword: false,
          school: null,
        });
      }
      if (where.id === 'admin-id' || where.id === 'viewer-id') {
        return Promise.resolve({
          id: where.id,
          username: where.id === 'admin-id' ? 'admin' : 'viewer',
          passwordHash,
          fullName: where.id === 'admin-id' ? 'ผู้ดูแล' : 'ผู้ดู',
          role: where.id === 'admin-id' ? Role.ADMIN : Role.VIEWER,
          schoolId: null,
          groupId: null,
          mustChangePassword: false,
          school: null,
        });
      }
      return Promise.resolve(null);
    });

    const moduleFixture = await Test.createTestingModule({
      imports: [AppModule],
    })
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
          const role = auth.includes('viewer') ? Role.VIEWER : Role.ADMIN;
          req.user = {
            id: role === Role.VIEWER ? 'viewer-id' : 'admin-id',
            username: role === Role.VIEWER ? 'viewer' : 'admin',
            role,
            fullName: role === Role.VIEWER ? 'ผู้ดู' : 'ผู้ดูแล',
            passwordHash: 'hashed',
          };
          return true;
        },
      })
      .compile();

    app = moduleFixture.createNestApplication();
    app.use(cookieParser());
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

  const adminAuth = () => 'Bearer admin-test-token';
  const viewerAuth = () => 'Bearer viewer-test-token';

  afterAll(async () => {
    await app.close();
  });

  it('POST /api/auth/login — admin login', async () => {
    const res = await request(app.getHttpServer())
      .post('/api/auth/login')
      .send({ username: 'admin', password: 'owner123!' })
      .expect(201);

    expect(res.body.user.username).toBe('admin');
  });

  it('POST /api/auth/login — viewer login', async () => {
    const res = await request(app.getHttpServer())
      .post('/api/auth/login')
      .send({ username: 'viewer', password: 'owner123!' })
      .expect(201);

    expect(res.body.user.username).toBe('viewer');
  });

  it('GET /api/auth/me — authenticated session', async () => {
    const res = await request(app.getHttpServer())
      .get('/api/auth/me')
      .set('Authorization', adminAuth())
      .expect(200);

    expect(res.body.username).toBe('admin');
  });

  it('GET /api/members — list members after login', async () => {
    prismaMock.member.findMany.mockResolvedValue([]);
    prismaMock.member.count.mockResolvedValue(0);

    await request(app.getHttpServer())
      .get('/api/members')
      .set('Authorization', adminAuth())
      .expect(200);
  });

  it('POST /api/members — viewer cannot create member', async () => {
    await request(app.getHttpServer())
      .post('/api/members')
      .set('Authorization', viewerAuth())
      .send({ associationMemberId: 'am-1', memberNo: 'M001', joinDate: '2026-01-01' })
      .expect(403);
  });

  it('POST /api/member-applications/submit — accepts the registration page payload', async () => {
    const school = { id: 'school-1', name: 'โรงเรียนแม่ฟ้าหลวง', code: 'MFH' };
    prismaMock.school.findMany.mockResolvedValue([school]);
    prismaMock.school.findUnique.mockResolvedValue(school);
    prismaMock.memberType.findUnique.mockResolvedValue({ id: 'type-1', code: 'REG' });
    prismaMock.associationMember.findFirst.mockResolvedValue(null);
    prismaMock.associationMember.create.mockResolvedValue({ id: 'am-1', schoolId: school.id });
    prismaMock.member.findUnique.mockResolvedValue(null);
    prismaMock.member.create.mockResolvedValue({
      id: 'member-1',
      memberNo: 'M0001',
      status: 'SUSPENDED',
      membershipClass: 'ORDINARY',
      applicationDeadline: new Date('2026-07-20'),
      school: { name: school.name },
    });

    await request(app.getHttpServer())
      .post('/api/member-applications/submit')
      .send({
        type: 'ordinary',
        governmentAgency: school.name,
        memberNo: 'M0001',
        fullName: 'สมชาย ใจดี',
        beneficiaries: [
          {
            name: 'สมหญิง ใจดี',
            relationship: 'คู่สมรส',
            nationalId: '1234567890123',
            houseNo: '99/1',
            moo: '2',
            road: 'ถนนทดสอบ',
            soi: 'ซอยทดสอบ',
            subdistrict: 'แม่ฟ้าหลวง',
            district: 'แม่ฟ้าหลวง',
            province: 'เชียงราย',
            zip: '57110',
            phone: '0812345678',
            contactPerson: 'สมชาย ใจดี',
            contactPhone: '0899999999',
          },
        ],
      })
      .expect(201);
  });

  it('GET /api/death-claims/preview-calculation — benefit preview per regulation', async () => {
    prismaMock.member.count.mockResolvedValue(50);

    const res = await request(app.getHttpServer())
      .get('/api/death-claims/preview-calculation')
      .query({ claimType: 'MEMBER_DEATH' })
      .set('Authorization', adminAuth())
      .expect(200);

    expect(res.body.payingMemberCount).toBe(50);
    expect(res.body.collectionRate).toBe(100);
    expect(res.body.grossCollected).toBe(5000);
    expect(res.body.fundReserve).toBe(500);
    expect(res.body.netToPay).toBe(4500);
  });

  it('PATCH /api/contributions/:id/payment — rejects closed period', async () => {
    prismaMock.memberContribution.findUnique.mockResolvedValue({
      id: 'contrib-1',
      schoolId: 'school-1',
      period: { isClosed: true, year: 2026, month: 1 },
      member: { groupId: 'group-1' },
    });

    await request(app.getHttpServer())
      .patch('/api/contributions/contrib-1/payment')
      .set('Authorization', adminAuth())
      .send({ amount: 100, paidDate: '2026-01-15' })
      .expect(400);
  });
});
