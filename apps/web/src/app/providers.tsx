'use client';

import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useState, type ReactNode } from 'react';
import ErrorBoundary from '@/components/ErrorBoundary';

export function Providers({ children }: { children: ReactNode }) {
  const [queryClient] = useState(
    () =>
      new QueryClient({
        defaultOptions: {
          queries: {
            staleTime: 60 * 1000,
            refetchOnWindowFocus: false,
            /**
             * ให้ query ที่ล้มเหลวโยนขึ้น error boundary แทนที่จะคืน data = undefined เงียบ ๆ
             *
             * เดิมมีเพียง 1 ใน 52 หน้าที่เช็ค isError ที่เหลือจึงเรนเดอร์ตารางว่าง ยอด 0
             * หรือข้อความ "ไม่พบข้อมูล" ทั้งที่ API ล่ม — หน้างบทดลองถึงขั้นแสดง
             * "⚠ ไม่สมดุล ต่างกัน 0.00" ให้เจ้าหน้าที่บัญชีเห็นเมื่อเรียก API ไม่สำเร็จ
             *
             * ยกเว้น 401/403: axios interceptor พาไป /login หรือ /change-password อยู่แล้ว
             * ถ้าโยนซ้ำผู้ใช้จะเห็นหน้า error แวบหนึ่งก่อนถูก redirect
             * หน้าที่จัดการ error เองอยู่แล้วให้ตั้ง throwOnError: false ที่ตัว query
             */
            throwOnError: (error: unknown) => {
              const status = (error as { response?: { status?: number } })?.response?.status;
              return status !== 401 && status !== 403;
            },
          },
        },
      }),
  );

  return (
    <QueryClientProvider client={queryClient}>
      <ErrorBoundary>{children}</ErrorBoundary>
    </QueryClientProvider>
  );
}

