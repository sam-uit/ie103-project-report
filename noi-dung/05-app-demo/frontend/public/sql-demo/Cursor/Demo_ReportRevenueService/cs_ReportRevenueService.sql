--Cursor 1: Tổng hợp doanh thu chi tiết từng Đặt phòng (Tiền phòng + Dịch vụ)
--Cursor này duyệt qua danh sách các đặt phòng đã hoàn tất để tính toán tổng chi phí (bao gồm tiền phòng từ CT_DATPHONG và tiền dịch vụ 
--từ CT_SUDUNG_DV). Điều này phục vụ cho mục Trình bày thông tin/Report trong đồ án.

DECLARE @BookingId INT, 
        @UserFullName NVARCHAR(100), 
        @TienPhong DECIMAL(18,2), 
        @TienDichVu DECIMAL(18,2),
        @TongCong DECIMAL(18,2);

-- Khai báo Cursor lấy thông tin đặt phòng và tên khách hàng
DECLARE cur_ThongKeDoanhThu CURSOR FOR 
    SELECT dp.id, u.full_name
    FROM DATPHONG dp
    JOIN USERS u ON dp.user_id = u.id;

OPEN cur_ThongKeDoanhThu;

FETCH NEXT FROM cur_ThongKeDoanhThu INTO @BookingId, @UserFullName;

PRINT N'---------- BÁO CÁO CHI PHÍ CHI TIẾT ĐẶT PHÒNG ----------';

WHILE @@FETCH_STATUS = 0
BEGIN
    -- 1. Tính tiền phòng từ bảng CT_DATPHONG [cite: 9]
    SELECT @TienPhong = ISNULL(SUM(don_gia), 0) 
    FROM CT_DATPHONG 
    WHERE datphong_id = @BookingId;

    -- 2. Tính tiền dịch vụ từ bảng CT_SUDUNG_DV [cite: 4]
    SELECT @TienDichVu = ISNULL(SUM(so_luong * don_gia), 0) 
    FROM CT_SUDUNG_DV 
    WHERE datphong_id = @BookingId;

    SET @TongCong = @TienPhong + @TienDichVu;

    PRINT N'Mã Đặt Phòng: ' + CAST(@BookingId AS VARCHAR) + 
          N' | Khách hàng: ' + @UserFullName + 
          N' | Tiền phòng: ' + CAST(@TienPhong AS VARCHAR) + 
          N' | Tiền DV: ' + CAST(@TienDichVu AS VARCHAR) + 
          N' | TỔNG: ' + CAST(@TongCong AS VARCHAR);

    FETCH NEXT FROM cur_ThongKeDoanhThu INTO @BookingId, @UserFullName;
END

CLOSE cur_ThongKeDoanhThu;
DEALLOCATE cur_ThongKeDoanhThu;