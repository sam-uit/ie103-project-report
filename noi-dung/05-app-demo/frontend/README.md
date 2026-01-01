# Frontend - Hệ thống Quản lý Đặt phòng

## 📁 Cấu trúc thư mục

```
frontend/
├── src/
│   ├── components/        # React components
│   │   ├── admin/                # Components dành cho Admin
│   │   │   ├── AdminDashboard.tsx       # Dashboard tổng quan admin
│   │   │   ├── AdminBookingManager.tsx  # Quản lý đặt phòng
│   │   │   └── AdminTransactionManager.tsx # Quản lý giao dịch
│   │   ├── user/                 # Components dành cho User
│   │   │   └── UserBookings.tsx         # Danh sách booking của user
│   │   ├── modals/               # Modal dialogs
│   │   │   ├── LoginModal.tsx           # Modal đăng nhập/đăng ký
│   │   │   ├── PaymentModals.tsx        # Modal thanh toán
│   │   │   └── RoomFormModal.tsx        # Modal thêm/sửa phòng
│   │   ├── ui/                   # UI components tái sử dụng
│   │   │   ├── Button.tsx               # Button component
│   │   │   ├── Toast.tsx                # Toast notification
│   │   │   └── index.ts                 # Export tất cả UI components
│   │   └── ErrorBoundary.tsx     # Error boundary wrapper
│   ├── services/          # API service layer
│   │   ├── authService.api.ts           # API calls cho auth
│   │   ├── bookingService.api.ts        # API calls cho booking
│   │   ├── roomService.api.ts           # API calls cho room
│   │   ├── transactionService.api.ts    # API calls cho transaction
│   │   └── services.ts                  # Export tất cả services
│   ├── config/            # Cấu hình
│   │   └── apiClient.ts                 # Axios instance với config
│   ├── utils/             # Utility functions
│   │   ├── helpers.ts                   # Helper functions (format date, currency)
│   │   ├── mappers.ts                   # Map data giữa BE ↔ FE
│   │   ├── storage.ts                   # LocalStorage helpers
│   │   └── validation.ts                # Validation functions
│   ├── App.tsx            # Root component
│   ├── main.tsx           # Entry point
│   └── types.ts           # TypeScript type definitions
├── index.html             # HTML template
├── index.css              # Global styles
├── vite.config.ts         # Vite configuration
├── tailwind.config.js     # Tailwind CSS configuration
├── tsconfig.json          # TypeScript configuration
└── package.json           # Dependencies và scripts
```

## 🎯 Mục đích từng thành phần

### 📂 src/components/

#### 🔧 admin/ - Components dành cho Admin
Các trang quản lý dành cho user có role ADMIN.

- **AdminDashboard.tsx**: 
  - Dashboard tổng quan với thống kê (tổng phòng, tổng booking, doanh thu)
  - Navigation tabs: Đặt phòng, Giao dịch, Phòng
  - Layout với sidebar/tabs để chuyển đổi giữa các trang quản lý

- **AdminBookingManager.tsx**:
  - Quản lý tất cả đặt phòng trong hệ thống
  - Filter theo trạng thái: All, Pending, Confirmed, Checked-in, Checked-out, Rejected
  - Statistics cards: số lượng pending, confirmed, checked-in, tổng doanh thu
  - View toggle: Card view / Table view
  - Actions: Duyệt, Từ chối, Check-in, Check-out, Xem chi tiết
  - Hiển thị thông tin: room, khách, ngày check-in/out (có giờ), trạng thái, giá

- **AdminTransactionManager.tsx**:
  - Quản lý tất cả giao dịch thanh toán
  - Filter theo trạng thái: All, Pending, Completed, Failed
  - Actions: Cập nhật trạng thái giao dịch
  - Hiển thị: booking liên quan, user, số tiền, phương thức thanh toán, ngày giao dịch

#### 👤 user/ - Components dành cho User thường

- **UserBookings.tsx**:
  - Hiển thị danh sách booking của user đã đăng nhập
  - Filter tabs: Tất cả, Sắp tới, Đã qua
  - Card design đẹp với ảnh phòng, thông tin booking
  - Status badges rõ ràng
  - Format ngày tháng theo tiếng Việt (ngắn/dài/relative)
  - Empty state khi chưa có booking

#### 🪟 modals/ - Modal Dialogs

- **LoginModal.tsx**:
  - Modal đăng nhập và đăng ký
  - Toggle giữa login/register form
  - Form validation
  - Call authService để login/register
  - Lưu token vào localStorage sau khi login thành công

- **PaymentModals.tsx**:
  - Modal thanh toán cho booking
  - Form nhập thông tin thanh toán (phương thức, số tiền)
  - Call transactionService để tạo transaction

