'use client';

import { useState } from 'react';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { Calculator, TriangleAlert } from 'lucide-react';
import { api } from '@/lib/api';
import { showError, showSuccess } from '@/lib/toast';
import { Modal } from '@/components/ui/Modal';

export interface DepreciableAsset {
  id: string;
  name: string;
  originalCost: number;
  salvageValue: number;
  usefulLifeYears: number;
  accumulatedDep: number;
}

interface ScheduleRow {
  year: number;
  depreciation: number;
  accumulated: number;
  bookValue: number;
}

const baht = (n: number) =>
  new Intl.NumberFormat('th-TH', { style: 'currency', currency: 'THB' }).format(Number(n) || 0);

/** มูลค่าตามบัญชีมีพื้นเป็นราคาซาก ตรงกับที่ API คำนวณ ไม่ใช่ปัดที่ศูนย์ */
export const bookValueOf = (a: DepreciableAsset) =>
  Math.max(Number(a.salvageValue) || 0, Number(a.originalCost) - (Number(a.accumulatedDep) || 0));

/**
 * แผงคำนวณและบันทึกค่าเสื่อมราคาประจำปี
 *
 * การบันทึกค่าเสื่อมลงบัญชีแยกประเภทจริง กดพลาดแล้วต้องกลับรายการ ไม่ใช่แค่แก้ตัวเลข
 * จึงต้องให้ผู้ใช้เห็นตารางค่าเสื่อมตลอดอายุการใช้งาน เลือกปีเองได้ และยืนยันก่อนบันทึก
 */
