# Phân Tích Và Thiết Kế

## Các Chức Năng Nghiệp Vụ

### Bao Gồm

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
- **Hệ thống khuyến mãi & mã giảm giá (Vouchers)**.
- **Quản lý dịch vụ đi kèm (Add-on Services)** như ăn sáng, giặt ủi, đưa đón sân bay.
- **Hệ thống đánh giá & phản hồi (Reviews & Ratings)** sau khi hoàn tất thanh toán.

### Không Bao Gồm

- Tích hợp cổng thanh toán thực tế (VNPay, Stripe, PayPal).
- Hệ thống kế toán hoặc xuất hóa đơn điện tử.
- Tối ưu hiệu năng cho quy mô lớn (high traffic).
- Tích hợp bên thứ ba (OTA như Booking, Agoda).

## Quy Tắc Nghiệp Vụ & Xác Định Thực Thể

### Các Quy Tắc Nghiệp Vụ

- Một phòng không được đặt trùng thời gian.
- Ngày trả phòng phải lớn hơn ngày nhận phòng.
- Giờ trả phòng trễ nhất là **12:00 trưa** mỗi ngày.
- Giờ nhận phòng sớm nhất là **14:00 (2 giờ chiều)** mỗi ngày.
- Một lần đặt phòng phải có ít nhất một phòng.
- Mỗi đặt phòng chỉ có tối đa một thanh toán.
- Số tiền thanh toán phải lớn hơn 0.
- Không được xóa đặt phòng nếu đã thanh toán.
- Có thể hoàn tiền nếu người dùng yêu cầu trước 24 tiếng (2 ngày) kể từ ngày nhận phòng.
- Chỉ có **Admin** mới có quyền duyệt hoàn trả.
- **Mỗi đặt phòng có thể áp dụng tối đa một mã giảm giá (voucher)**.
- **Mã giảm giá phải còn hạn sử dụng và chưa hết số lượng**.
- **Khách hàng có thể gọi dịch vụ đi kèm bất cứ lúc nào trong thời gian lưu trú**.
- **Chỉ những khách hàng đã thanh toán (PAID) và đã trả phòng mới được đánh giá**.
- **Mỗi đặt phòng chỉ được đánh giá một lần**.
- **Số sao đánh giá phải từ 1 đến 5**.

### Miêu Tả Các Nghiệp Vụ (User Stories)

- US-01: Quản lý phòng
    - Là **Admin**, tôi muốn thêm, sửa, xóa phòng để cập nhật thông tin phòng.
- US-02: Quản lý khách hàng
    - Là **Staff**, tôi muốn lưu trữ thông tin khách hàng để theo dõi lịch sử đặt phòng.
- US-03: Đặt phòng (End User) / Khách hàng
    - Là **End User**, tôi muốn tìm kiếm phòng trống và đặt phòng theo thời gian mong muốn.
- US-04: Hủy đặt phòng (End User) / Khách hàng
    - Là **End User**, tôi muốn hủy đặt phòng trước thời điểm nhận phòng và biết liệu mình có được hoàn tiền hay không.
- US-05: Kiểm tra phòng trống
    - Là **Staff** hoặc **End User**, tôi muốn xem danh sách phòng trống theo ngày check-in và check-out.
- US-06: Thanh toán
    - Là **Staff**, tôi muốn ghi nhận thanh toán và hoàn tiền cho một đặt phòng để theo dõi trạng thái thanh toán và doanh thu.
- US-07: Áp dụng mã giảm giá
    - Là **End User**, tôi muốn áp dụng mã giảm giá (voucher) khi đặt phòng để được giảm giá theo chương trình khuyến mãi.
- US-08: Sử dụng dịch vụ đi kèm
    - Là **End User**, tôi muốn đặt thêm các dịch vụ đi kèm (ăn sáng, giặt ủi, đưa đón sân bay) trong thời gian lưu trú để tiện lợi hơn.
