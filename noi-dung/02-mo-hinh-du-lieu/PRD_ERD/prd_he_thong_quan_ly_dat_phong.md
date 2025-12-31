# HỆ THỐNG QUẢN LÝ ĐẶT PHÒNG

---

## 1. Tổng quan sản phẩm

### 1.1 Tên sản phẩm

- **Booking Management System (BMS)**

### 1.2 Mục đích

Hệ thống Quản lý Đặt phòng (BMS) được xây dựng nhằm hỗ trợ quản lý thông tin phòng, khách hàng, đặt phòng và thanh toán ở mức cơ bản. Hệ thống tập trung vào quản lý dữ liệu bằng cơ sở dữ liệu quan hệ, phục vụ cho việc học tập và thực hành SQL trong môn Quản lý thông tin.

### 1.3 Đối tượng sử dụng

- Quản trị viên (Admin)
- Nhân viên (Staff)
- Người dùng cuối (End User)

### 1.4 Phạm vi áp dụng

- Khách sạn, nhà nghỉ, homestay quy mô nhỏ và vừa
- Có giao diện quản lý (BMS) cho Admin/Staff
- Có giao diện người dùng (User Application) cho End User
- Có triển khai ứng dụng web hoặc mobile ở mức hoàn chỉnh cho mục đích demo và đồ án
- Có tích hợp thanh toán trực tuyến ở mức mô phỏng

---

## 2. Vấn đề cần giải quyết

Việc quản lý đặt phòng thủ công hoặc bằng bảng tính gặp nhiều hạn chế:

- Dễ xảy ra trùng lịch đặt phòng
- Khó theo dõi trạng thái phòng theo thời gian
- Dữ liệu khách hàng phân tán, khó truy vấn
- Khó tổng hợp báo cáo và thống kê doanh thu
- Dữ liệu có thể được sao lưu tự động và bảo mật

---

## 3. Mục tiêu sản phẩm

- Quản lý dữ liệu tập trung bằng cơ sở dữ liệu quan hệ
- Đảm bảo toàn vẹn và nhất quán dữ liệu
- Hỗ trợ truy vấn và thống kê hiệu quả bằng SQL
- Phù hợp để triển khai các ràng buộc, trigger và procedure, cursor

---

## 4. Stakeholders

| Vai trò  | Mô tả                                                           |
| -------- | --------------------------------------------------------------- |
| Admin    | Quản lý phòng, loại phòng, giá phòng                            |
| Staff    | Quản lý đặt phòng, xác nhận / hủy đặt, ghi nhận thanh toán      |
| End User | Tìm kiếm phòng, đặt phòng, hủy đặt phòng và theo dõi thanh toán |

---

## 5. Phạm vi chức năng

### 5.1 In Scope

- Quản lý phòng và loại phòng (BMS)
- Quản lý khách hàng (BMS)
- Quản lý đặt phòng (BMS)
- Kiểm tra phòng trống (BMS & User Application)
- Đặt phòng và hủy đặt phòng (User Application)
- Thanh toán trực tuyến (mô phỏng)
- Hoàn tiền và hủy giao dịch theo chính sách
- Quản lý và phân quyền người dùng (Admin / Staff / End User)
- Hiển thị trạng thái đặt phòng và thanh toán (User Application)
- Ứng dụng web hoặc mobile hoàn chỉnh phục vụ thao tác đặt phòng

### 5.2 Out of Scope

- Tích hợp cổng thanh toán thực tế (VNPay, Stripe, PayPal)
- Hệ thống kế toán hoặc xuất hóa đơn điện tử
- Tối ưu hiệu năng cho quy mô lớn (high traffic)
- Tích hợp bên thứ ba (OTA như Booking, Agoda)

---

## 6. User Stories

### US-01: Quản lý phòng

Là **Admin**, tôi muốn thêm, sửa, xóa phòng để cập nhật thông tin phòng.

### US-02: Quản lý khách hàng

Là **Staff**, tôi muốn lưu trữ thông tin khách hàng để theo dõi lịch sử đặt phòng.

### US-03: Đặt phòng (End User)

Là **End User**, tôi muốn tìm kiếm phòng trống và đặt phòng theo thời gian mong muốn.

### US-04: Hủy đặt phòng (End User)

Là **End User**, tôi muốn hủy đặt phòng trước thời điểm nhận phòng và biết liệu mình có được hoàn tiền hay không.

### US-05: Kiểm tra phòng trống

Là **Staff** hoặc **End User**, tôi muốn xem danh sách phòng trống theo ngày check-in và check-out.

### US-06: Thanh toán

Là **Staff**, tôi muốn ghi nhận thanh toán và hoàn tiền cho một đặt phòng để theo dõi trạng thái thanh toán và doanh thu.

