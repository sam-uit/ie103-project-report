/* ===========================================================
   1. Fuction: Tính Hạng Thành Viên
   ===========================================================

CREATE FUNCTION dbo.fn_TinhHangThanhVien (@UserID INT)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @TongTienDaChi DECIMAL(18, 0);
    DECLARE @HangThanhVien VARCHAR(20);

    -- Tính tổng tiền các giao dịch thành công
    SELECT @TongTienDaChi = SUM(so_tien) -- (hoặc amount)
    FROM dbo.PAYMENTS
    WHERE user_id = @UserID 
    AND status IN ('PAID', 'SUCCESS', 'APPROVED');

    SET @TongTienDaChi = ISNULL(@TongTienDaChi, 0);

    -- Quy tắc xếp hạng
    IF @TongTienDaChi < 5000000 
        SET @HangThanhVien = 'STANDARD';
    ELSE IF @TongTienDaChi < 20000000 
        SET @HangThanhVien = 'GOLD';
    ELSE 
        SET @HangThanhVien = 'PLATINUM';

    RETURN @HangThanhVien;
END
*/

-- ===========================================================
-- 2. KỊCH BẢN TEST 
-- ===========================================================

-- Hiển thị thông tin khách hàng kèm hạng thành viên tính toán được
SELECT 
    u.id AS [ID],
    u.full_name AS [Full Name],
    
    -- Hiển thị tổng tiền để đối chiếu 
    FORMAT((
        SELECT ISNULL(SUM(so_tien), 0) 
        FROM PAYMENTS 
        WHERE user_id = @UserID AND status IN ('PAID', 'SUCCESS', 'APPROVED')
    ), 'N0') + ' VNĐ' AS [Tổng Chi Tiêu],
    
    -- Gọi hàm xếp hạng
    dbo.fn_TinhHangThanhVien(@UserID) AS [Xếp Hạng]
FROM USERS u
WHERE u.id = @UserID;