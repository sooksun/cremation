'use client';

import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { AlertCircle, Phone, Building2, Calendar, DollarSign, Download } from 'lucide-react';
import { api } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import { exportElementToPdf } from '@/lib/export-pdf';
import { exportToCsv } from '@/lib/export-csv';
import { useRef } from 'react';
import dayjs from 'dayjs';

interface Arrears {
  id: string;
  welfareAmount: number;
  serviceAmount: number;
  totalAmount: number;
  member: {
    id: string;
    memberNo: string;
    firstName: string;
    lastName: string;
    phone?: string;
    group?: { name: string };
  };
  period: {
    year: number;
    month: number;
  };
  school: {
    id: string;
    name: string;
  };
}

const monthNames = [
  'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
  'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
];

export default function ArrearsPage() {
  const { selectedSchoolId } = useAuthStore();

  const { data: arrears, isLoading } = useQuery<Arrears[]>({
    queryKey: ['arrears', selectedSchoolId],
    queryFn: async () => {
      const params = selectedSchoolId ? `?schoolId=${selectedSchoolId}` : '';
      const response = await api.get(`/contributions/arrears${params}`);
      return response.data;
    },
  });

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('th-TH', {
      style: 'currency',
      currency: 'THB',
      minimumFractionDigits: 0,
    }).format(amount);
  };

  const totalArrears = arrears?.reduce((sum, a) => sum + Number(a.totalAmount), 0) || 0;

  const contentRef = useRef<HTMLDivElement>(null);

  const handleExportPdf = async () => {
    if (contentRef.current) {
      await exportElementToPdf(contentRef.current, `arrears-report.pdf`);
    }
  };

  const handleExportCsv = () => {
    if (!arrears) return;
    const rows = [
      ['เลขสมาชิก', 'ชื่อ-สกุล', 'โรงเรียน', 'กลุ่ม', 'งวด', 'ยอดค้าง', 'โทร'],
      ...arrears.map(a => [
        a.member.memberNo,
        `${a.member.firstName} ${a.member.lastName}`,
        a.school.name,
        a.member.group?.name || '-',
        `${monthNames[a.period.month-1]} ${a.period.year + 543}`,
        a.totalAmount,
        a.member.phone || '-'
      ])
    ];
    exportToCsv(`arrears-${dayjs().format('YYYY-MM-DD')}`, rows);
  };

  // Group by school
  const groupedBySchool = arrears?.reduce((acc, item) => {
    if (!acc[item.school.id]) {
      acc[item.school.id] = {
        school: item.school,
        items: [],
        total: 0,
      };
    }
    acc[item.school.id].items.push(item);
    acc[item.school.id].total += Number(item.totalAmount);
    return acc;
  }, {} as Record<string, { school: { id: string; name: string }; items: Arrears[]; total: number }>);

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      className="space-y-6"
      ref={contentRef}
    >
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-display font-bold text-slate-900">
            รายการค้างชำระ
          </h1>
          <p className="text-slate-500 mt-1">
            รายการเงินสงเคราะห์ที่ยังไม่ได้ชำระ
          </p>
        </div>
        <div className="flex gap-2">
          <button onClick={handleExportPdf} className="btn-secondary flex items-center gap-2">
            <Download size={18} /> PDF
          </button>
          <button onClick={handleExportCsv} className="btn-secondary flex items-center gap-2">
            <Download size={18} /> CSV
          </button>
        </div>
      </div>

      {/* Summary */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div className="stat-card">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 bg-amber-100 rounded-xl flex items-center justify-center">
              <AlertCircle className="w-6 h-6 text-amber-600" />
            </div>
            <div>
              <p className="stat-label">จำนวนรายการ</p>
              <p className="text-2xl font-bold text-slate-900">{arrears?.length || 0}</p>
            </div>
          </div>
        </div>
        <div className="stat-card">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 bg-red-100 rounded-xl flex items-center justify-center">
              <DollarSign className="w-6 h-6 text-red-600" />
            </div>
            <div>
              <p className="stat-label">ยอดค้างชำระรวม</p>
              <p className="text-2xl font-bold text-red-600">{formatCurrency(totalArrears)}</p>
            </div>
          </div>
        </div>
        <div className="stat-card">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 bg-sky-100 rounded-xl flex items-center justify-center">
              <Building2 className="w-6 h-6 text-sky-600" />
            </div>
            <div>
              <p className="stat-label">จำนวนโรงเรียน</p>
              <p className="text-2xl font-bold text-slate-900">
                {Object.keys(groupedBySchool || {}).length}
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Arrears List */}
      {isLoading ? (
        <div className="flex items-center justify-center py-20">
          <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : arrears?.length === 0 ? (
        <div className="card text-center py-20 text-slate-500">
          <AlertCircle className="w-16 h-16 mx-auto text-slate-300 mb-4" />
          <p className="text-lg font-medium">ไม่มีรายการค้างชำระ</p>
          <p className="text-sm mt-1">สมาชิกทุกคนชำระเงินครบถ้วนแล้ว</p>
        </div>
      ) : (
        <div className="space-y-6">
          {Object.values(groupedBySchool || {}).map(({ school, items, total }) => (
            <div key={school.id} className="card overflow-hidden">
              <div className="px-4 py-3 bg-slate-50 border-b border-slate-200 flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <Building2 className="w-5 h-5 text-slate-400" />
                  <h3 className="font-semibold text-slate-900">{school.name}</h3>
                  <span className="badge-warning">{items.length} รายการ</span>
                </div>
                <span className="font-semibold text-red-600">{formatCurrency(total)}</span>
              </div>
              <div className="table-container border-0">
                <table className="table">
                  <thead>
                    <tr>
                      <th>เลขสมาชิก</th>
                      <th>ชื่อ-นามสกุล</th>
                      <th>กลุ่ม</th>
                      <th>งวด</th>
                      <th>โทรศัพท์</th>
                      <th className="text-right">ยอดค้างชำระ</th>
                    </tr>
                  </thead>
                  <tbody>
                    {items.map((item) => (
                      <tr key={item.id}>
                        <td className="font-mono text-sm">{item.member.memberNo}</td>
                        <td className="font-medium">
                          {item.member.firstName} {item.member.lastName}
                        </td>
                        <td className="text-slate-500">{item.member.group?.name || '-'}</td>
                        <td>
                          <span className="flex items-center gap-1 text-sm">
                            <Calendar size={14} className="text-slate-400" />
                            {monthNames[item.period.month - 1]} {item.period.year + 543}
                          </span>
                        </td>
                        <td>
                          {item.member.phone ? (
                            <a
                              href={`tel:${item.member.phone}`}
                              className="flex items-center gap-1 text-primary-600 hover:text-primary-700"
                            >
                              <Phone size={14} />
                              {item.member.phone}
                            </a>
                          ) : (
                            <span className="text-slate-400">-</span>
                          )}
                        </td>
                        <td className="text-right font-semibold text-red-600">
                          {formatCurrency(item.totalAmount)}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          ))}
        </div>
      )}
    </motion.div>
  );
}