- US-09: Đánh giá phòng
    - Là **End User**, tôi muốn đánh giá và để lại phản hồi về phòng sau khi hoàn tất thanh toán và trả phòng để chia sẻ trải nghiệm của mình.
- US-10: Xem đánh giá phòng
    - Là **End User**, tôi muốn xem điểm trung bình và các đánh giá của từng loại phòng để đưa ra quyết định đặt phòng phù hợp.

### Danh Sách Các Thực Thể

- **Quản Lý/Quản Trị Viên**
    - Đại diện cho người dùng nội bộ của hệ thống (Admin / Staff).
    - Có quyền quản lý nghiệp vụ và dữ liệu hệ thống
- **Người Dùng**
    - Đại diện cho một người dùng/khách hàng cuối của hệ thống quản lý đặt phòng.
    - Có thể thực hiện đặt phòng, hủy đặt phòng, thanh toán, đánh giá, và xem các thông tin của mình.
- **Phòng**
    - Đại diện cho một phòng.
    - Có thể được đặt hoặc không.
- **Loại Phòng**
    - Đại diện cho một loại phòng.
- **Đặt Phòng**
    - Đại diện cho một giao dịch đặt phòng.
    - Có thể được hủy hoặc không.
- **Dịch Vụ**
    - Đại diện cho một dịch vụ đi kèm.
- **Thanh Toán**
    - Đại diện cho một giao dịch thanh toán.
- **Hoàn Tiền**
    - Đại diện cho một giao dịch hoàn tiền.
- **Vai Trò**
    - Đại diện cho một vai trò.
- **Quyền Hạn**
    - Định nghĩa quyền thao tác cụ thể (CRUD phòng, duyệt hoàn tiền, xem báo cáo...).
- **Đánh Giá**
    - Đại diện cho một đánh giá.
- **Mã Giảm Giá**
    - Đại diện cho một mã giảm giá.
    - Có thể được áp dụng khi đặt phòng.

### Quan Hệ Giữa Các Thực Thể

<!-- TODO: Mô tả bằng ngôn ngữ "business" thay vì kỹ thuật -->

Đây là quan hệ giữa các thực thể dưới góc độ và ngôn ngữ nghiệp vụ.

- **Quản Trị Viên** được gán **Vai Trò**.
- **Vai Trò** có các **Quyền Hạn**.
- **Phòng** thuộc **Loại Phòng**.
- **Người Dùng** thực hiện **Đặt Phòng**.
- **Đặt Phòng** bao gồm **Phòng**.
- **Đặt Phòng** được áp dụng **Mã Giảm Giá**.
- **Đặt Phòng** được **Thanh Toán**.
- **Đặt Phòng** được **Đánh Giá**.
- **Người Dùng** viết **Đánh Giá**.
- **Người Dùng** thực hiện **Thanh Toán**.
- **Người Dùng** yêu cầu **Hoàn Tiền**.
- **Thanh Toán** được **Hoàn Tiền**.
- **Quản Trị Viên** duyệt **Hoàn Tiền**.
- **Đặt Phòng** có kèm **Dịch Vụ**.

Tóm tắt các thực thể và mối quan hệ bằng mô hình trực quan:

<!-- Sử dụng layout elk cho riêng diagram này. -->

![Trực Quan Hóa các Thực Thể và Mối Quan Hệ](diagrams/entity-relationship.svg)

## Mô Hình Mức Quan Niệm

<!-- - Thực thể và các thuộc tính. -->
<!-- - Mô hình ER dạng Chen. -->
<!-- Chưa có khái niệm bảng ở đây -->

<!-- ![Mô Hình Thực Thể Quan Hệ](diagrams/ER.svg) -->

Các thực thể từ các yêu cầu nghiệp vụ được mô hình hóa.

### Các Thực Thể và Thuộc Tính

- Trình bày các thực thể và thuộc tính tương ứng ở mức quan niệm phản ánh các thực thể từ mô hình nghiệp vụ.

#### ADMINS (Quản Lý/Quản Trị Viên)

