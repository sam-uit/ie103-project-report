-- ============================================
-- TEST CASES CHO CÁC STORED PROCEDURE MỚI
-- Dựa trên dữ liệu mẫu từ seed_data.sql
-- ============================================

-- ============================================
-- 1. TEST CASES CHO SP_TAO_DANH_GIA
-- ============================================

PRINT N'========================================';
PRINT N'1. TEST CASES CHO SP_TAO_DANH_GIA';
PRINT N'========================================';
GO

-- Test Case 1.1: Tạo đánh giá thành công (Booking đã COMPLETED và đã thanh toán)
-- Booking ID 1: User 1, đã COMPLETED, đã thanh toán SUCCESS, check_out = '2024-01-08 12:00:00'
PRINT N'';
PRINT N'Test Case 1.1: Tạo đánh giá thành công cho Booking ID 1';
PRINT N'Điều kiện: Booking đã COMPLETED, đã thanh toán SUCCESS, đã check-out';
GO

DECLARE @UserId1 INT = 1;
DECLARE @DatPhongId1 INT = 1;

EXEC SP_TAO_DANH_GIA
    @UserId = @UserId1,
    @DatPhongId = @DatPhongId1,
    @SoSao = 5,
    @BinhLuan = N'Phòng rất đẹp và sạch sẽ, nhân viên phục vụ nhiệt tình!';
GO

-- Test Case 1.2: Tạo đánh giá thành công khác (Booking ID 2)
-- Booking ID 2: User 2, đã COMPLETED, đã thanh toán SUCCESS
PRINT N'';
PRINT N'Test Case 1.2: Tạo đánh giá thành công cho Booking ID 2';
GO

DECLARE @UserId2 INT = 2;
DECLARE @DatPhongId2 INT = 2;

EXEC SP_TAO_DANH_GIA
    @UserId = @UserId2,
    @DatPhongId = @DatPhongId2,
    @SoSao = 4,
    @BinhLuan = N'Dịch vụ tốt, giá cả hợp lý. Sẽ quay lại lần sau!';
GO

-- Test Case 1.3: Lỗi - User không tồn tại
PRINT N'';
PRINT N'Test Case 1.3: Lỗi - User không tồn tại';
GO

DECLARE @UserId3 INT = 999;
DECLARE @DatPhongId3 INT = 1;

EXEC SP_TAO_DANH_GIA
    @UserId = @UserId3,
    @DatPhongId = @DatPhongId3,
    @SoSao = 5,
    @BinhLuan = N'Test';
GO

-- Test Case 1.4: Lỗi - Đặt phòng không thuộc user
PRINT N'';
PRINT N'Test Case 1.4: Lỗi - Đặt phòng không thuộc user';
GO

DECLARE @UserId4 INT = 2;
DECLARE @DatPhongId4 INT = 1; -- Booking này thuộc User 1

EXEC SP_TAO_DANH_GIA
    @UserId = @UserId4,
    @DatPhongId = @DatPhongId4,
    @SoSao = 5,
    @BinhLuan = N'Test';
GO

-- Test Case 1.5: Lỗi - Chưa thanh toán (Booking ID 8 - PENDING)
PRINT N'';
PRINT N'Test Case 1.5: Lỗi - Chưa thanh toán (Booking ở trạng thái PENDING)';
GO

DECLARE @UserId5 INT = 8;
DECLARE @DatPhongId5 INT = 8; -- Booking PENDING, chưa thanh toán

EXEC SP_TAO_DANH_GIA
    @UserId = @UserId5,
    @DatPhongId = @DatPhongId5,
    @SoSao = 5,
    @BinhLuan = N'Test';
GO

-- Test Case 1.6: Lỗi - Chưa check-out (Booking ID 5 - CONFIRMED, check_out trong tương lai)
PRINT N'';
PRINT N'Test Case 1.6: Lỗi - Chưa check-out (Booking đang diễn ra)';
GO

