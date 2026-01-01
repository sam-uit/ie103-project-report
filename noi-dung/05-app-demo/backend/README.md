# Backend - Hệ thống Quản lý Đặt phòng

## 📁 Cấu trúc thư mục

```
backend/
├── adapters/          # Các adapter tương tác với database
│   ├── AuthAdapter.js        # Xử lý đăng nhập, đăng ký
│   ├── BookingAdapter.js     # CRUD đặt phòng
│   ├── RoomAdapter.js        # CRUD phòng
│   └── TransactionAdapter.js # CRUD giao dịch thanh toán
├── config/            # Cấu hình hệ thống
│   └── database.js           # Cấu hình kết nối SQL Server
├── data/              # Dữ liệu mẫu
│   └── seedData.js           # Dữ liệu seed (users, rooms, bookings)
├── middleware/        # Middleware xử lý request
│   └── auth.js               # Xác thực JWT token
├── routes/            # Định nghĩa API routes
│   ├── auth.routes.js        # Routes đăng nhập/đăng ký
│   ├── booking.routes.js     # Routes quản lý đặt phòng
│   ├── room.routes.js        # Routes quản lý phòng
│   └── transaction.routes.js # Routes quản lý giao dịch
├── scripts/           # Scripts tiện ích
│   ├── create_database.sql   # SQL tạo database & tables
│   └── seed.js               # Script chạy seed data
├── .env               # Biến môi trường (KHÔNG commit lên Git)
├── package.json       # Dependencies và scripts
└── server.js          # Entry point của server
```

## 🎯 Mục đích từng thành phần

### 📂 adapters/
Chứa các class Adapter theo pattern **Adapter Pattern**, mỗi adapter chịu trách nhiệm tương tác với một bảng trong database:

- **AuthAdapter.js**: Xử lý đăng nhập, đăng ký, lấy thông tin user
  - `login(username, password)` - Đăng nhập
  - `register(userData)` - Đăng ký tài khoản mới
  - `getUserById(id)` - Lấy thông tin user theo ID

- **BookingAdapter.js**: Quản lý đặt phòng
  - `getAllBookings()` - Lấy tất cả booking (admin)
  - `getBookingsByUserId(userId)` - Lấy booking của user
  - `createBooking(bookingData)` - Tạo booking mới
  - `updateBookingStatus(id, status)` - Cập nhật trạng thái booking
  - `deleteBooking(id)` - Xóa booking

- **RoomAdapter.js**: Quản lý phòng
  - `getAllRooms()` - Lấy tất cả phòng
  - `getRoomById(id)` - Lấy chi tiết phòng
  - `createRoom(roomData)` - Tạo phòng mới (admin)
  - `updateRoom(id, roomData)` - Cập nhật phòng
  - `deleteRoom(id)` - Xóa phòng

- **TransactionAdapter.js**: Quản lý giao dịch thanh toán
  - `getAllTransactions()` - Lấy tất cả giao dịch
  - `getTransactionsByUserId(userId)` - Lấy giao dịch của user
  - `createTransaction(transactionData)` - Tạo giao dịch mới
  - `updateTransactionStatus(id, status)` - Cập nhật trạng thái giao dịch

### 📂 config/
- **database.js**: Cấu hình kết nối SQL Server sử dụng package `mssql`
  - Export `poolPromise` để tái sử dụng connection pool
  - Đọc config từ `.env` file

### 📂 data/
- **seedData.js**: Dữ liệu mẫu cho development
  - `users`: 2 users (admin + user)
  - `rooms`: 5 phòng với giá và thông tin khác nhau
  - `bookings`: Dữ liệu đặt phòng mẫu

### 📂 middleware/
- **auth.js**: Middleware xác thực JWT
  - `authenticateToken`: Verify JWT token từ header `Authorization`
  - `authorizeRole(['ADMIN'])`: Kiểm tra role của user

### 📂 routes/
Định nghĩa các API endpoints:

- **auth.routes.js**:
  - `POST /api/auth/login` - Đăng nhập
  - `POST /api/auth/register` - Đăng ký
  - `GET /api/auth/me` - Lấy thông tin user hiện tại

- **booking.routes.js**:
  - `GET /api/bookings` - Lấy tất cả bookings (admin) hoặc của user
  - `GET /api/bookings/:id` - Lấy chi tiết booking
  - `POST /api/bookings` - Tạo booking mới
  - `PATCH /api/bookings/:id/status` - Cập nhật trạng thái
  - `DELETE /api/bookings/:id` - Xóa booking

- **room.routes.js**:
  - `GET /api/rooms` - Lấy tất cả phòng
  - `GET /api/rooms/:id` - Lấy chi tiết phòng
  - `POST /api/rooms` - Tạo phòng mới (admin)
  - `PUT /api/rooms/:id` - Cập nhật phòng (admin)
  - `DELETE /api/rooms/:id` - Xóa phòng (admin)

- **transaction.routes.js**:
  - `GET /api/transactions` - Lấy tất cả giao dịch
  - `POST /api/transactions` - Tạo giao dịch mới
  - `PATCH /api/transactions/:id/status` - Cập nhật trạng thái

### 📂 scripts/
- **create_database.sql**: Script SQL tạo database và tables
- **seed.js**: Script Node.js để seed dữ liệu mẫu vào database

### 📄 Files khác
- **.env**: Biến môi trường (DB connection, JWT secret, PORT, CORS)
- **server.js**: Entry point - khởi tạo Express server, mount routes, middleware
- **package.json**: Dependencies và npm scripts

## 🚀 Cách sử dụng

### 1. Cài đặt dependencies
```bash
cd backend
npm install
```

