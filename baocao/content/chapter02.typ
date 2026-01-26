#import "../template/lib.typ": *

= Phân Tích Và Thiết Kế
<phan-tich-va-thiet-ke>


== Các Chức Năng Nghiệp Vụ
<cac-chuc-nang-nghiep-vu>


=== Bao Gồm
<bao-gom>

- Quản lý phòng và loại phòng (BMS).
- Quản lý khách hàng (BMS).
- Quản lý đặt phòng (BMS).
- Kiểm tra phòng trống (BMS & User Application).
- Đặt phòng và hủy đặt phòng (User Application).
- Thanh toán trực tuyến (mô phỏng).
- Hoàn tiền và hủy giao dịch theo chính sách.
- Quản lý và phân quyền người dùng (Admin / Staff / End User).
- Hiển thị trạng thái đặt phòng và thanh toán (User Application).
- Ứng dụng web hoặc mobile hoàn chỉnh phục vụ thao tác đặt phòng.
- #strong[Hệ thống khuyến mãi & mã giảm giá (Vouchers)].
- #strong[Quản lý dịch vụ đi kèm (Add-on Services)] như ăn sáng, giặt ủi, đưa đón sân bay.
- #strong[Hệ thống đánh giá & phản hồi (Reviews & Ratings)] sau khi hoàn tất thanh toán.

=== Không Bao Gồm
<khong-bao-gom>

- Tích hợp cổng thanh toán thực tế (VNPay, Stripe, PayPal).
- Hệ thống kế toán hoặc xuất hóa đơn điện tử.
- Tối ưu hiệu năng cho quy mô lớn (high traffic).
- Tích hợp bên thứ ba (OTA như Booking, Agoda).

== Quy Tắc Nghiệp Vụ & Xác Định Thực Thể
<quy-tac-nghiep-vu-xac-dinh-thuc-the>


=== Các Quy Tắc Nghiệp Vụ
<cac-quy-tac-nghiep-vu>

- Một phòng không được đặt trùng thời gian.
- Ngày trả phòng phải lớn hơn ngày nhận phòng.
- Giờ trả phòng trễ nhất là #strong[12:00 trưa] mỗi ngày.
- Giờ nhận phòng sớm nhất là #strong[14:00 (2 giờ chiều)] mỗi ngày.
- Một lần đặt phòng phải có ít nhất một phòng.
- Mỗi đặt phòng chỉ có tối đa một thanh toán.
- Số tiền thanh toán phải lớn hơn 0.
- Không được xóa đặt phòng nếu đã thanh toán.
- Có thể hoàn tiền nếu người dùng yêu cầu trước 24 tiếng (2 ngày) kể từ ngày nhận phòng.
- Chỉ có #strong[Admin] mới có quyền duyệt hoàn trả.
- #strong[Mỗi đặt phòng có thể áp dụng tối đa một mã giảm giá (voucher)].
- #strong[Mã giảm giá phải còn hạn sử dụng và chưa hết số lượng].
- #strong[Khách hàng có thể gọi dịch vụ đi kèm bất cứ lúc nào trong thời gian lưu trú].
- #strong[Chỉ những khách hàng đã thanh toán (PAID) và đã trả phòng mới được đánh giá].
- #strong[Mỗi đặt phòng chỉ được đánh giá một lần].
- #strong[Số sao đánh giá phải từ 1 đến 5].

=== Miêu Tả Các Nghiệp Vụ (User Stories)
<mieu-ta-cac-nghiep-vu-user-stories>

- US-01: Quản lý phòng
  - Là #strong[Admin], tôi muốn thêm, sửa, xóa phòng để cập nhật thông tin phòng.
- US-02: Quản lý khách hàng
  - Là #strong[Staff], tôi muốn lưu trữ thông tin khách hàng để theo dõi lịch sử đặt phòng.
- US-03: Đặt phòng (End User) / Khách hàng
  - Là #strong[End User], tôi muốn tìm kiếm phòng trống và đặt phòng theo thời gian mong muốn.
- US-04: Hủy đặt phòng (End User) / Khách hàng
  - Là #strong[End User], tôi muốn hủy đặt phòng trước thời điểm nhận phòng và biết liệu mình có được hoàn tiền hay không.
- US-05: Kiểm tra phòng trống
  - Là #strong[Staff] hoặc #strong[End User], tôi muốn xem danh sách phòng trống theo ngày check-in và check-out.
