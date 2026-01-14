# MÔ TẢ CÁC STORED PROCEDURE MỚI

## Tổng quan

Tài liệu này mô tả 3 Stored Procedure mới được tạo để quản lý các chức năng liên quan đến:

- **REVIEWS**: Bảng đánh giá và phản hồi
- **CT_SUDUNG_DV**: Chi tiết sử dụng Dịch Vụ
- **DICHVU**: Dịch vụ
- **VOUCHERS**: Mã giảm giá

## Danh sách Stored Procedures

### 1. SP_TAO_DANH_GIA

- **Chức năng**: Tạo đánh giá cho đặt phòng sau khi đã thanh toán và trả phòng
- **Bảng liên quan**: REVIEWS, USERS, DATPHONG, PAYMENTS, CT_DATPHONG
- **File**: `SP_TAO_DANH_GIA.sql`

### 2. SP_SU_DUNG_DICH_VU

- **Chức năng**: Ghi nhận sử dụng dịch vụ đi kèm trong thời gian lưu trú
- **Bảng liên quan**: CT_SUDUNG_DV, DICHVU, DATPHONG
- **File**: `SP_SU_DUNG_DICH_VU.sql`

### 3. SP_AP_DUNG_VOUCHER

- **Chức năng**: Áp dụng mã giảm giá cho đặt phòng
- **Bảng liên quan**: VOUCHERS, DATPHONG, CT_DATPHONG
- **File**: `SP_AP_DUNG_VOUCHER.sql`

---

## SP_TAO_DANH_GIA

### Mục đích

Cho phép người dùng tạo đánh giá và phản hồi sau khi đã hoàn tất thanh toán và trả phòng.

### Tham số đầu vào

- `@UserId` (INT): ID của người dùng tạo đánh giá
- `@DatPhongId` (INT): ID của đặt phòng cần đánh giá
- `@SoSao` (INT): Số sao đánh giá (1-5)
- `@BinhLuan` (NVARCHAR(1000), tùy chọn): Nội dung bình luận

### Chức năng chính

1. **Kiểm tra điều kiện đánh giá:**
   - User phải tồn tại và ở trạng thái ACTIVE
   - Đặt phòng phải thuộc về user đó
   - Đặt phòng phải đã được thanh toán (trạng thái PAID hoặc SUCCESS)
   - Đặt phòng phải đã check-out (đã trả phòng)
   - Mỗi đặt phòng chỉ được đánh giá một lần

2. **Tạo đánh giá:**
   - Tự động lấy thông tin phòng từ đặt phòng
   - Tạo bản ghi REVIEWS với trạng thái PENDING (chờ duyệt)
   - Ghi nhận ngày đánh giá là ngày hiện tại

### Business Rules áp dụng

- Chỉ những khách hàng đã thanh toán và đã trả phòng mới được đánh giá
- Mỗi đặt phòng chỉ được đánh giá một lần (UNIQUE constraint trên datphong_id)
- Số sao phải từ 1 đến 5 (CHECK constraint)

### Ví dụ sử dụng

```sql
DECLARE @UserId INT = 1;
DECLARE @DatPhongId INT = 10;

EXEC SP_TAO_DANH_GIA
    @UserId = @UserId,
    @DatPhongId = @DatPhongId,
    @SoSao = 5,
    @BinhLuan = N'Phòng rất đẹp, dịch vụ tốt!';
```

### Test Cases chi tiết (dựa trên seed_data.sql)

#### Test Case 1.1: Tạo đánh giá thành công

```sql
-- Booking ID 1: User 1, đã COMPLETED, đã thanh toán SUCCESS, check_out = '2024-01-08 12:00:00'
DECLARE @UserId INT = 1;
DECLARE @DatPhongId INT = 1;

EXEC SP_TAO_DANH_GIA
    @UserId = @UserId,
    @DatPhongId = @DatPhongId,
    @SoSao = 5,
    @BinhLuan = N'Phòng rất đẹp và sạch sẽ, nhân viên phục vụ nhiệt tình!';
```

#### Test Case 1.5: Lỗi - Chưa thanh toán

```sql
-- Booking ID 8: User 8, PENDING, chưa thanh toán
DECLARE @UserId INT = 8;
DECLARE @DatPhongId INT = 8;

EXEC SP_TAO_DANH_GIA
    @UserId = @UserId,
    @DatPhongId = @DatPhongId,
    @SoSao = 5,
    @BinhLuan = N'Test';
-- Kết quả: Lỗi "Chỉ có thể đánh giá sau khi đã thanh toán"
```

### Lỗi có thể xảy ra

