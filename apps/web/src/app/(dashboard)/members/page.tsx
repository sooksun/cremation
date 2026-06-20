'use client';

import { useState, useRef } from 'react';
import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import {
  Plus,
  Search,
  Download,
  ChevronLeft,
  ChevronRight,
  Eye,
  Edit,
  UserX,
  BarChart3,
} from 'lucide-react';
import Link from 'next/link';
import { api, type Member, membershipClassLabels } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import { showSuccess, showError } from '@/lib/toast';

const statusConfig = {
  ACTIVE: { label: 'ปกติ', class: 'badge-success' },
  RESIGNED: { label: 'ลาออก', class: 'badge-neutral' },
  DECEASED: { label: 'เสียชีวิต', class: 'badge-danger' },
  ARREARS: { label: 'ค้างชำระ', class: 'badge-warning' },
  SUSPENDED: { label: 'พักสมาชิก', class: 'badge-info' },
};

interface MemberListResponse {
  data: Member[];
  meta: {
    total: number;
    page: number;
    limit: number;
    totalPages: number;
  };
}

export default function MembersPage() {
  const { selectedSchoolId } = useAuthStore();
  const [page, setPage] = useState(1);
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState<string>('');
  const [classFilter, setClassFilter] = useState<string>('');
  const [importing, setImporting] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleExport = async () => {
    try {
      const params = selectedSchoolId ? `?schoolId=${selectedSchoolId}` : '';
      const response = await api.get(`/members/export/csv${params}`, { responseType: 'blob' });
      const url = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement('a');
      link.href = url;
      link.download = 'members.csv';
      link.click();
      window.URL.revokeObjectURL(url);
      showSuccess('ส่งออก CSV สำเร็จ');
    } catch {
      showError('ส่งออกไม่สำเร็จ');
    }
  };

  const parseCsvRows = (text: string) => {
    const lines = text.replace(/^\uFEFF/, '').trim().split(/\r?\n/);
    const headers = lines[0].split(',').map((h) => h.replace(/^"|"$/g, '').trim());
    return lines.slice(1).map((line) => {
      const values = line.match(/("([^"]|"")*"|[^,]*)/g)?.map((v) =>
        v.replace(/^"|"$/g, '').replace(/""/g, '"').trim(),
      ) || [];
      const row: Record<string, string> = {};
      headers.forEach((h, i) => { row[h] = values[i] || ''; });
      return row;
    });
  };

  const handleImport = async (file: File) => {
    setImporting(true);
    try {
      const text = await file.text();
      const parsed = parseCsvRows(text);
      const rows = parsed.map((r) => ({
        memberNo: r.memberNo,
        firstName: r.firstName,
        lastName: r.lastName,
        schoolCode: r.schoolCode,
        memberTypeCode: r.memberTypeCode,
        groupCode: r.groupCode || undefined,
        status: r.status || undefined,
        joinDate: r.joinDate || undefined,
        phone: r.phone || undefined,
        idCardNo: r.idCardNo || undefined,
      }));
      const response = await api.post('/members/import/csv', { rows });
      const r = response.data;
      showSuccess(`นำเข้าสำเร็จ: สร้าง ${r.created}, อัปเดต ${r.updated}, ข้าม ${r.skipped}`);
      if (r.errors?.length) showError(r.errors.slice(0, 3).join('; '));
    } catch (e: any) {
      showError(e.response?.data?.message || 'นำเข้าไม่สำเร็จ');
    } finally {
      setImporting(false);
      if (fileInputRef.current) fileInputRef.current.value = '';
    }
  };

  const { data, isLoading } = useQuery<MemberListResponse>({
    queryKey: ['members', selectedSchoolId, page, search, statusFilter, classFilter],
    queryFn: async () => {
      const params = new URLSearchParams();
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      if (search) params.append('search', search);
      if (statusFilter) params.append('status', statusFilter);
      if (classFilter) params.append('membershipClass', classFilter);
      params.append('page', page.toString());
      params.append('limit', '20');
      const response = await api.get(`/members?${params}`);
      return response.data;
    },
  });

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      className="space-y-6"
    >
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-display font-bold text-slate-900">
            ทะเบียนสมาชิก
          </h1>
          <p className="text-slate-500 mt-1">
            จัดการสมาชิกฌาปนกิจ — ระบบสร้างทะเบียนสมาชิกสมาคมให้อัตโนมัติเมื่อเพิ่มสมาชิกใหม่
          </p>
        </div>
        <Link href="/members/new" className="btn-primary">
          <Plus size={20} />
          เพิ่มสมาชิก
        </Link>
      </div>

      {/* Filters */}
      <div className="card p-4">
        <div className="flex flex-col md:flex-row gap-4">
          <div className="flex-1 relative">
            <Search
              size={20}
              className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400"
            />
            <input
              type="text"
              placeholder="ค้นหาชื่อ, เลขสมาชิก, เลขบัตรประชาชน..."
              className="input pl-10"
              value={search}
              onChange={(e) => {
                setSearch(e.target.value);
                setPage(1);
              }}
            />
          </div>
          <select
            className="input w-full md:w-48"
            value={statusFilter}
            onChange={(e) => {
              setStatusFilter(e.target.value);
              setPage(1);
            }}
          >
            <option value="">ทุกสถานะ</option>
            <option value="ACTIVE">ปกติ</option>
            <option value="ARREARS">ค้างชำระ</option>
            <option value="RESIGNED">ลาออก</option>
            <option value="DECEASED">เสียชีวิต</option>
            <option value="SUSPENDED">พักสมาชิก</option>
          </select>
          <select
            className="input w-full md:w-48"
            value={classFilter}
            onChange={(e) => {
              setClassFilter(e.target.value);
              setPage(1);
            }}
          >
            <option value="">ทุกชั้นสมาชิก</option>
            <option value="ORDINARY">สมาชิกสามัญ</option>
            <option value="CONTRIBUTORY">สมาชิกสมทบ</option>
          </select>
          <button type="button" onClick={handleExport} className="btn-secondary">
            <Download size={20} />
            ส่งออก CSV
          </button>
          <input
            ref={fileInputRef}
            type="file"
            accept=".csv"
            className="hidden"
            onChange={(e) => e.target.files?.[0] && handleImport(e.target.files[0])}
          />
          <button
            type="button"
            onClick={() => fileInputRef.current?.click()}
            disabled={importing}
            className="btn-secondary"
          >
            {importing ? 'กำลังนำเข้า...' : 'นำเข้า CSV'}
          </button>
        </div>
      </div>

      {/* Table */}
      <div className="card overflow-hidden">
        {isLoading ? (
          <div className="flex items-center justify-center py-20">
            <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
          </div>
        ) : data?.data.length === 0 ? (
          <div className="text-center py-20 text-slate-500">
            <UserX className="w-16 h-16 mx-auto text-slate-300 mb-4" />
            <p className="text-lg font-medium">ไม่พบข้อมูลสมาชิก</p>
            <p className="text-sm mt-1">เพิ่มสมาชิกใหม่ — ระบบจะสร้างทะเบียนสมาชิกสมาคมให้อัตโนมัติ</p>
            <Link href="/members/new" className="btn-primary mt-4 inline-flex">
              <Plus size={18} />
              เพิ่มสมาชิก
            </Link>
          </div>
        ) : (
          <>
            <div className="table-container border-0">
              <table className="table">
                <thead>
                  <tr>
                    <th>เลขสมาชิก</th>
                    <th>ชื่อ-นามสกุล</th>
                    <th>โรงเรียน</th>
                    <th>ประเภท</th>
                    <th>ชั้นสมาชิก</th>
                    <th>กลุ่ม</th>
                    <th>สถานะ</th>
                    <th className="text-right">จัดการ</th>
                  </tr>
                </thead>
                <tbody>
                  {data?.data.map((member) => (
                    <tr key={member.id}>
                      <td className="font-mono text-sm font-medium">
                        {member.memberNo}
                      </td>
                      <td>
                        <div>
                          <p className="font-medium text-slate-900">
                            {member.associationMember?.firstName} {member.associationMember?.lastName}
                          </p>
                          {(member.associationMember?.phone) && (
                            <p className="text-sm text-slate-500">{member.associationMember.phone}</p>
                          )}
                        </div>
                      </td>
                      <td className="text-slate-500">{member.school.name}</td>
                      <td>
                        <span className="badge-neutral">{member.associationMember?.memberType?.name}</span>
                      </td>
                      <td>
                        {member.membershipClass ? (
                          <span className="badge-info">{membershipClassLabels[member.membershipClass]}</span>
                        ) : (
                          '-'
                        )}
                      </td>
                      <td className="text-slate-500">
                        {member.group?.name || '-'}
                      </td>
                      <td>
                        <span className={statusConfig[member.status].class}>
                          {statusConfig[member.status].label}
                        </span>
                      </td>
                      <td>
                        <div className="flex justify-end gap-1">
                          <Link
                            href={`/members/${member.id}/profile`}
                            className="p-2 rounded-lg hover:bg-slate-100 text-slate-500 hover:text-slate-700"
                            title="Dashboard รายบุคคล"
                          >
                            <BarChart3 size={18} />
                          </Link>
                          <Link
                            href={`/members/${member.id}`}
                            className="p-2 rounded-lg hover:bg-slate-100 text-slate-500 hover:text-slate-700"
                          >
                            <Eye size={18} />
                          </Link>
                          <Link
                            href={`/members/${member.id}/edit`}
                            className="p-2 rounded-lg hover:bg-slate-100 text-slate-500 hover:text-slate-700"
                          >
                            <Edit size={18} />
                          </Link>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {/* Pagination */}
            {data && data.meta.totalPages > 1 && (
              <div className="flex items-center justify-between p-4 border-t border-slate-100">
                <p className="text-sm text-slate-500">
                  แสดง {(data.meta.page - 1) * data.meta.limit + 1} -{' '}
                  {Math.min(data.meta.page * data.meta.limit, data.meta.total)} จาก{' '}
                  {data.meta.total} รายการ
                </p>
                <div className="flex gap-2">
                  <button
                    onClick={() => setPage((p) => Math.max(1, p - 1))}
                    disabled={page === 1}
                    className="btn-secondary px-3"
                  >
                    <ChevronLeft size={20} />
                  </button>
                  <button
                    onClick={() => setPage((p) => Math.min(data.meta.totalPages, p + 1))}
                    disabled={page === data.meta.totalPages}
                    className="btn-secondary px-3"
                  >
                    <ChevronRight size={20} />
                  </button>
                </div>
              </div>
            )}
          </>
        )}
      </div>
    </motion.div>
  );
}

