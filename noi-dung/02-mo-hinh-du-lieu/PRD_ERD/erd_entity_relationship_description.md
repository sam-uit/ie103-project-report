# MÔ TẢ THỰC THỂ & MỐI QUAN HỆ (ERD)

Tài liệu này mô tả ý nghĩa của từng **thực thể (Entity)** trong ERD của Hệ thống Quản lý Đặt phòng, cùng với **các mối quan hệ (Relationship)** giữa chúng. Tài liệu dùng để giải thích thiết kế CSDL khi báo cáo hoặc bảo vệ đồ án.

---

## 1. Nhóm User & Authorization

### 1.1 ADMINS

**Mô tả:**

- Đại diện cho người dùng nội bộ của hệ thống (Admin / Staff).
- Có quyền quản lý nghiệp vụ và dữ liệu hệ thống.

**Quan hệ:**

- 1 Admin có thể có nhiều Role thông qua `ADMIN_ROLES`.
- Admin có quyền duyệt hoàn tiền (`REFUNDS`).

---

### 1.2 ROLES

**Mô tả:**

- Định nghĩa vai trò trong hệ thống (VD: SUPER\_ADMIN, STAFF).

**Quan hệ:**

- 1 Role có thể gán cho nhiều Admin (`ADMIN_ROLES`).
- 1 Role bao gồm nhiều Permission (`ROLE_PERMISSIONS`).

---

### 1.3 PERMISSIONS

**Mô tả:**

- Định nghĩa quyền thao tác cụ thể (CRUD phòng, duyệt hoàn tiền, xem báo cáo...).

**Quan hệ:**

- 1 Permission có thể thuộc nhiều Role (`ROLE_PERMISSIONS`).

---

### 1.4 ADMIN\_ROLES

**Mô tả:**

- Bảng trung gian thể hiện quan hệ N–N giữa `ADMINS` và `ROLES`.

**Ý nghĩa thiết kế:**

- Một Admin có thể có nhiều Role.
- Một Role có thể gán cho nhiều Admin.

---

### 1.5 ROLE\_PERMISSIONS

**Mô tả:**

- Bảng trung gian thể hiện quan hệ N–N giữa `ROLES` và `PERMISSIONS`.

---

### 1.6 USERS

**Mô tả:**

- Người dùng cuối của hệ thống (khách đặt phòng).

**Quan hệ:**

- 1 User có thể tạo nhiều đơn đặt phòng (`DATPHONG`).
- 1 User có thể thực hiện nhiều giao dịch thanh toán (`PAYMENTS`).
- 1 User có thể viết nhiều đánh giá (`REVIEWS`).

---

## 2. Nhóm Room & Booking

### 2.1 LOAIPHONG

**Mô tả:**

- Danh mục loại phòng (Đơn, Đôi, VIP...).

**Quan hệ:**

- 1 Loại phòng có nhiều Phòng (`PHONG`).

---

### 2.2 PHONG

**Mô tả:**

- Phòng cụ thể có thể được đặt.

**Quan hệ:**

- Thuộc về một `LOAIPHONG`.
- Có thể xuất hiện trong nhiều đơn đặt phòng thông qua `CT_DATPHONG`.
- Có thể nhận nhiều đánh giá từ khách hàng (`REVIEWS`).

---

### 2.3 DATPHONG

**Mô tả:**

- Đại diện cho một lần đặt phòng của User.

**Quan hệ:**

- Thuộc về một `USERS`.
- Có nhiều phòng được đặt thông qua `CT_DATPHONG`.
- Có thể phát sinh thanh toán (`PAYMENTS`).
- Có thể áp dụng một mã giảm giá (`VOUCHERS`).
- Có thể sử dụng nhiều dịch vụ thông qua `CT_SUDUNG_DV`.
- Có thể tạo ra một đánh giá (`REVIEWS`).

---

### 2.4 CT\_DATPHONG (Chi tiết đặt phòng)

**Mô tả:**

- Bảng chi tiết thể hiện các phòng cụ thể trong một đơn đặt phòng.

**Ý nghĩa nghiệp vụ:**