- User không tồn tại hoặc không active
- Đặt phòng không tồn tại hoặc không thuộc user
- Chưa thanh toán hoặc chưa trả phòng
- Đã đánh giá rồi
- Số sao không hợp lệ (không trong khoảng 1-5)

---

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

## SP_AP_DUNG_VOUCHER

### Mục đích

Áp dụng mã giảm giá (voucher) cho một đặt phòng và tự động tính toán số tiền giảm giá.

### Tham số đầu vào

- `@DatPhongId` (INT): ID của đặt phòng
- `@VoucherCode` (NVARCHAR(50)): Mã voucher cần áp dụng

### Tham số đầu ra

- `@TongTienPhong` (DECIMAL(18,2)): Tổng tiền phòng trước khi giảm
- `@TienGiam` (DECIMAL(18,2)): Số tiền được giảm
- `@TongTienSauGiam` (DECIMAL(18,2)): Tổng tiền sau khi áp dụng giảm giá

### Chức năng chính

1. **Kiểm tra điều kiện áp dụng voucher:**
   - Đặt phòng phải tồn tại
   - Đặt phòng chưa được áp dụng voucher nào
   - Đặt phòng phải ở trạng thái PENDING
   - Voucher phải tồn tại và còn active
   - Voucher chưa hết hạn
   - Voucher còn số lần sử dụng

2. **Tính toán giảm giá:**
   - Tính tổng tiền phòng từ CT_DATPHONG
   - Kiểm tra tổng tiền có đạt mức tối thiểu để áp dụng voucher không
   - Tính số tiền giảm dựa trên phần trăm giảm giá
   - Tính tổng tiền sau giảm

3. **Cập nhật dữ liệu:**
   - Gán voucher_id vào đặt phòng
   - Tăng số lần đã dùng của voucher
   - Tự động vô hiệu hóa voucher nếu đã hết số lần sử dụng

### Business Rules áp dụng

- Mỗi đặt phòng chỉ có thể áp dụng tối đa một mã giảm giá
- Mã giảm giá phải còn hạn sử dụng và chưa hết số lượng
- Tổng tiền đặt phòng phải đạt mức tối thiểu để áp dụng voucher
- Chỉ áp dụng được khi đặt phòng ở trạng thái PENDING

### Ví dụ sử dụng

```sql
DECLARE @DatPhongId INT = 10;
DECLARE @VoucherCode NVARCHAR(50) = 'SUMMER2024';
DECLARE @TongTienPhong DECIMAL(18,2);
DECLARE @TienGiam DECIMAL(18,2);
DECLARE @TongTienSauGiam DECIMAL(18,2);

EXEC SP_AP_DUNG_VOUCHER
    @DatPhongId = @DatPhongId,
    @VoucherCode = @VoucherCode,
    @TongTienPhong = @TongTienPhong OUTPUT,
    @TienGiam = @TienGiam OUTPUT,
    @TongTienSauGiam = @TongTienSauGiam OUTPUT;

SELECT
    @TongTienPhong AS TongTienPhong,
    @TienGiam AS TienGiam,
    @TongTienSauGiam AS TongTienSauGiam;
```

### Lỗi có thể xảy ra

- Đặt phòng không tồn tại
- Đặt phòng đã được áp dụng voucher
- Đặt phòng không ở trạng thái PENDING
- Mã voucher không tồn tại
- Voucher không còn hoạt động
- Voucher đã hết hạn
- Voucher đã hết số lần sử dụng
- Tổng tiền chưa đạt mức tối thiểu

### Test Cases chi tiết (dựa trên seed_data.sql)

#### Test Case 3.1: Áp dụng voucher thành công - SUMMER2024

```sql
-- Booking ID 9: User 9, PENDING, chưa có voucher
-- Voucher SUMMER2024: 15% giảm, tối thiểu 1,000,000, còn hạn đến 2024-08-31
DECLARE @DatPhongId INT = 9;
DECLARE @VoucherCode NVARCHAR(50) = 'SUMMER2024';
DECLARE @TongTienPhong DECIMAL(18,2);
DECLARE @TienGiam DECIMAL(18,2);
DECLARE @TongTienSauGiam DECIMAL(18,2);

EXEC SP_AP_DUNG_VOUCHER
    @DatPhongId = @DatPhongId,
    @VoucherCode = @VoucherCode,
    @TongTienPhong = @TongTienPhong OUTPUT,
    @TienGiam = @TienGiam OUTPUT,
    @TongTienSauGiam = @TongTienSauGiam OUTPUT;

SELECT
    @TongTienPhong AS TongTienPhong,
    @TienGiam AS TienGiam,
    @TongTienSauGiam AS TongTienSauGiam;
```

