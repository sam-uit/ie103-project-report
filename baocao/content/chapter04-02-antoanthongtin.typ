#import "../template/lib.typ": *

== An Toàn Thông Tin
<an-toan-thong-tin>

Mục này trình bày về cách hiện thực các biện pháp bảo mật thông tin trong hệ thống, bao gồm các biện pháp phân quyền, mã hóa mật khẩu, và các biện pháp bảo mật khác. Hệ thống áp dụng mô hình bảo mật đa lớp từ mức Vật Lý của Hệ Quản Trị CSDL, tới phân quyền dựa trên vai trò (RBAC) ở mức dữ liệu.

Đồng thời trình bày các công việc của quản trị viên trong việc sao lưu/khôi phục dữ liệu, đảm bảo an toàn thông tin và tính liên tục của vận hành (Business Continuity).

=== Bảo Mật Mức Hệ Quản Trị
<bao-mat-muc-he-quan-tri>

Bảo mật mức vật lý của hệ quản trị SQL Server là lớp đầu tiên trong An Toàn Thông Tin của Hệ Thống BMS.

Để tuân thủ nguyên tắc "Đặc quyền tối thiểu" (Least Privilege) -- mỗi tài khoản chỉ có quyền truy cập vào tài nguyên cần thiết, hệ thống KHÔNG SỬ DỤNG tài khoản `sa` (System Admin) để kết nối từ ứng dụng vào cơ sở dữ liệu. Thay vào đó, một tài khoản chuyên biệt được tạo ra để kết nối từ ứng dụng vào cơ sở dữ liệu.

+ Tạo Login Server:

```sql
CREATE LOGIN [BMS_App_User] WITH PASSWORD = 'P@ssw0rd123!';
```

#block[
#set enum(numbering: "1.", start: 2)
+ Tạo Database User & Gán Quyền:
]

```sql
USE ROOM_BOOKING_SYSTEM;
CREATE USER [BMS_App_User] FOR LOGIN [BMS_App_User];
```

#block[
#set enum(numbering: "1.", start: 3)
+ Gán Quyền: Chỉ cấp quyền thực thi (EXECUTE) trên các Stored Procedure, ngăn chặn truy cập trực tiếp vào bảng dữ liệu.
]

```sql
GRANT EXECUTE TO [BMS_App_User];
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO [BMS_App_User];
GO
```

=== Xác Thực Và Phân Quyền
<xac-thuc-va-phan-quyen>

Hệ thống áp dụng cơ chế phân quyền dựa trên vai trò (RBAC).

==== Mã Hóa Mật Khẩu
<ma-hoa-mat-khau>

Để đảm bảo an toàn dữ liệu người dùng, hệ thống không lưu trữ mật khẩu dưới dạng văn bản thuần (plain-text). Mọi mật khẩu đều được mã hóa một chiều bằng thuật toán SHA-256 thông qua hàm HASHBYTES của SQL Server trước khi lưu vào cơ sở dữ liệu.

Tạo một Stored Producedure thực hiện mã hóa mật khẩu mỗi khi tạo User mới (`SP_AUTH_REGISTER`) như miêu tả sau:

```sql
--- Phần quan trọng: Mã hóa mật khẩu trước khi ghi vào bảng USERS.
BEGIN
    DECLARE @PasswordHash VARBINARY(64);
    SET @PasswordHash = HASHBYTES('SHA2_256', @Password);

    INSERT INTO USERS (email, password_hash, full_name)
    VALUES (@Email, CONVERT(NVARCHAR(255), @Hash, 1), @FullName);
END
```

SP Đăng nhập (Kiểm tra Hash mật khẩu khi người dùng đăng nhập) `SP_AUTH_LOGIN`:

- Mã hóa mật khẩu nhập vào và so sánh với mật khẩu đã mã hóa trong database.
- Đảm bảo luôn so sánh cặp `email` đăng nhập và `mật khẩu` được nhập vào.

