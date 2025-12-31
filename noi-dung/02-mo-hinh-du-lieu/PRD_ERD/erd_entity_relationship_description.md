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

---

## 2. Nhóm Room & Booking

### 2.1 `LOAIPHONG`

**Mô tả:**

- Danh mục loại phòng (Đơn, Đôi, VIP...).

**Quan hệ:**

- 1 Loại phòng có nhiều Phòng (`PHONG`).

---

### 2.2 `PHONG`

**Mô tả:**

- Phòng cụ thể có thể được đặt.

**Quan hệ:**

- Thuộc về một `LOAIPHONG`.
- Có thể xuất hiện trong nhiều đơn đặt phòng thông qua `CT_DATPHONG`.

---

### 2.3 `DATPHONG`

**Mô tả:**

- Đại diện cho một lần đặt phòng của User.

**Quan hệ:**

- Thuộc về một `USERS`.
- Có nhiều phòng được đặt thông qua `CT_DATPHONG`.
- Có thể phát sinh thanh toán (`PAYMENTS`).

---

### 2.4 `CT_DATPHONG` (Chi tiết đặt phòng)

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

### 3.1 `PAYMENTS`

**Mô tả:**

- Ghi nhận giao dịch thanh toán cho đơn đặt phòng.

**Quan hệ:**

- Thuộc về một `DATPHONG`.
- Được thực hiện bởi một `USERS`.
- Có thể phát sinh nhiều `REFUNDS`.

---

### 3.2 `REFUNDS`

**Mô tả:**

- Ghi nhận các yêu cầu và giao dịch hoàn tiền.

**Quan hệ:**

- Thuộc về một `PAYMENTS`.
- Được yêu cầu bởi `USERS`.
- Được duyệt bởi `ADMINS`.

---

## 4. Tóm tắt quan hệ chính

- `USERS` ⟶ `DATPHONG` ⟶ `CT_DATPHONG` ⟶ `PHONG` ⟶ `LOAIPHONG`
- `DATPHONG` ⟶ `PAYMENTS` ⟶ `REFUNDS`
- `ADMINS` ⟶ `ADMIN_ROLES` ⟶ `ROLES` ⟶ `ROLE_PERMISSIONS` ⟶ `PERMISSIONS`

---

## 5. Ghi chú thiết kế

- **Các quan hệ N–N đều được xử lý bằng bảng trung gian.**
  - Sẽ được biểu diễn trong ER Chen notation.

- Phù hợp triển khai ràng buộc khóa ngoại, trigger và procedure trong SQL.

