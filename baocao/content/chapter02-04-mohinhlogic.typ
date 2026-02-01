#import "../template/lib.typ": *

== Mô Hình Mức Logic
<mo-hinh-muc-logic>

Quy cách trình bày:

- Khóa chính: #underline[gạch chân] (ví dụ: #underline[id])
- Khóa ngoại: #emph[in nghiêng] (ví dụ: #emph[loai\_phong\_id])

=== Nhóm Bảng Thực Thể
<nhom-bang-thuc-the>


==== ADMINS (Quản Lý/Quản Trị Viên)
<admins-quan-ly-quan-tri-vien>

ADMINS(#underline[id], email, password\_hash, full\_name, status, created\_at, updated\_at)

#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh duy nhất của admin.], [email], [Tên đăng nhập của admin.], [password\_hash], [Mật khẩu của admin.], [full\_name], [Họ tên đầy đủ của admin.], [status], [Trạng thái của admin.], [created\_at], [Thời gian tạo của admin.], [updated\_at], [Thời gian cập nhật của admin.]
  ),
  caption: [Mô Hình Mức Logic: ADMINS],
)

==== DATPHONG (Đặt Phòng)
<datphong-dat-phong>

- Lưu trữ thông tin header của đơn đặt phòng.

DATPHONG(#underline[id], #emph[user\_id], #emph[voucher\_id], check\_in, check\_out, trang\_thai, created\_at)

#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh đơn đặt phòng.], [#emph[user\_id]], [Khóa ngoại tham chiếu tới bảng USERS (Người đặt).], [#emph[voucher\_id]], [Khóa ngoại tham chiếu tới bảng VOUCHERS (Mã giảm giá áp dụng, có thể
    NULL).], [check\_in], [Ngày nhận phòng dự kiến.], [check\_out], [Ngày trả phòng dự kiến.], [trang\_thai], [Trạng thái đơn (PENDING, CONFIRMED, CANCELLED, COMPLETED).], [created\_at], [Thời gian tạo đơn.]
  ),
  caption: [Mô Hình Mức Logic: DATPHONG],
)

==== DICHVU (Dịch Vụ)
<dichvu-dich-vu>

- Danh mục các dịch vụ đi kèm (Ăn uống, Spa, Đưa đón…).

DICHVU(#underline[id], ten\_dich\_vu, don\_gia, don\_vi\_tinh, trang\_thai, created\_at, updated\_at)

#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh dịch vụ.], [ten\_dich\_vu], [Tên dịch vụ.], [don\_gia], [Đơn giá niêm yết.], [don\_vi\_tinh], [Đơn vị tính.], [trang\_thai], [Trạng thái khả dụng (ACTIVE/INACTIVE).], [created\_at], [Ngày tạo.], [updated\_at], [Ngày cập nhật.]
  ),
  caption: [Mô Hình Mức Logic: DICHVU],
)

==== LOAIPHONG (Loại Phòng)
<loaiphong-loai-phong>

- Danh mục phân loại phòng (Deluxe, Standard, Suite…).

LOAIPHONG(#underline[id], ten\_loai, gia\_co\_ban, mo\_ta, suc\_chua)

#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh loại phòng.], [ten\_loai], [Tên hiển thị của loại phòng.], [gia\_co\_ban], [Giá gốc theo đêm.], [mo\_ta], [Mô tả chi tiết loại phòng.], [suc\_chua], [Số người tối đa cho phép.]
  ),
  caption: [Mô Hình Mức Logic: LOAIPHONG],
)

==== PAYMENTS (Thanh Toán)
<payments-thanh-toan>

- Lưu trữ lịch sử giao dịch thanh toán.

