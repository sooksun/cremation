'use client';

import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { FileText, Eye, Check } from 'lucide-react';
import { api } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import { showSuccess } from '@/lib/toast';
import dayjs from 'dayjs';

interface Application {
  id: string;
  memberNo: string;
  joinDate: string;
  applicationSubmittedAt?: string;
  status: string;
  school?: { name: string; code: string };
  associationMember?: {
    firstName: string;
    lastName: string;
    idCardNo?: string;
    memberType?: { name: string };
  };
  beneficiaries?: any[];
}

export default function MemberApplicationsPage() {
  const { selectedSchoolId } = useAuthStore();
  const [selected, setSelected] = useState<Application | null>(null);

  const { data: applications = [], isLoading } = useQuery<Application[]>({
    queryKey: ['member-applications', selectedSchoolId],
    queryFn: async () => {
      const params = selectedSchoolId ? `?schoolId=${selectedSchoolId}` : '';
      const res = await api.get(`/member-applications${params}`);
      return res.data;
    },
  });

  const formatDate = (d?: string) => d ? dayjs(d).format('DD/MM/BBBB') : '-';

  const handleApprove = async (id: string) => {
    try {
      const res = await api.post(`/member-applications/${id}/approve`);
      showSuccess(res.data?.message || 'อนุมัติใบสมัครสำเร็จ');
      // refresh list
      window.location.reload();
    } catch (e: any) {
      showError(e.response?.data?.message || 'อนุมัติล้มเหลว');
    }
  };

  return (
    <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-6">
      <div>
        <h1 className="text-2xl font-semibold flex items-center gap-2">
          <FileText /> ใบสมัครสมาชิก (Applications)
        </h1>
        <p className="text-sm text-slate-500">รายการใบสมัครที่ส่งเข้ามา รอตรวจสอบ</p>
      </div>

      {isLoading ? <div>กำลังโหลด...</div> : (
        <div className="card overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-slate-50">
              <tr>
                <th className="p-3 text-left">เลขสมาชิก</th>
                <th className="p-3 text-left">ชื่อ-สกุล</th>
                <th className="p-3">โรงเรียน</th>
                <th className="p-3">วันที่สมัคร</th>
                <th className="p-3">สถานะ</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {applications.map((app) => (
                <tr key={app.id} className="border-t hover:bg-slate-50">
                  <td className="p-3 font-mono text-xs">{app.memberNo}</td>
                  <td className="p-3">
                    {app.associationMember?.firstName} {app.associationMember?.lastName}
                  </td>
                  <td className="p-3">{app.school?.name || '-'}</td>
                  <td className="p-3">{formatDate(app.applicationSubmittedAt)}</td>
                  <td className="p-3">
                    <span className="badge bg-amber-100 text-amber-700">{app.status}</span>
                  </td>
                  <td className="p-3 flex gap-2">
                    <button onClick={() => setSelected(app)} className="btn-secondary text-xs flex items-center gap-1">
                      <Eye size={14} /> ดู
                    </button>
                    <button onClick={() => handleApprove(app.id)} className="btn-primary text-xs flex items-center gap-1">
                      <Check size={14} /> อนุมัติ
                    </button>
                  </td>
                </tr>
              ))}
              {applications.length === 0 && <tr><td colSpan={6} className="p-4 text-center text-slate-400">ไม่มีใบสมัคร</td></tr>}
            </tbody>
          </table>
        </div>
      )}

      {selected && (
        <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50" onClick={() => setSelected(null)}>
          <div className="bg-white rounded-2xl w-full max-w-2xl p-6" onClick={e => e.stopPropagation()}>
            <h3 className="text-xl font-semibold mb-4">รายละเอียดใบสมัคร {selected.memberNo}</h3>
            <div className="grid grid-cols-2 gap-4 text-sm">
              <div><strong>ชื่อ-สกุล:</strong> {selected.associationMember?.firstName} {selected.associationMember?.lastName}</div>
              <div><strong>บัตรประชาชน:</strong> {selected.associationMember?.idCardNo || '-'}</div>
              <div><strong>โรงเรียน:</strong> {selected.school?.name}</div>
              <div><strong>วันที่สมัคร:</strong> {formatDate(selected.applicationSubmittedAt)}</div>
              <div><strong>สถานะ:</strong> {selected.status}</div>
              <div><strong>ประเภท:</strong> {selected.associationMember?.memberType?.name}</div>
            </div>
            <div className="mt-4">
              <strong>ผู้รับผลประโยชน์:</strong>
              <ul className="list-disc ml-5">
                {selected.beneficiaries?.map((b: any, i: number) => (
                  <li key={i}>{b.fullName} ({b.relationship})</li>
                ))}
              </ul>
            </div>
            <div className="mt-6 flex justify-end gap-3">
              <button onClick={() => setSelected(null)} className="btn-secondary">ปิด</button>
              <button onClick={() => handleApprove(selected.id)} className="btn-primary">อนุมัติและยืนยัน</button>
            </div>
          </div>
        </div>
      )}
    </motion.div>
  );
}
