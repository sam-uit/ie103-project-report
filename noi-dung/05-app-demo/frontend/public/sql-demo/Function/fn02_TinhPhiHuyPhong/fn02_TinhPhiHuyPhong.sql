/* ===========================================================
   FUNCTION : Tính Phí Hủy Phòng
   ===========================================================

CREATE FUNCTION dbo.fn_TinhPhiHuyPhong (@MaDatPhong INT, @NgayBaoHuy DATETIME)
RETURNS DECIMAL(18, 0)
AS
BEGIN
    DECLARE @PhiPhat DECIMAL(18, 0) = 0;
    DECLARE @TongTienCoc DECIMAL(18, 0);
    DECLARE @NgayCheckIn DATETIME;
    DECLARE @SoNgayTruocCheckIn INT;

    SELECT 
        @NgayCheckIn = dp.check_in,
        @TongTienCoc = (SELECT SUM(don_gia) FROM dbo.CT_DATPHONG WHERE datphong_id = @MaDatPhong)
    FROM dbo.DATPHONG dp
    WHERE dp.id = @MaDatPhong;

    SET @SoNgayTruocCheckIn = DATEDIFF(DAY, @NgayBaoHuy, @NgayCheckIn);

    IF @SoNgayTruocCheckIn >= 3 SET @PhiPhat = 0;
    ELSE IF @SoNgayTruocCheckIn >= 1 SET @PhiPhat = @TongTienCoc * 0.5;
    ELSE SET @PhiPhat = @TongTienCoc;

    RETURN ISNULL(@PhiPhat, 0);
END
*/

-- ===========================================================
-- KỊCH BẢN TEST
-- ===========================================================
SELECT 
    @BookingID AS [Mã Đơn],
    FORMAT(CAST(@NgayBaoHuy AS DATETIME), 'dd/MM/yyyy') AS [Ngày Báo Hủy],
    FORMAT(dbo.fn_TinhPhiHuyPhong(@BookingID, CAST(@NgayBaoHuy AS DATETIME)), 'N0') + ' VNĐ' AS [💰 SỐ TIỀN PHẠT];