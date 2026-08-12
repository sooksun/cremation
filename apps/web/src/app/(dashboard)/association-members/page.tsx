'use client';

import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useForm } from 'react-hook-form';
import { motion } from 'framer-motion';
import {
  Search,
  ChevronLeft,
  ChevronRight,
  Eye,
  Edit,
  Trash2,
  Plus,
  UserX,
  Building2,
  BarChart3,
  X,
} from 'lucide-react';
import Link from 'next/link';
import { api, type School, type MemberType } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import { toast } from 'react-toastify';
import { showConfirm } from '@/lib/toast';

const statusConfig = {
  ACTIVE: { label: 'ปกติ', class: 'badge-success' },
  RESIGNED: { label: 'ลาออก', class: 'badge-neutral' },
  DECEASED: { label: 'เสียชีวิต', class: 'badge-danger' },
  ARREARS: { label: 'ค้างชำระ', class: 'badge-warning' },
  SUSPENDED: { label: 'พักสมาชิก', class: 'badge-info' },
};

interface AssociationMemberRow {
  id: string;
  firstName: string;
  lastName: string;
  associationMemberNo?: string;
  position?: string;
  associationJoinDate?: string;
  notes?: string;
  phone?: string;
  idCardNo?: string;
  school: { id: string; name: string };
  memberType: { id: string; name: string };
  cremationMember?: {
    id: string;
    memberNo: string;
    status: string;
  } | null;
}

interface CreateMemberForm {
  schoolId: string;
  memberTypeId: string;
  firstName: string;
  lastName: string;
  idCardNo?: string;
  phone?: string;
  position?: string;
  associationMemberNo?: string;
  notes?: string;
}

interface AssociationMemberListResponse {
  data: AssociationMemberRow[];
  meta: {
    total: number;
    page: number;
    limit: number;
    totalPages: number;
  };
}

