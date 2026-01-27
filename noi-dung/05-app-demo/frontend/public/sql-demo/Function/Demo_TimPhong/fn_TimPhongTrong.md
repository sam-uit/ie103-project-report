### Function 2: Tìm phòng trống theo loại (`fn_TimPhongTrongTheoLoai`)

#### 1. Mô tả và Hướng xử lý

- **Mục đích:** Lọc ra danh sách các phòng thuộc một loại cụ thể đang khả dụng (Available) trong khoảng thời gian khách muốn đặt.
    
- **Logic xử lý:**
    
    - Đầu vào: `Loại Phòng ID`, `Ngày Check-in`, `Ngày Check-out`.
        
    - Lấy danh sách **TẤT CẢ** phòng thuộc loại phòng yêu cầu.
        
    - Tìm danh sách các phòng **ĐANG BẬN** (có lịch đặt trùng với thời gian đầu vào).
        
        - _Lưu ý:_ Bỏ qua các đơn đặt phòng đã bị Hủy (`CANCELLED`) hoặc Hoàn tiền (`REFUNDED`).
            
    - **Công thức:** `Kết quả = Danh sách Gốc - Danh sách Bận`.
        
    - Trả về dạng Bảng (Table-Valued Function).
        

#### 2. Source Code

```SQL
CREATE OR ALTER FUNCTION dbo.fn_TimPhongTrongTheoLoai 
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
```

#### 3. Kiểm thử

- **Kịch bản:** Phòng `101` (Loại 1) đang có khách ở từ `04/04` đến `05/04`. Phòng `102` (Loại 1) đang trống.
    
- **Test Case:** Tìm phòng Loại 1 trống trong ngày `02/04`.
    
- **Kết quả mong đợi:** Chỉ hiển thị phòng `104` `205` `304` `501`. Phòng `101` bị ẩn đi.
    

```SQL
-- Câu lệnh chạy test
SELECT * FROM dbo.fn_TimPhongTrongTheoLoai(1, '2023-04-04', '2023-04-05');
```
