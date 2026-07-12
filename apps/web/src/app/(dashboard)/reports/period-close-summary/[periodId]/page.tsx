'use client';

import { useRef } from 'react';
import { useParams } from 'next/navigation';
import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { ArrowLeft, Download } from 'lucide-react';
import Link from 'next/link';
import { api } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import { exportElementToPdf } from '@/lib/export-pdf';
import { exportToCsv } from '@/lib/export-csv';

const monthNames = [
  'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
  'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม',
];

export default function PeriodCloseSummaryPage() {
  const params = useParams();
  const periodId = params.periodId as string;
  const { selectedSchoolId } = useAuthStore();
  const contentRef = useRef<HTMLDivElement>(null);

  const fmt = (n: number) =>
    new Intl.NumberFormat('th-TH', { style: 'currency', currency: 'THB' }).format(n);

  const { data, isLoading, error } = useQuery({
    queryKey: ['period-close-summary', periodId, selectedSchoolId],
    queryFn: async () => {
      const params = new URLSearchParams();
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      const res = await api.get(`/reports/period-close-summary/${periodId}?${params}`);
      return res.data;
    },
    retry: false,
  });

  const handleExportPdf = async () => {
    if (contentRef.current) {
      await exportElementToPdf(contentRef.current, `สรุปปิดงวด-${periodId}.pdf`);
    }
  };

  const handleExportCsv = () => {
    if (!data) return;
    const rows: any[][] = [['เลขสมาชิก', 'ชื่อ-นามสกุล', 'โรงเรียน', 'ยอดที่ต้องชำระ', 'ยอดที่ชำระแล้ว', 'ค้างชำระ']];
    data.contributions.forEach((c: any) =>
      rows.push([c.memberNo, c.fullName, c.school, c.totalAmount, c.paidAmount, c.isArrears ? 'ค้างชำระ' : '-']),
    );
    exportToCsv(`สรุปปิดงวด-${periodId}`, rows);
  };

  if (isLoading) {
    return (
      <div className="flex justify-center py-20">
        <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  if ((error as any)?.response?.status === 403) {
    return (
      <div className="text-center py-20 text-slate-500">
        คุณไม่มีสิทธิ์เข้าถึงรายงานสรุปปิดงวดนี้
      </div>
    );
  }

  if (!data) {
    return <div className="text-center py-20 text-slate-500">ไม่พบข้อมูลงวด</div>;
  }

  return (
    <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-6">
      <div className="flex items-center gap-4">
        <Link href={`/contributions/periods/${periodId}`} className="p-2 hover:bg-slate-100 rounded-lg">
          <ArrowLeft size={20} />
        </Link>
        <div className="flex-1">
          <h1 className="text-2xl font-display font-bold text-slate-900">สรุปปิดงวด</h1>
          <p className="text-slate-500 mt-1">
            งวด {monthNames[data.period.month - 1]} {data.period.year + 543}
          </p>
        </div>
        <div className="flex items-center gap-2">
          <button onClick={handleExportPdf} className="btn-secondary flex items-center gap-2">
            <Download size={18} /> PDF
          </button>
          <button onClick={handleExportCsv} className="btn-secondary flex items-center gap-2">
            <Download size={18} /> CSV
          </button>
        </div>
      </div>

      <div ref={contentRef} className="space-y-6">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="card p-4">
            <p className="text-sm text-slate-500">จำนวนสมาชิก</p>
            <p className="text-xl font-bold text-slate-900">{data.summary.memberCount} คน</p>
          </div>
          <div className="card p-4">
            <p className="text-sm text-slate-500">ยอดที่ต้องชำระรวม</p>
            <p className="text-xl font-bold text-slate-900">{fmt(data.summary.totalDue)}</p>
          </div>
          <div className="card p-4">
            <p className="text-sm text-slate-500">ยอดที่ชำระแล้ว</p>
            <p className="text-xl font-bold text-emerald-700">{fmt(data.summary.totalPaid)}</p>
          </div>
        </div>

        <div className="card p-5">
          <h3 className="font-semibold text-slate-900 mb-4">สรุปตามโรงเรียน</h3>
          <div className="table-container border-0">
            <table className="table">
              <thead>
                <tr>
                  <th>โรงเรียน</th>
                  <th className="text-right">จำนวนสมาชิก</th>
                  <th className="text-right">ยอดที่ต้องชำระ</th>
                  <th className="text-right">ยอดที่ชำระแล้ว</th>
                </tr>
              </thead>
              <tbody>
                {data.bySchool.map((s: any) => (
                  <tr key={s.school.id}>
                    <td className="font-medium">{s.school.name}</td>
                    <td className="text-right">{s.memberCount}</td>
                    <td className="text-right">{fmt(s.totalDue)}</td>
                    <td className="text-right">{fmt(s.totalPaid)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        <div className="card overflow-hidden">
          <div className="px-4 py-3 bg-slate-50 border-b border-slate-200">
            <h3 className="font-semibold text-slate-900">รายบุคคล ({data.contributions.length})</h3>
          </div>
          <div className="table-container border-0">
            <table className="table">
              <thead>
                <tr>
                  <th>เลขสมาชิก</th>
                  <th>ชื่อ-นามสกุล</th>
                  <th>โรงเรียน</th>
                  <th className="text-right">ยอดที่ต้องชำระ</th>
                  <th className="text-right">ยอดที่ชำระแล้ว</th>
                  <th>สถานะ</th>
                </tr>
              </thead>
              <tbody>
                {data.contributions.map((c: any) => (
                  <tr key={c.id}>
                    <td className="font-mono text-sm">{c.memberNo}</td>
                    <td className="font-medium">{c.fullName}</td>
                    <td className="text-slate-500">{c.school}</td>
                    <td className="text-right">{fmt(c.totalAmount)}</td>
                    <td className="text-right">{fmt(c.paidAmount)}</td>
                    <td>
                      {c.isArrears ? (
                        <span className="badge-warning">ค้างชำระ</span>
                      ) : (
                        <span className="badge-success">ชำระแล้ว</span>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </motion.div>
  );
}
