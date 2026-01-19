# Demo 5: Hoàn Tiền

## B1: Trình Bày Bài Toán

### Mục Đích
Xây dựng **Trigger** để quản lý quy trình hoàn tiền an toàn và chính xác.

### Vấn Đề
Khi xử lý hoàn tiền (INSERT vào bảng `REFUNDS`):
1. **Kiểm tra số tiền hoàn**: Không được vượt quá số tiền đã thanh toán
2. **Đồng bộ trạng thái**: Cập nhật PAYMENTS.status = 'REFUNDED' và DATPHONG.trang_thai = 'REFUNDED'
3. **Ngăn gian lận**: Không cho hoàn tiền nhiều hơn đã trả

### Giải Pháp
Sử dụng **INSTEAD OF Trigger** để:
- Kiểm tra `refund_amount <= payment.amount`
- Tự động cập nhật trạng thái payment và booking
- Đảm bảo tính toàn vẹn dữ liệu

---

## B2: Câu Truy Vấn SQL

### Tạo Trigger
```sql
CREATE TRIGGER dbo.trg_REFUNDS_Insert_CheckAndUpdate
ON dbo.REFUNDS
INSTEAD OF INSERT
AS
BEGIN
    -- Kiểm tra số tiền hoàn không vượt quá số tiền thanh toán
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dbo.PAYMENTS p ON p.id = i.payment_id
        WHERE i.refund_amount > p.amount
    )
    BEGIN
        RAISERROR (N'Refund vượt quá thanh toán', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Insert refund
    INSERT INTO dbo.REFUNDS(payment_id, refund_amount, status, reason, approved_by, created_at)
    SELECT payment_id, refund_amount, status, reason, approved_by, ISNULL(created_at, GETDATE())
    FROM inserted;

    -- Cập nhật trạng thái payment
    UPDATE p
    SET p.status = 'REFUNDED'
    FROM dbo.PAYMENTS p
    JOIN inserted i ON i.payment_id = p.id;

    -- Cập nhật trạng thái booking
    UPDATE d
    SET d.trang_thai = 'REFUNDED'
    FROM dbo.DATPHONG d
    JOIN dbo.PAYMENTS p ON p.booking_id = d.id
    JOIN inserted i ON i.payment_id = p.id;
END
```

---

## B3: Các Bảng Dữ Liệu Liên Quan

### Bảng PAYMENTS (Trước Khi Thực Thi)
| id | booking_id | amount | status | created_at |
|----|------------|--------|--------|------------|
| 1  | 1          | 1000000| SUCCESS| 2026-01-15 |

### Bảng DATPHONG (Trước Khi Thực Thi)
| id | user_id | trang_thai | created_at |
|----|---------|------------|------------|
| 1  | 1       | PAID       | 2026-01-10 |

### Bảng REFUNDS (Trước Khi Thực Thi)
| id | payment_id | refund_amount | status |
|----|------------|---------------|--------|
| (Trống) ||||

---

## B4: Thực Thi Câu Lệnh

### Test Case - Hoàn tiền hợp lệ
```sql
INSERT INTO REFUNDS(payment_id, refund_amount, status, reason, approved_by, created_at)
VALUES (1, 1000000, 'APPROVED', 'Khách hủy phòng', 1, GETDATE());
```

---

## B5: Kết Quả Sau Thực Thi

### Bảng REFUNDS (Sau Khi Thực Thi)
| id | payment_id | refund_amount | status | reason | approved_by | created_at |
|----|------------|---------------|--------|--------|-------------|------------|
| **1** | **1** | **1000000** | **APPROVED** | **Khách hủy phòng** | **1** | **2026-01-17 16:00** |

### Bảng PAYMENTS (Sau Khi Thực Thi)
| id | booking_id | amount | status | created_at |
|----|------------|--------|--------|------------|
| 1  | 1          | 1000000| **REFUNDED** ← Tự động cập nhật | 2026-01-15 |

### Bảng DATPHONG (Sau Khi Thực Thi)
| id | user_id | trang_thai | created_at |
|----|---------|------------|------------|
| 1  | 1       | **REFUNDED** ← Tự động cập nhật | 2026-01-10 |

### Nếu Hoàn Tiền Vượt Quá
```sql
-- Thử hoàn 1500000 (vượt quá 1000000 đã trả)
INSERT INTO REFUNDS(payment_id, refund_amount, status, reason, approved_by, created_at)
VALUES (1, 1500000, 'APPROVED', 'Test', 1, GETDATE());
```

**Kết quả:** ❌ Error: Refund vượt quá thanh toán

---

## Kết Luận

Trigger này:
- ✅ Đảm bảo hoàn tiền không vượt quá số đã trả
- ✅ Tự động đồng bộ trạng thái 3 bảng
- ✅ Ngăn chặn gian lận hoàn tiền
