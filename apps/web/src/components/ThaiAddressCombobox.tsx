'use client';

import { useState, useEffect, useRef, useCallback } from 'react';
import { api } from '@/lib/api';
import { MapPin, Search } from 'lucide-react';

export interface ThaiAddressItem {
  id: number;
  subdistrict: string;
  district: string;
  province: string;
  zipCode: string;
}

interface ThaiAddressComboboxProps {
  value?: string;
  onChangeValue?: (val: string) => void;
  onSelectAddress: (addr: {
    subdistrict: string;
    district: string;
    province: string;
    zipCode: string;
  }) => void;
  disabled?: boolean;
  placeholder?: string;
  className?: string;
}

export function ThaiAddressCombobox({
  value = '',
  onChangeValue,
  onSelectAddress,
  disabled = false,
  placeholder = 'พิมพ์ชื่อตำบลเพื่อค้นหา...',
  className = '',
}: ThaiAddressComboboxProps) {
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState('');
  const [items, setItems] = useState<ThaiAddressItem[]>([]);
  const [loading, setLoading] = useState(false);
  const [highlightIndex, setHighlightIndex] = useState(-1);
  const boxRef = useRef<HTMLDivElement>(null);

  const fetchAddresses = useCallback(async (q: string) => {
    setLoading(true);
    try {
      const res = await api.get<ThaiAddressItem[]>('/member-applications/addresses', {
        params: { q: q.trim(), limit: 25 },
      });
      setItems(res.data || []);
    } catch {
      setItems([]);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    if (!open) return;
    const timer = setTimeout(() => {
      fetchAddresses(query);
    }, 200);
    return () => clearTimeout(timer);
  }, [query, open, fetchAddresses]);

  useEffect(() => {
    const onDocClick = (e: MouseEvent) => {
      if (boxRef.current && !boxRef.current.contains(e.target as Node)) {
        setOpen(false);
      }
    };
    document.addEventListener('mousedown', onDocClick);
    return () => document.removeEventListener('mousedown', onDocClick);
  }, []);

  const handlePick = (item: ThaiAddressItem) => {
    onSelectAddress({
      subdistrict: item.subdistrict,
      district: item.district,
      province: item.province,
      zipCode: item.zipCode,
    });
    setQuery('');
    setOpen(false);
  };

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (!open || items.length === 0) {
      if (e.key === 'ArrowDown') setOpen(true);
      return;
    }

    if (e.key === 'ArrowDown') {
      e.preventDefault();
      setHighlightIndex((prev) => (prev < items.length - 1 ? prev + 1 : 0));
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      setHighlightIndex((prev) => (prev > 0 ? prev - 1 : items.length - 1));
    } else if (e.key === 'Enter') {
      e.preventDefault();
      if (highlightIndex >= 0 && highlightIndex < items.length) {
        handlePick(items[highlightIndex]);
      }
    } else if (e.key === 'Escape') {
      setOpen(false);
    }
  };

  return (
    <div className={`relative ${className}`} ref={boxRef}>
      <div className="relative">
        <input
          className={`input pr-8 ${disabled ? 'bg-slate-100 text-slate-500 cursor-not-allowed' : ''}`}
          autoComplete="off"
          disabled={disabled}
          value={open ? query : value}
          placeholder={placeholder}
          onFocus={() => {
            setQuery(value || '');
            setOpen(true);
            setHighlightIndex(-1);
            fetchAddresses(value || '');
          }}
          onChange={(e) => {
            const val = e.target.value;
            setQuery(val);
            onChangeValue?.(val);
            if (!open) setOpen(true);
          }}
          onKeyDown={handleKeyDown}
        />
        <div className="absolute right-2.5 top-1/2 -translate-y-1/2 text-slate-400 pointer-events-none">
          {loading ? (
            <span className="inline-block w-4 h-4 border-2 border-emerald-500 border-t-transparent rounded-full animate-spin" />
          ) : (
            <Search size={16} />
          )}
        </div>
      </div>

      {open && !disabled && (
        <div className="absolute z-30 mt-1 w-full min-w-[280px] max-h-64 overflow-auto rounded-xl border border-slate-200 bg-white shadow-xl py-1 text-sm">
          <div className="px-3 py-1.5 text-[11px] font-semibold text-slate-400 uppercase tracking-wider bg-slate-50 border-b border-slate-100 flex items-center gap-1">
            <MapPin size={12} className="text-emerald-600" />
            เลือกตำบล (ระบบจะกรอก อำเภอ จังหวัด รหัสไปรษณีย์ ให้อัตโนมัติ)
          </div>
          {items.length === 0 ? (
            <div className="px-3 py-3 text-center text-xs text-slate-500">
              {loading ? 'กำลังค้นหาที่อยู่...' : 'ไม่พบข้อมูลที่ค้นหา (สามารถพิมพ์เองได้)'}
            </div>
          ) : (
            items.map((item, idx) => {
              const isSelected = item.subdistrict === value;
              const isHighlighted = idx === highlightIndex;
              return (
                <button
                  key={`${item.id}-${idx}`}
                  type="button"
                  onMouseDown={(e) => {
                    e.preventDefault();
                    handlePick(item);
                  }}
                  onMouseEnter={() => setHighlightIndex(idx)}
                  className={`w-full px-3 py-2 text-left flex items-center justify-between gap-2 transition-colors ${
                    isHighlighted || isSelected
                      ? 'bg-emerald-50 text-emerald-900 font-medium'
                      : 'text-slate-700 hover:bg-slate-50'
                  }`}
                >
                  <div className="min-w-0">
                    <span className="font-semibold text-slate-900">ต.{item.subdistrict}</span>
                    <span className="text-slate-500 text-xs ml-1.5">
                      (อ.{item.district} จ.{item.province})
                    </span>
                  </div>
                  <span className="text-xs font-mono px-1.5 py-0.5 rounded bg-slate-100 text-slate-600 shrink-0">
                    {item.zipCode}
                  </span>
                </button>
              );
            })
          )}
        </div>
      )}
    </div>
  );
}
