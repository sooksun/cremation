import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface User {
  id: string;
  username: string;
  fullName: string;
  role: string;
  schoolId?: string;
  schoolName?: string;
}

interface AuthState {
  token: string | null;
  user: User | null;
  selectedSchoolId: string | null;
  selectedYear: number;
  setAuth: (token: string, user: User) => void;
  logout: () => void;
  setSelectedSchool: (schoolId: string | null) => void;
  setSelectedYear: (year: number) => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      token: null,
      user: null,
      selectedSchoolId: null,
      selectedYear: new Date().getFullYear(),

      setAuth: (token, user) => {
        set({ token, user, selectedSchoolId: user.schoolId || null });
      },

      logout: () => {
        set({ token: null, user: null, selectedSchoolId: null });
      },

      setSelectedSchool: (schoolId) => {
        set({ selectedSchoolId: schoolId });
      },

      setSelectedYear: (year) => {
        set({ selectedYear: year });
      },
    }),
    {
      name: 'cremation-auth',
    },
  ),
);

