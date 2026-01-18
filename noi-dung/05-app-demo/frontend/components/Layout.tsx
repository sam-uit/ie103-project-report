import React, { useState } from 'react';
import { NavLink, useLocation } from 'react-router-dom';
import { useConfig } from '../contexts/ConfigContext';
import {
  LayoutDashboard,
  Database,
  FileText,
  Users,
  Settings,
  RefreshCw,
  ChevronLeft,
  ChevronRight,
  ChevronDown,
  ChevronUp,
  Box,
  Zap,
  Code,
  MousePointer,
  Sparkles
} from 'lucide-react';

interface LayoutProps {
  children: React.ReactNode;
}

const Layout: React.FC<LayoutProps> = ({ children }) => {
  const { refreshConfig, backendOnline, checkBackendStatus, loading } = useConfig();
  const [isCollapsed, setIsCollapsed] = useState(false);

  return (
    <div className="flex h-screen w-full bg-slate-100 dark:bg-dark-bg text-slate-900 dark:text-dark-text-primary">
      {/* Modern Sidebar with Glassmorphism */}
      <aside className={`flex-shrink-0 flex flex-col relative transition-all duration-300 ${isCollapsed ? 'w-20' : 'w-64'}`}>
        {/* Gradient Background */}
        <div className="absolute inset-0 bg-gradient-to-br from-primary-600/5 via-accent-purple-600/5 to-accent-cyan-600/5 dark:from-primary-500/3 dark:via-accent-purple-500/3 dark:to-accent-cyan-500/3"></div>

        {/* Main Sidebar Content */}
        <div className="relative flex flex-col h-full backdrop-blur-xl bg-white/90 dark:bg-dark-surface/90 border-r border-slate-200/50 dark:border-dark-border/50 shadow-2xl">

          {/* Header */}
          <div className="h-20 flex items-center justify-center px-4 border-b border-slate-200/50 dark:border-dark-border/50 bg-gradient-to-r from-white/50 to-transparent dark:from-dark-elevated/50 dark:to-transparent">
            {!isCollapsed && (
              <div className="flex items-center gap-3 group">
                <div className="relative">
                  {/* Glow Effect */}
                  <div className="absolute inset-0 bg-gradient-to-br from-primary-500 to-primary-600 rounded-xl blur-md opacity-50 group-hover:opacity-75 transition-opacity"></div>
                  {/* Icon Container */}
                  <div className="relative p-2.5 rounded-xl bg-gradient-to-br from-primary-500 to-primary-600 shadow-lg">
                    <Database size={24} className="text-white" strokeWidth={2.5} />
                  </div>
                </div>
                <div>
                  <h1 className="text-lg font-bold bg-gradient-to-r from-slate-900 to-slate-700 dark:from-dark-text-primary dark:to-dark-text-secondary bg-clip-text text-transparent">
                    Hệ Thống BMS
                  </h1>
                  <p className="text-xs text-slate-500 dark:text-dark-text-muted">Management System</p>
                </div>
              </div>
            )}
            {isCollapsed && (
              <div className="relative">
                <div className="absolute inset-0 bg-gradient-to-br from-primary-500 to-primary-600 rounded-xl blur-md opacity-50"></div>
                <div className="relative p-2.5 rounded-xl bg-gradient-to-br from-primary-500 to-primary-600 shadow-lg">
                  <Database size={24} className="text-white" strokeWidth={2.5} />
                </div>
              </div>
            )}
          </div>

          {/* Navigation */}
          <nav className="flex-1 overflow-y-auto px-3 space-y-0.5">
            <NavItem to="/" icon={<LayoutDashboard size={20} />} label="Tổng quan" isCollapsed={isCollapsed} />

            {/* SQL Menu - Always Expanded */}
            <NavItem
              to="/scenarios"
              icon={<Database size={20} />}
              label="Xử lý thông tin "
              isCollapsed={isCollapsed}
              badge="14"
            />

            {/* Submenu - Always Visible */}
            {!isCollapsed && (
              <div className="ml-2 space-y-0.5 mt-0.5 pl-4 border-l-2 border-slate-200 dark:border-dark-border">
                <SubNavItem
                  to="/scenarios?type=Stored Procedure"
                  icon={<Box size={16} />}
                  label="Stored Procedure"
                  count={5}
                  color="purple"
                />
                <SubNavItem
                  to="/scenarios?type=Trigger"
                  icon={<Zap size={16} />}
                  label="Trigger"
                  count={5}
                  color="yellow"
                />
                <SubNavItem
                  to="/scenarios?type=Function"
                  icon={<Code size={16} />}
                  label="Function"
                  count={3}
                  color="green"
                />
                <SubNavItem
                  to="/scenarios?type=Cursor"
                  icon={<MousePointer size={16} />}
                  label="Cursor"
                  count={2}
                  color="purple"
                />
              </div>
            )}

            <NavItem to="/reports" icon={<FileText size={20} />} label="Trình bày thông tin" isCollapsed={isCollapsed} />
            <NavItem to="/logs" icon={<Users size={20} />} label="Thành Viên Nhóm" isCollapsed={isCollapsed} />
          </nav>

          {/* System Status & Actions */}
          <div className="p-4 space-y-3 border-t border-slate-200/50 dark:border-dark-border/50 bg-gradient-to-t from-slate-50/50 to-transparent dark:from-dark-elevated/30 dark:to-transparent">
            {/* Toggle Button */}
            <button
              onClick={() => setIsCollapsed(!isCollapsed)}
              className="w-full p-2.5 rounded-xl border border-slate-200 dark:border-dark-border bg-white/80 dark:bg-dark-elevated/80 backdrop-blur-sm hover:border-primary-500 dark:hover:border-primary-500 hover:bg-primary-50 dark:hover:bg-primary-500/10 text-slate-600 dark:text-dark-text-secondary hover:text-primary-600 dark:hover:text-primary-400 transition-all shadow-sm hover:shadow-md flex items-center justify-center gap-2 text-sm font-semibold"
              title={isCollapsed ? "Mở sidebar" : "Đóng sidebar"}
            >
              {isCollapsed ? (
                <>
                  <ChevronRight size={18} strokeWidth={2.5} />
                </>
              ) : (
                <>
                  <ChevronLeft size={18} strokeWidth={2.5} />
                  <span>Thu gọn</span>
                </>
              )}
            </button>

            {/* Reload Config Button */}
            <button
              onClick={() => refreshConfig()}
              disabled={loading}
              title="Tải lại file cấu hình JSON"
              className={`w-full group flex items-center ${isCollapsed ? 'justify-center' : 'justify-center gap-2.5'} px-4 py-3 rounded-xl border border-slate-200 dark:border-dark-border hover:border-accent-purple-500 dark:hover:border-accent-purple-500 bg-white/80 dark:bg-dark-elevated/80 backdrop-blur-sm hover:bg-accent-purple-50 dark:hover:bg-accent-purple-500/10 text-slate-600 dark:text-dark-text-secondary hover:text-accent-purple-600 dark:hover:text-accent-purple-400 text-sm font-semibold transition-all duration-300 disabled:opacity-50 shadow-sm hover:shadow-md`}
            >
              <RefreshCw size={16} className={`${loading ? 'animate-spin' : 'group-hover:rotate-180 transition-transform duration-500'}`} strokeWidth={2.5} />
              {!isCollapsed && <span>Reload Config</span>}
            </button>

            {/* Backend Status */}
            <div
              className={`w-full flex items-center ${isCollapsed ? 'justify-center' : 'justify-center gap-3'} px-4 py-3 rounded-xl border backdrop-blur-sm shadow-sm hover:shadow-md transition-all duration-300 cursor-pointer ${backendOnline
                ? 'bg-gradient-to-r from-accent-green-50 to-emerald-50 border-accent-green-300 text-accent-green-700 dark:from-accent-green-500/10 dark:to-emerald-500/10 dark:border-accent-green-500 dark:text-accent-green-400'
                : 'bg-gradient-to-r from-accent-pink-50 to-red-50 border-accent-pink-300 text-accent-pink-700 dark:from-accent-pink-500/10 dark:to-red-500/10 dark:border-accent-pink-500 dark:text-accent-pink-400'
                }`}
              title={backendOnline ? "Kết nối Backend thành công" : "Không kết nối được Backend (Mock Mode)"}
              onClick={checkBackendStatus}
              role="button"
            >
              <div className="relative flex h-2.5 w-2.5">
                <span className={`animate-ping absolute inline-flex h-full w-full rounded-full opacity-75 ${backendOnline ? 'bg-accent-green-500' : 'bg-accent-pink-500'}`}></span>
                <span className={`relative inline-flex rounded-full h-2.5 w-2.5 ${backendOnline ? 'bg-accent-green-600' : 'bg-accent-pink-600'}`}></span>
              </div>
              {!isCollapsed && (
                <span className="text-xs font-bold tracking-wider uppercase">
                  {backendOnline ? 'SYSTEM ONLINE' : 'OFFLINE MODE'}
                </span>
              )}
            </div>
          </div>

          {/* Settings */}
          <div className="p-3 border-t border-slate-200/50 dark:border-dark-border/50 bg-gradient-to-t from-slate-50/50 to-transparent dark:from-dark-elevated/30 dark:to-transparent">
            <NavItem to="/settings" icon={<Settings size={20} />} label="Cài đặt" isCollapsed={isCollapsed} />
          </div>
        </div>
      </aside>

      {/* Main Content */}
      <main className="flex-1 flex flex-col h-full overflow-hidden">
        <div className="flex-1 overflow-hidden relative">
          {children}
        </div>
      </main>
    </div>
  );
};