PAYMENTS(#underline[id], #emph[booking\_id], #emph[user\_id], so\_tien, phuong\_thuc, trang\_thai, created\_at)

#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh giao dịch.], [#emph[booking\_id]], [Khóa ngoại tham chiếu đơn đặt phòng được thanh toán.], [#emph[user\_id]], [Khóa ngoại tham chiếu người thực hiện thanh toán.], [so\_tien], [Số tiền thanh toán.], [phuong\_thuc], [Phương thức (TIEN\_MAT, CHUYEN\_KHOAN, THE, ONLINE).], [trang\_thai], [Trạng thái giao dịch (PENDING, SUCCESS, FAILED, CANCELLED, PAID, UNPAID,
    REFUNDED).], [created\_at], [Ngày tạo.]
  ),
  caption: [Mô Hình Mức Logic: PAYMENTS],
)

==== PERMISSIONS (Quyền Hạn)
<permissions-quyen-han>

- Danh sách các quyền hạn cụ thể trong hệ thống.

PERMISSIONS(#underline[id], code, description)

#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh quyền hạn.], [code], [Mã code hệ thống (ví dụ: `VIEW_DASHBOARD`, `EDIT_ROOM`).], [description], [Mô tả chi tiết quyền hạn.]
  ),
  caption: [Mô Hình Mức Logic: PERMISSIONS],
)

==== PHONG (Phòng)
<phong-phong>

- Danh sách các phòng vật lý.

PHONG(#underline[id], so\_phong, #emph[loai\_phong\_id], trang\_thai)

#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh phòng.], [so\_phong], [Số hiệu phòng (ví dụ: 101, 202).], [#emph[loai\_phong\_id]], [Khóa ngoại tham chiếu tới bảng LOAIPHONG.], [trang\_thai], [Trạng thái hiện tại (AVAILABLE, OCCUPIED, MAINTENANCE, RESERVED).]
  ),
  caption: [Mô Hình Mức Logic: PHONG],
)

==== REFUNDS (Hoàn Tiền)
<refunds-hoan-tien>

- Lưu trữ yêu cầu và lịch sử hoàn tiền.

REFUNDS(#underline[id], #emph[payment\_id], #emph[requested\_by], #emph[approved\_by], so\_tien\_hoan, ly\_do, trang\_thai, created\_at, updated\_at)

#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh yêu cầu hoàn tiền.], [#emph[payment\_id]], [Khóa ngoại tham chiếu giao dịch gốc cần hoàn tại PAYMENTS.], [#emph[requested\_by]], [Người yêu cầu hoàn tiền, khóa ngoại tham chiếu tới USERS.], [#emph[approved\_by]], [Người duyệt hoàn tiền (có thể NULL nếu chưa duyệt). Khóa ngoại tham
    chiếu tới ADMINS.], [so\_tien\_hoan], [Số tiền được hoàn.], [trang\_thai], [Trạng thái (REQUESTED, APPROVED, REJECTED, COMPLETED).], [created\_at], [Ngày tạo.], [updated\_at], [Ngày cập nhật.]
  ),
  caption: [Mô Hình Mức Logic: REFUNDS],
)

==== REVIEWS (Đánh Giá)
<reviews-danh-gia>

- Lưu trữ đánh giá từ khách hàng sau khi hoàn tất đặt phòng.

REVIEWS(#underline[id], #emph[user\_id], #emph[phong\_id], #emph[datphong\_id], so\_sao, binh\_luan, ngay\_danh\_gia, trang\_thai, created\_at, updated\_at)

#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh đánh giá.], [#emph[user\_id]], [Người đánh giá, khóa ngoại tham chiếu tới USERS.], [#emph[datphong\_id]], [Khóa ngoại tham chiếu đơn đặt phòng, DATPHONG.], [#emph[phong\_id]], [Khóa ngoại tham chiếu phòng được đánh giá, PHONG.], [so\_sao], [Điểm đánh giá (1-5).], [trang\_thai], [Trạng thái kiểm duyệt (VISIBLE/HIDDEN).], [created\_at], [Ngày tạo.], [updated\_at], [Ngày cập nhật.]
  ),
  caption: [Mô Hình Mức Logic: REVIEWS],
)

