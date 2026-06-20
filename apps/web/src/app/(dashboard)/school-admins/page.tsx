'use client';

import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion, AnimatePresence } from 'framer-motion';
import { Plus, Edit, Trash2, X, Building2, UserCog } from 'lucide-react';
import { useForm } from 'react-hook-form';
import { showSuccess, showError, showConfirm } from '@/lib/toast';
import { api } from '@/lib/api';

interface SchoolInfo {
  id: string;
  code: string;
  name: string;
  district?: string;
  province?: string;
}

interface SchoolAdminInfo {
  id: string;
  username: string;
  fullName: string;
  mustChangePassword?: boolean;
}

interface SchoolAdminRow {
  school: SchoolInfo;
  admin: SchoolAdminInfo | null;
}

interface SchoolAdminForm {
  username: string;
  password: string;
  fullName: string;
}

export default function SchoolAdminsPage() {
  const queryClient = useQueryClient();
  const [modalOpen, setModalOpen] = useState(false);
  const [editingRow, setEditingRow] = useState<SchoolAdminRow | null>(null);

  const { register, handleSubmit, reset, formState: { errors } } = useForm<SchoolAdminForm>();

  const { data: rows, isLoading } = useQuery<SchoolAdminRow[]>({
    queryKey: ['school-admins'],
    queryFn: async () => {
      const response = await api.get('/school-admins');
      return response.data;
    },
  });

  const createMutation = useMutation({
    mutationFn: (payload: { schoolId: string; data: SchoolAdminForm }) =>
      api.post('/school-admins', {
        schoolId: payload.schoolId,
        ...payload.data,
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['school-admins'] });
      showSuccess('เพิ่มผู้ดูแลโรงเรียนสำเร็จ');
      closeModal();
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const updateMutation = useMutation({
    mutationFn: (payload: { schoolId: string; data: Partial<SchoolAdminForm> }) =>
      api.patch(`/school-admins/by-school/${payload.schoolId}`, payload.data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['school-admins'] });
      showSuccess('แก้ไขข้อมูลสำเร็จ');
      closeModal();
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const deleteMutation = useMutation({
    mutationFn: (schoolId: string) => api.delete(`/school-admins/by-school/${schoolId}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['school-admins'] });
      showSuccess('ลบผู้ดูแลโรงเรียนสำเร็จ');
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const openModal = (row: SchoolAdminRow) => {
    setEditingRow(row);
    if (row.admin) {
      reset({
        username: row.admin.username,
        password: '',
        fullName: row.admin.fullName,
      });
    } else {
      reset({
        username: `admin-${row.school.code.toLowerCase()}`,
        password: '',
        fullName: `ผู้ดูแล ${row.school.name}`,
      });
    }
    setModalOpen(true);
  };

  const closeModal = () => {
    setModalOpen(false);
    setEditingRow(null);
    reset();
  };

  const onSubmit = (data: SchoolAdminForm) => {
    if (!editingRow) return;

    if (editingRow.admin) {
      const submitData: Partial<SchoolAdminForm> = {
        fullName: data.fullName,
        username: data.username,
      };
      if (data.password?.trim()) {
        submitData.password = data.password;
      }
      updateMutation.mutate({ schoolId: editingRow.school.id, data: submitData });
    } else {
      createMutation.mutate({ schoolId: editingRow.school.id, data });
    }
  };

  const withAdmin = rows?.filter((row) => row.admin) ?? [];
  const withoutAdmin = rows?.filter((row) => !row.admin) ?? [];

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      className="space-y-6"
    >
      <div>
        <h1 className="text-2xl font-display font-bold text-slate-900">
          ผู้ดูแลโรงเรียน
        </h1>
        <p className="text-slate-500 mt-1">
          บัญชีผู้ดูแลแยกจากสมาชิก — กำหนดโรงเรียนละ 1 ผู้ใช้
        </p>
      </div>

      {withoutAdmin.length > 0 && (
        <div className="card p-4 border-amber-200 bg-amber-50">
          <p className="text-amber-800 text-sm">
            มี {withoutAdmin.length} โรงเรียนที่ยังไม่มีผู้ดูแล — กรุณาเพิ่มบัญชีให้ครบ
          </p>
        </div>
      )}

      <div className="card overflow-hidden">
        {isLoading ? (
          <div className="flex items-center justify-center py-20">
            <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
          </div>
        ) : (
          <div className="table-container border-0">
            <table className="table">
              <thead>
                <tr>
                  <th>รหัสโรงเรียน</th>
                  <th>ชื่อโรงเรียน</th>
                  <th>ชื่อผู้ใช้</th>
                  <th>ชื่อ-นามสกุล</th>
                  <th>สถานะ</th>
                  <th className="text-right">จัดการ</th>
                </tr>
              </thead>
              <tbody>
                {rows?.map((row) => (
                  <tr key={row.school.id}>
                    <td className="font-mono text-sm">{row.school.code}</td>
                    <td className="font-medium">{row.school.name}</td>
                    <td className="font-mono text-sm text-slate-600">
                      {row.admin?.username || '-'}
                    </td>
                    <td>{row.admin?.fullName || '-'}</td>
                    <td>
                      {row.admin ? (
                        <span className="badge-success">มีผู้ดูแลแล้ว</span>
                      ) : (
                        <span className="badge-warning">ยังไม่มีผู้ดูแล</span>
                      )}
                    </td>
                    <td>
                      <div className="flex justify-end gap-1">
                        <button
                          onClick={() => openModal(row)}
                          className="p-2 rounded-lg hover:bg-slate-100 text-slate-500 hover:text-slate-700"
                          title={row.admin ? 'แก้ไข' : 'เพิ่มผู้ดูแล'}
                        >
                          {row.admin ? <Edit size={18} /> : <Plus size={18} />}
                        </button>
                        {row.admin && (
                          <button
                            onClick={() => {
                              showConfirm(
                                `ต้องการลบผู้ดูแลของ ${row.school.name} หรือไม่?`,
                                () => deleteMutation.mutate(row.school.id),
                              );
                            }}
                            className="p-2 rounded-lg hover:bg-red-50 text-slate-500 hover:text-red-600"
                          >
                            <Trash2 size={18} />
                          </button>
                        )}
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      <div className="grid md:grid-cols-2 gap-4">
        <div className="card p-4 flex items-start gap-3">
          <Building2 className="text-primary-600 mt-0.5" size={20} />
          <div>
            <p className="font-medium text-slate-900">โรงเรียนที่มีผู้ดูแลแล้ว</p>
            <p className="text-2xl font-bold text-primary-700">{withAdmin.length}</p>
          </div>
        </div>
        <div className="card p-4 flex items-start gap-3">
          <UserCog className="text-amber-600 mt-0.5" size={20} />
          <div>
            <p className="font-medium text-slate-900">โรงเรียนที่ยังไม่มีผู้ดูแล</p>
            <p className="text-2xl font-bold text-amber-700">{withoutAdmin.length}</p>
          </div>
        </div>
      </div>

      <AnimatePresence>
        {modalOpen && editingRow && (
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
                  {editingRow.admin ? 'แก้ไขผู้ดูแล' : 'เพิ่มผู้ดูแล'} — {editingRow.school.name}
                </h2>
                <button onClick={closeModal} className="p-2 hover:bg-slate-100 rounded-lg">
                  <X size={20} />
                </button>
              </div>

              <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
                <div>
                  <label className="label">ชื่อผู้ใช้</label>
                  <input
                    {...register('username', { required: 'กรุณากรอกชื่อผู้ใช้' })}
                    className="input"
                    placeholder="admin-sch001"
                  />
                  {errors.username && (
                    <p className="text-sm text-red-500 mt-1">{errors.username.message}</p>
                  )}
                </div>

                <div>
                  <label className="label">
                    รหัสผ่าน{' '}
                    {editingRow.admin && (
                      <span className="text-slate-400">(เว้นว่างหากไม่ต้องการเปลี่ยน)</span>
                    )}
                  </label>
                  <input
                    {...register('password', {
                      required: editingRow.admin ? false : 'กรุณากรอกรหัสผ่าน',
                      minLength: { value: 8, message: 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร' },
                    })}
                    type="password"
                    className="input"
                    placeholder="••••••••"
                  />
                  {errors.password && (
                    <p className="text-sm text-red-500 mt-1">{errors.password.message}</p>
                  )}
                </div>

                <div>
                  <label className="label">ชื่อ-นามสกุล</label>
                  <input
                    {...register('fullName', { required: 'กรุณากรอกชื่อ-นามสกุล' })}
                    className="input"
                    placeholder="ชื่อ นามสกุล"
                  />
                  {errors.fullName && (
                    <p className="text-sm text-red-500 mt-1">{errors.fullName.message}</p>
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