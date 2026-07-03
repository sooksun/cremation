'use client';

import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { Plus, Edit, Trash2, Wallet } from 'lucide-react';
import { api } from '@/lib/api';
import { showSuccess, showError } from '@/lib/toast';
import { useAuthStore } from '@/store/auth';
import ThaiDatePicker from '@/components/ThaiDatePicker';
import dayjs from 'dayjs';

interface CashEntry {
  id: string;
  date: string;
  type: 'IN' | 'OUT';
  amount: number;
  description?: string;
  school?: { name: string };
}

export default function CashBookPage() {
  const queryClient = useQueryClient();
  const { selectedSchoolId } = useAuthStore();
  const [showForm, setShowForm] = useState(false);
  const [editing, setEditing] = useState<CashEntry | null>(null);
  const [form, setForm] = useState({
    date: dayjs().format('YYYY-MM-DD'),
    type: 'IN' as 'IN' | 'OUT',
    amount: '',
    description: '',
  });

  const { data: entries = [], isLoading } = useQuery<CashEntry[]>({
    queryKey: ['cash-book', selectedSchoolId],
    queryFn: async () => {
      const params = selectedSchoolId ? `?schoolId=${selectedSchoolId}` : '';
      const res = await api.get(`/cash-book${params}`);
      return res.data;
    },
  });

  const createMutation = useMutation({
    mutationFn: (data: any) => api.post('/cash-book', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['cash-book'] });
      showSuccess('บันทึกสมุดเงินสดสำเร็จ');
      closeForm();
    },
    onError: (e: any) => showError(e.response?.data?.message || 'เกิดข้อผิดพลาด'),
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: any }) => api.patch(`/cash-book/${id}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['cash-book'] });
      showSuccess('อัปเดตสำเร็จ');
      closeForm();
    },
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/cash-book/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['cash-book'] });
      showSuccess('ลบสำเร็จ');
    },
  });

  const openCreate = () => {
    setEditing(null);
    setForm({
      date: dayjs().format('YYYY-MM-DD'),
      type: 'IN',
      amount: '',
      description: '',
    });
    setShowForm(true);
  };

  const openEdit = (entry: CashEntry) => {
    setEditing(entry);
    setForm({
      date: dayjs(entry.date).format('YYYY-MM-DD'),
      type: entry.type,
      amount: String(entry.amount),
      description: entry.description || '',
    });
    setShowForm(true);
  };

  const closeForm = () => {
    setShowForm(false);
    setEditing(null);
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const payload = {
      ...form,
      amount: Number(form.amount),
    };
    if (editing) {
      updateMutation.mutate({ id: editing.id, data: payload });
    } else {
      createMutation.mutate(payload);
    }
  };

  const formatCurrency = (amount: number) =>
    new Intl.NumberFormat('th-TH', { style: 'currency', currency: 'THB' }).format(amount);

  const totalIn = entries.filter((e) => e.type === 'IN').reduce((sum, e) => sum + e.amount, 0);
  const totalOut = entries.filter((e) => e.type === 'OUT').reduce((sum, e) => sum + e.amount, 0);
  const balance = totalIn - totalOut;

  return (
    <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-semibold flex items-center gap-2">
            <Wallet /> สมุดเงินสด (Cash Book)
          </h1>
          <p className="text-sm text-slate-500">ติดตามเงินสดรับ-จ่าย</p>
        </div>
        <button onClick={openCreate} className="btn-primary flex items-center gap-2">
          <Plus size={18} /> เพิ่มรายการ
        </button>
      </div>

      <div className="grid grid-cols-3 gap-4">
        <div className="card p-4">
          <div className="text-sm text-emerald-600">เงินสดรับ</div>
          <div className="text-2xl font-bold text-emerald-700">{formatCurrency(totalIn)}</div>
        </div>
        <div className="card p-4">
          <div className="text-sm text-red-600">เงินสดจ่าย</div>
          <div className="text-2xl font-bold text-red-700">{formatCurrency(totalOut)}</div>
        </div>
        <div className="card p-4">
          <div className="text-sm text-slate-600">คงเหลือ</div>
          <div className={`text-2xl font-bold ${balance >= 0 ? 'text-emerald-700' : 'text-red-700'}`}>
            {formatCurrency(balance)}
          </div>
        </div>
      </div>

      {isLoading ? (
        <div>Loading...</div>
      ) : (
        <div className="card overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-slate-50">
              <tr>
                <th className="p-3 text-left">วันที่</th>
                <th className="p-3 text-left">ประเภท</th>
                <th className="p-3 text-right">จำนวน</th>
                <th className="p-3 text-left">รายละเอียด</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {entries.map((e) => (
                <tr key={e.id} className="border-t">
                  <td className="p-3">{dayjs(e.date).format('DD/MM/BBBB')}</td>
                  <td className="p-3">
                    <span className={`px-2 py-0.5 rounded text-xs ${e.type === 'IN' ? 'bg-emerald-100 text-emerald-700' : 'bg-red-100 text-red-700'}`}>
                      {e.type === 'IN' ? 'รับ' : 'จ่าย'}
                    </span>
                  </td>
                  <td className={`p-3 text-right font-medium ${e.type === 'IN' ? 'text-emerald-600' : 'text-red-600'}`}>
                    {formatCurrency(e.amount)}
                  </td>
                  <td className="p-3 text-slate-600">{e.description || '-'}</td>
                  <td className="p-3 flex gap-2 justify-end">
                    <button onClick={() => openEdit(e)} className="text-blue-600"><Edit size={16} /></button>
                    <button onClick={() => deleteMutation.mutate(e.id)} className="text-red-600"><Trash2 size={16} /></button>
                  </td>
                </tr>
              ))}
              {entries.length === 0 && (
                <tr><td colSpan={5} className="p-4 text-center text-slate-400">ไม่มีรายการ</td></tr>
              )}
            </tbody>
          </table>
        </div>
      )}

      {showForm && (
        <div className="fixed inset-0 bg-black/30 flex items-center justify-center z-50">
          <div className="bg-white rounded-xl w-full max-w-md p-6">
            <h3 className="text-lg font-semibold mb-4">{editing ? 'แก้ไข' : 'เพิ่ม'} รายการเงินสด</h3>
            <form onSubmit={handleSubmit} className="space-y-4">
              <ThaiDatePicker value={form.date} onChange={(d) => d && setForm({ ...form, date: d.format('YYYY-MM-DD') })} />
              <select value={form.type} onChange={(e) => setForm({ ...form, type: e.target.value as 'IN' | 'OUT' })} className="input w-full">
                <option value="IN">รับเงินสด (IN)</option>
                <option value="OUT">จ่ายเงินสด (OUT)</option>
              </select>
              <input type="number" step="0.01" className="input w-full" placeholder="จำนวนเงิน" value={form.amount} onChange={(e) => setForm({ ...form, amount: e.target.value })} required />
              <input className="input w-full" placeholder="รายละเอียด" value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} />
              <div className="flex gap-3 justify-end">
                <button type="button" onClick={closeForm} className="btn-secondary">ยกเลิก</button>
                <button type="submit" className="btn-primary">บันทึก</button>
              </div>
            </form>
          </div>
        </div>
      )}
    </motion.div>
  );
}