```sql
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

==== Kiểm Soát Truy Cập Dựa Trên Vai Trò (Data-Driven RBAC)
<kiem-soat-truy-cap-dua-tren-vai-tro-data-driven-rbac>

Hệ thống quản lý quyền hạn thông qua các bảng `ROLES`, `PERMISSIONS` và `ADMIN_ROLES`. Quyền truy cập không được gán cứng mà dựa trên vai trò và quyền hạn của #emph[Admin] hoặc #emph[Staff] (Nhân viên).

Mô hình phân quyền:

#figure(
    table(
    columns: (10%, 20%, 70%),
    align: (right + bottom, left + bottom, left + bottom),
    [STT], [#strong[Vai Trò]], [#strong[Quyền Hạn]],
    [1], [`SUPER_ADMIN`], [Quản trị viên cấp cao],
    [2], [`ADMIN`], [Quản trị viên],
    [3], [`STAFF`], [Nhân viên],
    [4], [`ACCOUNTANT`], [Kế toán],
    [5], [`RECEPTIONIST`], [Lễ tân],
    [6], [`MANAGER`], [Quản lý],
    [7], [`MAINTENANCE`], [Bảo trì],
    [8], [`MARKETING`], [Marketing],
    [9], [`SUPPORT`], [Hỗ trợ],
    [10], [`ANALYST`], [Phân tích]
    ),
    caption: [An Toàn Thông Tin - Bảng Phân Quyền]
)
Thủ tục kiểm tra quyền `F_CHECK_PERMISSION`:

- Kiểm tra quyền bằng cách liên kết các bảng, và chỉ cho phép truy cập vào tài nguyên hệ thống nếu staff/admin có quyền truy cập vào tài nguyên đó.
- Miêu tả nhanh như dưới đây.

```sql
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

=== Sao Lưu & Phục Hồi
<sao-luu-phuc-hoi>

Chiến lược sao lưu dữ liệu được đề xuất:

- Full Backup: Thực hiện định kỳ vào 00:00 Chủ Nhật hàng tuần.
  - Mỗi bản Full backup được lưu giữ trong 2 tuần.
- Differential Backup: Thực hiện vào 00:00 các ngày trong tuần.
  - Mỗi bản Differential backup được lưu giữ trong 1 tuần.
- Export/Import: Sử dụng trong các tình huống cụ thể.
  - Không quy định thời gian lưu giữ, tùy tình huống hoặc yêu cầu khi thực hiện.

==== Backup -- Restore Dữ Liệu
<backup-restore-du-lieu>

#strong[Backup:]

+ Chuột phải vào Database, chọn #emph[Task] \> #emph[Back Up…].

#figure(image("images/backup-01.jpg.jpeg"),
  caption: [
    Backup - 01 - Task \> Back Up.
  ]
)

#block[
#set enum(numbering: "1.", start: 2)
+ Chọn #emph[Full] hoặc #emph[Differential] trong mục #emph[Backup type]. Chọn #emph[Destination] là #emph[Disk]
]

#figure(image("images/backup-02.jpg.jpeg"),
  caption: [
    Backup - 02 - Backup Type.
  ]
)

#block[
#set enum(numbering: "1.", start: 3)
+ Thêm đường dẫn thư mục lưu file backup.
]

#figure(image("images/backup-03.jpg.jpeg"),
  caption: [
    Backup - 03 - Backup Destination.
  ]
)

#block[
#set enum(numbering: "1.", start: 4)
+ Nhấn #emph[OK].
]

#figure(image("images/backup-04.jpg.jpeg"),
  caption: [
    Backup - 04 - Xác Nhận.
  ]
)

#block[
#set enum(numbering: "1.", start: 5)
+ Thông báo Hoàn Thành.
]

#figure(image("images/backup-05.jpg.jpeg"),
  caption: [
    Backup - 05 - Backup Hoàn Thành.
  ]
)

#strong[Restore:]

+ Chuột phải vào mục Database của Server, chọn #emph[Restore Database…].

#figure(image("images/restore-01.jpg.jpeg"),
  caption: [
    Restore - 01 - Restore Database.
  ]
)

#block[
#set enum(numbering: "1.", start: 2)
+ Chọn #emph[Source] là #emph[Device] và chọn #emph[File name] là file backup.
]

#figure(image("images/restore-02.jpg.jpeg"),
  caption: [
    Restore - 02 - Source.
  ]
)

#block[
#set enum(numbering: "1.", start: 3)
+ Chọn file `.bak` để khôi phục.
]

#figure(image("images/restore-03.jpg.jpeg"),
  caption: [
    Restore - 03 - Destination.
  ]
)

#block[
#set enum(numbering: "1.", start: 4)
+ Chọn #emph[Destination] là #emph[Database] và đặt tên #emph[Database] là #emph[BookingMS].
]

#figure(image("images/restore-04.jpg.jpeg"),
  caption: [
    Restore - 04 - Xác Nhận.
  ]
)