- Giải quyết quan hệ N–N giữa `DATPHONG` và `PHONG`.
- Lưu đơn giá phòng tại thời điểm đặt.

**Quan hệ:**

- Thuộc về một `DATPHONG`.
- Tham chiếu tới một `PHONG`.

---

## 3. Nhóm Payment & Refund

### 3.1 PAYMENTS

**Mô tả:**

- Ghi nhận giao dịch thanh toán cho đơn đặt phòng.

**Các thuộc tính chính:**

- `so_tien`: Số tiền thanh toán
- `phuong_thuc`: Phương thức thanh toán (Tiền mặt/Chuyển khoản/Thẻ...)
- `trang_thai`: Trạng thái thanh toán (PENDING/SUCCESS/FAILED/CANCELLED)

**Quan hệ:**

- Thuộc về một `DATPHONG`.
- Được thực hiện bởi một `USERS`.
- Có thể phát sinh nhiều `REFUNDS`.

**Nghiệp vụ:**

- Tổng tiền thanh toán được tính tự động dựa trên: Tiền phòng + Tiền dịch vụ - Giảm giá (nếu có voucher).

---

### 3.2 REFUNDS

**Mô tả:**

- Ghi nhận các yêu cầu và giao dịch hoàn tiền.

**Các thuộc tính chính:**

- `so_tien_hoan`: Số tiền hoàn lại
- `ly_do`: Lý do hoàn tiền
- `trang_thai`: Trạng thái hoàn tiền (REQUESTED/APPROVED/REJECTED/COMPLETED)

**Quan hệ:**

- Thuộc về một `PAYMENTS`.
- Được yêu cầu bởi `USERS`.
- Được duyệt bởi `ADMINS`.

**Nghiệp vụ:**

- Khách hàng được hoàn tiền nếu hủy đặt phòng trước ít nhất 24 giờ so với thời điểm nhận phòng.
- Nếu hủy trong vòng 24 giờ trước giờ nhận phòng, không hoàn tiền.

---

## 4. Nhóm Vouchers & Promotions

### 4.1 VOUCHERS

**Mô tả:**

- Đại diện cho mã giảm giá/khuyến mãi trong hệ thống.
- Cho phép khách hàng nhận ưu đãi khi đặt phòng.

**Các thuộc tính chính:**

- `ma_code`: Mã voucher duy nhất
- `phan_tram_giam`: Phần trăm giảm giá
- `ngay_het_han`: Ngày hết hạn sử dụng
- `so_tien_toi_thieu`: Số tiền đặt phòng tối thiểu để áp dụng
- `so_lan_toi_da`: Số lần sử dụng tối đa
- `so_lan_da_dung`: Số lần đã được sử dụng
- `trang_thai`: Trạng thái voucher (Active/Inactive)

**Quan hệ:**

- Một Voucher có thể được áp dụng cho nhiều đơn đặt phòng (`DATPHONG`).
- Mỗi đơn đặt phòng chỉ có thể áp dụng tối đa một Voucher.

**Nghiệp vụ:**

- Trigger kiểm tra voucher còn hạn và tự động tính lại tổng tiền thanh toán.
- Tăng `so_lan_da_dung` khi voucher được áp dụng thành công.

---

## 5. Nhóm Services (Dịch vụ đi kèm)

### 5.1 DICHVU

**Mô tả:**

- Danh mục các dịch vụ bổ sung mà khách sạn cung cấp (ăn sáng, giặt ủi, đưa đón sân bay, spa...).

**Các thuộc tính chính:**

- `ten_dich_vu`: Tên dịch vụ
- `don_gia`: Đơn giá dịch vụ
- `don_vi_tinh`: Đơn vị tính (Suất, Lần, Giờ...)
- `trang_thai`: Trạng thái dịch vụ (Active/Inactive)

**Quan hệ:**

- Một Dịch vụ có thể được sử dụng nhiều lần thông qua `CT_SUDUNG_DV`.

---

### 5.2 CT\_SUDUNG\_DV (Chi tiết sử dụng dịch vụ)

**Mô tả:**

- Ghi nhận chi tiết việc sử dụng dịch vụ của khách hàng trong thời gian lưu trú.

**Các thuộc tính chính:**

