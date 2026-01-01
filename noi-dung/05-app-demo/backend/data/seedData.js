// ============================================================================
// SEED DATA - SQL Server Initial Data
// ============================================================================

export const SEED_USERS = [
  { 
    id: 'U001', 
    name: 'Nguyễn Văn A', 
    email: 'user@demo.com',
    password: 'password123', // Will be hashed
    phone: '0901234567',
    role: 'USER', 
    status: 'ACTIVE'
  },
  { 
    id: 'U002', 
    name: 'Trần Thị B', 
    email: 'guest@demo.com',
    password: 'password123',
    phone: '0912345678',
    role: 'USER',
    status: 'ACTIVE'
  },
  { 
    id: 'A001', 
    name: 'Quản Trị Viên', 
    email: 'admin@demo.com',
    password: 'admin123',
    phone: '0923456789',
    role: 'ADMIN',
    status: 'ACTIVE'
  },
];

export const SEED_ROOMS = [
  {
    id: 'R001', 
    name: 'Phòng Deluxe Hướng Biển', 
    type: 'Deluxe', 
    price: 1500000, 
    capacity: 2,
    amenities: ['WiFi', 'TV', 'AC', 'Minibar', 'Sea View'],
    imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&q=80&w=1000',
    description: 'Phòng sang trọng với ban công nhìn ra biển, đầy đủ tiện nghi.',
    status: 'AVAILABLE'
  },
  {
    id: 'R002', 
    name: 'Phòng Standard Đôi', 
    type: 'Standard', 
    price: 800000, 
    capacity: 2,
    amenities: ['WiFi', 'TV', 'AC'],
    imageUrl: 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&q=80&w=1000',
    description: 'Phòng tiêu chuẩn ấm cúng, phù hợp cho các cặp đôi.',
    status: 'AVAILABLE'
  },
  {
    id: 'R003', 
    name: 'Family Suite Cao Cấp', 
    type: 'Suite', 
    price: 2500000, 
    capacity: 4,
    amenities: ['WiFi', 'TV', 'AC', 'Minibar', 'Kitchen', 'Bathtub'],
    imageUrl: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&q=80&w=1000',
    description: 'Không gian rộng rãi cho gia đình 4 người, có bếp nhỏ.',
    status: 'AVAILABLE'
  },
  {
    id: 'R004', 
    name: 'Phòng Đơn Business', 
    type: 'Standard', 
    price: 600000, 
    capacity: 1,
    amenities: ['WiFi', 'TV', 'AC', 'Work Desk'],
    imageUrl: 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?auto=format&fit=crop&q=80&w=1000',
    description: 'Phòng yên tĩnh, bàn làm việc rộng, wifi tốc độ cao.',
    status: 'AVAILABLE'
  }
];

export const SEED_BOOKINGS = [
  {
    id: 'B001', 
    roomId: 'R002', 
    userId: 'U001',
    checkIn: '2024-01-20', 
    checkOut: '2024-01-22',
    guests: 2,
    totalAmount: 1600000, 
    status: 'PENDING', 
    paymentStatus: 'UNPAID',
    specialRequests: ''
  },
  {
    id: 'B002', 
    roomId: 'R003', 
    userId: 'U002',
    checkIn: '2024-02-01', 
    checkOut: '2024-02-05',
    guests: 4,
    totalAmount: 10000000, 
    status: 'CONFIRMED', 
    paymentStatus: 'PAID',
    specialRequests: 'Cần giường phụ cho trẻ em'
  },
  {
    id: 'B003', 
    roomId: 'R001', 
    userId: 'U001',
    checkIn: '2023-12-10', 
    checkOut: '2023-12-12',
    guests: 2,
    totalAmount: 3000000, 
    status: 'CHECKED_OUT', 
    paymentStatus: 'PAID',
    specialRequests: ''
  }
];

export const SEED_TRANSACTIONS = [
  { 
    id: 'TRX001', 
    bookingId: 'B002', 
    userId: 'U002', 
    amount: 10000000, 
    method: 'CREDIT_CARD', 
    type: 'PAYMENT', 
    status: 'SUCCESS',
    note: 'Thanh toán đặt phòng Family Suite' 
  },
  { 
    id: 'TRX002', 
    bookingId: 'B003', 
    userId: 'U001', 
    amount: 3000000, 
    method: 'MOMO', 
    type: 'PAYMENT', 
    status: 'SUCCESS',
    note: 'Thanh toán đặt phòng Deluxe' 
  }
];