- US-06: Thanh toán
  - Là #strong[Staff], tôi muốn ghi nhận thanh toán và hoàn tiền cho một đặt phòng để theo dõi trạng thái thanh toán và doanh thu.
- US-07: Áp dụng mã giảm giá
  - Là #strong[End User], tôi muốn áp dụng mã giảm giá (voucher) khi đặt phòng để được giảm giá theo chương trình khuyến mãi.
- US-08: Sử dụng dịch vụ đi kèm
  - Là #strong[End User], tôi muốn đặt thêm các dịch vụ đi kèm (ăn sáng, giặt ủi, đưa đón sân bay) trong thời gian lưu trú để tiện lợi hơn.
- US-09: Đánh giá phòng
  - Là #strong[End User], tôi muốn đánh giá và để lại phản hồi về phòng sau khi hoàn tất thanh toán và trả phòng để chia sẻ trải nghiệm của mình.
- US-10: Xem đánh giá phòng
  - Là #strong[End User], tôi muốn xem điểm trung bình và các đánh giá của từng loại phòng để đưa ra quyết định đặt phòng phù hợp.

=== Danh Sách Các Thực Thể
<danh-sach-cac-thuc-the>

- #strong[Quản Lý/Quản Trị Viên]
  - Đại diện cho người dùng nội bộ của hệ thống (Admin / Staff).
  - Có quyền quản lý nghiệp vụ và dữ liệu hệ thống
- #strong[Người Dùng]
  - Đại diện cho một người dùng/khách hàng cuối của hệ thống quản lý đặt phòng.
  - Có thể thực hiện đặt phòng, hủy đặt phòng, thanh toán, đánh giá, và xem các thông tin của mình.
- #strong[Phòng]
  - Đại diện cho một phòng.
  - Có thể được đặt hoặc không.
- #strong[Loại Phòng]
  - Đại diện cho một loại phòng.
- #strong[Đặt Phòng]
  - Đại diện cho một giao dịch đặt phòng.
  - Có thể được hủy hoặc không.
- #strong[Dịch Vụ]
  - Đại diện cho một dịch vụ đi kèm.
- #strong[Thanh Toán]
  - Đại diện cho một giao dịch thanh toán.
- #strong[Hoàn Tiền]
  - Đại diện cho một giao dịch hoàn tiền.
- #strong[Vai Trò]
  - Đại diện cho một vai trò.
- #strong[Quyền Hạn]
  - Định nghĩa quyền thao tác cụ thể (CRUD phòng, duyệt hoàn tiền, xem báo cáo…).
- #strong[Đánh Giá]
  - Đại diện cho một đánh giá.
- #strong[Mã Giảm Giá]
  - Đại diện cho một mã giảm giá.
  - Có thể được áp dụng khi đặt phòng.

=== Quan Hệ Giữa Các Thực Thể
<quan-he-giua-cac-thuc-the>

Đây là quan hệ giữa các thực thể dưới góc độ và ngôn ngữ nghiệp vụ.

- #strong[Quản Trị Viên] được gán #strong[Vai Trò].
- #strong[Vai Trò] có các #strong[Quyền Hạn].
- #strong[Phòng] thuộc #strong[Loại Phòng].
- #strong[Người Dùng] thực hiện #strong[Đặt Phòng].
- #strong[Đặt Phòng] bao gồm #strong[Phòng].
- #strong[Đặt Phòng] được áp dụng #strong[Mã Giảm Giá].
- #strong[Đặt Phòng] được #strong[Thanh Toán].
- #strong[Đặt Phòng] được #strong[Đánh Giá].
- #strong[Người Dùng] viết #strong[Đánh Giá].
- #strong[Người Dùng] thực hiện #strong[Thanh Toán].
- #strong[Người Dùng] yêu cầu #strong[Hoàn Tiền].
- #strong[Thanh Toán] được #strong[Hoàn Tiền].
- #strong[Quản Trị Viên] duyệt #strong[Hoàn Tiền].
- #strong[Đặt Phòng] có kèm #strong[Dịch Vụ].

Tóm tắt các thực thể và mối quan hệ bằng mô hình trực quan:

#figure(image("diagrams/entity-relationship.svg"),
  caption: [
    Trực Quan Hóa các Thực Thể và Mối Quan Hệ
  ]
)

== Mô Hình Mức Quan Niệm
<mo-hinh-muc-quan-niem>

Các thực thể từ các yêu cầu nghiệp vụ được mô hình hóa.

