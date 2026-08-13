'use client';

import { useState } from 'react';
import { Upload, X } from 'lucide-react';
import { api } from '@/lib/api';
import { showError } from '@/lib/toast';

export interface ReconcileResponse {
  scope: { fullDistrict: boolean; schools: Array<{ id: string; code: string; name: string }> };
  summary: {
    expected: number; paid: number; alreadyPaid: number; missingFromFile: number;
    inFileNotPaid: number; unknownInFile: number; markedArrears: number;
  };
  missing: Array<{
    memberNo: string; fullName: string; schoolCode: string; schoolName: string;
    groupName: string; amountDue: number; reason: 'NOT_IN_FILE' | 'IN_FILE_NOT_PAID';
    memberId: string; contributionId: string | null; schoolId: string;
  }>;
  unknown: Array<{ rowNo: number; memberNo: string }>;
  success: number; failed: number; notFound: number;
  errors: Array<{ memberNo: string; error: string }>;
}

export function UploadPaymentModal({
  year, month, canUseFullDistrict, onClose, onDone,
}: {
  year: number; month: number; canUseFullDistrict: boolean;
  onClose: () => void; onDone: (result: ReconcileResponse) => void;
}) {
  const [file, setFile] = useState<File | null>(null);
  const [fullDistrict, setFullDistrict] = useState(false);
  const [autoMarkArrears, setAutoMarkArrears] = useState(true);
  const [busy, setBusy] = useState(false);

  const submit = async () => {
    if (!file) {
      showError('กรุณาเลือกไฟล์ก่อน');
      return;
    }
    setBusy(true);
    try {
      const form = new FormData();
      form.append('file', file);
      form.append('year', String(year));
      form.append('month', String(month));
      form.append('fullDistrict', String(fullDistrict));
      form.append('autoMarkArrears', String(autoMarkArrears));

      // ต้อง override Content-Type ให้เป็น undefined เฉพาะคำขอนี้ — instance กลางตั้ง default เป็น
      // application/json ซึ่งทำให้ axios แปลง FormData เป็น JSON แล้วไฟล์หายไปทั้งก้อน
      // เมื่อไม่มี Content-Type axios จะตรวจเจอ FormData เองแล้วใส่ multipart/form-data; boundary=… ให้
      const response = await api.post<ReconcileResponse>('/contributions/upload', form, {
        headers: { 'Content-Type': undefined },
      });
      onDone(response.data);
    } catch (error) {
      const message =
        (error as { response?: { data?: { message?: string } } }).response?.data?.message ??
        'อัปโหลดไม่สำเร็จ';
      showError(message);
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl w-full max-w-md p-5">
        <div className="flex items-center justify-between mb-4">
          <h2 className="font-semibold text-slate-800">อัปโหลดไฟล์เก็บเงิน</h2>
          <button onClick={onClose} className="p-1 text-slate-400 hover:text-slate-600">
            <X size={18} />
          </button>
        </div>

        <input
          type="file"
          accept=".csv,.xlsx,.xls"
          onChange={(e) => setFile(e.target.files?.[0] ?? null)}
          className="w-full border border-slate-200 rounded-xl p-2 text-sm"
        />

        <label className="flex items-center gap-2 mt-4 text-sm text-slate-700">
          <input
            type="checkbox"
            checked={autoMarkArrears}
            onChange={(e) => setAutoMarkArrears(e.target.checked)}
          />
          บันทึกค้างชำระอัตโนมัติให้คนที่ขาด
        </label>

        {canUseFullDistrict && (
          <label className="flex items-center gap-2 mt-2 text-sm text-slate-700">
            <input
              type="checkbox"
              checked={fullDistrict}
              onChange={(e) => setFullDistrict(e.target.checked)}
            />
            ไฟล์นี้คือรายชื่อครบทั้งอำเภอ
          </label>
        )}

        <button
          onClick={submit}
          disabled={busy || !file}
          className="mt-5 w-full bg-primary-600 text-white rounded-xl py-2 text-sm font-medium disabled:opacity-40 flex items-center justify-center gap-2"
        >
          <Upload size={16} />
          {busy ? 'กำลังตรวจสอบ…' : 'ตรวจสอบและบันทึก'}
        </button>
      </div>
    </div>
  );
}
