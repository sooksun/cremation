'use client';

import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { Plus, Edit, Trash2, Calculator } from 'lucide-react';
import { api } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import { showSuccess, showError } from '@/lib/toast';
import ThaiDatePicker from '@/components/ThaiDatePicker';
import dayjs from 'dayjs';

interface Asset {
  id: string;
  code?: string;
  name: string;
  category?: string;
  purchaseDate: string;
  originalCost: number;
  salvageValue: number;
  usefulLifeYears: number;
  accumulatedDep: number;
  status: string;
  school?: { name: string };
}

export default function AssetsPage() {
  const { selectedSchoolId } = useAuthStore();
  const queryClient = useQueryClient();
  const [modalOpen, setModalOpen] = useState(false);
  const [editing, setEditing] = useState<Asset | null>(null);
  const [form, setForm] = useState<any>({});

  const { data: assets = [], isLoading } = useQuery<Asset[]>({
    queryKey: ['assets', selectedSchoolId],
    queryFn: async () => {
      const params = selectedSchoolId ? `?schoolId=${selectedSchoolId}` : '';
      const res = await api.get(`/assets${params}`);
      return res.data;
    },
  });

  const createMutation = useMutation({
    mutationFn: (data: any) => api.post('/assets', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['assets'] });
      showSuccess('บันทึกสินทรัพย์สำเร็จ');
      closeModal();
    },
    onError: (e: any) => showError(e.response?.data?.message || 'เกิดข้อผิดพลาด'),
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: any }) => api.patch(`/assets/${id}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['assets'] });
      showSuccess('อัปเดตสำเร็จ');
      closeModal();
    },
  });

  const recordDepMutation = useMutation({
    mutationFn: (id: string) => api.post(`/assets/${id}/depreciation`, {}),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['assets'] });
      showSuccess(res.data?.message || 'บันทึกค่าเสื่อมราคาสำเร็จ');
    },
  });

  const openCreate = () => {
    setEditing(null);
    setForm({
      name: '',
      purchaseDate: dayjs().format('YYYY-MM-DD'),
      originalCost: 0,
      salvageValue: 0,
      usefulLifeYears: 5,
      category: '',
    });
    setModalOpen(true);
  };

  const openEdit = (asset: Asset) => {
    setEditing(asset);
    setForm({
      ...asset,
      purchaseDate: dayjs(asset.purchaseDate).format('YYYY-MM-DD'),
    });
    setModalOpen(true);
  };

  const closeModal = () => {
    setModalOpen(false);
    setEditing(null);
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const payload = { ...form };
    if (editing) {
      updateMutation.mutate({ id: editing.id, data: payload });
    } else {
      createMutation.mutate(payload);
    }
  };

  const fmt = (n: number) =>
    new Intl.NumberFormat('th-TH', { style: 'currency', currency: 'THB' }).format(n);

  const bookValue = (a: Asset) => Math.max(0, Number(a.originalCost) - Number(a.accumulatedDep || 0));

  return (
    <div className="p-6">
      <div className="flex justify-between mb-6">
        <h1 className="text-2xl font-semibold">สินทรัพย์ถาวร</h1>
        <button onClick={openCreate} className="btn-primary flex items-center gap-2">
          <Plus size={18} /> เพิ่มสินทรัพย์
        </button>
      </div>

      {isLoading ? <div>กำลังโหลด...</div> : (
        <div className="card overflow-hidden">
          <table className="w-full text-sm">
            <thead>
              <tr className="bg-gray-50">
                <th className="text-left p-3">ชื่อ</th>
                <th>วันที่ซื้อ</th>
                <th className="text-right">ต้นทุนเดิม</th>
                <th className="text-right">ค่าเสื่อมสะสม</th>
                <th className="text-right">มูลค่าตามบัญชี</th>
                <th>อายุการใช้งาน</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {assets.map((a) => (
                <tr key={a.id} className="border-t">
                  <td className="p-3 font-medium">{a.name} {a.code && <span className="text-xs text-gray-500">({a.code})</span>}</td>
                  <td className="p-3 text-center">{dayjs(a.purchaseDate).format('DD/MM/BBBB')}</td>
                  <td className="p-3 text-right">{fmt(a.originalCost)}</td>
                  <td className="p-3 text-right">{fmt(a.accumulatedDep || 0)}</td>
                  <td className="p-3 text-right font-semibold">{fmt(bookValue(a))}</td>
                  <td className="p-3 text-center">{a.usefulLifeYears} ปี</td>
                  <td className="p-3 flex gap-2 justify-end">
                    <button onClick={() => recordDepMutation.mutate(a.id)} className="text-blue-600 hover:underline flex items-center gap-1 text-xs">
                      <Calculator size={14} /> บันทึกเสื่อม
                    </button>
                    <button onClick={() => openEdit(a)} className="text-gray-500"><Edit size={16} /></button>
                  </td>
                </tr>
              ))}
              {assets.length === 0 && <tr><td colSpan={7} className="p-4 text-center text-gray-400">ไม่มีสินทรัพย์</td></tr>}
            </tbody>
          </table>
        </div>
      )}

      {/* Modal */}
      {modalOpen && (
        <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50">
          <div className="bg-white rounded-2xl w-full max-w-md p-6">
            <h2 className="text-xl font-semibold mb-4">{editing ? 'แก้ไข' : 'เพิ่ม'} สินทรัพย์ถาวร</h2>
            <form onSubmit={handleSubmit} className="space-y-4">
              <input className="input w-full" placeholder="ชื่อสินทรัพย์" value={form.name || ''} onChange={e => setForm({ ...form, name: e.target.value })} required />
              <input className="input w-full" placeholder="รหัส (ถ้ามี)" value={form.code || ''} onChange={e => setForm({ ...form, code: e.target.value })} />
              <ThaiDatePicker value={form.purchaseDate} onChange={d => d && setForm({ ...form, purchaseDate: d.format('YYYY-MM-DD') })} />
              <div className="grid grid-cols-2 gap-3">
                <input type="number" className="input" placeholder="ต้นทุนเดิม" value={form.originalCost || ''} onChange={e => setForm({ ...form, originalCost: parseFloat(e.target.value) })} required />
                <input type="number" className="input" placeholder="มูลค่าซาก" value={form.salvageValue || 0} onChange={e => setForm({ ...form, salvageValue: parseFloat(e.target.value) })} />
              </div>
              <input type="number" className="input" placeholder="อายุการใช้งาน (ปี)" value={form.usefulLifeYears || ''} onChange={e => setForm({ ...form, usefulLifeYears: parseInt(e.target.value) })} required />
              <input className="input w-full" placeholder="หมวดหมู่" value={form.category || ''} onChange={e => setForm({ ...form, category: e.target.value })} />
              <div className="flex justify-end gap-3 pt-2">
                <button type="button" onClick={closeModal} className="btn-secondary">ยกเลิก</button>
                <button type="submit" className="btn-primary">บันทึก</button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}