=== Các Thực Thể và Thuộc Tính
<cac-thuc-the-va-thuoc-tinh>

- Trình bày các thực thể và thuộc tính tương ứng ở mức quan niệm phản ánh các thực thể từ mô hình nghiệp vụ.

==== ADMINS (Quản Lý/Quản Trị Viên)
<admins-quan-ly-quan-tri-vien>

- ID Admin (Thuộc tính định danh, duy nhất).
- Email
- Mật khẩu
- Tên Đầy Đủ
- Trạng Thái (Hoạt Động, Không Hoạt Động).

#figure(image("diagrams/ch02-concept-admins.svg"),
  caption: [
    Thực Thể và Thuộc Tính: ADMINS
  ]
)

==== DATPHONG (Đặt Phòng)
<datphong-dat-phong>

- ID Đặt Phòng (Thuộc tính định danh, duy nhất).
- Ngày Nhận Phòng
- Ngày Trả Phòng
- Trạng Thái (Đang Chờ, Đã Xác Nhận, Đã Hủy, Đã Hoàn Thành).

#figure(image("diagrams/ch02-concept-datphong.svg"),
  caption: [
    Thực Thể và Thuộc Tính: DATPHONG
  ]
)

==== DICHVU (Dịch Vụ)
<dichvu-dich-vu>

- ID Dịch Vụ (Thuộc tính định danh, duy nhất).
- Tên Dịch Vụ
- Đơn Giá
- Đơn Vị Tính (Mặc định 'Lần', có thể là 'Kg', 'Giờ', …)
- Trạng Thái (Hoạt Động, Không Hoạt Động).

#figure(image("diagrams/ch02-concept-dichvu.svg"),
  caption: [
    Thực Thể và Thuộc Tính: DICHVU
  ]
)

==== LOAIPHONG (Loại Phòng)
<loaiphong-loai-phong>

- ID Loại Phòng (Thuộc tính định danh, duy nhất).
- Tên Loại Phòng
- Giá Cơ Bản
- Mô Tả
- Sức Chứa (Mặc định là 2).

#figure(image("diagrams/ch02-concept-loaiphong.svg"),
  caption: [
    Thực Thể và Thuộc Tính: LOAIPHONG
  ]
)

==== PAYMENTS (Thanh Toán)
<payments-thanh-toan>

- ID Thanh Toán (Thuộc tính định danh, duy nhất).
- Số Tiền
- Phương Thức Thanh Toán (Tiền Mặt, Chuyển Khoản, Thẻ, Online)
- Trạng Thái (Đang Chờ, Thành Công, Gặp Lỗi, Đã Hủy, Đã Thanh Toán, Chưa Thanh Toán, Đã Hoàn Trả).

#figure(image("diagrams/ch02-concept-payments.svg"),
  caption: [
    Thực Thể và Thuộc Tính: PAYMENTS
  ]
)

==== PERMISSIONS (Quyền Hạn)
<permissions-quyen-han>

- ID Quyền Hạn (Thuộc tính định danh, duy nhất).
- Mã Quyền Hạn
- Miêu Tả

#figure(image("diagrams/ch02-concept-permissions.svg"),
  caption: [
    Thực Thể và Thuộc Tính: PERMISSIONS
  ]
)

==== PHONG (Phòng)
<phong-phong>

- ID Phòng (Thuộc tính định danh).
- Số Phòng (101, 102, …).
- Trạng Thái (Trống, Đang Ở, Bảo Trì, Đã Đặt).

#figure(image("diagrams/ch02-concept-phong.svg"),
  caption: [
    Thực Thể và Thuộc Tính: PHONG
  ]
)

==== REFUNDS (Hoàn Tiền)
<refunds-hoan-tien>

- ID Hoàn Tiền (Thuộc tính định danh, duy nhất).
- Số Tiền Hoàn
- Trạng Thái (Đã Yêu Cầu, Đã Duyệt, Từ Chối, Đã Hoàn Thành).
- Lý Do

#figure(image("diagrams/ch02-concept-refunds.svg"),
  caption: [
    Thực Thể và Thuộc Tính: REFUNDS
  ]
)

==== REVIEWS (Đánh Giá)
<reviews-danh-gia>

- ID Đánh Giá (Thuộc tính định danh, duy nhất).
- Số Sao (1, 2, 3, 4, 5)
- Bình Luận
- Ngày Đánh Giá
- Trạng Thái (Đang Chờ, Đã Duyệt, Từ Chối).

