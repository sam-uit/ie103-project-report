#import "../template/lib.typ": *

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
