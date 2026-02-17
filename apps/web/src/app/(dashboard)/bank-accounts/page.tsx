'use client';

import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion, AnimatePresence } from 'framer-motion';
import { Plus, Landmark, Edit, Trash2, X, Star, CreditCard, Wallet } from 'lucide-react';
import { useForm } from 'react-hook-form';
import { showSuccess, showError, showConfirm } from '@/lib/toast';
import { api } from '@/lib/api';

interface BankAccount {
  id: string;
  bankName: string;
  accountNo: string;
  accountName: string;
  description?: string;
  isActive: boolean;
  isDefault: boolean;
}

interface BankAccountForm {
  bankName: string;
  accountNo: string;
  accountName: string;
  description?: string;
  isDefault?: boolean;
}

interface AccountBalance {
  totalDeposits: number;
  totalWithdrawals: number;
  balance: number;
}

export default function BankAccountsPage() {
  const queryClient = useQueryClient();
  const [modalOpen, setModalOpen] = useState(false);
  const [editingAccount, setEditingAccount] = useState<BankAccount | null>(null);

  const { register, handleSubmit, reset, formState: { errors } } = useForm<BankAccountForm>();

  const { data: bankAccounts, isLoading } = useQuery<BankAccount[]>({
    queryKey: ['bank-accounts'],
    queryFn: async () => {
      const response = await api.get('/bank-accounts?includeInactive=true');
      return response.data;
    },
  });

  // Get balance for each account
  const { data: balances } = useQuery<Record<string, AccountBalance>>({
    queryKey: ['bank-account-balances', bankAccounts?.map(a => a.id)],
    queryFn: async () => {
      if (!bankAccounts || bankAccounts.length === 0) return {};
      const results: Record<string, AccountBalance> = {};
      await Promise.all(
        bankAccounts.map(async (account) => {
          try {
            const response = await api.get(`/bank-accounts/${account.id}/balance`);
            results[account.id] = response.data;
          } catch {
            results[account.id] = { totalDeposits: 0, totalWithdrawals: 0, balance: 0 };
          }
        })
      );
      return results;
    },
    enabled: !!bankAccounts && bankAccounts.length > 0,
  });

  const createMutation = useMutation({
    mutationFn: (data: BankAccountForm) => api.post('/bank-accounts', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['bank-accounts'] });
      showSuccess('เพิ่มบัญชีธนาคารสำเร็จ');
      closeModal();
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<BankAccountForm> }) =>
      api.patch(`/bank-accounts/${id}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['bank-accounts'] });
      showSuccess('แก้ไขข้อมูลสำเร็จ');
      closeModal();
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/bank-accounts/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['bank-accounts'] });
      showSuccess('ปิดใช้งานบัญชีธนาคารสำเร็จ');
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const setDefaultMutation = useMutation({
    mutationFn: (id: string) => api.patch(`/bank-accounts/${id}/set-default`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['bank-accounts'] });
      showSuccess('ตั้งเป็นบัญชีหลักสำเร็จ');
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const openModal = (account?: BankAccount) => {
    if (account) {
      setEditingAccount(account);
      reset({
        bankName: account.bankName,
        accountNo: account.accountNo,
        accountName: account.accountName,
        description: account.description || '',
        isDefault: account.isDefault,
      });
    } else {
      setEditingAccount(null);
      reset({ bankName: '', accountNo: '', accountName: '', description: '', isDefault: false });
    }
    setModalOpen(true);
  };

  const closeModal = () => {
    setModalOpen(false);
    setEditingAccount(null);
    reset();
  };

  const onSubmit = (data: BankAccountForm) => {
    if (editingAccount) {
      updateMutation.mutate({ id: editingAccount.id, data });
    } else {
      createMutation.mutate(data);
    }
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('th-TH', {
      style: 'currency',
      currency: 'THB',
      minimumFractionDigits: 0,
    }).format(amount);
  };

  // Calculate totals
  const totalBalance = bankAccounts?.reduce((sum, account) => {
    return sum + (balances?.[account.id]?.balance || 0);
  }, 0) || 0;

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
            บัญชีธนาคาร
          </h1>
          <p className="text-slate-500 mt-1">
            จัดการบัญชีธนาคารกลางของกองทุนฌาปนกิจสงเคราะห์
          </p>
        </div>
        <button onClick={() => openModal()} className="btn-primary">
          <Plus size={20} />
          เพิ่มบัญชี
        </button>
      </div>

      {/* Summary Card */}
      <div className="card p-6 bg-gradient-to-r from-sky-500 to-sky-600 text-white">
        <div className="flex items-center gap-4">
          <div className="w-14 h-14 bg-white/20 rounded-2xl flex items-center justify-center">
            <Wallet className="w-7 h-7" />
          </div>
          <div>
            <p className="text-sky-100">ยอดรวมทุกบัญชี</p>
            <p className="text-3xl font-bold">{formatCurrency(totalBalance)}</p>
          </div>
        </div>
      </div>

      {/* Cards Grid */}
      {isLoading ? (
        <div className="flex items-center justify-center py-20">
          <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : bankAccounts?.length === 0 ? (
        <div className="card text-center py-20 text-slate-500">
          <Landmark className="w-16 h-16 mx-auto text-slate-300 mb-4" />
          <p className="text-lg font-medium">ยังไม่มีบัญชีธนาคาร</p>
          <p className="text-sm mt-1">เริ่มต้นด้วยการเพิ่มบัญชีธนาคารกลางของกองทุน</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {bankAccounts?.map((account) => (
            <motion.div
              key={account.id}
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              className={`card-hover p-6 ${!account.isActive ? 'opacity-60' : ''} ${
                account.isDefault ? 'ring-2 ring-sky-500' : ''
              }`}
            >
              <div className="flex items-start justify-between mb-4">
                <div className="w-12 h-12 bg-sky-100 rounded-xl flex items-center justify-center">
                  <Landmark className="w-6 h-6 text-sky-600" />
                </div>
                <div className="flex gap-1">
                  {!account.isDefault && account.isActive && (
                    <button
                      onClick={() => setDefaultMutation.mutate(account.id)}
                      className="p-2 rounded-lg hover:bg-amber-50 text-slate-400 hover:text-amber-500"
                      title="ตั้งเป็นบัญชีหลัก"
                    >
                      <Star size={16} />
                    </button>
                  )}
                  <button
                    onClick={() => openModal(account)}
                    className="p-2 rounded-lg hover:bg-slate-100 text-slate-500"
                  >
                    <Edit size={16} />
                  </button>
                  {!account.isDefault && (
                    <button
                      onClick={() => {
                        showConfirm(
                          'ต้องการปิดใช้งานบัญชีธนาคารนี้หรือไม่?',
                          () => deleteMutation.mutate(account.id),
                        );
                      }}
                      className="p-2 rounded-lg hover:bg-red-50 text-slate-500 hover:text-red-600"
                    >
                      <Trash2 size={16} />
                    </button>
                  )}
                </div>
              </div>

              <div className="flex items-center gap-2 mb-2">
                <h3 className="font-semibold text-slate-900">{account.bankName}</h3>
                {account.isDefault && (
                  <span className="badge-success text-xs">บัญชีหลัก</span>
                )}
                {!account.isActive && (
                  <span className="badge-warning text-xs">ปิดใช้งาน</span>
                )}
              </div>
              <div className="flex items-center gap-2 text-sm text-slate-500 mb-2">
                <CreditCard size={14} />
                <span className="font-mono">{account.accountNo}</span>
              </div>
              <p className="text-sm text-slate-600 mb-1">{account.accountName}</p>
              {account.description && (
                <p className="text-xs text-slate-400 mb-3">{account.description}</p>
              )}
              
              {/* Balance */}
              <div className="pt-3 mt-3 border-t border-slate-100">
                <div className="flex justify-between items-center">
                  <span className="text-sm text-slate-500">ยอดคงเหลือ</span>
                  <span className={`font-semibold ${
                    (balances?.[account.id]?.balance || 0) >= 0 ? 'text-emerald-600' : 'text-red-600'
                  }`}>
                    {formatCurrency(balances?.[account.id]?.balance || 0)}
                  </span>
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
                  {editingAccount ? 'แก้ไขบัญชีธนาคาร' : 'เพิ่มบัญชีธนาคาร'}
                </h2>
                <button onClick={closeModal} className="p-2 hover:bg-slate-100 rounded-lg">
                  <X size={20} />
                </button>
              </div>

              <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
                <div>
                  <label className="label">ชื่อธนาคาร *</label>
                  <input
                    {...register('bankName', { required: 'กรุณากรอกชื่อธนาคาร' })}
                    className="input"
                    placeholder="เช่น ธนาคารกรุงไทย"
                  />
                  {errors.bankName && (
                    <p className="text-sm text-red-500 mt-1">{errors.bankName.message}</p>
                  )}
                </div>

                <div>
                  <label className="label">เลขบัญชี *</label>
                  <input
                    {...register('accountNo', { required: 'กรุณากรอกเลขบัญชี' })}
                    className="input"
                    placeholder="xxx-x-xxxxx-x"
                  />
                  {errors.accountNo && (
                    <p className="text-sm text-red-500 mt-1">{errors.accountNo.message}</p>
                  )}
                </div>

                <div>
                  <label className="label">ชื่อบัญชี *</label>
                  <input
                    {...register('accountName', { required: 'กรุณากรอกชื่อบัญชี' })}
                    className="input"
                    placeholder="กองทุนฌาปนกิจฯ"
                  />
                  {errors.accountName && (
                    <p className="text-sm text-red-500 mt-1">{errors.accountName.message}</p>
                  )}
                </div>

                <div>
                  <label className="label">คำอธิบาย</label>
                  <input
                    {...register('description')}
                    className="input"
                    placeholder="เช่น บัญชีหลัก, บัญชีสำรอง"
                  />
                </div>

                <div className="flex items-center gap-2">
                  <input
                    type="checkbox"
                    {...register('isDefault')}
                    id="isDefault"
                    className="w-4 h-4 rounded border-slate-300 text-primary-600 focus:ring-primary-500"
                  />
                  <label htmlFor="isDefault" className="text-sm text-slate-700">
                    ตั้งเป็นบัญชีหลัก
                  </label>
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
