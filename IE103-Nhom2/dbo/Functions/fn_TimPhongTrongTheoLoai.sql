CREATE   FUNCTION dbo.fn_TimPhongTrongTheoLoai 
(
    @LoaiPhongID INT, 
    @NgayCheckIn DATETIME, 
    @NgayCheckOut DATETIME
)
RETURNS TABLE
AS
RETURN
(
    SELECT p.id, p.so_phong, p.trang_thai
    FROM dbo.PHONG p
    WHERE p.loai_phong_id = @LoaiPhongID
    AND p.id NOT IN (
        -- Tìm phòng bị trùng lịch (đang bận)
        SELECT ct.phong_id
        FROM dbo.DATPHONG dp
        JOIN dbo.CT_DATPHONG ct ON dp.id = ct.datphong_id
        WHERE dp.trang_thai NOT IN ('CANCELLED', 'REFUNDED')
        AND (
            (@NgayCheckIn < dp.check_out AND @NgayCheckOut > dp.check_in)
        )
    )
);
GO

