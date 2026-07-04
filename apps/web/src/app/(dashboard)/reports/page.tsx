'use client';

import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { 
  BarChart3, 
  Users, 
  Flower2, 
  DollarSign, 
  TrendingUp, 
  TrendingDown,
  Building2,
  Calendar,
  FileText,
  Download
} from 'lucide-react';
import { api } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import ThaiDatePicker from '@/components/ThaiDatePicker';
import dayjs from 'dayjs';
import { formatThaiDateShort } from '@/components/ThaiDatePicker';

export default function ReportsPage() {
  const { selectedSchoolId, selectedYear } = useAuthStore();
  const [reportType, setReportType] = useState<'members' | 'financial' | 'death-benefits'>('members');
  const [dateRange, setDateRange] = useState({
    startDate: `${selectedYear}-01-01`,
    endDate: `${selectedYear}-12-31`,
  });
  const [deathBenefitFilterMode, setDeathBenefitFilterMode] = useState<'year' | 'range'>('year');
  const [deathBenefitRange, setDeathBenefitRange] = useState({
    startDate: `${selectedYear}-01-01`,
    endDate: `${selectedYear}-12-31`,
  });

  const { data: memberStats, isLoading: loadingMembers } = useQuery({
    queryKey: ['member-stats', selectedYear, selectedSchoolId],
    queryFn: async () => {
      const params = new URLSearchParams({ year: selectedYear.toString() });
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      const response = await api.get(`/reports/members?${params}`);
      return response.data;
    },
    enabled: reportType === 'members',
  });

  const { data: financialSummary, isLoading: loadingFinancial } = useQuery({
    queryKey: ['financial-summary', selectedSchoolId, dateRange],
    queryFn: async () => {
      const params = new URLSearchParams({
        startDate: dateRange.startDate,
        endDate: dateRange.endDate,
      });
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      const response = await api.get(`/reports/financial?${params}`);
      return response.data;
    },
    enabled: reportType === 'financial',
  });

  const { data: deathBenefitReport, isLoading: loadingDeathBenefits } = useQuery({
    queryKey: [
      'death-benefit-report',
      selectedSchoolId,
      selectedYear,
      deathBenefitFilterMode,
      deathBenefitRange,
    ],
    queryFn: async () => {
      const params =
        deathBenefitFilterMode === 'range'
          ? new URLSearchParams(deathBenefitRange)
          : new URLSearchParams({ year: selectedYear.toString() });
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      const response = await api.get(`/reports/death-benefits?${params}`);
      return response.data;
    },
    enabled: reportType === 'death-benefits',
  });

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('th-TH', {
      style: 'currency',
      currency: 'THB',
      minimumFractionDigits: 0,
    }).format(amount);
  };

  const formatDate = (dateString: string) => {
    return formatThaiDateShort(dateString);
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
            รายงาน
          </h1>
          <p className="text-slate-500 mt-1">
            รายงานสรุปข้อมูลสมาชิกและการเงิน ปี พ.ศ. {selectedYear + 543}
          </p>
        </div>
      </div>

      {/* Report Type Tabs */}
      <div className="flex gap-2 flex-wrap">
        <button
          onClick={() => setReportType('members')}
          className={`flex items-center gap-2 px-4 py-2.5 rounded-xl font-medium transition-colors ${
            reportType === 'members'
              ? 'bg-primary-500 text-white shadow-lg shadow-primary-500/25'
              : 'bg-white text-slate-600 hover:bg-slate-50 border border-slate-200'
          }`}
        >
          <Users size={18} />
          สถิติสมาชิก
        </button>
        <button
          onClick={() => setReportType('financial')}
          className={`flex items-center gap-2 px-4 py-2.5 rounded-xl font-medium transition-colors ${
            reportType === 'financial'
              ? 'bg-primary-500 text-white shadow-lg shadow-primary-500/25'
              : 'bg-white text-slate-600 hover:bg-slate-50 border border-slate-200'
          }`}
        >
          <DollarSign size={18} />
          สรุปการเงิน
        </button>
        <button
          onClick={() => setReportType('death-benefits')}
          className={`flex items-center gap-2 px-4 py-2.5 rounded-xl font-medium transition-colors ${
            reportType === 'death-benefits'
              ? 'bg-primary-500 text-white shadow-lg shadow-primary-500/25'
              : 'bg-white text-slate-600 hover:bg-slate-50 border border-slate-200'
          }`}
        >
          <Flower2 size={18} />
          เงินสงเคราะห์ศพ
        </button>
      </div>

      {/* Members Report */}
      {reportType === 'members' && (
        <div className="space-y-6">
          {loadingMembers ? (
            <div className="flex justify-center py-20">
              <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
            </div>
          ) : (
            <>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {memberStats?.map((stat: any) => (
                  <div key={stat.school.id} className="card p-5">
                    <div className="flex items-center gap-3 mb-4">
                      <div className="w-10 h-10 bg-primary-100 rounded-lg flex items-center justify-center">
                        <Building2 className="w-5 h-5 text-primary-600" />
                      </div>
                      <div>
                        <h3 className="font-semibold text-slate-900">{stat.school.name}</h3>
                        <p className="text-2xl font-bold text-primary-600">{stat.stats.total} คน</p>
                      </div>
                    </div>
                    <div className="space-y-2">
                      {stat.stats.byStatus.map((s: any) => (
                        <div key={s.status} className="flex justify-between text-sm">
                          <span className="text-slate-500">
                            {s.status === 'ACTIVE' ? 'ปกติ' :
                             s.status === 'RESIGNED' ? 'ลาออก' :
                             s.status === 'DECEASED' ? 'เสียชีวิต' :
                             s.status === 'ARREARS' ? 'ค้างชำระ' : s.status}
                          </span>
                          <span className="font-medium">{s.count}</span>
                        </div>
                      ))}
                    </div>
                  </div>
                ))}
              </div>
            </>
          )}
        </div>
      )}

      {/* Financial Report */}
      {reportType === 'financial' && (
        <div className="space-y-6">
          {/* Date Range Filter */}
          <div className="card p-4">
            <div className="flex flex-wrap items-center gap-4">
              <div className="flex items-center gap-2">
                <Calendar size={18} className="text-slate-400" />
                <span className="text-sm text-slate-600">ช่วงเวลา:</span>
              </div>
              <ThaiDatePicker
                value={dateRange.startDate ? dayjs(dateRange.startDate) : null}
                onChange={(date) => setDateRange({ ...dateRange, startDate: date ? date.format('YYYY-MM-DD') : '' })}
                placeholder="เลือกวันเริ่มต้น"
                style={{ width: 160 }}
              />
              <span className="text-slate-400">ถึง</span>
              <ThaiDatePicker
                value={dateRange.endDate ? dayjs(dateRange.endDate) : null}
                onChange={(date) => setDateRange({ ...dateRange, endDate: date ? date.format('YYYY-MM-DD') : '' })}
                placeholder="เลือกวันสิ้นสุด"
                style={{ width: 160 }}
              />
            </div>
          </div>

          {loadingFinancial ? (
            <div className="flex justify-center py-20">
              <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
            </div>
          ) : (
            <>
              {/* Summary Cards */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div className="stat-card bg-gradient-to-br from-emerald-500 to-emerald-600 text-white">
                  <div className="flex items-center gap-3">
                    <TrendingUp className="w-8 h-8 opacity-80" />
                    <div>
                      <p className="text-emerald-100">รายรับรวม</p>
                      <p className="text-2xl font-bold">{formatCurrency(financialSummary?.income?.total || 0)}</p>
                    </div>
                  </div>
                </div>
                <div className="stat-card bg-gradient-to-br from-red-500 to-red-600 text-white">
                  <div className="flex items-center gap-3">
                    <TrendingDown className="w-8 h-8 opacity-80" />
                    <div>
                      <p className="text-red-100">รายจ่ายรวม</p>
                      <p className="text-2xl font-bold">{formatCurrency(financialSummary?.expense?.total || 0)}</p>
                    </div>
                  </div>
                </div>
                <div className="stat-card bg-gradient-to-br from-sky-500 to-sky-600 text-white">
                  <div className="flex items-center gap-3">
                    <DollarSign className="w-8 h-8 opacity-80" />
                    <div>
                      <p className="text-sky-100">รายได้สุทธิ</p>
                      <p className="text-2xl font-bold">{formatCurrency(financialSummary?.netIncome || 0)}</p>
                    </div>
                  </div>
                </div>
              </div>

              {/* Details */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="card p-5">
                  <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
                    <TrendingUp className="w-5 h-5 text-emerald-500" />
                    รายรับตามประเภท
                  </h3>
                  <div className="space-y-3">
                    {financialSummary?.income?.byType?.map((item: any) => (
                      <div key={item.type} className="flex justify-between items-center">
                        <span className="text-slate-600">{item.type}</span>
                        <div className="text-right">
                          <span className="font-semibold text-emerald-600">{formatCurrency(item.amount)}</span>
                          <span className="text-sm text-slate-400 ml-2">({item.count} รายการ)</span>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>

                <div className="card p-5">
                  <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
                    <TrendingDown className="w-5 h-5 text-red-500" />
                    รายจ่ายตามประเภท
                  </h3>
                  <div className="space-y-3">
                    {financialSummary?.expense?.byType?.map((item: any) => (
                      <div key={item.type} className="flex justify-between items-center">
                        <span className="text-slate-600">{item.type}</span>
                        <div className="text-right">
                          <span className="font-semibold text-red-600">{formatCurrency(item.amount)}</span>
                          <span className="text-sm text-slate-400 ml-2">({item.count} รายการ)</span>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </>
          )}
        </div>
      )}

      {/* Death Benefits Report */}
      {reportType === 'death-benefits' && (
        <div className="space-y-6">
          {/* Filter mode: by year (default) or by explicit date range */}
          <div className="card p-4 flex flex-wrap items-center gap-4">
            <div className="flex gap-2">
              <button
                onClick={() => setDeathBenefitFilterMode('year')}
                className={`px-3 py-1.5 rounded-lg text-sm font-medium ${
                  deathBenefitFilterMode === 'year'
                    ? 'bg-primary-500 text-white'
                    : 'bg-slate-100 text-slate-600'
                }`}
              >
                ตามปี
              </button>
              <button
                onClick={() => setDeathBenefitFilterMode('range')}
                className={`px-3 py-1.5 rounded-lg text-sm font-medium ${
                  deathBenefitFilterMode === 'range'
                    ? 'bg-primary-500 text-white'
                    : 'bg-slate-100 text-slate-600'
                }`}
              >
                ตามช่วงวันที่
              </button>
            </div>
            {deathBenefitFilterMode === 'range' && (
              <>
                <ThaiDatePicker
                  value={deathBenefitRange.startDate ? dayjs(deathBenefitRange.startDate) : null}
                  onChange={(date) =>
                    setDeathBenefitRange({
                      ...deathBenefitRange,
                      startDate: date ? date.format('YYYY-MM-DD') : '',
                    })
                  }
                  placeholder="วันเริ่มต้น"
                  style={{ width: 160 }}
                />
                <span className="text-slate-400">ถึง</span>
                <ThaiDatePicker
                  value={deathBenefitRange.endDate ? dayjs(deathBenefitRange.endDate) : null}
                  onChange={(date) =>
                    setDeathBenefitRange({
                      ...deathBenefitRange,
                      endDate: date ? date.format('YYYY-MM-DD') : '',
                    })
                  }
                  placeholder="วันสิ้นสุด"
                  style={{ width: 160 }}
                />
              </>
            )}
          </div>

          {loadingDeathBenefits ? (
            <div className="flex justify-center py-20">
              <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
            </div>
          ) : (
            <>
              {/* Summary */}
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div className="stat-card">
                  <p className="stat-label">แจ้งเสียชีวิต</p>
                  <p className="stat-value">{deathBenefitReport?.summary?.totalClaims || 0}</p>
                </div>
                <div className="stat-card">
                  <p className="stat-label">จ่ายแล้ว</p>
                  <p className="text-2xl font-bold text-emerald-600">{deathBenefitReport?.summary?.paid || 0}</p>
                </div>
                <div className="stat-card">
                  <p className="stat-label">รอจ่าย</p>
                  <p className="text-2xl font-bold text-amber-600">{deathBenefitReport?.summary?.unpaid || 0}</p>
                </div>
                <div className="stat-card">
                  <p className="stat-label">ยอดจ่ายรวม</p>
                  <p className="text-xl font-bold text-primary-600">
                    {formatCurrency(deathBenefitReport?.summary?.totalPaid || 0)}
                  </p>
                </div>
              </div>

              {/* Claims Table */}
              <div className="card overflow-hidden">
                <div className="px-4 py-3 bg-slate-50 border-b border-slate-200">
                  <h3 className="font-semibold text-slate-900">รายการแจ้งเสียชีวิต</h3>
                </div>
                {deathBenefitReport?.claims?.length === 0 ? (
                  <div className="text-center py-10 text-slate-500">
                    <Flower2 className="w-12 h-12 mx-auto text-slate-300 mb-3" />
                    <p>ไม่มีข้อมูลการแจ้งเสียชีวิตในช่วงเวลานี้</p>
                  </div>
                ) : (
                  <div className="table-container border-0">
                    <table className="table">
                      <thead>
                        <tr>
                          <th>เลขที่</th>
                          <th>ชื่อสมาชิก</th>
                          <th>โรงเรียน</th>
                          <th>วันที่เสียชีวิต</th>
                          <th className="text-right">ยอดรวมก่อนหัก</th>
                          <th className="text-right">หักค่าธรรมเนียม</th>
                          <th className="text-right">เงินสงเคราะห์สุทธิ</th>
                          <th>สถานะ</th>
                        </tr>
                      </thead>
                      <tbody>
                        {deathBenefitReport?.claims?.map((claim: any) => (
                          <tr key={claim.id}>
                            <td className="font-mono text-sm">{claim.claimNo}</td>
                            <td className="font-medium">
                              {claim.member.associationMember?.firstName} {claim.member.associationMember?.lastName}
                            </td>
                            <td className="text-slate-500">{claim.school.name}</td>
                            <td>{formatDate(claim.deathDate)}</td>
                            <td className="text-right">{formatCurrency(claim.grossAmount)}</td>
                            <td className="text-right text-red-600">{formatCurrency(claim.feeDeduction)}</td>
                            <td className="text-right font-semibold">
                              {formatCurrency(claim.netToPay)}
                            </td>
                            <td>
                              {claim.payment ? (
                                <span className="badge-success">จ่ายแล้ว</span>
                              ) : (
                                <span className="badge-warning">รอจ่าย</span>
                              )}
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                )}
              </div>
            </>
          )}
        </div>
      )}
    </motion.div>
  );
}