- **RoomFormModal.tsx**:
  - Modal thêm/sửa phòng (admin only)
  - Form với fields: name, description, price, maxGuests, roomType, imageUrl
  - Validation
  - Call roomService để create/update room

#### 🎨 ui/ - Reusable UI Components

- **Button.tsx**:
  - Customizable button component
  - Props: variant (primary, secondary, success, danger, outline), size (sm, md, lg), isLoading
  - Consistent styling với Tailwind

- **Toast.tsx**:
  - Toast notification component
  - Types: success, error, info, warning
  - Auto dismiss sau vài giây
  - Position: top-right

- **index.ts**:
  - Export tất cả UI components để import dễ dàng
  - `import { Button, Toast } from '@/components/ui'`

#### 🛡️ ErrorBoundary.tsx
- React Error Boundary để catch errors trong component tree
- Hiển thị fallback UI khi có lỗi
- Prevent toàn bộ app crash khi 1 component lỗi

### 📂 src/services/

Layer gọi API, mỗi service tương ứng với 1 resource.

- **authService.api.ts**:
  - `login(username, password)` → POST /api/auth/login
  - `register(userData)` → POST /api/auth/register
  - `getCurrentUser()` → GET /api/auth/me
  - `logout()` → Clear localStorage

- **bookingService.api.ts**:
  - `getAllBookings()` → GET /api/bookings
  - `getMyBookings()` → GET /api/bookings (user's bookings)
  - `createBooking(bookingData)` → POST /api/bookings
  - `updateBookingStatus(id, status)` → PATCH /api/bookings/:id/status
  - `deleteBooking(id)` → DELETE /api/bookings/:id
  - **Sử dụng mappers** để convert field names giữa BE ↔ FE

- **roomService.api.ts**:
  - `getAllRooms()` → GET /api/rooms
  - `getRoomById(id)` → GET /api/rooms/:id
  - `createRoom(roomData)` → POST /api/rooms
  - `updateRoom(id, roomData)` → PUT /api/rooms/:id
  - `deleteRoom(id)` → DELETE /api/rooms/:id
  - **Sử dụng mappers** để convert imageUrl ↔ image, etc.

- **transactionService.api.ts**:
  - `getAllTransactions()` → GET /api/transactions
  - `createTransaction(transactionData)` → POST /api/transactions
  - `updateTransactionStatus(id, status)` → PATCH /api/transactions/:id/status

- **services.ts**:
  - Export tất cả services để import gọn: `import { authService, bookingService } from '@/services'`

### 📂 src/config/

- **apiClient.ts**:
  - Tạo axios instance với baseURL = `http://localhost:3000/api`
  - Interceptors:
    - Request: Tự động thêm `Authorization: Bearer <token>` vào header
    - Response: Handle errors globally (401 → logout, 500 → show error)

### 📂 src/utils/

Các utility functions tái sử dụng.

- **helpers.ts**:
  - `formatCurrency(amount)` → Format số tiền VND: "1.500.000 ₫"
  - `formatDate(date, format)` → Format ngày theo tiếng Việt
    - `'short'`: "31/12/2025"
    - `'medium'`: "31 Th12 2025"
    - `'long'`: "31 Tháng 12, 2025"
    - `'full'`: "Thứ Tư, 31 Tháng 12, 2025"
  - `formatDateTime(date)` → "31/12/2025 14:30"
  - `getRelativeTime(date)` → "2 ngày trước", "1 tuần sau"
  - `calculateNights(checkIn, checkOut)` → Số đêm
  - `isDateInPast(date)` → Check xem ngày đã qua chưa

- **mappers.ts**:
  - Map field names giữa Backend ↔ Frontend
  - **Backend → Frontend**:
    - `mapRoomFromAPI(apiRoom)`: imageUrl → image
    - `mapBookingFromAPI(apiBooking)`: totalAmount → totalPrice, notes → specialRequests
  - **Frontend → Backend**:
    - `mapRoomToAPI(frontendRoom)`: image → imageUrl
    - `mapBookingToAPI(frontendBooking)`: totalPrice → totalAmount, specialRequests → notes
  - **Tại sao cần?**: Backend dùng snake_case/DB naming, Frontend dùng camelCase/UI naming

- **storage.ts**:
  - `setToken(token)` → Lưu JWT token vào localStorage
  - `getToken()` → Lấy token từ localStorage
  - `removeToken()` → Xóa token (logout)
  - `setUser(user)` → Lưu thông tin user
  - `getUser()` → Lấy thông tin user
  - `removeUser()` → Xóa thông tin user

- **validation.ts**:
  - `validateEmail(email)` → Kiểm tra email hợp lệ
  - `validatePhone(phone)` → Kiểm tra số điện thoại
  - `validatePassword(password)` → Kiểm tra password đủ mạnh
  - `validateBookingDates(checkIn, checkOut)` → Kiểm tra ngày hợp lệ

### 📄 Root Files

- **App.tsx**:
  - Root component của ứng dụng
  - Routing logic (nếu dùng react-router)
  - State quản lý user, authentication
  - Conditional rendering: Admin view vs User view vs Guest view

- **main.tsx**:
  - Entry point của React app
  - Render App component vào DOM
  - Setup React StrictMode

- **types.ts**:
  - TypeScript type definitions
  - Types: User, Room, Booking, Transaction
  - Enums: BookingStatus, PaymentStatus, UserRole

- **index.html**:
  - HTML template
  - `<div id="root">` mount point
  - Link đến `/src/main.tsx`

- **index.css**:
  - Global CSS
  - Tailwind directives: @tailwind base, components, utilities
  - Custom global styles

## 🚀 Cách sử dụng

### 1. Cài đặt dependencies
```bash
cd frontend
npm install
```

### 2. Cấu hình môi trường
Tạo file `.env` (nếu cần):
```env
VITE_API_URL=http://localhost:3000/api
```

### 3. Chạy development server
```bash
npm run dev
```

App sẽ chạy tại `http://localhost:5173`

### 4. Build production
```bash
npm run build
```

Output sẽ ở folder `dist/`

## 🔧 Sửa đổi và mở rộng

### Thêm component mới

1. **Tạo component file**:
```tsx
// src/components/user/UserProfile.tsx
import React from 'react';
import { User } from '@/types';

interface UserProfileProps {
  user: User;
}

export const UserProfile: React.FC<UserProfileProps> = ({ user }) => {
  return (
    <div className="bg-white p-6 rounded-lg shadow">
      <h2 className="text-2xl font-bold mb-4">{user.fullName}</h2>
      {/* ... */}
    </div>
  );
};
```

2. **Import và sử dụng**:
```tsx
import { UserProfile } from '@/components/user/UserProfile';

function App() {
  return <UserProfile user={currentUser} />;
}
```

### Thêm API service mới

1. **Tạo service file**:
```typescript
// src/services/reviewService.api.ts
import apiClient from '@/config/apiClient';
import { Review } from '@/types';

export const reviewService = {
  async getReviewsByRoom(roomId: number): Promise<Review[]> {
    const response = await apiClient.get(`/reviews/room/${roomId}`);
    return response.data;
  },
  
  async createReview(reviewData: Partial<Review>): Promise<Review> {
    const response = await apiClient.post('/reviews', reviewData);
    return response.data;
  }
};
```

2. **Export trong services.ts**:
```typescript
// src/services/services.ts
export { reviewService } from './reviewService.api';
```

3. **Sử dụng trong component**:
```tsx
import { reviewService } from '@/services';

const reviews = await reviewService.getReviewsByRoom(roomId);
```

### Thêm utility function mới

```typescript
// src/utils/helpers.ts
export const formatRating = (rating: number): string => {
  return '⭐'.repeat(Math.floor(rating));
};
```

### Thêm TypeScript type mới

```typescript
// src/types.ts
export interface Review {
  id: number;
  bookingId: number;
  userId: number;
  rating: number;
  comment: string;
  createdAt: string;
}
```

## 🎨 Styling với Tailwind CSS

### Sử dụng Tailwind classes
```tsx
<div className="bg-blue-500 text-white p-4 rounded-lg shadow-md hover:bg-blue-600 transition">
  Content
</div>
```

### Custom configuration
Edit `tailwind.config.js`:
```javascript
module.exports = {
  theme: {
    extend: {
      colors: {
        'brand-blue': '#1E40AF',
      },
    },
  },
};
```

## 📊 Data Flow

```
Component (UI)
    ↓ (call service)
Service (API Layer)
    ↓ (HTTP request via apiClient)
Backend API
    ↓ (response)
Service (map data with mappers)
    ↓ (return data)
Component (update state, re-render)
```

### Example: Lấy danh sách phòng

1. Component gọi service:
```tsx
const rooms = await roomService.getAllRooms();
```

2. Service gọi API:
```typescript
// roomService.api.ts
const response = await apiClient.get('/rooms');
```

3. apiClient tự động thêm token vào header:
```typescript
// apiClient.ts interceptor
config.headers.Authorization = `Bearer ${token}`;
```

4. Backend trả về data với field `imageUrl`

5. Service map data trước khi return:
```typescript
return response.data.map(mapRoomFromAPI); // imageUrl → image
```

6. Component nhận data với field `image`

## 🔐 Authentication Flow

1. User nhấn "Đăng nhập" → Mở LoginModal
2. User nhập username/password → Submit form
3. Component gọi `authService.login(username, password)`
4. Service gọi API `/auth/login`, nhận token
5. Service lưu token vào localStorage qua `storage.setToken(token)`
6. Service lưu user info qua `storage.setUser(user)`
7. App re-render, hiện giao diện đã đăng nhập
8. Các request tiếp theo tự động có token trong header (nhờ apiClient interceptor)

## 🧩 Component Patterns

### Pattern 1: Container/Presentation
```tsx
// Container: Handle logic
const UserBookingsContainer = () => {
  const [bookings, setBookings] = useState([]);
  
  useEffect(() => {
    bookingService.getMyBookings().then(setBookings);
  }, []);
  
  return <UserBookingsView bookings={bookings} />;
};

// Presentation: Pure UI
const UserBookingsView = ({ bookings }) => {
  return (
    <div>
      {bookings.map(booking => <BookingCard key={booking.id} booking={booking} />)}
    </div>
  );
};
```

### Pattern 2: Custom Hooks
```tsx
// hooks/useBookings.ts
export const useBookings = () => {
  const [bookings, setBookings] = useState([]);
  const [loading, setLoading] = useState(true);
  
  useEffect(() => {
    bookingService.getMyBookings()
      .then(setBookings)
      .finally(() => setLoading(false));
  }, []);
  
  return { bookings, loading };
};

// Component
const UserBookings = () => {
  const { bookings, loading } = useBookings();
  if (loading) return <Loading />;
  return <BookingList bookings={bookings} />;
};
```

## ⚠️ Lưu ý quan trọng

### Security
- **KHÔNG lưu sensitive data** vào localStorage ngoài token
- **Validate input** trước khi submit
- **Escape HTML** để tránh XSS
- **Check permissions** trước khi hiển thị admin features

### Performance
- **Sử dụng React.memo** cho components render nhiều lần
- **Lazy load** các routes/components không cần thiết ngay
- **Debounce** search/filter inputs
- **Pagination** cho danh sách dài

### Code Quality
- **TypeScript**: Luôn define types cho props, state, API responses
- **Naming**: Descriptive, consistent naming
- **Comments**: Chỉ comment khi logic phức tạp
- **Formatting**: Sử dụng Prettier để format code tự động

### Error Handling
```tsx
try {
  await roomService.createRoom(roomData);
  toast.success('Tạo phòng thành công!');
} catch (error) {
  console.error('Create room error:', error);
  toast.error(error.message || 'Có lỗi xảy ra');
}
```

## 📝 Common Patterns

### Loading State
```tsx
const [loading, setLoading] = useState(false);

const handleSubmit = async () => {
  setLoading(true);
  try {
    await someService.doSomething();
  } finally {
    setLoading(false);
  }
};

return <Button isLoading={loading}>Submit</Button>;
```

### Conditional Rendering
```tsx
{user ? (
  <Dashboard user={user} />
) : (
  <LoginModal />
)}

{bookings.length > 0 ? (
  <BookingList bookings={bookings} />
) : (
  <EmptyState message="Chưa có booking nào" />
)}
```

### List Rendering
```tsx
{rooms.map(room => (
  <RoomCard 
    key={room.id} 
    room={room} 
    onBook={handleBook}
  />
))}
```

## 🧪 Testing Tips

### Manual Testing Checklist
- [ ] Login/Logout flow
- [ ] Create/Edit/Delete operations
- [ ] Form validation (invalid inputs)
- [ ] Error handling (network error, 401, 500)
- [ ] Responsive design (mobile, tablet, desktop)
- [ ] Date formatting hiển thị đúng tiếng Việt
- [ ] Status badges hiển thị đúng màu sắc

## 📚 Tech Stack

- **React 18**: UI library
- **TypeScript**: Type safety
- **Vite**: Build tool (fast, modern)
- **Tailwind CSS**: Utility-first CSS framework
- **Axios**: HTTP client
- **Lucide React**: Icon library
- **date-fns**: Date manipulation (nếu cần thêm)

## 🤝 Đóng góp

Khi sửa code, vui lòng:
1. **Đọc kỹ README** này trước
2. **Follow naming conventions** hiện tại
3. **Sử dụng TypeScript** đúng cách, không dùng `any`
4. **Test kỹ** trước khi commit
5. **Format code** với Prettier
6. **Update README** nếu thêm feature/pattern mới
7. **Sử dụng mappers** khi gọi API để đảm bảo field mapping đúng
8. **Sử dụng helpers** (formatDate, formatCurrency) thay vì tự format

## 🔗 Links hữu ích

- [React Docs](https://react.dev/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Tailwind CSS Docs](https://tailwindcss.com/docs)
- [Vite Guide](https://vitejs.dev/guide/)