---

## 7. Yêu cầu dữ liệu (Data Requirements)

### 7.1 Các thực thể chính

- LOAIPHONG
- PHONG
- KHACHHANG
- DATPHONG
- CT\_DATPHONG
- USERS (End User)
- ADMINS (Admin / Staff)
- ROLES
- PERMISSIONS
- ADMIN\_ROLES
- ROLE\_PERMISSIONS
- PAYMENTS
- REFUNDS

### 7.2 Quan hệ giữa các thực thể

```
LOAIPHONG 1 --- n PHONG
KHACHHANG 1 --- n DATPHONG
DATPHONG 1 --- n CT_DATPHONG
PHONG 1 --- n CT_DATPHONG
DATPHONG 1 --- n PAYMENTS
PAYMENTS 1 --- n REFUNDS

ADMINS 1 --- n ADMIN_ROLES
ROLES 1 --- n ADMIN_ROLES
ROLES 1 --- n ROLE_PERMISSIONS
PERMISSIONS 1 --- n ROLE_PERMISSIONS
```

---

## 8. Business Rules

1. Một phòng không được đặt trùng thời gian
2. Ngày trả phòng phải lớn hơn ngày nhận phòng
3. Giờ trả phòng trễ nhất là **12:00 trưa** mỗi ngày
4. Giờ nhận phòng sớm nhất là **14:00 (2 giờ chiều)** mỗi ngày
5. Một lần đặt phòng phải có ít nhất một phòng
6. Mỗi đặt phòng chỉ có tối đa một thanh toán
7. Số tiền thanh toán phải lớn hơn 0
8. Không được xóa đặt phòng nếu đã thanh toán
9. Có thể hoàn tiền nếu người dùng yêu cầu trước 24 tiếng (2 ngày) kể từ ngày nhận phòng.

---

## 9. Yêu cầu thanh toán (Phiên bản đơn giản)

### 9.1 Mô tả

Hệ thống hỗ trợ ghi nhận thanh toán ở mức cơ bản. Mỗi đặt phòng tương ứng tối đa một giao dịch thanh toán. Thanh toán có thể là tiền cọc hoặc thanh toán toàn bộ.

### 9.2 Trạng thái thanh toán

- PAID: Đã thanh toán
- UNPAID: Chưa thanh toán
- REFUNDED: Đã hoàn tiền

### 9.3 Chính sách hoàn tiền (Refund Policy)

- Khách hàng được hoàn tiền nếu **hủy đặt phòng trước ít nhất 24 giờ** so với thời điểm nhận phòng
- Hoàn tiền áp dụng cho các đặt phòng đã thanh toán
- Nếu hủy trong vòng 24 giờ trước giờ nhận phòng, **không hoàn tiền**

### 9.4 Dữ liệu lưu trữ

- Số tiền đã trả
- Phương thức thanh toán (Tiền mặt / Chuyển khoản)
- Trạng thái thanh toán (PAID / UNPAID / REFUNDED)
- Ngày thanh toán
- Ngày hoàn tiền (nếu có)

---

## 10. Yêu cầu SQL (Deliverables cho đồ án)

### 10.1 DDL

- CREATE TABLE với PRIMARY KEY, FOREIGN KEY
- CHECK, UNIQUE constraint

### 10.2 DML

- INSERT dữ liệu mẫu
- UPDATE trạng thái phòng và thanh toán
- DELETE có kiểm soát ràng buộc

### 10.3 Truy vấn nâng cao

- Danh sách phòng trống theo thời gian
- Doanh thu theo tháng
- Danh sách đặt phòng chưa thanh toán
- Khách hàng có số lượt đặt phòng nhiều nhất

---

## 11. Non-Functional Requirements

- Đảm bảo toàn vẹn dữ liệu
- Truy vấn hiệu quả với dữ liệu mẫu
- Dễ dàng mở rộng thêm chức năng

---

## 12. Tiêu chí đánh giá đồ án

- Thiết kế CSDL đạt chuẩn (3NF)
- Áp dụng đúng JOIN, SUBQUERY, GROUP BY
- Có sử dụng constraint và trigger, cursor, stored procedures
- Truy vấn phản ánh đúng nghiệp vụ

---

## 13. Bổ sung: Quản lý người dùng, Thanh toán & ERD

### 13.1 Quản lý người dùng & phân quyền

- Hệ thống phân tách rõ **Admins** (người dùng nội bộ) và **End Users** (người dùng cuối)
- Admins áp dụng mô hình **RBAC (Role-Based Access Control)**
- Một Admin có thể có nhiều Role
- Mỗi Role gồm nhiều Permission (CRUD phòng, duyệt hoàn tiền, xem báo cáo...)

