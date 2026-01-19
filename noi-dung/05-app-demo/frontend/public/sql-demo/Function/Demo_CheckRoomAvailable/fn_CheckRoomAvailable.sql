
/* ============================================================
   FUNCTION 2: KIỂM TRA PHÒNG TRỐNG 
   - Input: ID Phòng, Ngày đến, Ngày đi
   - Output: 1 (Bận), 0 (Trống)
   ============================================================ */
CREATE OR ALTER FUNCTION dbo.fn_KiemTraPhongTrong (@PhongID INT, @NgayCheckIn DATETIME, @NgayCheckOut DATETIME)
RETURNS BIT 
AS
BEGIN
    DECLARE @KetQua BIT;

    IF EXISTS (
        SELECT 1 
        FROM dbo.DATPHONG dp
        JOIN dbo.CT_DATPHONG ct ON dp.id = ct.datphong_id
        WHERE ct.phong_id = @PhongID 
        AND dp.trang_thai != 'CANCELLED' -- Giả sử trạng thái hủy là CANCELLED
        -- Logic: Ngày khách mới đến nằm trong khoảng khách cũ đang ở
        AND (@NgayCheckIn < dp.check_out AND @NgayCheckOut > dp.check_in)
    )
        SET @KetQua = 1; -- Bận
    ELSE
        SET @KetQua = 0; -- Trống

    RETURN @KetQua;
END
GO

/* ============================================================
   FUNCTION 3: TẠO MÃ ĐẶT PHÒNG TỰ ĐỘNG 
   - Input: ID số (VD: 1)
   - Output: Mã chuỗi (VD: BK00001)
   ============================================================ */
CREATE OR ALTER FUNCTION dbo.fn_TaoMaDatPhong (@ID INT)
RETURNS VARCHAR(10)
AS
BEGIN
    -- Thêm số 0 vào trước và gắn tiền tố BK (Booking)
    RETURN 'BK' + RIGHT('00000' + CAST(@ID AS VARCHAR(5)), 5);
END
GO