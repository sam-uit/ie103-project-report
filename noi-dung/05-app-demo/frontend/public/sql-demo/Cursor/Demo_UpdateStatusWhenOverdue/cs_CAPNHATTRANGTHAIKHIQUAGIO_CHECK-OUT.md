### Function 1: Tự động hoàn tất đơn đặt phòng (`cursor_checkout`)

#### 1. Mô tả và Hướng xử lý
- **Mục đích:** Tự động hóa việc kết thúc quy trình đặt phòng. Hệ thống quét các đơn đặt phòng đã quá hạn trả 
phòng (`Check-out`) nhưng trạng thái vẫn là `CONFIRMED` để chuyển sang `COMPLETED`
và giải phóng phòng.
    
- **Logic xử lý:**
    
    - Khai báo Cursor quét bảng `DATPHONG`.
        
    - Điều kiện lọc: `trang_thai = 'CONFIRMED'` VÀ `check_out < GETDATE()` (Thời gian hiện tại đã vượt qua giờ check-out).
        
    - **Xử lý ngoại lệ:** Vòng lặp xử lý từng đơn:

        + Cập nhật trạng thái đơn (`DATPHONG`) thành `COMPLETED`.

        + Tìm các phòng liên quan trong bảng `CT_DATPHONG` và cập nhật trạng thái phòng (`PHONG`) về `AVAILABLE` (Sẵn sàng đón khách mới).

        + Đếm số lượng đơn đã xử lý và in log thông báo.
        
#### 2. Source Code
SQL
```
DECLARE @id_datphong INT;
DECLARE @dem_completed INT = 0;

-- Khai báo Cursor cho các đơn đã quá hạn trả phòng
DECLARE cursor_checkout CURSOR FOR 
SELECT id 
FROM DATPHONG 
WHERE trang_thai = 'CONFIRMED' 
  AND check_out < GETDATE();

OPEN cursor_checkout;

FETCH NEXT FROM cursor_checkout INTO @id_datphong;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Cập nhật trạng thái đơn đặt phòng
    UPDATE DATPHONG 
    SET trang_thai = 'COMPLETED' 
    WHERE id = @id_datphong;
    
    -- Cập nhật lại trạng thái các phòng trong đơn đó thành 'AVAILABLE'
    UPDATE PHONG 
    SET trang_thai = 'AVAILABLE'
    WHERE id IN (SELECT phong_id FROM CT_DATPHONG WHERE datphong_id = @id_datphong);

    SET @dem_completed = @dem_completed + 1;
    PRINT N'Đã hoàn tất đơn đặt phòng số: ' + CAST(@id_datphong AS NVARCHAR(10));

    FETCH NEXT FROM cursor_checkout INTO @id_datphong;
END

CLOSE cursor_checkout;
DEALLOCATE cursor_checkout;

PRINT N'>>> Tổng cộng đã xử lý xong ' + CAST(@dem_completed AS NVARCHAR(10)) + N' đơn quá hạn.';
GO
```    

SQL
```
    -- Kiểm tra trước khi chạy
    SELECT id, trang_thai FROM DATPHONG WHERE id = 1;
    -- Chạy đoạn code Cursor bên trên
    -- Kiểm tra sau khi chạy
    SELECT id, trang_thai FROM DATPHONG WHERE id = 1;
```

_Kết quả:_  Đơn ID=1 chuyển thành 'COMPLETED'.

            Phòng P201 chuyển thành 'AVAILABLE'.

---