---

### 13.2 Thanh toán trực tuyến (mô phỏng)

- End User thực hiện thanh toán khi đặt phòng
- Không tích hợp cổng thanh toán thực tế
- Mỗi đơn đặt phòng có thể có nhiều giao dịch thanh toán (mở rộng)
- Trạng thái thanh toán:
  - PENDING
  - SUCCESS
  - FAILED
  - CANCELLED

---

### 13.3 Hoàn tiền & Hủy giao dịch

- End User được yêu cầu hoàn tiền nếu hủy trước **24 giờ** so với giờ nhận phòng
- Admin duyệt hoàn tiền
- Hỗ trợ hoàn tiền toàn phần hoặc một phần
- Trạng thái hoàn tiền:
  - REQUESTED
  - APPROVED
  - REJECTED
  - COMPLETED

---

### 13.4 ERD – Text Definition

#### Admins & Authorization

```text
admins
---------
id (PK)
email (UNIQUE)
password_hash
full_name
status
created_at
updated_at
```

```text
roles
-----
id (PK)
code
name
description
```

```text
permissions
-----------
id (PK)
code
description
```

```text
admin_roles
--------------
admin_id (FK -> admins.id)
role_id (FK -> roles.id)
```

```text
role_permissions
----------------
role_id (FK -> roles.id)
permission_id (FK -> permissions.id)
```

---

#### End Users

```text
users
-----
id (PK)
email
phone
password_hash
full_name
status
created_at
updated_at
```

---

#### Payments

```text
payments
--------
id (PK)
user_id (FK -> users.id)
booking_id (FK -> datphong.id)
amount
currency
payment_method
provider
transaction_ref
status
created_at
updated_at
```

---

#### Refunds

```text
refunds
-------
id (PK)
payment_id (FK -> payments.id)
refund_amount
reason
status
requested_by (FK -> users.id)
approved_by (FK -> admins.id)
created_at
updated_at
```

---

### 13.5 ERD – Mermaid Diagram (Flow-based)

#### 13.5.1 Phân quyền admin

```
erDiagram
    ADMINS ||--o{ ADMIN_ROLES : has
    ROLES ||--o{ ADMIN_ROLES : assigned
    ROLES ||--o{ ROLE_PERMISSIONS : includes
    PERMISSIONS ||--o{ ROLE_PERMISSIONS : grants
```


#### 13.5.2 Quy trình đặt phòng

```
erDiagram
    USERS ||--o{ DATPHONG : creates
    DATPHONG ||--o{ PAYMENTS : has
    PAYMENTS ||--o{ REFUNDS : generates

    ADMINS ||--o{ REFUNDS : approves
```

---

### 13.6 ERD tổng thể hệ thống (User, Booking, Payment, Admin & Authorization)

```
erDiagram
    %% ===== USER & AUTH =====
    ADMINS {
        int id PK
        string email
        string password_hash
        string full_name
        string status
    }

    ROLES {
        int id PK
        string code
        string name
    }

    PERMISSIONS {
        int id PK
        string code
        string description
    }

    ADMIN_ROLES {
        int admin_id FK
        int role_id FK
    }

    ROLE_PERMISSIONS {
        int role_id FK
        int permission_id FK
    }

    USERS {
        int id PK
        string email
        string phone
        string password_hash
        string full_name
        string status
    }

    %% ===== ROOM & BOOKING =====
    LOAIPHONG {
        int id PK
        string ten_loai
        decimal gia_co_ban
    }

    PHONG {
        int id PK
        string so_phong
        int loai_phong_id FK
        string trang_thai
    }

    DATPHONG {
        int id PK
        int user_id FK
        datetime check_in
        datetime check_out
        string trang_thai
        datetime created_at
    }

    CT_DATPHONG {
        int id PK
        int datphong_id FK
        int phong_id FK
        decimal don_gia
    }

    %% ===== PAYMENT =====
    PAYMENTS {
        int id PK
        int booking_id FK
        int user_id FK
        decimal amount
        string method
        string status
        datetime created_at
    }

    REFUNDS {
        int id PK
        int payment_id FK
        decimal refund_amount
        string status
        string reason
    }

    %% ===== RELATIONSHIPS =====
    ADMINS ||--o{ ADMIN_ROLES : has
    ROLES ||--o{ ADMIN_ROLES : assigned
    ROLES ||--o{ ROLE_PERMISSIONS : includes
    PERMISSIONS ||--o{ ROLE_PERMISSIONS : grants

    USERS ||--o{ DATPHONG : creates
    DATPHONG ||--o{ CT_DATPHONG : contains
    PHONG ||--o{ CT_DATPHONG : booked
    LOAIPHONG ||--o{ PHONG : categorizes

    DATPHONG ||--o{ PAYMENTS : has
    PAYMENTS ||--o{ REFUNDS : refunds
    USERS ||--o{ PAYMENTS : makes
    ADMINS ||--o{ REFUNDS : approves
```



