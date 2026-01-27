/* ===========================================================
   Function: Tìm Phòng Trống Theo Loại
   ===========================================================

CREATE FUNCTION dbo.fn_TimPhongTrongTheoLoai 
(
    @LoaiPhongID INT, 
    @NgayCheckIn DATETIME, 
    @NgayCheckOut DATETIME
)
RETURNS TABLE
AS
RETURN
(
    -- Lấy tất cả phòng thuộc loại yêu cầu
    SELECT p.id, p.so_phong, p.trang_thai
    FROM dbo.PHONG p
    WHERE p.loai_phong_id = @LoaiPhongID
    AND p.id NOT IN (
        -- TRỪ ĐI các phòng đang bận (Trùng lịch & chưa hủy)
        SELECT ct.phong_id
        FROM dbo.DATPHONG dp
        JOIN dbo.CT_DATPHONG ct ON dp.id = ct.datphong_id
        WHERE dp.trang_thai NOT IN ('CANCELLED', 'REFUNDED')
        AND (
            (@NgayCheckIn < dp.check_out AND @NgayCheckOut > dp.check_in)
        )
    )
);
*/

-- ===========================================================
-- 2. KỊCH BẢN TEST
-- ===========================================================

-- Tìm các phòng đang trống dựa trên tham số người dùng nhập
SELECT 
    p.id AS [ID Phòng],
    p.so_phong AS [Số Phòng],
    p.trang_thai AS [Trạng Thái Gốc],
    N'✅ Có thể đặt' AS [Kết Luận]
FROM dbo.fn_TimPhongTrongTheoLoai(
    @LoaiPhongID, 
    CAST(@CheckIn AS DATETIME), 
    CAST(@CheckOut AS DATETIME)
) p;