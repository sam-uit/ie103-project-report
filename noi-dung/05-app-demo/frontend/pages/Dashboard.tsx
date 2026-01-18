import React, { useState, useEffect } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { useConfig } from '../contexts/ConfigContext';
import { Play, FileCode, ChevronRight, Loader2, Database, Zap, Box, GitBranch, Sparkles, ArrowRight } from 'lucide-react';
import { ScenarioType } from '../types';

// Modern 3D card styles with vibrant colors
const typeStyles: Record<string, {
      gradient: string;
      iconBg: string;
      badgeBg: string;
      glowColor: string;
      hoverGlow: string;
      activeTab: string;
      inactiveTab: string;
}> = {
      'Stored Procedure': {
            gradient: 'from-accent-orange-500/10 via-accent-orange-600/5 to-transparent',
            iconBg: 'bg-gradient-to-br from-accent-orange-500 to-accent-orange-600',
            badgeBg: 'bg-accent-orange-500',
            glowColor: 'shadow-accent-orange-500/20',
            hoverGlow: 'group-hover:shadow-accent-orange-500/40',
            activeTab: 'bg-gradient-to-r from-accent-orange-500 to-accent-orange-600 text-white shadow-xl shadow-accent-orange-500/30 ring-2 ring-accent-orange-500',
            inactiveTab: 'bg-white/60 dark:bg-dark-elevated/60 text-slate-600 dark:text-dark-text-secondary hover:text-accent-orange-600 dark:hover:text-accent-orange-400 hover:border-accent-orange-200 dark:hover:border-accent-orange-500/30'
      },
      'Trigger': {
            gradient: 'from-yellow-500/10 via-yellow-600/5 to-transparent',
            iconBg: 'bg-gradient-to-br from-yellow-500 to-yellow-600',
            badgeBg: 'bg-yellow-500',
            glowColor: 'shadow-yellow-500/20',
            hoverGlow: 'group-hover:shadow-yellow-500/40',
            activeTab: 'bg-gradient-to-r from-yellow-500 to-yellow-600 text-white shadow-xl shadow-yellow-500/30 ring-2 ring-yellow-500',
            inactiveTab: 'bg-white/60 dark:bg-dark-elevated/60 text-slate-600 dark:text-dark-text-secondary hover:text-yellow-600 dark:hover:text-yellow-400 hover:border-yellow-200 dark:hover:border-yellow-500/30'
      },
      'Function': {
            gradient: 'from-accent-green-500/10 via-accent-green-600/5 to-transparent',
            iconBg: 'bg-gradient-to-br from-accent-green-500 to-accent-green-600',
            badgeBg: 'bg-accent-green-500',
            glowColor: 'shadow-accent-green-500/20',
            hoverGlow: 'group-hover:shadow-accent-green-500/40',
            activeTab: 'bg-gradient-to-r from-accent-green-500 to-accent-green-600 text-white shadow-xl shadow-accent-green-500/30 ring-2 ring-accent-green-500',
            inactiveTab: 'bg-white/60 dark:bg-dark-elevated/60 text-slate-600 dark:text-dark-text-secondary hover:text-accent-green-600 dark:hover:text-accent-green-400 hover:border-accent-green-200 dark:hover:border-accent-green-500/30'
      },
      'Cursor': {
            gradient: 'from-accent-purple-500/10 via-accent-purple-600/5 to-transparent',
            iconBg: 'bg-gradient-to-br from-accent-purple-500 to-accent-purple-600',
            badgeBg: 'bg-accent-purple-500',
            glowColor: 'shadow-accent-purple-500/20',
            hoverGlow: 'group-hover:shadow-accent-purple-500/40',
            activeTab: 'bg-gradient-to-r from-accent-purple-500 to-accent-purple-600 text-white shadow-xl shadow-accent-purple-500/30 ring-2 ring-accent-purple-500',
            inactiveTab: 'bg-white/60 dark:bg-dark-elevated/60 text-slate-600 dark:text-dark-text-secondary hover:text-accent-purple-600 dark:hover:text-accent-purple-400 hover:border-accent-purple-200 dark:hover:border-accent-purple-500/30'
      }
};

