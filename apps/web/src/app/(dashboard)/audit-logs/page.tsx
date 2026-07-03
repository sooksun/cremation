'use client';

import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { api } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import { History, RefreshCw } from 'lucide-react';

interface AuditLog {
  id: string;
  createdAt: string;
  action: string;
  entityType: string;
  entityId: string;
  schoolId?: string;
  ipAddress?: string;
  metadata?: any;
  user?: {
    id: string;
    fullName: string;
    role: string;
  };
}

interface AuditLogsResponse {
  data: AuditLog[];
}

const AUDIT_ACTIONS = [
  'ALL',
  'USER_LOGIN',
  'USER_CREATE',
  'USER_UPDATE',
  'USER_ROLE_CHANGE',
  'USER_DELETE',
  'SCHOOL_ADMIN_CREATE',
  'SCHOOL_ADMIN_UPDATE',
  'SCHOOL_ADMIN_DELETE',
  'SCHOOL_CREATE',
  'SCHOOL_UPDATE',
  'SCHOOL_DELETE',
  'PASSWORD_CHANGE',
  'RECEIPT_CREATE',
  'PAYMENT_VOUCHER_CREATE',
  'CONTRIBUTION_PAYMENT',
  'BATCH_PAYMENT',
  'CONTRIBUTION_PERIOD_CLOSE',
  'DEATH_CLAIM_CREATE',
  'DEATH_CLAIM_APPROVE',
  'DEATH_CLAIM_PAYMENT',
  'MEMBER_CREATE',
  'MEMBER_UPDATE',
  'MEMBER_STATUS_CHANGE',
  'ASSOCIATION_MEMBER_CREATE',
  'ASSOCIATION_MEMBER_UPDATE',
  'GROUP_CREATE',
  'GROUP_UPDATE',
  'GROUP_DELETE',
  'BANK_ACCOUNT_CREATE',
  'BANK_ACCOUNT_UPDATE',
  'BANK_ACCOUNT_DELETE',
  'ACCOUNT_CREATE',
  'ACCOUNT_UPDATE',
  'ASSET_CREATE',
  'ASSET_UPDATE',
  'ASSET_DISPOSE',
  'ASSET_DEPRECIATION_RECORD',
  'WELFARE_SETTINGS_UPDATE',
];

