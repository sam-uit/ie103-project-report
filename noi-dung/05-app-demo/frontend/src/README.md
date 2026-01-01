# BookingMS - Cấu trúc dự án sau khi refactor

## 📁 Cấu trúc thư mục

```
src/
├── types.ts                      # Type definitions và interfaces
├── utils/
│   └── helpers.ts                # Utility functions (formatCurrency, etc.)
├── data/
│   └── mockData.ts               # Mock data cho demo
├── services/
│   └── services.ts               # Service layer (API calls)
├── components/
│   ├── ui/
│   │   ├── Button.tsx            # Button & Badge components
│   │   └── index.ts              # UI components exports
│   ├── modals/
│   │   ├── PaymentModals.tsx     # Payment & Refund modals
│   │   └── RoomFormModal.tsx     # Room form modal
│   ├── admin/
│   │   ├── AdminDashboard.tsx    # Admin dashboard component
│   │   ├── AdminBookingManager.tsx   # Booking management
│   │   └── AdminTransactionManager.tsx  # Transaction management
│   └── user/
│       └── UserBookings.tsx      # User booking components
└── App.tsx                       # Main app component
```

## 🔧 Các module chính

### 1. **Types** (`src/types.ts`)
- Định nghĩa tất cả các type và interface
- UserRole, BookingStatus, PaymentStatus, PaymentMethod
- User, Room, Booking, Transaction interfaces

### 2. **Utils** (`src/utils/helpers.ts`)
- Các hàm tiện ích
- `formatCurrency()` - Format số tiền theo định dạng VNĐ

### 3. **Data** (`src/data/mockData.ts`)
- Mock data cho demo
- MOCK_ROOMS, MOCK_USERS, MOCK_BOOKINGS, MOCK_TRANSACTIONS

### 4. **Services** (`src/services/services.ts`)
- Service layer xử lý logic nghiệp vụ
- RoomService - Quản lý phòng
- BookingService - Quản lý đặt phòng
- TransactionService - Quản lý giao dịch
- AuthService - Xác thực người dùng

### 5. **UI Components** (`src/components/ui/`)
- Button component với các variants
- Badge component cho status display

### 6. **Modals** (`src/components/modals/`)
- PaymentGatewayModal - Cổng thanh toán
- RefundConfirmModal - Xác nhận hoàn tiền
- RoomFormModal - Form thêm/sửa phòng

### 7. **Admin Components** (`src/components/admin/`)
- AdminDashboard - Trang tổng quan admin
- AdminBookingManager - Quản lý đơn đặt phòng
- AdminTransactionManager - Quản lý giao dịch

### 8. **User Components** (`src/components/user/`)
- BookingModal - Modal đặt phòng
- UserBookingsList - Danh sách đơn đặt của user

## 🚀 Ưu điểm của cấu trúc mới

1. **Dễ bảo trì**: Mỗi component/module có trách nhiệm riêng
2. **Tái sử dụng**: Components có thể import và sử dụng ở nhiều nơi
3. **Dễ test**: Từng module độc lập, dễ viết unit tests
4. **Scalable**: Dễ mở rộng thêm tính năng mới
5. **Clean code**: Code rõ ràng, dễ đọc, dễ hiểu
6. **Type safety**: TypeScript types được tách riêng và quản lý tốt

## 📝 Hướng dẫn sử dụng

### Import types:
```typescript
import { User, Room, Booking } from './types';
```

### Import components:
```typescript
import { Button, Badge } from './components/ui';
import { AdminDashboard } from './components/admin/AdminDashboard';
```

### Import services:
```typescript
import { RoomService, BookingService } from './services/services';
```

### Import utilities:
```typescript
import { formatCurrency } from './utils/helpers';
```

## 🔄 Migration từ file cũ

File `app.tsx` cũ đã được chia thành nhiều file nhỏ:
- Tất cả code đã được refactor
- Import paths đã được cập nhật
- Không thay đổi logic hoặc tính năng
- Code cleaner và dễ maintain hơn