DECLARE @UserId6 INT = 5;
DECLARE @DatPhongId6 INT = 5; -- Booking CONFIRMED nhưng check_out = '2024-01-28 12:00:00' (trong tương lai nếu chạy vào tháng 1/2024)

EXEC SP_TAO_DANH_GIA
    @UserId = @UserId6,
    @DatPhongId = @DatPhongId6,
    @SoSao = 5,
    @BinhLuan = N'Test';
GO

-- Test Case 1.7: Lỗi - Đã đánh giá rồi (Booking ID 1 đã có review)
PRINT N'';
PRINT N'Test Case 1.7: Lỗi - Đã đánh giá rồi (Booking đã có review)';
GO

DECLARE @UserId7 INT = 1;
DECLARE @DatPhongId7 INT = 1; -- Booking này đã có review trong seed_data

EXEC SP_TAO_DANH_GIA
    @UserId = @UserId7,
    @DatPhongId = @DatPhongId7,
    @SoSao = 5,
    @BinhLuan = N'Test lại';
GO

-- Test Case 1.8: Lỗi - Số sao không hợp lệ (< 1)
PRINT N'';
PRINT N'Test Case 1.8: Lỗi - Số sao không hợp lệ (< 1)';
GO

DECLARE @UserId8 INT = 3;
DECLARE @DatPhongId8 INT = 3;

EXEC SP_TAO_DANH_GIA
    @UserId = @UserId8,
    @DatPhongId = @DatPhongId8,
    @SoSao = 0,
    @BinhLuan = N'Test';
GO

-- Test Case 1.9: Lỗi - Số sao không hợp lệ (> 5)
PRINT N'';
PRINT N'Test Case 1.9: Lỗi - Số sao không hợp lệ (> 5)';
GO

DECLARE @UserId9 INT = 3;
DECLARE @DatPhongId9 INT = 3;

EXEC SP_TAO_DANH_GIA
    @UserId = @UserId9,
    @DatPhongId = @DatPhongId9,
    @SoSao = 6,
    @BinhLuan = N'Test';
GO

-- Test Case 1.10: Tạo đánh giá không có bình luận (chỉ có số sao)
PRINT N'';
PRINT N'Test Case 1.10: Tạo đánh giá không có bình luận (chỉ có số sao)';
GO

DECLARE @UserId10 INT = 4;
DECLARE @DatPhongId10 INT = 4;

EXEC SP_TAO_DANH_GIA
    @UserId = @UserId10,
    @DatPhongId = @DatPhongId10,
    @SoSao = 5,
    @BinhLuan = NULL;
GO

-- ============================================
-- 2. TEST CASES CHO SP_SU_DUNG_DICH_VU
-- ============================================

PRINT N'';
PRINT N'========================================';
PRINT N'2. TEST CASES CHO SP_SU_DUNG_DICH_VU';
PRINT N'========================================';
GO

-- Test Case 2.1: Sử dụng dịch vụ thành công (Booking CONFIRMED)
-- Booking ID 5: User 5, CONFIRMED, check_in = '2024-01-25 14:00:00', check_out = '2024-01-28 12:00:00'
-- Dịch vụ ID 1: Ăn sáng Buffet, giá 150000
PRINT N'';
PRINT N'Test Case 2.1: Sử dụng dịch vụ thành công - Ăn sáng Buffet';
PRINT N'Điều kiện: Booking CONFIRMED, dịch vụ ACTIVE, trong thời gian lưu trú';
GO

DECLARE @DatPhongId21 INT = 5;
DECLARE @DichVuId21 INT = 1; -- Ăn sáng Buffet
DECLARE @SoLuong21 INT = 2;
DECLARE @ServiceUsageId21 INT;

EXEC SP_SU_DUNG_DICH_VU
    @DatPhongId = @DatPhongId21,
    @DichVuId = @DichVuId21,
    @SoLuong = @SoLuong21,
    @GhiChu = N'Ăn sáng buffet cho 2 người',
    @ServiceUsageId = @ServiceUsageId21 OUTPUT;

