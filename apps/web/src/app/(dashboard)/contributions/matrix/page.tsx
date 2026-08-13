'use client';

import { useState, useMemo } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import {
  CheckCircle,
  XCircle,
  AlertTriangle,
  Minus,
  Building2,
  Users,
  Download,
  Filter,
  Search,
  Save,
  Upload,
  FileSpreadsheet,
} from 'lucide-react';
import { api } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import { showSuccess, showError } from '@/lib/toast';
import { canSelectAllSchools, filterSchoolsForUser } from '@/lib/school-scope';
import { UploadPaymentModal, type ReconcileResponse } from './UploadPaymentModal';
import { ReconcileResultPanel } from './ReconcileResultPanel';

interface MonthData {
  status: 'paid' | 'unpaid' | 'arrears' | 'none';
  amount?: number;
  paidDate?: string;
  contributionId?: string;
  periodId?: string;
}

interface MemberRow {
  member: {
    id: string;
    memberNo: string;
    firstName: string;
    lastName: string;
    school: { id: string; name: string; code: string };
    memberType?: string;
    group?: string;
  };
  monthlyData: Record<number, MonthData>;
  summary: {
    totalPaid: number;
    totalUnpaid: number;
    paidMonths: number;
    unpaidMonths: number;
  };
}

interface SchoolSummary {
  schoolId: string;
  schoolName: string;
  schoolCode: string;
  totalMembers: number;
  totalPaid: number;
  totalUnpaid: number;
  monthlyStats: Record<number, { paid: number; unpaid: number; total: number }>;
}

interface MatrixData {
  year: number;
  periods: { id: string; month: number; welfareRate: number; serviceFee: number; isClosed: boolean }[];
  members: MemberRow[];
  schoolSummary: SchoolSummary[];
  totalSummary: { totalMembers: number; totalPaid: number; totalUnpaid: number };
}

interface SchoolOption {
  id: string;
  code: string;
  name: string;
  memberCount: number;
}

const THAI_MONTHS = [
  'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
  'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.',
];

const THAI_MONTHS_FULL = [
  'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
  'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม',
];