#### Test Case 3.2: Áp dụng voucher thành công - VIP20

```sql
-- Booking ID 10: User 10, PENDING, chưa có voucher
-- Voucher VIP20: 20% giảm, tối thiểu 2,000,000
DECLARE @DatPhongId INT = 10;
DECLARE @VoucherCode NVARCHAR(50) = 'VIP20';
DECLARE @TongTienPhong DECIMAL(18,2);
DECLARE @TienGiam DECIMAL(18,2);
DECLARE @TongTienSauGiam DECIMAL(18,2);

EXEC SP_AP_DUNG_VOUCHER
    @DatPhongId = @DatPhongId,
    @VoucherCode = @VoucherCode,
    @TongTienPhong = @TongTienPhong OUTPUT,
    @TienGiam = @TienGiam OUTPUT,
    @TongTienSauGiam = @TongTienSauGiam OUTPUT;
```

#### Test Case 3.11: Lỗi - Tổng tiền chưa đạt mức tối thiểu

```sql
-- Booking ID 14: Tổng tiền = 800,000
-- Voucher VIP20: yêu cầu tối thiểu 2,000,000
DECLARE @DatPhongId INT = 14;
DECLARE @VoucherCode NVARCHAR(50) = 'VIP20';
DECLARE @TongTienPhong DECIMAL(18,2);
DECLARE @TienGiam DECIMAL(18,2);
DECLARE @TongTienSauGiam DECIMAL(18,2);

EXEC SP_AP_DUNG_VOUCHER
    @DatPhongId = @DatPhongId,
    @VoucherCode = @VoucherCode,
    @TongTienPhong = @TongTienPhong OUTPUT,
    @TienGiam = @TienGiam OUTPUT,
    @TongTienSauGiam = @TongTienSauGiam OUTPUT;
-- Kết quả: Lỗi "Tổng tiền đặt phòng chưa đạt mức tối thiểu để áp dụng voucher"
```

---

## 4. Test Cases đầy đủ

File `TEST_CASES_PROCEDURE.sql` chứa đầy đủ các test cases cho cả 3 PROCEDURE, bao gồm:

### Test Cases cho SP_TAO_DANH_GIA (10 test cases)

1. Không lỗi: Tạo đánh giá thành công (Booking đã COMPLETED và đã thanh toán)
2. Không lỗi: Tạo đánh giá thành công khác
3. Lỗi: - User không tồn tại
4. Lỗi: - Đặt phòng không thuộc user
5. Lỗi: - Chưa thanh toán (Booking ở trạng thái PENDING)
6. Lỗi: - Chưa check-out (Booking đang diễn ra)
7. Lỗi: - Đã đánh giá rồi
8. Lỗi: - Số sao không hợp lệ (< 1)
9. Lỗi: - Số sao không hợp lệ (> 5)
10. Không lỗi: Tạo đánh giá không có bình luận (chỉ có số sao)

### Test Cases cho SP_SU_DUNG_DICH_VU (9 test cases)

1. Không lỗi: Sử dụng dịch vụ thành công - Ăn sáng Buffet
2. Không lỗi: Sử dụng dịch vụ thành công - Đưa đón sân bay
3. Không lỗi: Sử dụng dịch vụ thành công - Massage
4. Lỗi: - Đặt phòng không tồn tại
5. Lỗi: - Đặt phòng chưa được xác nhận (PENDING)
6. Lỗi: - Dịch vụ không tồn tại
7. Lỗi: - Dịch vụ không còn hoạt động (INACTIVE)
8. Lỗi: - Số lượng không hợp lệ (<= 0)
9. Không lỗi: Sử dụng nhiều dịch vụ cùng lúc cho cùng một booking

### Test Cases cho SP_AP_DUNG_VOUCHER (12 test cases)

1. Không lỗi: Áp dụng voucher thành công - SUMMER2024 (15% giảm)
2. Không lỗi: Áp dụng voucher thành công - VIP20 (20% giảm)
3. Không lỗi: Áp dụng voucher thành công - WELCOME10 (10% giảm)
4. Lỗi: - Đặt phòng không tồn tại
5. Lỗi: - Đặt phòng đã được áp dụng voucher
6. Lỗi: - Đặt phòng không ở trạng thái PENDING (CONFIRMED)
7. Lỗi: - Mã voucher không tồn tại
8. Lỗi: - Voucher không còn hoạt động (INACTIVE)
9. Lỗi: - Voucher đã hết hạn
10. Lỗi: - Voucher đã hết số lần sử dụng
11. Lỗi: - Tổng tiền chưa đạt mức tối thiểu
12. Không lỗi: Áp dụng voucher và kiểm tra số lần đã dùng tăng lên

---
