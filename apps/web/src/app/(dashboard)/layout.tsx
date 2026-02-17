'use client';

import { useEffect, useState } from 'react';
import { useRouter, usePathname } from 'next/navigation';
import Link from 'next/link';
import Image from 'next/image';
import { motion, AnimatePresence } from 'framer-motion';
import {
  LayoutDashboard,
  Users,
  UserCog,
  BookOpen,
  Receipt,
  Landmark,
  PiggyBank,
  BarChart3,
  Settings,
  LogOut,
  ChevronDown,
  Menu,
  X,
  Flower2,
  Building2,
  Calendar,
  Award,
} from 'lucide-react';
import { useAuthStore } from '@/store/auth';
import { api, type School } from '@/lib/api';

const menuItems = [
  {
    label: 'หน้าหลัก',
    href: '/dashboard',
    icon: LayoutDashboard,
  },
  {
    label: 'จัดการผู้ใช้',
    href: '/users',
    icon: UserCog,
    roles: ['ADMIN'],
  },
  // ─── 1. ข้อมูลหลัก ─────────────────────────────────────
  {
    label: '1. ข้อมูลหลัก',
    icon: BookOpen,
    children: [
      { label: 'โรงเรียน', href: '/schools' },
      { label: 'ประเภทสมาชิก', href: '/member-types' },
      { label: 'กลุ่ม', href: '/groups' },
      { label: 'ผังบัญชี', href: '/accounts' },
      { label: 'บัญชีธนาคาร', href: '/bank-accounts' },
    ],
  },
  // ─── 2. งานสมาคม (สมาคมผู้ประกอบวิชาชีพ) ────────────────
  {
    label: '2. งานสมาคม',
    icon: Award,
    children: [
      { label: 'สมาชิกสมาคม', href: '/association-members' },
      { label: 'ธนาคาร', href: '/bank' },
      { label: 'รายงานการเงิน', href: '/reports/finance' },
      { label: 'รายงานสมาชิก', href: '/reports' },
    ],
  },
  // ─── 3. งานฌาปนกิจ (กองทุนฌาปนกิจสงเคราะห์) ────────────
  {
    label: '3. งานฌาปนกิจ',
    icon: PiggyBank,
    children: [
      { label: 'ภาพรวมผู้บริหาร', href: '/reports/executive' },
      { label: 'สมาชิกฌาปนกิจ', href: '/members' },
      { label: 'งวดเงินสงเคราะห์', href: '/contributions/periods' },
      { label: 'ตารางการชำระ', href: '/contributions/matrix' },
      { label: 'รายการค้างชำระ', href: '/contributions/arrears' },
      { label: 'ใบเสร็จรับเงิน', href: '/receipts' },
      { label: 'ใบสำคัญจ่าย', href: '/payments' },
      { label: 'ธนาคาร', href: '/bank' },
      { label: 'แจ้งเสียชีวิต', href: '/death-claims' },
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
];

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const router = useRouter();
  const pathname = usePathname();
  const { user, logout, selectedSchoolId, setSelectedSchool, selectedYear, setSelectedYear } = useAuthStore();
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [expandedMenus, setExpandedMenus] = useState<string[]>([]);
  const [schools, setSchools] = useState<School[]>([]);

  useEffect(() => {
    if (!user) {
      router.push('/login');
    }
  }, [user, router]);

  useEffect(() => {
    const fetchSchools = async () => {
      try {
        const response = await api.get('/schools');
        setSchools(response.data);
      } catch (error) {
        console.error('Failed to fetch schools:', error);
      }
    };
    fetchSchools();
  }, []);

  // ขยายเมนูที่เกี่ยวข้องกับ pathname ปัจจุบัน
  useEffect(() => {
    const activeLabel = menuItems.find(
      (item) =>
        item.href === pathname ||
        item.children?.some((c) => 'href' in c && c.href === pathname),
    );
    if (activeLabel?.label && activeLabel.children) {
      setExpandedMenus((prev) =>
        prev.includes(activeLabel.label) ? prev : [...prev, activeLabel.label],
      );
    }
  }, [pathname]);

  const toggleMenu = (label: string) => {
    setExpandedMenus((prev) =>
      prev.includes(label) ? prev.filter((m) => m !== label) : [...prev, label],
    );
  };

  const handleLogout = () => {
    logout();
    router.push('/login');
  };

  if (!user) return null;

  const years = Array.from({ length: 5 }, (_, i) => new Date().getFullYear() - i);

  return (
    <div className="min-h-screen bg-slate-50">
      {/* Sidebar */}
      <aside
        className={`fixed inset-y-0 left-0 z-50 w-72 bg-white border-r border-slate-200 transform transition-transform duration-300 lg:translate-x-0 flex flex-col ${
          sidebarOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        {/* Logo */}
        <div className="h-16 flex-shrink-0 flex items-center gap-3 px-6 border-b border-slate-100">
          <Image
            src="/logo.png"
            alt="Logo"
            width={44}
            height={44}
            className="object-contain"
            style={{ background: 'transparent' }}
          />
          <div>
            <h1 className="font-display font-bold text-slate-900">สมาคมครู ผู้บริหาร</h1>
            <p className="text-xs text-slate-500">อ.แม่ฟ้าหลวง จ.เชียงราย</p>
          </div>
        </div>

        {/* Menu */}
        <nav className="flex-1 overflow-y-auto py-4 px-3 min-h-0 scrollbar-thin scrollbar-thumb-slate-300 scrollbar-track-slate-100">
          {menuItems.map((item) => {
            const isActive = item.href === pathname || item.children?.some((c) => c.href === pathname);
            const isExpanded = expandedMenus.includes(item.label);
            const Icon = item.icon;

            // Check role access
            if (item.roles && !item.roles.includes(user.role)) {
              return null;
            }

            if (item.children) {
              return (
                <div key={item.label} className="mb-1">
                  <button
                    onClick={() => toggleMenu(item.label)}
                    className={`w-full sidebar-link ${isActive ? 'active' : ''}`}
                  >
                    {Icon && <Icon size={20} />}
                    <span className="flex-1 text-left">{item.label}</span>
                    <ChevronDown
                      size={16}
                      className={`transition-transform ${isExpanded ? 'rotate-180' : ''}`}
                    />
                  </button>
                  <AnimatePresence>
                    {isExpanded && (
                      <motion.div
                        initial={{ height: 0, opacity: 0 }}
                        animate={{ height: 'auto', opacity: 1 }}
                        exit={{ height: 0, opacity: 0 }}
                        className="overflow-hidden"
                      >
                        <div className="ml-8 mt-1 space-y-1">
                          {item.children.map((child) => {
                            // Check role access for child items
                            if ('roles' in child && child.roles && !child.roles.includes(user.role)) {
                              return null;
                            }
                            return (
                              <Link
                                key={`${item.label}-${child.label}`}
                                href={child.href!}
                                className={`block px-4 py-2 rounded-lg text-sm transition-colors ${
                                  pathname === child.href
                                    ? 'bg-primary-50 text-primary-700 font-medium'
                                    : 'text-slate-600 hover:bg-slate-50'
                                }`}
                                onClick={() => setSidebarOpen(false)}
                              >
                                {child.label}
                              </Link>
                            );
                          })}
                        </div>
                      </motion.div>
                    )}
                  </AnimatePresence>
                </div>
              );
            }

            return (
              <Link
                key={item.href}
                href={item.href!}
                className={`sidebar-link mb-1 ${pathname === item.href ? 'active' : ''}`}
                onClick={() => setSidebarOpen(false)}
              >
                {Icon && <Icon size={20} />}
                <span>{item.label}</span>
              </Link>
            );
          })}
        </nav>

        {/* User info */}
        <div className="flex-shrink-0 p-4 border-t border-slate-100">
          <div className="flex items-center gap-3 mb-3">
            <div className="w-10 h-10 bg-primary-100 rounded-full flex items-center justify-center">
              <span className="text-primary-700 font-semibold">
                {user.fullName.charAt(0)}
              </span>
            </div>
            <div className="flex-1 min-w-0">
              <p className="font-medium text-slate-900 truncate">{user.fullName}</p>
              <p className="text-xs text-slate-500">{user.role}</p>
            </div>
          </div>
          <button
            onClick={handleLogout}
            className="btn-ghost w-full justify-start text-red-600 hover:bg-red-50 hover:text-red-700"
          >
            <LogOut size={18} />
            ออกจากระบบ
          </button>
        </div>
      </aside>

      {/* Mobile overlay */}
      {sidebarOpen && (
        <div
          className="fixed inset-0 bg-black/50 z-40 lg:hidden"
          onClick={() => setSidebarOpen(false)}
        />
      )}

      {/* Main content */}
      <div className="lg:pl-72">
        {/* Top bar */}
        <header className="sticky top-0 z-30 h-16 bg-white/80 backdrop-blur-lg border-b border-slate-200 flex items-center justify-between px-4 lg:px-6">
          <button
            onClick={() => setSidebarOpen(true)}
            className="lg:hidden p-2 rounded-lg hover:bg-slate-100"
          >
            <Menu size={24} />
          </button>

          <div className="flex items-center gap-4">
            {/* School selector */}
            <div className="flex items-center gap-2">
              <Building2 size={18} className="text-slate-400" />
              <select
                value={selectedSchoolId || ''}
                onChange={(e) => setSelectedSchool(e.target.value || null)}
                className="text-sm border-none bg-transparent focus:ring-0 text-slate-700 font-medium pr-8 cursor-pointer"
              >
                <option value="">ทุกโรงเรียน</option>
                {schools.map((school) => (
                  <option key={school.id} value={school.id}>
                    {school.name}
                  </option>
                ))}
              </select>
            </div>

            {/* Year selector */}
            <div className="flex items-center gap-2 border-l border-slate-200 pl-4">
              <Calendar size={18} className="text-slate-400" />
              <select
                value={selectedYear}
                onChange={(e) => setSelectedYear(Number(e.target.value))}
                className="text-sm border-none bg-transparent focus:ring-0 text-slate-700 font-medium pr-8 cursor-pointer"
              >
                {years.map((year) => (
                  <option key={year} value={year}>
                    ปี พ.ศ. {year + 543}
                  </option>
                ))}
              </select>
            </div>
          </div>
        </header>

        {/* Page content */}
        <main className="p-4 lg:p-6">{children}</main>
      </div>
    </div>
  );
}

