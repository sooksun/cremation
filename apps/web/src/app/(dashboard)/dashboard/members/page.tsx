'use client';

import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import {
  Users,
  UserCheck,
  UserX,
  Building2,
  FolderTree,
  AlertTriangle,
  UserPlus,
  ShieldAlert,
} from 'lucide-react';
import Link from 'next/link';
import dynamic from 'next/dynamic';
import ChartSkeleton from '@/components/ChartSkeleton';
import { api, membershipEndReasonLabels, type MembershipEndReason } from '@/lib/api';

// recharts หนักราว 99 kB (gzip) และใช้เฉพาะบล็อกกราฟ จึงโหลดแบบ dynamic ฝั่ง client เท่านั้น
const MemberStatusPieChart = dynamic(
  () => import('./charts').then((m) => m.MemberStatusPieChart),
  { ssr: false, loading: () => <ChartSkeleton className="h-[260px]" /> },
);
const MemberTypeBarChart = dynamic(
  () => import('./charts').then((m) => m.MemberTypeBarChart),
  { ssr: false, loading: () => <ChartSkeleton className="h-[260px]" /> },
);
const ClusterBarChart = dynamic(
  () => import('./charts').then((m) => m.ClusterBarChart),
  { ssr: false, loading: () => <ChartSkeleton className="h-[260px]" /> },
);
import { useAuthStore } from '@/store/auth';

const COLORS = ['#10b981', '#3b82f6', '#f59e0b', '#f43f5e', '#8b5cf6', '#06b6d4'];

const STATUS_LABELS: Record<string, string> = {
  ACTIVE: 'ปกติ',
  ARREARS: 'ค้างชำระ',
  SUSPENDED: 'พักสมาชิก',
  RESIGNED: 'ลาออก',
  DECEASED: 'เสียชีวิต',
};

const CLASS_LABELS: Record<string, string> = {
  ORDINARY: 'สมาชิกสามัญ',
  CONTRIBUTORY: 'สมาชิกสมทบ',
};

interface MembersDashboard {
  summary: {
    associationMembers: number;
    cremationMembers: number;
    notInCremationFund: number;
    joinedThisYear: number;
    joinedThisMonth: number;
    endedThisYear: number;
    activeSchools: number;
  };
  byStatus: Array<{ status: string; count: number }>;
  byMembershipClass: Array<{ membershipClass: string; count: number }>;
  byMemberType: Array<{ memberTypeId: string; code: string; name: string; count: number }>;
  associationStatus: {
    active: number;
    ended: number;
    byReason: Array<{ reason: MembershipEndReason; count: number }>;
  };
  dataGaps: {
    withoutGroup: number;
    withoutBeneficiary: number;
    missingIdCard: number;
    missingBirthDate: number;
    missingPhone: number;
  };
  bySchool: Array<{
    schoolId: string;
    name: string;
    clusterName: string | null;
    associationMembers: number;
    cremationMembers: number;
    groups: number;
  }>;
  byCluster: Array<{ clusterId: string; name: string; schools: number; members: number }>;
}

const num = (n: number) => new Intl.NumberFormat('th-TH').format(n);

// ชื่อโรงเรียนยาวเกินกว่าจะอ่านบนแกนกราฟ
const shortName = (name: string) =>
  name.replace(/^โรงเรียน\s*\.?\s*/, '').split(/\s+กลุ่มเครือข่าย/)[0].trim();

