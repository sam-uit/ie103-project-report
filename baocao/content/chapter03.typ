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

- Lưu trữ tài khoản quản trị viên và nhân viên.

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[id]], [`INT`], [`PK`, `IDENTITY`], [Khóa chính tự tăng.], [email], [`NVARCHAR(255)`], [`NOT NULL`, `UNIQUE`], [Email đăng nhập.], [password\_hash], [`NVARCHAR(255)`], [`NOT NULL`], [Mật khẩu (Hash).], [full\_name], [`NVARCHAR(255)`], [`NULL`], [Họ tên đầy đủ.], [status], [`NVARCHAR(50)`], [`DEFAULT 'ACTIVE'`], [Trạng thái tài khoản.], [created\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [updated\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày cập nhật.], [#emph[CHECK]], [], [`status IN ('ACTIVE', 'INACTIVE')`], [Chỉ nhận giá trị quy định.]
)

==== 2. ROLES
<roles>

- Định nghĩa các vai trò (nhóm quyền).

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[id]], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [code], [`NVARCHAR(50)`], [`NOT NULL`, `UNIQUE`], [Mã vai trò (VD: ADMIN).], [name], [`NVARCHAR(255)`], [`NOT NULL`], [Tên hiển thị.], [description], [`NVARCHAR(500)`], [`NULL`], [Mô tả vai trò.]
)

==== 3. PERMISSIONS
<permissions>

- Danh sách các quyền hạn chức năng.

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[id]], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [code], [`NVARCHAR(100)`], [`NOT NULL`, `UNIQUE`], [Mã quyền (VD: USER\_READ).], [description], [`NVARCHAR(255)`], [`NULL`], [Mô tả quyền hạn.]
)

==== 4. ADMIN\_ROLES
<4-admin-roles>

- Bảng trung gian phân quyền cho Admin.

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[admin\_id]], [`INT`], [`PK`, `FK` (ADMINS)], [Khóa ngoại + Khóa chính.], [#strong[role\_id]], [`INT`], [`PK`, `FK` (ROLES)], [Khóa ngoại + Khóa chính.], [#emph[FK Rule]], [], [`ON DELETE CASCADE`], [Xóa Admin/Role tự động xóa dòng này.]
)

==== 5. ROLE\_PERMISSIONS
<5-role-permissions>

- Bảng trung gian gán quyền cho Role.

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[role\_id]], [`INT`], [`PK`, `FK` (ROLES)], [Khóa ngoại + Khóa chính.], [#strong[permission\_id]], [`INT`], [`PK`, `FK` (PERMISSIONS)], [Khóa ngoại + Khóa chính.], [#emph[FK Rule]], [], [`ON DELETE CASCADE`], [Xóa Role/Permission tự động xóa dòng này.]
)

=== B. Nhóm Bảng Nghiệp Vụ Chính
<b-nhom-bang-nghiep-vu-chinh>


==== 6. USERS
<users>

- Thông tin người dùng cuối (Khách hàng).

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[id]], [`INT`], [`PK`, `IDENTITY`], [Khóa chính tự tăng.], [email], [`NVARCHAR(255)`], [`NOT NULL`, `UNIQUE`], [Email đăng nhập.], [password\_hash], [`NVARCHAR(255)`], [`NOT NULL`], [Mật khẩu (Hash).], [full\_name], [`NVARCHAR(255)`], [`NULL`], [Họ tên khách hàng.], [phone\_number], [`NVARCHAR(20)`], [`NULL`], [Số điện thoại.], [address], [`NVARCHAR(500)`], [`NULL`], [Địa chỉ liên hệ.], [created\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày đăng ký.], [updated\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày cập nhật.]
)

==== 7. LOAIPHONG
<loaiphong>

- Danh mục loại phòng.

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[id]], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [ten\_loai], [`NVARCHAR(100)`], [`NOT NULL`], [Tên loại (VD: Deluxe).], [mo\_ta], [`NVARCHAR(500)`], [`NULL`], [Mô tả tiện nghi.], [gia\_co\_ban], [`DECIMAL(18,2)`], [`NOT NULL`], [Giá niêm yết.], [suc\_chua], [`INT`], [`NOT NULL`], [Số người tối đa.], [created\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [updated\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày cập nhật.]
)

==== 8. PHONG
<phong>

