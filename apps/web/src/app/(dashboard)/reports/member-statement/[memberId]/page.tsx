'use client';

import { useRef } from 'react';
import { useParams } from 'next/navigation';
import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { ArrowLeft, Download } from 'lucide-react';
import Link from 'next/link';
import { api } from '@/lib/api';
import dayjs from 'dayjs';
import { exportElementToPdf } from '@/lib/export-pdf';
import { exportToCsv } from '@/lib/export-csv';

export default function MemberStatementPage() {
  const params = useParams();
  const memberId = params.memberId as string;
  const contentRef = useRef<HTMLDivElement>(null);

  const fmt = (n: number) =>
    new Intl.NumberFormat('th-TH', { style: 'currency', currency: 'THB' }).format(n);
  const fmtDate = (d: string) => dayjs(d).format('DD/MM/') + (dayjs(d).year() + 543);
  const fmtDescription = (r: any) =>
    r.periodMonth && r.periodYear ? `${r.description} ${r.periodMonth}/${r.periodYear + 543}` : r.description;

  const { data, isLoading } = useQuery({
    queryKey: ['member-statement', memberId],
    queryFn: async () => {
      const res = await api.get(`/reports/member-statement/${memberId}`);
      return res.data;
    },
  });

  const handleExportPdf = async () => {
    if (contentRef.current) {
      await exportElementToPdf(contentRef.current, `สมุดบัญชี-${data?.member?.memberNo}.pdf`);
    }
  };

  const handleExportCsv = () => {
    if (!data) return;
    const rows: any[][] = [['วันที่', 'รายการ', 'จ่าย', 'รับ', 'ยอดสะสม']];
    data.statement.forEach((r: any) =>
      rows.push([fmtDate(r.date), fmtDescription(r), r.paid, r.received, r.runningTotal]),
    );
    exportToCsv(`สมุดบัญชี-${data.member.memberNo}`, rows);
  };

  if (isLoading) {
    return (
      <div className="flex justify-center py-20">
        <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  if (!data) {
    return <div className="text-center py-20 text-slate-500">ไม่พบข้อมูลสมาชิก</div>;
  }

  return (
    <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-6">
      <div className="flex items-center gap-4">
        <Link href={`/members/${memberId}/profile`} className="p-2 hover:bg-slate-100 rounded-lg">
          <ArrowLeft size={20} />
        </Link>
        <div className="flex-1">
          <h1 className="text-2xl font-display font-bold text-slate-900">สมุดบัญชีสมาชิก</h1>
          <p className="text-slate-500 mt-1">
            {data.member.fullName} • เลขสมาชิก {data.member.memberNo} • {data.member.school}
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
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="card p-4">
            <p className="text-sm text-slate-500">ยอดชำระสะสม</p>
            <p className="text-xl font-bold text-emerald-700">{fmt(data.summary.totalPaid)}</p>
          </div>
          <div className="card p-4">
            <p className="text-sm text-slate-500">เงินสงเคราะห์ที่ได้รับ</p>
            <p className="text-xl font-bold text-primary-700">{fmt(data.summary.totalReceived)}</p>
          </div>
        </div>

        <div className="card overflow-hidden">
          <div className="px-4 py-3 bg-slate-50 border-b border-slate-200">
            <h3 className="font-semibold text-slate-900">ประวัติรายการ ({data.statement.length})</h3>
          </div>
          {data.statement.length === 0 ? (
            <div className="text-center py-10 text-slate-500">ยังไม่มีรายการ</div>
          ) : (
            <div className="table-container border-0">
              <table className="table">
                <thead>
                  <tr>
                    <th>วันที่</th>
                    <th>รายการ</th>
                    <th className="text-right">จ่าย</th>
                    <th className="text-right">รับ</th>
                    <th className="text-right">ยอดสะสม</th>
                  </tr>
                </thead>
                <tbody>
                  {data.statement.map((r: any, i: number) => (
                    <tr key={i}>
                      <td>{fmtDate(r.date)}</td>
                      <td>{fmtDescription(r)}</td>
                      <td className="text-right">{r.paid > 0 ? fmt(r.paid) : '-'}</td>
                      <td className="text-right text-primary-600">{r.received > 0 ? fmt(r.received) : '-'}</td>
                      <td className="text-right font-medium">{fmt(r.runningTotal)}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>
    </motion.div>
  );
}
