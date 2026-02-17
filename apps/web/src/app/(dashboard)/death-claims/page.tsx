'use client';

import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import {
  Plus,
  Search,
  Eye,
  Flower2,
  Calendar,
  User,
  DollarSign,
  CheckCircle,
  Clock,
} from 'lucide-react';
import Link from 'next/link';
import { api, type DeathClaim } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import { formatThaiDateShort } from '@/components/ThaiDatePicker';

export default function DeathClaimsPage() {
  const { selectedSchoolId, selectedYear } = useAuthStore();
  const [search, setSearch] = useState('');

  const { data: claims, isLoading } = useQuery<DeathClaim[]>({
    queryKey: ['death-claims', selectedSchoolId, selectedYear],
    queryFn: async () => {
      const params = new URLSearchParams();
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      params.append('year', selectedYear.toString());
      const response = await api.get(`/death-claims?${params}`);
      return response.data;
    },
  });

  const { data: stats } = useQuery({
    queryKey: ['death-claims-stats', selectedYear],
    queryFn: async () => {
      const response = await api.get(`/death-claims/stats?year=${selectedYear}`);
      return response.data;
    },
  });

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('th-TH', {
      style: 'currency',
      currency: 'THB',
      minimumFractionDigits: 0,
    }).format(amount);
  };

  // ใช้ formatThaiDateShort แสดงปี พ.ศ.
  const formatDate = formatThaiDateShort;

  const filteredClaims = claims?.filter(
    (claim) =>
      claim.member.firstName.toLowerCase().includes(search.toLowerCase()) ||
      claim.member.lastName.toLowerCase().includes(search.toLowerCase()) ||
      claim.claimNo.toLowerCase().includes(search.toLowerCase()),
  );

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
            การแจ้งเสียชีวิต
          </h1>
          <p className="text-slate-500 mt-1">
            บันทึกและจัดการข้อมูลการเสียชีวิตของสมาชิก ปี พ.ศ. {selectedYear + 543}
          </p>
        </div>
        <Link href="/death-claims/new" className="btn-primary">
          <Plus size={20} />
          บันทึกการแจ้ง
        </Link>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="stat-card">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-rose-100 rounded-lg flex items-center justify-center">
              <Flower2 className="w-5 h-5 text-rose-600" />
            </div>
            <div>
              <p className="stat-label">แจ้งทั้งหมด</p>
              <p className="text-2xl font-bold text-slate-900">{stats?.totalClaims || 0}</p>
            </div>
          </div>
        </div>
        <div className="stat-card">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-emerald-100 rounded-lg flex items-center justify-center">
              <CheckCircle className="w-5 h-5 text-emerald-600" />
            </div>
            <div>
              <p className="stat-label">จ่ายแล้ว</p>
              <p className="text-2xl font-bold text-emerald-600">{stats?.totalPaid || 0}</p>
            </div>
          </div>
        </div>
        <div className="stat-card">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-amber-100 rounded-lg flex items-center justify-center">
              <Clock className="w-5 h-5 text-amber-600" />
            </div>
            <div>
              <p className="stat-label">รอจ่าย</p>
              <p className="text-2xl font-bold text-amber-600">{stats?.unpaid || 0}</p>
            </div>
          </div>
        </div>
        <div className="stat-card">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-sky-100 rounded-lg flex items-center justify-center">
              <DollarSign className="w-5 h-5 text-sky-600" />
            </div>
            <div>
              <p className="stat-label">ยอดจ่ายรวม</p>
              <p className="text-lg font-bold text-sky-600">
                {formatCurrency(stats?.totalAmountPaid || 0)}
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Search */}
      <div className="card p-4">
        <div className="relative">
          <Search
            size={20}
            className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400"
          />
          <input
            type="text"
            placeholder="ค้นหาเลขที่, ชื่อสมาชิก..."
            className="input pl-10"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
      </div>

      {/* Claims list */}
      {isLoading ? (
        <div className="flex items-center justify-center py-20">
          <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : filteredClaims?.length === 0 ? (
        <div className="card text-center py-20 text-slate-500">
          <Flower2 className="w-16 h-16 mx-auto text-slate-300 mb-4" />
          <p className="text-lg font-medium">ไม่พบข้อมูลการแจ้งเสียชีวิต</p>
          <p className="text-sm mt-1">สำหรับปี พ.ศ. {selectedYear + 543}</p>
        </div>
      ) : (
        <div className="grid gap-4">
          {filteredClaims?.map((claim) => (
            <motion.div
              key={claim.id}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              className="card-hover p-5"
            >
              <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div className="flex items-start gap-4">
                  <div className="w-12 h-12 bg-rose-100 rounded-xl flex items-center justify-center flex-shrink-0">
                    <Flower2 className="w-6 h-6 text-rose-600" />
                  </div>
                  <div>
                    <div className="flex items-center gap-3 mb-1">
                      <span className="font-mono text-sm text-slate-500">
                        {claim.claimNo}
                      </span>
                      {claim.payment ? (
                        <span className="badge-success">จ่ายแล้ว</span>
                      ) : (
                        <span className="badge-warning">รอจ่าย</span>
                      )}
                    </div>
                    <h3 className="font-semibold text-slate-900">
                      {claim.member.firstName} {claim.member.lastName}
                    </h3>
                    <div className="flex items-center gap-4 mt-2 text-sm text-slate-500">
                      <span className="flex items-center gap-1">
                        <Calendar size={14} />
                        เสียชีวิต: {formatDate(claim.deathDate)}
                      </span>
                      <span className="flex items-center gap-1">
                        <User size={14} />
                        ผู้รับผลประโยชน์: {claim.mainBeneficiary}
                      </span>
                    </div>
                  </div>
                </div>

                <div className="flex items-center gap-4">
                  <div className="text-right">
                    <p className="text-sm text-slate-500">เงินสงเคราะห์</p>
                    <p className="text-xl font-bold text-slate-900">
                      {formatCurrency(claim.netToPay)}
                    </p>
                  </div>
                  <Link
                    href={`/death-claims/${claim.id}`}
                    className="btn-secondary px-4"
                  >
                    <Eye size={18} />
                    ดูรายละเอียด
                  </Link>
                </div>
              </div>
            </motion.div>
          ))}
        </div>
      )}
    </motion.div>
  );
}

