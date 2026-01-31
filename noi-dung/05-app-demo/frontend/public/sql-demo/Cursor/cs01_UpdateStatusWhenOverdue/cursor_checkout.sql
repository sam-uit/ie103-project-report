-- Nhóm 02.
-- Cursor - Tự Động Hoàn Tất Đơn Đặt Phòng Khi Quá Hạn

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
