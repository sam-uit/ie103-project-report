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
