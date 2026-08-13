import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { config as loadEnv } from 'dotenv';
import { resolve } from 'path';
import cookieParser from 'cookie-parser';
import type { NestExpressApplication } from '@nestjs/platform-express';
import helmet from 'helmet';
import { AppModule } from './app.module';
import { validateEnv } from './config/env.validation';

loadEnv({ path: resolve(process.cwd(), '../../.env') });
loadEnv({ path: resolve(process.cwd(), '.env') });

async function bootstrap() {
  validateEnv();

  const isProduction = process.env.NODE_ENV === 'production';

  const app = await NestFactory.create<NestExpressApplication>(AppModule);

  app.use(
    helmet({
      contentSecurityPolicy: isProduction
        ? {
            directives: {
              defaultSrc: ["'self'"],
              scriptSrc: ["'self'"],
              styleSrc: ["'self'", "'unsafe-inline'"],
              imgSrc: ["'self'", 'data:', 'https:'],
              connectSrc: ["'self'"],
              fontSrc: ["'self'"],
              objectSrc: ["'none'"],
              upgradeInsecureRequests: [],
            },
          }
        : false, // disable strict CSP in dev for easier debugging
      crossOriginEmbedderPolicy: false,
      crossOriginOpenerPolicy: { policy: 'same-origin' },
      crossOriginResourcePolicy: { policy: 'cross-origin' },
      hsts: isProduction
        ? {
            maxAge: 31536000, // 1 year
            includeSubDomains: true,
            preload: true,
          }
        : false,
      noSniff: true,
      frameguard: { action: 'deny' },
      xssFilter: true,
      referrerPolicy: { policy: 'no-referrer' },
    }),
  );
  // ค่าเริ่มต้นของ express คือ 100kb ซึ่งไม่พอกับบทสนทนาผู้ช่วยที่ส่งประวัติทั้งก้อนกลับมา
  // ใช้ API ของ Nest แทนการ import express ตรง ๆ เพราะ express ไม่ใช่ dependency โดยตรง
  // ของ apps/api — pnpm deploy --prod จะไม่รวมมาให้ แล้ว container จะ boot ไม่ขึ้น
  app.useBodyParser('json', { limit: '1mb' });
  app.useBodyParser('urlencoded', { limit: '1mb', extended: true });
  app.use(cookieParser());

  const corsOrigins = process.env.CORS_ORIGINS
    ? process.env.CORS_ORIGINS.split(',').map((origin) => origin.trim())
    : process.env.FRONTEND_URL
      ? [process.env.FRONTEND_URL]
      : ['http://localhost:3000'];

  app.enableCors({
    origin: (origin, callback) => {
      // Requests with no Origin header (same-origin browser fetches through a
      // reverse proxy, curl, health checks, server-to-server calls) aren't
      // meaningfully protected by a CORS check anyway — Origin is a
      // browser-enforced signal, and a non-browser client can send any value
      // (or none) regardless. Real protection here is the httpOnly/sameSite
      // strict auth cookie plus per-route guards, not this check.
      if (!origin || corsOrigins.includes(origin)) {
        return callback(null, true);
      }

      if (!isProduction && process.env.ALLOW_ALL_ORIGINS === 'true') {
        return callback(null, true);
      }

      callback(new Error('Not allowed by CORS'));
    },
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  });

  app.setGlobalPrefix('api');

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: true,
      transformOptions: {
        enableImplicitConversion: true,
      },
    }),
  );

  const port = process.env.API_PORT || 3001;
  await app.listen(port);
}

bootstrap();