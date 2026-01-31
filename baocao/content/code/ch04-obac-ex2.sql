    -- Đơn đặt phòng phải tồn tại VÀ thuộc về đúng User này
    IF NOT EXISTS (
        SELECT 1 FROM DATPHONG 
        WHERE id = @BookingId AND user_id = @UserId
    )