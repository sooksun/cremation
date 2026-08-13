'use client';

import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  LineChart,
  Line,
  Legend,
  PieChart as RechartsPieChart,
  Pie,
  Cell,
} from 'recharts';

const formatNumber = (num: number) => new Intl.NumberFormat('th-TH').format(num);

const formatCurrency = (amount: number) =>
  new Intl.NumberFormat('th-TH', {
    style: 'currency',
    currency: 'THB',
    minimumFractionDigits: 0,
  }).format(amount);

export interface MemberStatusSlice {
  name: string;
  value: number;
  color: string;
}

export function MemberStatusPieChart({ data }: { data: MemberStatusSlice[] }) {
  return (
    <ResponsiveContainer width="100%" height="100%">
      <RechartsPieChart>
        <Pie
          data={data}
          cx="50%"
          cy="50%"
          innerRadius={50}
          outerRadius={80}
          paddingAngle={5}
          dataKey="value"
          label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}
        >
          {data.map((entry, index) => (
            <Cell key={`cell-${index}`} fill={entry.color} />
          ))}
        </Pie>
        <Tooltip formatter={(value: number) => `${formatNumber(value)} คน`} />
      </RechartsPieChart>
    </ResponsiveContainer>
  );
}

export function MonthlyFinanceChart({ data }: { data: Record<string, any>[] }) {
  return (
    <ResponsiveContainer width="100%" height="100%">
      <LineChart data={data}>
        <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" />
        <XAxis dataKey="name" tick={{ fontSize: 11 }} />
        <YAxis tickFormatter={(value) => `${(value / 1000).toFixed(0)}k`} tick={{ fontSize: 11 }} />
        <Tooltip formatter={(value: number) => formatCurrency(value)} />
        <Legend />
        <Line type="monotone" dataKey="รายรับ" stroke="#10b981" strokeWidth={2} />
        <Line type="monotone" dataKey="รายจ่าย" stroke="#f43f5e" strokeWidth={2} />
      </LineChart>
    </ResponsiveContainer>
  );
}

export function DeathClaimsTrendChart({ data }: { data: Record<string, any>[] }) {
  return (
    <ResponsiveContainer width="100%" height="100%">
      <BarChart data={data}>
        <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" />
        <XAxis dataKey="name" tick={{ fontSize: 12 }} />
        <YAxis tick={{ fontSize: 12 }} />
        <Tooltip />
        <Legend />
        <Bar dataKey="ตัวสมาชิก" stackId="a" fill="#f43f5e" />
        <Bar dataKey="บิดามารดา" stackId="a" fill="#f59e0b" />
        <Bar dataKey="บุตร" stackId="a" fill="#6366f1" />
      </BarChart>
    </ResponsiveContainer>
  );
}