- ID Admin (Thuộc tính định danh, duy nhất).
- Email
- Mật khẩu
- Tên Đầy Đủ
- Trạng Thái (Hoạt Động, Không Hoạt Động).

![Thực Thể và Thuộc Tính: ADMINS](diagrams/ch02-concept-admins.svg)

#### DATPHONG (Đặt Phòng)

- ID Đặt Phòng (Thuộc tính định danh, duy nhất).
- Ngày Nhận Phòng
- Ngày Trả Phòng
- Trạng Thái (Đang Chờ, Đã Xác Nhận, Đã Hủy, Đã Hoàn Thành).

![Thực Thể và Thuộc Tính: DATPHONG](diagrams/ch02-concept-datphong.svg)

#### DICHVU (Dịch Vụ)

- ID Dịch Vụ (Thuộc tính định danh, duy nhất).
- Tên Dịch Vụ
- Đơn Giá
- Đơn Vị Tính (Mặc định 'Lần', có thể là 'Kg', 'Giờ', ...)
- Trạng Thái (Hoạt Động, Không Hoạt Động).

![Thực Thể và Thuộc Tính: DICHVU](diagrams/ch02-concept-dichvu.svg)

#### LOAIPHONG (Loại Phòng)

- ID Loại Phòng (Thuộc tính định danh, duy nhất).
- Tên Loại Phòng
- Giá Cơ Bản ($\gt 0$)
- Mô Tả
- Sức Chứa (Mặc định là 2).

![Thực Thể và Thuộc Tính: LOAIPHONG](diagrams/ch02-concept-loaiphong.svg)

#### PAYMENTS (Thanh Toán)

- ID Thanh Toán (Thuộc tính định danh, duy nhất).
- Số Tiền
- Phương Thức Thanh Toán (Tiền Mặt, Chuyển Khoản, Thẻ, Online)
- Trạng Thái (Đang Chờ, Thành Công, Gặp Lỗi, Đã Hủy, Đã Thanh Toán, Chưa Thanh Toán, Đã Hoàn Trả).

![Thực Thể và Thuộc Tính: PAYMENTS](diagrams/ch02-concept-payments.svg)

#### PERMISSIONS (Quyền Hạn)

- ID Quyền Hạn (Thuộc tính định danh, duy nhất).
- Mã Quyền Hạn
- Miêu Tả

![Thực Thể và Thuộc Tính: PERMISSIONS](diagrams/ch02-concept-permissions.svg)

#### PHONG (Phòng)

- ID Phòng (Thuộc tính định danh).
- Số Phòng (101, 102, ...).
- Trạng Thái (Trống, Đang Ở, Bảo Trì, Đã Đặt).

![Thực Thể và Thuộc Tính: PHONG](diagrams/ch02-concept-phong.svg)

#### REFUNDS (Hoàn Tiền)

- ID Hoàn Tiền (Thuộc tính định danh, duy nhất).
- Số Tiền Hoàn
- Trạng Thái (Đã Yêu Cầu, Đã Duyệt, Từ Chối, Đã Hoàn Thành).
- Lý Do

![Thực Thể và Thuộc Tính: REFUNDS](diagrams/ch02-concept-refunds.svg)

#### REVIEWS (Đánh Giá)

- ID Đánh Giá (Thuộc tính định danh, duy nhất).
- Số Sao (1, 2, 3, 4, 5)
- Bình Luận
- Ngày Đánh Giá
- Trạng Thái (Đang Chờ, Đã Duyệt, Từ Chối).

![Thực Thể và Thuộc Tính: REVIEWS](diagrams/ch02-concept-reviews.svg)

#### ROLES (Vai Trò)

- ID Role (Thuộc tính định danh, duy nhất).
- Mã Vai Trò
- Tên Vai Trò
- Miêu Tả

![Thực Thể và Thuộc Tính: ROLES](diagrams/ch02-concept-roles.svg)

#### USERS (Người Dùng)

