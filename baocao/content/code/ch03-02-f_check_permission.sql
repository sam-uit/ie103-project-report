    -- Kiểm tra sự tồn tại của quyền trong chuỗi liên kết:
    -- Admin -> Admin_Roles -> Roles -> Role_Permissions -> Permissions
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