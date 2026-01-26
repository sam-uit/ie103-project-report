# Cài Đặt - Triển Khai

Trong chương này, Nhóm 02 sẽ trình bày chi tiết về việc cài đặt mô hình dữ liệu (mức vật lý) và các chức năng quản lý thông tin trên hệ quản trị cơ sở dữ liệu Microsoft SQL Server.

## Môi Trường Cài Đặt

- Hệ quản trị cơ sở dữ liệu (DBMS) được sử dụng là Microsoft SQL Server, phiên bản 2019.
- Công cụ quản lý: SQL Server Management Studio (SSMS), phiên bản 18.12.1.
- Công cụ bổ sung: Azure Data Studio, phiên bản 1.52.0.

## Cài Đặt Mô Hình Dữ Liệu (Mức Vật Lý)

Mô Hình Dữ Liệu, hay Từ Điển Dữ Liệu, trình bày chi tiết thành phần và cấu trúc của cơ sở dữ liệu, bao gồm các bảng, thuộc tính, loại dữ liệu, quan hệ giữa các bảng, và các ràng buộc toàn vẹn.

### A. Nhóm Bảng Quản Trị & Hệ Thống

#### 1. ADMINS

- Lưu trữ tài khoản quản trị viên và nhân viên.

| **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính tự tăng. |
| `email` | `NVARCHAR(255)` | `NOT NULL`, `UNIQUE` | Email đăng nhập. |
| `password_hash` | `NVARCHAR(255)` | `NOT NULL` | Mật khẩu (Hash). |
| `full_name` | `NVARCHAR(255)` | `NULL` | Họ tên đầy đủ. |
| `status` | `NVARCHAR(50)` | `DEFAULT 'ACTIVE'` | Trạng thái tài khoản. |
| `created_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày tạo. |
| `updated_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày cập nhật. |
| *CHECK* |  | `status IN ('ACTIVE', 'INACTIVE')` | Chỉ nhận giá trị quy định. |

```{=typst}
#figure(
  table(
    columns: (20%, 20%, 30%, 30%),
    align: (left, left, left, left),
    [#strong[Thuộc Tính]], [#strong[Kiểu]], [#strong[Ràng Buộc]], [#strong[Mô Tả]], [`id`], [`INT`], [`PK`, `IDENTITY`], [Khóa chính tự tăng.], [`email`], [`NVARCHAR(255)`], [`NOT NULL`, `UNIQUE`], [Email đăng nhập.], [`password_hash`], [`NVARCHAR(255)`], [`NOT NULL`], [Mật khẩu (Hash).], [`full_name`], [`NVARCHAR(255)`], [`NULL`], [Họ tên đầy đủ.], [`status`], [`NVARCHAR(50)`], [`DEFAULT 'ACTIVE'`], [Trạng thái tài khoản.], [`created_at`], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [`updated_at`], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày cập nhật.], [#emph[CHECK]], [], [`status IN ('ACTIVE', 'INACTIVE')`], [Chỉ nhận giá trị quy định.]
  ),
  caption: [
    Mô Hình Mức Vật Lý: ADMINS
  ],
)
```

#### 2. ROLES

- Định nghĩa các vai trò (nhóm quyền).

| **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `code` | `NVARCHAR(50)` | `NOT NULL`, `UNIQUE` | Mã vai trò (VD: ADMIN). |
| `name` | `NVARCHAR(255)` | `NOT NULL` | Tên hiển thị. |
| `description` | `NVARCHAR(500)` | `NULL` | Mô tả vai trò. |

#### 3. PERMISSIONS

- Danh sách các quyền hạn chức năng.

| **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `code` | `NVARCHAR(100)` | `NOT NULL`, `UNIQUE` | Mã quyền (VD: USER_READ). |
| `description` | `NVARCHAR(255)` | `NULL` | Mô tả quyền hạn. |

#### 4. ADMIN_ROLES

- Bảng trung gian phân quyền cho Admin.

| **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `admin_id` | `INT` | `PK`, `FK` (ADMINS) | Khóa ngoại + Khóa chính. |
| `role_id` | `INT` | `PK`, `FK` (ROLES) | Khóa ngoại + Khóa chính. |
| *FK Rule* |  | `ON DELETE CASCADE` | Xóa Admin/Role tự động xóa dòng này. |

