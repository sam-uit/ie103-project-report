import React from 'react';
import { Users, CheckCircle2, FileText, UserCircle, Sparkles, Award } from 'lucide-react';
import { useConfig } from '../contexts/ConfigContext';

const Logs: React.FC = () => {
  const { config, loading } = useConfig();

  if (loading) return <div className="p-8">Loading...</div>;

  const members = config?.teamMembers || [];

  return (
    <div className="h-full overflow-y-auto bg-gradient-to-br from-slate-50 via-slate-100 to-slate-200 dark:from-dark-bg dark:via-dark-surface dark:to-dark-bg">
      <div className="max-w-6xl mx-auto p-8 flex flex-col gap-10">

        {/* Modern Header with Glassmorphism */}
        <div className="relative">
          {/* Gradient Overlay */}
          <div className="absolute inset-0 bg-gradient-to-r from-accent-green-500/10 via-accent-cyan-500/10 to-primary-500/10 dark:from-accent-green-500/5 dark:via-accent-cyan-500/5 dark:to-primary-500/5 blur-3xl"></div>

          <div className="relative backdrop-blur-xl bg-white/80 dark:bg-dark-surface/80 border border-slate-200/50 dark:border-dark-border/50 rounded-3xl p-8 shadow-2xl">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-4">
                <div className="p-3 rounded-2xl bg-gradient-to-br from-accent-green-500 to-accent-cyan-500 shadow-lg shadow-accent-green-500/30">
                  <Users className="text-white" size={28} strokeWidth={2.5} />
                </div>
                <div>
                  <h1 className="text-3xl font-bold bg-gradient-to-r from-slate-900 to-slate-700 dark:from-dark-text-primary dark:to-dark-text-secondary bg-clip-text text-transparent">
                    Thành Viên Nhóm & Phân Công
                  </h1>
                  <p className="text-slate-600 dark:text-dark-text-secondary mt-1 text-base font-medium">
                    Danh sách chi tiết các thành viên thực hiện đồ án và nhiệm vụ được giao.
                  </p>
                </div>
              </div>

              {/* Stats Badge */}
              <div className="backdrop-blur-xl bg-white/80 dark:bg-white/10 px-5 py-3 rounded-2xl border border-slate-200/50 dark:border-dark-border/50 shadow-lg">
                <div className="flex items-center gap-2">
                  <Award className="text-accent-green-500" size={20} strokeWidth={2.5} />
                  <span className="text-sm font-bold text-slate-600 dark:text-dark-text-secondary">
                    Tổng số: <span className="text-accent-green-600 dark:text-accent-green-400">{members.length} thành viên</span>
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Modern Members Table */}
        <div className="relative">
          {/* Glow Effect */}
          <div className="absolute inset-0 bg-gradient-to-r from-primary-500/10 to-accent-cyan-500/10 blur-xl rounded-3xl"></div>

          <div className="relative backdrop-blur-xl bg-white/90 dark:bg-white/10 border border-slate-200/50 dark:border-dark-border/50 rounded-3xl shadow-2xl overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse">
                <thead>
                  <tr className="bg-gradient-to-r from-slate-50 to-slate-100 dark:from-slate-800/50 dark:to-slate-900/50 border-b-2 border-primary-500/30">
                    <th className="py-5 px-6 text-sm font-bold text-slate-600 dark:text-dark-text-secondary uppercase tracking-wider w-40">
                      <div className="flex items-center gap-2">
                        <div className="w-1.5 h-1.5 rounded-full bg-primary-500"></div>
                        MSSV
                      </div>
                    </th>
                    <th className="py-5 px-6 text-sm font-bold text-slate-600 dark:text-dark-text-secondary uppercase tracking-wider">
                      <div className="flex items-center gap-2">
                        <div className="w-1.5 h-1.5 rounded-full bg-accent-cyan-500"></div>
                        Họ và Tên
                      </div>
                    </th>
                    <th className="py-5 px-6 text-sm font-bold text-slate-600 dark:text-dark-text-secondary uppercase tracking-wider">
                      <div className="flex items-center gap-2">
                        <div className="w-1.5 h-1.5 rounded-full bg-accent-green-500"></div>
                        Tasks
                      </div>
                    </th>
                    <th className="py-5 px-6 text-sm font-bold text-slate-600 dark:text-dark-text-secondary uppercase tracking-wider">
                      <div className="flex items-center gap-2">
                        <div className="w-1.5 h-1.5 rounded-full bg-accent-orange-500"></div>
                        Notes
                      </div>
                    </th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-200/50 dark:divide-slate-700/50">
                  {members.length === 0 ? (
                    <tr>
                      <td colSpan={4} className="py-12 text-center text-slate-400 italic">
                        Danh sách thành viên trống (kiểm tra config.json)
                      </td>
                    </tr>
                  ) : members.map((member, index) => (
                    <tr
                      key={member.mssv}
                      className="group hover:bg-white/50 dark:hover:bg-white/5 transition-all duration-300"
                      style={{ animationDelay: `${index * 50}ms` }}
                    >
                      {/* MSSV */}
                      <td className="py-5 px-6 font-mono text-slate-600 dark:text-dark-text-secondary font-bold group-hover:text-primary-600 dark:group-hover:text-primary-400 transition-colors">
                        <div className="flex items-center gap-2">
                          <div className="w-1 h-8 bg-gradient-to-b from-primary-500 to-primary-600 rounded-full opacity-0 group-hover:opacity-100 transition-opacity"></div>
                          {member.mssv}
                        </div>
                      </td>

                      {/* Name */}
                      <td className="py-5 px-6">
                        <div className="flex items-center gap-3">
                          {/* Avatar with Gradient */}
                          <div className="relative">
                            <div className="absolute inset-0 bg-gradient-to-br from-accent-cyan-500 to-primary-500 rounded-full blur-md opacity-50 group-hover:opacity-75 transition-opacity"></div>
                            <div className="relative w-10 h-10 rounded-full bg-gradient-to-br from-accent-cyan-500 to-primary-500 flex items-center justify-center text-white font-bold text-sm shadow-lg ring-2 ring-white dark:ring-slate-800">
                              {member.name.split(' ').pop()?.charAt(0) || <UserCircle size={20} />}
                            </div>
                          </div>
                          <span className="font-bold text-slate-900 dark:text-white group-hover:text-primary-600 dark:group-hover:text-primary-400 transition-colors">{member.name}</span>
                        </div>
                      </td>

                      {/* Tasks */}
                      <td className="py-5 px-6">
                        {member.tasks ? (
                          <div className="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-gradient-to-r from-accent-green-50 to-emerald-50 dark:from-accent-green-500/20 dark:to-emerald-500/20 border border-accent-green-200/50 dark:border-accent-green-500/30 shadow-sm hover:shadow-md transition-all">
                            <CheckCircle2 size={16} className="text-accent-green-600 dark:text-accent-green-400" strokeWidth={2.5} />
                            <span className="text-accent-green-700 dark:text-accent-green-300 text-sm font-bold">{member.tasks}</span>
                          </div>
                        ) : (
                          <span className="text-slate-400 italic text-sm">Đang cập nhật...</span>
                        )}
                      </td>

                      {/* Notes */}
                      <td className="py-5 px-6">
                        {member.notes && (
                          <div className="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-gradient-to-r from-amber-50 to-orange-50 dark:from-amber-500/20 dark:to-orange-500/20 border border-amber-200/50 dark:border-amber-500/30 shadow-sm">
                            <FileText size={16} className="text-amber-600 dark:text-amber-400" strokeWidth={2.5} />
                            <span className="text-amber-700 dark:text-amber-300 text-sm font-semibold">{member.notes}</span>
                          </div>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Logs;