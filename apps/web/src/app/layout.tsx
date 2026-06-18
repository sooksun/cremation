import type { Metadata } from 'next';
import { Noto_Sans_Thai, Prompt } from 'next/font/google';
import './globals.css';
import { Providers } from './providers';
import { ToastContainer } from 'react-toastify';

const notoSansThai = Noto_Sans_Thai({
  subsets: ['thai', 'latin'],
  weight: ['300', '400', '500', '600', '700'],
  variable: '--font-noto-sans-thai',
  display: 'swap',
});

const prompt = Prompt({
  subsets: ['thai', 'latin'],
  weight: ['400', '500', '600', '700'],
  variable: '--font-prompt',
  display: 'swap',
});

export const metadata: Metadata = {
  title: {
    default: 'สมาคมครูอำเภอแม่ฟ้าหลวง | ระบบสมาชิกสมาคมและฌาปนกิจสงเคราะห์',
    template: '%s | สมาคมครูอำเภอแม่ฟ้าหลวง',
  },
  description:
    'ระบบบริหารจัดการสมาชิกสมาคมครูและงานฌาปนกิจสงเคราะห์ อำเภอแม่ฟ้าหลวง จังหวัดเชียงราย',
  icons: {
    icon: '/icon.png',
    apple: '/apple-icon.png',
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="th" className={`${notoSansThai.variable} ${prompt.variable}`}>
      <body className="font-sans">
        <Providers>
          {children}
          <ToastContainer
            position="top-right"
            autoClose={4000}
            hideProgressBar={false}
            newestOnTop={false}
            closeOnClick
            rtl={false}
            pauseOnFocusLoss
            draggable
            pauseOnHover
            theme="dark"
            style={{
              fontSize: '14px',
            }}
          />
        </Providers>
      </body>
    </html>
  );
}