export default function ContributionMatrixPage() {
  const queryClient = useQueryClient();
  const { selectedYear, user, selectedSchoolId: globalSchoolId } = useAuthStore();
  const showAllSchoolsOption = canSelectAllSchools(user?.role);
  const selectedSchoolId = showAllSchoolsOption
    ? (globalSchoolId ?? '')
    : (user?.schoolId || '');
  const [search, setSearch] = useState('');
  const [viewMode, setViewMode] = useState<'detail' | 'summary'>('detail');
  const [selectedMonth, setSelectedMonth] = useState<number>(new Date().getMonth() + 1);
  const [showUploadModal, setShowUploadModal] = useState(false);
  // The period id targeted by the currently-open upload modal (fixed for the modal's
  // lifetime since the month selector is unreachable behind the modal overlay).
  const [uploadPeriodId, setUploadPeriodId] = useState<string>('');
  // The completed reconcile result is always set together with the periodId that
  // produced it, in a single object, so the pair can never drift out of sync.
  const [reconcile, setReconcile] = useState<{ result: ReconcileResponse; periodId: string } | null>(null);

  // State สำหรับเก็บการเปลี่ยนแปลงสถานะ
  const [statusChanges, setStatusChanges] = useState<Map<string, { contributionId: string; status: 'paid' | 'unpaid' | 'arrears' }>>(new Map());

  // Fetch schools
  const { data: schools } = useQuery<SchoolOption[]>({
    queryKey: ['matrix-schools', selectedYear],
    queryFn: async () => {
      const response = await api.get(`/contributions/matrix/schools?year=${selectedYear}`);
      return response.data;
    },
  });

  // Fetch matrix data
  const { data: matrixData, isLoading } = useQuery<MatrixData>({
    queryKey: ['contribution-matrix', selectedYear, selectedSchoolId],
    queryFn: async () => {
      const params = new URLSearchParams();
      params.append('year', selectedYear.toString());
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      const response = await api.get(`/contributions/matrix?${params}`);
      return response.data;
    },
  });

  // Filter members by search
  const filteredMembers = useMemo(() => {
    if (!matrixData?.members) return [];
    if (!search) return matrixData.members;

    const searchLower = search.toLowerCase();
    return matrixData.members.filter(
      (row) =>
        row.member.memberNo.toLowerCase().includes(searchLower) ||
        row.member.firstName?.toLowerCase().includes(searchLower) ||
        row.member.lastName?.toLowerCase().includes(searchLower) ||
        row.member.school.name.toLowerCase().includes(searchLower),
    );
  }, [matrixData?.members, search]);

  // Mutation สำหรับบันทึกการชำระเงินหลายรายการ
  const batchPaymentMutation = useMutation({
    mutationFn: async (payments: Array<{ contributionId: string; amount: number; paidDate?: string }>) => {
      const response = await api.post('/contributions/batch-payment', { payments });
      return response.data;
    },
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: ['contribution-matrix'] });
      setStatusChanges(new Map());
      if (data.failed > 0) {
        // แสดงรายละเอียดของรายการที่ล้มเหลว
        const failedItems = data.results?.filter((r: any) => !r.success) || [];

        // แยก error messages เพื่อแสดงให้ชัดเจน
        const errorMessages = failedItems.map((r: any) => {
          const errorMsg = r.error || 'ไม่ทราบสาเหตุ';
          // ถ้า error message ยาวเกินไป ให้แสดงแค่ส่วนสำคัญ
          if (errorMsg.length > 100) {
            return errorMsg.substring(0, 100) + '...';
          }
          return errorMsg;
        });
        
        // ถ้ามี error message เดียว ให้แสดงเต็ม แต่ถ้ามีหลายอันให้แสดงสรุป
        if (errorMessages.length === 1) {
          showError(errorMessages[0]);
        } else {
          showError(`บันทึกสำเร็จ ${data.success} รายการ แต่ล้มเหลว ${data.failed} รายการ - ${errorMessages.join('; ')}`);
        }
      } else {
        showSuccess(`บันทึกสำเร็จ ${data.success} รายการ`);
      }
    },
    onError: (error: any) => {
      console.error('Batch payment error:', error);
      console.error('Error response:', error.response?.data);
      console.error('Error request:', error.config?.data);
      
      // Check for validation errors
      if (error.response?.status === 400) {
        const validationErrors = error.response?.data?.message || error.response?.data;
        if (Array.isArray(validationErrors)) {
          showError(`ข้อมูลไม่ถูกต้อง: ${validationErrors.join(', ')}`);
        } else {
          showError(validationErrors || 'ข้อมูลไม่ถูกต้อง');
        }
      } else {
        const errorMessage = error.response?.data?.message || error.message || 'เกิดข้อผิดพลาดในการบันทึก';
        showError(errorMessage);
      }
    },
  });

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('th-TH', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    }).format(amount);
  };

  // Toggle status for a contribution
  const toggleStatus = (memberId: string, month: number, periodId: string | undefined, contributionId: string | undefined, currentStatus: MonthData['status'], amount: number) => {
    // If no period, show error
    if (!periodId) {
      showError(`ไม่มีงวดสำหรับเดือน ${THAI_MONTHS_FULL[month - 1]}`);
      return;
    }

    // If no contribution, show error (need to generate first)
    if (!contributionId) {
      showError(`ไม่มีรายการเงินสงเคราะห์สำหรับเดือน ${THAI_MONTHS_FULL[month - 1]} กรุณาสร้างรายการก่อน`);
      return;
    }

    const key = `${memberId}-${month}`;
    const currentChange = statusChanges.get(key);

    let newStatus: 'paid' | 'unpaid' | 'arrears';
    if (currentStatus === 'paid' || currentChange?.status === 'paid') {
      // Toggle to unpaid/arrears
      newStatus = 'unpaid';
    } else {
      // Toggle to paid
      newStatus = 'paid';
    }

    const newChanges = new Map(statusChanges);
    if (newStatus === currentStatus && !currentChange) {
      // No change needed, remove if exists
      newChanges.delete(key);
    } else {
      newChanges.set(key, {
        contributionId,
        status: newStatus,
      });
    }
    setStatusChanges(newChanges);
  };

  // Handle save all changes
  const handleSaveAll = () => {
    if (statusChanges.size === 0) {
      showError('ไม่มีรายการที่เปลี่ยนแปลง');
      return;
    }

    // Build payments array from statusChanges
    const payments: Array<{ contributionId: string; amount: number; paidDate?: string }> = [];

    statusChanges.forEach((change, key) => {
      // Find the contribution data
      const [memberId, monthStr] = key.split('-');
      const month = parseInt(monthStr);
      const memberRow = matrixData?.members.find((m) => m.member.id === memberId);
      
      if (memberRow) {
        const monthData = memberRow.monthlyData[month];
        if (monthData && monthData.contributionId) {
          if (change.status === 'paid') {
            // Mark as paid
            const amount = typeof monthData.amount === 'number' ? monthData.amount : 0;
            if (amount > 0) {
              payments.push({
                contributionId: monthData.contributionId,
                amount: Number(amount),
                paidDate: new Date().toISOString().split('T')[0],
              });
            } else {
              console.warn(`Amount is 0 or invalid for contribution ${monthData.contributionId}, skipping`);
            }
          } else if (change.status === 'unpaid' || change.status === 'arrears') {
            // Cancel payment (set amount to 0)
            // Don't include paidDate when cancelling payment
            payments.push({
              contributionId: monthData.contributionId,
              amount: 0,
            });
          }
        } else {
          console.warn(`No contribution data found for member ${memberId}, month ${month}`);
        }
      } else {
        console.warn(`Member row not found for memberId: ${memberId}`);
      }
    });

    if (payments.length === 0) {
      showError('ไม่มีรายการที่ต้องบันทึก');
      return;
    }

    batchPaymentMutation.mutate(payments);
  };

  // Status cell component
  const StatusCell = ({ 
    data, 
    memberId, 
    month, 
    periodId, 
    contributionId,
    amount 
  }: { 
    data: MonthData;
    memberId: string;
    month: number;
    periodId?: string;
    contributionId?: string;
    amount: number;
  }) => {
    const key = `${memberId}-${month}`;
    const change = statusChanges.get(key);
    const displayStatus = change?.status || data.status;
    const isChanged = statusChanges.has(key);

    const handleClick = () => {
      toggleStatus(memberId, month, periodId, contributionId, data.status, amount);
    };

    // Status: none (ไม่มีรายการ)
    if (data.status === 'none') {
      return (
        <div 
          className={`flex items-center justify-center text-slate-300 cursor-pointer hover:bg-slate-50 rounded p-1 transition-colors ${isChanged ? 'ring-2 ring-primary-500' : ''}`}
          title={`ไม่มีรายการ (คลิกเพื่อเช็ค)`}
          onClick={handleClick}
        >
          <Minus size={16} />
        </div>
      );
    }

    // Status: paid (ชำระแล้ว)
    if (displayStatus === 'paid') {
      return (
        <div 
          className={`flex items-center justify-center text-emerald-600 cursor-pointer hover:bg-emerald-50 rounded p-1 transition-colors ${isChanged ? 'ring-2 ring-primary-500' : ''}`}
          title={`ชำระแล้ว ${formatCurrency(amount)} บาท (คลิกเพื่อยกเลิก)`}
          onClick={handleClick}
        >
          <CheckCircle size={18} />
        </div>
      );
    }

    // Status: arrears (ค้างชำระ)
    if (displayStatus === 'arrears') {
      return (
        <div 
          className={`flex items-center justify-center text-red-600 cursor-pointer hover:bg-red-50 rounded p-1 transition-colors ${isChanged ? 'ring-2 ring-primary-500' : ''}`}
          title={`ค้างชำระ ${formatCurrency(amount)} บาท (คลิกเพื่อชำระ)`}
          onClick={handleClick}
        >
          <XCircle size={18} />
        </div>
      );
    }

    // Status: unpaid (ยังไม่ชำระ)
    return (
      <div 
        className={`flex items-center justify-center text-amber-500 cursor-pointer hover:bg-amber-50 rounded p-1 transition-colors ${isChanged ? 'ring-2 ring-primary-500' : ''}`}
        title={`ยังไม่ชำระ ${formatCurrency(amount)} บาท (คลิกเพื่อชำระ)`}
        onClick={handleClick}
      >
        <AlertTriangle size={18} />
      </div>
    );
  };

  // Download Template Excel
  const handleDownloadTemplate = async () => {
    try {
      const response = await api.get(
        `/contributions/template?year=${selectedYear}&month=${selectedMonth}`,
        { responseType: 'blob' },
      );
      const url = URL.createObjectURL(response.data as Blob);
      const link = document.createElement('a');
      link.href = url;
      link.download = `Template_การชำระเงิน_${selectedYear + 543}_${THAI_MONTHS_FULL[selectedMonth - 1]}.xlsx`;
      link.click();
      URL.revokeObjectURL(url);
      showSuccess('ดาวน์โหลด Template สำเร็จ');
    } catch {
      showError('เกิดข้อผิดพลาดในการดาวน์โหลด');
    }
  };

  // Open upload modal — resolve the period id for the selected month up front, and
  // discard any previously-shown reconcile result so a stale panel can never stay
  // paired with the newly-targeted period.
  const handleOpenUploadModal = () => {
    const period = matrixData?.periods.find((p) => p.month === selectedMonth);
    if (!period) {
      showError(`ไม่มีงวดสำหรับเดือน ${THAI_MONTHS_FULL[selectedMonth - 1]} กรุณาสร้างงวดก่อน`);
      return;
    }
    setUploadPeriodId(period.id);
    setReconcile(null);
    setShowUploadModal(true);
  };

  // Closing the modal without completing an upload must not leave a stale result
  // panel behind — reconcile is already cleared on open, this is a second guard.
  const handleCloseUploadModal = () => {
    setShowUploadModal(false);
    setUploadPeriodId('');
    setReconcile(null);
  };

  // Send arrears notice — confirm first, since this can trigger membership termination
  // for members who meet the cutoff (processArrearsAfterNotice on the backend)
  const handleSendArrearsNotice = async () => {
    if (!reconcile) return;
    const confirmed = window.confirm(
      `จะแจ้งเตือนค้างชำระ ${reconcile.result.missing.length} ราย\n` +
        'สมาชิกที่ครบเงื่อนไขตามระเบียบอาจถูกตัดสมาชิกภาพจากการดำเนินการนี้ ยืนยันหรือไม่',
    );
    if (!confirmed) return;

    try {
      const response = await api.post(
        `/contributions/periods/${reconcile.periodId}/send-arrears-notice`,
      );
      showSuccess(response.data.message);
      queryClient.invalidateQueries({ queryKey: ['contribution-matrix'] });
    } catch {
      showError('แจ้งเตือนค้างชำระไม่สำเร็จ');
    }
  };

  // Export to CSV
  const handleExport = () => {
    if (!matrixData) return;

    const headers = ['เลขสมาชิก', 'ชื่อ-นามสกุล', 'โรงเรียน', 'ประเภท', 'กลุ่ม'];
    THAI_MONTHS_FULL.forEach((m) => headers.push(m));
    headers.push('ชำระแล้ว', 'ค้างชำระ');

    const rows = filteredMembers.map((row) => {
      const data = [
        row.member.memberNo,
        `${row.member.firstName} ${row.member.lastName}`,
        row.member.school.name,
        row.member.memberType || '-',
        row.member.group || '-',
      ];

      for (let m = 1; m <= 12; m++) {
        const status = row.monthlyData[m]?.status;
        if (status === 'paid') data.push('ชำระแล้ว');
        else if (status === 'unpaid') data.push('ยังไม่ชำระ');
        else if (status === 'arrears') data.push('ค้างชำระ');
        else data.push('-');
      }

      data.push(formatCurrency(row.summary.totalPaid));
      data.push(formatCurrency(row.summary.totalUnpaid));

      return data;
    });

    const csvContent = [headers.join(','), ...rows.map((r) => r.join(','))].join('\n');
    const blob = new Blob(['\ufeff' + csvContent], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = `การชำระเงินสงเคราะห์_${selectedYear + 543}.csv`;
    link.click();
  };

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
            ตารางการชำระเงินสงเคราะห์
          </h1>
          <p className="text-slate-500 mt-1">
            ตรวจสอบการนำส่งเงินสงเคราะห์ล่วงหน้า ปี พ.ศ. {selectedYear + 543}
          </p>
        </div>
        <div className="flex gap-2">
          <button onClick={handleDownloadTemplate} className="btn-secondary" disabled={!matrixData}>
            <FileSpreadsheet size={20} />
            ดาวน์โหลด Template
          </button>
          <button onClick={handleOpenUploadModal} className="btn-primary" disabled={!matrixData}>
            <Upload size={20} />
            อัปโหลด Excel
          </button>
          <button onClick={handleExport} className="btn-secondary" disabled={!matrixData}>
            <Download size={20} />
            ส่งออก CSV
          </button>
        </div>
      </div>

      {showUploadModal && (
        <UploadPaymentModal
          year={selectedYear}
          month={selectedMonth}
          canUseFullDistrict={['ADMIN', 'FINANCE'].includes(user?.role ?? '')}
          onClose={handleCloseUploadModal}
          onDone={(result) => {
            setShowUploadModal(false);
            setReconcile({ result, periodId: uploadPeriodId });
            queryClient.invalidateQueries({ queryKey: ['contribution-matrix'] });
            showSuccess(`บันทึกชำระ ${result.success} รายการ · ขาด ${result.missing.length} คน`);
          }}
        />
      )}

      {reconcile && (
        <ReconcileResultPanel
          result={reconcile.result}
          periodId={reconcile.periodId}
          onClose={() => setReconcile(null)}
          onSendNotice={handleSendArrearsNotice}
        />
      )}

      {/* Filters */}
      <div className="card p-4">
        <div className="flex flex-col md:flex-row gap-4">
          {/* Month selector for Template/Upload */}
          <div className="w-full md:w-48">
            <label className="block text-sm font-medium text-slate-700 mb-1">
              เดือน (สำหรับ Template/Upload)
            </label>
            <select
              value={selectedMonth}
              onChange={(e) => setSelectedMonth(Number(e.target.value))}
              className="input"
            >
              {THAI_MONTHS_FULL.map((month, index) => (
                <option key={index + 1} value={index + 1}>
                  {month}
                </option>
              ))}
            </select>
          </div>

          {/* School filter */}
          <div className="flex-1">
            <div className="flex items-center gap-2">
              <Building2 size={18} className="text-slate-400" />
              <select
                value={selectedSchoolId}
                disabled
                className="input disabled:cursor-default bg-slate-50"
                title="ใช้ตัวกรองโรงเรียนจากแถบด้านบน"
              >
                {showAllSchoolsOption && (
                  <option value="">
                    ทุกโรงเรียน ({schools?.reduce((sum, s) => sum + s.memberCount, 0) || 0} คน)
                  </option>
                )}
                {filterSchoolsForUser(schools ?? [], user?.role, user?.schoolId).map((school) => (
                  <option key={school.id} value={school.id}>
                    {school.name} ({school.memberCount} คน)
                  </option>
                ))}
              </select>
            </div>
          </div>

          {/* Search */}
          <div className="flex-1 relative">
            <Search
              size={20}
              className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400"
            />
            <input
              type="text"
              placeholder="ค้นหาเลขสมาชิก, ชื่อ..."
              className="input pl-10"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
          </div>

          {/* View mode */}
          <div className="flex gap-2">
            <button
              onClick={() => setViewMode('detail')}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
                viewMode === 'detail'
                  ? 'bg-primary-100 text-primary-700'
                  : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
              }`}
            >
              รายละเอียด
            </button>
            <button
              onClick={() => setViewMode('summary')}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
                viewMode === 'summary'
                  ? 'bg-primary-100 text-primary-700'
                  : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
              }`}
            >
              สรุปโรงเรียน
            </button>
          </div>
        </div>
      </div>

      {/* Summary stats */}
      {matrixData && (
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <div className="stat-card">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-primary-100 rounded-lg flex items-center justify-center">
                <Users className="w-5 h-5 text-primary-600" />
              </div>
              <div>
                <p className="stat-label">สมาชิกทั้งหมด</p>
                <p className="text-xl font-bold text-slate-900">
                  {matrixData.totalSummary.totalMembers.toLocaleString()} คน
                </p>
              </div>
            </div>
          </div>
          <div className="stat-card">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-emerald-100 rounded-lg flex items-center justify-center">
                <CheckCircle className="w-5 h-5 text-emerald-600" />
              </div>
              <div>
                <p className="stat-label">ยอดชำระแล้ว</p>
                <p className="text-xl font-bold text-emerald-600">
                  {formatCurrency(matrixData.totalSummary.totalPaid)} บาท
                </p>
              </div>
            </div>
          </div>
          <div className="stat-card">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-amber-100 rounded-lg flex items-center justify-center">
                <AlertTriangle className="w-5 h-5 text-amber-600" />
              </div>
              <div>
                <p className="stat-label">ยอดค้างชำระ</p>
                <p className="text-xl font-bold text-amber-600">
                  {formatCurrency(matrixData.totalSummary.totalUnpaid)} บาท
                </p>
              </div>
            </div>
          </div>
          <div className="stat-card">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-sky-100 rounded-lg flex items-center justify-center">
                <Building2 className="w-5 h-5 text-sky-600" />
              </div>
              <div>
                <p className="stat-label">โรงเรียน</p>
                <p className="text-xl font-bold text-sky-600">
                  {matrixData.schoolSummary.length} แห่ง
                </p>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Legend & Save Button */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div className="flex items-center gap-6 text-sm">
          <div className="flex items-center gap-2">
            <CheckCircle size={18} className="text-emerald-600" />
            <span>ชำระแล้ว</span>
          </div>
          <div className="flex items-center gap-2">
            <AlertTriangle size={18} className="text-amber-500" />
            <span>ยังไม่ชำระ</span>
          </div>
          <div className="flex items-center gap-2">
            <XCircle size={18} className="text-red-600" />
            <span>ค้างชำระ</span>
          </div>
          <div className="flex items-center gap-2">
            <Minus size={18} className="text-slate-300" />
            <span>ไม่มีรายการ</span>
          </div>
        </div>
        {statusChanges.size > 0 && viewMode === 'detail' && (
          <button
            onClick={handleSaveAll}
            disabled={batchPaymentMutation.isPending}
            className="btn-primary flex items-center gap-2"
          >
            <Save size={18} />
            บันทึกทั้งหมด ({statusChanges.size} รายการ)
          </button>
        )}
      </div>

      {/* Matrix Table */}
      {isLoading ? (
        <div className="flex items-center justify-center py-20">
          <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : viewMode === 'detail' ? (
        /* Detail View - Member Matrix */
        <div className="card overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead className="bg-slate-50 sticky top-0">
                <tr>
                  <th className="px-3 py-3 text-left font-semibold text-slate-700 whitespace-nowrap sticky left-0 bg-slate-50 z-10 border-r border-slate-200">
                    เลขสมาชิก
                  </th>
                  <th className="px-3 py-3 text-left font-semibold text-slate-700 whitespace-nowrap min-w-[150px]">
                    ชื่อ-นามสกุล
                  </th>
                  <th className="px-3 py-3 text-left font-semibold text-slate-700 whitespace-nowrap">
                    โรงเรียน
                  </th>
                  {THAI_MONTHS.map((month, idx) => (
                    <th key={idx} className="px-2 py-3 text-center font-semibold text-slate-700 whitespace-nowrap w-14">
                      {month}
                    </th>
                  ))}
                  <th className="px-3 py-3 text-right font-semibold text-emerald-700 whitespace-nowrap bg-emerald-50">
                    ชำระแล้ว
                  </th>
                  <th className="px-3 py-3 text-right font-semibold text-amber-700 whitespace-nowrap bg-amber-50">
                    ค้างชำระ
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {filteredMembers.length === 0 ? (
                  <tr>
                    <td colSpan={17} className="text-center py-10 text-slate-500">
                      ไม่พบข้อมูล
                    </td>
                  </tr>
                ) : (
                  filteredMembers.map((row) => (
                    <tr key={row.member.id} className="hover:bg-slate-50">
                      <td className="px-3 py-2 font-mono text-xs sticky left-0 bg-white border-r border-slate-100 z-10">
                        {row.member.memberNo}
                      </td>
                      <td className="px-3 py-2 whitespace-nowrap">
                        {row.member.firstName ?? ''} {row.member.lastName ?? ''}
                      </td>
                      <td className="px-3 py-2 text-slate-500 text-xs whitespace-nowrap">
                        {row.member.school.code}
                      </td>
                      {Array.from({ length: 12 }, (_, i) => i + 1).map((month) => {
                        const monthData = row.monthlyData[month] || { status: 'none' as const };
                        return (
                          <td key={month} className="px-2 py-2 text-center">
                            <StatusCell
                              data={monthData}
                              memberId={row.member.id}
                              month={month}
                              periodId={monthData.periodId}
                              contributionId={monthData.contributionId}
                              amount={monthData.amount || 0}
                            />
                          </td>
                        );
                      })}
                      <td className="px-3 py-2 text-right font-medium text-emerald-600 bg-emerald-50/50">
                        {formatCurrency(row.summary.totalPaid)}
                      </td>
                      <td className="px-3 py-2 text-right font-medium text-amber-600 bg-amber-50/50">
                        {formatCurrency(row.summary.totalUnpaid)}
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
          {filteredMembers.length > 0 && (
            <div className="px-4 py-3 border-t border-slate-100 text-sm text-slate-500">
              แสดง {filteredMembers.length.toLocaleString()} รายการ
            </div>
          )}
        </div>
      ) : (
        /* Summary View - School Summary */
        <div className="card overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead className="bg-slate-50">
                <tr>
                  <th className="px-4 py-3 text-left font-semibold text-slate-700 whitespace-nowrap sticky left-0 bg-slate-50 z-10">
                    โรงเรียน
                  </th>
                  <th className="px-3 py-3 text-center font-semibold text-slate-700 whitespace-nowrap">
                    สมาชิก
                  </th>
                  {THAI_MONTHS.map((month, idx) => (
                    <th key={idx} className="px-2 py-3 text-center font-semibold text-slate-700 whitespace-nowrap w-16">
                      {month}
                    </th>
                  ))}
                  <th className="px-3 py-3 text-right font-semibold text-emerald-700 whitespace-nowrap bg-emerald-50">
                    ชำระแล้ว
                  </th>
                  <th className="px-3 py-3 text-right font-semibold text-amber-700 whitespace-nowrap bg-amber-50">
                    ค้างชำระ
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {matrixData?.schoolSummary.map((school) => (
                  <tr key={school.schoolId} className="hover:bg-slate-50">
                    <td className="px-4 py-3 font-medium sticky left-0 bg-white z-10">
                      <div>
                        <p className="text-slate-900">{school.schoolName}</p>
                        <p className="text-xs text-slate-500">{school.schoolCode}</p>
                      </div>
                    </td>
                    <td className="px-3 py-3 text-center font-medium">
                      {school.totalMembers}
                    </td>
                    {Array.from({ length: 12 }, (_, i) => i + 1).map((month) => {
                      const stats = school.monthlyStats[month];
                      const total = stats?.total || 0;
                      const paid = stats?.paid || 0;
                      const percentage = total > 0 ? Math.round((paid / total) * 100) : 0;

                      return (
                        <td key={month} className="px-2 py-3 text-center">
                          {total > 0 ? (
                            <div className="flex flex-col items-center gap-1">
                              <span
                                className={`text-xs font-medium ${
                                  percentage === 100
                                    ? 'text-emerald-600'
                                    : percentage >= 50
                                    ? 'text-amber-600'
                                    : 'text-red-600'
                                }`}
                              >
                                {percentage}%
                              </span>
                              <span className="text-[10px] text-slate-400">
                                {paid}/{total}
                              </span>
                            </div>
                          ) : (
                            <span className="text-slate-300">-</span>
                          )}
                        </td>
                      );
                    })}
                    <td className="px-3 py-3 text-right font-semibold text-emerald-600 bg-emerald-50/50">
                      {formatCurrency(school.totalPaid)}
                    </td>
                    <td className="px-3 py-3 text-right font-semibold text-amber-600 bg-amber-50/50">
                      {formatCurrency(school.totalUnpaid)}
                    </td>
                  </tr>
                ))}
              </tbody>
              {/* Total row */}
              <tfoot className="bg-slate-100 font-semibold">
                <tr>
                  <td className="px-4 py-3 sticky left-0 bg-slate-100 z-10">รวมทั้งหมด</td>
                  <td className="px-3 py-3 text-center">
                    {matrixData?.totalSummary.totalMembers}
                  </td>
                  {Array.from({ length: 12 }, (_, i) => (
                    <td key={i} className="px-2 py-3 text-center text-slate-500">-</td>
                  ))}
                  <td className="px-3 py-3 text-right text-emerald-700 bg-emerald-100">
                    {formatCurrency(matrixData?.totalSummary.totalPaid || 0)}
                  </td>
                  <td className="px-3 py-3 text-right text-amber-700 bg-amber-100">
                    {formatCurrency(matrixData?.totalSummary.totalUnpaid || 0)}
                  </td>
                </tr>
              </tfoot>
            </table>
          </div>
        </div>
      )}
    </motion.div>
  );
}

