CREATE PROCEDURE SP_HUY_DAT_PHONG
(
    @BookingId INT,
    @UserId INT,
    @LyDo NVARCHAR(255) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    --Kiểm tra Booking có tồn tại hoặc thuốc thuộc user
    IF NOT EXISTS (
        SELECT 1
        FROM DATPHONG
        WHERE id = @BookingId
          AND user_id = @UserId
    )
    BEGIN
        RAISERROR(N'Booking không tồn tại hoặc không thuộc user', 16, 1);
        RETURN;
    END

    -- Không cho huỷ nếu đã check-in
    IF EXISTS (
        SELECT 1
        FROM DATPHONG
        WHERE id = @BookingId
          AND check_in <= GETDATE()
    )
    BEGIN
        RAISERROR(N'Không thể huỷ booking đã check-in', 16, 1);
        RETURN;
    END

    -- Chỉ cho huỷ khi PENDING
    IF EXISTS (
        SELECT 1
        FROM DATPHONG
        WHERE id = @BookingId
          AND trang_thai NOT IN ('PENDING')
    )
    BEGIN
        RAISERROR(N'Trạng thái booking không cho phép huỷ', 16, 1);
        RETURN;
    END

    UPDATE DATPHONG
    SET trang_thai = 'CANCELLED'
    WHERE id = @BookingId;
END;
GO
