'use client';

import { useQuery } from '@tanstack/react-query';
import { useRef } from 'react';
import { motion } from 'framer-motion';
import {
  Receipt,
  CreditCard,
  TrendingUp,
  TrendingDown,
  DollarSign,
  Flower2,
  PieChart,
  BarChart3,
  Building,
  Calendar,
  Download,
} from 'lucide-react';
import { exportElementToPdf } from '@/lib/export-pdf';
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  LineChart,
  Line,
  Legend,
  PieChart as RechartsPieChart,
  Pie,
  Cell,
  AreaChart,
  Area,
} from 'recharts';
import { api } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import dayjs from 'dayjs';

interface FinanceData {
  year: number;
  summary: {
    totalReceipts: number;
    totalPayments: number;
    netIncome: number;
    deathBenefitsPaid: number;
    deathBenefitsCount: number;
  };
  receiptsByType: { type: string; count: number; amount: number }[];
  paymentsByType: { type: string; count: number; amount: number }[];
  monthlyData: { month: number; receipts: number; payments: number; net: number }[];
  contributionsByPeriod: {
    period: { id: string; year: number; month: number };
    totalExpected: number;
    totalPaid: number;
    collectionRate: number;
  }[];
  bankAccounts: any[];
}

const receiptTypeLabels: Record<string, string> = {
  MEMBER_CONTRIBUTION: 'เงินสงเคราะห์',
  MEMBERSHIP_FEE: 'ค่าสมาชิกแรกเข้า',
  BOOK_FEE: 'ค่าสมุด',
  ANNUAL_FEE: 'ค่าบำรุงประจำปี',
  ADVANCE_WELFARE: 'เงินสำรองจ่าย',
  OTHER: 'อื่นๆ',
};

const paymentTypeLabels: Record<string, string> = {
  DEATH_BENEFIT: 'เงินสงเคราะห์ศพ',
  OPERATING_EXPENSE: 'ค่าดำเนินงาน',
  BANK_FEE: 'ค่าธรรมเนียมธนาคาร',
  OTHER: 'อื่นๆ',
};

