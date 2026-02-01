#import "../template/lib.typ": *

== An Toàn Thông Tin
<an-toan-thong-tin>

Như đã đề cập một phần ở #emph[Chương 3] -- mục #emph[Thiết Lập Nền Tảng Quản Trị & Bảo Mật], phần này của #emph[Chương 4] sẽ trình bày đầy đủ hơn về cách hiện thực các biện pháp bảo mật thông tin trong hệ thống, bao gồm các biện pháp phân quyền, mã hóa mật khẩu, và các biện pháp bảo mật khác. Hệ thống áp dụng mô hình bảo mật đa lớp từ mức Hệ Quản Trị CSDL, tới phân quyền dựa trên vai trò (RBAC) ở mức dữ liệu.

Đồng thời trình bày các công việc của quản trị viên trong việc sao lưu/khôi phục dữ liệu, đảm bảo an toàn thông tin và tính liên tục của vận hành (Business Continuity).

=== Bảo Mật Mức Hệ Quản Trị
<bao-mat-muc-he-quan-tri>

Bảo mật mức hệ quản trị SQL Server là lớp đầu tiên trong #emph[An Toàn Thông Tin] của Hệ Thống BMS.

Để tuân thủ nguyên tắc #emph[Đặc Quyền Tối Thiểu] (Least Privilege) -- mỗi tài khoản chỉ có đủ quyền truy cập vào tài nguyên cần thiết cho các nghiệp vụ cụ thể, hệ thống KHÔNG SỬ DỤNG tài khoản `sa` (System Admin) để kết nối từ ứng dụng vào cơ sở dữ liệu. Thay vào đó, một tài khoản chuyên biệt được tạo ra để kết nối từ ứng dụng vào cơ sở dữ liệu.

- Tạo Login trên Server:

#figure(
  ```sql
  CREATE LOGIN [BMS_App_User] WITH PASSWORD = 'P@ssw0rd123!';
  ```,
  caption: [Bảo Mật Mức Hệ Quản Trị - Tạo Login Server]
)
- Tạo Database User & Gán Quyền:

#figure(
```sql
USE ROOM_BOOKING_SYSTEM;
CREATE USER [BMS_App_User] FOR LOGIN [BMS_App_User];
```,
caption: [Bảo Mật Mức Hệ Quản Trị - Tạo Database User]
)
- Gán Quyền: Chỉ cấp quyền thực thi (`EXECUTE`) trên các Stored Procedure, ngăn chặn truy cập trực tiếp vào bảng dữ liệu.

#figure(
```sql
GRANT EXECUTE TO [BMS_App_User];
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO [BMS_App_User];
GO
```,
caption: [Bảo Mật Mức Hệ Quản Trị - Gán Quyền]
)

=== Mã Hóa Mật Khẩu
<ma-hoa-mat-khau>

Để đảm bảo an toàn dữ liệu người dùng, hệ thống không lưu trữ mật khẩu dưới dạng văn bản thuần (plain-text). Mọi mật khẩu đều được mã hóa một chiều bằng thuật toán SHA-256 thông qua hàm `HASHBYTES` của SQL Server trước khi lưu vào cơ sở dữ liệu.

Tồn tại một Stored Producedure (SP) thực hiện mã hóa mật khẩu mỗi khi tạo User mới (`SP_AUTH_REGISTER`) như miêu tả sau:

#figure(
    raw(read("code/ch04-sp_auth_register.sql"), lang: "sql", block: true),
    caption: [An Toàn Thông Tin -- Mã Hóa Mật Khẩu]
)
Tồn tại một SP Đăng nhập (Kiểm tra Hash mật khẩu khi người dùng đăng nhập) `SP_AUTH_LOGIN`:

- Mã hóa mật khẩu nhập vào và so sánh với mật khẩu đã mã hóa trong database.
- Đảm bảo luôn so sánh cặp `email` đăng nhập và `password_hash` được nhập vào.

#figure(
    raw(read("code/ch04-sp_auth_login.sql"), lang: "sql", block: true),
    caption: [An Toàn Thông Tin -- Kiểm Tra Mật Khẩu Đăng Nhập]
)

=== Xác Thực Và Phân Quyền
<xac-thuc-va-phan-quyen>

Để đảm bảo đúng và đủ quyền thực thi các thao tác tương ứng cho từng vai trò của #emph[Nhân Viên] và của #emph[Khách Hàng], hệ thống áp dụng những cơ chế tương ứng cần thiết.

- Đối với #emph[Nhân Viên]: Hệ thống áp dụng cơ chế phân quyền dựa trên vai trò (RBAC).
  - Mỗi #emph[role] có các quyền tương ứng.
- Đối với #emph[Khách Hàng]: Hệ thống áp dụng cơ chế xác thực quyền sở hữu (OBAC).
  - Mỗi #emph[USER] chỉ được thao tác trên dữ liệu của mình.

==== RBAC (Role-Based Access Control) Cho Nhân Viên
<rbac-role-based-access-control-cho-nhan-vien>