const NavItem: React.FC<{ to: string; icon: React.ReactNode; label: string; isCollapsed?: boolean; badge?: string }> = ({ to, icon, label, isCollapsed = false, badge }) => (
  <NavLink
    to={to}
    className={({ isActive }) => `
      group relative flex items-center ${isCollapsed ? 'justify-center' : 'gap-3'}
      px-4 py-3.5 rounded-xl
      transition-all duration-300
      overflow-hidden
      ${isActive
        ? 'bg-gradient-to-r from-primary-500 to-primary-600 text-white font-bold shadow-lg shadow-primary-500/30 scale-[1.02]'
        : 'text-slate-600 dark:text-dark-text-secondary hover:bg-white dark:hover:bg-dark-elevated hover:text-slate-900 dark:hover:text-dark-text-primary hover:shadow-md border border-transparent hover:border-slate-200 dark:hover:border-dark-border'
      }
    `}
    title={isCollapsed ? label : undefined}
  >
    {({ isActive }) => (
      <>
        {/* Active Indicator */}
        {isActive && !isCollapsed && (
          <div className="absolute left-0 top-1/2 -translate-y-1/2 w-1 h-8 bg-white rounded-r-full shadow-lg"></div>
        )}

        {/* Icon with Animation */}
        <div className={`transition-all duration-300 ${isActive ? 'scale-110' : 'group-hover:scale-110 group-hover:rotate-3'}`}>
          {icon}
        </div>

        {/* Label */}
        {!isCollapsed && (
          <span className="text-sm flex-1">{label}</span>
        )}

        {/* Badge */}
        {!isCollapsed && badge && (
          <span className="px-2 py-0.5 rounded-md text-xs font-bold bg-accent-orange-500 text-white shadow-md shadow-orange-500/50">
            {badge}
          </span>
        )}

        {/* Hover Shine Effect */}
        {!isActive && (
          <div className="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-500">
            <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/10 to-transparent transform -translate-x-full group-hover:translate-x-full transition-transform duration-1000"></div>
          </div>
        )}
      </>
    )}
  </NavLink>
);

