'use client';

import { useEffect } from 'react';

/**
 * error boundary ของเส้นทางนอกกลุ่ม (dashboard) — เช่น /register, /login, /change-password
 * ทำให้หน้าเหล่านี้แสดงข้อความที่อ่านรู้เรื่องแทนจอขาว เมื่อ query ล้มเหลว
 */
export default function RootError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error('route error:', error);
  }, [error]);

  return (
    <div className="min-h-screen flex items-center justify-center p-6 bg-slate-50">
      <div className="bg-white rounded-xl shadow p-8 max-w-md w-full text-center">
        <h2 className="text-xl font-semibold text-slate-900 mb-2">โหลดหน้านี้ไม่สำเร็จ</h2>
        <p className="text-slate-500 mb-1">ระบบติดต่อเซิร์ฟเวอร์ไม่ได้ กรุณาลองใหม่อีกครั้ง</p>
        <p className="text-xs text-slate-400 mb-6 break-words">{error.message}</p>
        <button
          type="button"
          onClick={reset}
          className="px-5 py-2 rounded-lg bg-slate-900 text-white hover:bg-slate-800"
        >
          ลองใหม่
        </button>
      </div>
    </div>
  );
}
