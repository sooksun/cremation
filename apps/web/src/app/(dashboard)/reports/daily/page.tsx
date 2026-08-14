'use client';

import { useState, useRef } from 'react';
import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { CalendarDays, ArrowDownLeft, ArrowUpRight, Download } from 'lucide-react';
import { api } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import ThaiDatePicker from '@/components/ThaiDatePicker';
import dayjs from 'dayjs';
import { exportElementToPdf } from '@/lib/export-pdf';
import { exportToCsv } from '@/lib/export-csv';

export default function DailyMovementPage() {
  const { selectedSchoolId } = useAuthStore();
  const [date, setDate] = useState(dayjs().format('YYYY-MM-DD'));
  const contentRef = useRef<HTMLDivElement>(null);

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

  const handleExportPdf = async () => {
    if (contentRef.current) {
      await exportElementToPdf(contentRef.current, `รายงานรายวัน-${date}.pdf`);
    }
  };

  const handleExportCsv = () => {
    if (!data) return;
    const rows: any[][] = [
      ['วันที่', 'ประเภท', 'เลขที่', 'โรงเรียน', 'จำนวนเงิน'],
    ];
    data.receipts.forEach((r: any) => rows.push([date, 'ใบเสร็จ', r.receiptNo, r.school || '-', r.amount]));
    data.payments.forEach((p: any) => rows.push([date, 'ใบสำคัญจ่าย', p.voucherNo, p.school || '-', p.amount]));
    data.bankTransactions.forEach((t: any) => rows.push([date, 'ธนาคาร', t.transactionNo, t.bankAccount, t.amount]));
    exportToCsv(`รายงานรายวัน-${date}`, rows);
  };

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
          <button onClick={handleExportPdf} className="btn-secondary flex items-center gap-2">
            <Download size={18} /> PDF
          </button>
          <button onClick={handleExportCsv} className="btn-secondary flex items-center gap-2">
            <Download size={18} /> CSV
          </button>
        </div>
      </div>

      {isLoading ? (
        <div className="flex justify-center py-20"><div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" /></div>
      ) : data ? (
        <div ref={contentRef}>
          {data.summary.bankIncludedInTotals === false && (
            <div className="mb-4 rounded-lg border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-800">
              เลือกโรงเรียนอยู่ — <span className="font-semibold">เงินรับ/เงินจ่าย/สุทธิ</span> ด้านล่างเป็นของโรงเรียนที่เลือกเท่านั้น
              ส่วน <span className="font-semibold">ธุรกรรมธนาคาร</span> เป็นยอดทั้งสมาคม
              เพราะบัญชีธนาคารใช้ร่วมกันทั้งเขต จึงไม่ถูกรวมเข้ายอดสุทธิ
            </div>
          )}

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
          <TxnTable
            title={`ธุรกรรมธนาคาร (${data.bankTransactions.length})`}
            badge={data.summary.bankIncludedInTotals === false ? 'ทั้งสมาคม — ไม่รวมในยอดสุทธิ' : undefined}
            rows={data.bankTransactions.map((t: any) => [t.transactionNo, t.type, t.bankAccount, fmt(t.amount)])}
          />
        </div>
      ) : null}
    </motion.div>
  );
}

function TxnTable({ title, rows, badge }: { title: string; rows: string[][]; badge?: string }) {
  if (!rows.length) return null;
  return (
    <div className="card overflow-hidden">
      <h3 className="font-semibold px-4 py-3 border-b bg-slate-50 flex items-center gap-2">
        {title}
        {badge && (
          <span className="rounded bg-amber-100 px-2 py-0.5 text-[11px] font-medium text-amber-700">
            {badge}
          </span>
        )}
      </h3>
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