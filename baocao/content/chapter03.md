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

<!-- | **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính tự tăng. |
| `email` | `NVARCHAR(255)` | `NOT NULL`, `UNIQUE` | Email đăng nhập. |
| `password_hash` | `NVARCHAR(255)` | `NOT NULL` | Mật khẩu (Hash). |
| `full_name` | `NVARCHAR(255)` | `NULL` | Họ tên đầy đủ. |
| `status` | `NVARCHAR(50)` | `DEFAULT 'ACTIVE'` | Trạng thái tài khoản. |
| `created_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày tạo. |
| `updated_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày cập nhật. |
| *CHECK* |  | `status IN ('ACTIVE', 'INACTIVE')` | Chỉ nhận giá trị quy định. | -->

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

<!-- | **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `code` | `NVARCHAR(50)` | `NOT NULL`, `UNIQUE` | Mã vai trò (VD: ADMIN). |
| `name` | `NVARCHAR(255)` | `NOT NULL` | Tên hiển thị. |
| `description` | `NVARCHAR(500)` | `NULL` | Mô tả vai trò. | -->

```{=typst}
#figure(
  table(
    columns: (20%, 20%, 30%, 30%),
    align: (left, left, left, left),
    [#strong[Thuộc Tính]], [#strong[Kiểu]], [#strong[Ràng Buộc]], [#strong[Mô Tả]], [`id`], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [`code`], [`NVARCHAR(50)`], [`NOT NULL`, `UNIQUE`], [Mã vai trò (VD: ADMIN).], [`name`], [`NVARCHAR(255)`], [`NOT NULL`], [Tên hiển thị.], [`description`], [`NVARCHAR(500)`], [`NULL`], [Mô tả vai trò.]
  ),
  caption: [
    Mô Hình Mức Vật Lý: ROLES
  ],
)
```

#### 3. PERMISSIONS

- Danh sách các quyền hạn chức năng.

<!-- | **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `code` | `NVARCHAR(100)` | `NOT NULL`, `UNIQUE` | Mã quyền (VD: USER_READ). |
| `description` | `NVARCHAR(255)` | `NULL` | Mô tả quyền hạn. | -->

```{=typst}
#figure(
  table(
    columns: (20%, 20%, 30%, 30%),
    align: (left, left, left, left),
    [#strong[Thuộc Tính]], [#strong[Kiểu]], [#strong[Ràng Buộc]], [#strong[Mô Tả]], [`id`], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [`code`], [`NVARCHAR(100)`], [`NOT NULL`, `UNIQUE`], [Mã quyền (VD: USER\_READ).], [`description`], [`NVARCHAR(255)`], [`NULL`], [Mô tả quyền hạn.]
  ),
  caption: [
    Mô Hình Mức Vật Lý: PERMISSIONS
  ],
)
```

#### 4. ADMIN_ROLES

- Bảng trung gian phân quyền cho Admin.

<!-- | **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `admin_id` | `INT` | `PK`, `FK` (ADMINS) | Khóa ngoại + Khóa chính. |
| `role_id` | `INT` | `PK`, `FK` (ROLES) | Khóa ngoại + Khóa chính. |
| *FK Rule* |  | `ON DELETE CASCADE` | Xóa Admin/Role tự động xóa dòng này. | -->

```{=typst}
#figure(
  table(
    columns: (20%, 10%, 25%, 45%),
    align: (left, left, left, left),
    [#strong[Thuộc Tính]], [#strong[Kiểu]], [#strong[Ràng Buộc]], [#strong[Mô Tả]], [`admin_id`], [`INT`], [`PK`, `FK` (ADMINS)], [Khóa ngoại + Khóa chính.], [`role_id`], [`INT`], [`PK`, `FK` (ROLES)], [Khóa ngoại + Khóa chính.], [#emph[FK Rule]], [], [`ON DELETE CASCADE`], [Xóa Admin/Role tự động xóa dòng này.]
  ),
  caption: [
    Mô Hình Mức Vật Lý: ADMIN_ROLES
  ],
)
```

#### 5. ROLE_PERMISSIONS

- Bảng trung gian gán quyền cho Role.

<!-- | **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `role_id` | `INT` | `PK`, `FK` (ROLES) | Khóa ngoại + Khóa chính. |
| `permission_id` | `INT` | `PK`, `FK` (PERMISSIONS) | Khóa ngoại + Khóa chính. |
| *FK Rule* |  | `ON DELETE CASCADE` | Xóa Role/Permission tự động xóa dòng này. | -->