- ID Người Dùng (Thuộc tính định danh, duy nhất).
- Email
- Mật khẩu
- Số Điện Thoại
- Tên Đầy Đủ
- Trạng Thái (Hoạt Động, Không Hoạt Động).

![Thực Thể và Thuộc Tính: USERS](diagrams/ch02-concept-users.svg)

#### VOUCHERS (Mã Giảm Giá)

- ID Voucher (Thuộc tính định danh, duy nhất).
- Mã Voucher
- Phần Trăm Giảm
- Ngày Hết Hạn
- Số Tiền Tối Thiểu
- Số Tiền Tối Đa
- Số Lần Đã Dùng
- Trạng Thái (Hoạt Động, Không Hoạt Động).

![Thực Thể và Thuộc Tính: VOUCHERS](diagrams/ch02-concept-vouchers.svg)

### Các Mối Quan Hệ

- ADMINS - ROLES: *(n - n)*
    - Một admin có thể có tối thiểu *1* và tối đa *n* vai trò.
    - Một vai trò có thể gán tối thiểu *0* và tối đa *n* admin.
- LOAI PHONG - PHONG: *(1 - n)*
    - Một loại phòng có tối thiểu *0* và tối đa *n* phòng.
    - Một phòng thuộc và chỉ thuộc *1* loại phòng.
- USERS - DATPHONG: *(1 - n)*
    - Một người dùng có tối thiểu *0* và tối đa *n* đơn đặt phòng.
    - Một đặt phòng có và chỉ thuộc về *1* người dùng.
- DATPHONG - PHONG: *(n - n)*
    - Một đơn đặt phòng có tối thiểu *1* và tối đa *n* phòng.
    - Một phòng có tối thiểu *0* và tối đa *n* đơn đặt phòng.
- VOUCHERS - DATPHONG: *(1 - n)*
    - Một mã giảm giá có tối thiểu *0*, và tối đa *n* đơn đặt phòng.
    - Một đơn đặt phòng có tối thiểu *0*, và tối đa *1* mã giảm giá áp dụng.
- DATPHONG - REVIEWS: *một - một*
    - Một đơn đặt phòng có tối thiểu *0* và tối đa *1* đánh giá.
    - Một đánh giá thuộc và chỉ thuộc *1* đơn đặt phòng.
- USERS - REVIEWS: *(1 - n)*
    - Một user có tối thiểu *0*, và tối đa *n* đánh giá.
    - Một đánh giá có tối thiểu *1* tối đa *1* user.
- USERS - PAYMENTS: *(1 - n)*
    - Một user có tối thiểu *0*, và tối đa *n* thanh toán.
    - Một thanh toán có và chỉ có *1* user
- USERS - REFUNDS: *(1 - n)*
    - Một user có tối thiểu *0*, và tối đa *n* yêu cầu hoàn tiền.
    - Một yêu cầu hoàn tiền có và chỉ có 1 user.
- PAYMENTS - REFUNDS: *(1 - n)*
    - Một thanh toán có tối thiểu *0* và tối đa *n* hoàn tiền.
    - Một hoàn tiền được và chỉ được tạo từ *1* thanh toán.
- DATPHONG - PAYMENTS: *(1 - n)*
    - Một đơn đặt phòng có tối thiểu *0* và tối đa *n* thanh toán.
    - Một thanh toán có và chỉ có *1* đơn đặt phòng.
- ADMINS - REFUNDS: *(1 - n)*
    - Một admin có thể duyệt tối thiểu *0* và tối đa *n* lần hoàn tiền.
    - Một lần hoàn tiền chỉ được duyệt bởi *1* một admin.
- DATPHONG - DICHVU: *(n - n)*
    - Một đơn đặt phòng có thể có tối thiểu *0* và tối đa *n* dịch vụ đi kèm.
    - Một dịch vụ đi kèm có thể được sử dụng tối thiểu *0* và tối đa *n* đơn đặt phòng.
- ROLES - PERMISSIONS: *(n - n)*
    - Một vai trò có tối thiểu *0* và tối đa *n* quyền hạn.
    - Một quyền hạn có tối thiểu *0* và tối đa *n* vai trò.

