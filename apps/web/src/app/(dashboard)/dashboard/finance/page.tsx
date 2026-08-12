'use client';

import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import {
  TrendingUp,
  TrendingDown,
  Wallet,
  Landmark,
  Info,
  CalendarClock,
} from 'lucide-react';
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Legend,
  ComposedChart,
  Line,
} from 'recharts';
import { api } from '@/lib/api';
import { useAuthStore } from '@/store/auth';

const THAI_MONTHS = ['ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];

const RECEIPT_TYPE_LABELS: Record<string, string> = {
  MEMBER_CONTRIBUTION: 'เงินสงเคราะห์รายเดือน',
  MEMBERSHIP_FEE: 'ค่าสมัครสมาชิก',
  BOOK_FEE: 'ค่าสมุด',
  ANNUAL_FEE: 'ค่าบำรุงรายปี',
  ADVANCE_WELFARE: 'เงินสงเคราะห์ล่วงหน้า',
  DEATH_COLLECTION: 'เก็บเงินกรณีเสียชีวิต',
  OTHER: 'อื่น ๆ',
};

const PAYMENT_TYPE_LABELS: Record<string, string> = {
  DEATH_BENEFIT: 'จ่ายเงินฌาปนกิจ',
  OPERATING_EXPENSE: 'ค่าใช้จ่ายดำเนินงาน',
  BANK_FEE: 'ค่าธรรมเนียมธนาคาร',
  OTHER: 'อื่น ๆ',
};

interface FinanceDashboard {
  year: number;
  openingBalance: number;
  summary: { totalInflow: number; totalOutflow: number; net: number; closingBalance: number };
  monthly: Array<{ month: number; inflow: number; outflow: number; net: number; accumulated: number }>;
  byReceiptType: Array<{ type: string; count: number; amount: number }>;
  byPaymentType: Array<{ type: string; count: number; amount: number }>;
  periodStatus: Array<{
    periodId: string; year: number; month: number; welfareRate: number; isClosed: boolean;
    members: number; due: number; paid: number; outstanding: number; unpaidMembers: number;
  }>;
  topOutstandingMembers: Array<{
    memberId: string; memberNo: string; fullName: string; schoolName: string;
    groupName: string | null; periods: number; due: number; paid: number; outstanding: number;
  }>;
  bankAccounts: Array<{ id: string; bankName: string; accountNo: string; accountName: string }>;
}

const baht = (n: number) =>
  new Intl.NumberFormat('th-TH', { style: 'currency', currency: 'THB', maximumFractionDigits: 0 }).format(n);
const num = (n: number) => new Intl.NumberFormat('th-TH').format(n);

export default function FinanceDashboardPage() {
  const { selectedSchoolId } = useAuthStore();
  const currentYear = new Date().getFullYear();
  const [year, setYear] = useState(currentYear);

  const { data, isLoading } = useQuery<FinanceDashboard>({
    queryKey: ['dashboard-finance', year, selectedSchoolId],
    queryFn: async () => {
      const params = new URLSearchParams({ year: String(year) });
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      return (await api.get(`/dashboards/finance?${params}`)).data;
    },
  });

  if (isLoading) {
    return (
      <div className="flex items-center justify-center py-20">
        <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }
  if (!data) return null;

  const chartData = data.monthly.map((m) => ({
    ...m,
    name: THAI_MONTHS[m.month - 1],
  }));
  const hasMovement = data.summary.totalInflow > 0 || data.summary.totalOutflow > 0;

  return (
    <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-display font-bold text-slate-900">ภาพรวมการเงิน</h1>
          <p className="text-slate-500 mt-1">เงินเข้า–ออก และยอดสะสม รายเดือน / รายคน</p>
        </div>
        <select
          value={year}
          onChange={(e) => setYear(Number(e.target.value))}
          className="input w-full sm:w-44"
        >
          {[0, 1, 2, 3, 4].map((offset) => {
            const y = currentYear - offset;
            return (
              <option key={y} value={y}>
                ปี พ.ศ. {y + 543}
              </option>
            );
          })}
        </select>
      </div>

      {!hasMovement && (
        <div className="card p-4 border-l-4 border-blue-400 flex items-start gap-3">
          <Info size={18} className="text-blue-500 shrink-0 mt-0.5" />
          <div className="text-sm text-slate-600">
            <p className="font-medium text-slate-900">ยังไม่มีรายการเงินเข้า–ออกในปีนี้</p>
            <p className="mt-0.5">
              ตัวเลขทั้งหมดจะเป็น 0 จนกว่าจะเริ่มบันทึกการรับชำระเงินสงเคราะห์หรือใบสำคัญจ่าย
            </p>
          </div>
        </div>
      )}

      {/* ตัวเลขหลัก */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="stat-card">
          <div className="flex items-center justify-between">
            <div>
              <p className="stat-label">เงินเข้าทั้งปี</p>
              <p className="stat-value text-emerald-600">{baht(data.summary.totalInflow)}</p>
            </div>
            <TrendingUp className="w-10 h-10 text-emerald-500 opacity-80" />
          </div>
        </div>
        <div className="stat-card">
          <div className="flex items-center justify-between">
            <div>
              <p className="stat-label">เงินออกทั้งปี</p>
              <p className="stat-value text-red-600">{baht(data.summary.totalOutflow)}</p>
            </div>
            <TrendingDown className="w-10 h-10 text-red-500 opacity-80" />
          </div>
        </div>
        <div className="stat-card">
          <div className="flex items-center justify-between">
            <div>
              <p className="stat-label">คงเหลือสุทธิปีนี้</p>
              <p className={`stat-value ${data.summary.net >= 0 ? 'text-slate-900' : 'text-red-600'}`}>
                {baht(data.summary.net)}
              </p>
            </div>
            <Wallet className="w-10 h-10 text-blue-500 opacity-80" />
          </div>
        </div>
        <div className="stat-card">
          <div className="flex items-center justify-between">
            <div>
              <p className="stat-label">ยอดสะสมปลายปี</p>
              <p className="stat-value">{baht(data.summary.closingBalance)}</p>
              <p className="text-xs text-slate-400 mt-1">ยกมา {baht(data.openingBalance)}</p>
            </div>
            <Landmark className="w-10 h-10 text-violet-500 opacity-80" />
          </div>
        </div>
      </div>

      {/* เงินเข้า-ออก + ยอดสะสม รายเดือน */}
      <div className="card p-6">
        <h2 className="font-semibold text-slate-900 mb-4">เงินเข้า–ออก และยอดสะสมรายเดือน</h2>
        <ResponsiveContainer width="100%" height={340}>
          <ComposedChart data={chartData}>
            <CartesianGrid strokeDasharray="3 3" vertical={false} />
            <XAxis dataKey="name" tick={{ fontSize: 12 }} />
            <YAxis tickFormatter={(v) => num(v)} tick={{ fontSize: 12 }} />
            <Tooltip formatter={(v: number, key) => [baht(v), key]} />
            <Legend />
            <Bar dataKey="inflow" name="เงินเข้า" fill="#10b981" radius={[4, 4, 0, 0]} />
            <Bar dataKey="outflow" name="เงินออก" fill="#f43f5e" radius={[4, 4, 0, 0]} />
            <Line type="monotone" dataKey="accumulated" name="ยอดสะสม" stroke="#8b5cf6" strokeWidth={2} dot={false} />
          </ComposedChart>
        </ResponsiveContainer>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <TypeBreakdown
          title="เงินเข้าแยกตามประเภท"
          rows={data.byReceiptType.map((r) => ({
            label: RECEIPT_TYPE_LABELS[r.type] ?? r.type,
            count: r.count,
            amount: r.amount,
          }))}
          color="#10b981"
        />
        <TypeBreakdown
          title="เงินออกแยกตามประเภท"
          rows={data.byPaymentType.map((r) => ({
            label: PAYMENT_TYPE_LABELS[r.type] ?? r.type,
            count: r.count,
            amount: r.amount,
          }))}
          color="#f43f5e"
        />
      </div>

      {/* สถานะเก็บเงินรายงวด */}
      <div className="card overflow-hidden">
        <div className="p-6 pb-3 flex items-center gap-2">
          <CalendarClock size={18} className="text-slate-400" />
          <h2 className="font-semibold text-slate-900">สถานะเก็บเงินรายงวด</h2>
        </div>
        {data.periodStatus.length === 0 ? (
          <p className="px-6 pb-6 text-sm text-slate-400">ยังไม่มีงวดเก็บเงินในปีนี้</p>
        ) : (
          <div className="table-container border-0">
            <table className="table">
              <thead>
                <tr>
                  <th>งวด</th>
                  <th className="text-center">อัตรา/คน</th>
                  <th className="text-center">สมาชิก</th>
                  <th className="text-right">ต้องเก็บ</th>
                  <th className="text-right">เก็บได้</th>
                  <th className="text-right">ค้าง</th>
                  <th className="text-center">สถานะ</th>
                </tr>
              </thead>
              <tbody>
                {data.periodStatus.map((p) => (
                  <tr key={p.periodId}>
                    <td className="font-medium">{THAI_MONTHS[p.month - 1]} {p.year + 543}</td>
                    <td className="text-center">{baht(p.welfareRate)}</td>
                    <td className="text-center">{num(p.members)}</td>
                    <td className="text-right">{baht(p.due)}</td>
                    <td className="text-right text-emerald-700">{baht(p.paid)}</td>
                    <td className="text-right">
                      {p.outstanding > 0 ? (
                        <span className="text-red-600">
                          {baht(p.outstanding)}
                          <span className="text-xs text-slate-400 ml-1">({num(p.unpaidMembers)} คน)</span>
                        </span>
                      ) : (
                        <span className="text-slate-400">-</span>
                      )}
                    </td>
                    <td className="text-center">
                      {p.isClosed ? (
                        <span className="badge-neutral">ปิดงวดแล้ว</span>
                      ) : (
                        <span className="badge-info">เปิดอยู่</span>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* รายคน */}
      <div className="card overflow-hidden">
        <div className="p-6 pb-3">
          <h2 className="font-semibold text-slate-900">สมาชิกที่ค้างชำระสูงสุด</h2>
          <p className="text-sm text-slate-500 mt-0.5">แสดงสูงสุด 20 อันดับของปี {year + 543}</p>
        </div>
        {data.topOutstandingMembers.length === 0 ? (
          <p className="px-6 pb-6 text-sm text-slate-400">
            {hasMovement ? 'ไม่มีสมาชิกค้างชำระ' : 'ยังไม่มีข้อมูลการชำระเงิน'}
          </p>
        ) : (
          <div className="table-container border-0">
            <table className="table">
              <thead>
                <tr>
                  <th>เลขสมาชิก</th>
                  <th>ชื่อ-นามสกุล</th>
                  <th>โรงเรียน</th>
                  <th>กลุ่ม</th>
                  <th className="text-center">งวด</th>
                  <th className="text-right">ต้องชำระ</th>
                  <th className="text-right">ชำระแล้ว</th>
                  <th className="text-right">ค้าง</th>
                </tr>
              </thead>
              <tbody>
                {data.topOutstandingMembers.map((m) => (
                  <tr key={m.memberId}>
                    <td className="font-mono text-sm">{m.memberNo}</td>
                    <td className="font-medium">{m.fullName}</td>
                    <td className="text-slate-500 text-sm">{m.schoolName}</td>
                    <td className="text-slate-500 text-sm">{m.groupName ?? '-'}</td>
                    <td className="text-center">{num(m.periods)}</td>
                    <td className="text-right">{baht(m.due)}</td>
                    <td className="text-right text-emerald-700">{baht(m.paid)}</td>
                    <td className="text-right text-red-600 font-medium">{baht(m.outstanding)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </motion.div>
  );
}

function TypeBreakdown({
  title,
  rows,
  color,
}: {
  title: string;
  rows: Array<{ label: string; count: number; amount: number }>;
  color: string;
}) {
  return (
    <div className="card p-6">
      <h2 className="font-semibold text-slate-900 mb-4">{title}</h2>
      {rows.length === 0 ? (
        <p className="text-sm text-slate-400 py-8 text-center">ยังไม่มีรายการ</p>
      ) : (
        <ResponsiveContainer width="100%" height={240}>
          <BarChart data={rows} layout="vertical" margin={{ left: 20 }}>
            <CartesianGrid strokeDasharray="3 3" horizontal={false} />
            <XAxis type="number" tickFormatter={(v) => num(v)} tick={{ fontSize: 11 }} />
            <YAxis type="category" dataKey="label" width={120} tick={{ fontSize: 11 }} />
            <Tooltip formatter={(v: number) => baht(v)} />
            <Bar dataKey="amount" fill={color} radius={[0, 4, 4, 0]} name="ยอดเงิน" />
          </BarChart>
        </ResponsiveContainer>
      )}
    </div>
  );
}
