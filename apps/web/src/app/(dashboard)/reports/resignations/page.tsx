'use client';

import { useState, useRef } from 'react';
import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { UserMinus, Download } from 'lucide-react';
import { api } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import ThaiDatePicker from '@/components/ThaiDatePicker';
import dayjs from 'dayjs';
import { exportElementToPdf } from '@/lib/export-pdf';
import { exportToCsv } from '@/lib/export-csv';

const REASON_LABEL: Record<string, string> = {
  DECEASED: 'เสียชีวิต',
  RETIRED: 'เกษียณ',
  RESIGNED: 'ลาออก',
  ARREARS_TERMINATED: 'ค้างชำระเกินกำหนด',
  MANUAL: 'อื่น ๆ',
  'ไม่ระบุ': 'ไม่ระบุ',
};

export default function ResignationReportPage() {
  const { selectedSchoolId, selectedYear } = useAuthStore();
  const [range, setRange] = useState({
    startDate: `${selectedYear}-01-01`,
    endDate: `${selectedYear}-12-31`,
  });
  const contentRef = useRef<HTMLDivElement>(null);

  const { data, isLoading } = useQuery({
    queryKey: ['resignation-report', range, selectedSchoolId],
    queryFn: async () => {
      const params = new URLSearchParams(range);
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      const res = await api.get(`/reports/resignations?${params}`);
      return res.data;
    },
  });

  const fmtDate = (d: string) => dayjs(d).format('DD/MM/') + (dayjs(d).year() + 543);

  const handleExportPdf = async () => {
    if (contentRef.current) {
      await exportElementToPdf(contentRef.current, `รายงานการลาออก-${range.startDate}.pdf`);
    }
  };

  const handleExportCsv = () => {
    if (!data) return;
    const rows: any[][] = [
      ['เลขฌาปนกิจ', 'เลขทะเบียนสมาคม', 'ชื่อ-นามสกุล', 'โรงเรียน', 'วันที่ลาออก', 'สาเหตุ'],
    ];
    data.resignations.forEach((r: any) =>
      rows.push([
        r.memberNo,
        r.associationMemberNo || '-',
        r.fullName,
        r.school,
        fmtDate(r.resignDate),
        REASON_LABEL[r.membershipEndReason] || r.membershipEndReason || '-',
      ]),
    );
    exportToCsv(`รายงานการลาออก-${range.startDate}`, rows);
  };

  return (
    <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-6">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-display font-bold text-slate-900">รายงานการลาออก</h1>
          <p className="text-slate-500 mt-1">รายชื่อสมาชิกที่ลาออกในช่วงเวลาที่กำหนด</p>
        </div>
        <div className="flex flex-wrap items-center gap-2">
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
          <button onClick={handleExportPdf} className="btn-secondary flex items-center gap-2">
            <Download size={18} /> PDF
          </button>
          <button onClick={handleExportCsv} className="btn-secondary flex items-center gap-2">
            <Download size={18} /> CSV
          </button>
        </div>
      </div>

      {isLoading ? (
        <div className="flex justify-center py-20">
          <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : data ? (
        <div ref={contentRef} className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="card p-4 flex items-center gap-3">
              <UserMinus className="text-red-600" />
              <div>
                <p className="text-sm text-slate-500">ลาออกทั้งหมด</p>
                <p className="text-xl font-bold text-slate-900">{data.summary.totalResigned} คน</p>
              </div>
            </div>
            {data.summary.byReason.map((r: any) => (
              <div key={r.reason} className="card p-4">
                <p className="text-sm text-slate-500">{REASON_LABEL[r.reason] || r.reason}</p>
                <p className="text-xl font-bold text-slate-900">{r.count} คน</p>
              </div>
            ))}
          </div>

          <div className="card overflow-hidden">
            <div className="px-4 py-3 bg-slate-50 border-b border-slate-200">
              <h3 className="font-semibold text-slate-900">
                รายชื่อผู้ลาออก ({data.resignations.length})
              </h3>
            </div>
            {data.resignations.length === 0 ? (
              <div className="text-center py-10 text-slate-500">ไม่มีข้อมูลในช่วงเวลานี้</div>
            ) : (
              <div className="table-container border-0">
                <table className="table">
                  <thead>
                    <tr>
                      <th>เลขฌาปนกิจ</th>
                      <th>เลขทะเบียนสมาคม</th>
                      <th>ชื่อ-นามสกุล</th>
                      <th>โรงเรียน</th>
                      <th>วันที่ลาออก</th>
                      <th>สาเหตุ</th>
                    </tr>
                  </thead>
                  <tbody>
                    {data.resignations.map((r: any) => (
                      <tr key={r.id}>
                        <td className="font-mono text-sm">{r.memberNo}</td>
                        <td className="font-mono text-sm">{r.associationMemberNo || '-'}</td>
                        <td className="font-medium">{r.fullName}</td>
                        <td className="text-slate-500">{r.school}</td>
                        <td>{fmtDate(r.resignDate)}</td>
                        <td>{REASON_LABEL[r.membershipEndReason] || r.membershipEndReason || '-'}</td>
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
