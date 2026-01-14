-- SP_AP_DUNG_VOUCHER.sql
-- Chức năng: Áp dụng mã giảm giá cho đặt phòng và tính toán giảm giá tự động
-- Bảng liên quan: VOUCHERS
-- Đặc điểm:
---- Kiểm tra voucher còn hạn và còn số lần sử dụng
---- Kiểm tra tổng tiền đạt mức tối thiểu
---- Tính toán tự động số tiền giảm và tổng tiền sau giảm
---- Tự động cập nhật số lần đã dùng và vô hiệu hóa khi hết

CREATE PROCEDURE SP_AP_DUNG_VOUCHER
(
    @DatPhongId INT,
    @VoucherCode NVARCHAR(50),
    @TongTienPhong DECIMAL(18,2) OUTPUT,
    @TienGiam DECIMAL(18,2) OUTPUT,
    @TongTienSauGiam DECIMAL(18,2) OUTPUT
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

        -- Kiểm tra đặt phòng chưa được áp dụng voucher
        IF EXISTS (
            SELECT 1 FROM DATPHONG
            WHERE id = @DatPhongId AND voucher_id IS NOT NULL
        )
        BEGIN
            RAISERROR(N'Đặt phòng này đã được áp dụng voucher', 16, 1);
            RETURN;
        END

        -- Kiểm tra đặt phòng ở trạng thái PENDING
        IF NOT EXISTS (
            SELECT 1 FROM DATPHONG
            WHERE id = @DatPhongId AND trang_thai = 'PENDING'
        )
        BEGIN
            RAISERROR(N'Chỉ có thể áp dụng voucher cho đặt phòng ở trạng thái PENDING', 16, 1);
            RETURN;
        END

        -- Tìm voucher theo mã code
        DECLARE @VoucherId INT;
        DECLARE @PhanTramGiam DECIMAL(5,2);
        DECLARE @NgayHetHan DATE;
        DECLARE @SoTienToiThieu DECIMAL(18,2);
        DECLARE @SoLanToiDa INT;
        DECLARE @SoLanDaDung INT;
        DECLARE @TrangThai NVARCHAR(50);

        SELECT
            @VoucherId = id,
            @PhanTramGiam = phan_tram_giam,
            @NgayHetHan = ngay_het_han,
            @SoTienToiThieu = so_tien_toi_thieu,
            @SoLanToiDa = so_lan_toi_da,
            @SoLanDaDung = so_lan_da_dung,
            @TrangThai = trang_thai
        FROM VOUCHERS
        WHERE ma_code = @VoucherCode;

        -- Kiểm tra voucher có tồn tại không
        IF @VoucherId IS NULL
        BEGIN
            RAISERROR(N'Mã voucher không tồn tại', 16, 1);
            RETURN;
        END

        -- Kiểm tra voucher còn active không
        IF @TrangThai <> 'ACTIVE'
        BEGIN
            RAISERROR(N'Voucher không còn hoạt động', 16, 1);
            RETURN;
        END

        -- Kiểm tra voucher còn hạn không
        IF @NgayHetHan < CAST(GETDATE() AS DATE)
        BEGIN
            RAISERROR(N'Voucher đã hết hạn', 16, 1);
            RETURN;
        END

        -- Kiểm tra voucher còn số lần sử dụng không
        IF @SoLanDaDung >= @SoLanToiDa
        BEGIN
            RAISERROR(N'Voucher đã hết số lần sử dụng', 16, 1);
            RETURN;
        END

        -- Tính tổng tiền phòng từ CT_DATPHONG
        SELECT @TongTienPhong = SUM(don_gia)
        FROM CT_DATPHONG
        WHERE datphong_id = @DatPhongId;

        IF @TongTienPhong IS NULL OR @TongTienPhong = 0
        BEGIN
            RAISERROR(N'Không tìm thấy thông tin giá phòng', 16, 1);
            RETURN;
        END

        -- Kiểm tra tổng tiền có đạt mức tối thiểu không
        IF @TongTienPhong < @SoTienToiThieu
        BEGIN
            RAISERROR(N'Tổng tiền đặt phòng chưa đạt mức tối thiểu để áp dụng voucher', 16, 1);
            RETURN;
        END

        -- Tính tiền giảm và tổng tiền sau giảm
        SET @TienGiam = @TongTienPhong * (@PhanTramGiam / 100.0);
        SET @TongTienSauGiam = @TongTienPhong - @TienGiam;

        BEGIN TRAN;

        -- Cập nhật voucher_id vào đặt phòng
        UPDATE DATPHONG
        SET voucher_id = @VoucherId
        WHERE id = @DatPhongId;

        -- Tăng số lần đã dùng của voucher
        UPDATE VOUCHERS
        SET so_lan_da_dung = so_lan_da_dung + 1,
            updated_at = GETDATE()
        WHERE id = @VoucherId;

        -- Nếu đã hết số lần sử dụng, cập nhật trạng thái
        IF (@SoLanDaDung + 1) >= @SoLanToiDa
        BEGIN
            UPDATE VOUCHERS
            SET trang_thai = 'INACTIVE'
            WHERE id = @VoucherId;
        END

        COMMIT TRAN;

        PRINT N'Voucher đã được áp dụng thành công';
        PRINT N'Tổng tiền phòng: ' + CAST(@TongTienPhong AS NVARCHAR(20));
        PRINT N'Tiền giảm: ' + CAST(@TienGiam AS NVARCHAR(20));
        PRINT N'Tổng tiền sau giảm: ' + CAST(@TongTienSauGiam AS NVARCHAR(20));
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
