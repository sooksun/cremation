'use client';

import { useState, useRef } from 'react';
import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { Download } from 'lucide-react';
import { api } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import ThaiDatePicker from '@/components/ThaiDatePicker';
import dayjs from 'dayjs';
import { exportElementToPdf } from '@/lib/export-pdf';
import { exportToCsv } from '@/lib/export-csv';

const typeLabels: Record<string, string> = {
  DEATH_BENEFIT: 'เงินสงเคราะห์ศพ',
  OPERATING_EXPENSE: 'ค่าใช้จ่ายดำเนินงาน',
  BANK_FEE: 'ค่าธรรมเนียมธนาคาร',
  OTHER: 'อื่นๆ',
};

export default function DisbursementLedgerReportPage() {
  const { selectedSchoolId, selectedYear } = useAuthStore();
  const [range, setRange] = useState({
    startDate: `${selectedYear}-01-01`,
    endDate: `${selectedYear}-12-31`,
  });
  const [type, setType] = useState('');
  const contentRef = useRef<HTMLDivElement>(null);

  const fmt = (n: number) =>
    new Intl.NumberFormat('th-TH', { style: 'currency', currency: 'THB' }).format(n);
  const fmtDate = (d: string) => dayjs(d).format('DD/MM/') + (dayjs(d).year() + 543);

  const { data, isLoading } = useQuery({
    queryKey: ['disbursement-ledger', range, type, selectedSchoolId],
    queryFn: async () => {
      const params = new URLSearchParams(range);
      if (type) params.append('type', type);
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      const res = await api.get(`/reports/disbursement-ledger?${params}`);
      return res.data;
    },
  });

  const handleExportPdf = async () => {
    if (contentRef.current) {
      await exportElementToPdf(contentRef.current, `รายงานการจ่าย-${range.startDate}.pdf`);
    }
  };

  const handleExportCsv = () => {
    if (!data) return;
    const rows: any[][] = [['เลขที่', 'วันที่', 'ประเภท', 'โรงเรียน', 'จำนวนเงิน']];
    data.payments.forEach((p: any) =>
      rows.push([p.voucherNo, fmtDate(p.date), typeLabels[p.type] || p.type, p.school || '-', p.amount]),
    );
    exportToCsv(`รายงานการจ่าย-${range.startDate}`, rows);
  };

  return (
    <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-6">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-display font-bold text-slate-900">รายงานการจ่าย</h1>
          <p className="text-slate-500 mt-1">รายการใบสำคัญจ่ายในช่วงเวลาที่กำหนด</p>
        </div>
        <div className="flex flex-wrap items-center gap-2">
          <button onClick={handleExportPdf} className="btn-secondary flex items-center gap-2">
            <Download size={18} /> PDF
          </button>
          <button onClick={handleExportCsv} className="btn-secondary flex items-center gap-2">
            <Download size={18} /> CSV
          </button>
        </div>
      </div>

      <div className="card p-4 flex flex-wrap items-center gap-4">
        <ThaiDatePicker
          value={range.startDate ? dayjs(range.startDate) : null}
          onChange={(d) => d && setRange({ ...range, startDate: d.format('YYYY-MM-DD') })}
          placeholder="วันเริ่มต้น"
          style={{ width: 160 }}
        />
        <span className="text-slate-400">ถึง</span>
        <ThaiDatePicker
          value={range.endDate ? dayjs(range.endDate) : null}
          onChange={(d) => d && setRange({ ...range, endDate: d.format('YYYY-MM-DD') })}
          placeholder="วันสิ้นสุด"
          style={{ width: 160 }}
        />
        <select value={type} onChange={(e) => setType(e.target.value)} className="input w-auto">
          <option value="">ทุกประเภท</option>
          {Object.entries(typeLabels).map(([value, label]) => (
            <option key={value} value={value}>
              {label}
            </option>
          ))}
        </select>
      </div>

      {isLoading ? (
        <div className="flex justify-center py-20">
          <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : data ? (
        <div ref={contentRef} className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="card p-4">
              <p className="text-sm text-slate-500">จำนวนรายการ</p>
              <p className="text-xl font-bold text-slate-900">{data.summary.count} รายการ</p>
            </div>
            <div className="card p-4">
              <p className="text-sm text-slate-500">ยอดรวม</p>
              <p className="text-xl font-bold text-red-700">{fmt(data.summary.totalAmount)}</p>
            </div>
          </div>

          <div className="card p-5">
            <h3 className="font-semibold text-slate-900 mb-4">สรุปตามประเภท</h3>
            <div className="space-y-2">
              {data.summary.byType.map((t: any) => (
                <div key={t.type} className="flex justify-between items-center">
                  <span className="text-slate-600">{typeLabels[t.type] || t.type}</span>
                  <div className="text-right">
                    <span className="font-semibold text-red-600">{fmt(t.amount)}</span>
                    <span className="text-sm text-slate-400 ml-2">({t.count} รายการ)</span>
                  </div>
                </div>
              ))}
            </div>
          </div>

          <div className="card overflow-hidden">
            <div className="px-4 py-3 bg-slate-50 border-b border-slate-200">
              <h3 className="font-semibold text-slate-900">รายการใบสำคัญจ่าย ({data.payments.length})</h3>
            </div>
            {data.payments.length === 0 ? (
              <div className="text-center py-10 text-slate-500">ไม่มีข้อมูลในช่วงเวลานี้</div>
            ) : (
              <div className="table-container border-0">
                <table className="table">
                  <thead>
                    <tr>
                      <th>เลขที่</th>
                      <th>วันที่</th>
                      <th>ประเภท</th>
                      <th>โรงเรียน</th>
                      <th className="text-right">จำนวนเงิน</th>
                    </tr>
                  </thead>
                  <tbody>
                    {data.payments.map((p: any) => (
                      <tr key={p.id}>
                        <td className="font-mono text-sm">{p.voucherNo}</td>
                        <td>{fmtDate(p.date)}</td>
                        <td>{typeLabels[p.type] || p.type}</td>
                        <td className="text-slate-500">{p.school || '-'}</td>
                        <td className="text-right font-medium">{fmt(p.amount)}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        </div>
      ) : null}
    </motion.div>
  );
}