### 2. Cấu hình môi trường
Tạo file `.env` với nội dung:
```env
# Database
DB_SERVER=localhost
DB_PORT=1433
DB_USER=sa
DB_PASSWORD=YourPassword123
DB_NAME=BookingMS

# Server
PORT=3000
CORS_ORIGIN=http://localhost:5173

# JWT
JWT_SECRET=your-super-secret-key-change-this-in-production
JWT_EXPIRES_IN=24h
```

### 3. Tạo database
```bash
# Sử dụng Docker (khuyến nghị)
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourPassword123" \
  -p 1433:1433 --name mssql-local -d mcr.microsoft.com/mssql/server:2022-latest

# Chạy script tạo database
docker exec -i mssql-local /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P YourPassword123 -C \
  -i /dev/stdin < scripts/create_database.sql
```

### 4. Seed dữ liệu mẫu
```bash
npm run seed
```

### 5. Chạy server
```bash
# Development mode (auto-reload với nodemon)
npm run dev

# Production mode
npm start
```

Server sẽ chạy tại `http://localhost:3000`

## 🔧 Sửa đổi và mở rộng

### Thêm API endpoint mới

1. **Tạo adapter method** (nếu cần):
```javascript
// adapters/BookingAdapter.js
async getBookingsByRoom(roomId) {
  const pool = await poolPromise;
  const result = await pool.request()
    .input('roomId', sql.Int, roomId)
    .query('SELECT * FROM Bookings WHERE RoomID = @roomId');
  return result.recordset;
}
```

2. **Thêm route**:
```javascript
// routes/booking.routes.js
router.get('/rooms/:roomId/bookings', async (req, res) => {
  try {
    const bookings = await bookingAdapter.getBookingsByRoom(req.params.roomId);
    res.json(bookings);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
```

3. **Mount route** (nếu tạo file route mới):
```javascript
// server.js
const newRoutes = require('./routes/new.routes');
app.use('/api/new', newRoutes);
```

### Thêm bảng mới trong database

1. **Tạo table trong SQL**:
```sql
-- scripts/create_database.sql
CREATE TABLE Reviews (
  ReviewID INT PRIMARY KEY IDENTITY(1,1),
  BookingID INT FOREIGN KEY REFERENCES Bookings(BookingID),
  Rating INT CHECK (Rating BETWEEN 1 AND 5),
  Comment NVARCHAR(500),
  CreatedAt DATETIME DEFAULT GETDATE()
);
```

2. **Tạo adapter mới**:
```javascript
// adapters/ReviewAdapter.js
class ReviewAdapter {
  async getAllReviews() { /* ... */ }
  async createReview(reviewData) { /* ... */ }
}
module.exports = new ReviewAdapter();
```

3. **Tạo routes**:
```javascript
// routes/review.routes.js
const express = require('express');
const reviewAdapter = require('../adapters/ReviewAdapter');
// ... định nghĩa routes
```

### Thêm middleware mới

```javascript
// middleware/logger.js
const logger = (req, res, next) => {
  console.log(`${req.method} ${req.path}`);
  next();
};

// server.js
const logger = require('./middleware/logger');
app.use(logger);
```

## 🔐 Authentication Flow

1. User đăng nhập qua `POST /api/auth/login`
2. Server verify username/password, trả về JWT token
3. Frontend lưu token vào localStorage
4. Mọi request sau đều gửi token trong header: `Authorization: Bearer <token>`
5. Middleware `auth.js` verify token và gắn `req.user` vào request
6. Routes có thể kiểm tra role: `authorizeRole(['ADMIN'])`

## 📊 Database Schema

### Users
- UserID (PK)
- Username, PasswordHash, FullName, Email, Phone
- Role (ADMIN/USER)
- CreatedAt

### Rooms
- RoomID (PK)
- Name, Description, ImageUrl
- PricePerNight, MaxGuests, RoomType
- IsAvailable

### Bookings
- BookingID (PK)
- UserID (FK), RoomID (FK)
- CheckInDate, CheckOutDate
- TotalAmount, Status, PaymentStatus
- GuestName, GuestPhone, Notes

### Transactions
- TransactionID (PK)
- BookingID (FK), UserID (FK)
- Amount, PaymentMethod, Status
- TransactionDate

## ⚠️ Lưu ý quan trọng

- **KHÔNG commit file `.env`** lên Git (đã có trong `.gitignore`)
- **Luôn sử dụng parameterized queries** để tránh SQL Injection
- **Hash password** bằng bcrypt trước khi lưu vào DB
- **Validate input** trước khi xử lý
- **Handle errors** đúng cách, không expose sensitive info
- **Sử dụng connection pool** để tối ưu performance

## 📝 API Response Format

### Success Response
```json
{
  "data": [...],
  "message": "Success"
}
```

### Error Response
```json
{
  "error": "Error message",
  "details": "Detailed error info (only in development)"
}
```

## 🧪 Testing

```bash
# Sử dụng tools như Postman hoặc curl để test API

# Example: Login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'

# Example: Get rooms
curl -X GET http://localhost:3000/api/rooms

# Example: Create booking (với auth)
curl -X POST http://localhost:3000/api/bookings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"roomId":1,"checkIn":"2025-01-01","checkOut":"2025-01-03",...}'
```

## 📚 Dependencies chính

- **express**: Web framework
- **mssql**: SQL Server driver
- **bcrypt**: Hash password
- **jsonwebtoken**: JWT authentication
- **dotenv**: Quản lý environment variables
- **cors**: Enable CORS
- **nodemon**: Auto-reload trong development

## 🤝 Đóng góp

Khi sửa code, vui lòng:
1. Đọc kỹ cấu trúc hiện tại
2. Follow naming conventions
3. Comment code khi cần thiết
4. Test kỹ trước khi commit
5. Cập nhật README nếu thêm feature mới
