'use client';

import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion, AnimatePresence } from 'framer-motion';
import { Plus, Building2, Edit, Trash2, X, Users, FolderTree } from 'lucide-react';
import { useForm } from 'react-hook-form';
import { showSuccess, showError, showConfirm } from '@/lib/toast';
import { api, type School } from '@/lib/api';

interface SchoolForm {
  code: string;
  name: string;
  district?: string;
  province?: string;
}

export default function SchoolsPage() {
  const queryClient = useQueryClient();
  const [modalOpen, setModalOpen] = useState(false);
  const [editingSchool, setEditingSchool] = useState<School | null>(null);

  const { register, handleSubmit, reset, formState: { errors } } = useForm<SchoolForm>();

  const { data: schools, isLoading } = useQuery<School[]>({
    queryKey: ['schools'],
    queryFn: async () => {
      const response = await api.get('/schools');
      return response.data;
    },
  });

  const createMutation = useMutation({
    mutationFn: (data: SchoolForm) => api.post('/schools', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['schools'] });
      showSuccess('เพิ่มโรงเรียนสำเร็จ');
      closeModal();
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<SchoolForm> }) =>
      api.patch(`/schools/${id}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['schools'] });
      showSuccess('แก้ไขข้อมูลสำเร็จ');
      closeModal();
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/schools/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['schools'] });
      showSuccess('ปิดใช้งานโรงเรียนสำเร็จ');
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const openModal = (school?: School) => {
    if (school) {
      setEditingSchool(school);
      reset({
        code: school.code,
        name: school.name,
        district: school.district || '',
        province: school.province || '',
      });
    } else {
      setEditingSchool(null);
      reset({ code: '', name: '', district: '', province: '' });
    }
    setModalOpen(true);
  };

  const closeModal = () => {
    setModalOpen(false);
    setEditingSchool(null);
    reset();
  };

  const onSubmit = (data: SchoolForm) => {
    if (editingSchool) {
      // Don't send code when updating
      const { code, ...updateData } = data;
      updateMutation.mutate({ id: editingSchool.id, data: updateData });
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
            โรงเรียน
          </h1>
          <p className="text-slate-500 mt-1">
            จัดการข้อมูลโรงเรียนในสังกัด
          </p>
        </div>
        <button onClick={() => openModal()} className="btn-primary">
          <Plus size={20} />
          เพิ่มโรงเรียน
        </button>
      </div>

      {/* School cards */}
      {isLoading ? (
        <div className="flex items-center justify-center py-20">
          <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {schools?.map((school) => (
            <motion.div
              key={school.id}
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              className="card-hover p-6"
            >
              <div className="flex items-start justify-between mb-4">
                <div className="w-12 h-12 bg-primary-100 rounded-xl flex items-center justify-center">
                  <Building2 className="w-6 h-6 text-primary-600" />
                </div>
                <div className="flex gap-1">
                  <button
                    onClick={() => openModal(school)}
                    className="p-2 rounded-lg hover:bg-slate-100 text-slate-500"
                  >
                    <Edit size={16} />
                  </button>
                  <button
                    onClick={() => {
                      showConfirm(
                        'ต้องการปิดใช้งานโรงเรียนนี้หรือไม่?',
                        () => deleteMutation.mutate(school.id),
                      );
                    }}
                    className="p-2 rounded-lg hover:bg-red-50 text-slate-500 hover:text-red-600"
                  >
                    <Trash2 size={16} />
                  </button>
                </div>
              </div>

              <h3 className="font-semibold text-slate-900 mb-1">{school.name}</h3>
              <p className="text-sm text-slate-500 mb-4">
                รหัส: {school.code}
                {school.district && ` • ${school.district}`}
                {school.province && `, ${school.province}`}
              </p>

              <div className="flex gap-4 text-sm">
                <div className="flex items-center gap-1.5 text-slate-600">
                  <Users size={16} className="text-slate-400" />
                  <span>{school._count?.members || 0} สมาชิก</span>
                </div>
                <div className="flex items-center gap-1.5 text-slate-600">
                  <FolderTree size={16} className="text-slate-400" />
                  <span>{school._count?.groups || 0} กลุ่ม</span>
                </div>
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
                  {editingSchool ? 'แก้ไขโรงเรียน' : 'เพิ่มโรงเรียน'}
                </h2>
                <button onClick={closeModal} className="p-2 hover:bg-slate-100 rounded-lg">
                  <X size={20} />
                </button>
              </div>

              <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
                <div>
                  <label className="label">รหัสโรงเรียน</label>
                  <input
                    {...register('code', { required: 'กรุณากรอกรหัสโรงเรียน' })}
                    className="input"
                    placeholder="เช่น SCH001"
                    disabled={!!editingSchool}
                  />
                  {errors.code && (
                    <p className="text-sm text-red-500 mt-1">{errors.code.message}</p>
                  )}
                </div>

                <div>
                  <label className="label">ชื่อโรงเรียน</label>
                  <input
                    {...register('name', { required: 'กรุณากรอกชื่อโรงเรียน' })}
                    className="input"
                    placeholder="ชื่อโรงเรียน"
                  />
                  {errors.name && (
                    <p className="text-sm text-red-500 mt-1">{errors.name.message}</p>
                  )}
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="label">อำเภอ</label>
                    <input
                      {...register('district')}
                      className="input"
                      placeholder="อำเภอ"
                    />
                  </div>
                  <div>
                    <label className="label">จังหวัด</label>
                    <input
                      {...register('province')}
                      className="input"
                      placeholder="จังหวัด"
                    />
                  </div>
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