#### 5. ROLE_PERMISSIONS

- Bảng trung gian gán quyền cho Role.

| **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `role_id` | `INT` | `PK`, `FK` (ROLES) | Khóa ngoại + Khóa chính. |
| `permission_id` | `INT` | `PK`, `FK` (PERMISSIONS) | Khóa ngoại + Khóa chính. |
| *FK Rule* |  | `ON DELETE CASCADE` | Xóa Role/Permission tự động xóa dòng này. |

### B. Nhóm Bảng Nghiệp Vụ Chính

#### 6. USERS

- Thông tin người dùng cuối (Khách hàng).

| **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính tự tăng. |
| `email` | `NVARCHAR(255)` | `NOT NULL`, `UNIQUE` | Email đăng nhập. |
| `phone` | `NVARCHAR(20)` | `NULL` | Số điện thoại. |
| `password_hash` | `NVARCHAR(255)` | `NOT NULL` | Mật khẩu (Hash). |
| `full_name` | `NVARCHAR(255)` | `NULL` | Họ tên khách hàng. |
| `status` | `NVARCHAR(50)` | `DEFAULT 'ACTIVE'` | Trạng thái tài khoản. |
| `created_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày đăng ký. |
| `updated_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày cập nhật. |
| *CHECK* |  | `status IN ('ACTIVE', 'INACTIVE')` | Chỉ nhận giá trị quy định. |

#### 7. LOAIPHONG

- Danh mục loại phòng.

| **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `ten_loai` | `NVARCHAR(100)` | `NOT NULL` | Tên loại (VD: Deluxe). |
| `gia_co_ban` | `DECIMAL(18,2)` | `NOT NULL` | Giá niêm yết. |
| `mo_ta` | `NVARCHAR(500)` | `NULL` | Mô tả tiện nghi. |
| `suc_chua` | `INT` | `DEFAULT 2` | Số người tối đa. |
| *CHECK* |  | `gia_co_ban > 0` | Chỉ nhận giá trị quy định. |
| *CHECK* |  | `suc_chua > 0` | Chỉ nhận giá trị quy định. |

#### 8. PHONG

- Danh sách phòng vật lý.

| **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `so_phong` | `NVARCHAR(50)` | `NOT NULL`, `UNIQUE` | Số phòng (VD: 101). |
| `loai_phong_id` | `INT` | `FK` (LOAIPHONG), `NOT NULL` | Loại phòng tương ứng. |
| `trang_thai` | `NVARCHAR(50)` | `DEFAULT 'AVAILABLE'` | Trạng thái phòng. |
| *CHECK* |  | `trang_thai IN ('AVAILABLE', 'OCCUPIED', 'MAINTENANCE', 'RESERVED')` | Chỉ nhận giá trị quy định. |

#### 9. DICHVU

- Danh mục dịch vụ đi kèm.

| **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `ten_dich_vu` | `NVARCHAR(255)` | `NOT NULL` | Tên dịch vụ. |
| `don_gia` | `DECIMAL(18,2)` | `NOT NULL` | Giá dịch vụ. |
| `don_vi_tinh` | `NVARCHAR(50)` | `NOT NULL`, `DEFAULT N'Lần'` | Đơn vị tính. |
| `trang_thai` | `NVARCHAR(50)` | `DEFAULT 'ACTIVE'` | Trạng thái. |
| `created_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày tạo. |
| `updated_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày cập nhật. |
| *CHECK* |  | `don_gia > 0` | Đơn giá phải dương. |
| *CHECK* |  | `trang_thai IN ('ACTIVE', 'INACTIVE')` | Ràng buộc trạng thái. |

#### 10. VOUCHERS

- Mã giảm giá và khuyến mãi.

