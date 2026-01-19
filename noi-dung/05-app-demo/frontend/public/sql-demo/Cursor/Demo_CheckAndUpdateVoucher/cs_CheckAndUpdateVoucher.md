### Function 1: Tính tổng tiền đặt phòng (`fn_TinhTongTien`)

#### 1. Mô tả và Hướng xử lý
- **Mục đích:** Tính toán tổng chi phí cuối cùng mà khách hàng phải trả cho một lượt đặt phòng (`Booking`).
    
- **Logic xử lý:**
    
    - Kết nối bảng `DATPHONG` (lấy thời gian) và `CT_DATPHONG` (lấy đơn giá).
        
    - Tính số ngày lưu trú: `Ngày Check-out` - `Ngày Check-in`.
        
    - **Xử lý ngoại lệ:** Nếu khách check-in và check-out trong cùng một ngày, hệ thống mặc định tính là 1 ngày.
        
    - Công thức: `Tổng tiền = SUM(Số ngày * Đơn giá)`.
        
#### 2. Source Code
SQL
```
CREATE OR ALTER dbo.fn_TinhTongTien (@DatPhongID INT)
RETURNS DECIMAL(18, 0)
AS
BEGIN
    DECLARE @TongTien DECIMAL(18, 0);

    SELECT @TongTien = SUM(
        ct.don_gia * (
            CASE 
                -- Nếu check_in trùng check_out tính tối thiểu 1 ngày
                WHEN DATEDIFF(DAY, dp.check_in, dp.check_out) = 0 THEN 1 
                ELSE DATEDIFF(DAY, dp.check_in, dp.check_out) 
            END
        )
    )
    FROM dbo.DATPHONG dp
    JOIN dbo.CT_DATPHONG ct ON dp.id = ct.datphong_id
    WHERE dp.id = @DatPhongID;

    -- Trả về 0 nếu không tìm thấy dữ liệu
    RETURN ISNULL(@TongTien, 0);
END
GO
```

#### 3. Kiểm thử 

- **Kịch bản:** Tính tiền cho Đơn đặt phòng có `ID = 1`.
    
- **Dữ liệu mẫu:** Check-in: `01/04`, Check-out: `03/04` (2 ngày). Đơn giá phòng: `800,000 VNĐ`.
    
- **Kết quả mong đợi:** 1,600,000 VNĐ.
    

SQL

```
-- Câu lệnh chạy test
SELECT dbo.fn_TinhTongTien(1) AS TongTienPhaiTra;
```

_Kết quả:_ Hàm trả về `1600000`, chính xác theo công thức `2 ngày * 800.000`.

---

### Function 2: Kiểm tra phòng trống (`fn_KiemTraPhongTrong`)

#### 1. Mô tả và Hướng xử lý

- **Mục đích:** Ngăn chặn việc đặt trùng phòng. Kiểm tra xem một phòng cụ thể có khả dụng trong khoảng thời gian khách yêu cầu hay không.
    
- **Logic xử lý:**
    
    - Quét toàn bộ bảng `DATPHONG` và `CT_DATPHONG`.
        
    - Tìm kiếm các đơn đặt phòng **chưa bị hủy** của phòng đó.
        
    - Kiểm tra sự chồng lấn thời gian (Overlap) theo nguyên tắc: `Ngày khách muốn đến < Ngày khách cũ đi` **VÀ** `Ngày khách muốn đi > Ngày khách cũ đến`.
        
    - Trả về `1` (True - Phòng bận) hoặc `0` (False - Phòng trống).
        

#### 2. Source Code 

SQL

```
CREATE OR ALTER dbo.fn_KiemTraPhongTrong (@PhongID INT, @NgayCheckIn DATETIME, @NgayCheckOut DATETIME)
RETURNS BIT 
AS
BEGIN
    DECLARE @KetQua BIT;

    IF EXISTS (
        SELECT 1 
        FROM dbo.DATPHONG dp
        JOIN dbo.CT_DATPHONG ct ON dp.id = ct.datphong_id
        WHERE ct.phong_id = @PhongID 
        AND dp.trang_thai != 'CANCELLED' -- Chỉ kiểm tra các đơn chưa hủy
        -- Logic kiểm tra trùng lịch (Overlap)
        AND (@NgayCheckIn < dp.check_out AND @NgayCheckOut > dp.check_in)
    )
        SET @KetQua = 1; -- Đã có người đặt (Bận)
    ELSE
        SET @KetQua = 0; -- Phòng trống

    RETURN @KetQua;
END
GO
```

#### 3. Kiểm thử

- **Kịch bản:** Kiểm tra phòng ID 3 (P201) đang có khách ở từ `01/04` đến `03/04`.
    
- **Test Case 1 (Trùng lịch):** Khách mới muốn đặt từ `02/04` đến `04/04`.
    
- **Test Case 2 (Không trùng):** Khách mới muốn đặt từ `05/05` đến `07/05`.
    

SQL

```
-- Test 1: Đặt trùng vào ngày 02/04 -> Kỳ vọng: 1 (Bận)
SELECT dbo.fn_KiemTraPhongTrong(3, '2025-04-02 14:00:00', '2025-04-04 12:00:00') AS TrangThai_Test1;

-- Test 2: Đặt xa vào tháng 5 -> Kỳ vọng: 0 (Trống)
SELECT dbo.fn_KiemTraPhongTrong(3, '2025-05-05 14:00:00', '2025-05-07 12:00:00') AS TrangThai_Test2;
```

_Kết quả:_ Test 1 trả về `1` (Hệ thống chặn đặt). Test 2 trả về `0` (Cho phép đặt).

---

### Function 3: Tạo mã hiển thị tự động (`fn_TaoMaDatPhong`)

#### 1. Mô tả và Hướng xử lý

- **Mục đích:** Tạo mã định danh thân thiện (Format Code) để hiển thị trên hóa đơn hoặc giao diện người dùng, thay thế cho ID dạng số khô khan.
    
- **Logic xử lý:**
    
    - Nhận vào ID số nguyên (Identity).
        
    - Thêm chuỗi ký tự `BK` (Booking) làm tiền tố.
        
    - Dùng hàm `RIGHT` để lấy đúng 5 chữ số cuối cùng, tự động điền thêm số `0` vào trước nếu ID nhỏ.
        
    - Ví dụ: ID `1` -> `BK00001`.
        

#### 2. Source Code

SQL

```
CREATE OR ALTER dbo.fn_TaoMaDatPhong (@ID INT)
RETURNS VARCHAR(10)
AS
BEGIN
    -- Input: 1 -> Output: BK00001
    RETURN 'BK' + RIGHT('00000' + CAST(@ID AS VARCHAR(5)), 5);
END
GO
```

#### 3. Kiểm thử 

- **Kịch bản:** Hiển thị danh sách các đơn đặt phòng kèm theo mã code đã được format.
    

SQL

```
-- Câu lệnh chạy test
SELECT id, dbo.fn_TaoMaDatPhong(id) AS Ma_Booking_Hien_Thi 
FROM dbo.DATPHONG;
```

_Kết quả:_ Cột `Ma_Booking_Hien_Thi` hiển thị giá trị `BK00001` tương ứng với `id = 1`.