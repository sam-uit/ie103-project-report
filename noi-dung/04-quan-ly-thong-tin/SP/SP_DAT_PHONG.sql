CREATE PROCEDURE SP_DAT_PHONG
(
    @UserId INT,
    @PhongId INT,
    @CheckIn DATETIME,
    @CheckOut DATETIME,
    @BookingId INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
  
        IF @CheckIn >= @CheckOut
        BEGIN
            RAISERROR(N'Check-in phải nhỏ hơn Check-out', 16, 1);
            RETURN;
        END

        IF NOT EXISTS (
            SELECT 1 FROM USERS
            WHERE id = @UserId AND status = 'ACTIVE'
        )
        BEGIN
            RAISERROR(N'User không tồn tại hoặc không active', 16, 1);
            RETURN;
        END

        IF NOT EXISTS (
            SELECT 1 FROM PHONG WHERE id = @PhongId
        )
        BEGIN
            RAISERROR(N'Phòng không tồn tại', 16, 1);
            RETURN;
        END


        IF EXISTS (
            SELECT 1
            FROM CT_DATPHONG ct
            JOIN DATPHONG dp ON dp.id = ct.datphong_id
            WHERE ct.phong_id = @PhongId
              AND dp.trang_thai IN ('PENDING', 'CONFIRMED')
              AND @CheckIn < dp.check_out
              AND @CheckOut > dp.check_in
        )
        BEGIN
            RAISERROR(N'Phòng đã được đặt trong khoảng thời gian này', 16, 1);
            RETURN;
        END


        BEGIN TRAN;

        --Insert DATPHONG
        INSERT INTO DATPHONG (user_id, check_in, check_out, trang_thai)
        VALUES (@UserId, @CheckIn, @CheckOut, 'PENDING');

        SET @BookingId = SCOPE_IDENTITY();

        --Insert CT_DATPHONG
        INSERT INTO CT_DATPHONG (datphong_id, phong_id, don_gia)
        SELECT
            @BookingId,
            p.id,
            lp.gia_co_ban
        FROM PHONG p
        JOIN LOAIPHONG lp ON lp.id = p.loai_phong_id
        WHERE p.id = @PhongId;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrSeverity INT = ERROR_SEVERITY();

        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END;
GO
