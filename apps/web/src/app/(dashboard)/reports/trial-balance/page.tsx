'use client';

import { useState, useRef } from 'react';
import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { Scale, Download } from 'lucide-react';
import { api } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import ThaiDatePicker from '@/components/ThaiDatePicker';
import dayjs from 'dayjs';
import { exportElementToPdf } from '@/lib/export-pdf';

export default function TrialBalancePage() {
  const { selectedSchoolId } = useAuthStore();
  const [dateRange, setDateRange] = useState({
    startDate: dayjs().startOf('year').format('YYYY-MM-DD'),
    endDate: dayjs().format('YYYY-MM-DD'),
  });

  const { data, isLoading } = useQuery({
    queryKey: ['trial-balance', dateRange, selectedSchoolId],
    queryFn: async () => {
      const params = new URLSearchParams(dateRange);
      // Note: current trial-balance doesn't filter school fully, but pass if needed
      const res = await api.get(`/accounts/trial-balance?${params}`);
      return res.data;
    },
  });

  const fmt = (n: number) =>
    new Intl.NumberFormat('th-TH', { minimumFractionDigits: 2 }).format(n);

  const contentRef = useRef<HTMLDivElement>(null);

  const handleExportPdf = async () => {
    if (contentRef.current) {
      await exportElementToPdf(contentRef.current, `trial-balance-${dateRange.startDate}.pdf`);
    }
  };

  const accounts = data?.accounts || [];
  const totals = data?.totals || { debit: 0, credit: 0, isBalanced: false, difference: 0 };

  return (
    <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-semibold flex items-center gap-2">
            <Scale /> งบทดลอง (Trial Balance)
          </h1>
          <p className="text-sm text-slate-500">ยอดรวมเดบิตและเครดิตตามผังบัญชี</p>
        </div>
        <button onClick={handleExportPdf} className="btn-secondary flex items-center gap-2">
          <Download size={18} /> PDF
        </button>
      </div>

      <div className="flex flex-wrap gap-3 items-end">
        <div>
          <label className="block text-sm mb-1">จากวันที่</label>
          <ThaiDatePicker
            value={dateRange.startDate}
            onChange={(d) => d && setDateRange((p) => ({ ...p, startDate: d.format('YYYY-MM-DD') }))}
          />
        </div>
        <div>
          <label className="block text-sm mb-1">ถึงวันที่</label>
          <ThaiDatePicker
            value={dateRange.endDate}
            onChange={(d) => d && setDateRange((p) => ({ ...p, endDate: d.format('YYYY-MM-DD') }))}
          />
        </div>
      </div>

      {isLoading ? (
        <div className="h-40 flex items-center justify-center">Loading...</div>
      ) : (
        <div ref={contentRef} className="card p-6 overflow-auto">
          <table className="w-full text-sm min-w-[800px]">
            <thead>
              <tr className="border-b">
                <th className="text-left p-2">รหัส</th>
                <th className="text-left p-2">ชื่อบัญชี</th>
                <th className="text-left p-2">ประเภท</th>
                <th className="text-right p-2">เดบิต</th>
                <th className="text-right p-2">เครดิต</th>
                <th className="text-right p-2">ยอดคงเหลือ</th>
              </tr>
            </thead>
            <tbody>
              {accounts.map((a: any) => (
                <tr key={a.id} className="border-b hover:bg-slate-50">
                  <td className="p-2 font-mono">{a.code}</td>
                  <td className="p-2">{a.name}</td>
                  <td className="p-2">{a.type}</td>
                  <td className="p-2 text-right">{fmt(a.debit)}</td>
                  <td className="p-2 text-right">{fmt(a.credit)}</td>
                  <td className="p-2 text-right font-medium">{fmt(a.balance)}</td>
                </tr>
              ))}
            </tbody>
            <tfoot>
              <tr className="font-bold border-t-2">
                <td colSpan={3} className="p-2">รวม</td>
                <td className="p-2 text-right">{fmt(totals.debit)}</td>
                <td className="p-2 text-right">{fmt(totals.credit)}</td>
                <td className="p-2 text-right"></td>
              </tr>
            </tfoot>
          </table>

          <div className="mt-4 text-sm">
            <div className={totals.isBalanced ? 'text-emerald-600' : 'text-red-600'}>
              {totals.isBalanced ? '✓ งบทดลองสมดุล' : `⚠ ไม่สมดุล ต่างกัน ${fmt(totals.difference)}`}
            </div>
          </div>
        </div>
      )}
    </motion.div>
  );
}