const Dashboard: React.FC = () => {
      const navigate = useNavigate();
      const { config, loading } = useConfig();
      const [searchParams] = useSearchParams();
      const typeFilter = searchParams.get('type'); // Get type from URL
      const [activeTab, setActiveTab] = useState<string | null>(typeFilter);

      // Sync activeTab with URL query parameter
      useEffect(() => {
            // If there's a type filter in URL, set it as active
            // If no type filter (viewing all), set activeTab to null
            setActiveTab(typeFilter);
      }, [typeFilter]);

      if (loading) {
            return (
                  <div className="flex items-center justify-center h-full">
                        <Loader2 className="animate-spin text-primary-500" size={32} />
                        <span className="ml-2 text-slate-500 dark:text-dark-text-secondary">Loading Configuration...</span>
                  </div>
            );
      }

      const scenarios = config?.scenarios || [];
      // If activeTab is null (no filter), show all scenarios
      // Otherwise, filter by activeTab
      const filteredScenarios = activeTab ? scenarios.filter(s => s.type === activeTab) : scenarios;

      const tabs = [
            { key: ScenarioType.StoredProcedure, label: 'Stored Procedures', icon: Box, count: scenarios.filter(s => s.type === ScenarioType.StoredProcedure).length },
            { key: ScenarioType.Trigger, label: 'Triggers', icon: Zap, count: scenarios.filter(s => s.type === ScenarioType.Trigger).length },
            { key: ScenarioType.Function, label: 'Functions', icon: GitBranch, count: scenarios.filter(s => s.type === ScenarioType.Function).length },
            { key: ScenarioType.Cursor, label: 'Cursors', icon: FileCode, count: scenarios.filter(s => s.type === ScenarioType.Cursor).length },
      ];

      return (
            <div className="h-full flex flex-col bg-slate-50 dark:bg-dark-bg overflow-hidden">
                  {/* Modern Header with Glassmorphism */}
                  <div className="flex-none relative h-22">
                        <div className="relative border-b border-slate-200 dark:border-dark-border bg-white dark:bg-dark-surface shadow-sm z-10">
                              <div className="max-w-7xl mx-auto px-6 py-4">
                                    {/* Tabs */}
                                    <div className="flex gap-4 overflow-x-auto pb-1 scrollbar-hide py-1">
                                          {tabs.map((tab) => {
                                                const Icon = tab.icon;
                                                const isActive = activeTab === tab.key;
                                                const styles = typeStyles[tab.key] || typeStyles['Stored Procedure'];

                                                return (
                                                      <button
                                                            key={tab.key}
                                                            onClick={() => setActiveTab(tab.key)}
                                                            className={`
                                                                  group relative flex items-center gap-2.5 pl-4 pr-5 py-3 rounded-xl text-sm font-bold transition-all duration-300 whitespace-nowrap border
                                                                  ${isActive ? styles.activeTab + ' border-transparent scale-105' : styles.inactiveTab + ' border-slate-200 dark:border-dark-border/50 bg-white dark:bg-dark-elevated shadow-sm hover:shadow-md'}
                                                            `}
                                                      >
                                                            <Icon size={18} className={`transition-transform duration-300 ${isActive ? 'drop-shadow-sm' : 'group-hover:scale-110 group-hover:rotate-6'}`} strokeWidth={2.5} />
                                                            <span>{tab.label}</span>
                                                            <span className={`
                                                                  ml-1 px-2 py-0.5 rounded-md text-xs font-extra-bold transition-all
                                                                  ${isActive ? 'bg-white/20 text-white' : 'bg-slate-100 dark:bg-dark-bg text-slate-600 dark:text-dark-text-secondary group-hover:bg-white dark:group-hover:bg-dark-surface'}
                                                            `}>
                                                                  {tab.count}
                                                            </span>
                                                      </button>
                                                );
                                          })}
                                    </div>
                              </div>
                        </div>
                  </div>

                  {/* Content with 3D Cards */}
                  <div className="flex-1 overflow-y-auto p-8">
                        <div className="max-w-7xl mx-auto">
                              {filteredScenarios.length === 0 ? (
                                    <div className="text-center py-20">
                                          <div className="inline-flex p-6 rounded-3xl bg-gradient-to-br from-slate-100 to-slate-200 dark:from-dark-surface dark:to-dark-elevated shadow-xl mb-6">
                                                <FileCode size={64} className="text-slate-400 dark:text-dark-text-muted" strokeWidth={1.5} />
                                          </div>
                                          <p className="text-slate-500 dark:text-dark-text-secondary text-lg font-medium">
                                                Không có demo nào trong danh mục này
                                          </p>
                                    </div>
                              ) : (
                                    <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
                                          {filteredScenarios.map((scenario, index) => {
                                                const styles = typeStyles[scenario.type] || typeStyles['Stored Procedure'];
                                                return (
                                                      <div
                                                            key={scenario.id}
                                                            onClick={() => navigate(`/scenario/${scenario.id}`)}
                                                            className="group perspective-1000"
                                                            style={{ animationDelay: `${index * 50}ms` }}
                                                      >
                                                            {/* 3D Card Container */}
                                                            <div className={`
                      relative h-full
                      bg-white dark:bg-dark-surface
                      rounded-3xl
                      border border-slate-200/50 dark:border-dark-border/50
                      shadow-xl ${styles.glowColor} ${styles.hoverGlow}
                      hover:shadow-2xl
                      transform-gpu
                      transition-all duration-500 ease-out
                      hover:scale-[1.03] hover:-translate-y-2
                      cursor-pointer
                      overflow-hidden
                      backdrop-blur-sm
                    `}>
                                                                  {/* Gradient Overlay */}
                                                                  <div className={`absolute inset-0 bg-gradient-to-br ${styles.gradient} opacity-50 group-hover:opacity-70 transition-opacity duration-500`}></div>

                                                                  {/* Shine Effect */}
                                                                  <div className="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-500">
                                                                        <div className="absolute inset-0 bg-gradient-to-br from-white/20 via-transparent to-transparent transform -translate-x-full group-hover:translate-x-full transition-transform duration-1000"></div>
                                                                  </div>

                                                                  {/* Content */}
                                                                  <div className="relative p-7 flex flex-col gap-5 h-full">
                                                                        {/* Header */}
                                                                        <div className="flex justify-between items-start">
                                                                              {/* Icon */}
                                                                              <div className={`
                            p-4 rounded-2xl ${styles.iconBg} 
                            text-white shadow-lg
                            transform group-hover:scale-110 group-hover:rotate-6
                            transition-all duration-500
                          `}>
                                                                                    <Database size={28} strokeWidth={2} />
                                                                              </div>

                                                                              {/* Badge */}
                                                                              <span className={`
                            px-3.5 py-1.5 rounded-xl 
                            text-xs font-bold uppercase tracking-wider
                            ${styles.badgeBg} text-white
                            shadow-lg
                            transform group-hover:scale-105
                            transition-all duration-300
                          `}>
                                                                                    {scenario.type}
                                                                              </span>
                                                                        </div>

                                                                        {/* Title & Description */}
                                                                        <div className="flex flex-col gap-3 flex-1 min-h-[7rem]">
                                                                              <h3 className="text-xl font-bold text-slate-900 dark:text-dark-text-primary leading-tight line-clamp-2 group-hover:text-primary-600 dark:group-hover:text-primary-400 transition-colors duration-300">
                                                                                    {scenario.title}
                                                                              </h3>
                                                                              <p className="text-sm text-slate-600 dark:text-dark-text-secondary leading-relaxed line-clamp-3">
                                                                                    {scenario.shortDesc}
                                                                              </p>
                                                                        </div>

                                                                        {/* Footer */}
                                                                        <div className="pt-5 border-t border-slate-200/50 dark:border-dark-border/50">
                                                                              <div className="flex items-center justify-between">
                                                                                    {/* File Path */}
                                                                                    <span className="text-xs font-mono text-slate-400 dark:text-dark-text-muted truncate max-w-[180px]" title={scenario.sqlFile}>
                                                                                          {scenario.sqlFile.split('/').pop()}
                                                                                    </span>

                                                                                    {/* CTA */}
                                                                                    <div className="flex items-center gap-2 text-primary-600 dark:text-primary-400 font-bold text-sm group-hover:gap-3 transition-all duration-300">
                                                                                          <span>Xem</span>
                                                                                          <ArrowRight size={18} strokeWidth={2.5} className="group-hover:translate-x-1 transition-transform duration-300" />
                                                                                    </div>
                                                                              </div>
                                                                        </div>
                                                                  </div>

                                                                  {/* Bottom Glow */}
                                                                  <div className={`absolute bottom-0 left-0 right-0 h-1 bg-gradient-to-r ${styles.iconBg} opacity-0 group-hover:opacity-100 transition-opacity duration-500`}></div>
                                                            </div>
                                                      </div>
                                                );
                                          })}
                                    </div>
                              )}
                        </div>
                  </div>

                  <style>{`
        .perspective-1000 {
          perspective: 1000px;
        }
        .scrollbar-hide::-webkit-scrollbar {
          display: none;
        }
        .scrollbar-hide {
          -ms-overflow-style: none;
          scrollbar-width: none;
        }
      `}</style>
            </div>
      );
};

export default Dashboard;