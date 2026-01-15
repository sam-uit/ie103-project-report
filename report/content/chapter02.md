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

- Nhóm 1:

```
LOAIPHONG 1 --- n PHONG
KHACHHANG 1 --- n DATPHONG
DATPHONG 1 --- n CT_DATPHONG
PHONG 1 --- n CT_DATPHONG
DATPHONG 1 --- n PAYMENTS
PAYMENTS 1 --- n REFUNDS
```

- Nhóm 2:

```
ADMINS 1 --- n ADMIN_ROLES
ROLES 1 --- n ADMIN_ROLES
ROLES 1 --- n ROLE_PERMISSIONS
PERMISSIONS 1 --- n ROLE_PERMISSIONS
```

- Nhóm 3:

```
VOUCHERS 1 --- n DATPHONG (Một voucher có thể được dùng cho nhiều đặt phòng)
DATPHONG 1 --- n CT_SUDUNG_DV (Một đặt phòng có thể sử dụng nhiều dịch vụ)
DICHVU 1 --- n CT_SUDUNG_DV (Một dịch vụ có thể được sử dụng nhiều lần)
USERS 1 --- n REVIEWS (Một user có thể đánh giá nhiều phòng)
PHONG 1 --- n REVIEWS (Một phòng có thể có nhiều đánh giá)
DATPHONG 1 --- 1 REVIEWS (Một đặt phòng có thể có một đánh giá)
```


## Mô Hình Mức Quan Niệm

## Thiết Kế Cơ Sở Dữ Liệu