SELECT @ServiceUsageId21 AS ServiceUsageId;
GO

-- Test Case 2.2: Sử dụng dịch vụ thành công - Đưa đón sân bay
PRINT N'';
PRINT N'Test Case 2.2: Sử dụng dịch vụ thành công - Đưa đón sân bay';
GO

DECLARE @DatPhongId22 INT = 6;
DECLARE @DichVuId22 INT = 7; -- Đưa đón sân bay
DECLARE @SoLuong22 INT = 1;
DECLARE @ServiceUsageId22 INT;

EXEC SP_SU_DUNG_DICH_VU
    @DatPhongId = @DatPhongId22,
    @DichVuId = @DichVuId22,
    @SoLuong = @SoLuong22,
    @GhiChu = N'Đưa đón sân bay Tân Sơn Nhất',
    @ServiceUsageId = @ServiceUsageId22 OUTPUT;

SELECT @ServiceUsageId22 AS ServiceUsageId;
GO

-- Test Case 2.3: Sử dụng dịch vụ thành công - Massage
PRINT N'';
PRINT N'Test Case 2.3: Sử dụng dịch vụ thành công - Massage body';
GO

DECLARE @DatPhongId23 INT = 13;
DECLARE @DichVuId23 INT = 6; -- Massage body
DECLARE @SoLuong23 INT = 1;
DECLARE @ServiceUsageId23 INT;

EXEC SP_SU_DUNG_DICH_VU
    @DatPhongId = @DatPhongId23,
    @DichVuId = @DichVuId23,
    @SoLuong = @SoLuong23,
    @GhiChu = N'Massage thư giãn 1 giờ',
    @ServiceUsageId = @ServiceUsageId23 OUTPUT;

SELECT @ServiceUsageId23 AS ServiceUsageId;
GO

-- Test Case 2.4: Lỗi - Đặt phòng không tồn tại
PRINT N'';
PRINT N'Test Case 2.4: Lỗi - Đặt phòng không tồn tại';
GO

DECLARE @DatPhongId24 INT = 999;
DECLARE @DichVuId24 INT = 1;
DECLARE @SoLuong24 INT = 1;
DECLARE @ServiceUsageId24 INT;

EXEC SP_SU_DUNG_DICH_VU
    @DatPhongId = @DatPhongId24,
    @DichVuId = @DichVuId24,
    @SoLuong = @SoLuong24,
    @GhiChu = N'Test',
    @ServiceUsageId = @ServiceUsageId24 OUTPUT;
GO

-- Test Case 2.5: Lỗi - Đặt phòng chưa được xác nhận (PENDING)
PRINT N'';
PRINT N'Test Case 2.5: Lỗi - Đặt phòng chưa được xác nhận (PENDING)';
GO

DECLARE @DatPhongId25 INT = 8; -- Booking PENDING
DECLARE @DichVuId25 INT = 1;
DECLARE @SoLuong25 INT = 1;
DECLARE @ServiceUsageId25 INT;

EXEC SP_SU_DUNG_DICH_VU
    @DatPhongId = @DatPhongId25,
    @DichVuId = @DichVuId25,
    @SoLuong = @SoLuong25,
    @GhiChu = N'Test',
    @ServiceUsageId = @ServiceUsageId25 OUTPUT;
GO

-- Test Case 2.6: Lỗi - Dịch vụ không tồn tại
PRINT N'';
PRINT N'Test Case 2.6: Lỗi - Dịch vụ không tồn tại';
GO

DECLARE @DatPhongId26 INT = 5;
DECLARE @DichVuId26 INT = 999;
DECLARE @SoLuong26 INT = 1;
DECLARE @ServiceUsageId26 INT;

EXEC SP_SU_DUNG_DICH_VU
    @DatPhongId = @DatPhongId26,
    @DichVuId = @DichVuId26,
    @SoLuong = @SoLuong26,
    @GhiChu = N'Test',
    @ServiceUsageId = @ServiceUsageId26 OUTPUT;
GO

