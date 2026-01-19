--Cursor 2: Kiểm tra và cập nhật trạng thái Voucher hàng loạt
--Dựa trên tệp LÊ ANH VŨ - SP_AP_DUNG_VOUCHER.sql, voucher sẽ bị vô hiệu hóa khi hết số lần sử dụng. Cursor này đóng vai trò là một tiến 
--trình bảo trì dữ liệu, duyệt qua bảng VOUCHERS để cập nhật trạng thái INACTIVE cho những mã đã đạt giới hạn so_lan_toi_da

DECLARE @VoucherId INT, 
        @MaCode NVARCHAR(50), 
        @SoLanDung INT, 
        @SoLanToiDa INT;

-- Khai báo Cursor lấy các Voucher còn đang ACTIVE 
DECLARE cur_BaoTriVoucher CURSOR FOR 
    SELECT id, ma_code, so_lan_da_dung, so_lan_toi_da 
    FROM VOUCHERS
    WHERE trang_thai = 'ACTIVE';

OPEN cur_BaoTriVoucher;

FETCH NEXT FROM cur_BaoTriVoucher INTO @VoucherId, @MaCode, @SoLanDung, @SoLanToiDa;

PRINT N'--- ĐANG KIỂM TRA ĐIỀU KIỆN VOUCHER ---';

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Kiểm tra nếu số lần đã dùng đạt giới hạn tối đa 
    IF @SoLanDung >= @SoLanToiDa
    BEGIN
        UPDATE VOUCHERS 
        SET trang_thai = 'INACTIVE', updated_at = GETDATE() 
        WHERE id = @VoucherId;

        PRINT N'Voucher [' + @MaCode + N'] đã hết lượt dùng. Cập nhật trạng thái: INACTIVE';
    END
    ELSE
    BEGIN
        PRINT N'Voucher [' + @MaCode + N'] vẫn hợp lệ (' + CAST(@SoLanDung AS VARCHAR) + '/' + CAST(@SoLanToiDa AS VARCHAR) + ')';
    END

    FETCH NEXT FROM cur_BaoTriVoucher INTO @VoucherId, @MaCode, @SoLanDung, @SoLanToiDa;
END

CLOSE cur_BaoTriVoucher;
DEALLOCATE cur_BaoTriVoucher;