```{=typst}
#figure(
  table(
    columns: (20%, 10%, 25%, 45%),
    align: (left, left, left, left),
    [#strong[Thuộc Tính]], [#strong[Kiểu]], [#strong[Ràng Buộc]], [#strong[Mô Tả]], [`role_id`], [`INT`], [`PK`, `FK` (ROLES)], [Khóa ngoại + Khóa chính.], [`permission_id`], [`INT`], [`PK`, `FK` (PERMISSIONS)], [Khóa ngoại + Khóa chính.], [#emph[FK Rule]], [], [`ON DELETE CASCADE`], [Xóa Role/Permission tự động xóa dòng này.]
  ),
  caption: [
    Mô Hình Mức Vật Lý: ROLE_PERMISSIONS
  ],
)
```

### B. Nhóm Bảng Nghiệp Vụ Chính

#### 6. USERS

- Thông tin người dùng cuối (Khách hàng).

<!-- | **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính tự tăng. |
| `email` | `NVARCHAR(255)` | `NOT NULL`, `UNIQUE` | Email đăng nhập. |
| `phone` | `NVARCHAR(20)` | `NULL` | Số điện thoại. |
| `password_hash` | `NVARCHAR(255)` | `NOT NULL` | Mật khẩu (Hash). |
| `full_name` | `NVARCHAR(255)` | `NULL` | Họ tên khách hàng. |
| `status` | `NVARCHAR(50)` | `DEFAULT 'ACTIVE'` | Trạng thái tài khoản. |
| `created_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày đăng ký. |
| `updated_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày cập nhật. |
| *CHECK* |  | `status IN ('ACTIVE', 'INACTIVE')` | Chỉ nhận giá trị quy định. | -->

```{=typst}
#figure(
  table(
    columns: (20%, 20%, 30%, 30%),
    align: (left, left, left, left),
    [#strong[Thuộc Tính]], [#strong[Kiểu]], [#strong[Ràng Buộc]], [#strong[Mô Tả]], [`id`], [`INT`], [`PK`, `IDENTITY`], [Khóa chính tự tăng.], [`email`], [`NVARCHAR(255)`], [`NOT NULL`, `UNIQUE`], [Email đăng nhập.], [`phone`], [`NVARCHAR(20)`], [`NULL`], [Số điện thoại.], [`password_hash`], [`NVARCHAR(255)`], [`NOT NULL`], [Mật khẩu (Hash).], [`full_name`], [`NVARCHAR(255)`], [`NULL`], [Họ tên khách hàng.], [`status`], [`NVARCHAR(50)`], [`DEFAULT 'ACTIVE'`], [Trạng thái tài khoản.], [`created_at`], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày đăng ký.], [`updated_at`], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày cập nhật.], [#emph[CHECK]], [], [`status IN ('ACTIVE', 'INACTIVE')`], [Chỉ nhận giá trị quy định.]
  ),
  caption: [
    Mô Hình Mức Vật Lý: USERS
  ],
)
```

#### 7. LOAIPHONG

- Danh mục loại phòng.

<!-- | **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `ten_loai` | `NVARCHAR(100)` | `NOT NULL` | Tên loại (VD: Deluxe). |
| `gia_co_ban` | `DECIMAL(18,2)` | `NOT NULL` | Giá niêm yết. |
| `mo_ta` | `NVARCHAR(500)` | `NULL` | Mô tả tiện nghi. |
| `suc_chua` | `INT` | `DEFAULT 2` | Số người tối đa. |
| *CHECK* |  | `gia_co_ban > 0` | Chỉ nhận giá trị quy định. |
| *CHECK* |  | `suc_chua > 0` | Chỉ nhận giá trị quy định. | -->

```{=typst}
#figure(
  table(
    columns: (20%, 20%, 25%, 35%),
    align: (left, left, left, left),
    [#strong[Thuộc Tính]], [#strong[Kiểu]], [#strong[Ràng Buộc]], [#strong[Mô Tả]], [`id`], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [`ten_loai`], [`NVARCHAR(100)`], [`NOT NULL`], [Tên loại (VD: Deluxe).], [`gia_co_ban`], [`DECIMAL(18,2)`], [`NOT NULL`], [Giá niêm yết.], [`mo_ta`], [`NVARCHAR(500)`], [`NULL`], [Mô tả tiện nghi.], [`suc_chua`], [`INT`], [`DEFAULT 2`], [Số người tối đa.], [#emph[CHECK]], [], [`gia_co_ban > 0`], [Chỉ nhận giá trị quy định.], [#emph[CHECK]], [], [`suc_chua > 0`], [Chỉ nhận giá trị quy định.]
  ),
  caption: [
    Mô Hình Mức Vật Lý: LOAIPHONG
  ],
)
```

