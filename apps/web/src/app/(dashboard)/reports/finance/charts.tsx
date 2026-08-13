'use client';

import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Line,
  Legend,
  PieChart as RechartsPieChart,
  Pie,
  Cell,
  AreaChart,
  Area,
} from 'recharts';

const formatCurrency = (amount: number) =>
  new Intl.NumberFormat('th-TH', {
    style: 'currency',
    currency: 'THB',
    minimumFractionDigits: 0,
  }).format(amount);

export interface PieSlice {
  name: string;
  value: number;
  color: string;
}

export function MonthlyAreaChart({ data }: { data: Record<string, any>[] }) {
  return (
    <ResponsiveContainer width="100%" height="100%">
      <AreaChart data={data}>
        <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" />
        <XAxis dataKey="name" tick={{ fontSize: 12 }} />
        <YAxis tickFormatter={(value) => `${(value / 1000).toFixed(0)}k`} tick={{ fontSize: 12 }} />
        <Tooltip formatter={(value: number) => formatCurrency(value)} />
        <Legend />
        <Area type="monotone" dataKey="รายรับ" stackId="1" stroke="#10b981" fill="#10b981" fillOpacity={0.6} />
        <Area type="monotone" dataKey="รายจ่าย" stackId="2" stroke="#f43f5e" fill="#f43f5e" fillOpacity={0.6} />
      </AreaChart>
    </ResponsiveContainer>
  );
}

export function TypeDonutChart({ data }: { data: PieSlice[] }) {
  return (
    <ResponsiveContainer width="100%" height="100%">
      <RechartsPieChart>
        <Pie data={data} cx="50%" cy="50%" innerRadius={40} outerRadius={70} dataKey="value">
          {data.map((entry, index) => (
            <Cell key={`cell-${index}`} fill={entry.color} />
          ))}
        </Pie>
        <Tooltip formatter={(value: number) => formatCurrency(value)} />
      </RechartsPieChart>
    </ResponsiveContainer>
  );
}

export function CollectionRateChart({ data }: { data: Record<string, any>[] }) {
  return (
    <ResponsiveContainer width="100%" height="100%">
      <BarChart data={data}>
        <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" />
        <XAxis dataKey="name" tick={{ fontSize: 12 }} />
        <YAxis yAxisId="left" tick={{ fontSize: 12 }} domain={[0, 100]} unit="%" />
        <YAxis
          yAxisId="right"
          orientation="right"
          tickFormatter={(value) => `${(value / 1000).toFixed(0)}k`}
          tick={{ fontSize: 12 }}
        />
        <Tooltip
          formatter={(value: number, name: string) =>
            name === 'อัตราเก็บ' ? `${value}%` : formatCurrency(value)
          }
        />
        <Legend />
        <Bar yAxisId="left" dataKey="อัตราเก็บ" fill="#10b981" radius={[4, 4, 0, 0]} />
        <Line yAxisId="right" type="monotone" dataKey="คาดหวัง" stroke="#f59e0b" strokeWidth={2} />
        <Line yAxisId="right" type="monotone" dataKey="เก็บได้" stroke="#3b82f6" strokeWidth={2} />
      </BarChart>
    </ResponsiveContainer>
  );
}
