-- SP_TAO_DANH_GIA.sql
-- Chức năng: Tạo đánh giá cho đặt phòng sau khi đã thanh toán và trả phòng
-- Bảng liên quan: REVIEWS
-- Đặc điểm:
---- Kiểm tra đã thanh toán và đã check-out
---- Mỗi đặt phòng chỉ được đánh giá một lần
---- Số sao từ 1-5
---- Tự động lấy thông tin phòng từ đặt phòng

CREATE PROCEDURE SP_TAO_DANH_GIA
(
    @UserId INT,
    @DatPhongId INT,
    @SoSao INT,
    @BinhLuan NVARCHAR(1000) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Kiểm tra User có tồn tại và active không
        IF NOT EXISTS (
            SELECT 1 FROM USERS
            WHERE id = @UserId AND status = 'ACTIVE'
        )
        BEGIN
            RAISERROR(N'User không tồn tại hoặc không active', 16, 1);
            RETURN;
        END

        -- Kiểm tra đặt phòng có tồn tại và thuộc user không
        IF NOT EXISTS (
            SELECT 1 FROM DATPHONG
            WHERE id = @DatPhongId AND user_id = @UserId
        )
        BEGIN
            RAISERROR(N'Đặt phòng không tồn tại hoặc không thuộc user này', 16, 1);
            RETURN;
        END

        -- Kiểm tra đặt phòng đã được thanh toán chưa
        IF NOT EXISTS (
            SELECT 1 FROM PAYMENTS
            WHERE booking_id = @DatPhongId
              AND trang_thai IN ('PAID', 'SUCCESS')
        )
        BEGIN
            RAISERROR(N'Chỉ có thể đánh giá sau khi đã thanh toán', 16, 1);
            RETURN;
        END

        -- Kiểm tra đặt phòng đã check-out chưa (đã trả phòng)
        IF EXISTS (
            SELECT 1 FROM DATPHONG
            WHERE id = @DatPhongId
              AND check_out > GETDATE()
        )
        BEGIN
            RAISERROR(N'Chỉ có thể đánh giá sau khi đã trả phòng', 16, 1);
            RETURN;
        END

        -- Kiểm tra đã đánh giá chưa (mỗi đặt phòng chỉ được đánh giá một lần)
        IF EXISTS (
            SELECT 1 FROM REVIEWS
            WHERE datphong_id = @DatPhongId
        )
        BEGIN
            RAISERROR(N'Đặt phòng này đã được đánh giá', 16, 1);
            RETURN;
        END

        -- Kiểm tra số sao hợp lệ (1-5)
        IF @SoSao < 1 OR @SoSao > 5
        BEGIN
            RAISERROR(N'Số sao phải từ 1 đến 5', 16, 1);
            RETURN;
        END

        -- Lấy thông tin phòng từ đặt phòng
        DECLARE @PhongId INT;
        SELECT TOP 1 @PhongId = ct.phong_id
        FROM CT_DATPHONG ct
        WHERE ct.datphong_id = @DatPhongId;

        IF @PhongId IS NULL
        BEGIN
            RAISERROR(N'Không tìm thấy thông tin phòng trong đặt phòng', 16, 1);
            RETURN;
        END

        BEGIN TRAN;

        -- Tạo đánh giá mới
        INSERT INTO REVIEWS (
            user_id,
            phong_id,
            datphong_id,
            so_sao,
            binh_luan,
            ngay_danh_gia,
            trang_thai
        )
        VALUES (
            @UserId,
            @PhongId,
            @DatPhongId,
            @SoSao,
            @BinhLuan,
            CAST(GETDATE() AS DATE),
            'PENDING'
        );

        COMMIT TRAN;

        PRINT N'Đánh giá đã được tạo thành công và đang chờ duyệt';
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
