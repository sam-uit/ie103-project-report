# Demo 2: Tự Động Đơn Giá Khi Đặt Phòng

## B1: Trình Bày Bài Toán

### Mục Đích
Xây dựng **Trigger** để tự động hóa quy trình đặt phòng và đảm bảo tính chính xác của đơn giá.

### Vấn Đề
Khi thêm chi tiết đặt phòng vào bảng `CT_DATPHONG`, cần:
1. **Kiểm tra trạng thái phòng**: Chỉ cho phép đặt phòng có trạng thái `AVAILABLE`
2. **Tự động lấy đơn giá**: Lấy giá từ bảng `LOAIPHONG` thay vì nhập thủ công (tránh sai sót)

### Giải Pháp
Sử dụng **INSTEAD OF Trigger** để:
- Chặn INSERT không hợp lệ (phòng không AVAILABLE)
- Tự động điền `don_gia` từ `LOAIPHONG.gia_co_ban`
- Đảm bảo tính nhất quán của dữ liệu

---

## B2: Câu Truy Vấn SQL

### Tạo Trigger
```sql
CREATE TRIGGER dbo.trg_CTDP_Insert_ValidatePrice
ON dbo.CT_DATPHONG
INSTEAD OF INSERT
AS
BEGIN
    -- Kiểm tra trạng thái phòng
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dbo.PHONG p ON p.id = i.phong_id
        WHERE p.trang_thai <> 'AVAILABLE'
    )
    BEGIN
        RAISERROR (N'Phòng không AVAILABLE nên không đặt được', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Thêm vào CT_DATPHONG với đơn giá tự động
    INSERT INTO dbo.CT_DATPHONG(datphong_id, phong_id, don_gia)
    SELECT  i.datphong_id,
            i.phong_id,
            lp.gia_co_ban
    FROM inserted i
    JOIN dbo.PHONG p      ON p.id = i.phong_id
    JOIN dbo.LOAIPHONG lp ON lp.id = p.loai_phong_id;
END
```

---

## B3: Các Bảng Dữ Liệu Liên Quan

### Bảng PHONG (Trước Khi Thực Thi)
| id | ten_phong | loai_phong_id | trang_thai | gia_hien_tai |
|----|-----------|---------------|------------|--------------|
| 1  | P101      | 1             | BOOKED     | 500000       |
| 2  | P102      | 1             | AVAILABLE  | 500000       |
| 3  | P201      | 2             | AVAILABLE  | 800000       |

### Bảng LOAIPHONG
| id | ten_loai | gia_co_ban | mo_ta |
|----|----------|------------|-------|
| 1  | Standard | 500000     | Phòng tiêu chuẩn |
| 2  | Deluxe   | 800000     | Phòng cao cấp |

### Bảng CT_DATPHONG (Trước Khi Thực Thi)
| id | datphong_id | phong_id | don_gia |
|----|-------------|----------|---------|
| 1  | 1           | 1        | 500000  |

---

## B4: Thực Thi Câu Lệnh

### Test Case
```sql
-- Thử đặt phòng P102 (AVAILABLE)
INSERT INTO CT_DATPHONG(datphong_id, phong_id)
VALUES (2, 2);
```

---

## B5: Kết Quả Sau Thực Thi

### Bảng CT_DATPHONG (Sau Khi Thực Thi)
| id | datphong_id | phong_id | don_gia |
|----|-------------|----------|---------|
| 1  | 1           | 1        | 500000  |
| **2** | **2**   | **2**    | **500000** |

**Lưu ý:** Cột `don_gia` được tự động điền = 500000 (từ LOAIPHONG.gia_co_ban)

### Nếu Thử Đặt Phòng P101 (BOOKED)
```
❌ Error: Phòng không AVAILABLE nên không đặt được
```

---

## Kết Luận

Trigger này:
- ✅ Ngăn chặn đặt phòng không hợp lệ
- ✅ Tự động hóa việc tính giá
- ✅ Giảm thiểu lỗi nhập liệu
