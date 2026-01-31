### Cursor - Đồng Bộ Trạng Thái Phòng Thực Tế (`cur_phong_status`)

#### 1. Mô tả và Hướng xử lý

- **Mục đích:**
    - Cursor này đảm bảo trạng thái hiển thị của phòng (`AVAILABLE`, `OCCUPIED`, `MAINTENANCE`, `RESERVED`) trên giao diện luôn khớp với dữ liệu đặt phòng thực tế trong cơ sở dữ liệu.
- **Logic xử lý:**
    - Duyệt qua tất cả các phòng trong bảng `PHONG`, lấy thông tin `id`, `so_phong` và `trang_thai` hiện tại.
    - Với mỗi phòng, thực hiện truy vấn kiểm tra xem có đơn đặt phòng nào đang hoạt động (Trạng thái `CONFIRMED` và thời gian hiện tại nằm trong khoảng lưu trú).
    - Cập nhật:
        + Trường hợp 1 (Có khách đang ở):
            - Nếu trạng thái hiện tại chưa phải `OCCUPIED` $\to$ Cập nhật thành `OCCUPIED`.
        + Trường hợp 2 (Không có khách):
            - Nếu trạng thái hiện tại là `OCCUPIED` (tức là dữ liệu cũ bị sai/treo) $\to$ Trả về `AVAILABLE`.
            - Nếu trạng thái hiện tại là `MAINTENANCE` (Bảo trì) hoặc `RESERVED` (Đã đặt trước) $\to$ Giữ nguyên, không can thiệp.

#### 2. Source Code

Khai báo:

```sql
-- Nhóm 02.
-- Cursor - Đồng Bộ Trạng Thái Phòng Thực Tế

DECLARE @id_phong INT;
DECLARE @so_phong NVARCHAR(20);
DECLARE @trang_thai NVARCHAR(50);
DECLARE @is_occupied INT;

DECLARE cur_phong_status CURSOR FOR
SELECT id, so_phong, trang_thai FROM PHONG;

OPEN cur_phong_status;
FETCH NEXT FROM cur_phong_status INTO @id_phong, @so_phong, @trang_thai;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Kiểm tra xem phòng có khách đang ở (CONFIRMED và trong thời gian lưu trú)
    SELECT @is_occupied = COUNT(*)
    FROM CT_DATPHONG ct
    JOIN DATPHONG dp ON ct.datphong_id = dp.id
    WHERE ct.phong_id = @id_phong
      AND dp.trang_thai = 'CONFIRMED'
      AND GETDATE() BETWEEN dp.check_in AND dp.check_out;

    IF @is_occupied > 0
    BEGIN
        -- Nếu có khách mà trạng thái chưa phải OCCUPIED thì mới cập nhật
        IF @trang_thai != 'OCCUPIED'
        BEGIN
            UPDATE PHONG SET trang_thai = 'OCCUPIED' WHERE id = @id_phong;
            PRINT N'Phòng ' + @so_phong + N': Cập nhật sang đang có khách';
        END
    END
    ELSE
    BEGIN
        IF @trang_thai = 'OCCUPIED'
        BEGIN
            UPDATE PHONG SET trang_thai = 'AVAILABLE' WHERE id = @id_phong;
            PRINT N'Phòng ' + @so_phong + N': trống';
        END
        ELSE
        BEGIN
             PRINT N'Phòng ' + @so_phong + N': Giữ nguyên trạng thái (' + @trang_thai + ')';
        END
    END

    FETCH NEXT FROM cur_phong_status INTO @id_phong, @so_phong, @trang_thai;
END

CLOSE cur_phong_status;
DEALLOCATE cur_phong_status;
GO
```

#### 3. Kiểm thử

- **Kịch bản:**
    - Phòng 101: Đang trống thực tế nhưng dữ liệu lỗi hiển thị là `AVAILABLE`.
    - Phòng 102: Đang có khách ở thực tế nhưng hiển thị là `AVAILABLE`.
    - Phòng 503: Đang bảo trì (`MAINTENANCE`), không có khách.
- **Dữ liệu**: 
    - 101: AVAILABLE (Đúng)
    - 102: AVAILABLE (Sai)
    - 503: MAINTENANCE (Đúng)
- **Kết quả mong đợi:**
    - Phòng 101 $\to$ Giữ nguyên là `AVAILABLE`
    - Phòng 102 $\to$ Được sửa thành `OCCUPIED`.
    - Phòng 503 $\to$ Giữ nguyên là `MAINTENANCE`

Kết quả:

```sql
-- Chạy đoạn code Cursor bên trên và quan sát cửa sổ Messages
-- Kết quả in ra mong đợi:
-- Phòng 101: Giữ nguyên trạng thái (AVAILABLE)
-- Phòng 102: Cập nhật sang Đang có khách (OCCUPIED)
-- Phòng 503: Giữ nguyên trạng thái (MAINTENANCE)
```
