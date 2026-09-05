'use client';

/**
 * ตัวรับข้อผิดพลาดชั้นนอกสุด — ทำงานเมื่อ layout ราก หรือ error.tsx เองพัง
 * ต้องมี html/body ของตัวเองตามข้อกำหนดของ Next.js App Router
 */
export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <html lang="th">
      <body style={{ fontFamily: 'system-ui, sans-serif', padding: '3rem', textAlign: 'center' }}>
        <h2 style={{ fontSize: '1.25rem', marginBottom: '0.5rem' }}>ระบบขัดข้อง</h2>
        <p style={{ color: '#64748b', marginBottom: '1.5rem' }}>{error.message}</p>
        <button
          type="button"
          onClick={reset}
          style={{
            padding: '0.5rem 1.25rem',
            borderRadius: '0.5rem',
            border: 0,
            background: '#0f172a',
            color: '#fff',
            cursor: 'pointer',
          }}
        >
          ลองใหม่
        </button>
      </body>
    </html>
  );
}
