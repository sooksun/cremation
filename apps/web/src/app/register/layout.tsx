import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'สมัครสมาชิกฌาปนกิจ',
  description:
    'กรอกใบสมัครสมาชิกสามัญหรือสมทบฌาปนกิจสงเคราะห์ครูแม่ฟ้าหลวง และดาวน์โหลด PDF',
};

export default function RegisterLayout({ children }: { children: React.ReactNode }) {
  return children;
}