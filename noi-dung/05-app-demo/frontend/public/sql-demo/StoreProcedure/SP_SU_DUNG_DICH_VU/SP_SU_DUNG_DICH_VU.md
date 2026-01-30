## SP_SU_DUNG_DICH_VU

### Mục đích

Ghi nhận việc khách hàng sử dụng dịch vụ đi kèm (ăn sáng, giặt ủi, đưa đón sân bay, v.v.) trong thời gian lưu trú.

### Tham số đầu vào

- `@DatPhongId` (INT): ID của đặt phòng
- `@DichVuId` (INT): ID của dịch vụ được sử dụng
- `@SoLuong` (INT, mặc định = 1): Số lượng dịch vụ
- `@GhiChu` (NVARCHAR(500), tùy chọn): Ghi chú về việc sử dụng dịch vụ
- `@ServiceUsageId` (INT OUTPUT): ID của bản ghi sử dụng dịch vụ vừa tạo

### Chức năng chính

1. **Kiểm tra điều kiện:**
   - Đặt phòng phải tồn tại
   - Đặt phòng phải ở trạng thái CONFIRMED (đã xác nhận)
   - Dịch vụ phải tồn tại và ở trạng thái ACTIVE
   - Số lượng phải lớn hơn 0
   - Thời điểm sử dụng dịch vụ phải trong khoảng thời gian check-in và check-out

2. **Ghi nhận sử dụng dịch vụ:**
   - Lấy đơn giá hiện tại của dịch vụ (để lưu lại giá tại thời điểm sử dụng)
   - Tạo bản ghi CT_SUDUNG_DV với thời điểm sử dụng là thời điểm hiện tại
   - Trả về ID của bản ghi vừa tạo

### Business Rules áp dụng

- Khách hàng có thể gọi dịch vụ đi kèm bất cứ lúc nào trong thời gian lưu trú
- Mỗi lần gọi dịch vụ được ghi nhận riêng biệt
- Đơn giá được lưu lại tại thời điểm sử dụng (tránh thay đổi giá sau này ảnh hưởng đến hóa đơn)

### Ví dụ sử dụng

```sql
DECLARE @DatPhongId INT = 10;
DECLARE @DichVuId INT = 1; -- Ví dụ: Ăn sáng
DECLARE @SoLuong INT = 2;
DECLARE @ServiceUsageId INT;

EXEC SP_SU_DUNG_DICH_VU
    @DatPhongId = @DatPhongId,
    @DichVuId = @DichVuId,
    @SoLuong = @SoLuong,
    @GhiChu = N'Ăn sáng cho 2 người',
    @ServiceUsageId = @ServiceUsageId OUTPUT;

SELECT @ServiceUsageId AS ServiceUsageId;
```

### Test Cases chi tiết (dựa trên seed_data.sql)

#### Test Case 2.1: Sử dụng dịch vụ thành công - Ăn sáng Buffet

```sql
-- Booking ID 5: User 5, CONFIRMED, check_in = '2024-01-25 14:00:00', check_out = '2024-01-28 12:00:00'
-- Dịch vụ ID 1: Ăn sáng Buffet, giá 150000
DECLARE @DatPhongId INT = 5;
DECLARE @DichVuId INT = 1;
DECLARE @SoLuong INT = 2;
DECLARE @ServiceUsageId INT;

EXEC SP_SU_DUNG_DICH_VU
    @DatPhongId = @DatPhongId,
    @DichVuId = @DichVuId,
    @SoLuong = @SoLuong,
    @GhiChu = N'Ăn sáng buffet cho 2 người',
    @ServiceUsageId = @ServiceUsageId OUTPUT;

SELECT @ServiceUsageId AS ServiceUsageId;
```

#### Test Case 2.5: Lỗi - Đặt phòng chưa được xác nhận

```sql
-- Booking ID 8: PENDING, chưa được xác nhận
DECLARE @DatPhongId INT = 8;
DECLARE @DichVuId INT = 1;
DECLARE @SoLuong INT = 1;
DECLARE @ServiceUsageId INT;

EXEC SP_SU_DUNG_DICH_VU
    @DatPhongId = @DatPhongId,
    @DichVuId = @DichVuId,
    @SoLuong = @SoLuong,
    @GhiChu = N'Test',
    @ServiceUsageId = @ServiceUsageId OUTPUT;
-- Kết quả: Lỗi "Chỉ có thể sử dụng dịch vụ khi đặt phòng đã được xác nhận"
```

#### Test Case 2.9: Sử dụng nhiều dịch vụ cùng lúc

```sql
-- Booking ID 6: Sử dụng nhiều dịch vụ khác nhau
DECLARE @DatPhongId INT = 6;
DECLARE @ServiceUsageId INT;

-- Sử dụng Ăn sáng Buffet
EXEC SP_SU_DUNG_DICH_VU
    @DatPhongId = @DatPhongId,
    @DichVuId = 1,
    @SoLuong = 2,
    @GhiChu = N'Ăn sáng buffet',
    @ServiceUsageId = @ServiceUsageId OUTPUT;

-- Sử dụng Giặt ủi
EXEC SP_SU_DUNG_DICH_VU
    @DatPhongId = @DatPhongId,
    @DichVuId = 5,
    @SoLuong = 3,
    @GhiChu = N'Giặt ủi 3kg',
    @ServiceUsageId = @ServiceUsageId OUTPUT;

-- Sử dụng Minibar
EXEC SP_SU_DUNG_DICH_VU
    @DatPhongId = @DatPhongId,
    @DichVuId = 12,
    @SoLuong = 1,
    @GhiChu = N'Minibar',
    @ServiceUsageId = @ServiceUsageId OUTPUT;
```

### Lỗi có thể xảy ra

- Đặt phòng không tồn tại
- Đặt phòng chưa được xác nhận
- Dịch vụ không tồn tại hoặc không còn hoạt động
- Số lượng không hợp lệ
- Thời điểm sử dụng không trong khoảng thời gian lưu trú

---
