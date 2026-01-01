export const validateEmail = (email: string): boolean => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

export const validateDateRange = (checkIn: string, checkOut: string): { 
  valid: boolean; 
  error?: string 
} => {
  if (!checkIn || !checkOut) {
    return { valid: false, error: 'Vui lòng chọn đầy đủ ngày nhận và trả phòng' };
  }

  const start = new Date(checkIn);
  const end = new Date(checkOut);
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  if (start < today) {
    return { valid: false, error: 'Ngày nhận phòng không thể là ngày trong quá khứ' };
  }

  if (start >= end) {
    return { valid: false, error: 'Ngày trả phòng phải sau ngày nhận phòng' };
  }

  const diffTime = end.getTime() - start.getTime();
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

  if (diffDays > 30) {
    return { valid: false, error: 'Không thể đặt phòng quá 30 ngày' };
  }

  return { valid: true };
};

export const validatePrice = (price: number): { valid: boolean; error?: string } => {
  if (price <= 0) {
    return { valid: false, error: 'Giá phòng phải lớn hơn 0' };
  }
  if (price > 100000000) {
    return { valid: false, error: 'Giá phòng không hợp lệ' };
  }
  return { valid: true };
};

export const validateCapacity = (capacity: number): { valid: boolean; error?: string } => {
  if (capacity <= 0 || capacity > 20) {
    return { valid: false, error: 'Sức chứa phải từ 1-20 người' };
  }
  return { valid: true };
};
