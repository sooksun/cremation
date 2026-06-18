'use client';

import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { FileSpreadsheet, Scale } from 'lucide-react';
import { api } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import ThaiDatePicker from '@/components/ThaiDatePicker';
import dayjs from 'dayjs';

export default function FinancialStatementsPage() {
  const { selectedYear } = useAuthStore();
  const [asOfDate, setAsOfDate] = useState(dayjs().format('YYYY-MM-DD'));
  const [plRange, setPlRange] = useState({
    startDate: `${selectedYear}-01-01`,
    endDate: `${selectedYear}-12-31`,
  });

  const { data: balanceSheet, isLoading: loadingBS } = useQuery({
    queryKey: ['balance-sheet', asOfDate],
    queryFn: async () => {
      const res = await api.get(`/accounts/reports/balance-sheet?asOfDate=${asOfDate}`);
      return res.data;
    },
  });

  const { data: profitLoss, isLoading: loadingPL } = useQuery({
    queryKey: ['profit-loss', plRange],
    queryFn: async () => {
      const params = new URLSearchParams(plRange);
      const res = await api.get(`/accounts/reports/profit-loss?${params}`);
      return res.data;
    },
  });

  const fmt = (n: number) =>
    new Intl.NumberFormat('th-TH', { style: 'currency', currency: 'THB' }).format(n);

  return (
    <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-6">
      <div>
        <h1 className="text-2xl font-display font-bold text-slate-900">งบการเงิน</h1>
        <p className="text-slate-500 mt-1">งบดุลและงบกำไรขาดทุน จากผังบัญชีและสมุดรายวัน</p>
      </div>

      <div className="grid grid-cols-1 xl:grid-cols-2 gap-6">
        <div className="card p-6">
          <div className="flex items-center justify-between mb-4">
            <h2 className="font-semibold flex items-center gap-2"><Scale size={20} />งบดุล</h2>
            <ThaiDatePicker
              value={asOfDate}
              onChange={(d) => d && setAsOfDate(d.format('YYYY-MM-DD'))}
            />
          </div>
          {loadingBS ? (
            <div className="h-32 flex items-center justify-center"><div className="w-6 h-6 border-2 border-primary-500 border-t-transparent rounded-full animate-spin" /></div>
          ) : balanceSheet ? (
            <div className="space-y-4 text-sm">
              <Section title="สินทรัพย์" rows={balanceSheet.assets} fmt={fmt} />
              <Section title="หนี้สิน" rows={balanceSheet.liabilities} fmt={fmt} />
              <Section title="ทุน" rows={balanceSheet.equity} fmt={fmt} />
              <div className="border-t pt-3 space-y-1 font-medium">
                <div className="flex justify-between"><span>รวมสินทรัพย์</span><span>{fmt(balanceSheet.totals.assets)}</span></div>
                <div className="flex justify-between"><span>รวมหนี้สิน + ทุน</span><span>{fmt(balanceSheet.totals.liabilitiesAndEquity)}</span></div>
              </div>
            </div>
          ) : null}
        </div>

        <div className="card p-6">
          <div className="flex items-center gap-2 mb-4">
            <FileSpreadsheet size={20} />
            <h2 className="font-semibold">งบกำไรขาดทุน</h2>
          </div>
          <div className="flex flex-wrap gap-3 mb-4">
            <ThaiDatePicker
              value={plRange.startDate}
              onChange={(d) => d && setPlRange((p) => ({ ...p, startDate: d.format('YYYY-MM-DD') }))}
            />
            <ThaiDatePicker
              value={plRange.endDate}
              onChange={(d) => d && setPlRange((p) => ({ ...p, endDate: d.format('YYYY-MM-DD') }))}
            />
          </div>
          {loadingPL ? (
            <div className="h-32 flex items-center justify-center"><div className="w-6 h-6 border-2 border-primary-500 border-t-transparent rounded-full animate-spin" /></div>
          ) : profitLoss ? (
            <div className="space-y-4 text-sm">
              <Section title="รายได้" rows={profitLoss.income.map((r: any) => ({ ...r, balance: r.amount }))} fmt={fmt} />
              <Section title="ค่าใช้จ่าย" rows={profitLoss.expenses.map((r: any) => ({ ...r, balance: r.amount }))} fmt={fmt} />
              <div className="border-t pt-3 font-bold flex justify-between">
                <span>กำไร (ขาดทุน) สุทธิ</span>
                <span className={profitLoss.totals.netProfit >= 0 ? 'text-emerald-600' : 'text-red-600'}>
                  {fmt(profitLoss.totals.netProfit)}
                </span>
              </div>
            </div>
          ) : null}
        </div>
      </div>
    </motion.div>
  );
}

function Section({ title, rows, fmt }: { title: string; rows: { code: string; name: string; balance: number }[]; fmt: (n: number) => string }) {
  if (!rows?.length) return <p className="text-slate-400">{title}: ไม่มีข้อมูล</p>;
  return (
    <div>
      <h3 className="font-medium text-slate-700 mb-2">{title}</h3>
      <table className="w-full">
        <tbody>
          {rows.map((r) => (
            <tr key={r.code} className="border-b border-slate-100">
              <td className="py-1.5">{r.code} {r.name}</td>
              <td className="py-1.5 text-right">{fmt(r.balance)}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}