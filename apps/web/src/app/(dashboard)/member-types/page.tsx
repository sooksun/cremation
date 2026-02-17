'use client';

import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion, AnimatePresence } from 'framer-motion';
import { Plus, Tags, Edit, Trash2, X, Users } from 'lucide-react';
import { useForm } from 'react-hook-form';
import { showSuccess, showError, showConfirm } from '@/lib/toast';
import { api, type MemberType } from '@/lib/api';

interface MemberTypeWithCount extends MemberType {
  _count?: { members: number };
}

interface MemberTypeForm {
  code: string;
  name: string;
  description?: string;
}

export default function MemberTypesPage() {
  const queryClient = useQueryClient();
  const [modalOpen, setModalOpen] = useState(false);
  const [editingType, setEditingType] = useState<MemberTypeWithCount | null>(null);

  const { register, handleSubmit, reset, formState: { errors } } = useForm<MemberTypeForm>();

  const { data: memberTypes, isLoading } = useQuery<MemberTypeWithCount[]>({
    queryKey: ['member-types'],
    queryFn: async () => {
      const response = await api.get('/member-types');
      return response.data;
    },
  });

  const createMutation = useMutation({
    mutationFn: (data: MemberTypeForm) => api.post('/member-types', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['member-types'] });
      showSuccess('เพิ่มประเภทสมาชิกสำเร็จ');
      closeModal();
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<MemberTypeForm> }) =>
      api.patch(`/member-types/${id}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['member-types'] });
      showSuccess('แก้ไขข้อมูลสำเร็จ');
      closeModal();
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/member-types/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['member-types'] });
      showSuccess('ปิดใช้งานประเภทสมาชิกสำเร็จ');
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const openModal = (type?: MemberTypeWithCount) => {
    if (type) {
      setEditingType(type);
      reset({
        code: type.code,
        name: type.name,
        description: type.description || '',
      });
    } else {
      setEditingType(null);
      reset({ code: '', name: '', description: '' });
    }
    setModalOpen(true);
  };

  const closeModal = () => {
    setModalOpen(false);
    setEditingType(null);
    reset();
  };

  const onSubmit = (data: MemberTypeForm) => {
    if (editingType) {
      // Don't send code when updating
      const { code, ...updateData } = data;
      updateMutation.mutate({ id: editingType.id, data: updateData });
    } else {
      createMutation.mutate(data);
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
            ประเภทสมาชิก
          </h1>
          <p className="text-slate-500 mt-1">
            จัดการประเภทสมาชิกของสมาคม เช่น ครูประจำการ ครูเกษียณ
          </p>
        </div>
        <button onClick={() => openModal()} className="btn-primary">
          <Plus size={20} />
          เพิ่มประเภท
        </button>
      </div>

      {/* Cards Grid */}
      {isLoading ? (
        <div className="flex items-center justify-center py-20">
          <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {memberTypes?.map((type) => (
            <motion.div
              key={type.id}
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              className="card-hover p-6"
            >
              <div className="flex items-start justify-between mb-4">
                <div className="w-12 h-12 bg-amber-100 rounded-xl flex items-center justify-center">
                  <Tags className="w-6 h-6 text-amber-600" />
                </div>
                <div className="flex gap-1">
                  <button
                    onClick={() => openModal(type)}
                    className="p-2 rounded-lg hover:bg-slate-100 text-slate-500"
                  >
                    <Edit size={16} />
                  </button>
                  <button
                    onClick={() => {
                      showConfirm(
                        'ต้องการปิดใช้งานประเภทสมาชิกนี้หรือไม่?',
                        () => deleteMutation.mutate(type.id),
                      );
                    }}
                    className="p-2 rounded-lg hover:bg-red-50 text-slate-500 hover:text-red-600"
                  >
                    <Trash2 size={16} />
                  </button>
                </div>
              </div>

              <h3 className="font-semibold text-slate-900 mb-1">{type.name}</h3>
              <p className="text-sm text-slate-500 mb-2">รหัส: {type.code}</p>
              {type.description && (
                <p className="text-sm text-slate-500 mb-4">{type.description}</p>
              )}

              <div className="flex items-center gap-1.5 text-sm text-slate-600">
                <Users size={16} className="text-slate-400" />
                <span>{type._count?.members || 0} สมาชิก</span>
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
                  {editingType ? 'แก้ไขประเภทสมาชิก' : 'เพิ่มประเภทสมาชิก'}
                </h2>
                <button onClick={closeModal} className="p-2 hover:bg-slate-100 rounded-lg">
                  <X size={20} />
                </button>
              </div>

              <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
                <div>
                  <label className="label">รหัสประเภท</label>
                  <input
                    {...register('code', { required: 'กรุณากรอกรหัสประเภท' })}
                    className="input"
                    placeholder="เช่น REG, RET"
                    disabled={!!editingType}
                  />
                  {errors.code && (
                    <p className="text-sm text-red-500 mt-1">{errors.code.message}</p>
                  )}
                </div>

                <div>
                  <label className="label">ชื่อประเภท</label>
                  <input
                    {...register('name', { required: 'กรุณากรอกชื่อประเภท' })}
                    className="input"
                    placeholder="เช่น ครูประจำการ"
                  />
                  {errors.name && (
                    <p className="text-sm text-red-500 mt-1">{errors.name.message}</p>
                  )}
                </div>

                <div>
                  <label className="label">คำอธิบาย</label>
                  <textarea
                    {...register('description')}
                    className="input"
                    rows={3}
                    placeholder="รายละเอียดเพิ่มเติม (ไม่บังคับ)"
                  />
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


