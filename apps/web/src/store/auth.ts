import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { canSelectAllSchools, resolveSelectedSchoolId } from '@/lib/school-scope';

interface User {
  id: string;
  username: string;
  fullName: string;
  role: string;
  schoolId?: string;
  schoolName?: string;
  groupId?: string;
  mustChangePassword?: boolean;
}

interface AuthState {
  user: User | null;
  selectedSchoolId: string | null;
  selectedYear: number;
  setUser: (user: User) => void;
  logout: () => void;
  setSelectedSchool: (schoolId: string | null) => void;
  setSelectedYear: (year: number) => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set, get) => ({
      user: null,
      selectedSchoolId: null,
      selectedYear: new Date().getFullYear(),

      setUser: (user) => {
        set({
          user,
          selectedSchoolId: resolveSelectedSchoolId(
            user.role,
            user.schoolId,
            get().selectedSchoolId,
          ),
        });
      },

      logout: () => {
        set({ user: null, selectedSchoolId: null });
      },

      setSelectedSchool: (schoolId) => {
        const { user } = get();
        set({
          selectedSchoolId: resolveSelectedSchoolId(user?.role, user?.schoolId, schoolId),
        });
      },

      setSelectedYear: (year) => {
        set({ selectedYear: year });
      },
    }),
    {
      name: 'cremation-auth',
      partialize: (state) => ({
        selectedSchoolId: state.selectedSchoolId,
        selectedYear: state.selectedYear,
      }),
    },
  ),
);