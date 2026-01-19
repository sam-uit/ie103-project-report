# 📁 Cấu Trúc Thư Mục SQL Demo

## Tổng Quan

Thư mục `sql-demo/` chứa tất cả các demo SQL được tổ chức theo loại (Trigger, StoreProcedure, Function, Cursor).

```
sql-demo/
├── Trigger/                    # Các demo về Trigger
│   ├── Demo_CheckTime/         # Demo 1: Kiểm tra thời gian
│   │   ├── problem.md          # Giới thiệu bài toán (B1-B5)
│   │   └── script.sql          # SQL script thực thi
│   ├── Demo_AutoPrice/         # Demo 2: Tự động đơn giá
│   │   ├── problem.md
│   │   └── script.sql
│   ├── Demo_SyncStatus/        # Demo 3: Đồng bộ trạng thái
│   │   ├── problem.md
│   │   └── script.sql
│   ├── Demo_Payment/           # Demo 4: Kiểm tra thanh toán
│   │   ├── problem.md
│   │   └── script.sql
│   ├── Demo_Refund/            # Demo 5: Hoàn tiền
│   │   ├── problem.md
│   │   └── script.sql
│   ├── trigger.md              # (Legacy) File markdown cũ
│   └── trigger.sql             # (Legacy) File SQL cũ
│
├── StoreProcedure/             # Các demo về Stored Procedure
│   ├── sp_ApplyVoucher.md
│   ├── sp_ApplyVoucher.sql
│   ├── sp_BookingRoom.md
│   ├── sp_BookingRoom.sql
│   ├── sp_Payment.md
│   ├── sp_Payment.sql
│   ├── sp_ReviewRoom.md
│   ├── sp_ReviewRoom.sql
│   ├── sp_Service.md
│   └── sp_Service.sql
│
├── Function/                   # Các demo về Function
│   └── (Thêm demo Function ở đây)
│
└── Cursor/                     # Các demo về Cursor
    └── (Thêm demo Cursor ở đây)
```

---

## 📋 Quy Ước Đặt Tên

### Thư Mục Demo
- **Format**: `Demo_<TenMoTa>`
- **Ví dụ**: `Demo_CheckTime`, `Demo_AutoPrice`, `Demo_Payment`
- **Lưu ý**: 
  - Sử dụng PascalCase
  - Tên ngắn gọn, mô tả rõ chức năng
  - Không dùng ký tự đặc biệt

### File Markdown (problem.md)
- **Tên file**: `problem.md` (cố định, chữ thường)
- **Nội dung**: Giới thiệu bài toán theo cấu trúc B1-B5
- **Format**: Markdown chuẩn GitHub

### File SQL (script.sql)
- **Tên file**: `script.sql` (cố định, chữ thường)
- **Nội dung**: SQL script hoàn chỉnh, có thể chạy trực tiếp
- **Format**: SQL Server (MSSQL)

---

## 🎯 Cấu Trúc File problem.md

Mỗi file `problem.md` phải tuân theo cấu trúc **B1-B5**:

```markdown
# Demo: Tên Bài Toán

## B1: Trình Bày Bài Toán
- Mục đích
- Vấn đề
- Giải pháp

## B2: Câu Truy Vấn SQL
- Code SQL chính
- Giải thích logic

## B3: Các Bảng Dữ Liệu Liên Quan
- Bảng TRƯỚC khi thực thi
- Mô tả cấu trúc

## B4: Thực Thi Câu Lệnh
- Hướng dẫn chạy
- Test cases

## B5: Kết Quả Sau Thực Thi
- Bảng SAU khi thực thi
- So sánh thay đổi
- Kết luận
```

---

## 🔧 Cấu Trúc File script.sql

```sql
/* ============================================================
   MÔ TẢ NGẮN GỌN VỀ TRIGGER/SP/FUNCTION
   ============================================================ */

-- Xóa đối tượng cũ nếu tồn tại
IF OBJECT_ID('dbo.ten_doi_tuong', 'TR/P/FN') IS NOT NULL 
    DROP TRIGGER/PROCEDURE/FUNCTION dbo.ten_doi_tuong;
GO

-- Tạo đối tượng mới
CREATE TRIGGER/PROCEDURE/FUNCTION dbo.ten_doi_tuong
...
AS
BEGIN
    -- Logic chính
END
GO

/* ============================================================
   TEST CASE 1: Mô tả test case
   Kỳ vọng: Kết quả mong đợi
   ============================================================ */
-- Câu lệnh test

/* ============================================================
   KIỂM TRA KẾT QUẢ
   ============================================================ */
SELECT * FROM ...;
```

---

## 📊 Ví Dụ Demo Hoàn Chỉnh

### Demo_CheckTime/

**problem.md:**
```markdown
# Demo 1: Kiểm Tra Thời Gian Đặt Phòng

## B1: Trình Bày Bài Toán
Xây dựng Trigger để đảm bảo check_out >= check_in...

## B2: Câu Truy Vấn SQL
```sql
CREATE TRIGGER trg_DATPHONG_CheckTime...
```

## B3: Các Bảng Dữ Liệu Liên Quan
...

## B4: Thực Thi Câu Lệnh
...

## B5: Kết Quả Sau Thực Thi
...
```

**script.sql:**
```sql
/* Trigger kiểm tra thời gian */
CREATE TRIGGER dbo.trg_DATPHONG_CheckTime
ON dbo.DATPHONG
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE check_out < check_in)
    BEGIN
        RAISERROR (N'check_out không được nhỏ hơn check_in', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END
GO

/* TEST CASE */
INSERT INTO DATPHONG...
```

---

## 🔄 Workflow Thêm Demo Mới

1. **Tạo thư mục**: `mkdir sql-demo/Trigger/Demo_MyDemo`
2. **Tạo problem.md**: Viết theo cấu trúc B1-B5
3. **Tạo script.sql**: Viết SQL script hoàn chỉnh
4. **Cập nhật config.json**: Thêm scenario mới
5. **Test**: Reload browser và kiểm tra

---

## ⚠️ Lưu Ý

1. **Tên file cố định**: Phải là `problem.md` và `script.sql`
2. **Encoding**: UTF-8
3. **Line endings**: LF (Unix) hoặc CRLF (Windows)
4. **SQL syntax**: Microsoft SQL Server (MSSQL)
5. **Markdown**: GitHub Flavored Markdown

---

## 📚 Tài Liệu Tham Khảo

- [DEMO_GUIDE.md](./DEMO_GUIDE.md) - Hướng dẫn thêm demo mới
- [CONFIG_GUIDE.md](./CONFIG_GUIDE.md) - Hướng dẫn cấu hình
- [README.md](./README.md) - Tổng quan hệ thống
