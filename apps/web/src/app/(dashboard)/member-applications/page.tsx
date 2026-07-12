'use client';

import { useState } from 'react';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { FileText, Eye, Check, X } from 'lucide-react';
import { api } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import { showSuccess, showError } from '@/lib/toast';
import dayjs from 'dayjs';

interface Application {
  id: string;
  memberNo: string;
  joinDate: string;
  applicationSubmittedAt?: string;
  status: string;
  applicationStatus?: string | null;
  school?: { name: string; code: string };
  associationMember?: {
    firstName: string;
    lastName: string;
    idCardNo?: string;
    memberType?: { name: string };
  };
  beneficiaries?: any[];
}

const STATUS_LABEL: Record<string, { text: string; cls: string }> = {
  APPROVED: { text: 'อนุมัติแล้ว', cls: 'bg-green-100 text-green-700' },
  REJECTED: { text: 'ปฏิเสธแล้ว', cls: 'bg-red-100 text-red-700' },
  PENDING: { text: 'รอตรวจสอบ', cls: 'bg-amber-100 text-amber-700' },
};

export default function MemberApplicationsPage() {
  const { selectedSchoolId } = useAuthStore();
  const queryClient = useQueryClient();
  const [selected, setSelected] = useState<Application | null>(null);
  const [approveTarget, setApproveTarget] = useState<Application | null>(null);
  const [rejectTarget, setRejectTarget] = useState<Application | null>(null);
  const [directorName, setDirectorName] = useState('');
  const [committeeName, setCommitteeName] = useState('');
  const [rejectReason, setRejectReason] = useState('');
  const [submitting, setSubmitting] = useState(false);

  const { data: applications = [], isLoading } = useQuery<Application[]>({
    queryKey: ['member-applications', selectedSchoolId],
    queryFn: async () => {
      const params = selectedSchoolId ? `?schoolId=${selectedSchoolId}` : '';
      const res = await api.get(`/member-applications${params}`);
      return res.data;
    },
  });

  const formatDate = (d?: string) => (d ? dayjs(d).format('DD/MM/BBBB') : '-');

  const refresh = () =>
    queryClient.invalidateQueries({ queryKey: ['member-applications'] });

  const openApprove = (app: Application) => {
    setDirectorName('');
    setCommitteeName('');
    setApproveTarget(app);
    setSelected(null);
  };

  const submitApprove = async () => {
    if (!approveTarget) return;
    setSubmitting(true);
    try {
      const res = await api.post(`/member-applications/${approveTarget.id}/approve`, {
        directorName: directorName.trim() || undefined,
        committeeName: committeeName.trim() || undefined,
      });
      showSuccess(res.data?.message || 'อนุมัติใบสมัครสำเร็จ');
      setApproveTarget(null);
      await refresh();
    } catch (e: any) {
      showError(e.response?.data?.message || 'อนุมัติล้มเหลว');
    } finally {
      setSubmitting(false);
    }
  };

  const submitReject = async () => {
    if (!rejectTarget) return;
    if (!rejectReason.trim()) {
      showError('กรุณาระบุเหตุผลการปฏิเสธ');
      return;
    }
    setSubmitting(true);
    try {
      const res = await api.post(`/member-applications/${rejectTarget.id}/reject`, {
        reason: rejectReason.trim(),
      });
      showSuccess(res.data?.message || 'ปฏิเสธใบสมัครแล้ว');
      setRejectTarget(null);
      setRejectReason('');
      await refresh();
    } catch (e: any) {
      showError(e.response?.data?.message || 'ปฏิเสธล้มเหลว');
    } finally {
      setSubmitting(false);
    }
  };

  const statusBadge = (app: Application) => {
    const s = app.applicationStatus || 'PENDING';
    const cfg = STATUS_LABEL[s] || STATUS_LABEL.PENDING;
    return <span className={`badge ${cfg.cls}`}>{cfg.text}</span>;
  };

  const isPending = (app: Application) =>
    !app.applicationStatus || app.applicationStatus === 'PENDING';

  return (
    <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-6">
      <div>
        <h1 className="text-2xl font-semibold flex items-center gap-2">
          <FileText /> ใบสมัครสมาชิก (Applications)
        </h1>
        <p className="text-sm text-slate-500">รายการใบสมัครที่ส่งเข้ามา รอตรวจสอบและอนุมัติ (ระเบียบ ข้อ 15)</p>
      </div>

      {isLoading ? (
        <div>กำลังโหลด...</div>
      ) : (
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
                  <td className="p-3">{statusBadge(app)}</td>
                  <td className="p-3 flex gap-2 justify-end">
                    <button
                      onClick={() => setSelected(app)}
                      className="btn-secondary text-xs flex items-center gap-1"
                    >
                      <Eye size={14} /> ดู
                    </button>
                    {isPending(app) && (
                      <>
                        <button
                          onClick={() => openApprove(app)}
                          className="btn-primary text-xs flex items-center gap-1"
                        >
                          <Check size={14} /> อนุมัติ
                        </button>
                        <button
                          onClick={() => {
                            setRejectReason('');
                            setRejectTarget(app);
                          }}
                          className="btn-secondary text-xs flex items-center gap-1 text-red-600"
                        >
                          <X size={14} /> ปฏิเสธ
                        </button>
                      </>
                    )}
                  </td>
                </tr>
              ))}
              {applications.length === 0 && (
                <tr>
                  <td colSpan={6} className="p-4 text-center text-slate-400">
                    ไม่มีใบสมัคร
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      )}

      {/* รายละเอียดใบสมัคร */}
      {selected && (
        <div
          className="fixed inset-0 bg-black/40 flex items-center justify-center z-50"
          onClick={() => setSelected(null)}
        >
          <div className="bg-white rounded-2xl w-full max-w-2xl p-6" onClick={(e) => e.stopPropagation()}>
            <h3 className="text-xl font-semibold mb-4">รายละเอียดใบสมัคร {selected.memberNo}</h3>
            <div className="grid grid-cols-2 gap-4 text-sm">
              <div><strong>ชื่อ-สกุล:</strong> {selected.associationMember?.firstName} {selected.associationMember?.lastName}</div>
              <div><strong>บัตรประชาชน:</strong> {selected.associationMember?.idCardNo || '-'}</div>
              <div><strong>โรงเรียน:</strong> {selected.school?.name}</div>
              <div><strong>วันที่สมัคร:</strong> {formatDate(selected.applicationSubmittedAt)}</div>
              <div><strong>สถานะ:</strong> {statusBadge(selected)}</div>
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
              {isPending(selected) && (
                <button onClick={() => openApprove(selected)} className="btn-primary">อนุมัติ</button>
              )}
            </div>
          </div>
        </div>
      )}

      {/* อนุมัติ + คำรับรอง ผอ./กรรมการ */}
      {approveTarget && (
        <div
          className="fixed inset-0 bg-black/40 flex items-center justify-center z-50"
          onClick={() => setApproveTarget(null)}
        >
          <div className="bg-white rounded-2xl w-full max-w-md p-6" onClick={(e) => e.stopPropagation()}>
            <h3 className="text-lg font-semibold mb-1">อนุมัติใบสมัคร {approveTarget.memberNo}</h3>
            <p className="text-sm text-slate-500 mb-4">
              บันทึกคำรับรองก่อนเปิดใช้งานสมาชิก (ระเบียบ ข้อ 15)
            </p>
            <div className="space-y-3 text-sm">
              <div>
                <label className="block text-slate-600 mb-1">คำรับรอง ผอ. (ถ้ามี)</label>
                <input
                  value={directorName}
                  onChange={(e) => setDirectorName(e.target.value)}
                  className="input w-full"
                  placeholder="ชื่อผู้อำนวยการที่รับรอง"
                />
              </div>
              <div>
                <label className="block text-slate-600 mb-1">กรรมการรับสมัคร (ถ้ามี)</label>
                <input
                  value={committeeName}
                  onChange={(e) => setCommitteeName(e.target.value)}
                  className="input w-full"
                  placeholder="ชื่อกรรมการรับสมัคร"
                />
              </div>
            </div>
            <div className="mt-6 flex justify-end gap-3">
              <button onClick={() => setApproveTarget(null)} className="btn-secondary" disabled={submitting}>
                ยกเลิก
              </button>
              <button onClick={submitApprove} className="btn-primary" disabled={submitting}>
                {submitting ? 'กำลังบันทึก...' : 'ยืนยันอนุมัติ'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ปฏิเสธ + เหตุผล */}
      {rejectTarget && (
        <div
          className="fixed inset-0 bg-black/40 flex items-center justify-center z-50"
          onClick={() => setRejectTarget(null)}
        >
          <div className="bg-white rounded-2xl w-full max-w-md p-6" onClick={(e) => e.stopPropagation()}>
            <h3 className="text-lg font-semibold mb-1">ปฏิเสธใบสมัคร {rejectTarget.memberNo}</h3>
            <p className="text-sm text-slate-500 mb-4">ระบุเหตุผลการปฏิเสธ</p>
            <textarea
              value={rejectReason}
              onChange={(e) => setRejectReason(e.target.value)}
              className="input w-full h-24"
              placeholder="เหตุผลการปฏิเสธ เช่น เอกสารไม่ครบ"
            />
            <div className="mt-6 flex justify-end gap-3">
              <button onClick={() => setRejectTarget(null)} className="btn-secondary" disabled={submitting}>
                ยกเลิก
              </button>
              <button
                onClick={submitReject}
                className="btn-primary bg-red-600 hover:bg-red-700"
                disabled={submitting}
              >
                {submitting ? 'กำลังบันทึก...' : 'ยืนยันปฏิเสธ'}
              </button>
            </div>
          </div>
        </div>
      )}
    </motion.div>
  );
}
