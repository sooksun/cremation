'use client';

import { useState, useMemo, type ReactNode } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion, AnimatePresence } from 'framer-motion';
import {
  Plus,
  Building2,
  Edit,
  Trash2,
  X,
  Users,
  FolderTree,
  LayoutGrid,
  Table2,
  GitBranch,
  User,
} from 'lucide-react';
import { useForm } from 'react-hook-form';
import { showSuccess, showError, showConfirm } from '@/lib/toast';
import { api, type School, type SchoolCluster } from '@/lib/api';

interface ClusterForm {
  code: string;
  name: string;
}

interface SchoolForm {
  code: string;
  name: string;
  district?: string;
  province?: string;
  clusterId: string;
}

interface HierarchyMember {
  id: string;
  firstName: string;
  lastName: string;
  associationMemberNo?: string;
  memberType: { name: string };
}

interface HierarchySchool {
  id: string;
  code: string;
  name: string;
  district?: string;
  province?: string;
  _count: { associationMembers: number };
  associationMembers: HierarchyMember[];
}

interface HierarchyCluster {
  id: string;
  code: string;
  name: string;
  schools: HierarchySchool[];
}

interface HierarchyData {
  clusters: HierarchyCluster[];
  unassignedSchools: HierarchySchool[];
}

interface AssociationMemberRow {
  id: string;
  firstName: string;
  lastName: string;
  associationMemberNo?: string;
  school: { id: string; name: string; cluster?: { id: string; name: string } };
  memberType: { name: string };
}

type ManageTab = 'hierarchy' | 'clusters' | 'schools' | 'members';
type ViewMode = 'cards' | 'table';

