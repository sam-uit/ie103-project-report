CREATE PROCEDURE SP_HOAN_TIEN
(
    @PaymentId INT,
    @RefundAmount DECIMAL(18,2),
    @AdminId INT,
    @Reason NVARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- kiểm tra payment có tồn tại ko
    IF NOT EXISTS (
        SELECT 1
        FROM PAYMENTS
        WHERE id = @PaymentId
          AND status = 'SUCCESS'
    )
    BEGIN
        RAISERROR(N'Payment không tồn tại hoặc chưa thanh toán', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (
        SELECT 1
        FROM ADMINS
        WHERE id = @AdminId
          AND status = 'ACTIVE'
    )
    BEGIN
        RAISERROR(N'Tài khoản không tồn tại', 16, 1);
        RETURN;
    END

    IF @RefundAmount <= 0
    BEGIN
        RAISERROR(N'Số tiền hoàn không hợp lệ', 16, 1);
        RETURN;
    END

    IF EXISTS (
        SELECT 1
        FROM PAYMENTS
        WHERE id = @PaymentId
          AND @RefundAmount > amount
    )
    BEGIN
        RAISERROR(N'Số tiền hoàn vượt quá số tiền đã thanh toán', 16, 1);
        RETURN;
    END

    -- Kiểm tra đã hoàn chưa
    IF EXISTS (
        SELECT 1
        FROM REFUNDS
        WHERE payment_id = @PaymentId
          AND status IN ('APPROVED', 'SUCCESS')
    )
    BEGIN
        RAISERROR(N'Payment này đã được hoàn tiền', 16, 1);
        RETURN;
    END


    BEGIN TRAN;

    INSERT INTO REFUNDS
    (
        payment_id,
        refund_amount,
        status,
        reason,
        approved_by
    )
    VALUES
    (
        @PaymentId,
        @RefundAmount,
        'APPROVED',
        @Reason,
        @AdminId
    );

    UPDATE PAYMENTS
    SET status = 'REFUNDED'
    WHERE id = @PaymentId;

    COMMIT TRAN;
END;
GO
