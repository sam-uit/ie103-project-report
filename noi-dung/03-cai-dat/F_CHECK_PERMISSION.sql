-- F_CHECK_PERMISSION.sql
CREATE OR ALTER FUNCTION F_CHECK_PERMISSION 
(
    @AdminId INT, 
    @RequiredPermissionCode NVARCHAR(50)
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
          AND p.code = @RequiredPermissionCode
    )
    SET @IsAllowed = 1;

    RETURN @IsAllowed;
END;