export default function SchoolsPage() {
  const queryClient = useQueryClient();
  const [manageTab, setManageTab] = useState<ManageTab>('hierarchy');
  const [viewMode, setViewMode] = useState<ViewMode>('table');
  const [clusterModalOpen, setClusterModalOpen] = useState(false);
  const [schoolModalOpen, setSchoolModalOpen] = useState(false);
  const [editingCluster, setEditingCluster] = useState<SchoolCluster | null>(null);
  const [editingSchool, setEditingSchool] = useState<School | null>(null);
  const [clusterFilter, setClusterFilter] = useState('');
  const [schoolFilter, setSchoolFilter] = useState('');

  const clusterForm = useForm<ClusterForm>();
  const schoolForm = useForm<SchoolForm>();

  const { data: hierarchy, isLoading: hierarchyLoading } = useQuery<HierarchyData>({
    queryKey: ['school-hierarchy'],
    queryFn: async () => {
      const response = await api.get('/school-clusters/hierarchy');
      return response.data;
    },
  });

  const { data: clusters, isLoading: clustersLoading } = useQuery<SchoolCluster[]>({
    queryKey: ['school-clusters'],
    queryFn: async () => {
      const response = await api.get('/school-clusters');
      return response.data;
    },
  });

  const { data: schools, isLoading: schoolsLoading } = useQuery<School[]>({
    queryKey: ['schools'],
    queryFn: async () => {
      const response = await api.get('/schools');
      return response.data;
    },
  });

  const { data: membersData, isLoading: membersLoading } = useQuery<{
    data: AssociationMemberRow[];
    meta: { total: number };
  }>({
    queryKey: ['school-mgmt-members', schoolFilter],
    queryFn: async () => {
      const params = new URLSearchParams({ limit: '500' });
      if (schoolFilter) params.append('schoolId', schoolFilter);
      const response = await api.get(`/association-members?${params}`);
      return response.data;
    },
    enabled: manageTab === 'members',
  });

  const schoolOptions = useMemo(() => {
    if (!schools) return [];
    if (!clusterFilter) return schools;
    return schools.filter((s) => s.clusterId === clusterFilter);
  }, [schools, clusterFilter]);

  const filteredSchools = useMemo(() => {
    return schoolOptions.filter((s) => !schoolFilter || s.id === schoolFilter);
  }, [schoolOptions, schoolFilter]);

  const filteredClusters = useMemo(() => {
    if (!clusters) return [];
    if (!clusterFilter) return clusters;
    return clusters.filter((c) => c.id === clusterFilter);
  }, [clusters, clusterFilter]);

  const filteredMembers = useMemo(() => {
    if (!membersData?.data) return [];
    return membersData.data.filter((m) => {
      if (schoolFilter && m.school.id !== schoolFilter) return false;
      if (clusterFilter && m.school.cluster?.id !== clusterFilter) return false;
      return true;
    });
  }, [membersData, clusterFilter, schoolFilter]);

  const handleClusterFilterChange = (value: string) => {
    setClusterFilter(value);
    setSchoolFilter('');
  };

  const filteredHierarchy = useMemo((): HierarchyData | null => {
    if (!hierarchy) return null;

    const matchSchool = (school: HierarchySchool) =>
      !schoolFilter || school.id === schoolFilter;

    const clusters = hierarchy.clusters
      .filter((c) => !clusterFilter || c.id === clusterFilter)
      .map((c) => ({
        ...c,
        schools: c.schools.filter(matchSchool),
      }))
      .filter((c) => c.schools.length > 0 || (!schoolFilter && !clusterFilter));

    const unassignedSchools = hierarchy.unassignedSchools.filter((s) => {
      if (clusterFilter) return false;
      return matchSchool(s);
    });

    return { clusters, unassignedSchools };
  }, [hierarchy, clusterFilter, schoolFilter]);

  const invalidateAll = () => {
    queryClient.invalidateQueries({ queryKey: ['school-hierarchy'] });
    queryClient.invalidateQueries({ queryKey: ['school-clusters'] });
    queryClient.invalidateQueries({ queryKey: ['schools'] });
    queryClient.invalidateQueries({ queryKey: ['school-mgmt-members'] });
  };

  const createClusterMutation = useMutation({
    mutationFn: (data: ClusterForm) => api.post('/school-clusters', data),
    onSuccess: () => {
      invalidateAll();
      showSuccess('เพิ่มกลุ่มสำเร็จ');
      closeClusterModal();
    },
    onError: (error: any) => showError(error.response?.data?.message || 'เกิดข้อผิดพลาด'),
  });

  const updateClusterMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<ClusterForm> }) =>
      api.patch(`/school-clusters/${id}`, data),
    onSuccess: () => {
      invalidateAll();
      showSuccess('แก้ไขกลุ่มสำเร็จ');
      closeClusterModal();
    },
    onError: (error: any) => showError(error.response?.data?.message || 'เกิดข้อผิดพลาด'),
  });

  const deleteClusterMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/school-clusters/${id}`),
    onSuccess: () => {
      invalidateAll();
      showSuccess('ลบกลุ่มสำเร็จ');
    },
    onError: (error: any) => showError(error.response?.data?.message || 'เกิดข้อผิดพลาด'),
  });

  const createSchoolMutation = useMutation({
    mutationFn: (data: SchoolForm) => api.post('/schools', data),
    onSuccess: () => {
      invalidateAll();
      showSuccess('เพิ่มโรงเรียนสำเร็จ');
      closeSchoolModal();
    },
    onError: (error: any) => showError(error.response?.data?.message || 'เกิดข้อผิดพลาด'),
  });

  const updateSchoolMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<SchoolForm> }) =>
      api.patch(`/schools/${id}`, data),
    onSuccess: () => {
      invalidateAll();
      showSuccess('แก้ไขข้อมูลสำเร็จ');
      closeSchoolModal();
    },
    onError: (error: any) => showError(error.response?.data?.message || 'เกิดข้อผิดพลาด'),
  });

  const deleteSchoolMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/schools/${id}`),
    onSuccess: () => {
      invalidateAll();
      showSuccess('ปิดใช้งานโรงเรียนสำเร็จ');
    },
    onError: (error: any) => showError(error.response?.data?.message || 'เกิดข้อผิดพลาด'),
  });

  const openClusterModal = (cluster?: SchoolCluster) => {
    if (cluster) {
      setEditingCluster(cluster);
      clusterForm.reset({ code: cluster.code, name: cluster.name });
    } else {
      setEditingCluster(null);
      clusterForm.reset({ code: '', name: '' });
    }
    setClusterModalOpen(true);
  };

  const closeClusterModal = () => {
    setClusterModalOpen(false);
    setEditingCluster(null);
    clusterForm.reset();
  };

  const openSchoolModal = (school?: School) => {
    if (school) {
      setEditingSchool(school);
      schoolForm.reset({
        code: school.code,
        name: school.name,
        district: school.district || '',
        province: school.province || '',
        clusterId: school.clusterId || '',
      });
    } else {
      setEditingSchool(null);
      schoolForm.reset({ code: '', name: '', district: '', province: '', clusterId: '' });
    }
    setSchoolModalOpen(true);
  };

  const closeSchoolModal = () => {
    setSchoolModalOpen(false);
    setEditingSchool(null);
    schoolForm.reset();
  };

  const onClusterSubmit = (data: ClusterForm) => {
    if (editingCluster) {
      updateClusterMutation.mutate({ id: editingCluster.id, data: { name: data.name } });
    } else {
      createClusterMutation.mutate(data);
    }
  };

  const onSchoolSubmit = (data: SchoolForm) => {
    if (editingSchool) {
      const { code, ...updateData } = data;
      updateSchoolMutation.mutate({ id: editingSchool.id, data: updateData });
    } else {
      createSchoolMutation.mutate(data);
    }
  };

  const isLoading =
    (manageTab === 'hierarchy' && hierarchyLoading) ||
    (manageTab === 'clusters' && clustersLoading) ||
    (manageTab === 'schools' && schoolsLoading) ||
    (manageTab === 'members' && membersLoading);

  const tabClass = (tab: ManageTab) =>
    `inline-flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
      manageTab === tab
        ? 'bg-primary-100 text-primary-700'
        : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
    }`;

  const renderHierarchy = () => {
    if (!filteredHierarchy) return null;

    const rows: ReactNode[] = [];

    const renderSchool = (school: HierarchySchool, clusterName: string) => {
      rows.push(
        <tr key={`school-${school.id}`} className="bg-slate-50/50">
          <td className="pl-8">
            <div className="flex items-center gap-2">
              <Building2 size={16} className="text-primary-500" />
              <span className="text-slate-500 text-xs">โรงเรียน</span>
            </div>
          </td>
          <td className="font-mono text-sm">{school.code}</td>
          <td className="font-medium">{school.name}</td>
          <td className="text-slate-500">{clusterName}</td>
          <td className="text-center">{school._count.associationMembers}</td>
          <td>
            <button
              onClick={() => openSchoolModal(schools?.find((s) => s.id === school.id))}
              className="p-2 rounded-lg hover:bg-slate-100 text-slate-500"
            >
              <Edit size={16} />
            </button>
          </td>
        </tr>,
      );

      school.associationMembers.forEach((member) => {
        rows.push(
          <tr key={`member-${member.id}`} className="text-sm">
            <td className="pl-16">
              <div className="flex items-center gap-2 text-slate-500">
                <User size={14} />
                <span className="text-xs">สมาชิก (ครู)</span>
              </div>
            </td>
            <td className="font-mono text-xs">{member.associationMemberNo || '-'}</td>
            <td>
              {member.firstName} {member.lastName}
            </td>
            <td className="text-slate-500">{member.memberType.name}</td>
            <td />
            <td />
          </tr>,
        );
      });
    };

    filteredHierarchy.clusters.forEach((cluster) => {
      rows.push(
        <tr key={`cluster-${cluster.id}`} className="bg-violet-50/60">
          <td>
            <div className="flex items-center gap-2 font-semibold text-violet-800">
              <FolderTree size={16} />
              <span>กลุ่ม</span>
            </div>
          </td>
          <td className="font-mono text-sm">{cluster.code}</td>
          <td className="font-semibold">{cluster.name}</td>
          <td />
          <td className="text-center font-medium">
            {cluster.schools.reduce((sum, s) => sum + s._count.associationMembers, 0)}
          </td>
          <td>
            <button
              onClick={() => openClusterModal(clusters?.find((c) => c.id === cluster.id))}
              className="p-2 rounded-lg hover:bg-violet-100 text-violet-600"
            >
              <Edit size={16} />
            </button>
          </td>
        </tr>,
      );

      cluster.schools.forEach((school) => renderSchool(school, cluster.name));
    });

    if (filteredHierarchy.unassignedSchools.length > 0) {
      rows.push(
        <tr key="unassigned-header" className="bg-amber-50/60">
          <td colSpan={6} className="font-medium text-amber-800">
            โรงเรียนที่ยังไม่ระบุกลุ่ม
          </td>
        </tr>,
      );
      filteredHierarchy.unassignedSchools.forEach((school) => renderSchool(school, '-'));
    }

    return (
      <div className="card overflow-hidden">
        <div className="table-container border-0">
          <table className="table">
            <thead>
              <tr>
                <th>ระดับ</th>
                <th>รหัส</th>
                <th>ชื่อ</th>
                <th>กลุ่ม / ประเภท</th>
                <th className="text-center">สมาชิก</th>
                <th className="text-right">จัดการ</th>
              </tr>
            </thead>
            <tbody>{rows}</tbody>
          </table>
        </div>
      </div>
    );
  };

  const renderClusters = () => (
    <div className="card overflow-hidden">
      <div className="table-container border-0">
        <table className="table">
          <thead>
            <tr>
              <th>รหัสกลุ่ม</th>
              <th>ชื่อกลุ่ม</th>
              <th className="text-center">โรงเรียน</th>
              <th className="text-center">สมาชิก (ครู)</th>
              <th className="text-right">จัดการ</th>
            </tr>
          </thead>
          <tbody>
            {filteredClusters.map((cluster) => (
              <tr key={cluster.id}>
                <td className="font-mono text-sm">{cluster.code}</td>
                <td className="font-medium">{cluster.name}</td>
                <td className="text-center">{cluster._count?.schools || 0}</td>
                <td className="text-center">{cluster._count?.members || 0}</td>
                <td>
                  <div className="flex justify-end gap-1">
                    <button
                      onClick={() => openClusterModal(cluster)}
                      className="p-2 rounded-lg hover:bg-slate-100 text-slate-500"
                    >
                      <Edit size={18} />
                    </button>
                    <button
                      onClick={() =>
                        showConfirm('ต้องการลบกลุ่มนี้หรือไม่?', () =>
                          deleteClusterMutation.mutate(cluster.id),
                        )
                      }
                      className="p-2 rounded-lg hover:bg-red-50 text-slate-500 hover:text-red-600"
                    >
                      <Trash2 size={18} />
                    </button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );

  const renderSchools = () => {
    if (filteredSchools.length === 0) {
      return (
        <div className="card p-12 text-center text-slate-500">
          <Building2 size={40} className="mx-auto mb-3 text-slate-300" />
          <p className="font-medium">ไม่พบโรงเรียนตามตัวกรอง</p>
          <p className="text-sm mt-1">ลองเปลี่ยนตัวกรองกลุ่มหรือโรงเรียน</p>
        </div>
      );
    }

    if (viewMode === 'cards') {
      return (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {filteredSchools.map((school) => (
            <motion.div key={school.id} className="card-hover p-6">
              <div className="flex items-start justify-between mb-4">
                <div className="w-12 h-12 bg-primary-100 rounded-xl flex items-center justify-center">
                  <Building2 className="w-6 h-6 text-primary-600" />
                </div>
                <div className="flex gap-1">
                  <button
                    onClick={() => openSchoolModal(school)}
                    className="p-2 rounded-lg hover:bg-slate-100 text-slate-500"
                  >
                    <Edit size={16} />
                  </button>
                  <button
                    onClick={() =>
                      showConfirm('ต้องการปิดใช้งานโรงเรียนนี้หรือไม่?', () =>
                        deleteSchoolMutation.mutate(school.id),
                      )
                    }
                    className="p-2 rounded-lg hover:bg-red-50 text-slate-500 hover:text-red-600"
                  >
                    <Trash2 size={16} />
                  </button>
                </div>
              </div>
              <h3 className="font-semibold text-slate-900 mb-1">{school.name}</h3>
              <p className="text-sm text-slate-500 mb-2">รหัส: {school.code}</p>
              <p className="text-sm text-violet-600 mb-4">
                กลุ่ม: {school.cluster?.name || 'ยังไม่ระบุ'}
              </p>
              <div className="flex gap-4 text-sm">
                <div className="flex items-center gap-1.5 text-slate-600">
                  <Users size={16} className="text-slate-400" />
                  <span>{school._count?.associationMembers || 0} สมาชิก</span>
                </div>
              </div>
            </motion.div>
          ))}
        </div>
      );
    }

    return (
      <div className="card overflow-hidden">
        <div className="table-container border-0">
          <table className="table">
            <thead>
              <tr>
                <th>รหัส</th>
                <th>ชื่อโรงเรียน</th>
                <th>กลุ่ม</th>
                <th>อำเภอ</th>
                <th>จังหวัด</th>
                <th className="text-center">สมาชิก</th>
                <th className="text-right">จัดการ</th>
              </tr>
            </thead>
            <tbody>
              {filteredSchools.map((school) => (
                <tr key={school.id}>
                  <td className="font-mono text-sm">{school.code}</td>
                  <td className="font-medium">{school.name}</td>
                  <td className="text-violet-700">{school.cluster?.name || '-'}</td>
                  <td className="text-slate-500">{school.district || '-'}</td>
                  <td className="text-slate-500">{school.province || '-'}</td>
                  <td className="text-center">{school._count?.associationMembers || 0}</td>
                  <td>
                    <div className="flex justify-end gap-1">
                      <button
                        onClick={() => openSchoolModal(school)}
                        className="p-2 rounded-lg hover:bg-slate-100 text-slate-500"
                      >
                        <Edit size={18} />
                      </button>
                      <button
                        onClick={() =>
                          showConfirm('ต้องการปิดใช้งานโรงเรียนนี้หรือไม่?', () =>
                            deleteSchoolMutation.mutate(school.id),
                          )
                        }
                        className="p-2 rounded-lg hover:bg-red-50 text-slate-500 hover:text-red-600"
                      >
                        <Trash2 size={18} />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    );
  };

  const renderMembers = () => (
    <div className="card overflow-hidden">
      <div className="table-container border-0">
        <table className="table">
          <thead>
            <tr>
              <th>เลขสมาชิก</th>
              <th>ชื่อ-นามสกุล</th>
              <th>ประเภท</th>
              <th>โรงเรียน</th>
              <th>กลุ่ม</th>
            </tr>
          </thead>
          <tbody>
            {filteredMembers.map((member) => (
              <tr key={member.id}>
                <td className="font-mono text-sm">{member.associationMemberNo || '-'}</td>
                <td className="font-medium">
                  {member.firstName} {member.lastName}
                </td>
                <td className="text-slate-500">{member.memberType.name}</td>
                <td>{member.school.name}</td>
                <td className="text-violet-700">{member.school.cluster?.name || '-'}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      {membersData && (
        <p className="px-4 py-3 text-sm text-slate-500 border-t border-slate-100">
          แสดง {filteredMembers.length} คน
          {(clusterFilter || schoolFilter) && ` (จากทั้งหมด ${membersData.meta.total} คน)`}
        </p>
      )}
    </div>
  );

  const addButton = () => {
    if (manageTab === 'clusters' || manageTab === 'hierarchy') {
      return (
        <button onClick={() => openClusterModal()} className="btn-primary">
          <Plus size={20} />
          เพิ่มกลุ่ม
        </button>
      );
    }
    if (manageTab === 'schools') {
      return (
        <button onClick={() => openSchoolModal()} className="btn-primary">
          <Plus size={20} />
          เพิ่มโรงเรียน
        </button>
      );
    }
    return null;
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      className="space-y-6"
    >
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-display font-bold text-slate-900">
            การจัดการโรงเรียน
          </h1>
          <p className="text-slate-500 mt-1">
            โครงสร้าง: กลุ่ม → โรงเรียน → สมาชิก (ครู)
          </p>
        </div>
        {addButton()}
      </div>

      <div className="card p-4">
        <div className="flex flex-col md:flex-row gap-4">
          <div className="w-full md:w-64">
            <label className="block text-sm font-medium text-slate-700 mb-1">กลุ่ม</label>
            <div className="flex items-center gap-2">
              <FolderTree size={18} className="text-slate-400 shrink-0" />
              <select
                value={clusterFilter}
                onChange={(e) => handleClusterFilterChange(e.target.value)}
                className="input"
              >
                <option value="">ทุกกลุ่ม</option>
                {clusters?.map((cluster) => (
                  <option key={cluster.id} value={cluster.id}>
                    {cluster.name}
                  </option>
                ))}
              </select>
            </div>
          </div>
          <div className="flex-1">
            <label className="block text-sm font-medium text-slate-700 mb-1">โรงเรียน</label>
            <div className="flex items-center gap-2">
              <Building2 size={18} className="text-slate-400 shrink-0" />
              <select
                value={schoolFilter}
                onChange={(e) => setSchoolFilter(e.target.value)}
                className="input"
              >
                <option value="">
                  ทุกโรงเรียน{schoolOptions.length > 0 ? ` (${schoolOptions.length})` : ''}
                </option>
                {schoolOptions.map((school) => (
                  <option key={school.id} value={school.id}>
                    {school.name}
                  </option>
                ))}
              </select>
            </div>
          </div>
        </div>
      </div>

      <div className="flex flex-wrap gap-2">
        <button onClick={() => setManageTab('hierarchy')} className={tabClass('hierarchy')}>
          <GitBranch size={16} />
          โครงสร้าง
        </button>
        <button onClick={() => setManageTab('clusters')} className={tabClass('clusters')}>
          <FolderTree size={16} />
          กลุ่ม
        </button>
        <button onClick={() => setManageTab('schools')} className={tabClass('schools')}>
          <Building2 size={16} />
          โรงเรียน
        </button>
        <button onClick={() => setManageTab('members')} className={tabClass('members')}>
          <Users size={16} />
          สมาชิก (ครู)
        </button>
      </div>

      {manageTab === 'schools' && (
        <div className="flex gap-2">
          <button
            onClick={() => setViewMode('cards')}
            className={`inline-flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
              viewMode === 'cards'
                ? 'bg-primary-100 text-primary-700'
                : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
            }`}
          >
            <LayoutGrid size={16} />
            การ์ด
          </button>
          <button
            onClick={() => setViewMode('table')}
            className={`inline-flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
              viewMode === 'table'
                ? 'bg-primary-100 text-primary-700'
                : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
            }`}
          >
            <Table2 size={16} />
            ตาราง
          </button>
        </div>
      )}

      {isLoading ? (
        <div className="flex items-center justify-center py-20">
          <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : (
        <>
          {manageTab === 'hierarchy' && renderHierarchy()}
          {manageTab === 'clusters' && renderClusters()}
          {manageTab === 'schools' && renderSchools()}
          {manageTab === 'members' && renderMembers()}
        </>
      )}

      <AnimatePresence>
        {clusterModalOpen && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
            onClick={closeClusterModal}
          >
            <motion.div
              initial={{ opacity: 0, scale: 0.95, y: 20 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.95, y: 20 }}
              className="bg-white rounded-2xl w-full max-w-md p-6 shadow-xl"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="flex items-center justify-between mb-6">
                <h2 className="text-xl font-semibold">
                  {editingCluster ? 'แก้ไขกลุ่ม' : 'เพิ่มกลุ่ม'}
                </h2>
                <button onClick={closeClusterModal} className="p-2 hover:bg-slate-100 rounded-lg">
                  <X size={20} />
                </button>
              </div>
              <form onSubmit={clusterForm.handleSubmit(onClusterSubmit)} className="space-y-4">
                <div>
                  <label className="label">รหัสกลุ่ม</label>
                  <input
                    {...clusterForm.register('code', { required: 'กรุณากรอกรหัสกลุ่ม' })}
                    className="input"
                    placeholder="เช่น CL01"
                    disabled={!!editingCluster}
                  />
                  {clusterForm.formState.errors.code && (
                    <p className="text-sm text-red-500 mt-1">
                      {clusterForm.formState.errors.code.message}
                    </p>
                  )}
                </div>
                <div>
                  <label className="label">ชื่อกลุ่ม</label>
                  <input
                    {...clusterForm.register('name', { required: 'กรุณากรอกชื่อกลุ่ม' })}
                    className="input"
                    placeholder="ชื่อกลุ่มโรงเรียน"
                  />
                  {clusterForm.formState.errors.name && (
                    <p className="text-sm text-red-500 mt-1">
                      {clusterForm.formState.errors.name.message}
                    </p>
                  )}
                </div>
                <div className="flex gap-3 pt-4">
                  <button type="button" onClick={closeClusterModal} className="btn-secondary flex-1">
                    ยกเลิก
                  </button>
                  <button
                    type="submit"
                    className="btn-primary flex-1"
                    disabled={createClusterMutation.isPending || updateClusterMutation.isPending}
                  >
                    บันทึก
                  </button>
                </div>
              </form>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

      <AnimatePresence>
        {schoolModalOpen && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
            onClick={closeSchoolModal}
          >
            <motion.div
              initial={{ opacity: 0, scale: 0.95, y: 20 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.95, y: 20 }}
              className="bg-white rounded-2xl w-full max-w-md p-6 shadow-xl"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="flex items-center justify-between mb-6">
                <h2 className="text-xl font-semibold">
                  {editingSchool ? 'แก้ไขโรงเรียน' : 'เพิ่มโรงเรียน'}
                </h2>
                <button onClick={closeSchoolModal} className="p-2 hover:bg-slate-100 rounded-lg">
                  <X size={20} />
                </button>
              </div>
              <form onSubmit={schoolForm.handleSubmit(onSchoolSubmit)} className="space-y-4">
                <div>
                  <label className="label">กลุ่ม *</label>
                  <select
                    {...schoolForm.register('clusterId', { required: 'กรุณาเลือกกลุ่ม' })}
                    className="input"
                  >
                    <option value="">เลือกกลุ่ม</option>
                    {clusters?.map((cluster) => (
                      <option key={cluster.id} value={cluster.id}>
                        {cluster.name}
                      </option>
                    ))}
                  </select>
                  {schoolForm.formState.errors.clusterId && (
                    <p className="text-sm text-red-500 mt-1">
                      {schoolForm.formState.errors.clusterId.message}
                    </p>
                  )}
                </div>
                <div>
                  <label className="label">รหัสโรงเรียน</label>
                  <input
                    {...schoolForm.register('code', { required: 'กรุณากรอกรหัสโรงเรียน' })}
                    className="input"
                    placeholder="เช่น SCH001"
                    disabled={!!editingSchool}
                  />
                </div>
                <div>
                  <label className="label">ชื่อโรงเรียน</label>
                  <input
                    {...schoolForm.register('name', { required: 'กรุณากรอกชื่อโรงเรียน' })}
                    className="input"
                    placeholder="ชื่อโรงเรียน"
                  />
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="label">อำเภอ</label>
                    <input {...schoolForm.register('district')} className="input" />
                  </div>
                  <div>
                    <label className="label">จังหวัด</label>
                    <input {...schoolForm.register('province')} className="input" />
                  </div>
                </div>
                <div className="flex gap-3 pt-4">
                  <button type="button" onClick={closeSchoolModal} className="btn-secondary flex-1">
                    ยกเลิก
                  </button>
                  <button
                    type="submit"
                    className="btn-primary flex-1"
                    disabled={createSchoolMutation.isPending || updateSchoolMutation.isPending}
                  >
                    บันทึก
                  </button>
                </div>
              </form>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  );
}