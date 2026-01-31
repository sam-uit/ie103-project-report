#import "../template/lib.typ": *

== An Toàn Thông Tin
<an-toan-thong-tin>


=== Xác Thực Và Phân Quyền
<xac-thuc-va-phan-quyen>

Hệ thống áp dụng mô hình bảo mật đa lớp, kết hợp giữa cơ chế phân quyền dựa trên vai trò (RBAC) ở mức dữ liệu và bảo mật mức vật lý của hệ quản trị SQL Server.

==== Mã Hóa Mật Khẩu
<ma-hoa-mat-khau>

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

==== Kiểm Soát Truy Cập Dựa Trên Vai Trò (Data-Driven RBAC)
<kiem-soat-truy-cap-dua-tren-vai-tro-data-driven-rbac>

Hệ thống quản lý quyền hạn thông qua các bảng `ROLES`, `PERMISSIONS` và `ADMIN_ROLES`. Quyền truy cập không được gán cứng mà động dựa trên dữ liệu.

Mô hình phân quyền:

#figure(
    table(
    columns: (10%, 20%, 70%),
    align: (right, left, left),
    [STT], [#strong[Vai Trò]], [#strong[Quyền Hạn]], [1], [Admin], [Quản lý tất cả], [2], [Staff], [Quản lý đặt phòng], [3], [End User], [Đặt phòng]
    ),
    caption: [An Toàn Thông Tin - Bảng Phân Quyền]
)
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
