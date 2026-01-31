/* ============================================================
   TRIGGER 1: Kiểm tra thời gian đặt phòng (DATPHONG)
   - Mục đích: Dữ liệu thời gian hợp lệ (check_out >= check_in)
   - Chạy khi: INSERT hoặc UPDATE trên DATPHONG
   - Sử dụng: inserted (Bảng ảo chứa dữ liệu mới)
   - Kết quả: Nếu sai thì báo lỗi + rollback
   ============================================================ */

-- Xóa trigger cũ nếu tồn tại
IF OBJECT_ID('dbo.trg_DATPHONG_CheckTime', 'TR') IS NOT NULL 
    DROP TRIGGER dbo.trg_DATPHONG_CheckTime;
GO

-- Tạo trigger mới
CREATE TRIGGER dbo.trg_DATPHONG_CheckTime
ON dbo.DATPHONG
AFTER INSERT, UPDATE
AS
BEGIN
    -- inserted: chứa các dòng vừa mới thêm / sửa
    -- Kiểm tra: check_out phải >= check_in
    IF EXISTS (SELECT 1 FROM inserted WHERE check_out < check_in)
    BEGIN
        RAISERROR (N'check_out không được nhỏ hơn check_in', 16, 1);
        ROLLBACK TRANSACTION;  -- Hủy thao tác
        RETURN;                -- Dừng trigger
    END
END
GO

/* ============================================================
   TEST CASE 1: Trường hợp SAI (check_out < check_in)
   Kỳ vọng: Lỗi và ROLLBACK
   (Đã comment để demo chạy thành công)
   
-- INSERT INTO DATPHONG(user_id, check_in, check_out, trang_thai, created_at)
-- VALUES (1, '2026-01-14 10:00', '2026-01-14 08:00', 'PENDING', GETDATE());


   TEST CASE 2: Trường hợp ĐÚNG (check_out >= check_in)
   Kỳ vọng: Thành công, dữ liệu được thêm vào
  
INSERT INTO DATPHONG(user_id, check_in, check_out, trang_thai, created_at)
VALUES (1, '2026-01-14 14:00', '2026-01-20 10:00', 'PENDING', GETDATE());


   KIỂM TRA KẾT QUẢ

SELECT * FROM DATPHONG ORDER BY id DESC;
============================================================ */
