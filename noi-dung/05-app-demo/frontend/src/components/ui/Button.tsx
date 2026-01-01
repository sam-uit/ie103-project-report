import { RefreshCcw } from 'lucide-react';

// ============================================================================
// UI COMPONENTS (Primitives)
// ============================================================================

interface ButtonProps {
  children: React.ReactNode;
  onClick?: () => void;
  variant?: 'primary' | 'secondary' | 'danger' | 'success' | 'ghost' | 'outline';
  size?: 'xs' | 'sm' | 'md' | 'lg';
  className?: string;
  disabled?: boolean;
  isLoading?: boolean;
  type?: 'button' | 'submit' | 'reset';
  form?: string;
}

export const Button = ({ 
  children, 
  onClick, 
  variant = 'primary', 
  size = 'md', 
  className = '', 
  disabled, 
  isLoading,
  ...props 
}: ButtonProps) => {
  const baseStyle = "rounded-lg font-medium transition-all duration-200 flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed";
  
  const variants = {
    primary: "bg-blue-600 text-white hover:bg-blue-700 shadow-sm",
    secondary: "bg-white text-gray-700 border border-gray-300 hover:bg-gray-50",
    danger: "bg-red-50 text-red-600 hover:bg-red-100 border border-red-100",
    success: "bg-green-600 text-white hover:bg-green-700",
    ghost: "bg-transparent hover:bg-gray-100 text-gray-600",
    outline: "bg-transparent border border-blue-600 text-blue-600 hover:bg-blue-50"
  };
  
  const sizes = { 
    xs: "px-2 py-1 text-xs", 
    sm: "px-3 py-1.5 text-xs", 
    md: "px-4 py-2 text-sm", 
    lg: "px-6 py-3 text-base" 
  };
  
  return (
    <button 
      onClick={onClick} 
      disabled={disabled || isLoading} 
      className={`${baseStyle} ${variants[variant]} ${sizes[size]} ${className}`} 
      {...props}
    >
      {isLoading ? <RefreshCcw className="animate-spin" size={16} /> : children}
    </button>
  );
};

interface BadgeProps {
  status: string;
}

export const Badge = ({ status }: BadgeProps) => {
  const styles: Record<string, string> = {
    AVAILABLE: "bg-green-100 text-green-700 border-green-200", 
    OCCUPIED: "bg-red-100 text-red-700 border-red-200", 
    MAINTENANCE: "bg-gray-100 text-gray-700 border-gray-200",
    PENDING: "bg-yellow-100 text-yellow-700 border-yellow-200", 
    CONFIRMED: "bg-blue-50 text-blue-600 border-blue-200", 
    CHECKED_IN: "bg-purple-100 text-purple-700 border-purple-200", 
    CHECKED_OUT: "bg-gray-100 text-gray-600 border-gray-200", 
    CANCELLED: "bg-red-50 text-red-600 border-red-100", 
    REJECTED: "bg-red-50 text-red-600 border-red-100", 
    REFUNDED: "bg-orange-100 text-orange-700 border-orange-200",
    UNPAID: "bg-gray-100 text-gray-600 border-gray-300", 
    PAID: "bg-green-100 text-green-700 border-green-300",
  };
  
  const labels: Record<string, string> = {
    AVAILABLE: "Còn trống", 
    OCCUPIED: "Đang có khách", 
    MAINTENANCE: "Bảo trì",
    PENDING: "Chờ duyệt", 
    CONFIRMED: "Đã xác nhận", 
    CHECKED_IN: "Đang ở", 
    CHECKED_OUT: "Đã trả phòng", 
    CANCELLED: "Khách hủy", 
    REJECTED: "Từ chối", 
    REFUNDED: "Đã hoàn tiền",
    UNPAID: "Chưa thanh toán", 
    PAID: "Đã thanh toán"
  };
  
  return (
    <span className={`px-2.5 py-0.5 rounded-full text-xs font-semibold border ${styles[status] || 'bg-gray-100'}`}>
      {labels[status] || status}
    </span>
  );
};