#### 8. PHONG

- Danh sách phòng vật lý.

<!-- | **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `so_phong` | `NVARCHAR(50)` | `NOT NULL`, `UNIQUE` | Số phòng (VD: 101). |
| `loai_phong_id` | `INT` | `FK (LOAIPHONG)`, `NOT NULL` | Loại phòng tương ứng. |
| `trang_thai` | `NVARCHAR(50)` | `DEFAULT 'AVAILABLE'` | Trạng thái phòng. |
| *CHECK* |  | `trang_thai IN ('AVAILABLE', 'OCCUPIED', 'MAINTENANCE', 'RESERVED')` | Chỉ nhận giá trị quy định. | -->

```{=typst}
#figure(
  table(
    columns: (20%, 20%, 30%, 30%),
    align: (left, left, left, left),
    [#strong[Thuộc Tính]], [#strong[Kiểu]], [#strong[Ràng Buộc]], [#strong[Mô Tả]], [`id`], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [`so_phong`], [`NVARCHAR(50)`], [`NOT NULL`, `UNIQUE`], [Số phòng (VD: 101).], [`loai_phong_id`], [`INT`], [`FK (LOAIPHONG)`, `NOT NULL`], [Loại phòng tương ứng.], [`trang_thai`], [`NVARCHAR(50)`], [`DEFAULT 'AVAILABLE'`], [Trạng thái phòng.], [#emph[CHECK]], [], [`trang_thai IN ('AVAILABLE', 'OCCUPIED', 'MAINTENANCE', 'RESERVED')`], [Chỉ nhận giá trị quy định.]
  ),
  caption: [
    Mô Hình Mức Vật Lý: PHONG
  ],
)
```

#### 9. DICHVU

- Danh mục dịch vụ đi kèm.

<!-- | **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `ten_dich_vu` | `NVARCHAR(255)` | `NOT NULL` | Tên dịch vụ. |
| `don_gia` | `DECIMAL(18,2)` | `NOT NULL` | Giá dịch vụ. |
| `don_vi_tinh` | `NVARCHAR(50)` | `NOT NULL`, `DEFAULT N'Lần'` | Đơn vị tính. |
| `trang_thai` | `NVARCHAR(50)` | `DEFAULT 'ACTIVE'` | Trạng thái. |
| `created_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày tạo. |
| `updated_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày cập nhật. |
| *CHECK* |  | `don_gia > 0` | Đơn giá phải dương. |
| *CHECK* |  | `trang_thai IN ('ACTIVE', 'INACTIVE')` | Ràng buộc trạng thái. | -->

```{=typst}
#figure(
  table(
    columns: (20%, 20%, 30%, 30%),
    align: (left, left, left, left),
    [#strong[Thuộc Tính]], [#strong[Kiểu]], [#strong[Ràng Buộc]], [#strong[Mô Tả]], [`id`], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [`ten_dich_vu`], [`NVARCHAR(255)`], [`NOT NULL`], [Tên dịch vụ.], [`don_gia`], [`DECIMAL(18,2)`], [`NOT NULL`], [Giá dịch vụ.], [`don_vi_tinh`], [`NVARCHAR(50)`], [`NOT NULL`, `DEFAULT N'Lần'`], [Đơn vị tính.], [`trang_thai`], [`NVARCHAR(50)`], [`DEFAULT 'ACTIVE'`], [Trạng thái.], [`created_at`], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [`updated_at`], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày cập nhật.], [#emph[CHECK]], [], [`don_gia > 0`], [Đơn giá phải dương.], [#emph[CHECK]], [], [`trang_thai IN ('ACTIVE', 'INACTIVE')`], [Ràng buộc trạng thái.]
  ),
  caption: [
    Mô Hình Mức Vật Lý: DICHVU
  ],
)
```

#### 10. VOUCHERS

- Mã giảm giá và khuyến mãi.

<!-- | **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
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
| *CHECK* |  | `trang_thai IN ('ACTIVE', 'INACTIVE')` | Ràng buộc trạng thái. | -->

