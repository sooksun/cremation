export function validateEnv(): void {
  const secret = process.env.JWT_SECRET;
  if (!secret || secret.length < 32) {
    throw new Error(
      'JWT_SECRET must be set and at least 32 characters long. Generate with: openssl rand -base64 48',
    );
  }

  if (process.env.NODE_ENV === 'production') {
    if (process.env.ALLOW_ALL_ORIGINS === 'true') {
      throw new Error('ALLOW_ALL_ORIGINS must not be enabled in production');
    }
    const origins = process.env.CORS_ORIGINS || process.env.FRONTEND_URL;
    if (!origins) {
      throw new Error('CORS_ORIGINS or FRONTEND_URL must be set in production');
    }
  }

  const assistantEnabled = process.env.ASSISTANT_ENABLED !== '0';
  if (process.env.NODE_ENV === 'production' && assistantEnabled && !process.env.OPENROUTER_API_KEY) {
    throw new Error(
      'OPENROUTER_API_KEY must be set when ASSISTANT_ENABLED is on (set ASSISTANT_ENABLED=0 to disable the chatbot)',
    );
  }
}

export function getJwtSecret(): string {
  const secret = process.env.JWT_SECRET;
  if (!secret || secret.length < 32) {
    throw new Error('JWT_SECRET is not configured');
  }
  return secret;
}