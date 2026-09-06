'use client';

import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { Plus, Edit, Trash2, Calculator } from 'lucide-react';
import { api } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import { showSuccess, showError } from '@/lib/toast';
import ThaiDatePicker from '@/components/ThaiDatePicker';
import { Modal } from '@/components/ui/Modal';
import { DepreciationPanel, bookValueOf } from './DepreciationPanel';
import dayjs from 'dayjs';
import buddhistEra from 'dayjs/plugin/buddhistEra';

dayjs.extend(buddhistEra);

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
  const [depreciating, setDepreciating] = useState<Asset | null>(null);

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

  // ใช้ตัวเดียวกับแผงค่าเสื่อม พื้นเป็นราคาซาก ไม่ใช่ศูนย์ ให้ตรงกับที่ API คำนวณ
  const bookValue = bookValueOf;

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
                    <button
                      onClick={() => setDepreciating(a)}
                      aria-label={`ค่าเสื่อมราคาของ ${a.name}`}
                      className="text-blue-600 hover:underline flex items-center gap-1 text-xs"
                    >
                      <Calculator size={14} aria-hidden="true" /> ค่าเสื่อมราคา
                    </button>
                    <button
                      onClick={() => openEdit(a)}
                      aria-label={`แก้ไข ${a.name}`}
                      className="text-gray-500"
                    >
                      <Edit size={16} aria-hidden="true" />
                    </button>
                  </td>
                </tr>
              ))}
              {assets.length === 0 && <tr><td colSpan={7} className="p-4 text-center text-gray-400">ไม่มีสินทรัพย์</td></tr>}
            </tbody>
          </table>
        </div>
      )}

      <Modal
        open={modalOpen}
        onClose={closeModal}
        title={`${editing ? 'แก้ไข' : 'เพิ่ม'}สินทรัพย์ถาวร`}
        size="max-w-md"
      >
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label htmlFor="asset-name" className="label">ชื่อสินทรัพย์</label>
            <input id="asset-name" className="input w-full" value={form.name || ''} onChange={e => setForm({ ...form, name: e.target.value })} required />
          </div>
          <div>
            <label htmlFor="asset-code" className="label">รหัส (ถ้ามี)</label>
            <input id="asset-code" className="input w-full" value={form.code || ''} onChange={e => setForm({ ...form, code: e.target.value })} />
          </div>
          <div>
            <label htmlFor="asset-purchase-date" className="label">วันที่ซื้อ</label>
            <ThaiDatePicker id="asset-purchase-date" value={form.purchaseDate} onChange={d => d && setForm({ ...form, purchaseDate: d.format('YYYY-MM-DD') })} />
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div>
              <label htmlFor="asset-cost" className="label">ต้นทุนเดิม</label>
              <input id="asset-cost" type="number" className="input" value={form.originalCost || ''} onChange={e => setForm({ ...form, originalCost: parseFloat(e.target.value) })} required />
            </div>
            <div>
              <label htmlFor="asset-salvage" className="label">ราคาซาก</label>
              <input id="asset-salvage" type="number" className="input" value={form.salvageValue || 0} onChange={e => setForm({ ...form, salvageValue: parseFloat(e.target.value) })} />
            </div>
          </div>
          <div>
            <label htmlFor="asset-life" className="label">อายุการใช้งาน (ปี)</label>
            <input id="asset-life" type="number" className="input w-full" value={form.usefulLifeYears || ''} onChange={e => setForm({ ...form, usefulLifeYears: parseInt(e.target.value) })} required />
          </div>
          <div>
            <label htmlFor="asset-category" className="label">หมวดหมู่</label>
            <input id="asset-category" className="input w-full" value={form.category || ''} onChange={e => setForm({ ...form, category: e.target.value })} />
          </div>
          <div className="flex justify-end gap-3 pt-2">
            <button type="button" onClick={closeModal} className="btn-secondary">ยกเลิก</button>
            <button type="submit" className="btn-primary">บันทึก</button>
          </div>
        </form>
      </Modal>

      <DepreciationPanel asset={depreciating} onClose={() => setDepreciating(null)} />
    </div>
  );
}