```{=typst}
#figure(
  table(
    columns: (20%, 16%, 28%, 36%),
    align: (left, left, left, left),
    [#strong[Thuộc Tính]], [#strong[Kiểu]], [#strong[Ràng Buộc]], [#strong[Mô Tả]], [`id`], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [`ma_code`], [`NVARCHAR(50)`], [`NOT NULL`, `UNIQUE`], [Mã Voucher (vd: `TET2025`).], [`phan_tram_giam`], [`DECIMAL(5,2)`], [`NOT NULL`], [Phần trăm giảm.], [`ngay_het_han`], [`DATETIME`], [`NOT NULL`], [Ngày hết hạn.], [`so_tien_toi_thieu`], [`DECIMAL(18,2)`], [`NOT NULL`], [Số tiền tối thiểu.], [`so_lan_toi_da`], [`INT`], [`NOT NULL`, `DEFAULT 100`], [Số lần tối đa.], [`so_lan_da_dung`], [`INT`], [`DEFAULT 0`], [Số lần đã dùng.], [`trang_thai`], [`NVARCHAR(50)`], [`DEFAULT 'ACTIVE'`], [Trạng thái.], [`created_at`], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [`updated_at`], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày cập nhật.], [#emph[CHECK]], [], [`phan_tram_giam >= 0`], [Phần trăm giảm phải >= 0.], [#emph[CHECK]], [], [`so_tien_toi_thieu >= 0`], [Số tiền tối thiểu phải >= 0.], [#emph[CHECK]], [], [`so_lan_toi_da > 0`], [Số lần tối đa phải > 0.], [#emph[CHECK]], [], [`so_lan_da_dung >= 0`], [Số lần đã dùng phải >= 0.], [#emph[CHECK]], [], [`so_lan_da_dung <= so_lan_toi_da`], [Số lần đã dùng phải <= số lần tối đa.], [#emph[CHECK]], [], [`trang_thai IN ('ACTIVE', 'INACTIVE')`], [Ràng buộc trạng thái.]
  ),
  caption: [
    Mô Hình Mức Vật Lý: VOUCHERS
  ],
)
```

### C. Nhóm Bảng Giao Dịch & Chi Tiết

#### 11. DATPHONG

- Đơn đặt phòng.

