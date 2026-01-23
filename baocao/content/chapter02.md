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

## Đối Tượng Và Mối Quan Hệ

![Mô Hình Thực Thể Quan Hệ](diagrams/ch02-ER.svg)

### User Stories

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

### Các Đối Tượng Chính

```{=typst}
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
    Các Đối Tượng Chính
  ],
)
```

### Quan Hệ Giữa Các Đối Tượng

- `ADMINS 1 --- n ADMIN_ROLES`: Một admin có thể có nhiều admin role.
- `DATPHONG 1 --- 1 REVIEWS`: Một đặt phòng có thể có một đánh giá.
- `DATPHONG 1 --- n CT_DATPHONG`: Một đặt phòng có thể có nhiều chi tiết đặt phòng.
- `DATPHONG 1 --- n CT_SUDUNG_DV`: Một đặt phòng có thể sử dụng nhiều dịch vụ.
- `DATPHONG 1 --- n PAYMENTS`: Một đặt phòng có thể có nhiều thanh toán.
- `DICHVU 1 --- n CT_SUDUNG_DV`: Một dịch vụ có thể được sử dụng nhiều lần.
- `LOAIPHONG 1 --- n PHONG`: Một loại phòng có thể có nhiều phòng.
- `PAYMENTS 1 --- n REFUNDS`: Một thanh toán có thể có nhiều hoàn tiền.
- `PERMISSIONS 1 --- n ROLE_PERMISSIONS`: Một permission có thể thuộc nhiều role.
- `PHONG 1 --- n CT_DATPHONG`: Một phòng có thể có nhiều chi tiết đặt phòng.
- `PHONG 1 --- n REVIEWS`: Một phòng có thể có nhiều đánh giá.
- `ROLES 1 --- n ADMIN_ROLES`: Một role có thể có nhiều admin roles.
- `ROLES 1 --- n ROLE_PERMISSIONS`: Một role có thể có nhiều role permission.
- `USERS 1 --- n DATPHONG`: Một user có thể có nhiều đặt phòng.
- `USERS 1 --- n REVIEWS`: Một user có thể đánh giá nhiều phòng.
- `VOUCHERS 1 --- n DATPHONG`: Một voucher có thể được dùng cho nhiều đặt phòng.

## Mô Hình Mức Quan Niệm

### Nhóm Bảng Thực Thể

### Nhóm Bảng Mối Quan Hệ

## Thiết Kế Cơ Sở Dữ Liệu

