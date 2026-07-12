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

type DateField = 'coverage' | 'applied' | 'recorded';

const DATE_FIELD_LABEL: Record<DateField, string> = {
  coverage: 'วันที่คุ้มครอง',
  applied: 'วันที่สมัคร',
  recorded: 'วันที่บันทึกข้อมูล',
};

const DATE_FIELD_KEY: Record<DateField, string> = {
  coverage: 'joinDate',
  applied: 'applicationSubmittedAt',
  recorded: 'createdAt',
};

export default function MemberRegistryReportPage() {
  const { selectedSchoolId, selectedYear } = useAuthStore();
  const [dateField, setDateField] = useState<DateField>('coverage');
  const [range, setRange] = useState({
    startDate: `${selectedYear}-01-01`,
    endDate: `${selectedYear}-12-31`,
  });
  const contentRef = useRef<HTMLDivElement>(null);

  const { data, isLoading } = useQuery({
    queryKey: ['member-registry-report', dateField, range, selectedSchoolId],
    queryFn: async () => {
      const params = new URLSearchParams({ dateField, ...range });
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      const res = await api.get(`/reports/member-registry?${params}`);
      return res.data;
    },
  });

  const fmtDate = (d?: string) => (d ? dayjs(d).format('DD/MM/') + (dayjs(d).year() + 543) : '-');

  const handleExportPdf = async () => {
    if (contentRef.current) {
      await exportElementToPdf(contentRef.current, `ทะเบียนสมาชิก-${range.startDate}.pdf`);
    }
  };

  const handleExportCsv = () => {
    if (!data) return;
    const rows: any[][] = [
      ['โรงเรียน', 'เลขฌาปนกิจ', 'เลขทะเบียนสมาคม', 'ชื่อ-นามสกุล', 'วันเกิด', DATE_FIELD_LABEL[dateField]],
    ];
    data.bySchool.forEach((group: any) =>
      group.members.forEach((m: any) =>
        rows.push([
          group.school.name,
          m.memberNo,
          m.associationMemberNo || '-',
          m.fullName,
          fmtDate(m.birthDate),
          fmtDate(m[DATE_FIELD_KEY[dateField]]),
        ]),
      ),
    );
    exportToCsv(`ทะเบียนสมาชิก-${range.startDate}`, rows);
  };

  return (
    <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-6">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-display font-bold text-slate-900">ทะเบียนสมาชิก</h1>
          <p className="text-slate-500 mt-1">รายชื่อสมาชิกฌาปนกิจ กรองตามช่วงวันที่ที่เลือก</p>
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
        <div className="flex items-center gap-2">
          <span className="text-sm text-slate-600">กรองตาม:</span>
          <select
            value={dateField}
            onChange={(e) => setDateField(e.target.value as DateField)}
            className="input w-auto"
          >
            {(Object.keys(DATE_FIELD_LABEL) as DateField[]).map((f) => (
              <option key={f} value={f}>
                {DATE_FIELD_LABEL[f]}
              </option>
            ))}
          </select>
        </div>
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
      </div>

      {isLoading ? (
        <div className="flex justify-center py-20">
          <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : data ? (
        <div ref={contentRef} className="space-y-6">
          <div className="card p-4">
            <p className="text-sm text-slate-500">จำนวนสมาชิกทั้งหมด</p>
            <p className="text-xl font-bold text-slate-900">{data.summary.total} คน</p>
          </div>

          {data.bySchool.map((group: any) => (
            <div key={group.school.id} className="card overflow-hidden">
              <div className="px-4 py-3 bg-slate-50 border-b border-slate-200">
                <h3 className="font-semibold text-slate-900">
                  {group.school.name} ({group.members.length})
                </h3>
              </div>
              <div className="table-container border-0">
                <table className="table">
                  <thead>
                    <tr>
                      <th>เลขฌาปนกิจ</th>
                      <th>เลขทะเบียนสมาคม</th>
                      <th>ชื่อ-นามสกุล</th>
                      <th>วันเกิด</th>
                      <th>{DATE_FIELD_LABEL[dateField]}</th>
                    </tr>
                  </thead>
                  <tbody>
                    {group.members.map((m: any) => (
                      <tr key={m.id}>
                        <td className="font-mono text-sm">{m.memberNo}</td>
                        <td className="font-mono text-sm">{m.associationMemberNo || '-'}</td>
                        <td className="font-medium">{m.fullName}</td>
                        <td>{fmtDate(m.birthDate)}</td>
                        <td>{fmtDate(m[DATE_FIELD_KEY[dateField]])}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          ))}
        </div>
      ) : null}
    </motion.div>
  );
}
