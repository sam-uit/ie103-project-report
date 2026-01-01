import { useState } from 'react';
import { X, Mail, Lock, LogIn } from 'lucide-react';
import { Button } from '../ui/Button';
import { toast } from '../ui/Toast';
import { AuthService } from '../../services/services';
import { User } from '../../types';
import { validateEmail } from '../../utils/validation';

interface LoginModalProps {
  isOpen: boolean;
  onClose: () => void;
  onLoginSuccess: (user: User) => void;
}

export const LoginModal = ({ isOpen, onClose, onLoginSuccess }: LoginModalProps) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  if (!isOpen) return null;

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();

    console.log('handleLogin called with email:', email, 'password:', password);

    // Validation đơn giản
    if (!email || !password) {
      toast.error('Vui lòng nhập đầy đủ email và mật khẩu');
      return;
    }

    setIsLoading(true);

    try {
      console.log('Calling AuthService.login...');
      const user = await AuthService.login(email, password);
      console.log('AuthService.login returned:', user);
      
      if (!user) {
        toast.error('Email hoặc mật khẩu không đúng');
        setIsLoading(false);
        return;
      }

      toast.success(`Chào mừng ${user.name}!`);
      onLoginSuccess(user);
      handleClose();
    } catch (error) {
      toast.error('Đã có lỗi xảy ra. Vui lòng thử lại.');
      console.error('Login error:', error);
      setIsLoading(false);
    }
  };

  const handleClose = () => {
    setEmail('');
    setPassword('');
    setIsLoading(false);
    onClose();
  };

  const fillDemoCredentials = (type: 'user' | 'admin') => {
    if (type === 'user') {
      setEmail('user@demo.com');
      setPassword('password123');
      toast.info('Đã điền thông tin tài khoản User');
    } else {
      setEmail('admin@demo.com');
      setPassword('admin123');
      toast.info('Đã điền thông tin tài khoản Admin');
    }
  };

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-2xl shadow-2xl max-w-md w-full overflow-hidden">
        {/* Header */}
        <div className="bg-gradient-to-r from-blue-600 to-blue-700 p-6 relative">
          <button
            onClick={handleClose}
            className="absolute top-4 right-4 text-white/80 hover:text-white transition-colors"
          >
            <X size={24} />
          </button>
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 bg-white/20 rounded-full flex items-center justify-center">
              <LogIn className="text-white" size={24} />
            </div>
            <div>
              <h2 className="text-2xl font-bold text-white">Đăng Nhập</h2>
              <p className="text-blue-100 text-sm">Vào hệ thống BookingMS</p>
            </div>
          </div>
        </div>

        {/* Form */}
        <form onSubmit={handleLogin} className="p-6 space-y-5">
          {/* Email Input */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Email
            </label>
            <div className="relative">
              <Mail className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" size={18} />
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                placeholder="user@demo.com hoặc admin@demo.com"
                required
              />
            </div>
          </div>

          {/* Password Input */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Mật khẩu
            </label>
            <div className="relative">
              <Lock className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" size={18} />
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                placeholder="••••••••"
                required
                minLength={6}
              />
            </div>
          </div>

          {/* Demo Info */}
          <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
            <div className="flex items-start gap-3">
              <div className="text-blue-600 mt-0.5">ℹ️</div>
              <div className="flex-1">
                <p className="text-sm font-medium text-blue-900 mb-3">
                  Tài khoản Demo:
                </p>
                <div className="space-y-3">
                  <div className="bg-white rounded-lg p-3 border border-blue-100">
                    <div className="text-xs font-semibold text-gray-700 mb-1">👤 User</div>
                    <div className="text-xs text-gray-600 space-y-1 font-mono">
                      <div>Email: user@demo.com</div>
                      <div>Pass: password123</div>
                    </div>
                    <button
                      type="button"
                      onClick={() => fillDemoCredentials('user')}
                      className="mt-2 text-xs text-blue-600 hover:text-blue-700 font-medium underline"
                    >
                      Điền tự động
                    </button>
                  </div>
                  <div className="bg-white rounded-lg p-3 border border-blue-100">
                    <div className="text-xs font-semibold text-gray-700 mb-1">🛡️ Admin</div>
                    <div className="text-xs text-gray-600 space-y-1 font-mono">
                      <div>Email: admin@demo.com</div>
                      <div>Pass: admin123</div>
                    </div>
                    <button
                      type="button"
                      onClick={() => fillDemoCredentials('admin')}
                      className="mt-2 text-xs text-blue-600 hover:text-blue-700 font-medium underline"
                    >
                      Điền tự động
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Action Buttons */}
          <div className="flex gap-3 pt-2">
            <Button
              type="button"
              variant="outline"
              onClick={handleClose}
              className="flex-1"
              disabled={isLoading}
            >
              Hủy
            </Button>
            <Button
              type="submit"
              className="flex-1"
              disabled={isLoading}
            >
              {isLoading ? 'Đang đăng nhập...' : 'Đăng nhập'}
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
};
