## An Toàn Thông Tin

Mục này trình bày về cách hiện thực các biện pháp bảo mật thông tin trong hệ thống, bao gồm các biện pháp phân quyền, mã hóa mật khẩu, và các biện pháp bảo mật khác.

Đồng thời trình bày các công việc của quản trị viên trong việc sao lưu/khôi phục dữ liệu, đảm bảo an toàn thông tin và tính liên tục của vận hành (Business Continuity).

### Xác Thực Và Phân Quyền

Hệ thống áp dụng mô hình bảo mật đa lớp, kết hợp giữa cơ chế phân quyền dựa trên vai trò (RBAC) ở mức dữ liệu và bảo mật mức vật lý của hệ quản trị SQL Server.

#### Bảo Mật Mức Hệ Quản Trị

Để tuân thủ nguyên tắc "Đặc quyền tối thiểu" (Least Privilege) -- mỗi tài khoản chỉ có quyền truy cập vào tài nguyên cần thiết, hệ thống KHÔNG SỬ DỤNG tài khoản `sa` (System Admin) để kết nối từ ứng dụng vào cơ sở dữ liệu. Thay vào đó, một tài khoản chuyên biệt được tạo ra để kết nối từ ứng dụng vào cơ sở dữ liệu.

1. Tạo Login Server:

```sql
CREATE LOGIN [BMS_App_User] WITH PASSWORD = 'P@ssw0rd123!';
```

2. Tạo Database User & Gán Quyền:

```sql
USE ROOM_BOOKING_SYSTEM;
CREATE USER [BMS_App_User] FOR LOGIN [BMS_App_User];
```

3. Gán Quyền: Chỉ cấp quyền thực thi (EXECUTE) trên các Stored Procedure, ngăn chặn truy cập trực tiếp vào bảng dữ liệu.

```sql
GRANT EXECUTE TO [BMS_App_User];
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO [BMS_App_User];
GO
```

#### Mã Hóa Mật Khẩu

Để đảm bảo an toàn dữ liệu người dùng, hệ thống không lưu trữ mật khẩu dưới dạng văn bản thuần (plain-text). Mọi mật khẩu đều được mã hóa một chiều bằng thuật toán SHA-256 thông qua hàm HASHBYTES của SQL Server trước khi lưu vào cơ sở dữ liệu.

Tạo một Stored Producedure thực hiện mã hóa mật khẩu mỗi khi tạo User mới (`SP_RegisterUser`):

```sql
-- Mã Hóa Mật Khẩu trong quá trình Đăng Ký Thành Viên
CREATE PROCEDURE SP_RegisterUser
    @Email NVARCHAR(255),
    @Password NVARCHAR(50),
    @FullName NVARCHAR(255)
AS
BEGIN
    DECLARE @PasswordHash VARBINARY(64);
    SET @PasswordHash = HASHBYTES('SHA2_256', @Password);

    INSERT INTO USERS (email, password_hash, full_name)
    VALUES (@Email, @PasswordHash, @FullName);
END
```

#### Kiểm Soát Truy Cập Dựa Trên Vai Trò (Data-Driven RBAC)

Hệ thống quản lý quyền hạn thông qua các bảng `ROLES`, `PERMISSIONS` và `ADMIN_ROLES`. Quyền truy cập không được gán cứng mà động dựa trên dữ liệu.

Hệ thống sử dụng Stored Procedure để xử lý đăng ký và đăng nhập, đảm bảo mật khẩu luôn được mã hóa một chiều (SHA-256) trước khi lưu xuống cơ sở dữ liệu.

Mô hình phân quyền:

<!-- | STT | **Vai Trò** | **Quyền Hạn** |
|----:|----|----|
| 1 | Admin | Quản lý tất cả |
| 2 | Staff | Quản lý đặt phòng |
| 3 | End User | Đặt phòng | -->

```{=typst}
#figure(
    table(
    columns: (10%, 20%, 70%),
    align: (right, left, left),
    [STT], [#strong[Vai Trò]], [#strong[Quyền Hạn]], [1], [Admin], [Quản lý tất cả], [2], [Staff], [Quản lý đặt phòng], [3], [End User], [Đặt phòng]
    ),
    caption: [An Toàn Thông Tin - Bảng Phân Quyền]
)
```

Thủ tục kiểm tra quyền:

```sql
CREATE FUNCTION F_CheckPermission (@AdminId INT, @PermissionCode NVARCHAR(50))
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
        WHERE ar.admin_id = @AdminId AND p.code = @PermissionCode
    )
    SET @IsAllowed = 1;

    RETURN @IsAllowed;
END
```

SP Cho đăng ký user, tạo mã hóa mật khẩu:

- Kiểm tra nếu email đã tồn tại.
- Mã hóa mật khẩu.
- Thêm người dùng vào bảng `USERS`.

```sql
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
```

SP Đăng nhập (Kiểm tra Hash):

- Mã hóa mật khẩu nhập vào và so sánh với mật khẩu đã mã hóa trong database.

