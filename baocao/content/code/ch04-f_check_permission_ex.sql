CREATE OR ALTER PROCEDURE SP_ADMIN_CANCEL_BOOKING
    @AdminId INT,
    @BookingId INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Gọi F_CHECK_PERMISSION để check quyền cụ thể
    IF dbo.F_CHECK_PERMISSION(@AdminId, 'CANCEL_ANY_BOOKING') = 0
    BEGIN
        RAISERROR(N'Bạn không có quyền thực hiện chức năng này.', 16, 1);
        RETURN;
    END

    UPDATE DATPHONG SET trang_thai = 'CANCELLED' WHERE id = @BookingId;
END;