### 14.7 Ghi chú triển khai SQL

- RBAC triển khai bằng bảng trung gian (many-to-many)
- Có thể dùng TRIGGER để tự động cập nhật trạng thái thanh toán / hoàn tiền
- ERD phù hợp triển khai
- Dễ mở rộng cho đồ án nâng cao

### 14.8 Links
- [Mermaid - Phân quyền admin](https://mermaid.live/edit#pako:eNp1UMtugzAQ_BW0Z4JIeNj4VjU5IOVRhVtlKbLiLaDEdmSw1Jbw74WQVjmke9qZnZldbQdHIxEYoF3WorRCce0N9bLc5NvCu15nM9NN6LDfrVeFx7xKNJNoIp5qRNPUpUb5RDiCw9tqv8mLIt9tR3Wtj2cn8R77OPvfM9yq2wZ8KG0tgbXWoQ8KrRIjhG7M4tBWqJADG1op7IkD1_3guQj9boz6tVnjygrYhzg3A3IXKVq8v-OPtagl2lfjdAssu0UA6-ATWJQkQRKGlCxImpFoQWMfvoAlYZBSEpOIUjqfh3GW9j5837aGASVJ_wPI9XLm)
- [Mermaid - Quy trình đặt phòng](https://mermaid.live/edit#pako:eNptzz1vgzAQBuC_gm4mCBzz5Q0V-jGERiEZWrFY4QpRi40MVG0J_70mUKZ68p2e984e4CwLBAao4gsvFa9zYehzypJDZlyvm40cjDg67h-f0weDGWeFvMN2Rmt_cfvoZZekx0y7ii9m7S3mkNyf0ngiJQpU87CZRvHuKf0H8qZR8hNbMKFUlwJYp3o0oUZV86mEYcrn0FVYYw5MXwuu3nPIxagzDRevUtZ_MSX7sgL2xj9aXfVNoZ-wfH0lKApUd7IXHTDHv40ANsAXsK3nW2FIbZdSEhLbcU34BkYDy_UI9WkYkMDZesQbTfi5LbWtwHfHX8m7bKw)
- [Mermaid - Full ERD](https://mermaid.live/edit#pako:eNq1Vt9vokAQ_lfIJr0n22hFUJJ78Kq9mlYxah_uYkK27BY2wi7ZXe6utf7vtyggv-zZNMcTzMzOfDPz8cEWuAxhYAHMRwR6HIZrqqnr4kL7mlza43K80L5ow8fV3cFy8A9H08lsqW0PT8lFqNQI0ub3R5OQnFBPwyEkQc0aQSF-M44cHwq_5n2Og8ChMMQ1j5BQxuJg3q3p4WZhP4zPRJP0WzMeK-Up5-PFdLJcTuzZZxIjLFxOIkkYreTfT9BpBA5RSKijqtzelx2cBbhoL_XvvIO4ejCzR5iHRAiFrjFtsvzPLdlnFP_f1edMXdj2VDH1m23fT2bfi2R9sIeT-Z2tjGe1IjF1AgbJ0YGwS0IYaB6BjsucJ1hd5geyC-YkU_HKsUm9g726pgwUh8on_QxWXno0XJ1TPTHFAvNqegQlliTEmutjd-MQetLFYvlPVOVjHKtb5EBZgXyzcj6AWuVrHMyev02ObFtIsVpt7BRf5sMf0_FsVSRKalqegeqJsQ1pBtU45hQTDFlM63MMsfQZepfw5412Mb59nI3OaSCCLyGm8hRQjp9jqgo0460CS80KlagJ3fEFHT8MV4k63U3my4aPydvb5SXbloTR0pREFCW-MUbJCfEoRg2BNWG0VPNuECtdrsv86TPqw0ilKMtiGp0z2Uq3IirvZRpXJL0KZVRCQkVRPhoDE55lnR11LA3Ns6myHuPkFYuaLGShGbULI81tWeMpeax0-6Kh3UKeEG6yZssbPOaBUcTZLyxAC3icIGBJHuMWCNVnByaPYM_TNZA-VnoPLHWLIN-swZru1JkI0p-MhdkxzmLPB9YzDIR6iqPkdUj_WnIrxxRhfpOwFli6vs8BrC34A6yuYV4ZA7Nv9Aemfm3qRgu8AKtjXl8ZRv-602v3TF0fdPVdC7zuq7avzF6n2zZ67YHRHei9bmf3F7CirmA)