```sql
-- SP_AUTH_LOGIN.sql
CREATE OR ALTER PROCEDURE SP_AUTH_LOGIN
    @Email NVARCHAR(255),
    @Password NVARCHAR(50)
AS
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
```

Function kiểm tra quyền:

- Đảm bảo mỗi user/admin có đúng quyền truy cập vào tài nguyên hệ thống theo vai trò của mình.

```sql
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
```



### Sao Lưu & Phục Hồi

Chiến lược sao lưu dữ liệu được đề xuất:

- Full Backup: Thực hiện định kỳ vào 00:00 Chủ Nhật hàng tuần.
    - Mỗi bản Full backup được lưu giữ trong 2 tuần.
- Differential Backup: Thực hiện vào 00:00 các ngày trong tuần.
    - Mỗi bản Differential backup được lưu giữ trong 1 tuần.
- Export/Import: Sử dụng trong các tình huống cụ thể.
    - Không quy định thời gian lưu giữ, tùy tình huống hoặc yêu cầu khi thực hiện.

#### Backup – Restore Dữ Liệu

**Backup:**

1. Chuột phải vào Database, chọn *Task* > *Back Up...*.

![Backup - 01 - Task > Back Up.](images/backup-01.jpg.jpeg)

2. Chọn *Full* hoặc *Differential* trong mục *Backup type*. Chọn *Destination* là *Disk*

![Backup - 02 - Backup Type.](images/backup-02.jpg.jpeg)

3. Thêm đường dẫn thư mục lưu file backup.

![Backup - 03 - Backup Destination.](images/backup-03.jpg.jpeg)

4. Nhấn *OK*.

![Backup - 04 - Xác Nhận.](images/backup-04.jpg.jpeg)

5. Thông báo Hoàn Thành.

![Backup - 05 - Backup Hoàn Thành.](images/backup-05.jpg.jpeg)

**Restore:**

1. Chuột phải vào mục Database của Server, chọn *Restore Database...*.

![Restore - 01 - Restore Database.](images/restore-01.jpg.jpeg)

2. Chọn *Source* là *Device* và chọn *File name* là file backup.

![Restore - 02 - Source.](images/restore-02.jpg.jpeg)

3. Chọn file `.bak` để khôi phục.

![Restore - 03 - Destination.](images/restore-03.jpg.jpeg)

4. Chọn *Destination* là *Database* và đặt tên *Database* là *BookingMS*.

![Restore - 04 - Xác Nhận.](images/restore-04.jpg.jpeg)

5. Thông báo Hoàn Thành.

![Restore - 05 - Restore Hoàn Thành.](images/restore-05.jpg.jpeg)

6. Kiểm tra các thành phần của Database vừa được khôi phục.

![Restore - 06 - Kiểm Tra.](images/restore-06.jpg.jpeg)

#### Export - Import Dữ Liệu

**Export:**

1. Chuột phải vào Database cần Export, chọn *Task* > *Export Data-Tier Application...*.

![Export - 01 - Task > Export Data-Tier Application.](images/export-01.jpg.jpeg)

2. Chọn *Next* ở trang *Introduction*.

![Export - 02 - Introduction.](images/export-02.jpg.jpeg)

3. Ở trang *Export Settings*, mục *Save to local disk*, chỉ định đường dẫn lưu file `.bacpac`.

![Export - 03 - Export Settings.](images/export-03.jpg.jpeg)

4. Ở trang *Export Settings*, *Next* và chọn các thành phần (*tables*) cần export.

![Export - 04 - Export Settings.](images/export-04.jpg.jpeg)

5. Ở trang *Summary*, xác nhận thông tin và nhấn *Finish*.

![Export - 05 - Summary.](images/export-05.jpg.jpeg)

6. Kiểm tra tiến độ và kết quả ở trang *Results*.

![Export - 06 - Results.](images/export-06.jpg.jpeg)

7. Kiểm tra kết quả và chắc chắn file `.bacpac` đã được tạo thành công.

![Export - 07 - Kiểm Tra.](images/export-07.jpg.jpeg)

**Import:**

1. Chuột phải vào Database cần Import, chọn *Import Data-Tier Application...*.

![Import - 01 - Import Data-Tier Application.](images/import-01.jpg.jpeg)

2. Chọn *Next* ở trang *Introduction*.

![Import - 02 - Introduction.](images/import-02.jpg.jpeg)

3. Chọn *Browse* để tìm file `.bacpac`.

![Import - 03 - Browse.](images/import-03.jpg.jpeg)

4. Ở trang *Database Settings*, đặt tên cho database tại *New database name*.

![Import - 04 - Database Settings.](images/import-04.jpg.jpeg)

5. Ở trang *Summary*, xác nhận thông tin và nhấn *Finish*.

![Import - 05 - Summary.](images/import-05.jpg.jpeg)

6. Kiểm tra tiến độ và kết quả ở trang *Results*.

![Import - 06 - Results.](images/import-06.jpg.jpeg)

7. Kiểm tra kết quả bằng cách xem các thành phần của Database vừa được import.

![Import - 07 - Kiểm Tra.](images/import-07.jpg.jpeg)
