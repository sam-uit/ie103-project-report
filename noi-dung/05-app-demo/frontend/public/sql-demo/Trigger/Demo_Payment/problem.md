# Demo 4: Kiểm Tra Thanh Toán

## B1: Trình Bày Bài Toán

### Mục Đích
Xây dựng **Trigger** để đảm bảo tính chính xác của số tiền thanh toán và tự động cập nhật trạng thái đơn đặt phòng.

### Vấn Đề
Khi khách hàng thanh toán (INSERT vào bảng `PAYMENTS`):
1. **Kiểm tra số tiền**: Số tiền thanh toán phải bằng tổng đơn giá các phòng đã đặt
2. **Cập nhật trạng thái**: Tự động chuyển trạng thái booking sang `PAID`
3. **Ngăn gian lận**: Không cho thanh toán sai số tiền

### Giải Pháp
Sử dụng **INSTEAD OF Trigger** để:
- Tính tổng tiền từ `CT_DATPHONG`
- So sánh với số tiền thanh toán
- Tự động cập nhật trạng thái nếu hợp lệ

---

## B2: Câu Truy Vấn SQL

### Tạo Trigger
```sql
CREATE TRIGGER dbo.trg_PAYMENTS_Insert_CheckAndPaid
ON dbo.PAYMENTS
INSTEAD OF INSERT
AS
BEGIN
    -- Kiểm tra số tiền thanh toán
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN (
            SELECT datphong_id, SUM(don_gia) AS tong_tien
            FROM dbo.CT_DATPHONG
            GROUP BY datphong_id
        ) t ON t.datphong_id = i.booking_id
        WHERE i.amount <> t.tong_tien
    )
    BEGIN
        RAISERROR (N'Amount phải bằng tổng don_gia của booking', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Insert payment
    INSERT INTO dbo.PAYMENTS(booking_id, user_id, amount, method, status, created_at)
    SELECT booking_id, user_id, amount, method, status, GETDATE()
    FROM inserted;

    -- Cập nhật trạng thái booking
    UPDATE d
    SET d.trang_thai = 'PAID'
    FROM dbo.DATPHONG d
    JOIN inserted i ON i.booking_id = d.id;
END
```

---

## B3: Các Bảng Dữ Liệu Liên Quan

### Bảng CT_DATPHONG
| id | datphong_id | phong_id | don_gia |
|----|-------------|----------|---------|
| 1  | 1           | 1        | 500000  |
| 2  | 1           | 2        | 500000  |

**Tổng tiền booking #1:** 1,000,000 VNĐ

### Bảng DATPHONG (Trước Khi Thực Thi)
| id | user_id | trang_thai | created_at |
|----|---------|------------|------------|
| 1  | 1       | PENDING    | 2026-01-10 |

### Bảng PAYMENTS (Trước Khi Thực Thi)
| id | booking_id | amount | status |
|----|------------|--------|--------|
| (Trống) |||

---

## B4: Thực Thi Câu Lệnh

### Test Case - Thanh toán đúng số tiền
```sql
INSERT INTO PAYMENTS(booking_id, user_id, amount, method, status, created_at)
VALUES (1, 1, 1000000, 'CASH', 'SUCCESS', GETDATE());
```

---

## B5: Kết Quả Sau Thực Thi

### Bảng PAYMENTS (Sau Khi Thực Thi)
| id | booking_id | user_id | amount | method | status | created_at |
|----|------------|---------|--------|--------|--------|------------|
| **1** | **1** | **1** | **1000000** | **CASH** | **SUCCESS** | **2026-01-17 16:00** |

### Bảng DATPHONG (Sau Khi Thực Thi)
| id | user_id | trang_thai | created_at |
|----|---------|------------|------------|
| 1  | 1       | **PAID** ← Tự động cập nhật | 2026-01-10 |

### Nếu Thanh Toán Sai Số Tiền
```sql
-- Thử thanh toán 900000 (sai, phải là 1000000)
INSERT INTO PAYMENTS(booking_id, user_id, amount, method, status, created_at)
VALUES (1, 1, 900000, 'CASH', 'SUCCESS', GETDATE());
```

**Kết quả:** ❌ Error: Amount phải bằng tổng don_gia của booking

---

## Kết Luận

Trigger này:
- ✅ Đảm bảo tính chính xác của thanh toán
- ✅ Tự động cập nhật trạng thái booking
- ✅ Ngăn chặn gian lận và sai sót
