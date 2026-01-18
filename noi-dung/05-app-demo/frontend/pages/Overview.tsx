import React from 'react';
import { BookOpen, Database, Server, ShieldCheck, Activity, Layers, Code, FileBarChart, Sparkles } from 'lucide-react';
import { useConfig } from '../contexts/ConfigContext';

const Overview: React.FC = () => {
  const { config, loading } = useConfig();

  if (loading) return <div className="p-8">Loading...</div>;

  // Use config data or empty object to prevent crashes
  const ov = config?.overview;

  // Safe defaults if config.json is partial
  const header = ov?.header || { title: "Tổng Quan Đồ Án", subtitle: "Hệ thống...", subject: "", teacher: "" };
  const sec1 = ov?.section1 || { title: "", problemStatement: "", steps: [] };
  const sec2 = ov?.section2 || { title: "", erdHighlights: [], businessConstraints: [] };
  const sec3 = ov?.section3 || { title: "", dbSystem: "", features: [] };
  const sec4 = ov?.section4 || { title: "", stats: [], security: [] };

  return (
    <div className="h-full overflow-y-auto bg-gradient-to-br from-slate-50 via-slate-100 to-slate-200 dark:from-dark-bg dark:via-dark-surface dark:to-dark-bg">
      <div className="max-w-6xl mx-auto p-8 space-y-12 pb-16">
        {/* Professional Academic Header */}
        <div className="relative">
          {/* Gradient Overlay */}
          <div className="absolute inset-0 bg-gradient-to-r from-primary-500/10 via-accent-purple-500/10 to-accent-cyan-500/10 dark:from-primary-500/5 dark:via-accent-purple-500/5 dark:to-accent-cyan-500/5 blur-3xl"></div>

          <div className="relative backdrop-blur-xl bg-white/80 dark:bg-dark-surface/80 border border-slate-200/50 dark:border-dark-border/50 rounded-3xl p-10 shadow-2xl">
            {/* University Logo/Icon */}
            <div className="flex justify-center mb-6">
              <div className="p-5 rounded-2xl bg-gradient-to-br from-primary-500 to-primary-600 shadow-lg shadow-primary-500/30">
                <Sparkles className="text-white" size={40} strokeWidth={2.5} />
              </div>
            </div>

            {/* Project Title - Centered */}
            <div className="text-center mb-8">
              <h1 className="text-4xl font-bold bg-gradient-to-r from-slate-900 to-slate-700 dark:from-dark-text-primary dark:to-dark-text-secondary bg-clip-text text-transparent leading-tight mb-2">
                {header.title}
              </h1>
            </div>

            {/* Academic Info Grid - Professional Layout */}
            <div className="max-w-4xl mx-auto space-y-3">
              {/* Course Subject */}
              {(header as any).subject && (
                <div className="flex items-center justify-center gap-3 px-6 py-3 rounded-xl bg-gradient-to-r from-slate-50 to-slate-100 dark:from-slate-800/50 dark:to-slate-700/50 border border-slate-200/50 dark:border-slate-600/50">
                  <BookOpen size={18} className="text-primary-600 dark:text-primary-400" strokeWidth={2.5} />
                  <span className="text-base font-semibold text-slate-700 dark:text-slate-300">
                    Môn học: <span className="text-primary-600 dark:text-primary-400">{(header as any).subject}</span>
                  </span>
                </div>
              )}

              {/* Group and Instructor Row */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                {/* Group Name */}
                <div className="flex items-center justify-center gap-3 px-6 py-3 rounded-xl bg-gradient-to-r from-accent-purple-50 to-accent-purple-100 dark:from-accent-purple-500/10 dark:to-accent-purple-600/10 border border-accent-purple-200/50 dark:border-accent-purple-500/30">
                  <div className="w-2.5 h-2.5 rounded-full bg-gradient-to-r from-accent-purple-500 to-accent-purple-600"></div>
                  <span className="text-base font-semibold text-accent-purple-700 dark:text-accent-purple-400">
                    {header.subtitle}
                  </span>
                </div>

                {/* Instructor */}
                {(header as any).teacher && (
                  <div className="flex items-center justify-center gap-3 px-6 py-3 rounded-xl bg-gradient-to-r from-accent-cyan-50 to-accent-cyan-100 dark:from-accent-cyan-500/10 dark:to-accent-cyan-600/10 border border-accent-cyan-200/50 dark:border-accent-cyan-500/30">
                    <div className="w-2.5 h-2.5 rounded-full bg-gradient-to-r from-accent-cyan-500 to-accent-cyan-600"></div>
                    <span className="text-base font-semibold text-accent-cyan-700 dark:text-accent-cyan-400">
                      {(header as any).teacher}
                    </span>
                  </div>
                )}
              </div>
            </div>

            {/* Decorative Bottom Border */}
            <div className="mt-8 pt-6 border-t border-slate-200/50 dark:border-slate-700/50">
              <div className="flex justify-center gap-2">
                <div className="w-16 h-1 rounded-full bg-gradient-to-r from-primary-500 to-primary-600"></div>
                <div className="w-16 h-1 rounded-full bg-gradient-to-r from-accent-purple-500 to-accent-purple-600"></div>
                <div className="w-16 h-1 rounded-full bg-gradient-to-r from-accent-cyan-500 to-accent-cyan-600"></div>
              </div>
            </div>
          </div>
        </div>

        {/* 1. Mô tả bài toán - Primary Blue */}
        <section className="space-y-6">
          <div className="flex items-center gap-4">
            <div className="p-3 rounded-2xl bg-gradient-to-br from-primary-500 to-primary-600 shadow-lg shadow-primary-500/30">
              <BookOpen size={28} className="text-white" strokeWidth={2.5} />
            </div>
            <h2 className="text-3xl font-bold bg-gradient-to-r from-primary-600 to-primary-700 dark:from-primary-400 dark:to-primary-500 bg-clip-text text-transparent">
              {sec1.title}
            </h2>
          </div>

          <div className="pl-4 md:pl-16 space-y-6">
            {/* Problem Statement Card */}
            <div className="relative group">ø
              <div className="absolute inset-0 bg-gradient-to-r from-primary-500/20 to-primary-600/20 blur-xl rounded-3xl opacity-0 group-hover:opacity-100 transition-opacity"></div>
              <div className="relative backdrop-blur-xl bg-white/90 dark:bg-dark-elevated/90 p-8 rounded-3xl border border-primary-200/50 dark:border-primary-500/30 shadow-xl hover:shadow-2xl transition-all">
                <h3 className="font-bold text-xl text-slate-900 dark:text-white mb-3 flex items-center gap-2">
                  <div className="w-2 h-2 rounded-full bg-gradient-to-r from-primary-500 to-primary-600"></div>
                  Phát biểu bài toán & Mục tiêu
                </h3>
                <p className="leading-relaxed text-base text-slate-700 dark:text-dark-text-primary font-medium">
                  {sec1.problemStatement}
                </p>
              </div>
            </div>

            {/* Process Steps */}
            <div>
              <h3 className="font-bold text-xl text-slate-900 dark:text-white mb-4">Quy trình thực tế</h3>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                {sec1.steps.map((item, index) => (
                  <div
                    key={item.step}
                    className="group relative backdrop-blur-xl bg-white/80 dark:bg-dark-elevated/80 p-5 rounded-2xl border border-slate-200/50 dark:border-dark-border/50 shadow-lg hover:shadow-xl transition-all hover:scale-105"
                    style={{ animationDelay: `${index * 50}ms` }}
                  >
                    {/* Step Number Badge */}
                    <div className="absolute -top-3 -left-3 w-10 h-10 rounded-xl bg-gradient-to-br from-primary-500 to-primary-600 text-white flex items-center justify-center font-bold text-lg shadow-lg shadow-primary-500/30">
                      {item.step}
                    </div>
                    <h4 className="font-bold text-slate-900 dark:text-white mt-2 mb-2">{item.title}</h4>
                    <p className="text-sm text-slate-600 dark:text-dark-text-secondary font-medium leading-relaxed">{item.desc}</p>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </section>

        {/* 2. Phân tích và thiết kế - Cyan */}
        <section className="space-y-6">
          <div className="flex items-center gap-4">
            <div className="p-3 rounded-2xl bg-gradient-to-br from-accent-cyan-500 to-accent-cyan-600 shadow-lg shadow-accent-cyan-500/30">
              <Layers size={28} className="text-white" strokeWidth={2.5} />
            </div>
            <h2 className="text-3xl font-bold bg-gradient-to-r from-accent-cyan-600 to-accent-cyan-700 dark:from-accent-cyan-400 dark:to-accent-cyan-500 bg-clip-text text-transparent">
              {sec2.title}
            </h2>
          </div>

          <div className="pl-4 md:pl-16 grid grid-cols-1 md:grid-cols-2 gap-6">
            {/* ERD Card */}
            <div className="relative group h-full">
              <div className="absolute inset-0 bg-gradient-to-r from-accent-cyan-500/20 to-accent-cyan-600/20 blur-xl rounded-3xl opacity-0 group-hover:opacity-100 transition-opacity"></div>
              <div className="relative h-full backdrop-blur-xl bg-white/90 dark:bg-white/10 p-6 rounded-3xl border border-accent-cyan-200/50 dark:border-accent-cyan-500/30 shadow-xl hover:shadow-2xl transition-all flex flex-col">
                <h3 className="font-bold text-lg text-slate-900 dark:text-white mb-4 flex items-center gap-2">
                  <Database size={20} className="text-accent-cyan-500" strokeWidth={2.5} />
                  Mô hình dữ liệu (ERD)
                </h3>
                <ul className="space-y-2.5 text-sm flex-1">
                  {sec2.erdHighlights.map((text, i) => (
                    <li key={i} className="flex items-start gap-3 text-slate-700 dark:text-dark-text-secondary">
                      <div className="mt-1.5 w-2 h-2 rounded-full bg-gradient-to-r from-accent-cyan-500 to-accent-cyan-600 flex-shrink-0"></div>
                      <span>{text}</span>
                    </li>
                  ))}
                </ul>
              </div>
            </div>

            {/* Business Constraints Card */}
            <div className="relative group h-full">
              <div className="absolute inset-0 bg-gradient-to-r from-accent-orange-500/20 to-accent-orange-600/20 blur-xl rounded-3xl opacity-0 group-hover:opacity-100 transition-opacity"></div>
              <div className="relative h-full backdrop-blur-xl bg-white/90 dark:bg-white/10 p-6 rounded-3xl border border-accent-orange-200/50 dark:border-accent-orange-500/30 shadow-xl hover:shadow-2xl transition-all flex flex-col">
                <h3 className="font-bold text-lg text-slate-900 dark:text-white mb-4 flex items-center gap-2">
                  <ShieldCheck size={20} className="text-accent-orange-500" strokeWidth={2.5} />
                  Ràng buộc nghiệp vụ
                </h3>
                <ul className="space-y-2.5 text-sm flex-1">
                  {sec2.businessConstraints.map((text, i) => (
                    <li key={i} className="flex items-start gap-3 text-slate-700 dark:text-dark-text-secondary">
                      <div className="mt-1.5 w-2 h-2 rounded-full bg-gradient-to-r from-accent-orange-500 to-accent-orange-600 flex-shrink-0"></div>
                      <span>{text}</span>
                    </li>
                  ))}
                </ul>
              </div>
            </div>
          </div>
        </section>

        {/* 3. Cài đặt - Green */}
        <section className="space-y-6">
          <div className="flex items-center gap-4">
            <div className="p-3 rounded-2xl bg-gradient-to-br from-accent-green-500 to-accent-green-600 shadow-lg shadow-accent-green-500/30">
              <Code size={28} className="text-white" strokeWidth={2.5} />
            </div>
            <h2 className="text-3xl font-bold bg-gradient-to-r from-accent-green-600 to-accent-green-700 dark:from-accent-green-400 dark:to-accent-green-500 bg-clip-text text-transparent">
              {sec3.title}
            </h2>
          </div>

          <div className="pl-4 md:pl-16 space-y-6">
            <div className="backdrop-blur-xl bg-white/80 dark:bg-dark-elevated/80 p-6 rounded-2xl border border-slate-200/50 dark:border-dark-border/50 shadow-lg">
              <p className="text-base text-slate-700 dark:text-dark-text-secondary">
                Hệ quản trị CSDL lựa chọn: <strong className="text-accent-green-600 dark:text-accent-green-400 font-bold">{sec3.dbSystem}</strong>
              </p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              {sec3.features.map((feat, i) => (
                <div
                  key={i}
                  className="group relative backdrop-blur-xl bg-white/80 dark:bg-dark-elevated/80 border border-slate-200/50 dark:border-dark-border/50 p-5 rounded-2xl shadow-lg hover:shadow-xl transition-all hover:scale-105"
                  style={{ animationDelay: `${i * 50}ms` }}
                >
                  <div className="absolute inset-0 bg-gradient-to-r from-accent-green-500/10 to-accent-green-600/10 rounded-2xl opacity-0 group-hover:opacity-100 transition-opacity"></div>
                  <span className="relative block font-bold text-slate-900 dark:text-white mb-2 text-base">{feat.title}</span>
                  <span className="relative text-sm text-slate-600 dark:text-dark-text-secondary">{feat.desc}</span>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* 4. Quản lý thông tin - Purple */}
        <section className="space-y-6">
          <div className="flex items-center gap-4">
            <div className="p-3 rounded-2xl bg-gradient-to-br from-accent-purple-500 to-accent-purple-600 shadow-lg shadow-accent-purple-500/30">
              <Server size={28} className="text-white" strokeWidth={2.5} />
            </div>
            <h2 className="text-3xl font-bold bg-gradient-to-r from-accent-purple-600 to-accent-purple-700 dark:from-accent-purple-400 dark:to-accent-purple-500 bg-clip-text text-transparent">
              {sec4.title}
            </h2>
          </div>

          <div className="pl-4 md:pl-16 grid grid-cols-1 md:grid-cols-2 gap-6">
            {/* Stats Card */}
            <div className="relative group h-full">
              <div className="absolute inset-0 bg-gradient-to-r from-accent-purple-500/20 to-accent-purple-600/20 blur-xl rounded-3xl opacity-0 group-hover:opacity-100 transition-opacity"></div>
              <div className="relative h-full backdrop-blur-xl bg-white/90 dark:bg-white/10 p-8 rounded-3xl border border-accent-purple-200/50 dark:border-accent-purple-500/30 shadow-xl hover:shadow-2xl transition-all flex flex-col">
                <h3 className="font-bold text-xl text-slate-900 dark:text-white flex items-center gap-2 mb-6">
                  <Activity size={22} className="text-accent-purple-500" strokeWidth={2.5} />
                  Xử lý thông tin (Demo)
                </h3>
                <ul className="space-y-4 flex-1">
                  {sec4.stats.map((stat, i) => (
                    <li
                      key={i}
                      className={`flex items-center justify-between ${i !== sec4.stats.length - 1 ? 'border-b border-slate-200 dark:border-dark-border pb-3' : ''}`}
                    >
                      <span className="text-slate-700 dark:text-dark-text-secondary font-medium">{stat.label}</span>
                      <span className="font-mono font-bold text-lg px-3 py-1.5 rounded-xl bg-gradient-to-r from-accent-purple-50 to-accent-purple-100 dark:from-accent-purple-500/20 dark:to-accent-purple-600/20 text-accent-purple-600 dark:text-accent-purple-400 shadow-sm">
                        {stat.value}
                      </span>
                    </li>
                  ))}
                </ul>
              </div>
            </div>

            {/* Security Card */}
            <div className="relative group h-full">
              <div className="absolute inset-0 bg-gradient-to-r from-accent-cyan-500/20 to-accent-cyan-600/20 blur-xl rounded-3xl opacity-0 group-hover:opacity-100 transition-opacity"></div>
              <div className="relative h-full backdrop-blur-xl bg-white/90 dark:bg-white/10 p-8 rounded-3xl border border-accent-cyan-200/50 dark:border-accent-cyan-500/30 shadow-xl hover:shadow-2xl transition-all flex flex-col">
                <h3 className="font-bold text-xl text-slate-900 dark:text-white flex items-center gap-2 mb-6">
                  <FileBarChart size={22} className="text-accent-cyan-500" strokeWidth={2.5} />
                  An toàn & Tiện ích
                </h3>
                <ul className="space-y-4 flex-1">
                  {sec4.security.map((item, i) => (
                    <li key={i} className="flex items-start gap-3">
                      <div className="mt-1 p-1.5 rounded-lg bg-gradient-to-br from-accent-cyan-500 to-accent-cyan-600 shadow-sm">
                        <ShieldCheck size={14} className="text-white" strokeWidth={2.5} />
                      </div>
                      <div className="text-sm text-slate-700 dark:text-dark-text-secondary">
                        <strong className="text-slate-900 dark:text-white">{item.label}:</strong> {item.desc}
                      </div>
                    </li>
                  ))}
                </ul>
              </div>
            </div>
          </div>
        </section>
      </div>
    </div>
  );
};

export default Overview;