// NavItemWithSubmenu for expandable menu items
const NavItemWithSubmenu: React.FC<{
  icon: React.ReactNode;
  label: string;
  isCollapsed?: boolean;
  badge?: string;
  isOpen: boolean;
  onClick: () => void;
}> = ({ icon, label, isCollapsed = false, badge, isOpen, onClick }) => (
  <button
    onClick={onClick}
    className={`
      group relative flex items-center ${isCollapsed ? 'justify-center' : 'gap-3'}
      w-full px-4 py-3.5 rounded-xl
      transition-all duration-300
      overflow-hidden
      text-slate-600 dark:text-dark-text-secondary hover:bg-white dark:hover:bg-dark-elevated hover:text-slate-900 dark:hover:text-dark-text-primary hover:shadow-md border border-transparent hover:border-slate-200 dark:hover:border-dark-border
    `}
    title={isCollapsed ? label : undefined}
  >
    {/* Icon with Animation */}
    <div className={`transition-all duration-300 group-hover:scale-110 group-hover:rotate-3`}>
      {icon}
    </div>

    {/* Label */}
    {!isCollapsed && (
      <span className="text-sm flex-1 text-left">{label}</span>
    )}

    {/* Badge */}
    {!isCollapsed && badge && (
      <span className="px-2 py-0.5 rounded-md text-xs font-bold bg-accent-orange-500 text-white animate-pulse">
        {badge}
      </span>
    )}

    {/* Chevron Icon */}
    {!isCollapsed && (
      <div className={`transition-transform duration-300 ${isOpen ? 'rotate-180' : ''}`}>
        <ChevronDown size={16} strokeWidth={2.5} />
      </div>
    )}

    {/* Hover Shine Effect */}
    <div className="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-500">
      <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/10 to-transparent transform -translate-x-full group-hover:translate-x-full transition-transform duration-1000"></div>
    </div>
  </button>
);

