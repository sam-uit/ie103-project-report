CREATE OR ALTER FUNCTION dbo.fn_TinhPhiHuyPhong (@MaDatPhong INT, @NgayBaoHuy DATETIME)
RETURNS DECIMAL(18, 0)
AS
BEGIN
    DECLARE @PhiPhat DECIMAL(18, 0) = 0;
    DECLARE @TongTienCoc DECIMAL(18, 0);
    DECLARE @NgayCheckIn DATETIME;
    DECLARE @SoNgayTruocCheckIn INT;

    -- Lấy thông tin ngày check-in và tổng tiền
    SELECT 
        @NgayCheckIn = dp.check_in,
        @TongTienCoc = (SELECT SUM(don_gia) FROM dbo.CT_DATPHONG WHERE datphong_id = @MaDatPhong)
    FROM dbo.DATPHONG dp
    WHERE dp.id = @MaDatPhong;

    IF @NgayCheckIn IS NULL RETURN 0;

    -- Tính số ngày chênh lệch
    SET @SoNgayTruocCheckIn = DATEDIFF(DAY, @NgayBaoHuy, @NgayCheckIn);

    -- Logic tính phí
    IF @SoNgayTruocCheckIn >= 3 
        SET @PhiPhat = 0;                  -- Miễn phí
    ELSE IF @SoNgayTruocCheckIn >= 1 
        SET @PhiPhat = @TongTienCoc * 0.5; -- Phạt 50%
    ELSE 
        SET @PhiPhat = @TongTienCoc;       -- Phạt 100%

    RETURN ISNULL(@PhiPhat, 0);
END
GO
