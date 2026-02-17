'use client';

import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion, AnimatePresence } from 'framer-motion';
import { Plus, UserCog, Edit, Trash2, X, Shield, Building2 } from 'lucide-react';
import { useForm } from 'react-hook-form';
import { showSuccess, showError, showConfirm } from '@/lib/toast';
import { api, type School } from '@/lib/api';

interface User {
  id: string;
  username: string;
  fullName: string;
  role: string;
  schoolId?: string;
  school?: School;
}

interface UserForm {
  username: string;
  password: string;
  fullName: string;
  role: string;
  schoolId?: string;
}

const roleLabels: Record<string, string> = {
  ADMIN: 'ผู้ดูแลระบบ',
  FINANCE: 'เจ้าหน้าที่การเงิน',
  ACCOUNTING: 'เจ้าหน้าที่บัญชี',
  GROUP_LEADER: 'หัวหน้ากลุ่ม',
  VIEWER: 'ผู้ดูข้อมูล',
};

const roleColors: Record<string, string> = {
  ADMIN: 'badge-danger',
  FINANCE: 'badge-success',
  ACCOUNTING: 'badge-info',
  GROUP_LEADER: 'badge-warning',
  VIEWER: 'badge-neutral',
};

export default function UsersPage() {
  const queryClient = useQueryClient();
  const [modalOpen, setModalOpen] = useState(false);
  const [editingUser, setEditingUser] = useState<User | null>(null);

  const { register, handleSubmit, reset, formState: { errors } } = useForm<UserForm>();

  const { data: users, isLoading } = useQuery<User[]>({
    queryKey: ['users'],
    queryFn: async () => {
      const response = await api.get('/users');
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

  const createMutation = useMutation({
    mutationFn: (data: UserForm) => api.post('/users', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
      showSuccess('เพิ่มผู้ใช้สำเร็จ');
      closeModal();
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<UserForm> }) =>
      api.patch(`/users/${id}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
      showSuccess('แก้ไขข้อมูลสำเร็จ');
      closeModal();
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/users/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
      showSuccess('ลบผู้ใช้สำเร็จ');
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const openModal = (user?: User) => {
    if (user) {
      setEditingUser(user);
      reset({
        username: user.username,
        password: '',
        fullName: user.fullName,
        role: user.role,
        schoolId: user.schoolId || '',
      });
    } else {
      setEditingUser(null);
      reset({ username: '', password: '', fullName: '', role: 'VIEWER', schoolId: '' });
    }
    setModalOpen(true);
  };

  const closeModal = () => {
    setModalOpen(false);
    setEditingUser(null);
    reset();
  };

  const onSubmit = (data: UserForm) => {
    const submitData: Record<string, any> = {
      username: data.username,
      fullName: data.fullName,
      role: data.role,
    };
    
    // Only include schoolId if it has a value
    if (data.schoolId && data.schoolId.trim() !== '') {
      submitData.schoolId = data.schoolId;
    }
    
    if (editingUser) {
      // Only include password if it's provided
      if (data.password && data.password.trim() !== '') {
        submitData.password = data.password;
      }
      delete submitData.username; // Don't update username
      updateMutation.mutate({ id: editingUser.id, data: submitData });
    } else {
      submitData.password = data.password;
      createMutation.mutate(submitData as UserForm);
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
            จัดการผู้ใช้งาน
          </h1>
          <p className="text-slate-500 mt-1">
            เพิ่ม แก้ไข และจัดการสิทธิ์ผู้ใช้งานระบบ
          </p>
        </div>
        <button onClick={() => openModal()} className="btn-primary">
          <Plus size={20} />
          เพิ่มผู้ใช้
        </button>
      </div>

      {/* Table */}
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
                  <th>ชื่อผู้ใช้</th>
                  <th>ชื่อ-นามสกุล</th>
                  <th>บทบาท</th>
                  <th>โรงเรียน</th>
                  <th className="text-right">จัดการ</th>
                </tr>
              </thead>
              <tbody>
                {users?.map((user) => (
                  <tr key={user.id}>
                    <td className="font-mono text-sm">{user.username}</td>
                    <td className="font-medium">{user.fullName}</td>
                    <td>
                      <span className={roleColors[user.role]}>
                        {roleLabels[user.role]}
                      </span>
                    </td>
                    <td className="text-slate-500">
                      {user.school?.name || 'ทุกโรงเรียน'}
                    </td>
                    <td>
                      <div className="flex justify-end gap-1">
                        <button
                          onClick={() => openModal(user)}
                          className="p-2 rounded-lg hover:bg-slate-100 text-slate-500 hover:text-slate-700"
                        >
                          <Edit size={18} />
                        </button>
                        <button
                          onClick={() => {
                            showConfirm(
                              'ต้องการลบผู้ใช้นี้หรือไม่?',
                              () => deleteMutation.mutate(user.id),
                            );
                          }}
                          className="p-2 rounded-lg hover:bg-red-50 text-slate-500 hover:text-red-600"
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
        )}
      </div>

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
                  {editingUser ? 'แก้ไขผู้ใช้' : 'เพิ่มผู้ใช้'}
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
                    placeholder="username"
                    disabled={!!editingUser}
                  />
                  {errors.username && (
                    <p className="text-sm text-red-500 mt-1">{errors.username.message}</p>
                  )}
                </div>

                <div>
                  <label className="label">
                    รหัสผ่าน {editingUser && <span className="text-slate-400">(เว้นว่างหากไม่ต้องการเปลี่ยน)</span>}
                  </label>
                  <input
                    {...register('password', { 
                      required: editingUser ? false : 'กรุณากรอกรหัสผ่าน',
                      minLength: { value: 4, message: 'รหัสผ่านต้องมีอย่างน้อย 4 ตัวอักษร' }
                    })}
                    type="password"
                    className="input"
                    placeholder="••••••"
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

                <div>
                  <label className="label">บทบาท</label>
                  <select {...register('role')} className="input">
                    <option value="ADMIN">ผู้ดูแลระบบ</option>
                    <option value="FINANCE">เจ้าหน้าที่การเงิน</option>
                    <option value="ACCOUNTING">เจ้าหน้าที่บัญชี</option>
                    <option value="GROUP_LEADER">หัวหน้ากลุ่ม</option>
                    <option value="VIEWER">ผู้ดูข้อมูล</option>
                  </select>
                </div>

                <div>
                  <label className="label">โรงเรียน (ถ้าไม่เลือก = ทุกโรงเรียน)</label>
                  <select {...register('schoolId')} className="input">
                    <option value="">ทุกโรงเรียน</option>
                    {schools?.map((school) => (
                      <option key={school.id} value={school.id}>
                        {school.name}
                      </option>
                    ))}
                  </select>
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

