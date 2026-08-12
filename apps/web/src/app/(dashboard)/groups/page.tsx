'use client';

import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion, AnimatePresence } from 'framer-motion';
import { Plus, FolderTree, Edit, Trash2, X, Users, Building2, Wand2, AlertTriangle } from 'lucide-react';
import { useForm } from 'react-hook-form';
import { showSuccess, showError, showConfirm } from '@/lib/toast';
import { api, type School, type Group } from '@/lib/api';
import { useAuthStore } from '@/store/auth';

interface GroupWithCount extends Group {
  _count?: { members: number };
  leader?: {
    id: string;
    associationMember?: { firstName: string; lastName: string };
  };
}

interface GroupForm {
  schoolId: string;
  code: string;
  name: string;
  leaderId?: string;
}

interface AutoAssignPreview {
  totalPending: number;
  groupsToCreate: number;
  perSchool: Array<{ schoolName: string; pending: number; willCreateGroup: boolean }>;
}

export default function GroupsPage() {
  const queryClient = useQueryClient();
  const { selectedSchoolId } = useAuthStore();
  const [modalOpen, setModalOpen] = useState(false);
  const [editingGroup, setEditingGroup] = useState<GroupWithCount | null>(null);

  const { register, handleSubmit, reset, formState: { errors } } = useForm<GroupForm>();

  const { data: groups, isLoading } = useQuery<GroupWithCount[]>({
    queryKey: ['groups', selectedSchoolId],
    queryFn: async () => {
      const params = selectedSchoolId ? `?schoolId=${selectedSchoolId}` : '';
      const response = await api.get(`/groups${params}`);
      return response.data;
    },
  });

  const { data: schools } = useQuery<School[]>({
    queryKey: ['schools'],
    queryFn: async () => {
      const response = await api.get('/schools');
      return response.data;
    },
  });

  const { data: preview } = useQuery<AutoAssignPreview>({
    queryKey: ['groups-auto-assign-preview', selectedSchoolId],
    queryFn: async () => {
      const params = selectedSchoolId ? `?schoolId=${selectedSchoolId}` : '';
      const response = await api.get(`/groups/auto-assign/preview${params}`);
      return response.data;
    },
  });

  const autoAssignMutation = useMutation({
    mutationFn: () =>
      api.post('/groups/auto-assign', selectedSchoolId ? { schoolId: selectedSchoolId } : {}),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['groups'] });
      queryClient.invalidateQueries({ queryKey: ['groups-auto-assign-preview'] });
      queryClient.invalidateQueries({ queryKey: ['members'] });
      showSuccess(res.data?.message || 'จัดกลุ่มสำเร็จ');
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const createMutation = useMutation({
    mutationFn: (data: GroupForm) => api.post('/groups', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['groups'] });
      showSuccess('เพิ่มกลุ่มสำเร็จ');
      closeModal();
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<GroupForm> }) =>
      api.patch(`/groups/${id}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['groups'] });
      showSuccess('แก้ไขข้อมูลสำเร็จ');
      closeModal();
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/groups/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['groups'] });
      showSuccess('ลบกลุ่มสำเร็จ');
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const openModal = (group?: GroupWithCount) => {
    if (group) {
      setEditingGroup(group);
      reset({
        schoolId: group.school.id,
        code: group.code,
        name: group.name,
        leaderId: group.leader?.id || '',
      });
    } else {
      setEditingGroup(null);
      reset({ schoolId: selectedSchoolId || '', code: '', name: '', leaderId: '' });
    }
    setModalOpen(true);
  };

  const closeModal = () => {
    setModalOpen(false);
    setEditingGroup(null);
    reset();
  };

  const onSubmit = (data: GroupForm) => {
    // Build clean data object - only include non-empty values
    const submitData: Record<string, any> = {};
    
    if (data.code && data.code.trim() !== '') submitData.code = data.code;
    if (data.name && data.name.trim() !== '') submitData.name = data.name;
    if (data.leaderId && data.leaderId.trim() !== '') submitData.leaderId = data.leaderId;
    
    if (editingGroup) {
      // Don't include schoolId when editing
      updateMutation.mutate({ id: editingGroup.id, data: submitData });
    } else {
      // Include schoolId only when creating
      submitData.schoolId = data.schoolId;
      createMutation.mutate(submitData as GroupForm);
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      className="space-y-6"
    >
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-display font-bold text-slate-900">
            กลุ่มเก็บเงิน
          </h1>
          <p className="text-slate-500 mt-1">
            กลุ่มย่อยภายในโรงเรียนสำหรับเก็บเงินสงเคราะห์รายเดือน (แยกจากกลุ่มโรงเรียน)
          </p>
        </div>
        <button onClick={() => openModal()} className="btn-primary">
          <Plus size={20} />
          เพิ่มกลุ่ม
        </button>
      </div>

      {/* สมาชิกที่ยังไม่เข้ากลุ่ม — เก็บเงินรายเดือนไม่ได้จนกว่าจะจัดกลุ่ม */}
      {preview && preview.totalPending > 0 && (
        <div className="card p-5 border-l-4 border-amber-400">
          <div className="flex flex-col md:flex-row md:items-center gap-4">
            <div className="flex-1">
              <div className="flex items-center gap-2 mb-1">
                <AlertTriangle size={18} className="text-amber-500 shrink-0" />
                <h2 className="font-semibold text-slate-900">
                  มีสมาชิก {preview.totalPending.toLocaleString('th-TH')} คนยังไม่อยู่ในกลุ่มเก็บเงิน
                </h2>
              </div>
              <p className="text-sm text-slate-500">
                ระบบจะจัดสมาชิกเข้ากลุ่มของโรงเรียนตัวเอง
                {preview.groupsToCreate > 0 && (
                  <> และสร้างกลุ่มให้อีก {preview.groupsToCreate} โรงเรียนที่ยังไม่มีกลุ่ม</>
                )}
                {' '}— สมาชิกที่ลาออกหรือเสียชีวิตจะไม่ถูกจัดเข้ากลุ่ม
              </p>
            </div>
            <button
              onClick={() =>
                showConfirm(
                  `จัดสมาชิก ${preview.totalPending.toLocaleString('th-TH')} คนเข้ากลุ่มตามโรงเรียนหรือไม่?`,
                  () => autoAssignMutation.mutate(),
                )
              }
              disabled={autoAssignMutation.isPending}
              className="btn-primary shrink-0"
            >
              <Wand2 size={18} />
              {autoAssignMutation.isPending ? 'กำลังจัด...' : 'จัดกลุ่มอัตโนมัติ'}
            </button>
          </div>

          {preview.perSchool.length > 0 && (
            <details className="mt-4">
              <summary className="text-sm text-primary-600 cursor-pointer select-none">
                ดูรายละเอียดรายโรงเรียน ({preview.perSchool.length} โรงเรียน)
              </summary>
              <div className="table-container border-0 mt-3 max-h-72 overflow-y-auto">
                <table className="table">
                  <thead>
                    <tr>
                      <th>โรงเรียน</th>
                      <th className="text-center">รอจัดกลุ่ม</th>
                      <th>กลุ่มปลายทาง</th>
                    </tr>
                  </thead>
                  <tbody>
                    {preview.perSchool.map((s) => (
                      <tr key={s.schoolName}>
                        <td>{s.schoolName}</td>
                        <td className="text-center">{s.pending}</td>
                        <td>
                          {s.willCreateGroup ? (
                            <span className="badge-info">สร้างกลุ่มใหม่</span>
                          ) : (
                            <span className="text-slate-500">ใช้กลุ่มเดิม</span>
                          )}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </details>
          )}
        </div>
      )}

      {/* Cards Grid */}
      {isLoading ? (
        <div className="flex items-center justify-center py-20">
          <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : groups?.length === 0 ? (
        <div className="card text-center py-20 text-slate-500">
          <FolderTree className="w-16 h-16 mx-auto text-slate-300 mb-4" />
          <p className="text-lg font-medium">ยังไม่มีกลุ่ม</p>
          <p className="text-sm mt-1">เริ่มต้นด้วยการเพิ่มกลุ่มใหม่</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {groups?.map((group) => (
            <motion.div
              key={group.id}
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              className="card-hover p-6"
            >
              <div className="flex items-start justify-between mb-4">
                <div className="w-12 h-12 bg-violet-100 rounded-xl flex items-center justify-center">
                  <FolderTree className="w-6 h-6 text-violet-600" />
                </div>
                <div className="flex gap-1">
                  <button
                    onClick={() => openModal(group)}
                    className="p-2 rounded-lg hover:bg-slate-100 text-slate-500"
                  >
                    <Edit size={16} />
                  </button>
                  <button
                    onClick={() => {
                      showConfirm(
                        'ต้องการลบกลุ่มนี้หรือไม่?',
                        () => deleteMutation.mutate(group.id),
                      );
                    }}
                    className="p-2 rounded-lg hover:bg-red-50 text-slate-500 hover:text-red-600"
                  >
                    <Trash2 size={16} />
                  </button>
                </div>
              </div>

              <h3 className="font-semibold text-slate-900 mb-1">{group.name}</h3>
              <p className="text-sm text-slate-500 mb-2">รหัส: {group.code}</p>
              
              <div className="flex items-center gap-2 text-sm text-slate-500 mb-3">
                <Building2 size={14} />
                <span>{group.school.name}</span>
              </div>

              {group.leader && (
                <p className="text-sm text-slate-600 mb-3">
                  หัวหน้ากลุ่ม: {group.leader.associationMember?.firstName} {group.leader.associationMember?.lastName}
                </p>
              )}

              <div className="flex items-center gap-1.5 text-sm text-slate-600 pt-3 border-t border-slate-100">
                <Users size={16} className="text-slate-400" />
                <span>{group._count?.members || 0} สมาชิก</span>
              </div>
            </motion.div>
          ))}
        </div>
      )}

      {/* Modal */}
      <AnimatePresence>
        {modalOpen && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
            onClick={closeModal}
          >
            <motion.div
              initial={{ opacity: 0, scale: 0.95, y: 20 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.95, y: 20 }}
              className="bg-white rounded-2xl w-full max-w-md p-6 shadow-xl"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="flex items-center justify-between mb-6">
                <h2 className="text-xl font-semibold">
                  {editingGroup ? 'แก้ไขกลุ่ม' : 'เพิ่มกลุ่ม'}
                </h2>
                <button onClick={closeModal} className="p-2 hover:bg-slate-100 rounded-lg">
                  <X size={20} />
                </button>
              </div>

              <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
                <div>
                  <label className="label">โรงเรียน</label>
                  <select
                    {...register('schoolId', { required: 'กรุณาเลือกโรงเรียน' })}
                    className="input"
                    disabled={!!editingGroup}
                  >
                    <option value="">เลือกโรงเรียน</option>
                    {schools?.map((school) => (
                      <option key={school.id} value={school.id}>
                        {school.name}
                      </option>
                    ))}
                  </select>
                  {errors.schoolId && (
                    <p className="text-sm text-red-500 mt-1">{errors.schoolId.message}</p>
                  )}
                </div>

                <div>
                  <label className="label">รหัสกลุ่ม</label>
                  <input
                    {...register('code', { required: 'กรุณากรอกรหัสกลุ่ม' })}
                    className="input"
                    placeholder="เช่น G01"
                  />
                  {errors.code && (
                    <p className="text-sm text-red-500 mt-1">{errors.code.message}</p>
                  )}
                </div>

                <div>
                  <label className="label">ชื่อกลุ่ม</label>
                  <input
                    {...register('name', { required: 'กรุณากรอกชื่อกลุ่ม' })}
                    className="input"
                    placeholder="ชื่อกลุ่ม"
                  />
                  {errors.name && (
                    <p className="text-sm text-red-500 mt-1">{errors.name.message}</p>
                  )}
                </div>

                <div className="flex gap-3 pt-4">
                  <button type="button" onClick={closeModal} className="btn-secondary flex-1">
                    ยกเลิก
                  </button>
                  <button
                    type="submit"
                    className="btn-primary flex-1"
                    disabled={createMutation.isPending || updateMutation.isPending}
                  >
                    {createMutation.isPending || updateMutation.isPending ? (
                      <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                    ) : (
                      'บันทึก'
                    )}
                  </button>
                </div>
              </form>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  );
}

