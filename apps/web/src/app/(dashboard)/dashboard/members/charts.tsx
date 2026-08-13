'use client';

import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  PieChart as RechartsPieChart,
  Pie,
  Cell,
  Legend,
} from 'recharts';

const num = (n: number) => new Intl.NumberFormat('th-TH').format(n);

export function MemberStatusPieChart({
  data,
  colors,
}: {
  data: { name: string; value: number }[];
  colors: string[];
}) {
  return (
    <ResponsiveContainer width="100%" height={260}>
      <RechartsPieChart>
        <Pie
          data={data}
          dataKey="value"
          nameKey="name"
          cx="50%"
          cy="50%"
          outerRadius={90}
          label={(e: any) => `${e.name} ${e.value}`}
        >
          {data.map((_, i) => (
            <Cell key={i} fill={colors[i % colors.length]} />
          ))}
        </Pie>
        <Tooltip formatter={(v: number) => `${num(v)} คน`} />
      </RechartsPieChart>
    </ResponsiveContainer>
  );
}

export function MemberTypeBarChart({ data }: { data: Record<string, any>[] }) {
  return (
    <ResponsiveContainer width="100%" height={260}>
      <BarChart data={data} layout="vertical" margin={{ left: 20 }}>
        <CartesianGrid strokeDasharray="3 3" horizontal={false} />
        <XAxis type="number" allowDecimals={false} />
        <YAxis type="category" dataKey="name" width={90} tick={{ fontSize: 12 }} />
        <Tooltip formatter={(v: number) => `${num(v)} คน`} />
        <Bar dataKey="count" fill="#3b82f6" radius={[0, 4, 4, 0]} name="จำนวน" />
      </BarChart>
    </ResponsiveContainer>
  );
}

export function ClusterBarChart({ data }: { data: Record<string, any>[] }) {
  return (
    <ResponsiveContainer width="100%" height={260}>
      <BarChart data={data}>
        <CartesianGrid strokeDasharray="3 3" vertical={false} />
        <XAxis dataKey="short" tick={{ fontSize: 11 }} interval={0} angle={-15} textAnchor="end" height={60} />
        <YAxis allowDecimals={false} />
        <Tooltip formatter={(v: number) => `${num(v)} คน`} />
        <Legend />
        <Bar dataKey="members" fill="#8b5cf6" radius={[4, 4, 0, 0]} name="สมาชิก" />
      </BarChart>
    </ResponsiveContainer>
  );
}
