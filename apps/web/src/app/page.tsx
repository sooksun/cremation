import type { Metadata } from 'next';
import LandingPage from '@/components/LandingPage';

export const metadata: Metadata = {
  title: 'หน้าหลัก | สมาคมครูอำเภอแม่ฟ้าหลวง',
  description:
    'ระบบบริหารจัดการสมาชิกสมาคมครูและงานฌาปนกิจสงเคราะห์ อำเภอแม่ฟ้าหลวง จังหวัดเชียงราย',
};

export default function Home() {
  return <LandingPage />;
}