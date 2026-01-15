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

## Đối Tượng và Mối Quan Hệ

![Mô Hình Thực Thể Quan Hệ](diagrams/er.svg)

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

### Các thực thể chính

- `LOAIPHONG`
- `PHONG`
- `KHACHHANG`
- `DATPHONG`
- `CT_DATPHONG`
- `USERS` (End User)
- `ADMINS` (Admin / Staff)
- `ROLES`
- `PERMISSIONS`
- `ADMIN_ROLES`
- `ROLE_PERMISSIONS`
- `PAYMENTS`
- `REFUNDS`
- `VOUCHERS` (Mã giảm giá)
- `DICHVU` (Dịch vụ đi kèm)
- `CT_SUDUNG_DV` (Chi tiết sử dụng dịch vụ)
- `REVIEWS` (Đánh giá & phản hồi)

### Quan Hệ Giữa Các Thực Thể

- `LOAIPHONG 1 --- n PHONG`: Một loại phòng có thể có nhiều phòng.
- `KHACHHANG 1 --- n DATPHONG`: Một khách hàng có thể có nhiều đặt phòng.
- `DATPHONG 1 --- n CT_DATPHONG`: Một đặt phòng có thể có nhiều chi tiết đặt phòng.
- `PHONG 1 --- n CT_DATPHONG`: Một phòng có thể có nhiều chi tiết đặt phòng.
- `DATPHONG 1 --- n PAYMENTS`: Một đặt phòng có thể có nhiều thanh toán.
- `PAYMENTS 1 --- n REFUNDS`: Một thanh toán có thể có nhiều hoàn tiền.
- `ADMINS 1 --- n ADMIN_ROLES`: Một admin có thể có nhiều admin role.
- `ROLES 1 --- n ADMIN_ROLES`: Một role có thể có nhiều admin roles.
- `ROLES 1 --- n ROLE_PERMISSIONS`: Một role có thể có nhiều role permission.
- `PERMISSIONS 1 --- n ROLE_PERMISSIONS`: Một permission có thể thuộc nhiều role.
- `VOUCHERS 1 --- n DATPHONG`: Một voucher có thể được dùng cho nhiều đặt phòng.
- `DATPHONG 1 --- n CT_SUDUNG_DV`: Một đặt phòng có thể sử dụng nhiều dịch vụ.
- `DICHVU 1 --- n CT_SUDUNG_DV`: Một dịch vụ có thể được sử dụng nhiều lần.
- `USERS 1 --- n REVIEWS`: Một user có thể đánh giá nhiều phòng.
- `PHONG 1 --- n REVIEWS`: Một phòng có thể có nhiều đánh giá.
- `DATPHONG 1 --- 1 REVIEWS`: Một đặt phòng có thể có một đánh giá.


## Mô Hình Mức Quan Niệm

## Thiết Kế Cơ Sở Dữ Liệu