<!-- | **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `user_id` | `INT` | `FK` (USERS), `NOT NULL` | Khách đặt phòng. |
| `voucher_id` | `INT` | `FK` (VOUCHERS), `NULL` | Voucher áp dụng (nếu có). |
| `check_in` | `DATETIME` | `NOT NULL` | Thời gian nhận phòng. |
| `check_out` | `DATETIME` | `NOT NULL` | Thời gian trả phòng. |
| `trang_thai` | `NVARCHAR(50)` | `DEFAULT 'PENDING'` | Trạng thái đơn. |
| `created_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày tạo. |
| *CHECK* |  | `check_out > check_in` | Thời gian trả phải lớn hơn thời gian nhận. |
| *CHECK* |  | `check_in > 14:00:00` | Thời gian nhận phải sau 14 giờ chiều. |
| *CHECK* |  | `check_out < 12:00:00` | Thời gian trả phải trước 12 giờ trưa. |
| *CHECK* |  | `trang_thai IN ('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED')` | Ràng buộc trạng thái. | -->

```{=typst}
#figure(
  table(
    columns: (20%, 16%, 28%, 36%),
    align: (left, left, left, left),
    [#strong[Thuộc Tính]], [#strong[Kiểu]], [#strong[Ràng Buộc]], [#strong[Mô Tả]], [`id`], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [`user_id`], [`INT`], [`FK (USERS)`, `NOT NULL`], [Khách đặt phòng.], [`voucher_id`], [`INT`], [`FK (VOUCHERS)`, `NULL`], [Voucher áp dụng (nếu có).], [`check_in`], [`DATETIME`], [`NOT NULL`], [Thời gian nhận phòng.], [`check_out`], [`DATETIME`], [`NOT NULL`], [Thời gian trả phòng.], [`trang_thai`], [`NVARCHAR(50)`], [`DEFAULT 'PENDING'`], [Trạng thái đơn.], [`created_at`], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [#emph[CHECK]], [], [`check_out > check_in`], [Thời gian trả phải lớn hơn thời gian nhận.], [#emph[CHECK]], [], [`check_in > 14:00:00`], [Nhận phòng sau 14 giờ chiều.], [#emph[CHECK]], [], [`check_out < 12:00:00`], [Trả phòng trước 12 giờ trưa.], [#emph[CHECK]], [], [`trang_thai IN ('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED')`], [Ràng buộc trạng thái.]
  ),
  caption: [
    Mô Hình Mức Vật Lý: DATPHONG
  ],
)
```

#### 12. CT_DATPHONG

- Chi tiết phòng trong đơn đặt phòng.

<!-- | **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `datphong_id` | `INT` | `FK` (DATPHONG), `NOT NULL` | Thuộc đơn đặt phòng nào. |
| `phong_id` | `INT` | `FK` (PHONG), `NOT NULL` | Phòng nào. |
| `don_gia` | `DECIMAL(18,2)` | `NOT NULL` | Giá phòng tại thời điểm đặt. |
| *FK Rule* |  | `datphong_id ON DELETE CASCADE` | Xóa đơn xóa luôn chi tiết. |
| *CHECK* |  | `UNIQUE datphong_id, phong_id` | Chi tiết đặt phòng không được trùng. |
| *CHECK* |  | `don_gia > 0` | Giá phải dương. | -->

```{=typst}
#figure(
  table(
    columns: (20%, 16%, 28%, 36%),
    align: (left, left, left, left),
    [#strong[Thuộc Tính]], [#strong[Kiểu]], [#strong[Ràng Buộc]], [#strong[Mô Tả]], [`id`], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [`datphong_id`], [`INT`], [`FK (DATPHONG)`, `NOT NULL`], [Thuộc đơn đặt phòng nào.], [`phong_id`], [`INT`], [`FK (PHONG)`, `NOT NULL`], [Phòng nào.], [`don_gia`], [`DECIMAL(18,2)`], [`NOT NULL`], [Giá phòng tại thời điểm đặt.], [#emph[FK Rule]], [], [`datphong_id ON DELETE CASCADE`], [Xóa đơn xóa luôn chi tiết.], [#emph[CHECK]], [], [`UNIQUE datphong_id, phong_id`], [Chi tiết đặt phòng không được trùng.], [#emph[CHECK]], [], [`don_gia > 0`], [Giá phải dương.]
  ),
  caption: [
    Mô Hình Mức Vật Lý: CT_DATPHONG
  ],
)
```

#### 13. CT_SUDUNG_DV

- Chi tiết sử dụng dịch vụ.

<!-- | **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `datphong_id` | `INT` | `FK` (DATPHONG), `NOT NULL` | Thuộc đơn đặt phòng nào. |
| `dichvu_id` | `INT` | `FK` (DICHVU), `NOT NULL` | Dịch vụ nào. |
| `so_luong` | `INT` | `DEFAULT 1`, `NOT NULL` | Số lượng. |
| `don_gia` | `DECIMAL(18,2)` | `NOT NULL` | Đơn giá tại thời điểm dùng. |
| `thoi_diem_su_dung` | `DATETIME` | `DEFAULT GETDATE()` | Thời gian order. |
| `ghi_chu` | `NVARCHAR(500)` | `NULL` | Ghi chú thêm. |
| `created_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày tạo. |
| *FK Rule* |  | `datphong_id ON DELETE CASCADE` | Xóa đơn xóa luôn chi tiết. |
| *CHECK* |  | `so_luong > 0` | Số lượng phải dương. |
| *CHECK* |  | `don_gia > 0` | Giá phải dương. | -->

```{=typst}
#figure(
  table(
    columns: (20%, 16%, 28%, 36%),
    align: (left, left, left, left),
    [#strong[Thuộc Tính]], [#strong[Kiểu]], [#strong[Ràng Buộc]], [#strong[Mô Tả]], [`id`], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [`datphong_id`], [`INT`], [`FK (DATPHONG)`, `NOT NULL`], [Thuộc đơn đặt phòng nào.], [`dichvu_id`], [`INT`], [`FK (DICHVU)`, `NOT NULL`], [Dịch vụ nào.], [`so_luong`], [`INT`], [`DEFAULT 1`, `NOT NULL`], [Số lượng.], [`don_gia`], [`DECIMAL(18,2)`], [`NOT NULL`], [Đơn giá tại thời điểm dùng.], [`thoi_diem_su_dung`], [`DATETIME`], [`DEFAULT GETDATE()`], [Thời gian order.], [`ghi_chu`], [`NVARCHAR(500)`], [`NULL`], [Ghi chú thêm.], [`created_at`], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [#emph[FK Rule]], [], [`datphong_id ON DELETE CASCADE`], [Xóa đơn xóa luôn chi tiết.], [#emph[CHECK]], [], [`so_luong > 0`], [Số lượng phải dương.], [#emph[CHECK]], [], [`don_gia > 0`], [Giá phải dương.]
  ),
  caption: [
    Mô Hình Mức Vật Lý: CT_SUDUNG_DV
  ],
)
```

