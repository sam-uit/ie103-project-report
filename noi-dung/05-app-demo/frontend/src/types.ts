// ============================================================================
// TYPE DEFINITIONS
// ============================================================================

export type UserRole = 'GUEST' | 'USER' | 'ADMIN' | 'STAFF';
export type BookingStatus = 'PENDING' | 'CONFIRMED' | 'CHECKED_IN' | 'CHECKED_OUT' | 'CANCELLED' | 'REFUNDED' | 'REJECTED';
export type PaymentStatus = 'UNPAID' | 'PAID' | 'REFUNDED';
export type PaymentMethod = 'CREDIT_CARD' | 'MOMO' | 'BANK_TRANSFER' | 'CASH';
export type TransactionType = 'PAYMENT' | 'REFUND';

export interface User {
  id: string;
  name: string;
  email: string;
  role: UserRole;
  avatar?: string;
}

export interface Room {
  id: string;
  name: string;
  type: string;
  price: number;
  capacity: number;
  description: string;
  image: string;
  status: 'AVAILABLE' | 'MAINTENANCE' | 'OCCUPIED';
}

export interface Transaction {
  id: string;
  bookingId: string;
  userId: string;
  amount: number;
  method: PaymentMethod;
  type: TransactionType;
  status: 'SUCCESS' | 'FAILED';
  createdAt: string;
  note?: string;
}

export interface Booking {
  id: string;
  roomId: string;
  userId: string;
  checkIn: string;
  checkOut: string;
  totalPrice: number;
  status: BookingStatus;
  paymentStatus: PaymentStatus;
  createdAt: string;
  guestName?: string;
  notes?: string;
}
