#import "../template/lib.typ": *

= Cài Đặt - Triển Khai
<cai-dat-trien-khai>

Trong chương này, Nhóm 02 sẽ trình bày chi tiết về việc cài đặt mô hình dữ liệu (mức vật lý) và các chức năng quản lý thông tin trên hệ quản trị cơ sở dữ liệu Microsoft SQL Server.

== Môi Trường Cài Đặt
<moi-truong-cai-dat>

- Hệ quản trị cơ sở dữ liệu (DBMS) được sử dụng là Microsoft SQL Server, phiên bản 2019.
- Công cụ quản lý: SQL Server Management Studio (SSMS), phiên bản 18.12.1.
- Công cụ bổ sung: Azure Data Studio, phiên bản 1.52.0.

== Cài Đặt Mô Hình Dữ Liệu (Mức Vật Lý)
<cai-dat-mo-hinh-du-lieu-muc-vat-ly>

Mô Hình Dữ Liệu, hay Từ Điển Dữ Liệu, trình bày chi tiết thành phần và cấu trúc của cơ sở dữ liệu, bao gồm các bảng, thuộc tính, loại dữ liệu, quan hệ giữa các bảng, và các ràng buộc toàn vẹn.

=== A. Nhóm Bảng Quản Trị & Hệ Thống
<a-nhom-bang-quan-tri-he-thong>


==== 1. ADMINS
<admins>

Lưu trữ tài khoản quản trị viên và nhân viên.

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Tên Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[id]], [`INT`], [`PK`, `IDENTITY`], [Khóa chính tự tăng.], [email], [`NVARCHAR(255)`], [`NOT NULL`, `UNIQUE`], [Email đăng nhập.], [password\_hash], [`NVARCHAR(255)`], [`NOT NULL`], [Mật khẩu (Hash).], [full\_name], [`NVARCHAR(255)`], [`NULL`], [Họ tên đầy đủ.], [status], [`NVARCHAR(50)`], [`DEFAULT 'ACTIVE'`], [Trạng thái tài khoản.], [created\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [updated\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày cập nhật.], [#emph[CHECK]], [], [`status IN ('ACTIVE', 'INACTIVE')`], [Chỉ nhận giá trị quy định.]
)

==== 2. ROLES
<roles>

Định nghĩa các vai trò (nhóm quyền).

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Tên Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[id]], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [code], [`NVARCHAR(50)`], [`NOT NULL`, `UNIQUE`], [Mã vai trò (VD: ADMIN).], [name], [`NVARCHAR(255)`], [`NOT NULL`], [Tên hiển thị.], [description], [`NVARCHAR(500)`], [`NULL`], [Mô tả vai trò.]
)

==== 3. PERMISSIONS
<permissions>

Danh sách các quyền hạn chức năng.

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Tên Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[id]], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [code], [`NVARCHAR(100)`], [`NOT NULL`, `UNIQUE`], [Mã quyền (VD: USER\_READ).], [description], [`NVARCHAR(255)`], [`NULL`], [Mô tả quyền hạn.]
)

==== 4. ADMIN\_ROLES
<4-admin-roles>

Bảng trung gian phân quyền cho Admin.

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Tên Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[admin\_id]], [`INT`], [`PK`, `FK` (ADMINS)], [Khóa ngoại + Khóa chính.], [#strong[role\_id]], [`INT`], [`PK`, `FK` (ROLES)], [Khóa ngoại + Khóa chính.], [#emph[FK Rule]], [], [`ON DELETE CASCADE`], [Xóa Admin/Role tự động xóa dòng này.]
)

==== 5. ROLE\_PERMISSIONS
<5-role-permissions>

Bảng trung gian gán quyền cho Role.

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Tên Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[role\_id]], [`INT`], [`PK`, `FK` (ROLES)], [Khóa ngoại + Khóa chính.], [#strong[permission\_id]], [`INT`], [`PK`, `FK` (PERMISSIONS)], [Khóa ngoại + Khóa chính.], [#emph[FK Rule]], [], [`ON DELETE CASCADE`], [Xóa Role/Permission tự động xóa dòng này.]
)

== Khởi Tạo Cơ Sở Dữ Liệu
<khoi-tao-co-so-du-lieu>


== Dữ Liệu Mẫu
<du-lieu-mau>


=== Phân Quyền
<phan-quyen>


==== ROLES
<roles-1>

```sql
INSERT INTO ROLES (code, name, description) VALUES
('SUPER_ADMIN', N'Quản trị viên cấp cao', N'Toàn quyền quản lý hệ thống'),
('ADMIN', N'Quản trị viên', N'Quản lý phòng và đặt phòng'),
('STAFF', N'Nhân viên', N'Xử lý đặt phòng và thanh toán'),
('ACCOUNTANT', N'Kế toán', N'Quản lý thanh toán và doanh thu'),
('RECEPTIONIST', N'Lễ tân', N'Tiếp nhận khách và check-in/out'),
('MANAGER', N'Quản lý', N'Giám sát hoạt động'),
('MAINTENANCE', N'Bảo trì', N'Quản lý bảo trì phòng'),
('MARKETING', N'Marketing', N'Quản lý khuyến mãi và voucher'),
('SUPPORT', N'Hỗ trợ', N'Hỗ trợ khách hàng'),
('ANALYST', N'Phân tích', N'Xem báo cáo và thống kê');

GO
```
