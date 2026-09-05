'use client';

import { useEffect } from 'react';
import { AlertTriangle, RefreshCw } from 'lucide-react';

/**
 * error boundary ระดับเส้นทางของทุกหน้าในกลุ่ม (dashboard)
 *
 * ต่างจาก ErrorBoundary ตัวเดียวที่ครอบทั้งแอปใน providers.tsx ตรงที่ตัวนี้ถูก reset ได้
 * โดยไม่ต้องรีโหลดทั้งหน้า และไม่กลืนแถบเมนู/หัวจอไปด้วย ผู้ใช้จึงยังเปลี่ยนไปหน้าอื่นได้
 */
export default function DashboardError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error('dashboard route error:', error);
  }, [error]);

  const status = (error as unknown as { response?: { status?: number } })?.response?.status;

  return (
    <div className="min-h-[50vh] flex items-center justify-center p-6">
      <div className="card p-8 max-w-md w-full text-center">
        <div className="w-14 h-14 bg-red-50 rounded-full flex items-center justify-center mx-auto mb-4">
          <AlertTriangle className="text-red-600" size={28} />
        </div>
        <h2 className="text-xl font-semibold text-slate-900 mb-2">โหลดข้อมูลไม่สำเร็จ</h2>
        <p className="text-slate-500 mb-2">
          {status === 404
            ? 'ไม่พบข้อมูลที่ต้องการ'
            : 'ระบบติดต่อเซิร์ฟเวอร์ไม่ได้ ตัวเลขที่เห็นอาจไม่ครบ จึงยังไม่แสดงผล'}
        </p>
        <p className="text-xs text-slate-400 mb-6 break-words">{error.message}</p>
        <button type="button" onClick={reset} className="btn-primary inline-flex items-center gap-2">
          <RefreshCw size={18} />
          ลองใหม่
        </button>
      </div>
    </div>
  );
}
