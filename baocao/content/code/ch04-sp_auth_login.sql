BEGIN
    SET NOCOUNT ON;

    DECLARE @InputHash NVARCHAR(255);
    SET @InputHash = CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256', @Password), 1);

    IF EXISTS (
        SELECT 1 FROM USERS 
        WHERE email = @Email AND password_hash = @InputHash
    )
    BEGIN
        SELECT id, email, full_name FROM USERS WHERE email = @Email;
        PRINT N'Đăng nhập thành công';
    END
    ELSE
    BEGIN
        RAISERROR(N'Sai email hoặc mật khẩu.', 16, 1);
    END
END;