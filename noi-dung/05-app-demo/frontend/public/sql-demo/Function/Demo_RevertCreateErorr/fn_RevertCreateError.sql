
-- Xóa function cũ nếu có để tạo mới không bị lỗi
IF OBJECT_ID('dbo.fn_TinhTongTien', 'FN') IS NOT NULL DROP FUNCTION dbo.fn_TinhTongTien;
IF OBJECT_ID('dbo.fn_KiemTraPhongTrong', 'FN') IS NOT NULL DROP FUNCTION dbo.fn_KiemTraPhongTrong;
IF OBJECT_ID('dbo.fn_TaoMaDatPhong', 'FN') IS NOT NULL DROP FUNCTION dbo.fn_TaoMaDatPhong;
GO

/* ============================================================
   FUNCTION 1: TÍNH TỔNG TIỀN 
   - Input: ID của Đặt phòng
   - Output: Tổng tiền (Tính theo số ngày ở * Đơn giá phòng)
   ============================================================ */
CREATE OR ALTER FUNCTION dbo.fn_TinhTongTien (@DatPhongID INT)
RETURNS DECIMAL(18, 0)
AS
BEGIN
    DECLARE @TongTien DECIMAL(18, 0);

    SELECT @TongTien = SUM(
        ct.don_gia * (
            CASE 
                -- Nếu check_in trùng check_out tính là 1 ngày
                WHEN DATEDIFF(DAY, dp.check_in, dp.check_out) = 0 THEN 1 
                ELSE DATEDIFF(DAY, dp.check_in, dp.check_out) 
            END
        )
    )
    FROM dbo.DATPHONG dp
    JOIN dbo.CT_DATPHONG ct ON dp.id = ct.datphong_id
    WHERE dp.id = @DatPhongID;

    RETURN ISNULL(@TongTien, 0);
END
GO
