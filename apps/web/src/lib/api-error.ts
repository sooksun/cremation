export function getApiErrorMessage(error: unknown, fallback = 'เกิดข้อผิดพลาด'): string {
  const err = error as {
    response?: {
      status?: number;
      data?: string | { message?: string | string[] };
    };
  };

  if (!err.response) {
    return 'ไม่สามารถเชื่อมต่อ API ได้ — กรุณาเปิดเซิร์ฟเวอร์ API (พอร์ต 3001) ด้วยคำสั่ง pnpm dev';
  }

  const { status, data } = err.response;

  if (status === 429) {
    return 'ลองเข้าสู่ระบบบ่อยเกินไป กรุณารอสักครู่แล้วลองใหม่';
  }

  if (status && status >= 500) {
    return 'เซิร์ฟเวอร์ API ไม่ทำงาน — รัน pnpm dev หรือ pnpm dev:api จากโฟลเดอร์โปรเจกต์';
  }

  if (typeof data === 'string') {
    if (data.includes('Internal Server Error')) {
      return 'เซิร์ฟเวอร์ API ไม่ทำงาน — รัน pnpm dev หรือ pnpm dev:api จากโฟลเดอร์โปรเจกต์';
    }
    return data;
  }

  if (data && typeof data === 'object' && 'message' in data) {
    const msg = data.message;
    if (Array.isArray(msg)) return msg.join(', ');
    if (typeof msg === 'string') return msg;
  }

  return fallback;
}