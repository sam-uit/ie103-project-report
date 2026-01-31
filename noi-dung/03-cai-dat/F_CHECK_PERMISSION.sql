-- F_CHECK_PERMISSION.sql
-- Chức năng: Kiểm tra xem một Admin có sở hữu quyền hạn cụ thể hay không
-- Input: @AdminId (INT), @PermissionCode (NVARCHAR)
-- Output: 1 (True) hoặc 0 (False)
CREATE OR ALTER FUNCTION F_CHECK_PERMISSION
(
    @AdminId INT,
    @PermissionCode NVARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    DECLARE @IsAllowed BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM ADMIN_ROLES ar
        JOIN ROLES r ON ar.role_id = r.id
        JOIN ROLE_PERMISSIONS rp ON r.id = rp.role_id
        JOIN PERMISSIONS p ON rp.permission_id = p.id
        WHERE ar.admin_id = @AdminId
          AND p.code = @PermissionCode
    )
    SET @IsAllowed = 1;

    RETURN @IsAllowed;
END;
GO
