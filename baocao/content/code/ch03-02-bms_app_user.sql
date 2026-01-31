-- 1. Tạo Login ở cấp độ Server
CREATE LOGIN [BMS_App_User] WITH PASSWORD = 'P@ssw0rd123!';
GO

-- 2. Tạo User ở cấp độ Database
USE ROOM_BOOKING_SYSTEM;
GO
CREATE USER [BMS_App_User] FOR LOGIN [BMS_App_User];
GO

-- 3. Cấp quyền thực thi cơ bản (Sẽ được tinh chỉnh chi tiết ở Chương 4)
GRANT EXECUTE TO [BMS_App_User];
GO