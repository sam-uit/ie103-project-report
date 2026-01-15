# HỆ THỐNG QUẢN LÝ ĐẶT PHÒNG



## 1. Tổng quan sản phẩm

### 1.1 Tên sản phẩm

**Booking Management System (BMS)**

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



## 2. Vấn đề cần giải quyết

Việc quản lý đặt phòng thủ công hoặc bằng bảng tính gặp nhiều hạn chế:

- Dễ xảy ra trùng lịch đặt phòng
- Khó theo dõi trạng thái phòng theo thời gian
- Dữ liệu khách hàng phân tán, khó truy vấn
- Khó tổng hợp báo cáo và thống kê doanh thu
- Dữ liệu có thể được sao lưu tự động và bảo mật



## 3. Mục tiêu sản phẩm

- Quản lý dữ liệu tập trung bằng cơ sở dữ liệu quan hệ
- Đảm bảo toàn vẹn và nhất quán dữ liệu
- Hỗ trợ truy vấn và thống kê hiệu quả bằng SQL
- Phù hợp để triển khai các ràng buộc, trigger và procedure, cursor



## 4. Stakeholders

| Vai trò  | Mô tả                                                           |
| -------- | --------------------------------------------------------------- |
| Admin    | Quản lý phòng, loại phòng, giá phòng                            |
| Staff    | Quản lý đặt phòng, xác nhận / hủy đặt, ghi nhận thanh toán      |
| End User | Tìm kiếm phòng, đặt phòng, hủy đặt phòng và theo dõi thanh toán |



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
- **Hệ thống khuyến mãi & mã giảm giá (Vouchers)**
- **Quản lý dịch vụ đi kèm (Add-on Services)** như ăn sáng, giặt ủi, đưa đón sân bay
- **Hệ thống đánh giá & phản hồi (Reviews & Ratings)** sau khi hoàn tất thanh toán

### 5.2 Out of Scope

- Tích hợp cổng thanh toán thực tế (VNPay, Stripe, PayPal)
- Hệ thống kế toán hoặc xuất hóa đơn điện tử
- Tối ưu hiệu năng cho quy mô lớn (high traffic)
- Tích hợp bên thứ ba (OTA như Booking, Agoda)



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

### US-07: Áp dụng mã giảm giá

Là **End User**, tôi muốn áp dụng mã giảm giá (voucher) khi đặt phòng để được giảm giá theo chương trình khuyến mãi.

### US-08: Sử dụng dịch vụ đi kèm

Là **End User**, tôi muốn đặt thêm các dịch vụ đi kèm (ăn sáng, giặt ủi, đưa đón sân bay) trong thời gian lưu trú để tiện lợi hơn.

### US-09: Đánh giá phòng

Là **End User**, tôi muốn đánh giá và để lại phản hồi về phòng sau khi hoàn tất thanh toán và trả phòng để chia sẻ trải nghiệm của mình.

### US-10: Xem đánh giá phòng

Là **End User**, tôi muốn xem điểm trung bình và các đánh giá của từng loại phòng để đưa ra quyết định đặt phòng phù hợp.



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
- **VOUCHERS** (Mã giảm giá)
- **DICHVU** (Dịch vụ đi kèm)
- **CT\_SUDUNG\_DV** (Chi tiết sử dụng dịch vụ)
- **REVIEWS** (Đánh giá & phản hồi)

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