#co-warn[Mọi thủ tục dành cho #emph[Nhân Viên] (các thao tác quản trị: Thêm phòng, Duyệt hoàn tiền...) đều phải đi qua hàm kiểm tra `F_CHECK_PERMISSION` để xác thực xem nhân viên đó có sở hữu quyền (`PERMISSIONS.code`) tương ứng hay không.]
Hệ thống quản lý quyền hạn thông qua các bảng `ROLES`, `PERMISSIONS`, `ROLE_PERMISSIONS` và `ADMIN_ROLES`. Quyền truy cập không được gán cứng mà dựa trên vai trò và quyền hạn của #emph[Admin] hoặc #emph[Staff] (Nhân viên).

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

#figure(
    raw(read("code/ch04-f_check_permission.sql"), lang: "sql", block: true),
    caption: [An Toàn Thông Tin -- Hàm Kiểm Tra Quyền]
)
Luôn sử dụng hàm `F_CHECK_PERMISSION` trên mọi thao thác của #emph[Nhân Viên], để đảm bảo #emph[Nhân Viên] có quyền thực hiện thao tác đó.

- Ví dụ: Thủ tục Hủy đơn Đặt Phòng.

#figure(
    raw(read("code/ch04-f_check_permission_ex.sql"), lang: "sql", block: true),
    caption: [An Toàn Thông Tin -- Sử Dụng Hàm Kiểm Tra Quyền]
)

==== OBAC (Ownership-Based Access Control) Cho Khách Hàng
<obac-ownership-based-access-control-cho-khach-hang>

- Quyền hạn được kiểm tra dựa trên tính sở hữu dữ liệu.

#co-warn[Mọi thủ tục dành cho #emph[Khách Hàng] đều cần có logic kiểm tra tính sở hữu dữ liệu. Mỗi Khách Hàng chỉ được phép thao tác trên dữ liệu thuộc về người đó.]
Ví dụ 1: Đối với End User, quyền "Đặt Phòng" là quyền mặc định. Ta chỉ cần kiểm tra: User có tồn tại và đang hoạt động hay không.

#figure(
    raw(read("code/ch04-obac-ex1.sql"), lang: "sql", block: true),
    caption: [An Toàn Thông Tin -- OBAC đối với USERS -- Ví dụ 1.]
)
Ví dụ 2: Trong thủ tục Hủy Đặt Phòng (giả sử), hệ thống bắt buộc kiểm tra điều kiện `WHERE user_id = @CurrentUserId` để đảm bảo người dùng chỉ có thể thao tác trên các đơn đặt phòng của chính họ.

#figure(
    raw(read("code/ch04-obac-ex2.sql"), lang: "sql", block: true),
    caption: [An Toàn Thông Tin -- OBAC đối với USERS -- Ví dụ 2.]
)

=== Sao Lưu & Phục Hồi
<sao-luu-phuc-hoi>

Để đảm bảo tính sẵn sàng (Availability) và liên tục (Business Contuinity) cũng như khả năng phục hồi sau thảm họa (Disaster Recovery), quy trình sao lưu dữ liệu được thực hiện định kỳ với chiến lược sao lưu dữ liệu được đề xuất sau đây.

- Full Backup: Thực hiện định kỳ vào 00:00 Chủ Nhật hàng tuần.
  - Mỗi bản Full backup được lưu giữ trong 2 tuần.
- Differential Backup: Thực hiện vào 00:00 các ngày trong tuần.
  - Mỗi bản Differential backup được lưu giữ trong 1 tuần.
- Export/Import: Sử dụng trong các tình huống cụ thể.
  - Không quy định thời gian lưu giữ, tùy tình huống hoặc yêu cầu khi thực hiện.
  - Cần có bản ghi chú về thời gian, và mục đích tạo.

==== Backup -- Restore Dữ Liệu
<backup-restore-du-lieu>

#strong[Backup:]

+ Chuột phải vào Database, chọn #emph[Task] \> #emph[Back Up…].
+ Chọn #emph[Full] hoặc #emph[Differential] trong mục #emph[Backup type]. Chọn #emph[Destination] là #emph[Disk]
+ Thêm đường dẫn thư mục lưu file backup.
+ Nhấn #emph[OK].
+ Thông báo Hoàn Thành.

#strong[Restore:]

+ Chuột phải vào mục Database của Server, chọn #emph[Restore Database…].
+ Chọn #emph[Source] là #emph[Device] và chọn #emph[File name] là file backup.
+ Chọn file `.bak` để khôi phục.
+ Chọn #emph[Destination] là #emph[Database] và đặt tên #emph[Database] là #emph[BookingMS].
+ Thông báo Hoàn Thành.
+ Kiểm tra các thành phần của Database vừa được khôi phục.

==== Export - Import Dữ Liệu
<export-import-du-lieu>

#strong[Export:]

+ Chuột phải vào Database cần Export, chọn #emph[Task] \> #emph[Export Data-Tier Application…].
+ Chọn #emph[Next] ở trang #emph[Introduction].
+ Ở trang #emph[Export Settings], mục #emph[Save to local disk], chỉ định đường dẫn lưu file `.bacpac`.
+ Ở trang #emph[Export Settings], #emph[Next] và chọn các thành phần (#emph[tables]) cần export.
+ Ở trang #emph[Summary], xác nhận thông tin và nhấn #emph[Finish].
+ Kiểm tra tiến độ và kết quả ở trang #emph[Results].
+ Kiểm tra kết quả và chắc chắn file `.bacpac` đã được tạo thành công.

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
