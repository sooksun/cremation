'use client';

import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Legend,
  ComposedChart,
  Line,
} from 'recharts';

const baht = (n: number) =>
  new Intl.NumberFormat('th-TH', { style: 'currency', currency: 'THB', maximumFractionDigits: 0 }).format(n);
const num = (n: number) => new Intl.NumberFormat('th-TH').format(n);

export function MonthlyCashFlowChart({ data }: { data: Record<string, any>[] }) {
  return (
    <ResponsiveContainer width="100%" height={340}>
      <ComposedChart data={data}>
        <CartesianGrid strokeDasharray="3 3" vertical={false} />
        <XAxis dataKey="name" tick={{ fontSize: 12 }} />
        <YAxis tickFormatter={(v) => num(v)} tick={{ fontSize: 12 }} />
        <Tooltip formatter={(v: number, key) => [baht(v), key]} />
        <Legend />
        <Bar dataKey="inflow" name="เงินเข้า" fill="#10b981" radius={[4, 4, 0, 0]} />
        <Bar dataKey="outflow" name="เงินออก" fill="#f43f5e" radius={[4, 4, 0, 0]} />
        <Line type="monotone" dataKey="accumulated" name="ยอดสะสม" stroke="#8b5cf6" strokeWidth={2} dot={false} />
      </ComposedChart>
    </ResponsiveContainer>
  );
}

export function TypeBreakdownChart({
  rows,
  color,
}: {
  rows: { label: string; amount: number }[];
  color: string;
}) {
  return (
    <ResponsiveContainer width="100%" height={240}>
      <BarChart data={rows} layout="vertical" margin={{ left: 20 }}>
        <CartesianGrid strokeDasharray="3 3" horizontal={false} />
        <XAxis type="number" tickFormatter={(v) => num(v)} tick={{ fontSize: 11 }} />
        <YAxis type="category" dataKey="label" width={120} tick={{ fontSize: 11 }} />
        <Tooltip formatter={(v: number) => baht(v)} />
        <Bar dataKey="amount" fill={color} radius={[0, 4, 4, 0]} name="ยอดเงิน" />
      </BarChart>
    </ResponsiveContainer>
  );
}
