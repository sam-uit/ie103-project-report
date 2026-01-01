// ============================================================================
// SERVICE LAYER - CENTRAL EXPORT
// ============================================================================
// Tất cả services đã được refactor để gọi API thật thông qua backend
// Không còn sử dụng mock data

export { RoomService } from './roomService.api';
export { BookingService } from './bookingService.api';
export { TransactionService } from './transactionService.api';
export { AuthService } from './authService.api';