-- Test Case 2.7: Lỗi - Dịch vụ không còn hoạt động (INACTIVE)
PRINT N'';
PRINT N'Test Case 2.7: Lỗi - Dịch vụ không còn hoạt động (INACTIVE)';
GO

DECLARE @DatPhongId27 INT = 5;
DECLARE @DichVuId27 INT = 14; -- Early checkin - INACTIVE
DECLARE @SoLuong27 INT = 1;
DECLARE @ServiceUsageId27 INT;

EXEC SP_SU_DUNG_DICH_VU
    @DatPhongId = @DatPhongId27,
    @DichVuId = @DichVuId27,
    @SoLuong = @SoLuong27,
    @GhiChu = N'Test',
    @ServiceUsageId = @ServiceUsageId27 OUTPUT;
GO

-- Test Case 2.8: Lỗi - Số lượng không hợp lệ (<= 0)
PRINT N'';
PRINT N'Test Case 2.8: Lỗi - Số lượng không hợp lệ (<= 0)';
GO

DECLARE @DatPhongId28 INT = 5;
DECLARE @DichVuId28 INT = 1;
DECLARE @SoLuong28 INT = 0;
DECLARE @ServiceUsageId28 INT;

EXEC SP_SU_DUNG_DICH_VU
    @DatPhongId = @DatPhongId28,
    @DichVuId = @DichVuId28,
    @SoLuong = @SoLuong28,
    @GhiChu = N'Test',
    @ServiceUsageId = @ServiceUsageId28 OUTPUT;
GO

-- Test Case 2.9: Sử dụng nhiều dịch vụ cùng lúc
PRINT N'';
PRINT N'Test Case 2.9: Sử dụng nhiều dịch vụ cùng lúc cho cùng một booking';
GO

DECLARE @DatPhongId29 INT = 6;
DECLARE @ServiceUsageId29 INT;

-- Sử dụng Ăn sáng Buffet
EXEC SP_SU_DUNG_DICH_VU
    @DatPhongId = @DatPhongId29,
    @DichVuId = 1,
    @SoLuong = 2,
    @GhiChu = N'Ăn sáng buffet',
    @ServiceUsageId = @ServiceUsageId29 OUTPUT;

-- Sử dụng Giặt ủi
EXEC SP_SU_DUNG_DICH_VU
    @DatPhongId = @DatPhongId29,
    @DichVuId = 5,
    @SoLuong = 3,
    @GhiChu = N'Giặt ủi 3kg',
    @ServiceUsageId = @ServiceUsageId29 OUTPUT;

-- Sử dụng Minibar
EXEC SP_SU_DUNG_DICH_VU
    @DatPhongId = @DatPhongId29,
    @DichVuId = 12,
    @SoLuong = 1,
    @GhiChu = N'Minibar',
    @ServiceUsageId = @ServiceUsageId29 OUTPUT;

SELECT @ServiceUsageId29 AS LastServiceUsageId;
GO

-- ============================================
-- 3. TEST CASES CHO SP_AP_DUNG_VOUCHER
-- ============================================

PRINT N'';
PRINT N'========================================';
PRINT N'3. TEST CASES CHO SP_AP_DUNG_VOUCHER';
PRINT N'========================================';
GO

-- Test Case 3.1: Áp dụng voucher thành công - SUMMER2024
-- Booking ID 9: User 9, PENDING, chưa có voucher
-- Voucher SUMMER2024: 15% giảm, tối thiểu 1,000,000, còn hạn đến 2024-08-31
PRINT N'';
PRINT N'Test Case 3.1: Áp dụng voucher thành công - SUMMER2024 (15% giảm)';
PRINT N'Điều kiện: Booking PENDING, voucher ACTIVE, còn hạn, tổng tiền đạt mức tối thiểu';
GO

DECLARE @DatPhongId31 INT = 9;
DECLARE @VoucherCode31 NVARCHAR(50) = 'SUMMER2024';
DECLARE @TongTienPhong31 DECIMAL(18,2);
DECLARE @TienGiam31 DECIMAL(18,2);
DECLARE @TongTienSauGiam31 DECIMAL(18,2);

