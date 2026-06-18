'use client';

import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { CalendarDays, ArrowDownLeft, ArrowUpRight } from 'lucide-react';
import { api } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import ThaiDatePicker from '@/components/ThaiDatePicker';
import dayjs from 'dayjs';

export default function DailyMovementPage() {
  const { selectedSchoolId } = useAuthStore();
  const [date, setDate] = useState(dayjs().format('YYYY-MM-DD'));

  const { data, isLoading } = useQuery({
    queryKey: ['daily-movement', date, selectedSchoolId],
    queryFn: async () => {
      const params = new URLSearchParams({ date });
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      const res = await api.get(`/reports/daily-movement?${params}`);
      return res.data;
    },
  });

  const fmt = (n: number) =>
    new Intl.NumberFormat('th-TH', { style: 'currency', currency: 'THB' }).format(n);

  return (
    <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-6">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-display font-bold text-slate-900">รายงานรายวัน</h1>
          <p className="text-slate-500 mt-1">สรุปเงินรับ-จ่ายและธุรกรรมธนาคารรายวัน</p>
        </div>
        <div className="flex items-center gap-2">
          <CalendarDays size={18} className="text-slate-400" />
          <ThaiDatePicker
            value={date}
            onChange={(d) => d && setDate(d.format('YYYY-MM-DD'))}
          />
        </div>
      </div>

      {isLoading ? (
        <div className="flex justify-center py-20"><div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" /></div>
      ) : data ? (
        <>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="card p-4 flex items-center gap-3">
              <ArrowDownLeft className="text-emerald-600" />
              <div><p className="text-sm text-slate-500">เงินรับ</p><p className="text-xl font-bold text-emerald-700">{fmt(data.summary.cashIn)}</p></div>
            </div>
            <div className="card p-4 flex items-center gap-3">
              <ArrowUpRight className="text-red-600" />
              <div><p className="text-sm text-slate-500">เงินจ่าย</p><p className="text-xl font-bold text-red-700">{fmt(data.summary.cashOut)}</p></div>
            </div>
            <div className="card p-4">
              <p className="text-sm text-slate-500">สุทธิ</p>
              <p className={`text-xl font-bold ${data.summary.netMovement >= 0 ? 'text-primary-700' : 'text-red-700'}`}>
                {fmt(data.summary.netMovement)}
              </p>
            </div>
          </div>

          <TxnTable title={`ใบเสร็จ (${data.receipts.length})`} rows={data.receipts.map((r: any) => [r.receiptNo, r.type, r.school || '-', fmt(r.amount)])} />
          <TxnTable title={`ใบสำคัญจ่าย (${data.payments.length})`} rows={data.payments.map((p: any) => [p.voucherNo, p.type, p.school || '-', fmt(p.amount)])} />
          <TxnTable title={`ธุรกรรมธนาคาร (${data.bankTransactions.length})`} rows={data.bankTransactions.map((t: any) => [t.transactionNo, t.type, t.bankAccount, fmt(t.amount)])} />
        </>
      ) : null}
    </motion.div>
  );
}

function TxnTable({ title, rows }: { title: string; rows: string[][] }) {
  if (!rows.length) return null;
  return (
    <div className="card overflow-hidden">
      <h3 className="font-semibold px-4 py-3 border-b bg-slate-50">{title}</h3>
      <table className="w-full text-sm">
        <tbody>
          {rows.map((row, i) => (
            <tr key={i} className="border-b border-slate-100">
              {row.map((cell, j) => (
                <td key={j} className={`px-4 py-2 ${j === row.length - 1 ? 'text-right font-medium' : ''}`}>{cell}</td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}