VOUCHERS 1 --- n DATPHONG (Một voucher có thể được dùng cho nhiều đặt phòng)
DATPHONG 1 --- n CT_SUDUNG_DV (Một đặt phòng có thể sử dụng nhiều dịch vụ)
DICHVU 1 --- n CT_SUDUNG_DV (Một dịch vụ có thể được sử dụng nhiều lần)
USERS 1 --- n REVIEWS (Một user có thể đánh giá nhiều phòng)
PHONG 1 --- n REVIEWS (Một phòng có thể có nhiều đánh giá)
DATPHONG 1 --- 1 REVIEWS (Một đặt phòng có thể có một đánh giá)
```



## 8. Business Rules

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
- **Tính điểm trung bình (Rating) cho mỗi loại phòng**
- **Tổng hợp hóa đơn cuối cùng: Tiền phòng + Tiền dịch vụ - Giảm giá**
- **Danh sách voucher còn hiệu lực**

### 10.4 Trigger & Stored Procedure

- **Trigger kiểm tra mã giảm giá còn hạn và tự động tính lại tổng tiền trong PAYMENTS**
- **Stored Procedure tổng hợp hóa đơn cuối cùng (phòng + dịch vụ - giảm giá)**
- **View tính điểm trung bình Rating cho mỗi LOAIPHONG**



## 11. Non-Functional Requirements

- Đảm bảo toàn vẹn dữ liệu
- Truy vấn hiệu quả với dữ liệu mẫu
- Dễ dàng mở rộng thêm chức năng



## 12. Các tính năng mở rộng

### 12.1 Hệ thống Khuyến mãi & Mã giảm giá (Vouchers)

**Mục đích:** Tăng tính thực tế cho doanh thu và khuyến khích khách hàng đặt phòng.

**Thực thể VOUCHERS:**

- ID (Primary Key)
- Code (Mã voucher, UNIQUE)
- Discount_percent (Phần trăm giảm giá)
- Expiry_date (Ngày hết hạn)
- Min_booking_amount (Số tiền tối thiểu để áp dụng)
- Max_uses (Số lần sử dụng tối đa)
- Current_uses (Số lần đã sử dụng)
- Status (Active/Inactive)

**Nghiệp vụ:**

- Mỗi đơn đặt phòng (DATPHONG) có thể áp dụng một mã giảm giá
- Khi áp dụng voucher, hệ thống kiểm tra:
  - Mã còn hạn sử dụng (Expiry_date)
  - Chưa đạt giới hạn số lần dùng (Current_uses < Max_uses)
  - Tổng tiền đặt phòng đạt ngưỡng tối thiểu
- Tổng tiền thanh toán = Tiền phòng - (Tiền phòng × Discount_percent)

**SQL Challenge:**

- Sử dụng **Trigger** để:
  - Kiểm tra voucher còn hạn không
  - Tự động tính lại tổng tiền (amount) trong bảng PAYMENTS
  - Tăng Current_uses khi voucher được áp dụng thành công

### 12.2 Quản lý Dịch vụ đi kèm (Add-on Services)

**Mục đích:** Khách sạn không chỉ bán phòng mà còn cung cấp các dịch vụ bổ sung.

**Thực thể DICHVU:**

- ID (Primary Key)
- Ten_dich_vu (Tên dịch vụ: Ăn sáng, Giặt ủi, Đưa đón sân bay, Spa, v.v.)
- Don_gia (Đơn giá)
- Don_vi_tinh (Đơn vị: Suất, Lần, Giờ)
- Status (Active/Inactive)

**Thực thể CT_SUDUNG_DV (Chi tiết sử dụng dịch vụ):**

- ID (Primary Key)
- Datphong_id (Foreign Key → DATPHONG)
- Dichvu_id (Foreign Key → DICHVU)
- So_luong (Số lượng)
- Don_gia (Đơn giá tại thời điểm sử dụng)
- Thoi_diem_su_dung (Thời điểm gọi dịch vụ)
- Ghi_chu (Ghi chú)

**Nghiệp vụ:**

- Khách hàng có thể gọi dịch vụ bất cứ lúc nào trong thời gian lưu trú
- Mỗi lần gọi dịch vụ được ghi nhận vào CT_SUDUNG_DV
- Tổng tiền dịch vụ = SUM(So_luong × Don_gia)

**SQL Challenge:**

- Viết **Stored Procedure** để tổng hợp hóa đơn cuối cùng:
  - Tiền phòng (từ CT_DATPHONG)
  - Tiền dịch vụ (từ CT_SUDUNG_DV)
  - Giảm giá (từ VOUCHERS nếu có)
  - **Tổng cộng = Tiền phòng + Tiền dịch vụ - Giảm giá**

### 12.3 Hệ thống Đánh giá & Phản hồi (Reviews & Ratings)

**Mục đích:** Thu thập phản hồi từ khách hàng để cải thiện chất lượng dịch vụ và hỗ trợ khách hàng khác đưa ra quyết định.

**Thực thể REVIEWS:**

- ID (Primary Key)
- User_id (Foreign Key → USERS)
- Phong_id (Foreign Key → PHONG)
- Datphong_id (Foreign Key → DATPHONG, UNIQUE)
- So_sao (Số sao: 1-5)
- Binh_luan (Nội dung đánh giá)
- Ngay_danh_gia (Ngày đánh giá)
- Status (Pending/Approved/Rejected)

**Nghiệp vụ:**

- Chỉ những khách hàng đã có trạng thái thanh toán **PAID** và đã trả phòng mới được đánh giá
- Mỗi đặt phòng chỉ được đánh giá một lần (UNIQUE constraint trên Datphong_id)
- Số sao phải từ 1 đến 5 (CHECK constraint)
- Admin có thể duyệt hoặc từ chối đánh giá



## 13. Tiêu chí đánh giá đồ án

- Thiết kế CSDL đạt chuẩn (3NF)
- Áp dụng đúng JOIN, SUBQUERY, GROUP BY
- Có sử dụng constraint và trigger, cursor, stored procedures
- Truy vấn phản ánh đúng nghiệp vụ



## 14. Bổ sung: Quản lý người dùng, Thanh toán & ERD

### 14.1 Quản lý người dùng & phân quyền

- Hệ thống phân tách rõ **Admins** (người dùng nội bộ) và **End Users** (người dùng cuối)
- Admins áp dụng mô hình **RBAC (Role-Based Access Control)**
- Một Admin có thể có nhiều Role
- Mỗi Role gồm nhiều Permission (CRUD phòng, duyệt hoàn tiền, xem báo cáo...)



### 14.2 Thanh toán trực tuyến (mô phỏng)

- End User thực hiện thanh toán khi đặt phòng
- Không tích hợp cổng thanh toán thực tế
- Mỗi đơn đặt phòng có thể có nhiều giao dịch thanh toán (mở rộng)
- Trạng thái thanh toán:
  - PENDING
  - SUCCESS
  - FAILED
  - CANCELLED



### 14.3 Hoàn tiền & Hủy giao dịch

- End User được yêu cầu hoàn tiền nếu hủy trước **24 giờ** so với giờ nhận phòng
- Admin duyệt hoàn tiền
- Hỗ trợ hoàn tiền toàn phần hoặc một phần
- Trạng thái hoàn tiền:
  - REQUESTED
  - APPROVED
  - REJECTED
  - COMPLETED



### 14.4 ERD – Text Definition

#### Admins & Authorization

```text
admins
------
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
--
id (PK)
code
name
description
```

```text
permissions
--------
id (PK)
code
description
```

```text
admin_roles
-----------
admin_id (FK -> admins.id)
role_id (FK -> roles.id)
```

```text
role_permissions
-------------
role_id (FK -> roles.id)
permission_id (FK -> permissions.id)
```



#### End Users

```text
users
--
id (PK)
email
phone
password_hash
full_name
status
created_at
updated_at
```



#### Payments

```text
payments
-----
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