#figure(image("diagrams/ch02-concept-reviews.svg"),
  caption: [
    Thực Thể và Thuộc Tính: REVIEWS
  ]
)

==== ROLES (Vai Trò)
<roles-vai-tro>

- ID Role (Thuộc tính định danh, duy nhất).
- Mã Vai Trò
- Tên Vai Trò
- Miêu Tả

#figure(image("diagrams/ch02-concept-roles.svg"),
  caption: [
    Thực Thể và Thuộc Tính: ROLES
  ]
)

==== USERS (Người Dùng)
<users-nguoi-dung>

- ID Người Dùng (Thuộc tính định danh, duy nhất).
- Email
- Mật khẩu
- Số Điện Thoại
- Tên Đầy Đủ
- Trạng Thái (Hoạt Động, Không Hoạt Động).

#figure(image("diagrams/ch02-concept-users.svg"),
  caption: [
    Thực Thể và Thuộc Tính: USERS
  ]
)

==== VOUCHERS (Mã Giảm Giá)
<vouchers-ma-giam-gia>

- ID Voucher (Thuộc tính định danh, duy nhất).
- Mã Voucher
- Phần Trăm Giảm
- Ngày Hết Hạn
- Số Tiền Tối Thiểu
- Số Tiền Tối Đa
- Số Lần Đã Dùng
- Trạng Thái (Hoạt Động, Không Hoạt Động).

#figure(image("diagrams/ch02-concept-vouchers.svg"),
  caption: [
    Thực Thể và Thuộc Tính: VOUCHERS
  ]
)

=== Các Mối Quan Hệ
<cac-moi-quan-he>

- ADMINS - ROLES: #emph[\(n - n)]
  - Một admin có thể có nhiều vai trò.
  - Một vai trò có thể gán cho nhiều admin.
- PHONG - LOAIPHONG: #emph[\(1 - n)]
  - Một phòng thuộc về một loại phòng.
  - Một loại phòng có thể có nhiều phòng.
- USERS - DATPHONG: #emph[\(1 - n)]
  - Một người dùng có thể có nhiều đặt phòng.
  - Một đặt phòng được thực hiện bởi một người dùng.
- DATPHONG - PHONG: #emph[\(n - n)]
  - Một đặt phòng có thể có nhiều phòng.
  - Một phòng có thể được đặt trong nhiều đặt phòng.
- DATPHONG - VOUCHERS: #emph[\(1 - n)]
  - Một đặt phòng có thể có một mã giảm giá.
  - Một mã giảm giá có thể được áp dụng cho nhiều đặt phòng.
- DATPHONG - REVIEWS: #emph[một - một]
  - Một lần đặt phòng có thể có một đánh giá.
  - Một đánh giá chỉ thuộc về một lần đặt phòng.
- USERS - REVIEWS: #emph[\(1 - n)]
  - Một người dùng có thể có nhiều đánh giá.
  - Một đánh giá chỉ thuộc về một người dùng.
- USERS - PAYMENTS: #emph[\(1 - n)]
  - Một người dùng có thể thực hiện nhiều thanh toán.
  - Một thanh toán chỉ được thực hiện bởi một người dùng.
- USERS - REFUNDS: #emph[\(1 - n)]
  - Một người dùng có thể yêu cầu nhiều lần hoàn tiền.
  - Một lần hoàn tiền chỉ được yêu cầu bởi một người dùng.
- PAYMENTS - REFUNDS: #emph[\(1 - n)]
  - Một lần thanh toán có thể có nhiều lần hoàn tiền.
  - Một lần hoàn tiền chỉ thuộc về một lần thanh toán.
- PAYMENTS - DATPHONG: #emph[\(1 - n)]
  - Một lần thanh toán thuộc về một lần đặt phòng.
  - Một lần đặt phòng có thể có nhiều lần thanh toán.
- ADMINS - REFUNDS: #emph[\(1 - n)]
  - Một admin có thể duyệt nhiều lần hoàn tiền.
  - Một lần hoàn tiền chỉ được duyệt bởi một admin.
- DATPHONG - DICHVU: #emph[\(n - n)]
  - Một lần đặt phòng có thể có nhiều dịch vụ đi kèm.
  - Một dịch vụ đi kèm có thể được áp dụng cho nhiều lần đặt phòng.
