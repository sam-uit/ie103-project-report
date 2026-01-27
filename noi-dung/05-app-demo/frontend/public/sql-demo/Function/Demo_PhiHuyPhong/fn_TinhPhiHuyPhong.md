### Function 1: Tính phí hủy phòng động (`fn_TinhPhiHuyPhong`)

#### 1. Mô tả và Hướng xử lý

- **Mục đích:** Tính toán số tiền phạt khi khách hàng yêu cầu hủy phòng, dựa trên thời gian báo trước so với ngày Check-in để đảm bảo công bằng.
    
- **Logic xử lý:**
    
    - Kết nối bảng `DATPHONG` để lấy ngày Check-in dự kiến.
        
    - Tính tổng tiền cọc của đơn hàng từ bảng `CT_DATPHONG`.
        
    - Tính khoảng cách ngày: `Số ngày` = `Ngày Check-in` - `Ngày Báo Hủy`.
        
    - **Quy tắc tính phí (Logic mới):**
        
        - Nếu báo trước **>= 3 ngày**: Miễn phí (0%).
            
        - Nếu báo trước **từ 1 đến dưới 3 ngày**: Phạt **50%** tổng tiền cọc.
            
        - Nếu báo sát giờ (**< 1 ngày** hoặc trong ngày check-in): Phạt **100%** tổng tiền cọc.
            

#### 2. Source Code



```SQL
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
```

#### 3. Kiểm thử

- **Kịch bản:** Đơn đặt phòng `ID = 3` có ngày Check-in là `2023/04/04`. Tổng tiền cọc `600,000 VNĐ`.
    
- **Test Case:** - Case 1: Hủy ngày `2023/04/01` (Trước 3 ngày).
    
    - Case 2: Hủy ngày `2023/04/04` (Trong ngày Check-in).
        
- **Kết quả mong đợi:** - Case 1: `0 VNĐ`.
    
    - Case 2: `600,000 VNĐ`.
    
```SQL
-- Câu lệnh chạy test
SELECT 
    dbo.fn_TinhPhiHuyPhong(3, '2023-04-01') AS PhiHuy_XaNgay, -- Kỳ vọng: 0
    dbo.fn_TinhPhiHuyPhong(3, '2023-04-04') AS PhiHuy_Gap;    -- Kỳ vọng: 600.000
```