#### Refunds

```text
refunds
----
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



#### Vouchers

```text
vouchers
-----
id (PK)
code (UNIQUE)
discount_percent
expiry_date
min_booking_amount
max_uses
current_uses
status
created_at
updated_at
```



#### Services & Service Usage

```text
dichvu
---
id (PK)
ten_dich_vu
don_gia
don_vi_tinh
status
created_at
updated_at
```

```text
ct_sudung_dv
---------
id (PK)
datphong_id (FK -> datphong.id)
dichvu_id (FK -> dichvu.id)
so_luong
don_gia
thoi_diem_su_dung
ghi_chu
created_at
```



#### Reviews & Ratings

```text
reviews
----
id (PK)
user_id (FK -> users.id)
phong_id (FK -> phong.id)
datphong_id (FK -> datphong.id, UNIQUE)
so_sao (CHECK: 1-5)
binh_luan
ngay_danh_gia
status
created_at
updated_at
```



### 14.5 ERD – Mermaid Diagram (Flow-based)

#### 14.5.1 Phân quyền admin

```
erDiagram
    ADMINS ||--o{ ADMIN_ROLES : has
    ROLES ||--o{ ADMIN_ROLES : assigned
    ROLES ||--o{ ROLE_PERMISSIONS : includes
    PERMISSIONS ||--o{ ROLE_PERMISSIONS : grants
```


#### 14.5.2 Quy trình đặt phòng

```
erDiagram
    USERS ||--o{ DATPHONG : creates
    DATPHONG ||--o{ PAYMENTS : has
    PAYMENTS ||--o{ REFUNDS : generates

    ADMINS ||--o{ REFUNDS : approves
```



#### 14.5.3 Vouchers, Services & Reviews

```
erDiagram
    DATPHONG ||--o| VOUCHERS : applies
    DATPHONG ||--o{ CT_SUDUNG_DV : uses
    DICHVU ||--o{ CT_SUDUNG_DV : provided
    
    USERS ||--o{ REVIEWS : writes
    PHONG ||--o{ REVIEWS : receives
    DATPHONG ||--o| REVIEWS : generates
```



### 14.6 ERD tổng thể hệ thống (User, Booking, Payment, Admin & Authorization)

```
erDiagram
    %% ===== NGƯỜI DÙNG & PHÂN QUYỀN =====
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

    %% ===== PHÒNG & ĐẶT PHÒNG =====
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

    %% ===== THANH TOÁN =====
    PAYMENTS {
        int id PK
        int booking_id FK
        int user_id FK
        decimal so_tien
        string phuong_thuc
        string trang_thai
        datetime created_at
    }

    REFUNDS {
        int id PK
        int payment_id FK
        decimal so_tien_hoan
        string trang_thai
        string ly_do
    }

    %% ===== MÃ GIẢM GIÁ =====
    VOUCHERS {
        int id PK
        string ma_code
        decimal phan_tram_giam
        date ngay_het_han
        decimal so_tien_toi_thieu
        int so_lan_toi_da
        int so_lan_da_dung
        string trang_thai
    }

    %% ===== DỊCH VỤ =====
    DICHVU {
        int id PK
        string ten_dich_vu
        decimal don_gia
        string don_vi_tinh
        string status
    }

    CT_SUDUNG_DV {
        int id PK
        int datphong_id FK
        int dichvu_id FK
        int so_luong
        decimal don_gia
        datetime thoi_diem_su_dung
        string ghi_chu
    }

    %% ===== ĐÁNH GIÁ =====
    REVIEWS {
        int id PK
        int user_id FK
        int phong_id FK
        int datphong_id FK
        int so_sao
        string binh_luan
        date ngay_danh_gia
        string status
    }

    %% ===== QUAN HỆ =====
    ADMINS ||--o{ ADMIN_ROLES : có
    ROLES ||--o{ ADMIN_ROLES : được_gán
    ROLES ||--o{ ROLE_PERMISSIONS : bao_gồm
    PERMISSIONS ||--o{ ROLE_PERMISSIONS : cấp_quyền

    USERS ||--o{ DATPHONG : tạo
    DATPHONG ||--o{ CT_DATPHONG : chứa
    PHONG ||--o{ CT_DATPHONG : được_đặt
    LOAIPHONG ||--o{ PHONG : phân_loại

    DATPHONG ||--o{ PAYMENTS : có
    PAYMENTS ||--o{ REFUNDS : hoàn_tiền
    USERS ||--o{ PAYMENTS : thực_hiện
    ADMINS ||--o{ REFUNDS : duyệt

    DATPHONG ||--o| VOUCHERS : áp_dụng
    DATPHONG ||--o{ CT_SUDUNG_DV : sử_dụng
    DICHVU ||--o{ CT_SUDUNG_DV : cung_cấp

    USERS ||--o{ REVIEWS : viết
    PHONG ||--o{ REVIEWS : nhận
    DATPHONG ||--o| REVIEWS : tạo_ra
```



### 14.7 Ghi chú triển khai SQL

- RBAC triển khai bằng bảng trung gian (many-to-many)
- Có thể dùng TRIGGER để:
  - Tự động cập nhật trạng thái thanh toán / hoàn tiền
  - Kiểm tra và áp dụng voucher khi đặt phòng
  - Kiểm tra điều kiện đánh giá (đã thanh toán và trả phòng)
- Stored Procedure để tổng hợp hóa đơn (phòng + dịch vụ - giảm giá)
- View để tính điểm trung bình rating cho mỗi loại phòng
- ERD phù hợp triển khai
- Dễ mở rộng cho đồ án nâng cao

### 14.8 Links
- [Mermaid - Phân quyền admin](https://mermaid.live/edit#pako:eNp1UMtugzAQ_BW0Z4JIeNj4VjU5IOVRhVtlKbLiLaDEdmSw1Jbw74WQVjmke9qZnZldbQdHIxEYoF3WorRCce0N9bLc5NvCu15nM9NN6LDfrVeFx7xKNJNoIp5qRNPUpUb5RDiCw9tqv8mLIt9tR3Wtj2cn8R77OPvfM9yq2wZ8KG0tgbXWoQ8KrRIjhG7M4tBWqJADG1op7IkD1_3guQj9boz6tVnjygrYhzg3A3IXKVq8v-OPtagl2lfjdAssu0UA6-ATWJQkQRKGlCxImpFoQWMfvoAlYZBSEpOIUjqfh3GW9j5837aGASVJ_wPI9XLm)
- [Mermaid - Quy trình đặt phòng](https://mermaid.live/edit#pako:eNptzz1vgzAQBuC_gm4mCBzz5Q0V-jGERiEZWrFY4QpRi40MVG0J_70mUKZ68p2e984e4CwLBAao4gsvFa9zYehzypJDZlyvm40cjDg67h-f0weDGWeFvMN2Rmt_cfvoZZekx0y7ii9m7S3mkNyf0ngiJQpU87CZRvHuKf0H8qZR8hNbMKFUlwJYp3o0oUZV86mEYcrn0FVYYw5MXwuu3nPIxagzDRevUtZ_MSX7sgL2xj9aXfVNoZ-wfH0lKApUd7IXHTDHv40ANsAXsK3nW2FIbZdSEhLbcU34BkYDy_UI9WkYkMDZesQbTfi5LbWtwHfHX8m7bKw)
- [Mermaid - Full ERD](https://mermaid.live/view#pako:eNq1V01v2zYY_iuEgO6UBpnjJI2AHQzbjY3WsuuvoYMBgpFYkYhFahKVzUsCNB2wAju122nADku3HnYotmHABliHHRz0f-ifjLItW7Loxl06XSy9X3zeT74-00xuYU3XsFehyPaQM2BAPnfugE_iBxhHb3-Lwh_roDL5wTgCH4FWbfLMAI96j6PwqTETmqmUKo260QFns6_4oUwAaoHWgyXJFx5lNsAOosMc1UW-_wX3LEiQT3LcJ8FwCBlycI7jCyQCf0a-GLDZS7v5sLohmjgEOeLypIXJVrXdqHc69aZxG8MW9k2PuoJytmJ_GkGoBI4shzIoT7n_IMvw-BCn6Rn_4TsQryomdBd7DvV9iU5ptteptm-XZMIZ_n9TvyheWavfTYv2-kU0_qubfKeK9mGzVG_VmpK4kUsCMzjkiC4ZFjapg4bApgiaHB6j1aS-h3Wfwzg6dlY2Pm9GX01XAspDkidIAmtxdKXU3eT0mBT42Fs1byGBBXUwMAk2TyBla1k8EDeiyqp5WL5aEIkVyOUufA_U0p4yMNM6VjGSbFmyumXG1tVNt1YyaqDbnFxmJlyr9LhRNbqdDZAdc35C1cCUoZ7jkhUgKGaKpgn4NJqB-YEC3a7e7xmVTVxx0cjBTNwAGRKO2EbY5qzhCFp8XQIak6_BUT0av2rIn8llOgn9Zq9c23gGOXFXpodwAtsliEEJz4nrwMlGDjAbjSDBQk4jtt5jwal0jeIgC0Syh2jGtZCSZSFoBek2v6mRF3GpROG35RroR-Ev6ZhU6uVav7f5CLOoSeBpcENfpO8sST-V3lJGNhvBso87vUrPOIKV_i0bOQZ7Gqg4cTiDzLxc68eiIQSJ80KxA_1AnQWbUGiSYF0Krl_IqVDLlWW72q9XP-38x1G7dmDdFBwZAh_xnA_HMlEyNoipCttCkqnK8rsv00e9kgFqUfiNYuk7P797l59lFhgdmJM_06uYUub65dvfo_BnE9qTK6aQzm0xOjhGHNpR-L2TX8rWK5nR-LULPw9GUXjJsrvMXGlx7ehAROMrvnKFzqXS95O0SqLwV5S-55ViCyevX0bjv8Xq5jHXSaRdMnkVbxkSBM3d5IlschOlorygJVGYT3gdED75SQ4kOvM953nKmJAO_WFCIkWfM1WGl0atOJbPhRrh-XJM62By5UIrCl8nvaaI6XJW6MCPwjdZ-dl0U0ubsoXhNLvKrCZtqYNTGo3_EYpcLUUYicZv1vizlJpWB_SQtqXZHrU0XXgB3tIcuTej-FObjoCBJgiWC6umy1cLeScDbcAupI6L2GecO4maxwObaPoTNPTlV-DGbTr_J7YQwczCXpkHTGj63tSCpp9pX2r67uH2_r2DvY8PioV7O_t7O7tb2kjTC8XC9m7h8GCvUCwW9w93DwsXW9pX0zN3tqX4xb_a0UiE)