### Mô Hình Thực Thể Quan Hệ (ERD) Hoàn Chỉnh

Quy cách:

- Các quan hệ *(n - n)* được tô sáng màu cam, chuẩn bị cho bước thiết kế logic.
- Đơn giản hóa đồ họa bằng cách không biểu diễn các thuộc tính.
- Mô hình đầy đủ các thuộc tính được trình bày ở phần *Phụ Lục B*, mục *Mô Hình Thực Thể Quan Hệ Đầy Đủ*.

<!-- TODO: Cân nhắc sử dụng direction TD -->

![Mô Hình Quan Niệm: Biểu Đồ ERD Hoàn Chỉnh](diagrams/ch02-concept-erd.svg)

## Mô Hình Mức Logic

Quy cách trình bày:

- Khóa chính: <u>gạch chân</u> (ví dụ: <u>id</u>)
- Khóa ngoại: *in nghiêng* (ví dụ: *loai_phong_id*)

### Nhóm Bảng Thực Thể

#### ADMINS (Quản Lý/Quản Trị Viên)

ADMINS(<u>id</u>, email, password_hash, full_name, status, created_at, updated_at)

<!-- TODO: định dạng khóa chính, khóa ngoại trong bảng -->

<!-- | Khóa | Mô tả |
| --- | --- |
| <u>id</u> | Mã định danh duy nhất của admin. |
| email | Tên đăng nhập của admin. |
| password_hash | Mật khẩu của admin. |
| full_name | Họ tên đầy đủ của admin. |
| status | Trạng thái của admin. |
| created_at | Thời gian tạo của admin. |
| updated_at | Thời gian cập nhật của admin. | -->

<!-- Sử dụng bảng của Typst -->

```{=typst}
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
```

#### DATPHONG (Đặt Phòng)

- Lưu trữ thông tin header của đơn đặt phòng.

DATPHONG(<u>id</u>, *user_id*, *voucher_id*, check_in, check_out, trang_thai, created_at)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh đơn đặt phòng.
| *user_id* | Khóa ngoại tham chiếu tới bảng USERS (Người đặt).
| *voucher_id* | Khóa ngoại tham chiếu tới bảng VOUCHERS (Mã giảm giá áp dụng, có thể NULL).
| check_in | Ngày nhận phòng dự kiến.
| check_out | Ngày trả phòng dự kiến.
| trang_thai | Trạng thái đơn (PENDING, CONFIRMED, CANCELLED, COMPLETED).
| created_at | Thời gian tạo đơn. -->

<!-- Sử dụng bảng của Typst -->

```{=typst}
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
```

#### DICHVU (Dịch Vụ)

- Danh mục các dịch vụ đi kèm (Ăn uống, Spa, Đưa đón...).

DICHVU(<u>id</u>, ten_dich_vu, don_gia, don_vi_tinh, trang_thai, created_at, updated_at)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh dịch vụ. |
| ten_dich_vu | Tên dịch vụ. |
| don_gia | Đơn giá niêm yết. |
| don_vi_tinh | Đơn vị tính. |
| trang_thai | Trạng thái khả dụng (ACTIVE/INACTIVE). |
| created_at | Ngày tạo. |
| updated_at | Ngày cập nhật. | -->

```{=typst}
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
```

#### LOAIPHONG (Loại Phòng)

- Danh mục phân loại phòng (Deluxe, Standard, Suite...).

LOAIPHONG(<u>id</u>, ten_loai, gia_co_ban, mo_ta, suc_chua)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh loại phòng. |
| ten_loai | Tên hiển thị của loại phòng. |
| gia_co_ban | Giá gốc theo đêm. |
| mo_ta | Mô tả chi tiết loại phòng. |
| suc_chua | Số người tối đa cho phép. | -->

```{=typst}
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
```

#### PAYMENTS (Thanh Toán)

- Lưu trữ lịch sử giao dịch thanh toán.