EXEC SP_AP_DUNG_VOUCHER
    @DatPhongId = @DatPhongId31,
    @VoucherCode = @VoucherCode31,
    @TongTienPhong = @TongTienPhong31 OUTPUT,
    @TienGiam = @TienGiam31 OUTPUT,
    @TongTienSauGiam = @TongTienSauGiam31 OUTPUT;

SELECT
    @TongTienPhong31 AS TongTienPhong,
    @TienGiam31 AS TienGiam,
    @TongTienSauGiam31 AS TongTienSauGiam;
GO

-- Test Case 3.2: Áp dụng voucher thành công - VIP20
-- Booking ID 10: User 10, PENDING, chưa có voucher
-- Voucher VIP20: 20% giảm, tối thiểu 2,000,000
PRINT N'';
PRINT N'Test Case 3.2: Áp dụng voucher thành công - VIP20 (20% giảm)';
GO

DECLARE @DatPhongId32 INT = 10;
DECLARE @VoucherCode32 NVARCHAR(50) = 'VIP20';
DECLARE @TongTienPhong32 DECIMAL(18,2);
DECLARE @TienGiam32 DECIMAL(18,2);
DECLARE @TongTienSauGiam32 DECIMAL(18,2);

EXEC SP_AP_DUNG_VOUCHER
    @DatPhongId = @DatPhongId32,
    @VoucherCode = @VoucherCode32,
    @TongTienPhong = @TongTienPhong32 OUTPUT,
    @TienGiam = @TienGiam32 OUTPUT,
    @TongTienSauGiam = @TongTienSauGiam32 OUTPUT;

SELECT
    @TongTienPhong32 AS TongTienPhong,
    @TienGiam32 AS TienGiam,
    @TongTienSauGiam32 AS TongTienSauGiam;
GO

-- Test Case 3.3: Áp dụng voucher thành công - WELCOME10
-- Booking ID 14: User 2, PENDING, chưa có voucher
-- Voucher WELCOME10: 10% giảm, tối thiểu 500,000
PRINT N'';
PRINT N'Test Case 3.3: Áp dụng voucher thành công - WELCOME10 (10% giảm)';
GO

DECLARE @DatPhongId33 INT = 14;
DECLARE @VoucherCode33 NVARCHAR(50) = 'WELCOME10';
DECLARE @TongTienPhong33 DECIMAL(18,2);
DECLARE @TienGiam33 DECIMAL(18,2);
DECLARE @TongTienSauGiam33 DECIMAL(18,2);

EXEC SP_AP_DUNG_VOUCHER
    @DatPhongId = @DatPhongId33,
    @VoucherCode = @VoucherCode33,
    @TongTienPhong = @TongTienPhong33 OUTPUT,
    @TienGiam = @TienGiam33 OUTPUT,
    @TongTienSauGiam = @TongTienSauGiam33 OUTPUT;

SELECT
    @TongTienPhong33 AS TongTienPhong,
    @TienGiam33 AS TienGiam,
    @TongTienSauGiam33 AS TongTienSauGiam;
GO

-- Test Case 3.4: Lỗi - Đặt phòng không tồn tại
PRINT N'';
PRINT N'Test Case 3.4: Lỗi - Đặt phòng không tồn tại';
GO

DECLARE @DatPhongId34 INT = 999;
DECLARE @VoucherCode34 NVARCHAR(50) = 'SUMMER2024';
DECLARE @TongTienPhong34 DECIMAL(18,2);
DECLARE @TienGiam34 DECIMAL(18,2);
DECLARE @TongTienSauGiam34 DECIMAL(18,2);

EXEC SP_AP_DUNG_VOUCHER
    @DatPhongId = @DatPhongId34,
    @VoucherCode = @VoucherCode34,
    @TongTienPhong = @TongTienPhong34 OUTPUT,
    @TienGiam = @TienGiam34 OUTPUT,
    @TongTienSauGiam = @TongTienSauGiam34 OUTPUT;
