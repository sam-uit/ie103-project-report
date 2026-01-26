#import "../template/lib.typ": *

= Cài Đặt - Triển Khai
<cai-dat-trien-khai>


== Cài Đặt Mô Hình Dữ Liệu (Mức Vật Lý)
<cai-dat-mo-hinh-du-lieu-muc-vat-ly>

- Hệ quản trị cơ sở dữ liệu (DBMS) được sử dụng là Microsoft SQL Server.
- Dưới đây là đặc tả chi tiết các bảng dữ liệu, kiểu dữ liệu và các ràng buộc toàn vẹn.

== Dữ Liệu Mẫu
<du-lieu-mau>


=== Phân Quyền
<phan-quyen>


==== ROLES
<roles>

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
