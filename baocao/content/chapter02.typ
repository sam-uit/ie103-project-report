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
- Giá Cơ Bản ($> 0$)
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
  - Một admin có thể có tối thiểu #emph[1] và tối đa #emph[n] vai trò.
  - Một vai trò có thể gán tối thiểu #emph[0] và tối đa #emph[n] admin.
- LOAI PHONG - PHONG: #emph[\(1 - n)]
  - Một loại phòng có tối thiểu #emph[0] và tối đa #emph[n] phòng.
  - Một phòng thuộc và chỉ thuộc #emph[1] loại phòng.
- USERS - DATPHONG: #emph[\(1 - n)]
  - Một người dùng có tối thiểu #emph[0] và tối đa #emph[n] đơn đặt phòng.
  - Một đặt phòng có và chỉ thuộc về #emph[1] người dùng.
- DATPHONG - PHONG: #emph[\(n - n)]
  - Một đơn đặt phòng có tối thiểu #emph[1] và tối đa #emph[n] phòng.
  - Một phòng có tối thiểu #emph[0] và tối đa #emph[n] đơn đặt phòng.
- VOUCHERS - DATPHONG: #emph[\(1 - n)]
  - Một mã giảm giá có tối thiểu #emph[0], và tối đa #emph[n] đơn đặt phòng.
  - Một đơn đặt phòng có tối thiểu #emph[0], và tối đa #emph[1] mã giảm giá áp dụng.
- DATPHONG - REVIEWS: #emph[một - một]
  - Một đơn đặt phòng có tối thiểu #emph[0] và tối đa #emph[1] đánh giá.
  - Một đánh giá thuộc và chỉ thuộc #emph[1] đơn đặt phòng.
- USERS - REVIEWS: #emph[\(1 - n)]
  - Một user có tối thiểu #emph[0], và tối đa #emph[n] đánh giá.
  - Một đánh giá có tối thiểu #emph[1] tối đa #emph[1] user.
- USERS - PAYMENTS: #emph[\(1 - n)]
  - Một user có tối thiểu #emph[0], và tối đa #emph[n] thanh toán.
  - Một thanh toán có và chỉ có #emph[1] user
- USERS - REFUNDS: #emph[\(1 - n)]
  - Một user có tối thiểu #emph[0], và tối đa #emph[n] yêu cầu hoàn tiền.
  - Một yêu cầu hoàn tiền có và chỉ có 1 user.
- PAYMENTS - REFUNDS: #emph[\(1 - n)]
  - Một thanh toán có tối thiểu #emph[0] và tối đa #emph[n] hoàn tiền.
  - Một hoàn tiền được và chỉ được tạo từ #emph[1] thanh toán.
- DATPHONG - PAYMENTS: #emph[\(1 - n)]
  - Một đơn đặt phòng có tối thiểu #emph[0] và tối đa #emph[n] thanh toán.
  - Một thanh toán có và chỉ có #emph[1] đơn đặt phòng.
- ADMINS - REFUNDS: #emph[\(1 - n)]
  - Một admin có thể duyệt tối thiểu #emph[0] và tối đa #emph[n] lần hoàn tiền.
  - Một lần hoàn tiền chỉ được duyệt bởi #emph[1] một admin.
- DATPHONG - DICHVU: #emph[\(n - n)]
  - Một đơn đặt phòng có thể có tối thiểu #emph[0] và tối đa #emph[n] dịch vụ đi kèm.
  - Một dịch vụ đi kèm có thể được sử dụng tối thiểu #emph[0] và tối đa #emph[n] đơn đặt phòng.
- ROLES - PERMISSIONS: #emph[\(n - n)]
  - Một vai trò có tối thiểu #emph[0] và tối đa #emph[n] quyền hạn.
  - Một quyền hạn có tối thiểu #emph[0] và tối đa #emph[n] vai trò.

=== Mô Hình Thực Thể Quan Hệ (ERD) Hoàn Chỉnh
<mo-hinh-thuc-the-quan-he-erd-hoan-chinh>

Quy cách:

- Các quan hệ #emph[\(n - n)] được tô sáng màu cam, chuẩn bị cho bước thiết kế logic.
- Đơn giản hóa đồ họa bằng cách không biểu diễn các thuộc tính.
- Mô hình đầy đủ các thuộc tính được trình bày ở phần #emph[Phụ Lục B], mục #emph[Mô Hình Thực Thể Quan Hệ Đầy Đủ].