#### 14. PAYMENTS

- Giao dịch thanh toán.

<!-- | **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `booking_id` | `INT` | `FK` (DATPHONG), `NOT NULL` | Thanh toán cho đơn nào. |
| `user_id` | `INT` | `FK` (USERS), `NOT NULL` | Người thanh toán. |
| `so_tien` | `DECIMAL(18,2)` | `NOT NULL` | Số tiền giao dịch. |
| `phuong_thuc` | `NVARCHAR(50)` | `NOT NULL` | Cách trả (`TIEN_MAT`, `CHUYEN_KHOAN`, `THE`, `ONLINE`...). |
| `trang_thai` | `NVARCHAR(50)` | `NULL` | Trạng thái giao dịch. |
| `created_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày tạo. |
| *CHECK* |  | `so_tien > 0` | Tiền phải dương. |
| *CHECK* |  | `trang_thai IN ('PENDING', 'SUCCESS', 'FAILED', 'CANCELLED', 'PAID', 'UNPAID', 'REFUNDED')` | Ràng buộc trạng thái. |
| *CHECK* |  | `phuong_thuc IN ('TIEN_MAT', 'CHUYEN_KHOAN', 'THE', 'ONLINE')` | Ràng buộc phương thức. | -->

```{=typst}
#figure(
  table(
    columns: (20%, 16%, 28%, 36%),
    align: (left, left, left, left),
    [#strong[Thuộc Tính]], [#strong[Kiểu]], [#strong[Ràng Buộc]], [#strong[Mô Tả]], [`id`], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [`booking_id`], [`INT`], [`FK (DATPHONG)`, `NOT NULL`], [Thanh toán cho đơn nào.], [`user_id`], [`INT`], [`FK (USERS)`, `NOT NULL`], [Người thanh toán.], [`so_tien`], [`DECIMAL(18,2)`], [`NOT NULL`], [Số tiền giao dịch.], [`phuong_thuc`], [`NVARCHAR(50)`], [`NOT NULL`], [Cách trả tiền.], [`trang_thai`], [`NVARCHAR(50)`], [`NULL`], [Trạng thái giao dịch.], [`created_at`], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [#emph[CHECK]], [], [`so_tien > 0`], [Tiền phải dương.], [#emph[CHECK]], [], [`trang_thai IN ('PENDING', 'SUCCESS', 'FAILED', 'CANCELLED', 'PAID', 'UNPAID', 'REFUNDED')`], [Ràng buộc trạng thái.], [#emph[CHECK]], [], [`phuong_thuc IN ('TIEN_MAT', 'CHUYEN_KHOAN', 'THE', 'ONLINE')`], [Ràng buộc phương thức.]
  ),
  caption: [
    Mô Hình Mức Vật Lý: PAYMENTS
  ],
)
```

#### 15. REFUNDS

- Yêu cầu hoàn tiền.

<!-- | **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `payment_id` | `INT` | `FK` (PAYMENTS), `NOT NULL` | Hoàn tiền cho giao dịch nào. |
| `so_tien_hoan` | `DECIMAL(18,2)` | `NOT NULL` | Số tiền hoàn trả. |
| `trang_thai` | `NVARCHAR(50)` | `NULL` | Trạng thái. |
| `ly_do` | `NVARCHAR(500)` | `NULL` | Lý do hoàn tiền. |
| `requested_by` | `INT` | `FK` (USERS), `NOT NULL` | Người yêu cầu. |
| `approved_by` | `INT` | `FK` (ADMINS), `NULL` | Người duyệt. |
| `created_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày tạo. |
| `updated_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày cập nhật. |
| *CHECK* |  | `trang_thai IN ('REQUESTED', 'APPROVED', 'REJECTED', 'COMPLETED')` | Ràng buộc trạng thái. |
| *CHECK* |  | `so_tien_hoan > 0` | Tiền phải dương. | -->

```{=typst}
#figure(
  table(
    columns: (20%, 16%, 28%, 36%),
    align: (left, left, left, left),
    [#strong[Thuộc Tính]], [#strong[Kiểu]], [#strong[Ràng Buộc]], [#strong[Mô Tả]], [`id`], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [`payment_id`], [`INT`], [`FK (PAYMENTS)`, `NOT NULL`], [Hoàn tiền cho giao dịch nào.], [`so_tien_hoan`], [`DECIMAL(18,2)`], [`NOT NULL`], [Số tiền hoàn trả.], [`trang_thai`], [`NVARCHAR(50)`], [`NULL`], [Trạng thái.], [`ly_do`], [`NVARCHAR(500)`], [`NULL`], [Lý do hoàn tiền.], [`requested_by`], [`INT`], [`FK (USERS)`, `NOT NULL`], [Người yêu cầu.], [`approved_by`], [`INT`], [`FK (ADMINS)`, `NULL`], [Người duyệt.], [`created_at`], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [`updated_at`], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày cập nhật.], [#emph[CHECK]], [], [`trang_thai IN ('REQUESTED', 'APPROVED', 'REJECTED', 'COMPLETED')`], [Ràng buộc trạng thái.], [#emph[CHECK]], [], [`so_tien_hoan > 0`], [Tiền phải dương.]
  ),
  caption: [
    Mô Hình Mức Vật Lý: REFUNDS
  ],
)
```

#### 16. REVIEWS

- Đánh giá từ khách hàng.

<!-- | **Thuộc Tính** | **Kiểu** | **Ràng Buộc** | **Mô Tả** |
| --- | --- | --- | --- |
| `id` | `INT` | `PK`, `IDENTITY` | Khóa chính. |
| `user_id` | `INT` | `FK` (USERS), `NOT NULL` | Người đánh giá. |
| `phong_id` | `INT` | `FK` (PHONG), `NOT NULL` | Phòng được đánh giá. |
| `datphong_id` | `INT` | `FK` (DATPHONG), `UNIQUE`, `NOT NULL` | Thuộc đơn đặt phòng nào (Duy nhất 1-1). |
| `so_sao` | `INT` | `NOT NULL` | Điểm sao (1-5). |
| `binh_luan` | `NVARCHAR(1000)` | `NULL` | Nội dung text. |
| `ngay_danh_gia` | `DATE` | `DEFAULT GETDATE()` | Ngày đánh giá. |
| `trang_thai` | `NVARCHAR(50)` | `DEFAULT 'PENDING'` | Trạng thái. |
| `created_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày tạo. |
| `updated_at` | `DATETIME` | `DEFAULT GETDATE()` | Ngày cập nhật. |
| *CHECK* |  | `so_sao BETWEEN 1 AND 5` | Giới hạn 1 đến 5 sao. |
| *CHECK* |  | `trang_thai IN ('PENDING', 'APPROVED', 'REJECTED')` | Ràng buộc trạng thái. | -->