- Danh sách phòng vật lý.

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[id]], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [loai\_phong\_id], [`INT`], [`FK` (LOAIPHONG), `NOT NULL`], [Loại phòng tương ứng.], [so\_phong], [`NVARCHAR(50)`], [`NOT NULL`, `UNIQUE`], [Số phòng (VD: 101).], [trang\_thai], [`NVARCHAR(50)`], [`DEFAULT 'AVAILABLE'`], [Trạng thái phòng.], [created\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [updated\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày cập nhật.], [#emph[CHECK]], [], [`trang_thai IN ('AVAILABLE', 'BOOKED', 'MAINTENANCE')`], [Ràng buộc trạng thái.]
)

==== 9. DICHVU
<dichvu>

- Danh mục dịch vụ đi kèm.

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[id]], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [ten\_dich\_vu], [`NVARCHAR(100)`], [`NOT NULL`], [Tên dịch vụ.], [mo\_ta], [`NVARCHAR(500)`], [`NULL`], [Mô tả chi tiết.], [don\_gia], [`DECIMAL(18,2)`], [`NOT NULL`], [Giá dịch vụ.], [trang\_thai], [`NVARCHAR(50)`], [`DEFAULT 'ACTIVE'`], [Trạng thái.], [created\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [updated\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày cập nhật.], [#emph[CHECK]], [], [`don_gia > 0`], [Đơn giá phải dương.], [#emph[CHECK]], [], [`trang_thai IN ('ACTIVE', 'INACTIVE')`], [Ràng buộc trạng thái.]
)

==== 10. VOUCHERS
<vouchers>

- Mã giảm giá và khuyến mãi.

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[id]], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [code], [`NVARCHAR(50)`], [`NOT NULL`, `UNIQUE`], [Mã Voucher (VD: TET2025).], [mo\_ta], [`NVARCHAR(500)`], [`NULL`], [Mô tả chương trình.], [giam\_gia], [`DECIMAL(18,2)`], [`NOT NULL`], [Giá trị giảm.], [loai\_giam\_gia], [`NVARCHAR(20)`], [`NOT NULL`], [Loại (`PERCENT`, `FIXED`).], [ngay\_bat\_dau], [`DATETIME`], [`NOT NULL`], [Ngày bắt đầu.], [ngay\_ket\_thuc], [`DATETIME`], [`NOT NULL`], [Ngày kết thúc.], [so\_luong], [`INT`], [`NOT NULL`], [Số lượng mã.], [trang\_thai], [`NVARCHAR(50)`], [`DEFAULT 'ACTIVE'`], [Trạng thái.], [created\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [updated\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày cập nhật.], [#emph[CHECK]], [], [`trang_thai IN ('ACTIVE', 'EXPIRED', 'DISABLED')`], [Ràng buộc trạng thái.], [#emph[CHECK]], [], [`loai_giam_gia IN ('PERCENT', 'FIXED')`], [Ràng buộc loại giảm.]
)

=== C. Nhóm Bảng Giao Dịch & Chi Tiết
<c-nhom-bang-giao-dich-chi-tiet>


==== 11. DATPHONG
<datphong>

- Đơn đặt phòng.

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[id]], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [user\_id], [`INT`], [`FK` (USERS), `NOT NULL`], [Khách đặt phòng.], [voucher\_id], [`INT`], [`FK` (VOUCHERS), `NULL`], [Voucher áp dụng (nếu có).], [ngay\_dat], [`DATETIME`], [`DEFAULT GETDATE()`], [Thời gian đặt.], [ngay\_checkin], [`DATE`], [`NOT NULL`], [Ngày nhận phòng.], [ngay\_checkout], [`DATE`], [`NOT NULL`], [Ngày trả phòng.], [tong\_tien], [`DECIMAL(18,2)`], [`NOT NULL`], [Tổng tiền đơn.], [trang\_thai], [`NVARCHAR(50)`], [`DEFAULT 'PENDING'`], [Trạng thái đơn.], [created\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [updated\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày cập nhật.], [#emph[CHECK]], [], [`trang_thai IN ('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED')`], [Ràng buộc trạng thái.]
)

==== 12. CT\_DATPHONG
<12-ct-datphong>

- Chi tiết phòng trong đơn đặt.

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[id]], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [datphong\_id], [`INT`], [`FK` (DATPHONG), `NOT NULL`], [Thuộc đơn đặt phòng nào.], [phong\_id], [`INT`], [`FK` (PHONG), `NOT NULL`], [Phòng nào.], [gia\_tien], [`DECIMAL(18,2)`], [`NOT NULL`], [Giá phòng tại thời điểm đặt.], [created\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [#emph[FK Rule]], [], [`datphong_id ON DELETE CASCADE`], [Xóa đơn xóa luôn chi tiết.]
)

==== 13. CT\_SUDUNG\_DV
<13-ct-sudung-dv>

- Chi tiết sử dụng dịch vụ.

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[id]], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [datphong\_id], [`INT`], [`FK` (DATPHONG), `NOT NULL`], [Thuộc đơn đặt phòng nào.], [dichvu\_id], [`INT`], [`FK` (DICHVU), `NOT NULL`], [Dịch vụ nào.], [so\_luong], [`INT`], [`DEFAULT 1`, `NOT NULL`], [Số lượng.], [don\_gia], [`DECIMAL(18,2)`], [`NOT NULL`], [Đơn giá tại thời điểm dùng.], [thoi\_diem\_su\_dung], [`DATETIME`], [`DEFAULT GETDATE()`], [Thời gian order.], [ghi\_chu], [`NVARCHAR(500)`], [`NULL`], [Ghi chú thêm.], [created\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [#emph[CHECK]], [], [`so_luong > 0`, `don_gia > 0`], [Số lượng và giá phải dương.]
)

==== 14. PAYMENTS
<payments>

- Giao dịch thanh toán.

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[id]], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [datphong\_id], [`INT`], [`FK` (DATPHONG), `NOT NULL`], [Thanh toán cho đơn nào.], [user\_id], [`INT`], [`FK` (USERS), `NOT NULL`], [Người thanh toán.], [so\_tien], [`DECIMAL(18,2)`], [`NOT NULL`], [Số tiền giao dịch.], [phuong\_thuc], [`NVARCHAR(50)`], [`NOT NULL`], [Cách trả (`CASH`, `BANK`…).], [ma\_giao\_dich], [`NVARCHAR(100)`], [`UNIQUE`, `NULL`], [Ref ID (nếu CK online).], [ngay\_thanh\_toan], [`DATETIME`], [`DEFAULT GETDATE()`], [Thời điểm trả.], [trang\_thai], [`NVARCHAR(50)`], [`DEFAULT 'PENDING'`], [Trạng thái giao dịch.], [created\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [updated\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày cập nhật.], [#emph[CHECK]], [], [`so_tien > 0`], [Tiền phải dương.], [#emph[CHECK]], [], [`trang_thai IN ('PENDING', 'SUCCESS', 'FAILED')`], [Ràng buộc trạng thái.]
)

==== 15. REFUNDS
<refunds>

- Yêu cầu hoàn tiền.

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[id]], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [payment\_id], [`INT`], [`FK` (PAYMENTS), `NOT NULL`], [Hoàn tiền cho giao dịch nào.], [user\_id], [`INT`], [`FK` (USERS), `NOT NULL`], [Người yêu cầu.], [admin\_id], [`INT`], [`FK` (ADMINS), `NULL`], [Người duyệt.], [so\_tien], [`DECIMAL(18,2)`], [`NOT NULL`], [Số tiền hoàn.], [ly\_do], [`NVARCHAR(500)`], [`NULL`], [Lý do hoàn tiền.], [ngay\_hoan\_tien], [`DATETIME`], [`NULL`], [Thời điểm hoàn thành.], [trang\_thai], [`NVARCHAR(50)`], [`DEFAULT 'PENDING'`], [Trạng thái.], [created\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [updated\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày cập nhật.], [#emph[CHECK]], [], [`trang_thai IN ('PENDING', 'APPROVED', 'REJECTED')`], [Ràng buộc trạng thái.]
)

==== 16. REVIEWS
<reviews>

- Đánh giá từ khách hàng.

#table(
  columns: (1fr,) * 4,
  align: (left, left, left, left),
  [Thuộc Tính], [Kiểu Dữ Liệu], [Ràng Buộc (Constraints)], [Mô Tả], [#strong[id]], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [user\_id], [`INT`], [`FK` (USERS), `NOT NULL`], [Người đánh giá.], [phong\_id], [`INT`], [`FK` (PHONG), `NOT NULL`], [Phòng được đánh giá.], [datphong\_id], [`INT`], [`FK` (DATPHONG), `UNIQUE`], [Thuộc đơn nào (Duy nhất 1-1).], [so\_sao], [`INT`], [`NOT NULL`], [Điểm sao (1-5).], [binh\_luan], [`NVARCHAR(1000)`], [`NULL`], [Nội dung text.], [ngay\_danh\_gia], [`DATE`], [`DEFAULT GETDATE()`], [Ngày đánh giá.], [trang\_thai], [`NVARCHAR(50)`], [`DEFAULT 'VISIBLE'`], [Trạng thái hiển thị.], [created\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [updated\_at], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày cập nhật.], [#emph[CHECK]], [], [`so_sao BETWEEN 1 AND 5`], [Giới hạn 1 đến 5 sao.], [#emph[CHECK]], [], [`trang_thai IN ('VISIBLE', 'HIDDEN')`], [Ràng buộc hiển thị.]
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
