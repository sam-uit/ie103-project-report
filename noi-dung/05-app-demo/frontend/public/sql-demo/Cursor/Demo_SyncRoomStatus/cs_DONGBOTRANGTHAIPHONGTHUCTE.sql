--Cursor 2: Kiểm kê và cập nhật trạng thái thực tế của bảng PHONG
--Nghiệp vụ này rất quan trọng: Cursor sẽ quét từng phòng trong hệ thống, kiểm tra xem tại thời điểm hiện tại (GETDATE()), phòng đó có 
--đang nằm trong một đơn đặt phòng nào "đang ở" (CONFIRMED) hay không để cập nhật trạng thái OCCUPIED hoặc AVAILABLE cho chính xác.

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