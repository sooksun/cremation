import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Enable CORS for frontend
  // Support multiple origins via CORS_ORIGINS (comma-separated) or single FRONTEND_URL
  const corsOrigins = process.env.CORS_ORIGINS
    ? process.env.CORS_ORIGINS.split(',').map((origin) => origin.trim())
    : process.env.FRONTEND_URL
      ? [process.env.FRONTEND_URL]
      : ['http://localhost:3000'];

  app.enableCors({
    origin: (origin, callback) => {
      // Allow requests with no origin (like mobile apps or curl requests)
      if (!origin) {
        return callback(null, true);
      }

      // Check if origin is in allowed list
      if (corsOrigins.includes(origin)) {
        return callback(null, true);
      }

      // In development, allow all origins (optional - remove in production)
      if (process.env.NODE_ENV === 'development' && process.env.ALLOW_ALL_ORIGINS === 'true') {
        return callback(null, true);
      }

      // Reject origin
      callback(new Error('Not allowed by CORS'));
    },
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  });

  // Global prefix for all routes
  app.setGlobalPrefix('api');

  // Global validation pipe
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

  console.log(`🚀 API server running on http://localhost:${port}/api`);
  console.log(`📡 CORS enabled for origins: ${corsOrigins.join(', ')}`);
  if (process.env.NODE_ENV === 'development' && process.env.ALLOW_ALL_ORIGINS === 'true') {
    console.log(`⚠️  WARNING: ALLOW_ALL_ORIGINS is enabled - allowing all origins in development`);
  }
}

bootstrap();