| **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `ma_code` | `NVARCHAR(50)` | `NOT NULL`, `UNIQUE` | Mã Voucher (VD: TET2025). |
| `phan_tram_giam` | `DECIMAL(5,2)` | `NOT NULL` | Phần trăm giảm. |
| `ngay_het_han` | `DATETIME` | `NOT NULL` | Ngày hết hạn. |
| `so_tien_toi_thieu` | `DECIMAL(18,2)` | `NOT NULL` | Số tiền tối thiểu. |
| `so_lan_toi_da` | `INT` | `NOT NULL`, `DEFAULT 100` | Số lần tối đa. |
| `so_lan_da_dung` | `INT` | `DEFAULT 0` | Số lần đã dùng. |
| `trang_thai` | `NVARCHAR(50)` | `DEFAULT 'ACTIVE'` | Trạng thái. |
| `created_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày tạo. |
| `updated_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày cập nhật. |
| *CHECK* |  | `phan_tram_giam >= 0` | Phần trăm giảm phải dương. |
| *CHECK* |  | `so_tien_toi_thieu >= 0` | Số tiền tối thiểu phải dương. |
| *CHECK* |  | `so_lan_toi_da > 0` | Số lần tối đa phải dương. |
| *CHECK* |  | `so_lan_da_dung >= 0` | Số lần đã dùng phải dương. |
| *CHECK* |  | `so_lan_da_dung <= so_lan_toi_da` | Số lần đã dùng phải nhỏ hơn hoặc bằng số lần tối đa. |
| *CHECK* |  | `trang_thai IN ('ACTIVE', 'INACTIVE')` | Ràng buộc trạng thái. |

### C. Nhóm Bảng Giao Dịch & Chi Tiết

#### 11. DATPHONG

- Đơn đặt phòng.

| **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `user_id` | `INT` | `FK` (USERS), `NOT NULL` | Khách đặt phòng. |
| `voucher_id` | `INT` | `FK` (VOUCHERS), `NULL` | Voucher áp dụng (nếu có). |
| `ngay_dat` | `DATETIME` | `DEFAULT GETDATE()` | Thời gian đặt. |
| `ngay_checkin` | `DATE` | `NOT NULL` | Ngày nhận phòng. |
| `ngay_checkout` | `DATE` | `NOT NULL` | Ngày trả phòng. |
| `tong_tien` | `DECIMAL(18,2)` | `NOT NULL` | Tổng tiền đơn. |
| `trang_thai` | `NVARCHAR(50)` | `DEFAULT 'PENDING'` | Trạng thái đơn. |
| `created_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày tạo. |
| `updated_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày cập nhật. |
| *CHECK* |  | `trang_thai IN ('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED')` | Ràng buộc trạng thái. |

#### 12. CT_DATPHONG

- Chi tiết phòng trong đơn đặt.

| **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `datphong_id` | `INT` | `FK` (DATPHONG), `NOT NULL` | Thuộc đơn đặt phòng nào. |
| `phong_id` | `INT` | `FK` (PHONG), `NOT NULL` | Phòng nào. |
| `gia_tien` | `DECIMAL(18,2)` | `NOT NULL` | Giá phòng tại thời điểm đặt. |
| `created_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày tạo. |
| *FK Rule* |  | `datphong_id ON DELETE CASCADE` | Xóa đơn xóa luôn chi tiết. |

#### 13. CT_SUDUNG_DV

- Chi tiết sử dụng dịch vụ.

| **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `datphong_id` | `INT` | `FK` (DATPHONG), `NOT NULL` | Thuộc đơn đặt phòng nào. |
| `dichvu_id` | `INT` | `FK` (DICHVU), `NOT NULL` | Dịch vụ nào. |
| `so_luong` | `INT` | `DEFAULT 1`, `NOT NULL` | Số lượng. |
| `don_gia` | `DECIMAL(18,2)` | `NOT NULL` | Đơn giá tại thời điểm dùng. |
| `thoi_diem_su_dung` | `DATETIME` | `DEFAULT GETDATE()` | Thời gian order. |
| `ghi_chu` | `NVARCHAR(500)` | `NULL` | Ghi chú thêm. |
| `created_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày tạo. |
| *CHECK* |  | `so_luong > 0`, `don_gia > 0` | Số lượng và giá phải dương. |

#### 14. PAYMENTS

- Giao dịch thanh toán.