PAYMENTS(<u>id</u>, *booking_id*, *user_id*, so_tien, phuong_thuc, trang_thai, created_at)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh giao dịch. |
| *booking_id* | Khóa ngoại tham chiếu đơn đặt phòng được thanh toán. |
| *user_id* | Khóa ngoại tham chiếu người thực hiện thanh toán. |
| so_tien | Số tiền thanh toán. |
| phuong_thuc | Phương thức (TIEN_MAT, CHUYEN_KHOAN, THE, ONLINE). |
| trang_thai | Trạng thái giao dịch (PENDING, SUCCESS, FAILED, CANCELLED, PAID, UNPAID, REFUNDED). |
| created_at | Ngày tạo. | -->

```{=typst}
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
```

#### PERMISSIONS (Quyền Hạn)

- Danh sách các quyền hạn cụ thể trong hệ thống.

PERMISSIONS(<u>id</u>, code, description)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh quyền hạn. |
| code | Mã code hệ thống (ví dụ: `VIEW_DASHBOARD`, `EDIT_ROOM`). |
| description | Mô tả chi tiết quyền hạn. | -->

```{=typst}
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
```

#### PHONG (Phòng)

- Danh sách các phòng vật lý.

PHONG(<u>id</u>, so_phong, *loai_phong_id*, trang_thai)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh phòng. |
| so_phong | Số hiệu phòng (ví dụ: 101, 202). |
| *loai_phong_id* | Khóa ngoại tham chiếu tới bảng LOAIPHONG. |
| trang_thai | Trạng thái hiện tại (AVAILABLE, OCCUPIED, MAINTENANCE, RESERVED). | -->

```{=typst}
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
```

#### REFUNDS (Hoàn Tiền)

- Lưu trữ yêu cầu và lịch sử hoàn tiền.

REFUNDS(<u>id</u>, *payment_id*, *requested_by*, *approved_by*, so_tien_hoan, ly_do, trang_thai, created_at, updated_at)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh yêu cầu hoàn tiền. |
| *payment_id* | Khóa ngoại tham chiếu giao dịch gốc cần hoàn tại PAYMENTS. |
| *requested_by* | Người yêu cầu hoàn tiền, khóa ngoại tham chiếu tới USERS. |
| *approved_by* | Người duyệt hoàn tiền (có thể NULL nếu chưa duyệt). Khóa ngoại tham chiếu tới ADMINS. |
| so_tien_hoan | Số tiền được hoàn. |
| trang_thai | Trạng thái (REQUESTED, APPROVED, REJECTED, COMPLETED). |
| created_at | Ngày tạo. |
| updated_at | Ngày cập nhật. | -->

```{=typst}
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
```

#### REVIEWS (Đánh Giá)

- Lưu trữ đánh giá từ khách hàng sau khi hoàn tất đặt phòng.

REVIEWS(<u>id</u>, *user_id*, *phong_id*, *datphong_id*, so_sao, binh_luan, ngay_danh_gia, trang_thai, created_at, updated_at)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh đánh giá. |
| *user_id* | Người đánh giá, khóa ngoại tham chiếu tới USERS. |
| *datphong_id* | Khóa ngoại tham chiếu đơn đặt phòng, DATPHONG. |
| *phong_id* | Khóa ngoại tham chiếu phòng được đánh giá, PHONG. |
| so_sao | Điểm đánh giá (1-5). |
| trang_thai | Trạng thái kiểm duyệt (VISIBLE/HIDDEN). |
| created_at | Ngày tạo. |
| updated_at | Ngày cập nhật. | -->

```{=typst}
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
```

#### ROLES (Vai Trò)

Định nghĩa các nhóm quyền (Admin, Staff, Customer).

ROLES(<u>id</u>, code, name, description)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh vai trò. |
| code | Mã code vai trò (ADMIN, STAFF, USER). |
| name | Tên hiển thị. |
| description | Mô tả chi tiết vai trò. | -->

```{=typst}
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
```

#### USERS (Người Dùng)