- `datphong_id`: Tham chiếu đến đơn đặt phòng
- `dichvu_id`: Tham chiếu đến dịch vụ
- `so_luong`: Số lượng dịch vụ sử dụng
- `don_gia`: Đơn giá tại thời điểm sử dụng
- `thoi_diem_su_dung`: Thời điểm gọi dịch vụ
- `ghi_chu`: Ghi chú bổ sung

**Ý nghĩa nghiệp vụ:**

- Giải quyết quan hệ N–N giữa `DATPHONG` và `DICHVU`.
- Lưu đơn giá dịch vụ tại thời điểm sử dụng (có thể thay đổi theo thời gian).
- Khách hàng có thể gọi dịch vụ bất cứ lúc nào trong thời gian lưu trú.

**Quan hệ:**

- Thuộc về một `DATPHONG`.
- Tham chiếu tới một `DICHVU`.

**Nghiệp vụ:**

- Stored Procedure tổng hợp hóa đơn cuối cùng: Tiền phòng + Tiền dịch vụ - Giảm giá.

---

## 6. Nhóm Reviews & Ratings

### 6.1 REVIEWS

**Mô tả:**

- Ghi nhận đánh giá và phản hồi của khách hàng về phòng sau khi hoàn tất thanh toán.

**Các thuộc tính chính:**

- `user_id`: Người đánh giá
- `phong_id`: Phòng được đánh giá
- `datphong_id`: Đơn đặt phòng liên quan (UNIQUE - mỗi đơn chỉ đánh giá một lần)
- `so_sao`: Số sao đánh giá (1-5)
- `binh_luan`: Nội dung đánh giá
- `ngay_danh_gia`: Ngày đánh giá
- `trang_thai`: Trạng thái (Pending/Approved/Rejected)

**Quan hệ:**

- Thuộc về một `USERS` (người viết đánh giá).
- Tham chiếu tới một `PHONG` (phòng được đánh giá).
- Tham chiếu tới một `DATPHONG` (đơn đặt phòng đã hoàn thành).

**Nghiệp vụ:**

- Chỉ những khách hàng đã thanh toán (PAID) và đã trả phòng mới được đánh giá.
- Mỗi đặt phòng chỉ được đánh giá một lần.
- Admin có thể duyệt hoặc từ chối đánh giá.
- View tính điểm trung bình Rating cho mỗi LOAIPHONG để hiển thị trên trang chủ.

---

## 7. Tóm tắt quan hệ chính

### 7.1 Luồng đặt phòng & thanh toán
- USERS ⟶ DATPHONG ⟶ CT\_DATPHONG ⟶ PHONG ⟶ LOAIPHONG
- DATPHONG ⟶ PAYMENTS ⟶ REFUNDS

### 7.2 Phân quyền
- ADMINS ⟶ ADMIN\_ROLES ⟶ ROLES ⟶ ROLE\_PERMISSIONS ⟶ PERMISSIONS

### 7.3 Khuyến mãi & dịch vụ
- VOUCHERS ⟶ DATPHONG (áp dụng mã giảm giá)
- DATPHONG ⟶ CT\_SUDUNG\_DV ⟶ DICHVU (sử dụng dịch vụ)

### 7.4 Đánh giá
- USERS ⟶ REVIEWS ⟵ PHONG
- DATPHONG ⟶ REVIEWS (một đơn đặt phòng tạo một đánh giá)

---

## 8. Ghi chú thiết kế

- Các quan hệ N–N đều được xử lý bằng bảng trung gian (CT_DATPHONG, CT_SUDUNG_DV, ADMIN_ROLES, ROLE_PERMISSIONS).
- Phù hợp triển khai ràng buộc khóa ngoại, trigger và procedure trong SQL.
- **Trigger** được sử dụng để:
  - Kiểm tra voucher còn hạn và tự động tính lại tổng tiền thanh toán
  - Kiểm tra điều kiện đánh giá (đã thanh toán và trả phòng)
- **Stored Procedure** để tổng hợp hóa đơn cuối cùng (phòng + dịch vụ - giảm giá).
- **View** để tính điểm trung bình rating cho mỗi loại phòng.