export default function AssociationMembersPage() {
  const { selectedSchoolId } = useAuthStore();
  const queryClient = useQueryClient();
  const [page, setPage] = useState(1);
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState<string>('');
  const [editModal, setEditModal] = useState<AssociationMemberRow | null>(null);
  const [editForm, setEditForm] = useState({
    associationMemberNo: '',
    position: '',
    associationJoinDate: '',
    notes: '',
  });
  const [createModalOpen, setCreateModalOpen] = useState(false);
  const createForm = useForm<CreateMemberForm>();

  const { data: schools } = useQuery<School[]>({
    queryKey: ['schools'],
    queryFn: async () => (await api.get('/schools')).data,
    enabled: createModalOpen,
  });

  const { data: memberTypes } = useQuery<MemberType[]>({
    queryKey: ['member-types'],
    queryFn: async () => (await api.get('/member-types')).data,
    enabled: createModalOpen,
  });

  const { data, isLoading } = useQuery<AssociationMemberListResponse>({
    queryKey: ['association-members', selectedSchoolId, page, search, statusFilter],
    queryFn: async () => {
      const params = new URLSearchParams();
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      if (search) params.append('search', search);
      if (statusFilter) params.append('status', statusFilter);
      params.append('page', page.toString());
      params.append('limit', '20');
      const response = await api.get(`/association-members?${params}`);
      return response.data;
    },
  });

  const updateMutation = useMutation({
    mutationFn: async ({
      associationMemberId,
      cremationMemberId,
      data,
    }: {
      associationMemberId: string;
      cremationMemberId?: string;
      data: typeof editForm;
    }) => {
      const payload: Record<string, string> = {};
      if (data.associationMemberNo !== undefined) payload.associationMemberNo = data.associationMemberNo;
      if (data.position !== undefined) payload.position = data.position;
      if (data.associationJoinDate) payload.associationJoinDate = data.associationJoinDate;
      if (data.notes !== undefined) payload.notes = data.notes;
      const path = cremationMemberId
        ? `/association-members/${cremationMemberId}`
        : `/association-members/by-id/${associationMemberId}`;
      const res = await api.patch(path, payload);
      return res.data;
    },
    onSuccess: () => {
      toast.success('บันทึกข้อมูลสมาชิกสมาคมสำเร็จ');
      setEditModal(null);
      queryClient.invalidateQueries({ queryKey: ['association-members'] });
    },
    onError: (err: any) => {
      toast.error(err.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const createMutation = useMutation({
    mutationFn: async (data: CreateMemberForm) => (await api.post('/association-members', data)).data,
    onSuccess: () => {
      toast.success('เพิ่มสมาชิกสมาคมสำเร็จ');
      setCreateModalOpen(false);
      createForm.reset();
      queryClient.invalidateQueries({ queryKey: ['association-members'] });
    },
    onError: (err: any) => {
      toast.error(err.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const deleteMutation = useMutation({
    mutationFn: async (associationMemberId: string) =>
      (await api.delete(`/association-members/by-id/${associationMemberId}`)).data,
    onSuccess: () => {
      toast.success('ลบสมาชิกสมาคมสำเร็จ');
      queryClient.invalidateQueries({ queryKey: ['association-members'] });
    },
    onError: (err: any) => {
      toast.error(err.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const openEditModal = (member: AssociationMemberRow) => {
    setEditModal(member);
    setEditForm({
      associationMemberNo: member.associationMemberNo || '',
      position: member.position || '',
      associationJoinDate: member.associationJoinDate
        ? String(member.associationJoinDate).split('T')[0]
        : '',
      notes: member.notes || '',
    });
  };

  const handleSubmitEdit = () => {
    if (!editModal) return;
    updateMutation.mutate({
      associationMemberId: editModal.id,
      cremationMemberId: editModal.cremationMember?.id,
      data: editForm,
    });
  };

  const formatDate = (d?: string) => {
    if (!d) return '-';
    const date = new Date(d);
    return date.toLocaleDateString('th-TH', {
      day: 'numeric',
      month: 'short',
      year: 'numeric',
    });
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      className="space-y-6"
    >
      {/* Header */}
      <div className="flex items-start justify-between">
        <div>
          <h1 className="text-2xl font-display font-bold text-slate-900">
            ทะเบียนสมาชิกสมาคม
          </h1>
          <p className="text-slate-500 mt-1">
            สมาคมผู้ประกอบวิชาชีพผู้บริหาร ครู และบุคลากรทางการศึกษา อำเภอแม่ฟ้าหลวง
          </p>
          <p className="text-sm text-slate-400 mt-1">
            สมาชิกฌาปนกิจสงเคราะห์ทุกคนเป็นสมาชิกของสมาคมนี้
          </p>
        </div>
        <button
          onClick={() => {
            createForm.reset({
              schoolId: '',
              memberTypeId: '',
              firstName: '',
              lastName: '',
              idCardNo: '',
              phone: '',
              position: '',
              associationMemberNo: '',
              notes: '',
            });
            setCreateModalOpen(true);
          }}
          className="btn-primary shrink-0"
        >
          <Plus size={20} />
          เพิ่มสมาชิก
        </button>
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
            <p className="text-lg font-medium">ไม่พบข้อมูลสมาชิกสมาคม</p>
            <p className="text-sm mt-1">เพิ่มสมาชิกฌาปนกิจใหม่ — ระบบจะสร้างทะเบียนสมาชิกสมาคมให้อัตโนมัติ</p>
            <Link href="/members/new" className="btn-primary mt-4 inline-flex">
              เพิ่มสมาชิกฌาปนกิจ
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
                    <th>ตำแหน่งในสมาคม</th>
                    <th>สถานะ</th>
                    <th className="text-right">จัดการ</th>
                  </tr>
                </thead>
                <tbody>
                  {data?.data.map((member) => (
                    <tr key={member.id}>
                      <td className="font-mono text-sm font-medium">
                        {member.associationMemberNo || member.cremationMember?.memberNo || '-'}
                      </td>
                      <td>
                        <div>
                          <p className="font-medium text-slate-900">
                            {member.firstName} {member.lastName}
                          </p>
                          {member.phone && (
                            <p className="text-sm text-slate-500">{member.phone}</p>
                          )}
                        </div>
                      </td>
                      <td className="text-slate-500">{member.school.name}</td>
                      <td className="text-slate-600">
                        {member.position || '-'}
                      </td>
                      <td>
                        {member.cremationMember ? (
                          <span className={statusConfig[member.cremationMember.status as keyof typeof statusConfig]?.class || 'badge-neutral'}>
                            {statusConfig[member.cremationMember.status as keyof typeof statusConfig]?.label || member.cremationMember.status}
                          </span>
                        ) : (
                          <span className="text-slate-400">— ไม่ได้เข้าร่วมฌาปนกิจ</span>
                        )}
                      </td>
                      <td>
                        <div className="flex justify-end gap-1">
                          {member.cremationMember && (
                          <Link
                            href={`/members/${member.cremationMember.id}/profile`}
                            className="p-2 rounded-lg hover:bg-slate-100 text-slate-500 hover:text-slate-700"
                            title="ดู Dashboard รายบุคคล"
                          >
                            <BarChart3 size={18} />
                          </Link>
                          )}
                          {member.cremationMember && (
                          <Link
                            href={`/members/${member.cremationMember.id}`}
                            className="p-2 rounded-lg hover:bg-slate-100 text-slate-500 hover:text-slate-700"
                            title="ดูรายละเอียด"
                          >
                            <Eye size={18} />
                          </Link>
                          )}
                          <button
                            onClick={() => openEditModal(member)}
                            className="p-2 rounded-lg hover:bg-slate-100 text-slate-500 hover:text-slate-700"
                            title="แก้ไขข้อมูลสมาชิกสมาคม"
                          >
                            <Edit size={18} />
                          </button>
                          <button
                            onClick={() =>
                              showConfirm('ต้องการลบสมาชิกนี้หรือไม่?', () =>
                                deleteMutation.mutate(member.id),
                              )
                            }
                            className="p-2 rounded-lg hover:bg-red-50 text-slate-500 hover:text-red-600"
                            title="ลบสมาชิก"
                          >
                            <Trash2 size={18} />
                          </button>
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

      {/* Edit Modal */}
      {editModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50">
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-white rounded-2xl shadow-xl max-w-md w-full p-6"
          >
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-lg font-semibold text-slate-900">
                แก้ไขข้อมูลสมาชิกสมาคม
              </h2>
              <button
                onClick={() => setEditModal(null)}
                className="p-2 hover:bg-slate-100 rounded-lg"
              >
                <X size={20} />
              </button>
            </div>
            <p className="text-slate-600 mb-4">
              {editModal.firstName} {editModal.lastName} ({editModal.cremationMember?.memberNo ?? editModal.associationMemberNo ?? '-'})
            </p>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">
                  เลขสมาชิกสมาคม
                </label>
                <input
                  type="text"
                  className="input w-full"
                  value={editForm.associationMemberNo}
                  onChange={(e) =>
                    setEditForm((f) => ({ ...f, associationMemberNo: e.target.value }))
                  }
                  placeholder="(ใช้เลขสมาชิกฌาปนกิจได้)"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">
                  ตำแหน่งในสมาคม
                </label>
                <input
                  type="text"
                  className="input w-full"
                  value={editForm.position}
                  onChange={(e) => setEditForm((f) => ({ ...f, position: e.target.value }))}
                  placeholder="เช่น สมาชิก, กรรมการ, เลขานุการ"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">
                  วันที่เป็นสมาชิกสมาคม
                </label>
                <input
                  type="date"
                  className="input w-full"
                  value={editForm.associationJoinDate}
                  onChange={(e) =>
                    setEditForm((f) => ({ ...f, associationJoinDate: e.target.value }))
                  }
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">
                  หมายเหตุ
                </label>
                <textarea
                  className="input w-full min-h-[80px]"
                  value={editForm.notes}
                  onChange={(e) => setEditForm((f) => ({ ...f, notes: e.target.value }))}
                  placeholder="หมายเหตุเพิ่มเติม"
                />
              </div>
            </div>
            <div className="flex gap-3 mt-6">
              <button
                onClick={() => setEditModal(null)}
                className="btn-secondary flex-1"
              >
                ยกเลิก
              </button>
              <button
                onClick={handleSubmitEdit}
                disabled={updateMutation.isPending}
                className="btn-primary flex-1"
              >
                {updateMutation.isPending ? 'กำลังบันทึก...' : 'บันทึก'}
              </button>
            </div>
          </motion.div>
        </div>
      )}

      {/* Create Modal */}
      {createModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50">
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-white rounded-2xl shadow-xl max-w-md w-full p-6 max-h-[90vh] overflow-y-auto"
          >
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-lg font-semibold text-slate-900">เพิ่มสมาชิกสมาคม</h2>
              <button
                onClick={() => setCreateModalOpen(false)}
                className="p-2 hover:bg-slate-100 rounded-lg"
              >
                <X size={20} />
              </button>
            </div>
            <form
              onSubmit={createForm.handleSubmit((data) => createMutation.mutate(data))}
              className="space-y-4"
            >
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">
                  โรงเรียน *
                </label>
                <select
                  className="input w-full"
                  {...createForm.register('schoolId', { required: 'กรุณาเลือกโรงเรียน' })}
                >
                  <option value="">เลือกโรงเรียน</option>
                  {schools?.map((s) => (
                    <option key={s.id} value={s.id}>
                      {s.name}
                    </option>
                  ))}
                </select>
                {createForm.formState.errors.schoolId && (
                  <p className="text-sm text-red-500 mt-1">
                    {createForm.formState.errors.schoolId.message}
                  </p>
                )}
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">
                  ประเภทสมาชิก *
                </label>
                <select
                  className="input w-full"
                  {...createForm.register('memberTypeId', { required: 'กรุณาเลือกประเภทสมาชิก' })}
                >
                  <option value="">เลือกประเภท</option>
                  {memberTypes?.map((mt) => (
                    <option key={mt.id} value={mt.id}>
                      {mt.name}
                    </option>
                  ))}
                </select>
                {createForm.formState.errors.memberTypeId && (
                  <p className="text-sm text-red-500 mt-1">
                    {createForm.formState.errors.memberTypeId.message}
                  </p>
                )}
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1">ชื่อ *</label>
                  <input
                    className="input w-full"
                    {...createForm.register('firstName', { required: 'กรุณากรอกชื่อ' })}
                  />
                  {createForm.formState.errors.firstName && (
                    <p className="text-sm text-red-500 mt-1">
                      {createForm.formState.errors.firstName.message}
                    </p>
                  )}
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1">
                    นามสกุล *
                  </label>
                  <input
                    className="input w-full"
                    {...createForm.register('lastName', { required: 'กรุณากรอกนามสกุล' })}
                  />
                  {createForm.formState.errors.lastName && (
                    <p className="text-sm text-red-500 mt-1">
                      {createForm.formState.errors.lastName.message}
                    </p>
                  )}
                </div>
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">
                  เลขบัตรประชาชน
                </label>
                <input className="input w-full" maxLength={13} {...createForm.register('idCardNo')} />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1">เบอร์โทร</label>
                  <input className="input w-full" {...createForm.register('phone')} />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1">
                    เลขสมาชิกสมาคม
                  </label>
                  <input className="input w-full" {...createForm.register('associationMemberNo')} />
                </div>
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">ตำแหน่ง</label>
                <input
                  className="input w-full"
                  placeholder="เช่น ผู้อำนวยการ, ครู"
                  {...createForm.register('position')}
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">หมายเหตุ</label>
                <textarea
                  className="input w-full min-h-[60px]"
                  {...createForm.register('notes')}
                />
              </div>
              <div className="flex gap-3 pt-2">
                <button
                  type="button"
                  onClick={() => setCreateModalOpen(false)}
                  className="btn-secondary flex-1"
                >
                  ยกเลิก
                </button>
                <button
                  type="submit"
                  disabled={createMutation.isPending}
                  className="btn-primary flex-1"
                >
                  {createMutation.isPending ? 'กำลังบันทึก...' : 'บันทึก'}
                </button>
              </div>
            </form>
          </motion.div>
        </div>
      )}
    </motion.div>
  );
}