- Lưu trữ thông tin khách hàng/người dùng cuối.

USERS(<u>id</u>, email, phone, password_hash, full_name, status, created_at, updated_at)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh người dùng. |
| email | Địa chỉ email (dùng để đăng nhập). |
| phone | Số điện thoại liên lạc. |
| password_hash | Mật khẩu đã mã hóa. |
| full_name | Họ và tên. |
| status | Trạng thái (ACTIVE/INACTIVE). |
| created_at | Ngày tạo. |
| updated_at | Ngày cập nhật. | -->

```{=typst}
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
```

#### VOUCHERS (Mã Giảm Giá)

- Quản lý các chương trình khuyến mãi.

VOUCHERS(<u>id</u>, ma_code, phan_tram_giam, ngay_het_han, so_tien_toi_thieu, so_lan_toi_da, so_lan_da_dung, trang_thai, created_at, updated_at)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh voucher. |
| ma_code | Mã nhập khuyến mãi (ví dụ: SUMMER2024). |
| phan_tram_giam | Phần trăm giảm giá. |
| ngay_het_han | Ngày hết hạn. |
| so_tien_toi_thieu | Số tiền tối thiểu để áp dụng voucher. |
| so_lan_toi_da | Số lần sử dụng tối đa. |
| so_lan_da_dung | Số lần đã sử dụng. |
| trang_thai | Trạng thái (ACTIVE/INACTIVE). |
| created_at | Ngày tạo. |
| updated_at | Ngày cập nhật. | -->

```{=typst}
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
```

### Nhóm Bảng Mối Liên Kết (Mối Quan Hệ n-n)

- Được hình thành từ việc tách các mối quan hệ nhiều-nhiều (Many-to-Many).

#### ADMIN_ROLES

- Mối quan hệ giữa ADMINS và ROLES.
- Phân quyền Admin.

ADMIN_ROLES(<u>admin_id</u>, <u>role_id</u>)

<!-- Nếu khóa vừa là khóa chính, vừa là khóa ngoại: đậm-nghiêng -->

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>*admin_id*</u> | Mã định danh duy nhất của admin. Khóa ngoại tham chiếu ADMINS. |
| <u>*role_id*</u> | Mã định danh duy nhất của role. Khóa ngoại tham chiếu ROLES. | -->

```{=typst}
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
```

#### ROLE_PERMISSIONS

- Giải quyết quan hệ N-N giữa ROLES và PERMISSIONS.
- Gán quyền cho Role.

ROLE_PERMISSIONS(<u>role_id</u>, <u>permission_id</u>)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>*role_id*</u> | Khóa ngoại tham chiếu ROLES. |
| <u>*permission_id*</u> | Khóa ngoại tham chiếu PERMISSIONS. | -->

```{=typst}
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
```

#### CT_DATPHONG

- Giải quyết quan hệ N-N giữa DATPHONG và PHONG.
- Lưu trữ danh sách phòng trong một đơn đặt phòng.

CT_DATPHONG(<u>id</u>, *datphong_id*, *phong_id*, don_gia)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh dòng chi tiết (Surrogate Key). |
| *datphong_id* | Khóa ngoại tham chiếu DATPHONG. |
| *phong_id* | Khóa ngoại tham chiếu PHONG. |
| don_gia | Giá phòng được chốt tại thời điểm đặt (Lưu lịch sử giá). | -->

```{=typst}
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
```

#### CT_SUDUNG_DV

- Giải quyết quan hệ N-N giữa DATPHONG và DICHVU.
- Lưu trữ các dịch vụ khách sử dụng trong đơn đặt hàng.

CT_SUDUNG_DV(<u>id</u>, *datphong_id*, *dichvu_id*, so_luong, don_gia, thoi_diem_su_dung, ghi_chu, created_at)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh dòng chi tiết (Surrogate Key). |
| *datphong_id* | Khóa ngoại tham chiếu DATPHONG. |
| *dichvu_id* | Khóa ngoại tham chiếu DICHVU. |
| so_luong | Số lượng dịch vụ sử dụng. |
| don_gia | Đơn giá dịch vụ tại thời điểm sử dụng. |
| thoi_diem_su_dung | Thời gian khách order dịch vụ. |
| ghi_chu | Ghi chú về việc sử dụng dịch vụ. |
| created_at | Ngày tạo. | -->

