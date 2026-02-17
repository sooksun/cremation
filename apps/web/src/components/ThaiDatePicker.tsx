'use client';

import { DatePicker, ConfigProvider } from 'antd';
import type { DatePickerProps } from 'antd';
import type { Locale } from 'antd/es/locale';
import dayjs, { Dayjs } from 'dayjs';
import 'dayjs/locale/th';
import buddhistEra from 'dayjs/plugin/buddhistEra';
import localeData from 'dayjs/plugin/localeData';
import th_TH from 'antd/locale/th_TH';

// Setup dayjs plugins
dayjs.extend(buddhistEra);
dayjs.extend(localeData);
dayjs.locale('th');

// Thai month names
const thaiMonths = [
  'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
  'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'
];

const thaiMonthsShort = [
  'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
  'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
];

// Custom Thai locale with Buddhist Era
const customThaiLocale: Locale = {
  ...th_TH,
  DatePicker: {
    ...th_TH.DatePicker!,
    lang: {
      ...th_TH.DatePicker!.lang,
      locale: 'th',
      yearFormat: 'BBBB',
      cellYearFormat: 'BBBB',
      monthFormat: 'MMMM',
      cellMeridiemFormat: 'A',
    },
  },
};

interface ThaiDatePickerProps {
  value?: string | Dayjs | null; // ISO date string (ค.ศ.) or Dayjs object
  onChange?: (date: Dayjs | null, dateString?: string) => void;
  placeholder?: string;
  className?: string;
  style?: React.CSSProperties;
  disabled?: boolean;
  allowClear?: boolean;
  returnString?: boolean; // If true, onChange receives string instead of Dayjs
}

