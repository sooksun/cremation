'use client';

import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion, AnimatePresence } from 'framer-motion';
import { Plus, BookOpen, Edit, Trash2, X, TrendingUp, TrendingDown, Wallet, Building } from 'lucide-react';
import { useForm } from 'react-hook-form';
import { showSuccess, showError, showConfirm } from '@/lib/toast';
import { api } from '@/lib/api';

interface Account {
  id: string;
  code: string;
  name: string;
  type: 'ASSET' | 'LIABILITY' | 'EQUITY' | 'INCOME' | 'EXPENSE';
  isActive: boolean;
}

interface AccountForm {
  code: string;
  name: string;
  type: string;
}

const typeLabels: Record<string, string> = {
  ASSET: 'สินทรัพย์',
  LIABILITY: 'หนี้สิน',
  EQUITY: 'ทุน',
  INCOME: 'รายได้',
  EXPENSE: 'ค่าใช้จ่าย',
};

const typeIcons: Record<string, React.ReactNode> = {
  ASSET: <Wallet className="w-6 h-6 text-emerald-600" />,
  LIABILITY: <Building className="w-6 h-6 text-red-600" />,
  EQUITY: <BookOpen className="w-6 h-6 text-purple-600" />,
  INCOME: <TrendingUp className="w-6 h-6 text-sky-600" />,
  EXPENSE: <TrendingDown className="w-6 h-6 text-amber-600" />,
};

const typeBgColors: Record<string, string> = {
  ASSET: 'bg-emerald-100',
  LIABILITY: 'bg-red-100',
  EQUITY: 'bg-purple-100',
  INCOME: 'bg-sky-100',
  EXPENSE: 'bg-amber-100',
};

