'use client';

import { useQuery } from '@tanstack/react-query';
import { useRef } from 'react';
import { motion } from 'framer-motion';
import {
  Users,
  Flower2,
  TrendingUp,
  TrendingDown,
  AlertTriangle,
  Building2,
  DollarSign,
  Clock,
  BarChart3,
  PieChart,
  Download,
} from 'lucide-react';
import { exportElementToPdf } from '@/lib/export-pdf';
import dynamic from 'next/dynamic';
import ChartSkeleton from '@/components/ChartSkeleton';
import { api } from '@/lib/api';

// recharts หนักราว 99 kB (gzip) และใช้เฉพาะบล็อกกราฟ จึงโหลดแบบ dynamic ฝั่ง client เท่านั้น
const MemberStatusPieChart = dynamic(
  () => import('./charts').then((m) => m.MemberStatusPieChart),
  { ssr: false, loading: () => <ChartSkeleton /> },
);
const MonthlyFinanceChart = dynamic(
  () => import('./charts').then((m) => m.MonthlyFinanceChart),
  { ssr: false, loading: () => <ChartSkeleton /> },
);
const DeathClaimsTrendChart = dynamic(
  () => import('./charts').then((m) => m.DeathClaimsTrendChart),
  { ssr: false, loading: () => <ChartSkeleton /> },
);
import { useAuthStore } from '@/store/auth';
import { formatThaiDateShort } from '@/components/ThaiDatePicker';
import dayjs from 'dayjs';

interface ExecutiveData {
  summary: {
    totalMembers: number;
    activeMembers: number;
    deathClaimsThisYear: number;
    pendingPayments: number;
    pendingPaymentAmount: number;
    welfareRate: number;
    arrearsCount: number;
  };
  membersByStatus: { status: string; count: number }[];
  membersBySchool: {
    id: string;
    name: string;
    total: number;
    active: number;
    arrears: number;
    deceased: number;
  }[];
  deathClaimsTrend: {
    year: number;
    totalClaims: number;
    totalPaid: number;
    byType: { member: number; parent: number; child: number };
  }[];
  monthlyFinance: {
    month: number;
    year: number;
    receipts: number;
    payments: number;
    net: number;
  }[];
  pendingPayments: any[];
}

const statusLabels: Record<string, string> = {
  ACTIVE: 'ปกติ',
  RESIGNED: 'ลาออก',
  DECEASED: 'เสียชีวิต',
  ARREARS: 'ค้างชำระ',
  SUSPENDED: 'พักสมาชิก',
};

const statusColors: Record<string, string> = {
  ACTIVE: '#10b981',
  RESIGNED: '#94a3b8',
  DECEASED: '#f43f5e',
  ARREARS: '#f59e0b',
  SUSPENDED: '#6366f1',
};

const COLORS = ['#10b981', '#f59e0b', '#f43f5e', '#6366f1', '#94a3b8'];

