const path = require('path');

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  output: 'standalone',
  // pnpm monorepo: pin the tracing root to the repo root (two levels up) so
  // `.next/standalone` always nests the server entry at `apps/web/server.js`,
  // matching Dockerfile.web's CMD. Without this, Next.js auto-detects the
  // root by walking up for a lockfile, which is unreliable inside Docker's
  // partial build context (apps/api isn't copied into the web build stage).
  outputFileTracingRoot: path.join(__dirname, '../../'),
  async rewrites() {
    if (process.env.NODE_ENV === 'production') {
      return [];
    }
    return [
      {
        source: '/api/:path*',
        destination: 'http://localhost:3001/api/:path*',
      },
    ];
  },
};

module.exports = nextConfig;