export default function ThaiDatePicker({
  value,
  onChange,
  placeholder = 'เลือกวันที่',
  className = '',
  style,
  disabled = false,
  allowClear = false,
  returnString = false,
}: ThaiDatePickerProps) {
  // Convert value to dayjs (supports string or Dayjs)
  const dayjsValue = value ? (dayjs.isDayjs(value) ? value : dayjs(value)) : null;

  // Handle change
  const handleChange: DatePickerProps['onChange'] = (date: Dayjs | null) => {
    if (onChange) {
      if (returnString) {
        // Return string for backwards compatibility
        // Use unknown as intermediate type for safe casting
        (onChange as unknown as (dateString: string) => void)(date ? date.format('YYYY-MM-DD') : '');
      } else {
        // Return Dayjs object
        onChange(date, date ? date.format('YYYY-MM-DD') : '');
      }
    }
  };

  // Custom header render to show พ.ศ. year
  // Note: headerRender is not in DatePickerProps type but is supported by antd DatePicker
  const customHeaderRender = ({ value: currentValue, type, onChange: onHeaderChange, onTypeChange }: {
    value: Dayjs;
    type: string;
    onChange: (date: Dayjs) => void;
    onTypeChange: (type: string) => void;
  }) => {
    const year = currentValue.year() + 543; // Convert to พ.ศ.
    const month = currentValue.month();

    const handlePrevMonth = () => {
      onHeaderChange(currentValue.subtract(1, 'month'));
    };

    const handleNextMonth = () => {
      onHeaderChange(currentValue.add(1, 'month'));
    };

    const handlePrevYear = () => {
      onHeaderChange(currentValue.subtract(1, 'year'));
    };

    const handleNextYear = () => {
      onHeaderChange(currentValue.add(1, 'year'));
    };

    if (type === 'date') {
      return (
        <div className="flex items-center justify-between px-2 py-2 border-b border-slate-200">
          <div className="flex items-center gap-1">
            <button
              type="button"
              onClick={handlePrevYear}
              className="p-1.5 hover:bg-slate-100 rounded transition-colors text-slate-500 hover:text-slate-700"
              title="ปีก่อนหน้า"
            >
              <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 19l-7-7 7-7m8 14l-7-7 7-7" />
              </svg>
            </button>
            <button
              type="button"
              onClick={handlePrevMonth}
              className="p-1.5 hover:bg-slate-100 rounded transition-colors text-slate-500 hover:text-slate-700"
              title="เดือนก่อนหน้า"
            >
              <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
              </svg>
            </button>
          </div>
          
          <div className="flex items-center gap-2">
            <button
              type="button"
              onClick={() => onTypeChange('month')}
              className="font-medium text-slate-700 hover:text-primary-600 transition-colors px-2 py-1 hover:bg-slate-50 rounded"
            >
              {thaiMonths[month]}
            </button>
            <button
              type="button"
              onClick={() => onTypeChange('year')}
              className="font-medium text-slate-700 hover:text-primary-600 transition-colors px-2 py-1 hover:bg-slate-50 rounded"
            >
              {year}
            </button>
          </div>

          <div className="flex items-center gap-1">
            <button
              type="button"
              onClick={handleNextMonth}
              className="p-1.5 hover:bg-slate-100 rounded transition-colors text-slate-500 hover:text-slate-700"
              title="เดือนถัดไป"
            >
              <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
              </svg>
            </button>
            <button
              type="button"
              onClick={handleNextYear}
              className="p-1.5 hover:bg-slate-100 rounded transition-colors text-slate-500 hover:text-slate-700"
              title="ปีถัดไป"
            >
              <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 5l7 7-7 7M5 5l7 7-7 7" />
              </svg>
            </button>
          </div>
        </div>
      );
    }

    if (type === 'month') {
      return (
        <div className="flex items-center justify-between px-2 py-2 border-b border-slate-200">
          <button
            type="button"
            onClick={handlePrevYear}
            className="p-1.5 hover:bg-slate-100 rounded transition-colors text-slate-500 hover:text-slate-700"
          >
            <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
            </svg>
          </button>
          
          <button
            type="button"
            onClick={() => onTypeChange('year')}
            className="font-medium text-slate-700 hover:text-primary-600 transition-colors px-3 py-1 hover:bg-slate-50 rounded"
          >
            {year}
          </button>

          <button
            type="button"
            onClick={handleNextYear}
            className="p-1.5 hover:bg-slate-100 rounded transition-colors text-slate-500 hover:text-slate-700"
          >
            <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
            </svg>
          </button>
        </div>
      );
    }

    if (type === 'year') {
      const startYear = Math.floor((currentValue.year() + 543) / 10) * 10;
      const endYear = startYear + 9;
      
      return (
        <div className="flex items-center justify-between px-2 py-2 border-b border-slate-200">
          <button
            type="button"
            onClick={() => onHeaderChange(currentValue.subtract(10, 'year'))}
            className="p-1.5 hover:bg-slate-100 rounded transition-colors text-slate-500 hover:text-slate-700"
          >
            <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
            </svg>
          </button>
          
          <span className="font-medium text-slate-700">
            {startYear} - {endYear}
          </span>

          <button
            type="button"
            onClick={() => onHeaderChange(currentValue.add(10, 'year'))}
            className="p-1.5 hover:bg-slate-100 rounded transition-colors text-slate-500 hover:text-slate-700"
          >
            <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
            </svg>
          </button>
        </div>
      );
    }

    return null;
  };

  return (
    <ConfigProvider locale={customThaiLocale}>
      <DatePicker
        value={dayjsValue}
        onChange={handleChange}
        placeholder={placeholder}
        className={className}
        disabled={disabled}
        allowClear={allowClear}
        format={(val) => val.format('D/M/BBBB')} // แสดง พ.ศ. ใน input
        style={style || { width: '100%' }}
        {...({ headerRender: customHeaderRender } as any)}
        cellRender={(current, info) => {
          // Type assertion: antd DatePicker's cellRender always passes Dayjs object for date/month/year cells
          // Use unknown as intermediate type for safe casting
          const dayjsCurrent = (current as unknown) as Dayjs;
          
          if (info.type === 'date') {
            return <div className="ant-picker-cell-inner">{dayjsCurrent.date()}</div>;
          }
          if (info.type === 'month') {
            return <div className="ant-picker-cell-inner">{thaiMonthsShort[dayjsCurrent.month()]}</div>;
          }
          if (info.type === 'year') {
            // แสดงปี พ.ศ. ใน year picker
            return <div className="ant-picker-cell-inner">{dayjsCurrent.year() + 543}</div>;
          }
          return info.originNode;
        }}
      />
    </ConfigProvider>
  );
}

// Utility function to format date for display (พ.ศ.)
export function formatThaiDate(dateString: string | Date | null | undefined): string {
  if (!dateString) return '-';
  const date = dayjs(dateString);
  return date.isValid() ? date.format('D MMMM BBBB') : '-';
}

// Utility function to format short date for display (พ.ศ.)
export function formatThaiDateShort(dateString: string | Date | null | undefined): string {
  if (!dateString) return '-';
  const date = dayjs(dateString);
  return date.isValid() ? date.format('D/M/BBBB') : '-';
}

// Convert ค.ศ. year to พ.ศ.
export function toBuddhistYear(year: number): number {
  return year + 543;
}

// Convert พ.ศ. year to ค.ศ.
export function toChristianYear(year: number): number {
  return year - 543;
}
