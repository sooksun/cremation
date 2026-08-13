'use client';

/**
 * Placeholder ระหว่างรอ chunk ของ recharts โหลด (โหลดแบบ dynamic เพื่อไม่ให้ติดไปกับ bundle แรก)
 */
export default function ChartSkeleton({ className = 'h-full' }: { className?: string }) {
  return (
    <div
      role="status"
      aria-label="กำลังโหลดกราฟ"
      className={`w-full ${className} rounded-lg bg-slate-100 animate-pulse`}
    />
  );
}
