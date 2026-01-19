# Hướng Dẫn Thêm Demo Mới

## 📁 Cấu Trúc Thư Mục Demo

Mỗi demo được tổ chức trong một thư mục riêng theo cấu trúc:

```
sql-demo/
├── Trigger/
│   ├── Demo_CheckTime/
│   │   ├── problem.md       # Giới thiệu bài toán (B1-B5)
│   │   └── script.sql       # SQL script thực thi
│   ├── Demo_AutoPrice/
│   │   ├── problem.md
│   │   └── script.sql
│   └── ...
├── StoreProcedure/
│   ├── Demo_BookRoom/
│   │   ├── problem.md
│   │   └── script.sql
│   └── ...
├── Function/
└── Cursor/
```

---

## 📝 Quy Trình Thêm Demo Mới (5 Bước)

### Bước 1: Tạo Thư Mục Demo

Tạo thư mục mới trong danh mục tương ứng (Trigger/StoreProcedure/Function/Cursor):

```bash
mkdir -p sql-demo/Trigger/Demo_TenDemo
```

### Bước 2: Tạo File `problem.md`

File này mô tả bài toán theo cấu trúc **B1-B5**:

```markdown
# Demo: Tên Bài Toán

## B1: Trình Bày Bài Toán

### Mục Đích
[Mô tả mục đích của trigger/SP/function]

### Vấn Đề
[Mô tả vấn đề cần giải quyết]

### Giải Pháp
[Mô tả cách giải quyết]

---

## B2: Câu Truy Vấn SQL

```sql
-- Code SQL chính
CREATE TRIGGER/PROCEDURE/FUNCTION ...
```

---

## B3: Các Bảng Dữ Liệu Liên Quan

### Bảng ABC (Trước Khi Thực Thi)
| col1 | col2 | col3 |
|------|------|------|
| ...  | ...  | ...  |

---

## B4: Thực Thi Câu Lệnh

Nhấn nút **EXECUTE** để chạy script.

---

## B5: Kết Quả Sau Thực Thi

### Bảng ABC (Sau Khi Thực Thi)
| col1 | col2 | col3 |
|------|------|------|
| ...  | ...  | ...  |

---

## Kết Luận

- ✅ Điểm mạnh 1
- ✅ Điểm mạnh 2
```

### Bước 3: Tạo File `script.sql`

File này chứa SQL script hoàn chỉnh:

```sql
/* ============================================================
   MÔ TẢ NGẮN GỌN
   ============================================================ */

-- Xóa đối tượng cũ nếu tồn tại
IF OBJECT_ID('dbo.ten_doi_tuong', 'TR/P/FN') IS NOT NULL 
    DROP TRIGGER/PROCEDURE/FUNCTION dbo.ten_doi_tuong;
GO

-- Tạo đối tượng mới
CREATE TRIGGER/PROCEDURE/FUNCTION ...
AS
BEGIN
    -- Logic chính
END
GO

/* ============================================================
   TEST CASE
   ============================================================ */
-- Các câu lệnh test
```

### Bước 4: Cập Nhật `config.json`

Thêm scenario mới vào file `frontend/config.json`:

```json
{
  "id": "trg-06",
  "title": "Trigger 6: Tên Demo",
  "type": "Trigger",
  "shortDesc": "Mô tả ngắn gọn",
  "sqlFile": "Demo_TenDemo/script.sql",
  "mdFile": "Demo_TenDemo/problem.md",
  "tables": ["BANG_1", "BANG_2"],
  "columns": [
    { "key": "id", "label": "ID", "isPk": true },
    { "key": "ten_cot", "label": "Tên Cột", "isPk": false }
  ],
  "params": [
    { "name": "@Param1", "type": "int", "defaultValue": 1 }
  ]
}
```

### Bước 5: Test Demo

1. Reload trình duyệt (F5)
2. Vào trang "Xử lý thông tin"
3. Chọn demo mới
4. Kiểm tra:
   - ✅ Markdown hiển thị đúng
   - ✅ SQL script load được
   - ✅ Execute thành công
   - ✅ Kết quả hiển thị đúng

---

## 🎨 Tùy Chỉnh Giao Diện Qua Config

### Thay Đổi Màu Sắc

Sửa file `frontend/index.css`:

```css
:root {
  --primary-600: #3b82f6;  /* Màu chính */
  --primary-500: #60a5fa;  /* Màu hover */
}
```

### Thay Đổi Tiêu Đề

Sửa file `frontend/config.json`:

```json
{
  "appSettings": {
    "title": "Tên Hệ Thống Mới",
    "description": "Mô tả mới",
    "version": "3.0"
  }
}
```

### Thêm/Xóa Menu

Sửa file `frontend/components/Layout.tsx` (chỉ khi cần thiết):

```tsx
const menuItems = [
  { path: '/', label: 'Tổng Quan', icon: Home },
  { path: '/scenarios', label: 'Xử Lý Thông Tin', icon: Database },
  // Thêm menu mới ở đây
];
```

---

## 📊 Ví Dụ Hoàn Chỉnh

Xem các demo mẫu trong thư mục `sql-demo/Trigger/`:
- ✅ `Demo_CheckTime` - Kiểm tra thời gian
- ✅ `Demo_AutoPrice` - Tự động đơn giá
- ✅ `Demo_SyncStatus` - Đồng bộ trạng thái
- ✅ `Demo_Payment` - Kiểm tra thanh toán
- ✅ `Demo_Refund` - Hoàn tiền

---

## ⚠️ Lưu Ý Quan Trọng

1. **Tên file phải khớp**: `problem.md` và `script.sql` (chữ thường)
2. **Cấu trúc B1-B5**: Phải tuân thủ trong `problem.md`
3. **SQL hợp lệ**: Test script trước khi thêm vào demo
4. **Config JSON**: Đảm bảo cú pháp JSON đúng (dùng JSONLint.com để kiểm tra)
5. **Reload sau khi sửa**: Nhấn F5 để thấy thay đổi

---

## 🚀 Workflow Nhanh

```bash
# 1. Tạo thư mục
mkdir -p sql-demo/Trigger/Demo_MyTrigger

# 2. Tạo files
touch sql-demo/Trigger/Demo_MyTrigger/problem.md
touch sql-demo/Trigger/Demo_MyTrigger/script.sql

# 3. Viết nội dung (dùng editor)
code sql-demo/Trigger/Demo_MyTrigger/

# 4. Cập nhật config
code frontend/config.json

# 5. Test
# Mở browser → F5 → Kiểm tra demo
```

---

## 📞 Hỗ Trợ

Nếu gặp vấn đề:
1. Kiểm tra console browser (F12)
2. Kiểm tra terminal backend (lỗi SQL)
3. Xem file `CONFIG_GUIDE.md` để biết thêm chi tiết
