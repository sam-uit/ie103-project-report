-- FN-01: Tính Hạng Thành Viên

CREATE OR ALTER FUNCTION dbo.fn_TinhHangThanhVien (@UserID INT)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @TongTienDaChi DECIMAL(18, 0);
    DECLARE @HangThanhVien VARCHAR(20);

    -- Tính tổng tiền các giao dịch thành công
    SELECT @TongTienDaChi = SUM(so_tien) -- Cột tiền thực tế trong bảng Payments
    FROM dbo.PAYMENTS
    WHERE user_id = @UserID
    AND trang_thai IN ('PAID', 'SUCCESS', 'APPROVED');

    SET @TongTienDaChi = ISNULL(@TongTienDaChi, 0);

    -- Logic so sánh
    IF @TongTienDaChi < 5000000
        SET @HangThanhVien = 'STANDARD';
    ELSE IF @TongTienDaChi < 20000000
        SET @HangThanhVien = 'GOLD';
    ELSE
        SET @HangThanhVien = 'PLATINUM';

    RETURN @HangThanhVien;
END
GO
