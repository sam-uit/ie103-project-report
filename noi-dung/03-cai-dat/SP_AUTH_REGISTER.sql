-- SP_AUTH_REGISTER.sql
CREATE OR ALTER PROCEDURE SP_AUTH_REGISTER
    @Email NVARCHAR(255),
    @Password NVARCHAR(50),
    @FullName NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM USERS WHERE email = @Email)
        BEGIN
            RAISERROR(N'Email đã tồn tại.', 16, 1);
            RETURN;
        END

        DECLARE @Hash VARBINARY(64);
        SET @Hash = HASHBYTES('SHA2_256', @Password);

        INSERT INTO USERS (email, password_hash, full_name)
        VALUES (@Email, CONVERT(NVARCHAR(255), @Hash, 1), @FullName);
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
