// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

export const formatCurrency = (amount: number): string => {
  return new Intl.NumberFormat('vi-VN', { 
    style: 'currency', 
    currency: 'VND' 
  }).format(amount);
};

/**
 * Format date to Vietnamese format
 * @param date - Date string or Date object
 * @param format - 'short' (31/12/2025) | 'medium' (31 Th12 2025) | 'long' (31 Tháng 12, 2025) | 'full' (Thứ Ba, 31 Tháng 12, 2025)
 */
export const formatDate = (
  date: string | Date | null | undefined, 
  format: 'short' | 'medium' | 'long' | 'full' = 'short'
): string => {
  if (!date) return 'N/A';
  
  const d = typeof date === 'string' ? new Date(date) : date;
  
  // Check if date is valid
  if (isNaN(d.getTime())) return 'N/A';

  const day = d.getDate();
  const month = d.getMonth() + 1;
  const year = d.getFullYear();

  const monthNames = [
    'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
    'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'
  ];

  const monthNamesShort = [
    'Th1', 'Th2', 'Th3', 'Th4', 'Th5', 'Th6',
    'Th7', 'Th8', 'Th9', 'Th10', 'Th11', 'Th12'
  ];

  const dayNames = [
    'Chủ Nhật', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 
    'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy'
  ];

  switch (format) {
    case 'short':
      return `${day.toString().padStart(2, '0')}/${month.toString().padStart(2, '0')}/${year}`;
    
    case 'medium':
      return `${day} ${monthNamesShort[month - 1]} ${year}`;
    
    case 'long':
      return `${day} ${monthNames[month - 1]}, ${year}`;
    
    case 'full':
      return `${dayNames[d.getDay()]}, ${day} ${monthNames[month - 1]}, ${year}`;
    
    default:
      return `${day.toString().padStart(2, '0')}/${month.toString().padStart(2, '0')}/${year}`;
  }
};

/**
 * Format datetime to Vietnamese format with time
 */
export const formatDateTime = (date: string | Date | null | undefined): string => {
  if (!date) return 'N/A';
  
  const d = typeof date === 'string' ? new Date(date) : date;
  
  if (isNaN(d.getTime())) return 'N/A';

  const hours = d.getHours().toString().padStart(2, '0');
  const minutes = d.getMinutes().toString().padStart(2, '0');
  
  return `${formatDate(d, 'short')} ${hours}:${minutes}`;
};

/**
 * Get relative time (e.g., "2 ngày trước", "3 giờ trước")
 */
export const getRelativeTime = (date: string | Date | null | undefined): string => {
  if (!date) return 'N/A';
  
  const d = typeof date === 'string' ? new Date(date) : date;
  
  if (isNaN(d.getTime())) return 'N/A';

  const now = new Date();
  const diffMs = now.getTime() - d.getTime();
  const diffSec = Math.floor(diffMs / 1000);
  const diffMin = Math.floor(diffSec / 60);
  const diffHour = Math.floor(diffMin / 60);
  const diffDay = Math.floor(diffHour / 24);
  const diffMonth = Math.floor(diffDay / 30);
  const diffYear = Math.floor(diffDay / 365);

  if (diffSec < 60) return 'Vừa xong';
  if (diffMin < 60) return `${diffMin} phút trước`;
  if (diffHour < 24) return `${diffHour} giờ trước`;
  if (diffDay < 30) return `${diffDay} ngày trước`;
  if (diffMonth < 12) return `${diffMonth} tháng trước`;
  return `${diffYear} năm trước`;
};

