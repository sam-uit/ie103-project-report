# Demo 3: Đồng Bộ Trạng Thái Phòng

## B1: Trình Bày Bài Toán

### Mục Đích
Xây dựng **Trigger** để tự động đồng bộ trạng thái phòng khi có thay đổi trong chi tiết đặt phòng.

### Vấn Đề
Khi có thao tác INSERT/UPDATE/DELETE trên bảng `CT_DATPHONG`:
- Phòng được đặt → Cần chuyển trạng thái sang `BOOKED`
- Phòng bị hủy đặt → Cần trả về trạng thái `AVAILABLE`
- Đảm bảo đồng bộ thời gian thực

### Giải Pháp
Sử dụng **AFTER Trigger** với:
- Bảng ảo `inserted`: Phòng vừa được đặt
- Bảng ảo `deleted`: Phòng vừa bị hủy
- Cập nhật trạng thái tự động

---

## B2: Câu Truy Vấn SQL

### Tạo Trigger
```sql
CREATE TRIGGER dbo.trg_CTDP_SyncRoomStatus
ON dbo.CT_DATPHONG
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    -- Có thêm/đổi chi tiết đặt phòng → BOOKED
    UPDATE p
    SET p.trang_thai = 'BOOKED'
    FROM dbo.PHONG p
    JOIN inserted i ON i.phong_id = p.id;

    -- Có xóa/đổi phòng cũ → AVAILABLE (nếu không còn trong CT_DATPHONG)
    UPDATE p
    SET p.trang_thai = 'AVAILABLE'
    FROM dbo.PHONG p
    JOIN deleted d ON d.phong_id = p.id
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.CT_DATPHONG c
        WHERE c.phong_id = p.id
    );
END
```

---

## B3: Các Bảng Dữ Liệu Liên Quan

### Bảng PHONG (Trước Khi Thực Thi)
| id | ten_phong | trang_thai |
|----|-----------|------------|
| 1  | P101      | BOOKED     |
| 2  | P102      | AVAILABLE  |
| 3  | P201      | AVAILABLE  |

### Bảng CT_DATPHONG (Trước Khi Thực Thi)
| id | datphong_id | phong_id |
|----|-------------|----------|
| 1  | 1           | 1        |

---

## B4: Thực Thi Câu Lệnh

### Test Case 1: Thêm đặt phòng
```sql
INSERT INTO CT_DATPHONG(datphong_id, phong_id, don_gia)
VALUES (2, 2, 500000);
```

### Test Case 2: Xóa đặt phòng
```sql
DELETE FROM CT_DATPHONG WHERE phong_id = 1;
```

---

## B5: Kết Quả Sau Thực Thi

### Sau Test Case 1 (INSERT)
**Bảng PHONG:**
| id | ten_phong | trang_thai |
|----|-----------|------------|
| 1  | P101      | BOOKED     |
| 2  | P102      | **BOOKED** ← Tự động chuyển |
| 3  | P201      | AVAILABLE  |

### Sau Test Case 2 (DELETE)
**Bảng PHONG:**
| id | ten_phong | trang_thai |
|----|-----------|------------|
| 1  | P101      | **AVAILABLE** ← Tự động trả về |
| 2  | P102      | BOOKED     |
| 3  | P201      | AVAILABLE  |

---

## Kết Luận

Trigger này:
- ✅ Đồng bộ trạng thái phòng tự động
- ✅ Giảm thiểu lỗi quản lý thủ công
- ✅ Đảm bảo tính nhất quán dữ liệu
