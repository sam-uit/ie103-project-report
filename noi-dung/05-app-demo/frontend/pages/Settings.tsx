import React, { useState, useEffect } from 'react';
import { useConfig } from '../contexts/ConfigContext';
import { api, getBaseUrl } from '../services/api';
import { Server, Save, Activity, AlertCircle, CheckCircle2, Globe, Database } from 'lucide-react';

const Settings: React.FC = () => {
  const { checkBackendStatus, backendOnline } = useConfig();
  
  // State for the form
  const [url, setUrl] = useState('');
  const [isTestLoading, setIsTestLoading] = useState(false);
  const [testStatus, setTestStatus] = useState<'idle' | 'success' | 'error'>('idle');
  const [message, setMessage] = useState('');

  // Load current setting on mount
  useEffect(() => {
    setUrl(getBaseUrl());
  }, []);

  const handleUrlChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setUrl(e.target.value);
    setTestStatus('idle');
    setMessage('');
  };

  const handleTestConnection = async () => {
    if (!url) return;
    setIsTestLoading(true);
    setTestStatus('idle');
    setMessage('');

    // Try to check health on the NEW url provided in input
    const isOk = await api.checkHealth(url);

    setIsTestLoading(false);
    if (isOk) {
      setTestStatus('success');
      setMessage('Kết nối thành công! Hệ thống tìm thấy endpoint /health.');
    } else {
      setTestStatus('error');
      setMessage('Không thể kết nối. Vui lòng kiểm tra URL hoặc trạng thái Server.');
    }
  };

  const handleSave = () => {
    if (!url) {
        setMessage('Vui lòng nhập URL hợp lệ');
        setTestStatus('error');
        return;
    }

    // Save to localStorage
    localStorage.setItem('app_api_base_url', url);
    
    // Trigger global status update
    checkBackendStatus();

    // Feedback
    setMessage('Đã lưu cấu hình. Hệ thống sẽ sử dụng URL mới.');
    setTestStatus('success');
  };

  const handleResetDefault = () => {
    const def = 'http://localhost:3001/api';
    setUrl(def);
    setTestStatus('idle');
    setMessage('Đã khôi phục mặc định (chưa lưu). Nhấn Lưu để áp dụng.');
  };

  return (
    <div className="p-8 h-full overflow-y-auto bg-slate-50 dark:bg-dark-bg">
      <div className="max-w-3xl mx-auto space-y-8">
        
        {/* Header */}
        <div className="flex flex-col gap-2 pb-6 border-b border-slate-200 dark:border-dark-border">
          <h1 className="text-3xl font-bold text-slate-900 dark:text-white tracking-tight flex items-center gap-3">
            <Server className="text-primary-600" size={32} />
            Cài Đặt Hệ Thống
          </h1>
          <p className="text-slate-500 dark:text-dark-text-secondary text-lg">
            Cấu hình kết nối Backend và các tùy chọn môi trường.
          </p>
        </div>

        {/* Connection Status Card */}
        <div className="bg-white dark:bg-dark-surface border border-slate-200 dark:border-dark-border rounded-xl shadow-sm overflow-hidden">
            <div className="px-6 py-4 border-b border-slate-200 dark:border-dark-border bg-slate-50 dark:bg-dark-elevated/50 flex justify-between items-center">
                <h3 className="font-bold text-slate-800 dark:text-white flex items-center gap-2">
                    <Activity size={18} className="text-blue-500"/> Trạng Thái Kết Nối Hiện Tại
                </h3>
                <span className={`px-3 py-1 rounded-full text-xs font-bold border ${
                    backendOnline 
                    ? 'bg-emerald-100 text-emerald-700 border-emerald-200 dark:bg-emerald-900/30 dark:text-emerald-400' 
                    : 'bg-red-100 text-red-700 border-red-200 dark:bg-red-900/30 dark:text-accent-orange-400'
                }`}>
                    {backendOnline ? 'ONLINE' : 'OFFLINE'}
                </span>
            </div>
            <div className="p-6">
                <p className="text-sm text-slate-600 dark:text-dark-text-secondary">
                    Hệ thống đang sử dụng API tại: <code className="bg-slate-100 dark:bg-dark-hover px-2 py-1 rounded font-mono text-primary-600 dark:text-primary-400">{getBaseUrl()}</code>
                </p>
                {!backendOnline && (
                    <div className="mt-4 p-3 bg-amber-50 dark:bg-amber-900/10 border border-amber-200 dark:border-amber-800 rounded text-sm text-amber-800 dark:text-amber-400 flex items-start gap-2">
                        <AlertCircle size={16} className="mt-0.5 flex-shrink-0"/>
                        <div>
                            <strong>Chế độ Offline:</strong> Hệ thống đang sử dụng dữ liệu giả lập (Mock Data). 
                            Các thao tác thực thi SQL sẽ không tác động đến cơ sở dữ liệu thực tế.
                        </div>
                    </div>
                )}
            </div>
        </div>

        {/* Configuration Form */}
        <div className="bg-white dark:bg-dark-surface border border-slate-200 dark:border-dark-border rounded-xl shadow-sm p-6 space-y-6">
            <h3 className="font-bold text-lg text-slate-900 dark:text-white flex items-center gap-2">
                <Database size={20} className="text-slate-400"/> Cấu Hình Backend API
            </h3>

            <div className="space-y-3">
                <label className="block text-sm font-medium text-slate-700 dark:text-dark-text-secondary">
                    Backend Base URL
                </label>
                <div className="relative group">
                    <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <Globe size={16} className="text-slate-400 group-focus-within:text-primary-500 transition-colors" />
                    </div>
                    <input
                        type="text"
                        value={url}
                        onChange={handleUrlChange}
                        placeholder="http://localhost:3001/api"
                        className="block w-full pl-10 pr-3 py-2.5 border border-slate-300 dark:border-dark-border rounded-lg bg-slate-50 dark:bg-black/20 text-slate-900 dark:text-dark-text-primary focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all font-mono text-sm"
                    />
                </div>
                <p className="text-xs text-slate-500 dark:text-dark-text-muted">
                    Địa chỉ máy chủ Node.js đang chạy. Mặc định là cổng 5000.
                </p>
            </div>

            {/* Actions */}
            <div className="flex flex-wrap items-center justify-between gap-4 pt-4 border-t border-slate-100 dark:border-dark-border">
                 <button 
                    onClick={handleResetDefault}
                    className="text-sm text-slate-500 hover:text-slate-700 dark:hover:text-dark-text-secondary underline underline-offset-2"
                 >
                    Khôi phục mặc định
                 </button>

                 <div className="flex gap-3">
                    <button
                        onClick={handleTestConnection}
                        disabled={isTestLoading || !url}
                        className={`px-4 py-2 rounded-lg text-sm font-medium border transition-colors flex items-center gap-2
                            ${isTestLoading 
                                ? 'bg-slate-100 text-slate-400 border-slate-200 cursor-wait' 
                                : 'bg-white hover:bg-slate-50 text-slate-700 border-slate-300 dark:bg-dark-elevated dark:border-dark-border dark:text-dark-text-primary dark:hover:bg-dark-hover'
                            }
                        `}
                    >
                        {isTestLoading ? <Activity size={16} className="animate-spin"/> : <Activity size={16}/>}
                        Test Connection
                    </button>

                    <button
                        onClick={handleSave}
                        className="px-6 py-2 rounded-lg text-sm font-bold text-white bg-primary-600 hover:bg-primary-700 shadow-md hover:shadow-lg transition-all flex items-center gap-2 active:scale-95"
                    >
                        <Save size={16}/> Lưu Cấu Hình
                    </button>
                 </div>
            </div>

            {/* Test Result Message */}
            {(message || testStatus !== 'idle') && (
                <div className={`mt-4 p-3 rounded-lg text-sm flex items-center gap-2 animate-in fade-in slide-in-from-top-2
                    ${testStatus === 'success' ? 'bg-emerald-50 text-emerald-700 dark:bg-emerald-900/20 dark:text-emerald-400' : ''}
                    ${testStatus === 'error' ? 'bg-red-50 text-red-700 dark:bg-red-900/20 dark:text-accent-orange-400' : ''}
                    ${testStatus === 'idle' && message ? 'bg-slate-100 text-slate-600 dark:bg-dark-elevated dark:text-dark-text-secondary' : ''}
                `}>
                    {testStatus === 'success' && <CheckCircle2 size={16} />}
                    {testStatus === 'error' && <AlertCircle size={16} />}
                    {message}
                </div>
            )}
        </div>
      </div>
    </div>
  );
};

export default Settings;