# 🎓 SQL Demo Manager V2

## Tổng Quan

Hệ thống quản lý và trình diễn các kỹ thuật xử lý dữ liệu SQL Server (Triggers, Stored Procedures, Functions, Cursors) với giao diện trực quan và dễ sử dụng.

### ✨ Tính Năng Chính

- ✅ **Demo Theo Cấu Trúc B1-B5**: Mỗi demo tuân theo quy trình chuẩn
  - B1: Trình bày bài toán
  - B2: Câu truy vấn SQL
  - B3: Bảng dữ liệu liên quan (trước thực thi)
  - B4: Thực thi câu lệnh
  - B5: Kết quả sau thực thi

- 📁 **Quản Lý Demo Qua Thư Mục**: Chỉ cần thêm folder mới là có demo
- 📝 **Markdown Support**: Hiển thị problem description đẹp mắt
- 🔄 **Real-time Execution**: Chạy SQL trực tiếp trên server
- 🎨 **Config-Driven UI**: Thay đổi giao diện qua config, không cần sửa code
- 🌓 **Dark Mode**: Hỗ trợ chế độ tối

---

## 📁 Cấu Trúc Thư Mục

```
sql-demo-manager/
├── frontend/
│   ├── sql-demo/                   # ⭐ Thư mục chứa tất cả demos
│   │   ├── Trigger/
│   │   │   ├── Demo_CheckTime/     # Demo 1
│   │   │   │   ├── problem.md      # Giới thiệu bài toán
│   │   │   │   └── script.sql      # SQL script
│   │   │   ├── Demo_AutoPrice/     # Demo 2
│   │   │   ├── Demo_SyncStatus/    # Demo 3
│   │   │   ├── Demo_Payment/       # Demo 4
│   │   │   └── Demo_Refund/        # Demo 5
│   │   ├── StoreProcedure/
│   │   ├── Function/
│   │   └── Cursor/
│   ├── components/
│   ├── pages/
│   ├── config.json                 # ⭐ File cấu hình chính
│   ├── DEMO_GUIDE.md              # Hướng dẫn thêm demo
│   └── CONFIG_GUIDE.md            # Hướng dẫn cấu hình
└── backend/
    ├── index.js                    # API server
    └── db.js                       # Database connection
```

---

## 🚀 Cài Đặt & Chạy

### 1. Cài Đặt Dependencies

```bash
# Backend
cd backend
npm install

# Frontend
cd ../frontend
npm install
```

### 2. Cấu Hình Database

Tạo file `.env` trong thư mục `backend/`:

```env
DB_SERVER=localhost
DB_NAME=HotelManagement
DB_USER=sa
DB_PASSWORD=your_password
DB_PORT=1433
```

### 3. Chạy Ứng Dụng

```bash
# Terminal 1: Chạy backend
cd backend
npm start

# Terminal 2: Chạy frontend
cd frontend
npm run dev
```

Mở browser: `http://localhost:5173`

---

## 📝 Thêm Demo Mới (5 Bước)

### Bước 1: Tạo Thư Mục

```bash
mkdir -p frontend/sql-demo/Trigger/Demo_MyTrigger
```

### Bước 2: Tạo `problem.md`

```markdown
# Demo: Tên Bài Toán

## B1: Trình Bày Bài Toán
[Mô tả vấn đề và giải pháp]

## B2: Câu Truy Vấn SQL
```sql
CREATE TRIGGER ...
```

## B3: Các Bảng Dữ Liệu Liên Quan
[Bảng trước khi thực thi]

## B4: Thực Thi Câu Lệnh
[Hướng dẫn chạy]

## B5: Kết Quả Sau Thực Thi
[Bảng sau khi thực thi]
```

### Bước 3: Tạo `script.sql`

```sql
/* Mô tả trigger */
CREATE TRIGGER dbo.trg_MyTrigger
ON dbo.TABLE_NAME
AFTER INSERT
AS
BEGIN
    -- Logic
END
GO

/* Test case */
INSERT INTO TABLE_NAME ...
```

### Bước 4: Cập Nhật `config.json`

Thêm vào mảng `scenarios`:

```json
{
  "id": "trg-06",
  "title": "Trigger 6: Tên Demo",
  "type": "Trigger",
  "shortDesc": "Mô tả ngắn",
  "sqlFile": "Trigger/Demo_MyTrigger/script.sql",
  "mdFile": "Trigger/Demo_MyTrigger/problem.md",
  "tables": ["TABLE_NAME"],
  "columns": [
    { "key": "id", "label": "ID", "isPk": true }
  ]
}
```

### Bước 5: Test

1. Reload browser (F5)
2. Vào "Xử lý thông tin"
3. Chọn demo mới
4. Kiểm tra markdown và SQL

---

## 🎨 Tùy Chỉnh Giao Diện

### Thay Đổi Tiêu Đề

Sửa `frontend/config.json`:

```json
{
  "appSettings": {
    "title": "Tên Hệ Thống Mới",
    "description": "Mô tả mới",
    "version": "3.0"
  }
}
```

### Thay Đổi Màu Sắc

Sửa `frontend/index.css`:

```css
:root {
  --primary-600: #3b82f6;  /* Màu chính */
  --primary-500: #60a5fa;  /* Màu hover */
}
```

### Thêm Thành Viên Nhóm

Sửa `frontend/config.json`:

```json
{
  "teamMembers": [
    {
      "mssv": "12345678",
      "name": "Nguyễn Văn A",
      "tasks": "Trigger: 3"
    }
  ]
}
```

---

## 📚 Tài Liệu

- [DEMO_GUIDE.md](frontend/DEMO_GUIDE.md) - Hướng dẫn thêm demo chi tiết
- [CONFIG_GUIDE.md](frontend/CONFIG_GUIDE.md) - Hướng dẫn cấu hình
- [FOLDER_STRUCTURE.md](frontend/sql-demo/FOLDER_STRUCTURE.md) - Cấu trúc thư mục

---

## 🎯 Ví Dụ Demo Có Sẵn

### Trigger (5 demos)
1. ✅ **Demo_CheckTime** - Kiểm tra thời gian đặt phòng
2. ✅ **Demo_AutoPrice** - Tự động đơn giá khi đặt phòng
3. ✅ **Demo_SyncStatus** - Đồng bộ trạng thái phòng
4. ✅ **Demo_Payment** - Kiểm tra thanh toán
5. ✅ **Demo_Refund** - Hoàn tiền

### Stored Procedure (5 demos)
- sp_ApplyVoucher
- sp_BookingRoom
- sp_Payment
- sp_ReviewRoom
- sp_Service

---

## 🔧 Công Nghệ Sử Dụng

### Frontend
- React + TypeScript
- Vite
- TailwindCSS
- React Router
- React Markdown

### Backend
- Node.js + Express
- MSSQL (mssql package)

---

## ⚠️ Lưu Ý

1. **Tên file cố định**: `problem.md` và `script.sql`
2. **Cấu trúc B1-B5**: Bắt buộc trong problem.md
3. **SQL hợp lệ**: Test script trước khi thêm
4. **Config JSON**: Kiểm tra cú pháp JSON
5. **Reload sau sửa**: F5 để thấy thay đổi

---

## 📞 Hỗ Trợ

Nếu gặp vấn đề:
1. Kiểm tra console browser (F12)
2. Kiểm tra terminal backend
3. Xem file DEMO_GUIDE.md

---

## 📄 License

MIT License - Tự do sử dụng cho mục đích học tập

---

## 👥 Nhóm Phát Triển

Xem danh sách thành viên trong trang "Thành Viên Nhóm" của ứng dụng.