#figure(image("diagrams/ch02-concept-erd.svg"),
  caption: [
    Mô Hình Quan Niệm: Biểu Đồ ERD Hoàn Chỉnh
  ]
)

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
  caption: [
    Mô Hình Mức Logic: ADMINS
  ],
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
  caption: [
    Mô Hình Mức Logic: DATPHONG
  ],
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
  caption: [
    Mô Hình Mức Logic: DICHVU
  ],
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
  caption: [
    Mô Hình Mức Logic: LOAIPHONG
  ],
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
  caption: [
    Mô Hình Mức Logic: PAYMENTS
  ],
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
  caption: [
    Mô Hình Mức Logic: PERMISSIONS
  ],
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
  caption: [
    Mô Hình Mức Logic: PHONG
  ],
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
  caption: [
    Mô Hình Mức Logic: REFUNDS
  ],
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
  caption: [
    Mô Hình Mức Logic: REVIEWS
  ],
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
  caption: [
    Mô Hình Mức Logic: ROLES
  ],
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
  caption: [
    Mô Hình Mức Logic: USERS
  ],
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
  caption: [
    Mô Hình Mức Logic: VOUCHERS
  ],
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
  caption: [
    Mô Hình Mức Logic: ADMINS_ROLES
  ],
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
  caption: [
    Mô Hình Mức Logic: ROLES_PERMISSIONS
  ],
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
  caption: [
    Mô Hình Mức Logic: CT_DATPHONG
  ],
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
  caption: [
    Mô Hình Mức Logic: CT_SUDUNG_DV
  ],
)

=== Tổng Hợp Danh Sách Bảng
<tong-hop-danh-sach-bang>

#figure(
  table(
    columns: (30%, 15%, 55%),
    align: (left, left, left),
  [#strong[Tên Bảng]], [#strong[Loại]], [#strong[Mô Tả]], [ADMINS], [Thực Thể], [Biểu diễn người quản trị.], [DATPHONG], [Thực Thể], [Lưu trữ thông tin đơn đặt phòng.], [DICHVU], [Thực Thể], [Danh mục các dịch vụ đi kèm.], [LOAIPHONG], [Thực Thể], [Danh mục phân loại phòng.], [PAYMENTS], [Thực Thể], [Lưu trữ lịch sử giao dịch thanh toán.], [PERMISSIONS], [Thực Thể], [Danh sách các quyền hạn hệ thống.], [PHONG], [Thực Thể], [Danh sách các phòng vật lý.], [REFUNDS], [Thực Thể], [Lưu trữ yêu cầu và lịch sử hoàn tiền.], [REVIEWS], [Thực Thể], [Lưu trữ đánh giá từ khách hàng.], [ROLES], [Thực Thể], [Định nghĩa các vai trò trong hệ thống.], [USERS], [Thực Thể], [Lưu trữ thông tin khách hàng.], [VOUCHERS], [Thực Thể], [Quản lý các chương trình khuyến mãi.], [ADMIN\_ROLES], [Liên Kết], [Mối quan hệ giữa ADMINS và ROLES.], [ROLE\_PERMISSIONS], [Liên Kết], [Mối quan hệ giữa ROLES và PERMISSIONS.], [CT\_DATPHONG], [Liên Kết], [Chi tiết các phòng trong đơn đặt phòng.], [CT\_SUDUNG\_DV], [Liên Kết], [Chi tiết các dịch vụ khách sử dụng.]
  ),
  caption: [
    Mô Hình Mức Logic: Danh Sách Bảng
  ],
)

== Kết Luận Chương 2
<ket-luan-chuong-2>

Trong Chương 2, Nhóm 02 đã trình bày chi tiết các khía cạnh của việc phân tích và thiết kế cơ sở dữ liệu cho hệ thống quản lý khách sạn. Bắt đầu từ việc phân tích nghiệp vụ, xác định các chức năng chính và các đối tượng cần quản lý, chúng tôi đã xây dựng một mô hình dữ liệu logic hoàn chỉnh.

Mô hình này bao gồm 12 thực thể chính và các mối quan hệ giữa chúng, được biểu diễn qua sơ đồ ERD. Các thực thể này bao phủ toàn bộ hoạt động của khách sạn, từ quản lý phòng, khách hàng, đặt phòng, thanh toán cho đến các dịch vụ đi kèm.

Tiếp theo, Nhóm 02 đã chuyển đổi mô hình quan niệm sang mô hình mức logic, cụ thể là mô hình quan hệ. Trong phần này, nhóm đã định nghĩa chi tiết cấu trúc của từng bảng, bao gồm tên bảng, các thuộc tính, kiểu dữ liệu, khóa chính, khóa ngoại và các ràng buộc toàn vẹn. Việc sử dụng khóa ngoại giúp đảm bảo tính nhất quán và toàn vẹn dữ liệu trong toàn hệ thống.

Cuối cùng, nhóm đã tổng hợp danh sách tất cả các bảng trong cơ sở dữ liệu, giúp người đọc có cái nhìn tổng quan về cấu trúc của hệ thống. Các bảng này đã sẵn sàng để triển khai trên một hệ quản trị cơ sở dữ liệu cụ thể.

Qua chương này, Nhóm 02 đã hoàn thành việc phân tích và thiết kế cơ sở dữ liệu cho hệ thống quản lý khách sạn, tạo nền tảng vững chắc cho việc triển khai và phát triển hệ thống trong các chương tiếp theo.