export function DepreciationPanel({
  asset,
  onClose,
}: {
  asset: DepreciableAsset | null;
  onClose: () => void;
}) {
  const queryClient = useQueryClient();
  const currentYear = new Date().getFullYear();
  const [year, setYear] = useState(currentYear);
  const [confirming, setConfirming] = useState(false);

  const { data: schedule = [], isLoading } = useQuery<ScheduleRow[]>({
    queryKey: ['asset-schedule', asset?.id],
    enabled: !!asset,
    queryFn: async () => {
      const res = await api.get(`/assets/${asset!.id}/schedule`);
      return res.data?.schedule ?? res.data ?? [];
    },
  });

  const record = useMutation({
    mutationFn: () => api.post(`/assets/${asset!.id}/depreciation`, { year }),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['assets'] });
      queryClient.invalidateQueries({ queryKey: ['asset-schedule', asset?.id] });
      showSuccess(res.data?.message || 'บันทึกค่าเสื่อมราคาเรียบร้อย');
      setConfirming(false);
      onClose();
    },
    // เดิมไม่มีตัวรับข้อผิดพลาด ผู้ใช้กดแล้วเงียบเมื่อระบบปฏิเสธ
    // เช่น บันทึกปีนั้นไปแล้ว หรือสินทรัพย์ตัดค่าเสื่อมครบแล้ว
    onError: (err: unknown) => {
      const message =
        (err as { response?: { data?: { message?: string } } })?.response?.data?.message ??
        'บันทึกค่าเสื่อมราคาไม่สำเร็จ';
      showError(message);
      setConfirming(false);
    },
  });

  if (!asset) return null;

  const depreciableBase = Number(asset.originalCost) - (Number(asset.salvageValue) || 0);
  const remaining = Math.max(0, depreciableBase - (Number(asset.accumulatedDep) || 0));
  const annual = asset.usefulLifeYears > 0 ? depreciableBase / asset.usefulLifeYears : 0;
  const willRecord = Math.min(annual, remaining);
  const fullyDepreciated = remaining <= 0;
  const years = Array.from({ length: 7 }, (_, i) => currentYear - 5 + i);

  return (
    <Modal
      open={!!asset}
      onClose={onClose}
      title={`ค่าเสื่อมราคา — ${asset.name}`}
      description="ตรวจตัวเลขก่อนบันทึก การบันทึกจะลงรายการในบัญชีแยกประเภทจริง"
      size="max-w-3xl"
    >
      <div className="space-y-5">
        <dl className="grid grid-cols-2 gap-3 rounded-xl bg-slate-50 p-4 text-sm sm:grid-cols-4">
          <div>
            <dt className="text-slate-500">ต้นทุนเดิม</dt>
            <dd className="font-semibold">{baht(asset.originalCost)}</dd>
          </div>
          <div>
            <dt className="text-slate-500">ราคาซาก</dt>
            <dd className="font-semibold">{baht(asset.salvageValue)}</dd>
          </div>
          <div>
            <dt className="text-slate-500">ค่าเสื่อมสะสม</dt>
            <dd className="font-semibold">{baht(asset.accumulatedDep)}</dd>
          </div>
          <div>
            <dt className="text-slate-500">มูลค่าตามบัญชี</dt>
            <dd className="font-semibold">{baht(bookValueOf(asset))}</dd>
          </div>
        </dl>

        {fullyDepreciated ? (
          <p className="flex items-start gap-2 rounded-xl bg-amber-50 p-3 text-sm text-amber-800">
            <TriangleAlert size={18} className="mt-0.5 shrink-0" aria-hidden="true" />
            สินทรัพย์นี้ตัดค่าเสื่อมราคาครบฐานแล้ว ({baht(depreciableBase)}) จึงบันทึกเพิ่มไม่ได้
          </p>
        ) : (
          <div className="flex flex-wrap items-end gap-4">
            <div>
              <label htmlFor="depreciation-year" className="label">
                ปีที่บันทึก
              </label>
              <select
                id="depreciation-year"
                className="input"
                value={year}
                onChange={(e) => setYear(Number(e.target.value))}
              >
                {years.map((y) => (
                  <option key={y} value={y}>
                    {y + 543}
                  </option>
                ))}
              </select>
            </div>
            <div className="text-sm">
              <p className="text-slate-500">จำนวนที่จะบันทึก</p>
              <p className="text-lg font-semibold text-primary-800">{baht(willRecord)}</p>
              {willRecord < annual && (
                <p className="text-xs text-slate-500">
                  เหลือให้ตัดอีก {baht(remaining)} จึงบันทึกได้ไม่เต็มปี
                </p>
              )}
            </div>
            <button
              type="button"
              onClick={() => setConfirming(true)}
              disabled={record.isPending}
              className="btn-primary ml-auto flex items-center gap-2"
            >
              <Calculator size={16} aria-hidden="true" />
              บันทึกค่าเสื่อมราคา
            </button>
          </div>
        )}

        <div>
          <h3 className="mb-2 text-sm font-semibold text-slate-700">
            ตารางค่าเสื่อมราคาตลอดอายุการใช้งาน
          </h3>
          <div className="overflow-x-auto rounded-xl border border-slate-200">
            <table className="w-full text-sm">
              <caption className="sr-only">
                ตารางค่าเสื่อมราคาแบบเส้นตรงของ {asset.name} แยกตามปี
              </caption>
              <thead className="bg-slate-50 text-slate-600">
                <tr>
                  <th scope="col" className="p-2 text-left">
                    ปี พ.ศ.
                  </th>
                  <th scope="col" className="p-2 text-right">
                    ค่าเสื่อมราคา
                  </th>
                  <th scope="col" className="p-2 text-right">
                    สะสม
                  </th>
                  <th scope="col" className="p-2 text-right">
                    มูลค่าตามบัญชี
                  </th>
                </tr>
              </thead>
              <tbody>
                {isLoading && (
                  <tr>
                    <td colSpan={4} className="p-3 text-center text-slate-400">
                      กำลังโหลด...
                    </td>
                  </tr>
                )}
                {!isLoading && schedule.length === 0 && (
                  <tr>
                    <td colSpan={4} className="p-3 text-center text-slate-400">
                      คำนวณตารางไม่ได้ ตรวจอายุการใช้งานและต้นทุนของสินทรัพย์
                    </td>
                  </tr>
                )}
                {schedule.map((row) => (
                  <tr key={row.year} className="border-t border-slate-100">
                    <td className="p-2">{row.year + 543}</td>
                    <td className="p-2 text-right">{baht(row.depreciation)}</td>
                    <td className="p-2 text-right">{baht(row.accumulated)}</td>
                    <td className="p-2 text-right font-medium">{baht(row.bookValue)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <Modal
        open={confirming}
        onClose={() => setConfirming(false)}
        title="ยืนยันบันทึกค่าเสื่อมราคา"
        size="max-w-md"
      >
        <p className="text-sm text-slate-600">
          จะบันทึกค่าเสื่อมราคา <strong>{baht(willRecord)}</strong> ของ <strong>{asset.name}</strong>{' '}
          สำหรับปี <strong>{year + 543}</strong> และลงรายการในบัญชีแยกประเภท
          การยกเลิกภายหลังต้องทำด้วยการกลับรายการ
        </p>
        <div className="mt-6 flex justify-end gap-3">
          <button type="button" className="btn-secondary" onClick={() => setConfirming(false)}>
            ยกเลิก
          </button>
          <button
            type="button"
            className="btn-primary"
            disabled={record.isPending}
            onClick={() => record.mutate()}
          >
            {record.isPending ? 'กำลังบันทึก...' : 'ยืนยันบันทึก'}
          </button>
        </div>
      </Modal>
    </Modal>
  );
}