==== ROLES (Vai Trò)
<roles-vai-tro>

Định nghĩa các nhóm quyền (Admin, Staff, Customer).

ROLES(#underline[id], code, name, description)

#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh vai trò.], [code], [Mã code vai trò (ADMIN, STAFF, USER).], [name], [Tên hiển thị.], [description], [Mô tả chi tiết vai trò.]
  ),
  caption: [Mô Hình Mức Logic: ROLES],
)

==== USERS (Người Dùng)
<users-nguoi-dung>

- Lưu trữ thông tin khách hàng/người dùng cuối.

USERS(#underline[id], email, phone, password\_hash, full\_name, status, created\_at, updated\_at)

#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh người dùng.], [email], [Địa chỉ email (dùng để đăng nhập).], [phone], [Số điện thoại liên lạc.], [password\_hash], [Mật khẩu đã mã hóa.], [full\_name], [Họ và tên.], [status], [Trạng thái (ACTIVE/INACTIVE).], [created\_at], [Ngày tạo.], [updated\_at], [Ngày cập nhật.]
  ),
  caption: [Mô Hình Mức Logic: USERS],
)

==== VOUCHERS (Mã Giảm Giá)
<vouchers-ma-giam-gia>

- Quản lý các chương trình khuyến mãi.

VOUCHERS(#underline[id], ma\_code, phan\_tram\_giam, ngay\_het\_han, so\_tien\_toi\_thieu, so\_lan\_toi\_da, so\_lan\_da\_dung, trang\_thai, created\_at, updated\_at)

#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh voucher.], [ma\_code], [Mã nhập khuyến mãi (ví dụ: SUMMER2024).], [phan\_tram\_giam], [Phần trăm giảm giá.], [ngay\_het\_han], [Ngày hết hạn.], [so\_tien\_toi\_thieu], [Số tiền tối thiểu để áp dụng voucher.], [so\_lan\_toi\_da], [Số lần sử dụng tối đa.], [so\_lan\_da\_dung], [Số lần đã sử dụng.], [trang\_thai], [Trạng thái (ACTIVE/INACTIVE).], [created\_at], [Ngày tạo.], [updated\_at], [Ngày cập nhật.]
  ),
  caption: [Mô Hình Mức Logic: VOUCHERS],
)

=== Nhóm Bảng Mối Liên Kết (Mối Quan Hệ n-n)
<nhom-bang-moi-lien-ket-moi-quan-he-n-n>

- Được hình thành từ việc tách các mối quan hệ nhiều-nhiều (Many-to-Many).

==== ADMIN\_ROLES
<admin-roles>

- Mối quan hệ giữa ADMINS và ROLES.
- Phân quyền Admin.

ADMIN\_ROLES(#underline[admin\_id], #underline[role\_id])

#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[#emph[admin\_id]]], [Mã định danh duy nhất của admin. Khóa ngoại tham chiếu ADMINS.], [#underline[#emph[role\_id]]], [Mã định danh duy nhất của role. Khóa ngoại tham chiếu ROLES.]
  ),
  caption: [Mô Hình Mức Logic: ADMINS_ROLES],
)

==== ROLE\_PERMISSIONS
<role-permissions>

- Giải quyết quan hệ N-N giữa ROLES và PERMISSIONS.
- Gán quyền cho Role.

ROLE\_PERMISSIONS(#underline[role\_id], #underline[permission\_id])

#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[#emph[role\_id]]], [Khóa ngoại tham chiếu ROLES.], [#underline[#emph[permission\_id]]], [Khóa ngoại tham chiếu PERMISSIONS.]
  ),
  caption: [Mô Hình Mức Logic: ROLES_PERMISSIONS],
)

==== CT\_DATPHONG
<ct-datphong>

- Giải quyết quan hệ N-N giữa DATPHONG và PHONG.
- Lưu trữ danh sách phòng trong một đơn đặt phòng.