| **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `datphong_id` | `INT` | `FK` (DATPHONG), `NOT NULL` | Thanh toán cho đơn nào. |
| `user_id` | `INT` | `FK` (USERS), `NOT NULL` | Người thanh toán. |
| `so_tien` | `DECIMAL(18,2)` | `NOT NULL` | Số tiền giao dịch. |
| `phuong_thuc` | `NVARCHAR(50)` | `NOT NULL` | Cách trả (`CASH`, `BANK`...). |
| `ma_giao_dich` | `NVARCHAR(100)` | `UNIQUE`, `NULL` | Ref ID (nếu CK online). |
| `ngay_thanh_toan` | `DATETIME` | `DEFAULT GETDATE()` | Thời điểm trả. |
| `trang_thai` | `NVARCHAR(50)` | `DEFAULT 'PENDING'` | Trạng thái giao dịch. |
| `created_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày tạo. |
| `updated_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày cập nhật. |
| *CHECK* |  | `so_tien > 0` | Tiền phải dương. |
| *CHECK* |  | `trang_thai IN ('PENDING', 'SUCCESS', 'FAILED')` | Ràng buộc trạng thái. |

#### 15. REFUNDS

- Yêu cầu hoàn tiền.

| **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| payment_id | `INT` | `FK` (PAYMENTS), `NOT NULL` | Hoàn tiền cho giao dịch nào. |
| user_id | `INT` | `FK` (USERS), `NOT NULL` | Người yêu cầu. |
| admin_id | `INT` | `FK` (ADMINS), `NULL` | Người duyệt. |
| so_tien | `DECIMAL(18,2)` | `NOT NULL` | Số tiền hoàn. |
| ly_do | `NVARCHAR(500)` | `NULL` | Lý do hoàn tiền. |
| ngay_hoan_tien | `DATETIME` | `NULL` | Thời điểm hoàn thành. |
| trang_thai | `NVARCHAR(50)` | `DEFAULT 'PENDING'` | Trạng thái. |
| created_at | `DATETIME` | `DEFAULT GETDATE()` | Ngày tạo. |
| updated_at | `DATETIME` | `DEFAULT GETDATE()` | Ngày cập nhật. |
| *CHECK* |  | `trang_thai IN ('PENDING', 'APPROVED', 'REJECTED')` | Ràng buộc trạng thái. |

#### 16. REVIEWS

- Đánh giá từ khách hàng.

| **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `user_id` | `INT` | `FK` (USERS), `NOT NULL` | Người đánh giá. |
| `phong_id` | `INT` | `FK` (PHONG), `NOT NULL` | Phòng được đánh giá. |
| `datphong_id` | `INT` | `FK` (DATPHONG), `UNIQUE` | Thuộc đơn nào (Duy nhất 1-1). |
| `so_sao` | `INT` | `NOT NULL` | Điểm sao (1-5). |
| `binh_luan` | `NVARCHAR(1000)` | `NULL` | Nội dung text. |
| `ngay_danh_gia` | `DATE` | `DEFAULT GETDATE()` | Ngày đánh giá. |
| `trang_thai` | `NVARCHAR(50)` | `DEFAULT 'VISIBLE'` | Trạng thái hiển thị. |
| `created_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày tạo. |
| `updated_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày cập nhật. |
| *CHECK* |  | `so_sao BETWEEN 1 AND 5` | Giới hạn 1 đến 5 sao. |
| *CHECK* |  | `trang_thai IN ('VISIBLE', 'HIDDEN')` | Ràng buộc hiển thị. |

## Khởi Tạo Cơ Sở Dữ Liệu

## Dữ Liệu Mẫu

### Phân Quyền

#### ROLES

```sql
INSERT INTO ROLES (code, name, description) VALUES
('SUPER_ADMIN', N'Quản trị viên cấp cao', N'Toàn quyền quản lý hệ thống'),
('ADMIN', N'Quản trị viên', N'Quản lý phòng và đặt phòng'),
('STAFF', N'Nhân viên', N'Xử lý đặt phòng và thanh toán'),
('ACCOUNTANT', N'Kế toán', N'Quản lý thanh toán và doanh thu'),
('RECEPTIONIST', N'Lễ tân', N'Tiếp nhận khách và check-in/out'),
('MANAGER', N'Quản lý', N'Giám sát hoạt động'),
('MAINTENANCE', N'Bảo trì', N'Quản lý bảo trì phòng'),
('MARKETING', N'Marketing', N'Quản lý khuyến mãi và voucher'),
('SUPPORT', N'Hỗ trợ', N'Hỗ trợ khách hàng'),
('ANALYST', N'Phân tích', N'Xem báo cáo và thống kê');

GO
```