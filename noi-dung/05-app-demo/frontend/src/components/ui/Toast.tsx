import { useState, useEffect } from 'react';
import { X, CheckCircle, AlertCircle, Info, AlertTriangle } from 'lucide-react';

type ToastType = 'success' | 'error' | 'info' | 'warning';

interface Toast {
  id: string;
  message: string;
  type: ToastType;
}

interface ToastContextType {
  showToast: (message: string, type?: ToastType) => void;
}

let toastCallback: ((message: string, type: ToastType) => void) | null = null;

export const toast = {
  success: (message: string) => toastCallback?.(message, 'success'),
  error: (message: string) => toastCallback?.(message, 'error'),
  info: (message: string) => toastCallback?.(message, 'info'),
  warning: (message: string) => toastCallback?.(message, 'warning'),
};

export const ToastProvider = ({ children }: { children: React.ReactNode }) => {
  const [toasts, setToasts] = useState<Toast[]>([]);

  const showToast = (message: string, type: ToastType = 'info') => {
    const id = Date.now().toString();
    setToasts(prev => [...prev, { id, message, type }]);
    
    setTimeout(() => {
      setToasts(prev => prev.filter(t => t.id !== id));
    }, 4000);
  };

  useEffect(() => {
    toastCallback = showToast;
    return () => {
      toastCallback = null;
    };
  }, []);

  const removeToast = (id: string) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  const getIcon = (type: ToastType) => {
    switch (type) {
      case 'success': return <CheckCircle size={20} />;
      case 'error': return <AlertCircle size={20} />;
      case 'warning': return <AlertTriangle size={20} />;
      case 'info': return <Info size={20} />;
    }
  };

  const getStyles = (type: ToastType) => {
    switch (type) {
      case 'success': return 'bg-green-50 text-green-800 border-green-200';
      case 'error': return 'bg-red-50 text-red-800 border-red-200';
      case 'warning': return 'bg-yellow-50 text-yellow-800 border-yellow-200';
      case 'info': return 'bg-blue-50 text-blue-800 border-blue-200';
    }
  };

  return (
    <>
      {children}
      <div className="fixed top-4 right-4 z-[9999] space-y-2 max-w-md">
        {toasts.map(toast => (
          <div
            key={toast.id}
            className={`flex items-center gap-3 p-4 rounded-lg border shadow-lg animate-in slide-in-from-right ${getStyles(toast.type)}`}
          >
            <div className="flex-shrink-0">
              {getIcon(toast.type)}
            </div>
            <p className="flex-1 text-sm font-medium">{toast.message}</p>
            <button
              onClick={() => removeToast(toast.id)}
              className="flex-shrink-0 hover:opacity-70 transition-opacity"
            >
              <X size={16} />
            </button>
          </div>
        ))}
      </div>
    </>
  );
};