CT\_DATPHONG(#underline[id], #emph[datphong\_id], #emph[phong\_id], don\_gia)

#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh dòng chi tiết (Surrogate Key).], [#emph[datphong\_id]], [Khóa ngoại tham chiếu DATPHONG.], [#emph[phong\_id]], [Khóa ngoại tham chiếu PHONG.], [don\_gia], [Giá phòng được chốt tại thời điểm đặt (Lưu lịch sử giá).]
  ),
  caption: [Mô Hình Mức Logic: CT_DATPHONG],
)

==== CT\_SUDUNG\_DV
<ct-sudung-dv>

- Giải quyết quan hệ N-N giữa DATPHONG và DICHVU.
- Lưu trữ các dịch vụ khách sử dụng trong đơn đặt hàng.

CT\_SUDUNG\_DV(#underline[id], #emph[datphong\_id], #emph[dichvu\_id], so\_luong, don\_gia, thoi\_diem\_su\_dung, ghi\_chu, created\_at)

#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh dòng chi tiết (Surrogate Key).], [#emph[datphong\_id]], [Khóa ngoại tham chiếu DATPHONG.], [#emph[dichvu\_id]], [Khóa ngoại tham chiếu DICHVU.], [so\_luong], [Số lượng dịch vụ sử dụng.], [don\_gia], [Đơn giá dịch vụ tại thời điểm sử dụng.], [thoi\_diem\_su\_dung], [Thời gian khách order dịch vụ.], [ghi\_chu], [Ghi chú về việc sử dụng dịch vụ.], [created\_at], [Ngày tạo.]
  ),
  caption: [Mô Hình Mức Logic: CT_SUDUNG_DV],
)

=== Tổng Hợp Danh Sách Bảng
<tong-hop-danh-sach-bang>

#figure(
  table(
    columns: (10%, 20%, 20%, 50%),
    align: (right, left, left, left),
    [#strong[STT]], [#strong[Tên Bảng]], [#strong[Loại]], [#strong[Mô Tả]], [1], [`ADMINS`], [Thực Thể], [Biểu diễn người quản trị.], [2], [`DATPHONG`], [Thực Thể], [Lưu trữ thông tin đơn đặt phòng.], [3], [`DICHVU`], [Thực Thể], [Danh mục các dịch vụ đi kèm.], [4], [`LOAIPHONG`], [Thực Thể], [Danh mục phân loại phòng.], [5], [`PAYMENTS`], [Thực Thể], [Lưu trữ lịch sử giao dịch thanh toán.], [6], [`PERMISSIONS`], [Thực Thể], [Danh sách các quyền hạn hệ thống.], [7], [`PHONG`], [Thực Thể], [Danh sách các phòng vật lý.], [8], [`REFUNDS`], [Thực Thể], [Lưu trữ yêu cầu và lịch sử hoàn tiền.], [9], [`REVIEWS`], [Thực Thể], [Lưu trữ đánh giá từ khách hàng.], [10], [`ROLES`], [Thực Thể], [Định nghĩa các vai trò trong hệ thống.], [11], [`USERS`], [Thực Thể], [Lưu trữ thông tin khách hàng.], [12], [`VOUCHERS`], [Thực Thể], [Quản lý các chương trình khuyến mãi.], [13], [`ADMIN_ROLES`], [Liên Kết], [Mối quan hệ giữa `ADMINS` và `ROLES`.], [14], [`ROLE_PERMISSIONS`], [Liên Kết], [Mối quan hệ giữa `ROLES` và `PERMISSIONS`.], [15], [`CT_DATPHONG`], [Liên Kết], [Chi tiết các phòng trong đơn đặt phòng.], [16], [`CT_SUDUNG_DV`], [Liên Kết], [Chi tiết các dịch vụ khách sử dụng.]
  ),
  caption: [Mô Hình Mức Logic: Danh Sách Bảng],
)
