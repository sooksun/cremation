'use client';

import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import {
  Users,
  Flower2,
  TrendingUp,
  TrendingDown,
  Activity,
  AlertCircle,
  CheckCircle2,
  Clock,
  ArrowUpRight,
} from 'lucide-react';
import { api, type DashboardData, type DeathClaim } from '@/lib/api';
import { useAuthStore } from '@/store/auth';

const statusColors = {
  ACTIVE: 'badge-success',
  RESIGNED: 'badge-neutral',
  DECEASED: 'badge-danger',
  ARREARS: 'badge-warning',
  SUSPENDED: 'badge-info',
};

const statusLabels = {
  ACTIVE: 'ปกติ',
  RESIGNED: 'ลาออก',
  DECEASED: 'เสียชีวิต',
  ARREARS: 'ค้างชำระ',
  SUSPENDED: 'พักสมาชิก',
};

const containerVariants = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: {
      staggerChildren: 0.1,
    },
  },
};

const itemVariants = {
  hidden: { opacity: 0, y: 20 },
  visible: { opacity: 1, y: 0 },
};

export default function DashboardPage() {
  const { selectedSchoolId, selectedYear } = useAuthStore();

  const { data: dashboard, isLoading } = useQuery<DashboardData>({
    queryKey: ['dashboard', selectedSchoolId, selectedYear],
    queryFn: async () => {
      const params = new URLSearchParams();
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      params.append('year', selectedYear.toString());
      const response = await api.get(`/reports/dashboard?${params}`);
      return response.data;
    },
  });

  const { data: recentClaims } = useQuery<DeathClaim[]>({
    queryKey: ['recent-claims', selectedSchoolId, selectedYear],
    queryFn: async () => {
      const params = new URLSearchParams();
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      params.append('year', selectedYear.toString());
      const response = await api.get(`/death-claims?${params}`);
      return response.data.slice(0, 5);
    },
  });

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('th-TH', {
      style: 'currency',
      currency: 'THB',
      minimumFractionDigits: 0,
    }).format(amount);
  };

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('th-TH', {
      day: 'numeric',
      month: 'short',
      year: 'numeric',
    });
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <motion.div
      variants={containerVariants}
      initial="hidden"
      animate="visible"
      className="space-y-6"
    >
      {/* Page header */}
      <motion.div variants={itemVariants}>
        <h1 className="text-2xl font-display font-bold text-slate-900">
          ภาพรวมระบบ
        </h1>
        <p className="text-slate-500 mt-1">
          สรุปข้อมูลสมาชิกและการเงินประจำปี พ.ศ. {selectedYear + 543}
        </p>
      </motion.div>

      {/* Stats cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <motion.div variants={itemVariants} className="stat-card">
          <div className="flex items-start justify-between">
            <div>
              <p className="stat-label">สมาชิกทั้งหมด</p>
              <p className="stat-value">{dashboard?.members.total.toLocaleString()}</p>
            </div>
            <div className="w-12 h-12 bg-primary-100 rounded-xl flex items-center justify-center">
              <Users className="w-6 h-6 text-primary-600" />
            </div>
          </div>
          <div className="mt-4 flex items-center gap-2 text-sm">
            <span className="badge-success">{dashboard?.members.active} ปกติ</span>
            <span className="badge-warning">{dashboard?.members.arrears} ค้างชำระ</span>
          </div>
        </motion.div>

        <motion.div variants={itemVariants} className="stat-card">
          <div className="flex items-start justify-between">
            <div>
              <p className="stat-label">แจ้งเสียชีวิตปีนี้</p>
              <p className="stat-value">{dashboard?.deathClaims.thisYear}</p>
            </div>
            <div className="w-12 h-12 bg-rose-100 rounded-xl flex items-center justify-center">
              <Flower2 className="w-6 h-6 text-rose-600" />
            </div>
          </div>
          <div className="mt-4 text-sm text-slate-500">
            รอจ่ายเงินสงเคราะห์
          </div>
        </motion.div>

        <motion.div variants={itemVariants} className="stat-card">
          <div className="flex items-start justify-between">
            <div>
              <p className="stat-label">รับเงินเดือนนี้</p>
              <p className="stat-value text-emerald-600">
                {formatCurrency(dashboard?.finance.receiptsThisMonth.amount || 0)}
              </p>
            </div>
            <div className="w-12 h-12 bg-emerald-100 rounded-xl flex items-center justify-center">
              <TrendingUp className="w-6 h-6 text-emerald-600" />
            </div>
          </div>
          <div className="mt-4 text-sm text-slate-500">
            {dashboard?.finance.receiptsThisMonth.count} รายการ
          </div>
        </motion.div>

        <motion.div variants={itemVariants} className="stat-card">
          <div className="flex items-start justify-between">
            <div>
              <p className="stat-label">จ่ายเงินเดือนนี้</p>
              <p className="stat-value text-amber-600">
                {formatCurrency(dashboard?.finance.paymentsThisMonth.amount || 0)}
              </p>
            </div>
            <div className="w-12 h-12 bg-amber-100 rounded-xl flex items-center justify-center">
              <TrendingDown className="w-6 h-6 text-amber-600" />
            </div>
          </div>
          <div className="mt-4 text-sm text-slate-500">
            {dashboard?.finance.paymentsThisMonth.count} รายการ
          </div>
        </motion.div>
      </div>

      {/* Main content grid */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Member status breakdown */}
        <motion.div variants={itemVariants} className="lg:col-span-1 card p-6">
          <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
            <Activity className="w-5 h-5 text-primary-500" />
            สถานะสมาชิก
          </h3>
          <div className="space-y-4">
            {[
              { status: 'ACTIVE' as const, icon: CheckCircle2, color: 'text-emerald-500' },
              { status: 'ARREARS' as const, icon: AlertCircle, color: 'text-amber-500' },
              { status: 'RESIGNED' as const, icon: Clock, color: 'text-slate-400' },
              { status: 'DECEASED' as const, icon: Flower2, color: 'text-rose-500' },
            ].map((item) => {
              const count = dashboard?.members[item.status.toLowerCase() as keyof typeof dashboard.members] || 0;
              const total = dashboard?.members.total || 1;
              const percentage = Math.round((count / total) * 100);
              const Icon = item.icon;

              return (
                <div key={item.status} className="flex items-center gap-3">
                  <Icon className={`w-5 h-5 ${item.color}`} />
                  <div className="flex-1">
                    <div className="flex justify-between text-sm mb-1">
                      <span className="text-slate-600">{statusLabels[item.status]}</span>
                      <span className="font-medium">{count} คน</span>
                    </div>
                    <div className="h-2 bg-slate-100 rounded-full overflow-hidden">
                      <div
                        className={`h-full rounded-full ${
                          item.status === 'ACTIVE'
                            ? 'bg-emerald-500'
                            : item.status === 'ARREARS'
                            ? 'bg-amber-500'
                            : item.status === 'DECEASED'
                            ? 'bg-rose-500'
                            : 'bg-slate-400'
                        }`}
                        style={{ width: `${percentage}%` }}
                      />
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </motion.div>

        {/* Recent death claims */}
        <motion.div variants={itemVariants} className="lg:col-span-2 card p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-slate-900 flex items-center gap-2">
              <Flower2 className="w-5 h-5 text-rose-500" />
              การแจ้งเสียชีวิตล่าสุด
            </h3>
            <a
              href="/death-claims"
              className="text-sm text-primary-600 hover:text-primary-700 flex items-center gap-1"
            >
              ดูทั้งหมด
              <ArrowUpRight className="w-4 h-4" />
            </a>
          </div>

          {recentClaims && recentClaims.length > 0 ? (
            <div className="table-container">
              <table className="table">
                <thead>
                  <tr>
                    <th>เลขที่</th>
                    <th>ชื่อสมาชิก</th>
                    <th>โรงเรียน</th>
                    <th>วันที่เสียชีวิต</th>
                    <th className="text-right">เงินสงเคราะห์</th>
                    <th>สถานะ</th>
                  </tr>
                </thead>
                <tbody>
                  {recentClaims.map((claim) => (
                    <tr key={claim.id}>
                      <td className="font-mono text-sm">{claim.claimNo}</td>
                      <td>
                        {claim.member.firstName} {claim.member.lastName}
                      </td>
                      <td className="text-slate-500 text-sm">{claim.school.name}</td>
                      <td className="text-sm">{formatDate(claim.deathDate)}</td>
                      <td className="text-right font-medium">
                        {formatCurrency(claim.netToPay)}
                      </td>
                      <td>
                        {claim.payment ? (
                          <span className="badge-success">จ่ายแล้ว</span>
                        ) : (
                          <span className="badge-warning">รอจ่าย</span>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          ) : (
            <div className="text-center py-8 text-slate-500">
              <Flower2 className="w-12 h-12 mx-auto text-slate-300 mb-3" />
              <p>ไม่มีข้อมูลการแจ้งเสียชีวิตในปีนี้</p>
            </div>
          )}
        </motion.div>
      </div>
    </motion.div>
  );
}