```{=typst}
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
```

### Tổng Hợp Danh Sách Bảng

<!-- | **Tên Bảng** | **Loại** | **Mô Tả** |
|------|------|-------|
| ADMINS | Thực Thể | Biểu diễn người quản trị. |
| DATPHONG | Thực Thể | Lưu trữ thông tin đơn đặt phòng. |
| DICHVU | Thực Thể | Danh mục các dịch vụ đi kèm. |
| LOAIPHONG | Thực Thể | Danh mục phân loại phòng. |
| PAYMENTS | Thực Thể | Lưu trữ lịch sử giao dịch thanh toán. |
| PERMISSIONS | Thực Thể | Danh sách các quyền hạn hệ thống. |
| PHONG | Thực Thể | Danh sách các phòng vật lý. |
| REFUNDS | Thực Thể | Lưu trữ yêu cầu và lịch sử hoàn tiền. |
| REVIEWS | Thực Thể | Lưu trữ đánh giá từ khách hàng. |
| ROLES | Thực Thể | Định nghĩa các vai trò trong hệ thống. |
| USERS | Thực Thể | Lưu trữ thông tin khách hàng. |
| VOUCHERS | Thực Thể | Quản lý các chương trình khuyến mãi. |
| ADMIN_ROLES | Liên Kết | Mối quan hệ giữa ADMINS và ROLES. |
| ROLE_PERMISSIONS | Liên Kết | Mối quan hệ giữa ROLES và PERMISSIONS. |
| CT_DATPHONG | Liên Kết | Chi tiết các phòng trong đơn đặt phòng. |
| CT_SUDUNG_DV | Liên Kết | Chi tiết các dịch vụ khách sử dụng. | -->

```{=typst}
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
```

## Kết Luận Chương 2

Trong Chương 2, Nhóm 02 đã trình bày chi tiết các khía cạnh của việc phân tích và thiết kế cơ sở dữ liệu cho hệ thống quản lý khách sạn. Bắt đầu từ việc phân tích nghiệp vụ, xác định các chức năng chính và các đối tượng cần quản lý, chúng tôi đã xây dựng một mô hình dữ liệu logic hoàn chỉnh.

Mô hình này bao gồm 12 thực thể chính và các mối quan hệ giữa chúng, được biểu diễn qua sơ đồ ERD. Các thực thể này bao phủ toàn bộ hoạt động của khách sạn, từ quản lý phòng, khách hàng, đặt phòng, thanh toán cho đến các dịch vụ đi kèm.

Tiếp theo, Nhóm 02 đã chuyển đổi mô hình quan niệm sang mô hình mức logic, cụ thể là mô hình quan hệ. Trong phần này, nhóm đã định nghĩa chi tiết cấu trúc của từng bảng, bao gồm tên bảng, các thuộc tính, kiểu dữ liệu, khóa chính, khóa ngoại và các ràng buộc toàn vẹn. Việc sử dụng khóa ngoại giúp đảm bảo tính nhất quán và toàn vẹn dữ liệu trong toàn hệ thống.

Cuối cùng, nhóm đã tổng hợp danh sách tất cả các bảng trong cơ sở dữ liệu, giúp người đọc có cái nhìn tổng quan về cấu trúc của hệ thống. Các bảng này đã sẵn sàng để triển khai trên một hệ quản trị cơ sở dữ liệu cụ thể.

Qua chương này, Nhóm 02 đã hoàn thành việc phân tích và thiết kế cơ sở dữ liệu cho hệ thống quản lý khách sạn, tạo nền tảng vững chắc cho việc triển khai và phát triển hệ thống trong các chương tiếp theo.
