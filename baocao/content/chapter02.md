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

1. Một phòng không được đặt trùng thời gian
2. Ngày trả phòng phải lớn hơn ngày nhận phòng
3. Giờ trả phòng trễ nhất là **12:00 trưa** mỗi ngày
4. Giờ nhận phòng sớm nhất là **14:00 (2 giờ chiều)** mỗi ngày
5. Một lần đặt phòng phải có ít nhất một phòng
6. Mỗi đặt phòng chỉ có tối đa một thanh toán
7. Số tiền thanh toán phải lớn hơn 0
8. Không được xóa đặt phòng nếu đã thanh toán
9. Có thể hoàn tiền nếu người dùng yêu cầu trước 24 tiếng (2 ngày) kể từ ngày nhận phòng
10. **Mỗi đặt phòng có thể áp dụng tối đa một mã giảm giá (voucher)**
11. **Mã giảm giá phải còn hạn sử dụng và chưa hết số lượng**
12. **Khách hàng có thể gọi dịch vụ đi kèm bất cứ lúc nào trong thời gian lưu trú**
13. **Chỉ những khách hàng đã thanh toán (PAID) và đã trả phòng mới được đánh giá**
14. **Mỗi đặt phòng chỉ được đánh giá một lần**
15. **Số sao đánh giá phải từ 1 đến 5**

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

### Danh Sách Các Thực Thể

#### ADMINS (Quản Lý/Quản Trị Viên)

Định Nghĩa:

- Đại diện cho người dùng nội bộ của hệ thống (Admin / Staff).
- Có quyền quản lý nghiệp vụ và dữ liệu hệ thống.

#### DATPHONG (Đặt Phòng)
#### DICHVU (Dịch Vụ)
#### LOAIPHONG (Loại Phòng)
#### PAYMENTS (Thanh Toán)
#### PERMISSIONS (Quyền Hạn)
#### PHONG (Phòng)
#### REFUNDS (Hoàn Tiền)
#### REVIEWS (Đánh Giá)
#### ROLES (Vai Trò)
#### USERS (Người Dùng)
#### VOUCHERS (Mã Giảm Giá)

### Quan Hệ Giữa Các Thực Thể

<!-- TODO: Mô tả bằng ngôn ngữ "business" thay vì kỹ thuật -->

- ADMINS - ROLES: Một admin có thể có nhiều role. Một role có thể gán cho nhiều admin.

<!-- (nên cần bảng trung gian) -->

## Mô Hình Mức Quan Niệm

<!-- - Thực thể và các thuộc tính. -->
<!-- - Mô hình ER dạng Chen. -->

![Mô Hình Thực Thể Quan Hệ](diagrams/ER.svg)

### Các Thực Thể

#### ADMINS (Quản Lý/Quản Trị Viên)

Định Nghĩa:

- Đại diện cho người dùng nội bộ của hệ thống (Admin / Staff).
- Có quyền quản lý nghiệp vụ và dữ liệu hệ thống.

Thuộc Tính:

- `id`: Mã định danh duy nhất của admin.
- `username`: Tên đăng nhập của admin.
- `password`: Mật khẩu của admin.
- `full_name`: Họ tên đầy đủ của admin.
- `email`: Email của admin.
- `phone`: Số điện thoại của admin.
- `address`: Địa chỉ của admin.
- `created_at`: Thời gian tạo của admin.
- `updated_at`: Thời gian cập nhật của admin.

#### DATPHONG (Đặt Phòng)
#### DICHVU (Dịch Vụ)
#### LOAIPHONG (Loại Phòng)
#### PAYMENTS (Thanh Toán)
#### PERMISSIONS (Quyền Hạn)
#### PHONG (Phòng)
#### REFUNDS (Hoàn Tiền)
#### REVIEWS (Đánh Giá)
#### ROLES (Vai Trò)
#### USERS (Người Dùng)
#### VOUCHERS (Mã Giảm Giá)

### Các Mối Quan Hệ

- `ADMINS - ROLES`: (n, n)
    - Một admin có thể có nhiều admin role.
    - Một role gán vào một admin cụ thể.

## Mô Hình Mức Logic

#### ADMINS (Quản Lý/Quản Trị Viên)

ADMINS(<u>id</u>, username, password, full_name, email, phone, address, created_at, updated_at)

- `id`: Mã định danh duy nhất của admin.
- `username`: Tên đăng nhập của admin.
- `password`: Mật khẩu của admin.
- `full_name`: Họ tên đầy đủ của admin.
- `email`: Email của admin.
- `phone`: Số điện thoại của admin.
- `address`: Địa chỉ của admin.
- `created_at`: Thời gian tạo của admin.
- `updated_at`: Thời gian cập nhật của admin.

#### DATPHONG (Đặt Phòng)
#### DICHVU (Dịch Vụ)
#### LOAIPHONG (Loại Phòng)
#### PAYMENTS (Thanh Toán)
#### PERMISSIONS (Quyền Hạn)
#### PHONG (Phòng)
#### REFUNDS (Hoàn Tiền)
#### REVIEWS (Đánh Giá)
#### ROLES (Vai Trò)
#### USERS (Người Dùng)
#### VOUCHERS (Mã Giảm Giá)

### Nhóm Bảng Mối Quan Hệ

#### `ADMIN_ROLES`:

Mối quan hệ giữa ADMINS và ROLES

`ADMIN_ROLES`(<u>admin_id</u>, <u>role_id</u>)

- `admin_id`: Mã định danh duy nhất của admin.
- `role_id`: Mã định danh duy nhất của role.

- ROLE_PERMISSIONS
- CT_DATPHONG
- CT_SUDUNG_DV

### Tổng Hợp

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
    Các Bảng Trong Cơ Sở Dữ Liệu
  ],
)
```

## Thiết Kế Cơ Sở Dữ Liệu


### Vật Lý