GO

-- Test Case 3.5: Lỗi - Đặt phòng đã được áp dụng voucher
PRINT N'';
PRINT N'Test Case 3.5: Lỗi - Đặt phòng đã được áp dụng voucher';
GO

-- Sau khi chạy Test Case 3.1, booking 9 đã có voucher
DECLARE @DatPhongId35 INT = 9;
DECLARE @VoucherCode35 NVARCHAR(50) = 'WELCOME10';
DECLARE @TongTienPhong35 DECIMAL(18,2);
DECLARE @TienGiam35 DECIMAL(18,2);
DECLARE @TongTienSauGiam35 DECIMAL(18,2);

EXEC SP_AP_DUNG_VOUCHER
    @DatPhongId = @DatPhongId35,
    @VoucherCode = @VoucherCode35,
    @TongTienPhong = @TongTienPhong35 OUTPUT,
    @TienGiam = @TienGiam35 OUTPUT,
    @TongTienSauGiam = @TongTienSauGiam35 OUTPUT;
GO

-- Test Case 3.6: Lỗi - Đặt phòng không ở trạng thái PENDING
PRINT N'';
PRINT N'Test Case 3.6: Lỗi - Đặt phòng không ở trạng thái PENDING (CONFIRMED)';
GO

DECLARE @DatPhongId36 INT = 5; -- Booking CONFIRMED
DECLARE @VoucherCode36 NVARCHAR(50) = 'SUMMER2024';
DECLARE @TongTienPhong36 DECIMAL(18,2);
DECLARE @TienGiam36 DECIMAL(18,2);
DECLARE @TongTienSauGiam36 DECIMAL(18,2);

EXEC SP_AP_DUNG_VOUCHER
    @DatPhongId = @DatPhongId36,
    @VoucherCode = @VoucherCode36,
    @TongTienPhong = @TongTienPhong36 OUTPUT,
    @TienGiam = @TienGiam36 OUTPUT,
    @TongTienSauGiam = @TongTienSauGiam36 OUTPUT;
GO

-- Test Case 3.7: Lỗi - Mã voucher không tồn tại
PRINT N'';
PRINT N'Test Case 3.7: Lỗi - Mã voucher không tồn tại';
GO

DECLARE @DatPhongId37 INT = 15;
DECLARE @VoucherCode37 NVARCHAR(50) = 'INVALID_CODE';
DECLARE @TongTienPhong37 DECIMAL(18,2);
DECLARE @TienGiam37 DECIMAL(18,2);
DECLARE @TongTienSauGiam37 DECIMAL(18,2);

EXEC SP_AP_DUNG_VOUCHER
    @DatPhongId = @DatPhongId37,
    @VoucherCode = @VoucherCode37,
    @TongTienPhong = @TongTienPhong37 OUTPUT,
    @TienGiam = @TienGiam37 OUTPUT,
    @TongTienSauGiam = @TongTienSauGiam37 OUTPUT;
GO

-- Test Case 3.8: Lỗi - Voucher không còn hoạt động (INACTIVE)
PRINT N'';
PRINT N'Test Case 3.8: Lỗi - Voucher không còn hoạt động (INACTIVE)';
GO

DECLARE @DatPhongId38 INT = 15;
DECLARE @VoucherCode38 NVARCHAR(50) = 'FLASH50'; -- INACTIVE (đã hết lượt)
DECLARE @TongTienPhong38 DECIMAL(18,2);
DECLARE @TienGiam38 DECIMAL(18,2);
DECLARE @TongTienSauGiam38 DECIMAL(18,2);

EXEC SP_AP_DUNG_VOUCHER
    @DatPhongId = @DatPhongId38,
    @VoucherCode = @VoucherCode38,
    @TongTienPhong = @TongTienPhong38 OUTPUT,
    @TienGiam = @TienGiam38 OUTPUT,
    @TongTienSauGiam = @TongTienSauGiam38 OUTPUT;