export default function AccountsPage() {
  const queryClient = useQueryClient();
  const [modalOpen, setModalOpen] = useState(false);
  const [editingAccount, setEditingAccount] = useState<Account | null>(null);
  const [filterType, setFilterType] = useState<string>('');

  const { register, handleSubmit, reset, formState: { errors } } = useForm<AccountForm>();

  const { data: accounts, isLoading } = useQuery<Account[]>({
    queryKey: ['accounts', filterType],
    queryFn: async () => {
      const params = filterType ? `?type=${filterType}` : '';
      const response = await api.get(`/accounts${params}`);
      return response.data;
    },
  });

  const createMutation = useMutation({
    mutationFn: (data: AccountForm) => api.post('/accounts', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['accounts'] });
      showSuccess('เพิ่มบัญชีสำเร็จ');
      closeModal();
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<AccountForm> }) =>
      api.patch(`/accounts/${id}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['accounts'] });
      showSuccess('แก้ไขข้อมูลสำเร็จ');
      closeModal();
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/accounts/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['accounts'] });
      showSuccess('ปิดใช้งานบัญชีสำเร็จ');
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const openModal = (account?: Account) => {
    if (account) {
      setEditingAccount(account);
      reset({
        code: account.code,
        name: account.name,
        type: account.type,
      });
    } else {
      setEditingAccount(null);
      reset({ code: '', name: '', type: 'ASSET' });
    }
    setModalOpen(true);
  };

  const closeModal = () => {
    setModalOpen(false);
    setEditingAccount(null);
    reset();
  };

  const onSubmit = (data: AccountForm) => {
    if (editingAccount) {
      // Only send name when editing (code and type are disabled)
      const updateData = { name: data.name };
      updateMutation.mutate({ id: editingAccount.id, data: updateData });
    } else {
      createMutation.mutate(data);
    }
  };

  // Group accounts by type
  const groupedAccounts = accounts?.reduce((acc, account) => {
    if (!acc[account.type]) acc[account.type] = [];
    acc[account.type].push(account);
    return acc;
  }, {} as Record<string, Account[]>);

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
            ผังบัญชี
          </h1>
          <p className="text-slate-500 mt-1">
            จัดการผังบัญชีสำหรับการบันทึกบัญชี
          </p>
        </div>
        <button onClick={() => openModal()} className="btn-primary">
          <Plus size={20} />
          เพิ่มบัญชี
        </button>
      </div>

      {/* Filter */}
      <div className="flex gap-2 flex-wrap">
        <button
          onClick={() => setFilterType('')}
          className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
            filterType === '' ? 'bg-primary-100 text-primary-700' : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
          }`}
        >
          ทั้งหมด
        </button>
        {Object.entries(typeLabels).map(([type, label]) => (
          <button
            key={type}
            onClick={() => setFilterType(type)}
            className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
              filterType === type ? 'bg-primary-100 text-primary-700' : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
            }`}
          >
            {label}
          </button>
        ))}
      </div>

      {/* Accounts List */}
      {isLoading ? (
        <div className="flex items-center justify-center py-20">
          <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : filterType ? (
        <div className="card overflow-hidden">
          <div className="table-container border-0">
            <table className="table">
              <thead>
                <tr>
                  <th>รหัส</th>
                  <th>ชื่อบัญชี</th>
                  <th>ประเภท</th>
                  <th className="text-right">จัดการ</th>
                </tr>
              </thead>
              <tbody>
                {accounts?.map((account) => (
                  <tr key={account.id}>
                    <td className="font-mono">{account.code}</td>
                    <td className="font-medium">{account.name}</td>
                    <td>
                      <span className="badge-neutral">{typeLabels[account.type]}</span>
                    </td>
                    <td>
                      <div className="flex justify-end gap-1">
                        <button
                          onClick={() => openModal(account)}
                          className="p-2 rounded-lg hover:bg-slate-100 text-slate-500"
                        >
                          <Edit size={18} />
                        </button>
                        <button
                          onClick={() => {
                            showConfirm(
                              'ต้องการปิดใช้งานบัญชีนี้หรือไม่?',
                              () => deleteMutation.mutate(account.id),
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
        </div>
      ) : (
        <div className="space-y-6">
          {Object.entries(typeLabels).map(([type, label]) => {
            const typeAccounts = groupedAccounts?.[type] || [];
            if (typeAccounts.length === 0) return null;

            return (
              <div key={type} className="card overflow-hidden">
                <div className="px-4 py-3 bg-slate-50 border-b border-slate-200 flex items-center gap-2">
                  <div className={`w-8 h-8 rounded-lg flex items-center justify-center ${typeBgColors[type]}`}>
                    {typeIcons[type]}
                  </div>
                  <h3 className="font-semibold text-slate-900">{label}</h3>
                  <span className="badge-neutral ml-2">{typeAccounts.length}</span>
                </div>
                <div className="divide-y divide-slate-100">
                  {typeAccounts.map((account) => (
                    <div key={account.id} className="px-4 py-3 flex items-center justify-between hover:bg-slate-50">
                      <div className="flex items-center gap-4">
                        <span className="font-mono text-sm text-slate-500 w-16">{account.code}</span>
                        <span className="font-medium text-slate-900">{account.name}</span>
                      </div>
                      <div className="flex gap-1">
                        <button
                          onClick={() => openModal(account)}
                          className="p-2 rounded-lg hover:bg-slate-100 text-slate-500"
                        >
                          <Edit size={16} />
                        </button>
                        <button
                          onClick={() => {
                            showConfirm(
                              'ต้องการปิดใช้งานบัญชีนี้หรือไม่?',
                              () => deleteMutation.mutate(account.id),
                            );
                          }}
                          className="p-2 rounded-lg hover:bg-red-50 text-slate-500 hover:text-red-600"
                        >
                          <Trash2 size={16} />
                        </button>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            );
          })}
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
                  {editingAccount ? 'แก้ไขบัญชี' : 'เพิ่มบัญชี'}
                </h2>
                <button onClick={closeModal} className="p-2 hover:bg-slate-100 rounded-lg">
                  <X size={20} />
                </button>
              </div>

              <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
                <div>
                  <label className="label">รหัสบัญชี</label>
                  <input
                    {...register('code', { required: 'กรุณากรอกรหัสบัญชี' })}
                    className="input"
                    placeholder="เช่น 101"
                    disabled={!!editingAccount}
                  />
                  {errors.code && (
                    <p className="text-sm text-red-500 mt-1">{errors.code.message}</p>
                  )}
                </div>

                <div>
                  <label className="label">ชื่อบัญชี</label>
                  <input
                    {...register('name', { required: 'กรุณากรอกชื่อบัญชี' })}
                    className="input"
                    placeholder="ชื่อบัญชี"
                  />
                  {errors.name && (
                    <p className="text-sm text-red-500 mt-1">{errors.name.message}</p>
                  )}
                </div>

                <div>
                  <label className="label">ประเภทบัญชี</label>
                  <select {...register('type')} className="input" disabled={!!editingAccount}>
                    {Object.entries(typeLabels).map(([type, label]) => (
                      <option key={type} value={type}>{label}</option>
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