// SubNavItem for submenu items
const SubNavItem: React.FC<{
  to: string;
  icon: React.ReactNode;
  label: string;
  count?: number;
  color?: 'orange' | 'yellow' | 'green' | 'purple' | 'pink' | 'red';
}> = ({ to, icon, label, count, color = 'orange' }) => {
  const location = useLocation();
  // Decode URLs to handle %20 vs space character mismatch
  const currentUrl = decodeURIComponent(location.pathname + location.search);
  const targetUrl = decodeURIComponent(to);
  const isActive = currentUrl === targetUrl;

  // Color mapping for count badges
  const colorClasses = {
    orange: 'bg-orange-500 text-white shadow-md shadow-orange-500/50',
    yellow: 'bg-yellow-500 text-slate-900 shadow-md shadow-yellow-500/50',
    green: 'bg-green-500 text-white shadow-md shadow-green-500/50',
    purple: 'bg-purple-500 text-white shadow-md shadow-purple-500/50'
  };

  return (
    <NavLink
      to={to}
      className={`
        group relative flex items-center gap-2.5
        pl-6 pr-3 py-2 rounded-lg
        transition-all duration-300
        text-xs
        ${isActive
          ? 'bg-gradient-to-r from-primary-500 to-primary-600 text-white font-semibold shadow-md'
          : 'text-slate-600 dark:text-dark-text-secondary hover:bg-slate-100 dark:hover:bg-dark-elevated hover:text-slate-900 dark:hover:text-dark-text-primary'
        }
      `}
    >
      {/* Icon */}
      <div className={`transition-transform duration-300 ${isActive ? 'scale-110' : 'group-hover:scale-110'}`}>
        {icon}
      </div>

      {/* Label */}
      <span className="flex-1">{label}</span>

      {/* Count Badge */}
      {count !== undefined && (
        <span className={`px-1.5 py-0.5 rounded text-xs font-bold transition-colors ${colorClasses[color]}`}>
          {count}
        </span>
      )}
    </NavLink>
  );
};

export default Layout;