GO

-- Test Case 3.9: Lỗi - Voucher đã hết hạn
PRINT N'';
PRINT N'Test Case 3.9: Lỗi - Voucher đã hết hạn';
GO

DECLARE @DatPhongId39 INT = 15;
DECLARE @VoucherCode39 NVARCHAR(50) = 'EXPIRED10'; -- Hết hạn 2024-01-01
DECLARE @TongTienPhong39 DECIMAL(18,2);
DECLARE @TienGiam39 DECIMAL(18,2);
DECLARE @TongTienSauGiam39 DECIMAL(18,2);

EXEC SP_AP_DUNG_VOUCHER
    @DatPhongId = @DatPhongId39,
    @VoucherCode = @VoucherCode39,
    @TongTienPhong = @TongTienPhong39 OUTPUT,
    @TienGiam = @TienGiam39 OUTPUT,
    @TongTienSauGiam = @TongTienSauGiam39 OUTPUT;
GO

-- Test Case 3.10: Lỗi - Voucher đã hết số lần sử dụng
PRINT N'';
PRINT N'Test Case 3.10: Lỗi - Voucher đã hết số lần sử dụng';
GO

DECLARE @DatPhongId310 INT = 15;
DECLARE @VoucherCode310 NVARCHAR(50) = 'FLASH50'; -- so_lan_da_dung = 20, so_lan_toi_da = 20
DECLARE @TongTienPhong310 DECIMAL(18,2);
DECLARE @TienGiam310 DECIMAL(18,2);
DECLARE @TongTienSauGiam310 DECIMAL(18,2);

EXEC SP_AP_DUNG_VOUCHER
    @DatPhongId = @DatPhongId310,
    @VoucherCode = @VoucherCode310,
    @TongTienPhong = @TongTienPhong310 OUTPUT,
    @TienGiam = @TienGiam310 OUTPUT,
    @TongTienSauGiam = @TongTienSauGiam310 OUTPUT;
GO

-- Test Case 3.11: Lỗi - Tổng tiền chưa đạt mức tối thiểu
-- Booking ID 14: Tổng tiền = 800,000 (từ CT_DATPHONG)
-- Voucher VIP20: yêu cầu tối thiểu 2,000,000
PRINT N'';
PRINT N'Test Case 3.11: Lỗi - Tổng tiền chưa đạt mức tối thiểu';
GO

-- Reset booking 14 về trạng thái chưa có voucher (nếu đã áp dụng ở Test Case 3.3)
UPDATE DATPHONG SET voucher_id = NULL WHERE id = 14;
GO

DECLARE @DatPhongId311 INT = 14;
DECLARE @VoucherCode311 NVARCHAR(50) = 'VIP20'; -- Yêu cầu tối thiểu 2,000,000
DECLARE @TongTienPhong311 DECIMAL(18,2);
DECLARE @TienGiam311 DECIMAL(18,2);
DECLARE @TongTienSauGiam311 DECIMAL(18,2);

EXEC SP_AP_DUNG_VOUCHER
    @DatPhongId = @DatPhongId311,
    @VoucherCode = @VoucherCode311,
    @TongTienPhong = @TongTienPhong311 OUTPUT,
    @TienGiam = @TienGiam311 OUTPUT,
    @TongTienSauGiam = @TongTienSauGiam311 OUTPUT;
GO

-- Test Case 3.12: Áp dụng voucher và kiểm tra số lần đã dùng tăng lên
PRINT N'';
PRINT N'Test Case 3.12: Áp dụng voucher và kiểm tra số lần đã dùng tăng lên';
GO

-- Kiểm tra số lần đã dùng trước khi áp dụng
SELECT ma_code, so_lan_da_dung, so_lan_toi_da, trang_thai
FROM VOUCHERS
WHERE ma_code = 'WEEKEND15';
GO

DECLARE @DatPhongId312 INT = 15;
DECLARE @VoucherCode312 NVARCHAR(50) = 'WEEKEND15';
DECLARE @TongTienPhong312 DECIMAL(18,2);
DECLARE @TienGiam312 DECIMAL(18,2);
DECLARE @TongTienSauGiam312 DECIMAL(18,2);