```{=typst}
#figure(
  table(
    columns: (20%, 18%, 26%, 36%),
    align: (left, left, left, left),
    [#strong[Thuộc Tính]], [#strong[Kiểu]], [#strong[Ràng Buộc]], [#strong[Mô Tả]], [`id`], [`INT`], [`PK`, `IDENTITY`], [Khóa chính.], [`user_id`], [`INT`], [`FK (USERS)`, `NOT NULL`], [Người đánh giá.], [`phong_id`], [`INT`], [`FK (PHONG)`, `NOT NULL`], [Phòng được đánh giá.], [`datphong_id`], [`INT`], [`FK (DATPHONG)`, `UNIQUE`, `NOT NULL`], [Thuộc đơn đặt phòng nào (Duy nhất 1-1).], [`so_sao`], [`INT`], [`NOT NULL`], [Điểm sao (1-5).], [`binh_luan`], [`NVARCHAR(1000)`], [`NULL`], [Nội dung text.], [`ngay_danh_gia`], [`DATE`], [`DEFAULT GETDATE()`], [Ngày đánh giá.], [`trang_thai`], [`NVARCHAR(50)`], [`DEFAULT 'PENDING'`], [Trạng thái.], [`created_at`], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [`updated_at`], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày cập nhật.], [#emph[CHECK]], [], [`so_sao BETWEEN 1 AND 5`], [Giới hạn 1 đến 5 sao.], [#emph[CHECK]], [], [`trang_thai IN ('PENDING', 'APPROVED', 'REJECTED')`], [Ràng buộc trạng thái.]
  ),
  caption: [
    Mô Hình Mức Vật Lý: REVIEWS
  ],
)
```

