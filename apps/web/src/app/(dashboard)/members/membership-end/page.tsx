'use client';

import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import {
  Search,
  ChevronLeft,
  ChevronRight,
  UserMinus,
  UserCheck,
  Eye,
  X,
  Undo2,
} from 'lucide-react';
import Link from 'next/link';
import {
  api,
  type Member,
  type MembershipEndReason,
  membershipEndReasonLabels,
} from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import { showSuccess, showError, showConfirm } from '@/lib/toast';
import ThaiDatePicker from '@/components/ThaiDatePicker';
import dayjs from 'dayjs';

const statusConfig: Record<string, { label: string; class: string }> = {
  ACTIVE: { label: 'ปกติ', class: 'badge-success' },
  RESIGNED: { label: 'สิ้นสุดสมาชิกภาพ', class: 'badge-neutral' },
  DECEASED: { label: 'เสียชีวิต', class: 'badge-danger' },
  ARREARS: { label: 'ค้างชำระ', class: 'badge-warning' },
  SUSPENDED: { label: 'พักสมาชิก', class: 'badge-info' },
};

// เหตุที่เจ้าหน้าที่บันทึกเองได้ — DECEASED ต้องไปทำผ่านงานแจ้งเสียชีวิตเพื่อให้เปิดเรื่องเคลมด้วย
const SELECTABLE_REASONS: MembershipEndReason[] = [
  'TRANSFERRED',
  'RESIGNED',
  'RETIRED',
  'ARREARS_TERMINATED',
  'MANUAL',
];

interface MemberListResponse {
  data: Member[];
  meta: { total: number; page: number; limit: number; totalPages: number };
}

