BEGIN TRANSACTION;

BEGIN TRY
    -- 1. Xử lý Thanh toán trước (Điều này có thể kích hoạt Trigger set Booking -> CONFIRMED)
    DECLARE @UserID INT;
    SELECT @UserID = user_id FROM DATPHONG WHERE id = @BookingID;

    IF @UserID IS NOT NULL
    BEGIN
        IF EXISTS (SELECT 1 FROM PAYMENTS WHERE booking_id = @BookingID)
        BEGIN
            UPDATE PAYMENTS
            SET trang_thai = 'PAID', phuong_thuc = @Method
            WHERE booking_id = @BookingID;
        END
        ELSE
        BEGIN
            INSERT INTO PAYMENTS (booking_id, user_id, so_tien, phuong_thuc, trang_thai, created_at)
            VALUES (@BookingID, @UserID, 1000000, @Method, 'PAID', GETDATE());
        END
    END
    ELSE
    BEGIN
        -- Nếu không tìm thấy ID, raise error để rollback luôn
        RAISERROR(N'Không tìm thấy Booking ID hoặc User ID hợp lệ!', 16, 1);
    END

    -- 2. Cập nhật trạng thái Đặt phòng thành COMPLETED (Chạy sau để ghi đè trạng thái từ Trigger)
    UPDATE DATPHONG 
    SET trang_thai = 'COMPLETED' 
    WHERE id = @BookingID;

    -- 3. Trả phòng: Cập nhật trạng thái Phòng thành AVAILABLE
      UPDATE PHONG
      SET trang_thai = 'AVAILABLE'
      WHERE id IN (
      SELECT phong_id
      FROM CT_DATPHONG
      WHERE datphong_id = @BookingID);
      
      IF @@ROWCOUNT = 0
      BEGIN
            RAISERROR(N'Không có phòng nào để trả – dữ liệu không hợp lệ!', 16, 1);
      END

    -- Nếu chạy đến đây mà không lỗi -> Commit
    COMMIT TRANSACTION;
    PRINT N'Check-out thành công! Tất cả dữ liệu đã được cập nhật.';
END TRY
BEGIN CATCH
    -- Nếu có lỗi bất kỳ -> Rollback toàn bộ
    ROLLBACK TRANSACTION;
    
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();

    -- Ném lỗi ra ngoài để UI hiển thị
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