export default function MembersDashboardPage() {
  const { selectedSchoolId } = useAuthStore();

  const { data, isLoading } = useQuery<MembersDashboard>({
    queryKey: ['dashboard-members', selectedSchoolId],
    queryFn: async () => {
      const params = selectedSchoolId ? `?schoolId=${selectedSchoolId}` : '';
      return (await api.get(`/dashboards/members${params}`)).data;
    },
  });

  if (isLoading) {
    return (
      <div className="flex items-center justify-center py-20">
        <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  if (!data) return null;

  const { summary, dataGaps } = data;
  const statusData = data.byStatus.filter((s) => s.count > 0);
  const totalGaps =
    dataGaps.withoutGroup + dataGaps.withoutBeneficiary + dataGaps.missingIdCard;

  return (
    <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-6">
      <div>
        <h1 className="text-2xl font-display font-bold text-slate-900">ภาพรวมสมาชิก</h1>
        <p className="text-slate-500 mt-1">สมาชิก ประเภทสมาชิก และโรงเรียนในสังกัด</p>
      </div>

      {/* ตัวเลขหลัก */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="stat-card">
          <div className="flex items-center justify-between">
            <div>
              <p className="stat-label">สมาชิกสมาคม</p>
              <p className="stat-value">{num(summary.associationMembers)}</p>
            </div>
            <Users className="w-10 h-10 text-primary-500 opacity-80" />
          </div>
        </div>
        <div className="stat-card">
          <div className="flex items-center justify-between">
            <div>
              <p className="stat-label">สมาชิกฌาปนกิจ</p>
              <p className="stat-value">{num(summary.cremationMembers)}</p>
              {summary.notInCremationFund > 0 && (
                <p className="text-xs text-slate-400 mt-1">
                  ยังไม่เข้าฌาปนกิจ {num(summary.notInCremationFund)} คน
                </p>
              )}
            </div>
            <UserCheck className="w-10 h-10 text-emerald-500 opacity-80" />
          </div>
        </div>
        <div className="stat-card">
          <div className="flex items-center justify-between">
            <div>
              <p className="stat-label">เข้าใหม่ปีนี้</p>
              <p className="stat-value">{num(summary.joinedThisYear)}</p>
              <p className="text-xs text-slate-400 mt-1">เดือนนี้ {num(summary.joinedThisMonth)} คน</p>
            </div>
            <UserPlus className="w-10 h-10 text-blue-500 opacity-80" />
          </div>
        </div>
        <div className="stat-card">
          <div className="flex items-center justify-between">
            <div>
              <p className="stat-label">โรงเรียนที่มีสมาชิก</p>
              <p className="stat-value">{num(summary.activeSchools)}</p>
              <p className="text-xs text-slate-400 mt-1">
                หมดสมาชิกภาพปีนี้ {num(summary.endedThisYear)} คน
              </p>
            </div>
            <Building2 className="w-10 h-10 text-violet-500 opacity-80" />
          </div>
        </div>
      </div>

      {/* ข้อมูลที่ยังขาด — บล็อกการทำงานจริง */}
      {totalGaps > 0 && (
        <div className="card p-5 border-l-4 border-amber-400">
          <div className="flex items-center gap-2 mb-3">
            <ShieldAlert size={18} className="text-amber-500 shrink-0" />
            <h2 className="font-semibold text-slate-900">ข้อมูลที่ยังขาด</h2>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
            <GapItem
              label="ไม่มีผู้รับเงินสงเคราะห์"
              value={dataGaps.withoutBeneficiary}
              hint="จ่ายเงินตอนเสียชีวิตไม่ได้"
              critical
            />
            <GapItem label="ยังไม่เข้ากลุ่มเก็บเงิน" value={dataGaps.withoutGroup} hint="เก็บเงินรายเดือนไม่ได้" critical />
            <GapItem label="ไม่มีเลขบัตรประชาชน" value={dataGaps.missingIdCard} />
            <GapItem label="ไม่มีวันเกิด" value={dataGaps.missingBirthDate} />
            <GapItem label="ไม่มีเบอร์โทร" value={dataGaps.missingPhone} />
          </div>
        </div>
      )}

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* สถานะสมาชิกฌาปนกิจ */}
        <div className="card p-6">
          <h2 className="font-semibold text-slate-900 mb-4">สถานะสมาชิกฌาปนกิจ</h2>
          {statusData.length === 0 ? (
            <EmptyHint text="ยังไม่มีข้อมูลสมาชิก" />
          ) : (
            <MemberStatusPieChart
              data={statusData.map((s) => ({ name: STATUS_LABELS[s.status] ?? s.status, value: s.count }))}
              colors={COLORS}
            />
          )}
        </div>

        {/* ประเภทสมาชิก */}
        <div className="card p-6">
          <h2 className="font-semibold text-slate-900 mb-4">ประเภทสมาชิก</h2>
          {data.byMemberType.length === 0 ? (
            <EmptyHint text="ยังไม่มีข้อมูลประเภทสมาชิก" />
          ) : (
            <MemberTypeBarChart data={data.byMemberType} />
          )}
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* ชั้นสมาชิก + สถานะสมาคม */}
        <div className="card p-6">
          <h2 className="font-semibold text-slate-900 mb-4">ชั้นสมาชิก และสถานะสมาคม</h2>
          <div className="space-y-3">
            {data.byMembershipClass.map((c) => (
              <Row
                key={c.membershipClass}
                label={CLASS_LABELS[c.membershipClass] ?? c.membershipClass}
                value={num(c.count)}
              />
            ))}
            <div className="pt-3 border-t border-slate-100 space-y-3">
              <Row label="สมาชิกสมาคมปกติ" value={num(data.associationStatus.active)} />
              <Row label="หมดสมาชิกภาพ" value={num(data.associationStatus.ended)} muted />
              {data.associationStatus.byReason.map((r) => (
                <Row
                  key={r.reason}
                  label={`— ${membershipEndReasonLabels[r.reason] ?? r.reason}`}
                  value={num(r.count)}
                  muted
                  indent
                />
              ))}
            </div>
          </div>
        </div>

        {/* กลุ่มเครือข่าย */}
        <div className="card p-6">
          <h2 className="font-semibold text-slate-900 mb-4">กลุ่มเครือข่ายพัฒนาการศึกษา</h2>
          {data.byCluster.length === 0 ? (
            <EmptyHint text="ยังไม่มีกลุ่มเครือข่าย" />
          ) : (
            <ClusterBarChart
              data={data.byCluster.map((c) => ({ ...c, short: c.name.replace('กลุ่มเครือข่ายพัฒนาการศึกษา', '') }))}
            />
          )}
        </div>
      </div>

      {/* รายโรงเรียน */}
      <div className="card overflow-hidden">
        <div className="p-6 pb-3 flex items-center gap-2">
          <FolderTree size={18} className="text-slate-400" />
          <h2 className="font-semibold text-slate-900">สมาชิกรายโรงเรียน</h2>
          <span className="text-sm text-slate-400">({data.bySchool.length} โรงเรียน)</span>
        </div>
        <div className="table-container border-0 max-h-[28rem] overflow-y-auto">
          <table className="table">
            <thead>
              <tr>
                <th>โรงเรียน</th>
                <th>กลุ่มเครือข่าย</th>
                <th className="text-center">สมาชิกสมาคม</th>
                <th className="text-center">สมาชิกฌาปนกิจ</th>
                <th className="text-center">กลุ่มเก็บเงิน</th>
              </tr>
            </thead>
            <tbody>
              {data.bySchool.map((s) => (
                <tr key={s.schoolId}>
                  <td className="font-medium">{shortName(s.name)}</td>
                  <td className="text-violet-700 text-sm">{s.clusterName ?? '-'}</td>
                  <td className="text-center">{num(s.associationMembers)}</td>
                  <td className="text-center">{num(s.cremationMembers)}</td>
                  <td className="text-center">
                    {s.groups === 0 ? (
                      <span className="badge-warning">ยังไม่มีกลุ่ม</span>
                    ) : (
                      num(s.groups)
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </motion.div>
  );
}

function GapItem({
  label,
  value,
  hint,
  critical,
}: {
  label: string;
  value: number;
  hint?: string;
  critical?: boolean;
}) {
  const tone = value === 0 ? 'text-emerald-600' : critical ? 'text-red-600' : 'text-amber-600';
  return (
    <div>
      <p className={`text-2xl font-semibold ${tone}`}>{num(value)}</p>
      <p className="text-sm text-slate-600">{label}</p>
      {hint && value > 0 && <p className="text-xs text-slate-400 mt-0.5">{hint}</p>}
    </div>
  );
}

function Row({
  label,
  value,
  muted,
  indent,
}: {
  label: string;
  value: string;
  muted?: boolean;
  indent?: boolean;
}) {
  return (
    <div className={`flex items-center justify-between ${indent ? 'pl-4' : ''}`}>
      <span className={`text-sm ${muted ? 'text-slate-500' : 'text-slate-700'}`}>{label}</span>
      <span className={`font-medium ${muted ? 'text-slate-500' : 'text-slate-900'}`}>{value}</span>
    </div>
  );
}

function EmptyHint({ text }: { text: string }) {
  return (
    <div className="h-[260px] flex flex-col items-center justify-center text-slate-400">
      <AlertTriangle size={28} className="mb-2 opacity-50" />
      <p className="text-sm">{text}</p>
    </div>
  );
}