#block[
#set enum(numbering: "1.", start: 5)
+ Thông báo Hoàn Thành.
]

#figure(image("images/restore-05.jpg.jpeg"),
  caption: [
    Restore - 05 - Restore Hoàn Thành.
  ]
)

#block[
#set enum(numbering: "1.", start: 6)
+ Kiểm tra các thành phần của Database vừa được khôi phục.
]

#figure(image("images/restore-06.jpg.jpeg"),
  caption: [
    Restore - 06 - Kiểm Tra.
  ]
)

==== Export - Import Dữ Liệu
<export-import-du-lieu>

#strong[Export:]

+ Chuột phải vào Database cần Export, chọn #emph[Task] \> #emph[Export Data-Tier Application…].

#figure(image("images/export-01.jpg.jpeg"),
  caption: [
    Export - 01 - Task \> Export Data-Tier Application.
  ]
)

#block[
#set enum(numbering: "1.", start: 2)
+ Chọn #emph[Next] ở trang #emph[Introduction].
]

#figure(image("images/export-02.jpg.jpeg"),
  caption: [
    Export - 02 - Introduction.
  ]
)

#block[
#set enum(numbering: "1.", start: 3)
+ Ở trang #emph[Export Settings], mục #emph[Save to local disk], chỉ định đường dẫn lưu file `.bacpac`.
]

#figure(image("images/export-03.jpg.jpeg"),
  caption: [
    Export - 03 - Export Settings.
  ]
)

#block[
#set enum(numbering: "1.", start: 4)
+ Ở trang #emph[Export Settings], #emph[Next] và chọn các thành phần (#emph[tables]) cần export.
]

#figure(image("images/export-04.jpg.jpeg"),
  caption: [
    Export - 04 - Export Settings.
  ]
)

#block[
#set enum(numbering: "1.", start: 5)
+ Ở trang #emph[Summary], xác nhận thông tin và nhấn #emph[Finish].
]

#figure(image("images/export-05.jpg.jpeg"),
  caption: [
    Export - 05 - Summary.
  ]
)

#block[
#set enum(numbering: "1.", start: 6)
+ Kiểm tra tiến độ và kết quả ở trang #emph[Results].
]

#figure(image("images/export-06.jpg.jpeg"),
  caption: [
    Export - 06 - Results.
  ]
)

#block[
#set enum(numbering: "1.", start: 7)
+ Kiểm tra kết quả và chắc chắn file `.bacpac` đã được tạo thành công.
]

#figure(image("images/export-07.jpg.jpeg"),
  caption: [
    Export - 07 - Kiểm Tra.
  ]
)

#strong[Import:]

+ Chuột phải vào Database cần Import, chọn #emph[Import Data-Tier Application…].

#figure(image("images/import-01.jpg.jpeg"),
  caption: [
    Import - 01 - Import Data-Tier Application.
  ]
)

#block[
#set enum(numbering: "1.", start: 2)
+ Chọn #emph[Next] ở trang #emph[Introduction].
]

#figure(image("images/import-02.jpg.jpeg"),
  caption: [
    Import - 02 - Introduction.
  ]
)

#block[
#set enum(numbering: "1.", start: 3)
+ Chọn #emph[Browse] để tìm file `.bacpac`.
]

#figure(image("images/import-03.jpg.jpeg"),
  caption: [
    Import - 03 - Browse.
  ]
)

#block[
#set enum(numbering: "1.", start: 4)
+ Ở trang #emph[Database Settings], đặt tên cho database tại #emph[New database name].
]

#figure(image("images/import-04.jpg.jpeg"),
  caption: [
    Import - 04 - Database Settings.
  ]
)

#block[
#set enum(numbering: "1.", start: 5)
+ Ở trang #emph[Summary], xác nhận thông tin và nhấn #emph[Finish].
]

#figure(image("images/import-05.jpg.jpeg"),
  caption: [
    Import - 05 - Summary.
  ]
)

#block[
#set enum(numbering: "1.", start: 6)
+ Kiểm tra tiến độ và kết quả ở trang #emph[Results].
]

#figure(image("images/import-06.jpg.jpeg"),
  caption: [
    Import - 06 - Results.
  ]
)

#block[
#set enum(numbering: "1.", start: 7)
+ Kiểm tra kết quả bằng cách xem các thành phần của Database vừa được import.
]

#figure(image("images/import-07.jpg.jpeg"),
  caption: [
    Import - 07 - Kiểm Tra.
  ]
)