EXEC SP_AP_DUNG_VOUCHER
    @DatPhongId = @DatPhongId312,
    @VoucherCode = @VoucherCode312,
    @TongTienPhong = @TongTienPhong312 OUTPUT,
    @TienGiam = @TienGiam312 OUTPUT,
    @TongTienSauGiam = @TongTienSauGiam312 OUTPUT;

-- Kiểm tra số lần đã dùng sau khi áp dụng
SELECT ma_code, so_lan_da_dung, so_lan_toi_da, trang_thai
FROM VOUCHERS
WHERE ma_code = 'WEEKEND15';
GO

-- ============================================
-- 4. KIỂM TRA KẾT QUẢ SAU KHI CHẠY TEST
-- ============================================

PRINT N'';
PRINT N'========================================';
PRINT N'4. KIỂM TRA KẾT QUẢ SAU KHI CHẠY TEST';
PRINT N'========================================';
GO

-- Kiểm tra các đánh giá mới được tạo
PRINT N'';
PRINT N'4.1. Danh sách các đánh giá mới được tạo:';
SELECT
    r.id,
    r.user_id,
    u.full_name AS ten_user,
    r.datphong_id,
    r.phong_id,
    p.so_phong,
    r.so_sao,
    r.binh_luan,
    r.ngay_danh_gia,
    r.trang_thai
FROM REVIEWS r
JOIN USERS u ON u.id = r.user_id
JOIN PHONG p ON p.id = r.phong_id
ORDER BY r.id DESC;
GO

-- Kiểm tra các dịch vụ mới được sử dụng
PRINT N'';
PRINT N'4.2. Danh sách các dịch vụ mới được sử dụng:';
SELECT
    ct.id,
    ct.datphong_id,
    ct.dichvu_id,
    dv.ten_dich_vu,
    ct.so_luong,
    ct.don_gia,
    ct.so_luong * ct.don_gia AS thanh_tien,
    ct.thoi_diem_su_dung,
    ct.ghi_chu
FROM CT_SUDUNG_DV ct
JOIN DICHVU dv ON dv.id = ct.dichvu_id
ORDER BY ct.id DESC;
GO

-- Kiểm tra các voucher đã được áp dụng
PRINT N'';
PRINT N'4.3. Danh sách các đặt phòng đã áp dụng voucher:';
SELECT
    dp.id AS datphong_id,
    dp.user_id,
    u.full_name AS ten_user,
    dp.voucher_id,
    v.ma_code,
    v.phan_tram_giam,
    dp.check_in,
    dp.check_out,
    dp.trang_thai
FROM DATPHONG dp
LEFT JOIN USERS u ON u.id = dp.user_id
LEFT JOIN VOUCHERS v ON v.id = dp.voucher_id
WHERE dp.voucher_id IS NOT NULL
ORDER BY dp.id DESC;
GO

-- Kiểm tra trạng thái các voucher sau khi sử dụng
PRINT N'';
PRINT N'4.4. Trạng thái các voucher sau khi sử dụng:';
SELECT
    ma_code,
    phan_tram_giam,
    ngay_het_han,
    so_tien_toi_thieu,
    so_lan_toi_da,
    so_lan_da_dung,
    trang_thai,
    CASE
        WHEN so_lan_da_dung >= so_lan_toi_da THEN N'Đã hết lượt'
        WHEN ngay_het_han < CAST(GETDATE() AS DATE) THEN N'Đã hết hạn'
        WHEN trang_thai = 'INACTIVE' THEN N'Không hoạt động'
        ELSE N'Còn sử dụng được'
    END AS tinh_trang
FROM VOUCHERS
ORDER BY ma_code;
GO

PRINT N'';
PRINT N'========================================';
PRINT N'HOÀN TẤT TẤT CẢ TEST CASES';
PRINT N'========================================';
GO
