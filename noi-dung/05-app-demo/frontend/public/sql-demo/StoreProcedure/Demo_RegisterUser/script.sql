-- Check if email exists
IF EXISTS (SELECT 1 FROM USERS WHERE email = @Email)
BEGIN
    RAISERROR(N'Email đã tồn tại!', 16, 1);
    RETURN;
END

-- Insert new user
INSERT INTO USERS (email, phone, password_hash, full_name, status, created_at)
VALUES (@Email, @Phone, @Password, @FullName, 'ACTIVE', GETDATE());

PRINT N'Đăng ký thành công!';
