CREATE PROCEDURE SP_THANH_TOAN
(
    @BookingId INT,
    @UserId INT,
    @Amount DECIMAL(18,2),
    @Method NVARCHAR(50),
    @PaymentId INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- kiểm tra đặt phòng theo booking & thuộc user
    IF NOT EXISTS (
        SELECT 1
        FROM DATPHONG
        WHERE id = @BookingId AND user_id = @UserId
    )
    BEGIN
        RAISERROR(N'Booking không tồn tại hoặc không thuộc user', 16, 1);
        RETURN;
    END

    -- Booking phải ở trạng thái PENDING
    IF EXISTS (
        SELECT 1
        FROM DATPHONG
        WHERE id = @BookingId AND trang_thai <> 'PENDING'
    )
    BEGIN
        RAISERROR(N'Booking thất bại, trạng thái không ở trạng thái PENDING', 16, 1);
        RETURN;
    END

    -- Kiểm tra booking đã thanh toán chưa
    IF EXISTS (
        SELECT 1
        FROM PAYMENTS
        WHERE booking_id = @BookingId AND status = 'SUCCESS'
    )
    BEGIN
        RAISERROR(N'Booking đã được thanh toán', 16, 1);
        RETURN;
    END

    BEGIN TRAN;

    -- 2.1 Insert PAYMENT
    INSERT INTO PAYMENTS(booking_id,user_id,amount,method,status)
    VALUES(@BookingId,@UserId,@Amount,@Method,'PAID');

    SET @PaymentId = SCOPE_IDENTITY();

    -- 2.2 Update booking
    UPDATE DATPHONG
    SET trang_thai = 'CONFIRMED'
    WHERE id = @BookingId;

    COMMIT TRAN;
END;
GO