const thaiMonths = ['ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];

export default function ExecutiveDashboardPage() {
  const { selectedSchoolId } = useAuthStore();

  const { data, isLoading } = useQuery<ExecutiveData>({
    queryKey: ['executive-dashboard', selectedSchoolId],
    queryFn: async () => {
      const params = selectedSchoolId ? `?schoolId=${selectedSchoolId}` : '';
      const response = await api.get(`/reports/executive${params}`);
      return response.data;
    },
  });

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('th-TH', {
      style: 'currency',
      currency: 'THB',
      minimumFractionDigits: 0,
    }).format(amount);
  };

  const formatNumber = (num: number) => {
    return new Intl.NumberFormat('th-TH').format(num);
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  if (!data) {
    return <div className="text-center py-20 text-slate-500">ไม่พบข้อมูล</div>;
  }

  // Prepare chart data
  const financeChartData = data.monthlyFinance.map((m) => ({
    name: `${thaiMonths[m.month - 1]} ${m.year + 543}`,
    รายรับ: m.receipts,
    รายจ่าย: m.payments,
    คงเหลือ: m.net,
  }));

  const deathClaimsChartData = data.deathClaimsTrend.map((d) => ({
    name: `${d.year + 543}`,
    ตัวสมาชิก: d.byType?.member || 0,
    บิดามารดา: d.byType?.parent || 0,
    บุตร: d.byType?.child || 0,
    ยอดจ่าย: d.totalPaid || 0,
  }));

  const memberStatusPieData = data.membersByStatus.map((s) => ({
    name: statusLabels[s.status] || s.status,
    value: s.count,
    color: statusColors[s.status] || '#94a3b8',
  }));

  const contentRef = useRef<HTMLDivElement>(null);

  const handleExportPdf = async () => {
    if (contentRef.current) {
      await exportElementToPdf(contentRef.current, `executive-report-${dayjs().format('YYYY-MM-DD')}.pdf`);
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      className="space-y-6"
      ref={contentRef}
    >
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-display font-bold text-slate-900 flex items-center gap-3">
            <BarChart3 className="w-7 h-7 text-primary-600" />
            Executive Dashboard
          </h1>
          <p className="text-slate-500 mt-1">
            ภาพรวมสมาคมฌาปนกิจสงเคราะห์ สำหรับคณะกรรมการและผู้บริหาร
          </p>
        </div>
        <button onClick={handleExportPdf} className="btn-secondary flex items-center gap-2">
          <Download size={18} /> PDF
        </button>
      </div>

      {/* KPI Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="card p-6"
        >
          <div className="flex items-start justify-between">
            <div>
              <p className="text-sm text-slate-500">สมาชิกทั้งหมด</p>
              <p className="text-3xl font-bold text-slate-900 mt-1">
                {formatNumber(data.summary.totalMembers)}
              </p>
              <p className="text-sm text-emerald-600 mt-2">
                {formatNumber(data.summary.activeMembers)} คน ปกติ
              </p>
            </div>
            <div className="w-14 h-14 bg-primary-100 rounded-2xl flex items-center justify-center">
              <Users className="w-7 h-7 text-primary-600" />
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="card p-6"
        >
          <div className="flex items-start justify-between">
            <div>
              <p className="text-sm text-slate-500">แจ้งเสียชีวิตปีนี้</p>
              <p className="text-3xl font-bold text-rose-600 mt-1">
                {data.summary.deathClaimsThisYear}
              </p>
              <p className="text-sm text-slate-500 mt-2">
                ราย
              </p>
            </div>
            <div className="w-14 h-14 bg-rose-100 rounded-2xl flex items-center justify-center">
              <Flower2 className="w-7 h-7 text-rose-600" />
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
          className="card p-6"
        >
          <div className="flex items-start justify-between">
            <div>
              <p className="text-sm text-slate-500">อัตราเงินช่วยเหลือ</p>
              <p className="text-2xl font-bold text-slate-900 mt-1">
                {formatCurrency(data.summary.welfareRate)}
              </p>
              <p className="text-sm text-slate-500 mt-2">
                ต่อราย (100%)
              </p>
            </div>
            <div className="w-14 h-14 bg-emerald-100 rounded-2xl flex items-center justify-center">
              <DollarSign className="w-7 h-7 text-emerald-600" />
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
          className="card p-6"
        >
          <div className="flex items-start justify-between">
            <div>
              <p className="text-sm text-slate-500">รอจ่ายเงินสงเคราะห์</p>
              <p className="text-3xl font-bold text-amber-600 mt-1">
                {data.summary.pendingPayments}
              </p>
              <p className="text-sm text-amber-600 mt-2">
                {formatCurrency(data.summary.pendingPaymentAmount)}
              </p>
            </div>
            <div className="w-14 h-14 bg-amber-100 rounded-2xl flex items-center justify-center">
              <Clock className="w-7 h-7 text-amber-600" />
            </div>
          </div>
        </motion.div>
      </div>

      {/* Alert Banner */}
      {data.summary.arrearsCount > 0 && (
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          className="bg-amber-50 border border-amber-200 rounded-2xl p-4 flex items-center gap-4"
        >
          <div className="w-12 h-12 bg-amber-100 rounded-xl flex items-center justify-center flex-shrink-0">
            <AlertTriangle className="w-6 h-6 text-amber-600" />
          </div>
          <div>
            <p className="font-semibold text-amber-800">มีสมาชิกค้างชำระเงินสงเคราะห์</p>
            <p className="text-sm text-amber-700">
              พบ {data.summary.arrearsCount} รายการที่ค้างชำระ กรุณาติดตามการชำระเงิน
            </p>
          </div>
        </motion.div>
      )}

      {/* Charts Row 1 */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Member Status Pie Chart */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
          className="card p-6"
        >
          <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
            <PieChart className="w-5 h-5 text-primary-500" />
            สัดส่วนสถานะสมาชิก
          </h3>
          <div className="h-64">
            <MemberStatusPieChart data={memberStatusPieData} />
          </div>
        </motion.div>

        {/* Monthly Finance Chart */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.6 }}
          className="card p-6 lg:col-span-2"
        >
          <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
            <TrendingUp className="w-5 h-5 text-emerald-500" />
            รายรับ-รายจ่าย 12 เดือนย้อนหลัง
          </h3>
          <div className="h-64">
            <MonthlyFinanceChart data={financeChartData} />
          </div>
        </motion.div>
      </div>

      {/* Charts Row 2 */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Death Claims Trend */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.7 }}
          className="card p-6"
        >
          <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
            <Flower2 className="w-5 h-5 text-rose-500" />
            แนวโน้มการแจ้งเสียชีวิต (5 ปี)
          </h3>
          <div className="h-64">
            <DeathClaimsTrendChart data={deathClaimsChartData} />
          </div>
        </motion.div>

        {/* Members by School */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.8 }}
          className="card p-6"
        >
          <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
            <Building2 className="w-5 h-5 text-sky-500" />
            สมาชิกแยกตามโรงเรียน
          </h3>
          <div className="space-y-3 max-h-64 overflow-y-auto">
            {data.membersBySchool.map((school) => (
              <div key={school.id} className="p-3 bg-slate-50 rounded-xl">
                <div className="flex items-center justify-between mb-2">
                  <span className="font-medium text-slate-900 text-sm">{school.name}</span>
                  <span className="text-lg font-bold text-primary-600">{school.total}</span>
                </div>
                <div className="flex gap-2 text-xs">
                  <span className="badge-success">{school.active} ปกติ</span>
                  {school.arrears > 0 && (
                    <span className="badge-warning">{school.arrears} ค้างชำระ</span>
                  )}
                  {school.deceased > 0 && (
                    <span className="badge-danger">{school.deceased} เสียชีวิต</span>
                  )}
                </div>
              </div>
            ))}
          </div>
        </motion.div>
      </div>

      {/* Pending Payments Table */}
      {data.pendingPayments.length > 0 && (
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.9 }}
          className="card p-6"
        >
          <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
            <Clock className="w-5 h-5 text-amber-500" />
            รายการรอจ่ายเงินสงเคราะห์
          </h3>
          <div className="table-container">
            <table className="table">
              <thead>
                <tr>
                  <th>เลขที่</th>
                  <th>ชื่อสมาชิก</th>
                  <th>โรงเรียน</th>
                  <th>วันที่แจ้ง</th>
                  <th className="text-right">ยอดจ่าย</th>
                </tr>
              </thead>
              <tbody>
                {data.pendingPayments.map((payment: any) => (
                  <tr key={payment.id}>
                    <td className="font-mono text-sm">{payment.claimNo}</td>
                    <td>
                      {payment.member?.associationMember?.firstName ?? ''} {payment.member?.associationMember?.lastName ?? ''}
                    </td>
                    <td className="text-slate-500">{payment.school?.name || payment.member?.school?.name || '-'}</td>
                    <td>{formatThaiDateShort(payment.reportedDate)}</td>
                    <td className="text-right font-semibold text-amber-600">
                      {formatCurrency(Number(payment.netToPay || 0))}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </motion.div>
      )}
    </motion.div>
  );
}