## Khởi Tạo Cơ Sở Dữ Liệu

- Script khởi tạo dữ liệu, phiên bản đầy đủ được đính kèm theo file báo cáo này.

### Tạo Database

- Đây là một lệnh đầy đủ, thực thi được.

```{=typst}
#figure(
  raw(read("code/ch03-00-create-database.sql"), lang: "sql", block: true),
  caption: [
    Khởi Tạo Cơ Sở Dữ Liệu: Tạo Database
  ],
)
```

### Khai Báo Các Bảng

- Phiên bản ví dụ miêu tả.

```{=typst}
#figure(
  raw(read("code/ch03-01-tables.sql"), lang: "sql", block: true),
  caption: [
    Khởi Tạo Cơ Sở Dữ Liệu: Khai Báo Các Bảng
  ],
)
```

## Dữ Liệu Mẫu

Để hệ thống có thể hoạt động demo, Nhóm 02 đã xây dựng bộ dữ liệu mẫu bao gồm danh mục hệ thống và dữ liệu giao dịch giả lập.

- Dưới đây là một số ví dụ, vui lòng tham khảo phiên bản đầy đủ đính kèm.

### Phân Quyền

- Hệ thống định nghĩa các nhóm người dùng cơ bản và quyền hạn tương ứng.

```sql
-- 2. ROLES
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

### Tài Khoản

```sql
-- Insert ADMINS (status: ACTIVE or INACTIVE)
INSERT INTO ADMINS (email, password_hash, full_name, status) VALUES
('superadmin@gmail.com', 'hash_password_1', N'Lê Kim Long', 'ACTIVE'),
('admin@gmail.com', 'hash_password_2', N'Đinh Xuân Sâm', 'ACTIVE'),
('staff@gmail.com', 'hash_password_3', N'Nguyễn Minh Triết', 'ACTIVE');

GO
```

### Loại Phòng

```sql
INSERT INTO LOAIPHONG (ten_loai, gia_co_ban, mo_ta, suc_chua) VALUES
(N'Phòng Đơn Tiêu Chuẩn', 500000, N'Phòng đơn cơ bản, giường đơn', 1),
(N'Phòng Đơn Cao Cấp', 700000, N'Phòng đơn với tiện nghi cao cấp', 1),
(N'Phòng Đôi Tiêu Chuẩn', 800000, N'Phòng đôi với 2 giường đơn hoặc 1 giường đôi', 2),
(N'Phòng Đôi Cao Cấp', 1200000, N'Phòng đôi rộng rãi, view đẹp', 2),
(N'Phòng Gia Đình', 1500000, N'Phòng lớn cho gia đình, 2-3 giường', 4),
(N'Phòng VIP', 2000000, N'Phòng VIP với đầy đủ tiện nghi', 2),
(N'Suite Junior', 2500000, N'Suite nhỏ với phòng khách riêng', 2),
(N'Suite Executive', 3500000, N'Suite cao cấp với nhiều phòng', 4),
(N'Phòng Deluxe', 1800000, N'Phòng deluxe view biển', 2),
(N'Phòng Honeymoon', 2200000, N'Phòng trang trí lãng mạn cho cặp đôi', 2);

GO
```

### Dữ Liệu Giao Dịch

- Mô phỏng quy trình đặt phòng và thanh toán.

```sql
INSERT INTO DATPHONG (user_id, voucher_id, check_in, check_out, trang_thai, created_at) VALUES
-- Đặt phòng đã hoàn thành
(1, 1, '2024-01-05 14:00:00', '2024-01-08 12:00:00', 'COMPLETED', '2024-01-01 10:00:00'),
-- Đặt phòng đang diễn ra
(5, NULL, '2024-01-25 14:00:00', '2024-01-28 12:00:00', 'CONFIRMED', '2024-01-20 16:00:00'),
-- Đặt phòng sắp tới
(8, 6, '2024-02-01 14:00:00', '2024-02-05 12:00:00', 'PENDING', '2024-01-25 09:00:00'),
-- Đặt phòng đã hủy
(11, NULL, '2024-01-18 14:00:00', '2024-01-20 12:00:00', 'CANCELLED', '2024-01-10 10:00:00'),
-- Thêm một số đặt phòng nữa
(1, 8, '2024-02-12 14:00:00', '2024-02-14 12:00:00', 'CONFIRMED', '2024-01-28 10:00:00');
```
