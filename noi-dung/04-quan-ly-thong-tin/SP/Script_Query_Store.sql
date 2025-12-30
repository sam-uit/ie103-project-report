--1 ĐẶT PHÒNG
DECLARE @BookingId INT;
EXEC SP_DAT_PHONG
    @UserId = 1,
    @PhongId = 1,
    @CheckIn = '2025-12-28 14:00',
    @CheckOut = '2025-12-29 12:00',
    @BookingId = @BookingId OUTPUT;
SELECT @BookingId AS BookingId;

--2 THANH TOÁN
DECLARE @PaymentId INT;
EXEC SP_THANH_TOAN
    @BookingId = 2,
    @UserId = 1,
    @Amount = 2500000,
    @Method = 'VNPAY',
    @PaymentId = @PaymentId OUTPUT;
SELECT @PaymentId AS PaymentId;

--3 KIỂM TRA PHÒNG TRỐNG
EXEC SP_CHECK_PHONG_TRONG
    @CheckIn = '2025-02-01 14:00',
    @CheckOut = '2025-02-03 12:00';

--4 HỦY ĐẶT PHÒNG
EXEC SP_HUY_DAT_PHONG
    @BookingId = 2,
    @UserId = 1,
    @LyDo = N'Thay đổi kế hoạch';

--5 HOÀN TIỀN
EXEC SP_HOAN_TIEN
@PaymentId = 20,
@RefundAmount = 1500000,
@AdminId = 1,
@Reason = N'Huỷ booking trước thời hạn';