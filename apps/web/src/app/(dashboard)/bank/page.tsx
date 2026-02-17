'use client';

import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { Landmark, TrendingUp, TrendingDown, ArrowUpRight, ArrowDownRight, Calendar, CreditCard } from 'lucide-react';
import { api, type School } from '@/lib/api';
import { useAuthStore } from '@/store/auth';

interface BankAccount {
  id: string;
  bankName: string;
  accountNo: string;
  accountName: string;
  school: School;
}

interface Transaction {
  id: string;
  date: string;
  type: 'DEPOSIT' | 'WITHDRAWAL';
  description: string;
  amount: number;
  reference: string;
  balance: number;
}

export default function BankPage() {
  const { selectedSchoolId } = useAuthStore();
  const [selectedAccountId, setSelectedAccountId] = useState<string | null>(null);

  const { data: bankAccounts, isLoading: loadingAccounts } = useQuery<BankAccount[]>({
    queryKey: ['bank-accounts', selectedSchoolId],
    queryFn: async () => {
      const params = selectedSchoolId ? `?schoolId=${selectedSchoolId}` : '';
      const response = await api.get(`/bank-accounts${params}`);
      return response.data;
    },
  });

  const { data: transactions, isLoading: loadingTransactions } = useQuery<Transaction[]>({
    queryKey: ['bank-transactions', selectedAccountId],
    queryFn: async () => {
      if (!selectedAccountId) return [];
      const response = await api.get(`/bank-accounts/${selectedAccountId}/transactions`);
      return response.data;
    },
    enabled: !!selectedAccountId,
  });

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('th-TH', {
      style: 'currency',
      currency: 'THB',
      minimumFractionDigits: 2,
    }).format(amount);
  };

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('th-TH', {
      day: 'numeric',
      month: 'short',
      year: 'numeric',
    });
  };

  // Calculate totals
  const totalDeposits = transactions?.filter(t => t.type === 'DEPOSIT').reduce((sum, t) => sum + t.amount, 0) || 0;
  const totalWithdrawals = transactions?.filter(t => t.type === 'WITHDRAWAL').reduce((sum, t) => sum + Math.abs(t.amount), 0) || 0;
  const currentBalance = transactions?.length ? transactions[transactions.length - 1].balance : 0;

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      className="space-y-6"
    >
      {/* Header */}
      <div>
        <h1 className="text-2xl font-display font-bold text-slate-900">
          ธุรกรรมธนาคาร
        </h1>
        <p className="text-slate-500 mt-1">
          ดูรายการเคลื่อนไหวบัญชีธนาคาร
        </p>
      </div>

      {/* Bank Account Selector */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {loadingAccounts ? (
          <div className="col-span-full flex justify-center py-10">
            <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
          </div>
        ) : bankAccounts?.length === 0 ? (
          <div className="col-span-full card text-center py-10 text-slate-500">
            <Landmark className="w-12 h-12 mx-auto text-slate-300 mb-3" />
            <p>ยังไม่มีบัญชีธนาคาร</p>
          </div>
        ) : (
          bankAccounts?.map((account) => (
            <button
              key={account.id}
              onClick={() => setSelectedAccountId(account.id)}
              className={`card p-4 text-left transition-all ${
                selectedAccountId === account.id
                  ? 'ring-2 ring-primary-500 bg-primary-50'
                  : 'hover:bg-slate-50'
              }`}
            >
              <div className="flex items-center gap-3">
                <div className={`w-10 h-10 rounded-lg flex items-center justify-center ${
                  selectedAccountId === account.id ? 'bg-primary-500 text-white' : 'bg-sky-100 text-sky-600'
                }`}>
                  <Landmark className="w-5 h-5" />
                </div>
                <div className="flex-1 min-w-0">
                  <h3 className="font-semibold text-slate-900 truncate">{account.bankName}</h3>
                  <p className="text-sm text-slate-500 flex items-center gap-1">
                    <CreditCard size={12} />
                    {account.accountNo}
                  </p>
                </div>
              </div>
            </button>
          ))
        )}
      </div>

      {/* Transaction Details */}
      {selectedAccountId && (
        <>
          {/* Summary Cards */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="stat-card">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 bg-emerald-100 rounded-lg flex items-center justify-center">
                  <TrendingUp className="w-5 h-5 text-emerald-600" />
                </div>
                <div>
                  <p className="stat-label">รับเข้า</p>
                  <p className="text-xl font-bold text-emerald-600">{formatCurrency(totalDeposits)}</p>
                </div>
              </div>
            </div>
            <div className="stat-card">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 bg-red-100 rounded-lg flex items-center justify-center">
                  <TrendingDown className="w-5 h-5 text-red-600" />
                </div>
                <div>
                  <p className="stat-label">จ่ายออก</p>
                  <p className="text-xl font-bold text-red-600">{formatCurrency(totalWithdrawals)}</p>
                </div>
              </div>
            </div>
            <div className="stat-card">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 bg-sky-100 rounded-lg flex items-center justify-center">
                  <Landmark className="w-5 h-5 text-sky-600" />
                </div>
                <div>
                  <p className="stat-label">ยอดคงเหลือ</p>
                  <p className="text-xl font-bold text-sky-600">{formatCurrency(currentBalance)}</p>
                </div>
              </div>
            </div>
          </div>

          {/* Transactions Table */}
          <div className="card overflow-hidden">
            <div className="px-4 py-3 bg-slate-50 border-b border-slate-200">
              <h3 className="font-semibold text-slate-900">รายการเคลื่อนไหว</h3>
            </div>
            {loadingTransactions ? (
              <div className="flex justify-center py-10">
                <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
              </div>
            ) : transactions?.length === 0 ? (
              <div className="text-center py-10 text-slate-500">
                <p>ยังไม่มีรายการเคลื่อนไหว</p>
              </div>
            ) : (
              <div className="table-container border-0">
                <table className="table">
                  <thead>
                    <tr>
                      <th>วันที่</th>
                      <th>รายละเอียด</th>
                      <th>อ้างอิง</th>
                      <th className="text-right">รับ</th>
                      <th className="text-right">จ่าย</th>
                      <th className="text-right">ยอดคงเหลือ</th>
                    </tr>
                  </thead>
                  <tbody>
                    {transactions?.map((tx) => (
                      <tr key={tx.id}>
                        <td>
                          <span className="flex items-center gap-1 text-sm">
                            <Calendar size={14} className="text-slate-400" />
                            {formatDate(tx.date)}
                          </span>
                        </td>
                        <td className="text-slate-600">{tx.description}</td>
                        <td className="font-mono text-sm text-slate-500">{tx.reference}</td>
                        <td className="text-right">
                          {tx.type === 'DEPOSIT' ? (
                            <span className="text-emerald-600 font-medium flex items-center justify-end gap-1">
                              <ArrowUpRight size={14} />
                              {formatCurrency(tx.amount)}
                            </span>
                          ) : '-'}
                        </td>
                        <td className="text-right">
                          {tx.type === 'WITHDRAWAL' ? (
                            <span className="text-red-600 font-medium flex items-center justify-end gap-1">
                              <ArrowDownRight size={14} />
                              {formatCurrency(Math.abs(tx.amount))}
                            </span>
                          ) : '-'}
                        </td>
                        <td className="text-right font-semibold">{formatCurrency(tx.balance)}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        </>
      )}
    </motion.div>
  );
}