- ROLES - PERMISSIONS: #emph[\(n - n)]
  - Một vai trò có thể có nhiều quyền hạn.
  - Một quyền hạn có thể thuộc về nhiều vai trò.

== Mô Hình Mức Logic
<mo-hinh-muc-logic>

Quy tắc trình bày:

- Khóa chính: #underline[gạch chân] (ví dụ: #underline[id])
- Khóa ngoại: #emph[in nghiêng] (ví dụ: #emph[loai\_phong\_id])

==== ADMINS (Quản Lý/Quản Trị Viên)
<admins-quan-ly-quan-tri-vien>

ADMINS(#underline[id], username, password, full\_name, email, phone, address, created\_at, updated\_at)

- `id`: Mã định danh duy nhất của admin.
- `username`: Tên đăng nhập của admin.
- `password`: Mật khẩu của admin.
- `full_name`: Họ tên đầy đủ của admin.
- `email`: Email của admin.
- `phone`: Số điện thoại của admin.
- `address`: Địa chỉ của admin.
- `created_at`: Thời gian tạo của admin.
- `updated_at`: Thời gian cập nhật của admin.

==== DATPHONG (Đặt Phòng)
<datphong-dat-phong>


==== DICHVU (Dịch Vụ)
<dichvu-dich-vu>


==== LOAIPHONG (Loại Phòng)
<loaiphong-loai-phong>


==== PAYMENTS (Thanh Toán)
<payments-thanh-toan>


==== PERMISSIONS (Quyền Hạn)
<permissions-quyen-han>


==== PHONG (Phòng)
<phong-phong>

PHONG(#underline[id], so\_phong, #emph[loai\_phong\_id], trang\_thai)

==== REFUNDS (Hoàn Tiền)
<refunds-hoan-tien>


==== REVIEWS (Đánh Giá)
<reviews-danh-gia>


==== ROLES (Vai Trò)
<roles-vai-tro>


==== USERS (Người Dùng)
<users-nguoi-dung>


==== VOUCHERS (Mã Giảm Giá)
<vouchers-ma-giam-gia>


=== Nhóm Bảng Mối Quan Hệ
<nhom-bang-moi-quan-he>


==== `ADMIN_ROLES`:
<admin-roles>

Mối quan hệ giữa ADMINS và ROLES

`ADMIN_ROLES`\(#underline[admin\_id], #underline[role\_id])

- `admin_id`: Mã định danh duy nhất của admin.

- `role_id`: Mã định danh duy nhất của role.

- ROLE\_PERMISSIONS

- CT\_DATPHONG

- CT\_SUDUNG\_DV

=== Tổng Hợp
<tong-hop>

#figure(
  table(
    columns: (10%, 30%, 15%, 45%),
    align: (right, left, left, left),
    [#strong("STT")], [#strong("Tên Thực Thể")], [#strong("Loại")], [#strong("Mô tả")],
    [1], [`ADMIN_ROLES`], [Quan hệ], [Quan hệ giữa admin và role],
    [2], [`ADMINS`], [Thực thể], [Admin và staff],
    [3], [`CT_DATPHONG`], [Thực thể], [Chi tiết đặt phòng],
    [4], [`CT_SUDUNG_DV`], [Thực thể], [Chi tiết sử dụng dịch vụ],
    [5], [`DATPHONG`], [Thực thể], [Đặt phòng],
    [6], [`DICHVU`], [Thực thể], [Dịch vụ đi kèm],
    [7], [`LOAIPHONG`], [Thực thể], [Loại phòng],
    [8], [`PAYMENTS`], [Thực thể], [Thanh toán],
    [9], [`PERMISSIONS`], [Quan hệ], [Quan hệ giữa permission và role],
    [10], [`PHONG`], [Thực thể], [Phòng],
    [11], [`REFUNDS`], [Thực thể], [Hoàn tiền],
    [12], [`REVIEWS`], [Thực thể], [Đánh giá & phản hồi],
    [13], [`ROLE_PERMISSIONS`], [Quan hệ], [Quan hệ giữa role và permission],
    [14], [`ROLES`], [Thực thể], [Role],
    [15], [`USERS`], [Thực thể], [End User],
    [16], [`VOUCHERS`], [Thực thể], [Mã giảm giá],
  ),
  caption: [
    Các Bảng Trong Cơ Sở Dữ Liệu
  ],
)

== Thiết Kế Cơ Sở Dữ Liệu
<thiet-ke-co-so-du-lieu>


=== Vật Lý
<vat-ly>
