-- SP_SU_DUNG_DICH_VU.sql
-- Chức năng: Ghi nhận sử dụng dịch vụ đi kèm trong thời gian lưu trú
-- Bảng liên quan: CT_SUDUNG_DV, DICHVU
-- Đặc điểm:
---- Chỉ cho phép khi đặt phòng đã CONFIRMED
---- Kiểm tra thời điểm sử dụng trong khoảng check-in/check-out
---- Lưu đơn giá tại thời điểm sử dụng
---- Trả về ID của bản ghi vừa tạo

CREATE OR ALTER PROCEDURE SP_SU_DUNG_DICH_VU
(
    @DatPhongId INT,
    @DichVuId INT,
    @SoLuong INT = 1,
    @GhiChu NVARCHAR(500) = NULL,
    @ServiceUsageId INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Kiểm tra đặt phòng có tồn tại không
        IF NOT EXISTS (
            SELECT 1 FROM DATPHONG
            WHERE id = @DatPhongId
        )
        BEGIN
            RAISERROR(N'Đặt phòng không tồn tại', 16, 1);
            RETURN;
        END

        -- Kiểm tra đặt phòng đã được xác nhận chưa (CONFIRMED)
        IF NOT EXISTS (
            SELECT 1 FROM DATPHONG
            WHERE id = @DatPhongId
              AND trang_thai = 'CONFIRMED'
        )
        BEGIN
            RAISERROR(N'Chỉ có thể sử dụng dịch vụ khi đặt phòng đã được xác nhận', 16, 1);
            RETURN;
        END

        -- Kiểm tra dịch vụ có tồn tại và đang active không
        IF NOT EXISTS (
            SELECT 1 FROM DICHVU
            WHERE id = @DichVuId AND trang_thai = 'ACTIVE'
        )
        BEGIN
            RAISERROR(N'Dịch vụ không tồn tại hoặc không còn hoạt động', 16, 1);
            RETURN;
        END

        -- Kiểm tra số lượng hợp lệ
        IF @SoLuong <= 0
        BEGIN
            RAISERROR(N'Số lượng phải lớn hơn 0', 16, 1);
            RETURN;
        END

        -- Kiểm tra thời điểm sử dụng dịch vụ phải trong khoảng thời gian đặt phòng
        DECLARE @CheckIn DATETIME;
        DECLARE @CheckOut DATETIME;

        SELECT @CheckIn = check_in, @CheckOut = check_out
        FROM DATPHONG
        WHERE id = @DatPhongId;

        DECLARE @ThoiDiemSuDung DATETIME = GETDATE();

        IF @ThoiDiemSuDung < @CheckIn OR @ThoiDiemSuDung > @CheckOut
        BEGIN
            RAISERROR(N'Chỉ có thể sử dụng dịch vụ trong thời gian lưu trú', 16, 1);
            RETURN;
        END

        -- Lấy đơn giá hiện tại của dịch vụ
        DECLARE @DonGia DECIMAL(18,2);
        SELECT @DonGia = don_gia
        FROM DICHVU
        WHERE id = @DichVuId;

        BEGIN TRAN;

        -- Ghi nhận sử dụng dịch vụ
        INSERT INTO CT_SUDUNG_DV (
            datphong_id,
            dichvu_id,
            so_luong,
            don_gia,
            thoi_diem_su_dung,
            ghi_chu
        )
        VALUES (
            @DatPhongId,
            @DichVuId,
            @SoLuong,
            @DonGia,
            @ThoiDiemSuDung,
            @GhiChu
        );

        SET @ServiceUsageId = SCOPE_IDENTITY();

        COMMIT TRAN;

        PRINT N'Dịch vụ đã được ghi nhận sử dụng thành công';
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
