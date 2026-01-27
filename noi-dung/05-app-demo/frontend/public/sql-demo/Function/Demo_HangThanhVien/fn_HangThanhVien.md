### Function 3: Xếp hạng thành viên (`fn_TinhHangThanhVien`)

#### 1. Mô tả và Hướng xử lý

- **Mục đích:** Tự động xếp hạng thành viên (Loyalty Tier) cho khách hàng dựa trên tổng doanh thu thực tế.
    
- **Logic xử lý:**
    
    - Kết nối bảng `PAYMENTS` để lấy lịch sử giao dịch của `UserID`.
        
    - Chỉ tính tổng tiền (`SUM`) của các giao dịch thành công (Status là `PAID`, `SUCCESS`, hoặc `APPROVED`).
        
    - **Quy tắc xếp hạng:**
        
        - Tổng chi tiêu < 5.000.000 VNĐ: **STANDARD**.
            
        - Tổng chi tiêu 5.000.000 - 20.000.000 VNĐ: **GOLD**.
            
        - Tổng chi tiêu > 20.000.000 VNĐ: **PLATINUM**.
            

#### 2. Source Code

```SQL
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
    AND status IN ('PAID', 'SUCCESS', 'APPROVED');

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
```

#### 3. Kiểm thử

- **Kịch bản:** - User 1: Đã thanh toán tổng cộng `13,400,000 VNĐ`.
    
    - User 3 : Đã thanh toán `4,300,000 VNĐ`.
        
- **Kết quả mong đợi:** - User 1: `GOLD`.
    
    - User 3: `STANDARD`.
        

```SQL
-- Câu lệnh chạy test
SELECT 
    dbo.fn_TinhHangThanhVien(1) AS Hang_User1,
    dbo.fn_TinhHangThanhVien(3) AS Hang_User3;
```