export default function AuditLogsPage() {
  const { user } = useAuthStore();
  const [selectedAction, setSelectedAction] = useState('ALL');
  const [fromDate, setFromDate] = useState('');
  const [toDate, setToDate] = useState('');
  const [limit, setLimit] = useState(50);

  const queryParams = new URLSearchParams();
  if (selectedAction !== 'ALL') queryParams.append('action', selectedAction);
  if (fromDate) queryParams.append('from', fromDate);
  if (toDate) queryParams.append('to', toDate);
  queryParams.append('limit', limit.toString());

  const { data, isLoading, isError, refetch, isFetching } = useQuery<AuditLogsResponse>({
    queryKey: ['audit-logs', selectedAction, fromDate, toDate, limit],
    queryFn: async () => {
      const response = await api.get(`/audit-logs?${queryParams.toString()}`);
      return response.data;
    },
    enabled: !!user,
  });

  const logs: AuditLog[] = data?.data || [];

  const formatDate = (dateStr: string) => {
    const d = new Date(dateStr);
    return d.toLocaleString('th-TH', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
    });
  };

  const getActionLabel = (action: string) => {
    const map: Record<string, string> = {
      USER_LOGIN: 'เข้าสู่ระบบ',
      USER_CREATE: 'สร้างผู้ใช้',
      USER_UPDATE: 'แก้ไขผู้ใช้',
      USER_ROLE_CHANGE: 'แก้ไขสิทธิ์ผู้ใช้ (Role)',
      USER_DELETE: 'ลบผู้ใช้',
      SCHOOL_ADMIN_CREATE: 'สร้างผู้ดูแลโรงเรียน',
      SCHOOL_ADMIN_UPDATE: 'แก้ไขผู้ดูแลโรงเรียน',
      SCHOOL_ADMIN_DELETE: 'ลบผู้ดูแลโรงเรียน',
      SCHOOL_CREATE: 'สร้างโรงเรียน',
      SCHOOL_UPDATE: 'แก้ไขโรงเรียน',
      SCHOOL_DELETE: 'ปิดใช้งานโรงเรียน',
      PASSWORD_CHANGE: 'เปลี่ยนรหัสผ่าน',
      RECEIPT_CREATE: 'สร้างใบเสร็จ',
      PAYMENT_VOUCHER_CREATE: 'สร้างใบสำคัญจ่าย',
      CONTRIBUTION_PAYMENT: 'บันทึกชำระเงินสงเคราะห์',
      BATCH_PAYMENT: 'ชำระเงินแบบกลุ่ม',
      CONTRIBUTION_PERIOD_CLOSE: 'ปิดงวดเงินสงเคราะห์',
      DEATH_CLAIM_CREATE: 'แจ้งเสียชีวิต',
      DEATH_CLAIM_APPROVE: 'อนุมัติเคลมเสียชีวิต',
      DEATH_CLAIM_PAYMENT: 'จ่ายเงินสงเคราะห์',
      MEMBER_CREATE: 'สร้างสมาชิก',
      MEMBER_UPDATE: 'แก้ไขสมาชิก',
      MEMBER_STATUS_CHANGE: 'เปลี่ยนสถานะสมาชิก',
      ASSOCIATION_MEMBER_CREATE: 'สร้างทะเบียนสมาชิกสมาคม',
      ASSOCIATION_MEMBER_UPDATE: 'แก้ไขทะเบียนสมาชิกสมาคม (ข้อมูล sensitive)',
      GROUP_CREATE: 'สร้างกลุ่ม',
      GROUP_UPDATE: 'แก้ไขกลุ่ม (รวมหัวหน้ากลุ่ม)',
      GROUP_DELETE: 'ลบกลุ่ม',
      BANK_ACCOUNT_CREATE: 'สร้างบัญชีธนาคาร',
      BANK_ACCOUNT_UPDATE: 'แก้ไขบัญชีธนาคาร',
      BANK_ACCOUNT_DELETE: 'ปิดบัญชีธนาคาร',
      ACCOUNT_CREATE: 'สร้างบัญชีแยกประเภท',
      ACCOUNT_UPDATE: 'แก้ไขบัญชีแยกประเภท',
      ASSET_CREATE: 'สร้างสินทรัพย์',
      ASSET_UPDATE: 'แก้ไขสินทรัพย์',
      ASSET_DISPOSE: 'จำหน่ายสินทรัพย์',
      ASSET_DEPRECIATION_RECORD: 'บันทึกค่าเสื่อมราคา',
      WELFARE_SETTINGS_UPDATE: 'แก้ไขอัตราสงเคราะห์ (มติคณะกรรมการ)',
    };
    return map[action] || action;
  };

  return (
    <div className="p-6">
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <History className="w-8 h-8 text-blue-600" />
          <div>
            <h1 className="text-2xl font-semibold">บันทึกกิจกรรม (Audit Log)</h1>
            <p className="text-sm text-gray-500">ติดตามการกระทำสำคัญในระบบ</p>
          </div>
        </div>
        <button
          onClick={() => refetch()}
          className="flex items-center gap-2 px-4 py-2 bg-white border rounded-lg hover:bg-gray-50"
          disabled={isFetching}
        >
          <RefreshCw className={`w-4 h-4 ${isFetching ? 'animate-spin' : ''}`} />
          รีเฟรช
        </button>
      </div>

      {/* Filters */}
      <div className="bg-white p-4 rounded-xl shadow mb-6 flex flex-wrap gap-4 items-end">
        <div>
          <label className="block text-sm font-medium mb-1">ประเภทการกระทำ</label>
          <select
            value={selectedAction}
            onChange={(e) => setSelectedAction(e.target.value)}
            className="border rounded-lg px-3 py-2 text-sm"
          >
            {AUDIT_ACTIONS.map((a) => (
              <option key={a} value={a}>
                {a === 'ALL' ? 'ทั้งหมด' : getActionLabel(a)}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label className="block text-sm font-medium mb-1">จากวันที่</label>
          <input
            type="date"
            value={fromDate}
            onChange={(e) => setFromDate(e.target.value)}
            className="border rounded-lg px-3 py-2 text-sm"
          />
        </div>

        <div>
          <label className="block text-sm font-medium mb-1">ถึงวันที่</label>
          <input
            type="date"
            value={toDate}
            onChange={(e) => setToDate(e.target.value)}
            className="border rounded-lg px-3 py-2 text-sm"
          />
        </div>

        <div>
          <label className="block text-sm font-medium mb-1">แสดงผล</label>
          <select
            value={limit}
            onChange={(e) => setLimit(Number(e.target.value))}
            className="border rounded-lg px-3 py-2 text-sm w-24"
          >
            {[20, 50, 100, 200].map((l) => (
              <option key={l} value={l}>
                {l} รายการ
              </option>
            ))}
          </select>
        </div>

        <button
          onClick={() => {
            setSelectedAction('ALL');
            setFromDate('');
            setToDate('');
            setLimit(50);
          }}
          className="px-4 py-2 text-sm text-gray-600 hover:text-gray-800"
        >
          ล้างตัวกรอง
        </button>
      </div>

      {/* Table */}
      <div className="bg-white rounded-xl shadow overflow-hidden">
        {isLoading ? (
          <div className="p-8 text-center text-gray-500">กำลังโหลด...</div>
        ) : isError ? (
          <div className="p-8 text-center text-red-500">เกิดข้อผิดพลาดในการโหลดข้อมูล</div>
        ) : logs.length === 0 ? (
          <div className="p-8 text-center text-gray-500">ไม่พบรายการบันทึกกิจกรรม</div>
        ) : (
          <table className="w-full text-sm">
            <thead className="bg-gray-50 border-b">
              <tr>
                <th className="text-left px-6 py-3 font-medium text-gray-600">เวลา</th>
                <th className="text-left px-6 py-3 font-medium text-gray-600">ผู้ใช้</th>
                <th className="text-left px-6 py-3 font-medium text-gray-600">การกระทำ</th>
                <th className="text-left px-6 py-3 font-medium text-gray-600">Entity</th>
                <th className="text-left px-6 py-3 font-medium text-gray-600">รายละเอียด</th>
                <th className="text-left px-6 py-3 font-medium text-gray-600">IP</th>
              </tr>
            </thead>
            <tbody className="divide-y">
              {logs.map((log) => (
                <tr key={log.id} className="hover:bg-gray-50">
                  <td className="px-6 py-3 whitespace-nowrap text-gray-600">
                    {formatDate(log.createdAt)}
                  </td>
                  <td className="px-6 py-3">
                    <div className="font-medium">{log.user?.fullName || 'ระบบ'}</div>
                    <div className="text-xs text-gray-400">{log.user?.role}</div>
                  </td>
                  <td className="px-6 py-3">
                    <span className="inline-block px-2.5 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-700">
                      {getActionLabel(log.action)}
                    </span>
                  </td>
                  <td className="px-6 py-3 font-mono text-xs text-gray-500">
                    {log.entityType}#{log.entityId.slice(0, 8)}
                  </td>
                  <td className="px-6 py-3 max-w-[280px]">
                    {log.metadata ? (
                      <pre className="text-[11px] text-gray-500 overflow-hidden whitespace-pre-wrap">
                        {JSON.stringify(log.metadata, null, 0)}
                      </pre>
                    ) : (
                      <span className="text-gray-400">-</span>
                    )}
                  </td>
                  <td className="px-6 py-3 text-xs text-gray-400 font-mono">{log.ipAddress || '-'}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      <div className="mt-4 text-xs text-gray-400 text-right">
        แสดงผลล่าสุด {logs.length} รายการ (เรียงจากใหม่ไปเก่า)
      </div>
    </div>
  );
}
