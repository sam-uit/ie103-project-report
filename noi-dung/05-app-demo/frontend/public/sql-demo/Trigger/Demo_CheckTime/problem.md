# Demo 1: Kiểm Tra Thời Gian Đặt Phòng

## B1: Trình Bày Bài Toán

### Mục Đích
Xây dựng **Trigger** để đảm bảo tính hợp lệ của dữ liệu thời gian khi đặt phòng trong hệ thống quản lý khách sạn.

### Vấn Đề
Trong hệ thống đặt phòng khách sạn, cần đảm bảo rằng:
- Thời gian trả phòng (`check_out`) phải **lớn hơn hoặc bằng** thời gian nhận phòng (`check_in`)
- Ngăn chặn dữ liệu không hợp lệ được lưu vào cơ sở dữ liệu
- Báo lỗi rõ ràng cho người dùng khi nhập sai

### Giải Pháp
Sử dụng **AFTER Trigger** trên bảng `DATPHONG` để:
1. Kiểm tra điều kiện thời gian sau khi INSERT hoặc UPDATE
2. Sử dụng bảng ảo `inserted` để truy cập dữ liệu mới
3. ROLLBACK transaction nếu phát hiện lỗi
4. Hiển thị thông báo lỗi chi tiết

---

## B2: Câu Truy Vấn SQL

### Tạo Trigger
```sql
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
```

### Test Case - Trường Hợp Sai
```sql
INSERT INTO DATPHONG(user_id, check_in, check_out, trang_thai, created_at)
VALUES (1, '2026-01-14 10:00', '2026-01-14 08:00', 'PENDING', GETDATE());
```

### Test Case - Trường Hợp Đúng
```sql
INSERT INTO DATPHONG(user_id, check_in, check_out, trang_thai, created_at)
VALUES (1, '2026-01-14 08:00', '2026-01-20 10:00', 'PENDING', GETDATE());
```

---

## B3: Các Bảng Dữ Liệu Liên Quan

### Bảng DATPHONG (Trước Khi Thực Thi)
| id | user_id | check_in | check_out | trang_thai | created_at |
|----|---------|----------|-----------|------------|------------|
| 1  | 1       | 2026-01-10 14:00 | 2026-01-15 12:00 | PAID | 2026-01-09 10:30 |
| 2  | 2       | 2026-01-12 15:00 | 2026-01-14 11:00 | PENDING | 2026-01-11 09:15 |

---

## B4: Thực Thi Câu Lệnh

Nhấn nút **EXECUTE** để chạy test case và xem kết quả.

---

## B5: Kết Quả Sau Thực Thi

### Trường Hợp Sai (check_out < check_in)
**Kết quả:** ❌ Lỗi - Transaction bị ROLLBACK
```
Error: check_out không được nhỏ hơn check_in
```

### Trường Hợp Đúng
**Kết quả:** ✅ Thành công - Dữ liệu được thêm vào bảng

### Bảng DATPHONG (Sau Khi Thực Thi Thành Công)
| id | user_id | check_in | check_out | trang_thai | created_at |
|----|---------|----------|-----------|------------|------------|
| 1  | 1       | 2026-01-10 14:00 | 2026-01-15 12:00 | PAID | 2026-01-09 10:30 |
| 2  | 2       | 2026-01-12 15:00 | 2026-01-14 11:00 | PENDING | 2026-01-11 09:15 |
| **3** | **1** | **2026-01-14 08:00** | **2026-01-20 10:00** | **PENDING** | **2026-01-17 16:00** |

---

## Kết Luận

Trigger này đảm bảo:
- ✅ Tính toàn vẹn dữ liệu về thời gian
- ✅ Ngăn chặn lỗi logic nghiệp vụ
- ✅ Cải thiện trải nghiệm người dùng với thông báo lỗi rõ ràng