const thaiMonths = ['ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];
const COLORS = ['#10b981', '#3b82f6', '#f59e0b', '#f43f5e', '#8b5cf6', '#06b6d4'];

export default function FinanceDashboardPage() {
  const { selectedSchoolId, selectedYear } = useAuthStore();
  const contentRef = useRef<HTMLDivElement>(null);

  const handleExportPdf = async () => {
    if (contentRef.current) {
      await exportElementToPdf(contentRef.current, `finance-report-${selectedYear}.pdf`);
    }
  };

  const { data, isLoading } = useQuery<FinanceData>({
    queryKey: ['finance-dashboard', selectedYear, selectedSchoolId],
    queryFn: async () => {
      const params = new URLSearchParams();
      params.append('year', selectedYear.toString());
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      const response = await api.get(`/reports/finance-dashboard?${params}`);
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
  const monthlyChartData = data.monthlyData.map((m) => ({
    name: thaiMonths[m.month - 1],
    รายรับ: m.receipts,
    รายจ่าย: m.payments,
    คงเหลือ: m.net,
  }));

  const receiptsPieData = data.receiptsByType.map((r, i) => ({
    name: receiptTypeLabels[r.type] || r.type,
    value: r.amount,
    color: COLORS[i % COLORS.length],
  }));

  const paymentsPieData = data.paymentsByType.map((p, i) => ({
    name: paymentTypeLabels[p.type] || p.type,
    value: p.amount,
    color: COLORS[i % COLORS.length],
  }));

  const collectionRateData = data.contributionsByPeriod.map((c) => ({
    name: thaiMonths[c.period.month - 1],
    อัตราเก็บ: c.collectionRate,
    คาดหวัง: c.totalExpected,
    เก็บได้: c.totalPaid,
  }));

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
            <DollarSign className="w-7 h-7 text-emerald-600" />
            Finance Dashboard
          </h1>
          <p className="text-slate-500 mt-1">
            สรุปการเงินประจำปี พ.ศ. {selectedYear + 543} • สำหรับเจ้าหน้าที่บัญชีและการเงิน
          </p>
        </div>
        <button onClick={handleExportPdf} className="btn-secondary flex items-center gap-2">
          <Download size={18} /> PDF
        </button>
      </div>

      {/* Summary Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="card p-6 bg-gradient-to-br from-emerald-500 to-emerald-600 text-white"
        >
          <div className="flex items-start justify-between">
            <div>
              <p className="text-sm text-emerald-100">รายรับรวม</p>
              <p className="text-2xl font-bold mt-1">
                {formatCurrency(data.summary.totalReceipts)}
              </p>
            </div>
            <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center">
              <TrendingUp className="w-6 h-6" />
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="card p-6 bg-gradient-to-br from-rose-500 to-rose-600 text-white"
        >
          <div className="flex items-start justify-between">
            <div>
              <p className="text-sm text-rose-100">รายจ่ายรวม</p>
              <p className="text-2xl font-bold mt-1">
                {formatCurrency(data.summary.totalPayments)}
              </p>
            </div>
            <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center">
              <TrendingDown className="w-6 h-6" />
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
          className={`card p-6 ${
            data.summary.netIncome >= 0
              ? 'bg-gradient-to-br from-sky-500 to-sky-600'
              : 'bg-gradient-to-br from-amber-500 to-amber-600'
          } text-white`}
        >
          <div className="flex items-start justify-between">
            <div>
              <p className="text-sm opacity-80">รายรับ - รายจ่าย</p>
              <p className="text-2xl font-bold mt-1">
                {formatCurrency(data.summary.netIncome)}
              </p>
            </div>
            <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center">
              <DollarSign className="w-6 h-6" />
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
          className="card p-6 bg-gradient-to-br from-purple-500 to-purple-600 text-white"
        >
          <div className="flex items-start justify-between">
            <div>
              <p className="text-sm text-purple-100">จ่ายเงินสงเคราะห์ศพ</p>
              <p className="text-2xl font-bold mt-1">
                {formatCurrency(data.summary.deathBenefitsPaid)}
              </p>
              <p className="text-sm text-purple-200 mt-1">
                {data.summary.deathBenefitsCount} ราย
              </p>
            </div>
            <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center">
              <Flower2 className="w-6 h-6" />
            </div>
          </div>
        </motion.div>
      </div>

      {/* Monthly Chart */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.5 }}
        className="card p-6"
      >
        <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
          <BarChart3 className="w-5 h-5 text-primary-500" />
          รายรับ-รายจ่ายรายเดือน ปี พ.ศ. {selectedYear + 543}
        </h3>
        <div className="h-80">
          <ResponsiveContainer width="100%" height="100%">
            <AreaChart data={monthlyChartData}>
              <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" />
              <XAxis dataKey="name" tick={{ fontSize: 12 }} />
              <YAxis tickFormatter={(value) => `${(value / 1000).toFixed(0)}k`} tick={{ fontSize: 12 }} />
              <Tooltip formatter={(value: number) => formatCurrency(value)} />
              <Legend />
              <Area type="monotone" dataKey="รายรับ" stackId="1" stroke="#10b981" fill="#10b981" fillOpacity={0.6} />
              <Area type="monotone" dataKey="รายจ่าย" stackId="2" stroke="#f43f5e" fill="#f43f5e" fillOpacity={0.6} />
            </AreaChart>
          </ResponsiveContainer>
        </div>
      </motion.div>

      {/* Income/Expense Breakdown */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Receipts by Type */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.6 }}
          className="card p-6"
        >
          <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
            <Receipt className="w-5 h-5 text-emerald-500" />
            รายรับแยกตามประเภท
          </h3>
          <div className="grid grid-cols-2 gap-4">
            <div className="h-48">
              <ResponsiveContainer width="100%" height="100%">
                <RechartsPieChart>
                  <Pie
                    data={receiptsPieData}
                    cx="50%"
                    cy="50%"
                    innerRadius={40}
                    outerRadius={70}
                    dataKey="value"
                  >
                    {receiptsPieData.map((entry, index) => (
                      <Cell key={`cell-${index}`} fill={entry.color} />
                    ))}
                  </Pie>
                  <Tooltip formatter={(value: number) => formatCurrency(value)} />
                </RechartsPieChart>
              </ResponsiveContainer>
            </div>
            <div className="space-y-2">
              {data.receiptsByType.map((r, i) => (
                <div key={r.type} className="flex items-center justify-between text-sm">
                  <div className="flex items-center gap-2">
                    <div
                      className="w-3 h-3 rounded-full"
                      style={{ backgroundColor: COLORS[i % COLORS.length] }}
                    />
                    <span className="text-slate-600">{receiptTypeLabels[r.type] || r.type}</span>
                  </div>
                  <span className="font-medium">{formatCurrency(r.amount)}</span>
                </div>
              ))}
            </div>
          </div>
        </motion.div>

        {/* Payments by Type */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.7 }}
          className="card p-6"
        >
          <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
            <CreditCard className="w-5 h-5 text-rose-500" />
            รายจ่ายแยกตามประเภท
          </h3>
          <div className="grid grid-cols-2 gap-4">
            <div className="h-48">
              <ResponsiveContainer width="100%" height="100%">
                <RechartsPieChart>
                  <Pie
                    data={paymentsPieData}
                    cx="50%"
                    cy="50%"
                    innerRadius={40}
                    outerRadius={70}
                    dataKey="value"
                  >
                    {paymentsPieData.map((entry, index) => (
                      <Cell key={`cell-${index}`} fill={entry.color} />
                    ))}
                  </Pie>
                  <Tooltip formatter={(value: number) => formatCurrency(value)} />
                </RechartsPieChart>
              </ResponsiveContainer>
            </div>
            <div className="space-y-2">
              {data.paymentsByType.map((p, i) => (
                <div key={p.type} className="flex items-center justify-between text-sm">
                  <div className="flex items-center gap-2">
                    <div
                      className="w-3 h-3 rounded-full"
                      style={{ backgroundColor: COLORS[i % COLORS.length] }}
                    />
                    <span className="text-slate-600">{paymentTypeLabels[p.type] || p.type}</span>
                  </div>
                  <span className="font-medium">{formatCurrency(p.amount)}</span>
                </div>
              ))}
            </div>
          </div>
        </motion.div>
      </div>

      {/* Collection Rate */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.8 }}
        className="card p-6"
      >
        <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
          <Calendar className="w-5 h-5 text-sky-500" />
          อัตราการเก็บเงินสงเคราะห์รายงวด
        </h3>
        <div className="h-64">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={collectionRateData}>
              <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" />
              <XAxis dataKey="name" tick={{ fontSize: 12 }} />
              <YAxis yAxisId="left" tick={{ fontSize: 12 }} domain={[0, 100]} unit="%" />
              <YAxis
                yAxisId="right"
                orientation="right"
                tickFormatter={(value) => `${(value / 1000).toFixed(0)}k`}
                tick={{ fontSize: 12 }}
              />
              <Tooltip
                formatter={(value: number, name: string) =>
                  name === 'อัตราเก็บ' ? `${value}%` : formatCurrency(value)
                }
              />
              <Legend />
              <Bar yAxisId="left" dataKey="อัตราเก็บ" fill="#10b981" radius={[4, 4, 0, 0]} />
              <Line yAxisId="right" type="monotone" dataKey="คาดหวัง" stroke="#f59e0b" strokeWidth={2} />
              <Line yAxisId="right" type="monotone" dataKey="เก็บได้" stroke="#3b82f6" strokeWidth={2} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </motion.div>

      {/* Bank Accounts */}
      {data.bankAccounts.length > 0 && (
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.9 }}
          className="card p-6"
        >
          <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
            <Building className="w-5 h-5 text-purple-500" />
            บัญชีธนาคาร
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {data.bankAccounts.map((account: any) => (
              <div key={account.id} className="p-4 bg-slate-50 rounded-xl">
                <div className="flex items-center gap-3 mb-2">
                  <div className="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center">
                    <Building className="w-5 h-5 text-purple-600" />
                  </div>
                  <div>
                    <p className="font-medium text-slate-900">{account.bankName}</p>
                    <p className="text-sm text-slate-500">{account.accountNo}</p>
                  </div>
                </div>
                <p className="text-sm text-slate-600">{account.accountName}</p>
                {account.school && (
                  <p className="text-xs text-slate-400 mt-1">{account.school.name}</p>
                )}
              </div>
            ))}
          </div>
        </motion.div>
      )}
    </motion.div>
  );
}