export default function MembershipEndPage() {
  const { selectedSchoolId } = useAuthStore();
  const queryClient = useQueryClient();
  const [page, setPage] = useState(1);
  const [search, setSearch] = useState('');
  const [reasonFilter, setReasonFilter] = useState<string>('');

  const [endModalOpen, setEndModalOpen] = useState(false);
  const [pickerSearch, setPickerSearch] = useState('');
  const [selectedMember, setSelectedMember] = useState<Member | null>(null);
  const [endReason, setEndReason] = useState<MembershipEndReason>('TRANSFERRED');
  const [endDate, setEndDate] = useState(dayjs().format('YYYY-MM-DD'));

  const { data, isLoading } = useQuery<MemberListResponse>({
    queryKey: ['membership-ended', selectedSchoolId, page, search, reasonFilter],
    queryFn: async () => {
      const params = new URLSearchParams({
        membershipEnded: 'true',
        page: String(page),
        limit: '20',
      });
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      if (search) params.append('search', search);
      if (reasonFilter) params.append('membershipEndReason', reasonFilter);
      return (await api.get(`/members?${params}`)).data;
    },
  });

  // ผู้สมัครให้เลือกในโมดัล — เฉพาะคนที่ยังมีสมาชิกภาพอยู่
  const { data: activeMembers, isLoading: pickerLoading } = useQuery<MemberListResponse>({
    queryKey: ['active-members-picker', selectedSchoolId, pickerSearch],
    queryFn: async () => {
      const params = new URLSearchParams({ status: 'ACTIVE', limit: '50' });
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      if (pickerSearch) params.append('search', pickerSearch);
      return (await api.get(`/members?${params}`)).data;
    },
    enabled: endModalOpen,
  });

  const invalidate = () => {
    queryClient.invalidateQueries({ queryKey: ['membership-ended'] });
    queryClient.invalidateQueries({ queryKey: ['active-members-picker'] });
    queryClient.invalidateQueries({ queryKey: ['members'] });
  };

  const endMembershipMutation = useMutation({
    mutationFn: ({
      memberId,
      reason,
      date,
    }: {
      memberId: string;
      reason: MembershipEndReason;
      date: string;
    }) =>
      api.patch(`/members/${memberId}/status`, {
        status: 'RESIGNED',
        date,
        membershipEndReason: reason,
      }),
    onSuccess: () => {
      invalidate();
      showSuccess('บันทึกการสิ้นสุดสมาชิกภาพสำเร็จ');
      closeEndModal();
    },
    onError: (error: any) =>
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด'),
  });

  const restoreMutation = useMutation({
    mutationFn: (memberId: string) =>
      api.patch(`/members/${memberId}/status`, { status: 'ACTIVE' }),
    onSuccess: () => {
      invalidate();
      showSuccess('กู้คืนสมาชิกภาพสำเร็จ');
    },
    onError: (error: any) =>
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด'),
  });

  const closeEndModal = () => {
    setEndModalOpen(false);
    setSelectedMember(null);
    setPickerSearch('');
    setEndReason('TRANSFERRED');
    setEndDate(dayjs().format('YYYY-MM-DD'));
  };

  const handleSubmitEnd = () => {
    if (!selectedMember) {
      showError('กรุณาเลือกสมาชิก');
      return;
    }
    if (!endDate) {
      showError('กรุณาระบุวันที่สิ้นสุดสมาชิกภาพ');
      return;
    }
    endMembershipMutation.mutate({
      memberId: selectedMember.id,
      reason: endReason,
      date: endDate,
    });
  };

  const formatDate = (d?: string) =>
    d
      ? new Date(d).toLocaleDateString('th-TH', {
          day: 'numeric',
          month: 'short',
          year: 'numeric',
        })
      : '-';

  const endedOn = (m: Member) => m.resignDate || m.deathDate;

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      className="space-y-6"
    >
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-display font-bold text-slate-900">
            สิ้นสุดสมาชิกภาพ
          </h1>
          <p className="text-slate-500 mt-1">
            จัดการสมาชิกที่ย้ายออกนอกเขต ลาออก เกษียณ หรือสิ้นสุดสมาชิกภาพด้วยเหตุอื่น
          </p>
        </div>
        <button onClick={() => setEndModalOpen(true)} className="btn-primary">
          <UserMinus size={20} />
          บันทึกสิ้นสุดสมาชิกภาพ
        </button>
      </div>

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
            className="input w-full md:w-64"
            value={reasonFilter}
            onChange={(e) => {
              setReasonFilter(e.target.value);
              setPage(1);
            }}
          >
            <option value="">ทุกเหตุผล</option>
            {(Object.keys(membershipEndReasonLabels) as MembershipEndReason[]).map((r) => (
              <option key={r} value={r}>
                {membershipEndReasonLabels[r]}
              </option>
            ))}
          </select>
        </div>
      </div>

      <div className="card overflow-hidden">
        {isLoading ? (
          <div className="flex items-center justify-center py-20">
            <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
          </div>
        ) : data?.data.length === 0 ? (
          <div className="text-center py-20 text-slate-500">
            <UserCheck className="w-16 h-16 mx-auto text-slate-300 mb-4" />
            <p className="text-lg font-medium">ไม่มีสมาชิกที่สิ้นสุดสมาชิกภาพ</p>
            <p className="text-sm mt-1">
              สมาชิกทุกคนตามตัวกรองนี้ยังมีสมาชิกภาพอยู่
            </p>
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
                    <th>เหตุสิ้นสุด</th>
                    <th>วันที่สิ้นสุด</th>
                    <th>สถานะ</th>
                    <th className="text-right">จัดการ</th>
                  </tr>
                </thead>
                <tbody>
                  {data?.data.map((member) => (
                    <tr key={member.id}>
                      <td className="font-mono text-sm font-medium">{member.memberNo}</td>
                      <td>
                        <p className="font-medium text-slate-900">
                          {member.associationMember?.firstName}{' '}
                          {member.associationMember?.lastName}
                        </p>
                        {member.associationMember?.phone && (
                          <p className="text-sm text-slate-500">
                            {member.associationMember.phone}
                          </p>
                        )}
                      </td>
                      <td className="text-slate-500">{member.school.name}</td>
                      <td>
                        {member.membershipEndReason ? (
                          <span className="badge-warning">
                            {membershipEndReasonLabels[member.membershipEndReason]}
                          </span>
                        ) : (
                          <span className="text-slate-400">ไม่ระบุ</span>
                        )}
                      </td>
                      <td className="text-slate-500">{formatDate(endedOn(member))}</td>
                      <td>
                        <span className={statusConfig[member.status]?.class || 'badge-neutral'}>
                          {statusConfig[member.status]?.label || member.status}
                        </span>
                      </td>
                      <td>
                        <div className="flex justify-end gap-1">
                          <Link
                            href={`/members/${member.id}`}
                            className="p-2 rounded-lg hover:bg-slate-100 text-slate-500 hover:text-slate-700"
                            title="ดูรายละเอียด"
                          >
                            <Eye size={18} />
                          </Link>
                          {member.status !== 'DECEASED' && (
                            <button
                              onClick={() =>
                                showConfirm(
                                  'กู้คืนสมาชิกภาพให้กลับเป็นปกติ? ข้อมูลเหตุและวันที่สิ้นสุดจะถูกล้าง',
                                  () => restoreMutation.mutate(member.id),
                                )
                              }
                              className="p-2 rounded-lg hover:bg-emerald-50 text-slate-500 hover:text-emerald-600"
                              title="กู้คืนสมาชิกภาพ (กรณีบันทึกผิด)"
                            >
                              <Undo2 size={18} />
                            </button>
                          )}
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

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

      {endModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50">
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-white rounded-2xl shadow-xl max-w-lg w-full p-6 max-h-[90vh] overflow-y-auto"
          >
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-lg font-semibold text-slate-900">
                บันทึกสิ้นสุดสมาชิกภาพ
              </h2>
              <button
                onClick={closeEndModal}
                className="p-2 hover:bg-slate-100 rounded-lg"
              >
                <X size={20} />
              </button>
            </div>

            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">
                  เลือกสมาชิก *
                </label>
                {selectedMember ? (
                  <div className="flex items-center justify-between gap-3 p-3 rounded-lg border border-primary-200 bg-primary-50">
                    <div>
                      <p className="font-medium text-slate-900">
                        {selectedMember.associationMember?.firstName}{' '}
                        {selectedMember.associationMember?.lastName}
                      </p>
                      <p className="text-sm text-slate-500">
                        {selectedMember.memberNo} · {selectedMember.school.name}
                      </p>
                    </div>
                    <button
                      onClick={() => setSelectedMember(null)}
                      className="btn-secondary px-3 py-1 text-sm shrink-0"
                    >
                      เปลี่ยน
                    </button>
                  </div>
                ) : (
                  <>
                    <div className="relative">
                      <Search
                        size={18}
                        className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400"
                      />
                      <input
                        type="text"
                        className="input pl-10"
                        placeholder="ค้นหาชื่อหรือเลขสมาชิก..."
                        value={pickerSearch}
                        onChange={(e) => setPickerSearch(e.target.value)}
                      />
                    </div>
                    <div className="mt-2 max-h-52 overflow-y-auto rounded-lg border border-slate-200 divide-y divide-slate-100">
                      {pickerLoading ? (
                        <p className="p-3 text-sm text-slate-500">กำลังโหลด...</p>
                      ) : activeMembers?.data.length === 0 ? (
                        <p className="p-3 text-sm text-slate-500">
                          ไม่พบสมาชิกที่มีสถานะปกติตามคำค้น
                        </p>
                      ) : (
                        activeMembers?.data.map((m) => (
                          <button
                            key={m.id}
                            onClick={() => setSelectedMember(m)}
                            className="w-full text-left p-3 hover:bg-slate-50"
                          >
                            <p className="font-medium text-slate-900">
                              {m.associationMember?.firstName}{' '}
                              {m.associationMember?.lastName}
                            </p>
                            <p className="text-sm text-slate-500">
                              {m.memberNo} · {m.school.name}
                            </p>
                          </button>
                        ))
                      )}
                    </div>
                  </>
                )}
              </div>

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">
                  เหตุสิ้นสุดสมาชิกภาพ *
                </label>
                <select
                  className="input w-full"
                  value={endReason}
                  onChange={(e) => setEndReason(e.target.value as MembershipEndReason)}
                >
                  {SELECTABLE_REASONS.map((r) => (
                    <option key={r} value={r}>
                      {membershipEndReasonLabels[r]}
                    </option>
                  ))}
                </select>
                <p className="text-xs text-slate-400 mt-1">
                  กรณีสมาชิกเสียชีวิต ให้บันทึกผ่านเมนู &ldquo;แจ้งเสียชีวิต&rdquo; เพื่อเปิดเรื่องขอรับเงินสงเคราะห์
                </p>
              </div>

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">
                  วันที่สิ้นสุดสมาชิกภาพ *
                </label>
                <ThaiDatePicker
                  value={endDate}
                  onChange={(v) => setEndDate((v as unknown as string) || '')}
                  placeholder="เลือกวันที่สิ้นสุดสมาชิกภาพ"
                  returnString
                />
              </div>
            </div>

            <div className="flex gap-3 mt-6">
              <button onClick={closeEndModal} className="btn-secondary flex-1">
                ยกเลิก
              </button>
              <button
                onClick={handleSubmitEnd}
                disabled={endMembershipMutation.isPending}
                className="btn-primary flex-1"
              >
                {endMembershipMutation.isPending ? 'กำลังบันทึก...' : 'บันทึก'}
              </button>
            </div>
          </motion.div>
        </div>
      )}
    </motion.div>
  );
}
