import {
  Award,
  BookOpen,
  Building2,
  ClipboardCheck,
  History,
  LayoutDashboard,
  PiggyBank,
  Settings,
  TrendingUp,
  UserCog,
  Users,
} from 'lucide-react';
import type { LucideIcon } from 'lucide-react';

export type MenuRole =
  | 'ADMIN'
  | 'SCHOOL_ADMIN'
  | 'FINANCE'
  | 'ACCOUNTING'
  | 'GROUP_LEADER'
  | 'VIEWER'
  | 'MEMBER';

export interface MenuLeaf {
  label: string;
  href: string;
  // เก็บเป็น string[] เพราะ layout เทียบกับ role ที่มาจาก store ซึ่งเป็น string
  // ส่วนเทสต์ใช้ MenuRole ตรวจว่าชื่อบทบาทที่เขียนไว้สะกดถูก
  roles?: string[];
}

export interface MenuItem {
  label: string;
  href?: string;
  icon?: LucideIcon;
  roles?: string[];
  children?: MenuLeaf[];
  // ป้ายตัวเลขบนเมนู เช่น จำนวนใบสมัครที่รออนุมัติ
  badge?: string;
}

/**
 * นิยามเมนูข้างของหน้าหลังบ้าน
 *
 * อยู่แยกจาก layout.tsx เพื่อให้เทสต์นำเข้าไปเทียบกับ route-access.ts ได้
 * โดยไม่ต้อง render React — เมนูกับตัวกันเส้นทางต้องบอกเรื่องเดียวกันเสมอ
 * ไม่งั้นผู้ใช้จะเห็นเมนูแล้วกดเข้าไปเจอหน้าปฏิเสธการเข้าถึง
 */
export const menuItems: MenuItem[] = [
  {
    label: 'หน้าหลัก',
    href: '/dashboard',
    icon: LayoutDashboard,
  },
  {
    label: 'ภาพรวมสมาชิก',
    href: '/dashboard/members',
    icon: Users,
  },
  {
    label: 'ภาพรวมการเงิน',
    href: '/dashboard/finance',
    icon: TrendingUp,
    roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE', 'ACCOUNTING'],
  },
  {
    label: 'ใบสมัครรออนุมัติ',
    href: '/member-applications',
    icon: ClipboardCheck,
    roles: ['ADMIN', 'SCHOOL_ADMIN'],
    badge: 'pendingApplications' as const,
  },
  {
    label: 'จัดการผู้ใช้',
    href: '/users',
    icon: UserCog,
    roles: ['ADMIN'],
  },
  {
    label: 'ผู้ดูแลโรงเรียน',
    href: '/school-admins',
    icon: Building2,
    roles: ['ADMIN'],
  },
  // ─── 1. ข้อมูลหลัก ─────────────────────────────────────
  {
    label: '1. ข้อมูลหลัก',
    icon: BookOpen,
    children: [
      { label: 'การจัดการโรงเรียน', href: '/schools', roles: ['ADMIN'] },
      { label: 'ประเภทสมาชิก', href: '/member-types', roles: ['ADMIN'] },
      { label: 'กลุ่มเก็บเงิน', href: '/groups', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE'] },
      { label: 'ผังบัญชี', href: '/accounts', roles: ['ADMIN', 'ACCOUNTING'] },
      { label: 'สินทรัพย์ถาวร', href: '/assets', roles: ['ADMIN', 'ACCOUNTING'] },
    ],
  },
  // ─── 2. งานสมาคม (สมาคมผู้ประกอบวิชาชีพ) ────────────────
  {
    label: '2. งานสมาคม',
    icon: Award,
    children: [
      { label: 'สมาชิกสมาคม', href: '/association-members', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE'] },
      { label: 'ธนาคาร', href: '/bank', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE'] },
      { label: 'รายงานการเงิน', href: '/reports/finance', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE', 'ACCOUNTING'] },
      { label: 'งบการเงิน', href: '/reports/financial-statements', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE', 'ACCOUNTING'] },
      { label: 'รายงานรายวัน', href: '/reports/daily', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE', 'ACCOUNTING'] },
      { label: 'งบทดลอง (Trial Balance)', href: '/reports/trial-balance', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE', 'ACCOUNTING'] },
      { label: 'รายงานสมาชิก', href: '/reports', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE'] },
      { label: 'รายงานการลาออก', href: '/reports/resignations', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE'] },
      { label: 'ทะเบียนสมาชิก (ตามวันที่)', href: '/reports/member-registry', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE'] },
      { label: 'รายงานรับชำระ', href: '/reports/receipts-ledger', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE', 'ACCOUNTING'] },
      { label: 'รายงานการจ่าย', href: '/reports/disbursement-ledger', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE', 'ACCOUNTING'] },
    ],
  },
  // ─── 3. งานฌาปนกิจ (กองทุนฌาปนกิจสงเคราะห์) ────────────
  {
    label: '3. งานฌาปนกิจ',
    icon: PiggyBank,
    children: [
      { label: 'ภาพรวมผู้บริหาร', href: '/reports/executive', roles: ['ADMIN'] },
      { label: 'รายงานคณะกรรมการ', href: '/reports/board-monthly', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE', 'ACCOUNTING'] },
      { label: 'สมาชิกฌาปนกิจ', href: '/members', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE'] },
      { label: 'สิ้นสุดสมาชิกภาพ', href: '/members/membership-end', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE'] },
      { label: 'งวดเงินสงเคราะห์', href: '/contributions/periods', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE', 'GROUP_LEADER'] },
      { label: 'ตารางการชำระ', href: '/contributions/matrix', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE', 'GROUP_LEADER'] },
      { label: 'รายการค้างชำระ', href: '/contributions/arrears', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE'] },
      { label: 'ใบเสร็จรับเงิน', href: '/receipts', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE'] },
      { label: 'ใบสำคัญจ่าย', href: '/payments', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE'] },
      { label: 'ธนาคาร', href: '/bank', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE'] },
      { label: 'แจ้งเสียชีวิต', href: '/death-claims', roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE'] },
    ],
  },
  {
    label: 'ตั้งค่า',
    icon: Settings,
    roles: ['ADMIN', 'FINANCE'],
    children: [
      { label: 'อัตราเงินช่วยเหลือ', href: '/settings/welfare-rate', roles: ['ADMIN'] },
      { label: 'การจัดการลายเซ็น', href: '/settings/signature' },
    ],
  },
  {
    label: 'บันทึกกิจกรรม',
    href: '/audit-logs',
    icon: History,
    roles: ['ADMIN', 'SCHOOL_ADMIN', 'FINANCE', 'ACCOUNTING'],
  },
];
