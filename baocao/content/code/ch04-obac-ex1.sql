    -- Nếu tài khoản hợp lệ (tồn tại, và đang ACTIVE), cho phép tạo đơn Đặt Phòng
    IF NOT EXISTS (SELECT 1 FROM USERS WHERE id = @UserId and status = 'ACTIVE')