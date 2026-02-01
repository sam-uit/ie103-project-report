## Mô Hình Mức Logic

Quy cách trình bày:

- Khóa chính: <u>gạch chân</u> (ví dụ: <u>id</u>)
- Khóa ngoại: *in nghiêng* (ví dụ: *loai_phong_id*)

### Nhóm Bảng Thực Thể

#### ADMINS (Quản Lý/Quản Trị Viên)

ADMINS(<u>id</u>, email, password_hash, full_name, status, created_at, updated_at)

<!-- TODO: định dạng khóa chính, khóa ngoại trong bảng -->

<!-- | Khóa | Mô tả |
| --- | --- |
| <u>id</u> | Mã định danh duy nhất của admin. |
| email | Tên đăng nhập của admin. |
| password_hash | Mật khẩu của admin. |
| full_name | Họ tên đầy đủ của admin. |
| status | Trạng thái của admin. |
| created_at | Thời gian tạo của admin. |
| updated_at | Thời gian cập nhật của admin. | -->

<!-- Sử dụng bảng của Typst -->

```{=typst}
#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh duy nhất của admin.], [email], [Tên đăng nhập của admin.], [password\_hash], [Mật khẩu của admin.], [full\_name], [Họ tên đầy đủ của admin.], [status], [Trạng thái của admin.], [created\_at], [Thời gian tạo của admin.], [updated\_at], [Thời gian cập nhật của admin.]
  ),
  caption: [Mô Hình Mức Logic: ADMINS],
)
```

#### DATPHONG (Đặt Phòng)

- Lưu trữ thông tin header của đơn đặt phòng.

DATPHONG(<u>id</u>, *user_id*, *voucher_id*, check_in, check_out, trang_thai, created_at)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh đơn đặt phòng.
| *user_id* | Khóa ngoại tham chiếu tới bảng USERS (Người đặt).
| *voucher_id* | Khóa ngoại tham chiếu tới bảng VOUCHERS (Mã giảm giá áp dụng, có thể NULL).
| check_in | Ngày nhận phòng dự kiến.
| check_out | Ngày trả phòng dự kiến.
| trang_thai | Trạng thái đơn (PENDING, CONFIRMED, CANCELLED, COMPLETED).
| created_at | Thời gian tạo đơn. -->

<!-- Sử dụng bảng của Typst -->

```{=typst}
#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh đơn đặt phòng.], [#emph[user\_id]], [Khóa ngoại tham chiếu tới bảng USERS (Người đặt).], [#emph[voucher\_id]], [Khóa ngoại tham chiếu tới bảng VOUCHERS (Mã giảm giá áp dụng, có thể
    NULL).], [check\_in], [Ngày nhận phòng dự kiến.], [check\_out], [Ngày trả phòng dự kiến.], [trang\_thai], [Trạng thái đơn (PENDING, CONFIRMED, CANCELLED, COMPLETED).], [created\_at], [Thời gian tạo đơn.]
  ),
  caption: [Mô Hình Mức Logic: DATPHONG],
)
```

#### DICHVU (Dịch Vụ)

- Danh mục các dịch vụ đi kèm (Ăn uống, Spa, Đưa đón...).

DICHVU(<u>id</u>, ten_dich_vu, don_gia, don_vi_tinh, trang_thai, created_at, updated_at)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh dịch vụ. |
| ten_dich_vu | Tên dịch vụ. |
| don_gia | Đơn giá niêm yết. |
| don_vi_tinh | Đơn vị tính. |
| trang_thai | Trạng thái khả dụng (ACTIVE/INACTIVE). |
| created_at | Ngày tạo. |
| updated_at | Ngày cập nhật. | -->

```{=typst}
#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh dịch vụ.], [ten\_dich\_vu], [Tên dịch vụ.], [don\_gia], [Đơn giá niêm yết.], [don\_vi\_tinh], [Đơn vị tính.], [trang\_thai], [Trạng thái khả dụng (ACTIVE/INACTIVE).], [created\_at], [Ngày tạo.], [updated\_at], [Ngày cập nhật.]
  ),
  caption: [Mô Hình Mức Logic: DICHVU],
)
```

#### LOAIPHONG (Loại Phòng)

- Danh mục phân loại phòng (Deluxe, Standard, Suite...).

LOAIPHONG(<u>id</u>, ten_loai, gia_co_ban, mo_ta, suc_chua)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh loại phòng. |
| ten_loai | Tên hiển thị của loại phòng. |
| gia_co_ban | Giá gốc theo đêm. |
| mo_ta | Mô tả chi tiết loại phòng. |
| suc_chua | Số người tối đa cho phép. | -->

```{=typst}
#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh loại phòng.], [ten\_loai], [Tên hiển thị của loại phòng.], [gia\_co\_ban], [Giá gốc theo đêm.], [mo\_ta], [Mô tả chi tiết loại phòng.], [suc\_chua], [Số người tối đa cho phép.]
  ),
  caption: [Mô Hình Mức Logic: LOAIPHONG],
)
```

#### PAYMENTS (Thanh Toán)

- Lưu trữ lịch sử giao dịch thanh toán.

PAYMENTS(<u>id</u>, *booking_id*, *user_id*, so_tien, phuong_thuc, trang_thai, created_at)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh giao dịch. |
| *booking_id* | Khóa ngoại tham chiếu đơn đặt phòng được thanh toán. |
| *user_id* | Khóa ngoại tham chiếu người thực hiện thanh toán. |
| so_tien | Số tiền thanh toán. |
| phuong_thuc | Phương thức (TIEN_MAT, CHUYEN_KHOAN, THE, ONLINE). |
| trang_thai | Trạng thái giao dịch (PENDING, SUCCESS, FAILED, CANCELLED, PAID, UNPAID, REFUNDED). |
| created_at | Ngày tạo. | -->

```{=typst}
#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh giao dịch.], [#emph[booking\_id]], [Khóa ngoại tham chiếu đơn đặt phòng được thanh toán.], [#emph[user\_id]], [Khóa ngoại tham chiếu người thực hiện thanh toán.], [so\_tien], [Số tiền thanh toán.], [phuong\_thuc], [Phương thức (TIEN\_MAT, CHUYEN\_KHOAN, THE, ONLINE).], [trang\_thai], [Trạng thái giao dịch (PENDING, SUCCESS, FAILED, CANCELLED, PAID, UNPAID,
    REFUNDED).], [created\_at], [Ngày tạo.]
  ),
  caption: [Mô Hình Mức Logic: PAYMENTS],
)
```

#### PERMISSIONS (Quyền Hạn)

- Danh sách các quyền hạn cụ thể trong hệ thống.

PERMISSIONS(<u>id</u>, code, description)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh quyền hạn. |
| code | Mã code hệ thống (ví dụ: `VIEW_DASHBOARD`, `EDIT_ROOM`). |
| description | Mô tả chi tiết quyền hạn. | -->

```{=typst}
#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh quyền hạn.], [code], [Mã code hệ thống (ví dụ: `VIEW_DASHBOARD`, `EDIT_ROOM`).], [description], [Mô tả chi tiết quyền hạn.]
  ),
  caption: [Mô Hình Mức Logic: PERMISSIONS],
)
```

#### PHONG (Phòng)

- Danh sách các phòng vật lý.

PHONG(<u>id</u>, so_phong, *loai_phong_id*, trang_thai)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh phòng. |
| so_phong | Số hiệu phòng (ví dụ: 101, 202). |
| *loai_phong_id* | Khóa ngoại tham chiếu tới bảng LOAIPHONG. |
| trang_thai | Trạng thái hiện tại (AVAILABLE, OCCUPIED, MAINTENANCE, RESERVED). | -->

```{=typst}
#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh phòng.], [so\_phong], [Số hiệu phòng (ví dụ: 101, 202).], [#emph[loai\_phong\_id]], [Khóa ngoại tham chiếu tới bảng LOAIPHONG.], [trang\_thai], [Trạng thái hiện tại (AVAILABLE, OCCUPIED, MAINTENANCE, RESERVED).]
  ),
  caption: [Mô Hình Mức Logic: PHONG],
)
```

#### REFUNDS (Hoàn Tiền)

- Lưu trữ yêu cầu và lịch sử hoàn tiền.

REFUNDS(<u>id</u>, *payment_id*, *requested_by*, *approved_by*, so_tien_hoan, ly_do, trang_thai, created_at, updated_at)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh yêu cầu hoàn tiền. |
| *payment_id* | Khóa ngoại tham chiếu giao dịch gốc cần hoàn tại PAYMENTS. |
| *requested_by* | Người yêu cầu hoàn tiền, khóa ngoại tham chiếu tới USERS. |
| *approved_by* | Người duyệt hoàn tiền (có thể NULL nếu chưa duyệt). Khóa ngoại tham chiếu tới ADMINS. |
| so_tien_hoan | Số tiền được hoàn. |
| trang_thai | Trạng thái (REQUESTED, APPROVED, REJECTED, COMPLETED). |
| created_at | Ngày tạo. |
| updated_at | Ngày cập nhật. | -->

```{=typst}
#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh yêu cầu hoàn tiền.], [#emph[payment\_id]], [Khóa ngoại tham chiếu giao dịch gốc cần hoàn tại PAYMENTS.], [#emph[requested\_by]], [Người yêu cầu hoàn tiền, khóa ngoại tham chiếu tới USERS.], [#emph[approved\_by]], [Người duyệt hoàn tiền (có thể NULL nếu chưa duyệt). Khóa ngoại tham
    chiếu tới ADMINS.], [so\_tien\_hoan], [Số tiền được hoàn.], [trang\_thai], [Trạng thái (REQUESTED, APPROVED, REJECTED, COMPLETED).], [created\_at], [Ngày tạo.], [updated\_at], [Ngày cập nhật.]
  ),
  caption: [Mô Hình Mức Logic: REFUNDS],
)
```

#### REVIEWS (Đánh Giá)

- Lưu trữ đánh giá từ khách hàng sau khi hoàn tất đặt phòng.

REVIEWS(<u>id</u>, *user_id*, *phong_id*, *datphong_id*, so_sao, binh_luan, ngay_danh_gia, trang_thai, created_at, updated_at)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh đánh giá. |
| *user_id* | Người đánh giá, khóa ngoại tham chiếu tới USERS. |
| *datphong_id* | Khóa ngoại tham chiếu đơn đặt phòng, DATPHONG. |
| *phong_id* | Khóa ngoại tham chiếu phòng được đánh giá, PHONG. |
| so_sao | Điểm đánh giá (1-5). |
| trang_thai | Trạng thái kiểm duyệt (VISIBLE/HIDDEN). |
| created_at | Ngày tạo. |
| updated_at | Ngày cập nhật. | -->

```{=typst}
#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh đánh giá.], [#emph[user\_id]], [Người đánh giá, khóa ngoại tham chiếu tới USERS.], [#emph[datphong\_id]], [Khóa ngoại tham chiếu đơn đặt phòng, DATPHONG.], [#emph[phong\_id]], [Khóa ngoại tham chiếu phòng được đánh giá, PHONG.], [so\_sao], [Điểm đánh giá (1-5).], [trang\_thai], [Trạng thái kiểm duyệt (VISIBLE/HIDDEN).], [created\_at], [Ngày tạo.], [updated\_at], [Ngày cập nhật.]
  ),
  caption: [Mô Hình Mức Logic: REVIEWS],
)
```

#### ROLES (Vai Trò)

Định nghĩa các nhóm quyền (Admin, Staff, Customer).

ROLES(<u>id</u>, code, name, description)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh vai trò. |
| code | Mã code vai trò (ADMIN, STAFF, USER). |
| name | Tên hiển thị. |
| description | Mô tả chi tiết vai trò. | -->

```{=typst}
#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh vai trò.], [code], [Mã code vai trò (ADMIN, STAFF, USER).], [name], [Tên hiển thị.], [description], [Mô tả chi tiết vai trò.]
  ),
  caption: [Mô Hình Mức Logic: ROLES],
)
```

#### USERS (Người Dùng)

- Lưu trữ thông tin khách hàng/người dùng cuối.

USERS(<u>id</u>, email, phone, password_hash, full_name, status, created_at, updated_at)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh người dùng. |
| email | Địa chỉ email (dùng để đăng nhập). |
| phone | Số điện thoại liên lạc. |
| password_hash | Mật khẩu đã mã hóa. |
| full_name | Họ và tên. |
| status | Trạng thái (ACTIVE/INACTIVE). |
| created_at | Ngày tạo. |
| updated_at | Ngày cập nhật. | -->

```{=typst}
#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh người dùng.], [email], [Địa chỉ email (dùng để đăng nhập).], [phone], [Số điện thoại liên lạc.], [password\_hash], [Mật khẩu đã mã hóa.], [full\_name], [Họ và tên.], [status], [Trạng thái (ACTIVE/INACTIVE).], [created\_at], [Ngày tạo.], [updated\_at], [Ngày cập nhật.]
  ),
  caption: [Mô Hình Mức Logic: USERS],
)
```

#### VOUCHERS (Mã Giảm Giá)

- Quản lý các chương trình khuyến mãi.

VOUCHERS(<u>id</u>, ma_code, phan_tram_giam, ngay_het_han, so_tien_toi_thieu, so_lan_toi_da, so_lan_da_dung, trang_thai, created_at, updated_at)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh voucher. |
| ma_code | Mã nhập khuyến mãi (ví dụ: SUMMER2024). |
| phan_tram_giam | Phần trăm giảm giá. |
| ngay_het_han | Ngày hết hạn. |
| so_tien_toi_thieu | Số tiền tối thiểu để áp dụng voucher. |
| so_lan_toi_da | Số lần sử dụng tối đa. |
| so_lan_da_dung | Số lần đã sử dụng. |
| trang_thai | Trạng thái (ACTIVE/INACTIVE). |
| created_at | Ngày tạo. |
| updated_at | Ngày cập nhật. | -->

```{=typst}
#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh voucher.], [ma\_code], [Mã nhập khuyến mãi (ví dụ: SUMMER2024).], [phan\_tram\_giam], [Phần trăm giảm giá.], [ngay\_het\_han], [Ngày hết hạn.], [so\_tien\_toi\_thieu], [Số tiền tối thiểu để áp dụng voucher.], [so\_lan\_toi\_da], [Số lần sử dụng tối đa.], [so\_lan\_da\_dung], [Số lần đã sử dụng.], [trang\_thai], [Trạng thái (ACTIVE/INACTIVE).], [created\_at], [Ngày tạo.], [updated\_at], [Ngày cập nhật.]
  ),
  caption: [Mô Hình Mức Logic: VOUCHERS],
)
```

### Nhóm Bảng Mối Liên Kết (Mối Quan Hệ n-n)

- Được hình thành từ việc tách các mối quan hệ nhiều-nhiều (Many-to-Many).

#### ADMIN_ROLES

- Mối quan hệ giữa ADMINS và ROLES.
- Phân quyền Admin.

ADMIN_ROLES(<u>admin_id</u>, <u>role_id</u>)

<!-- Nếu khóa vừa là khóa chính, vừa là khóa ngoại: đậm-nghiêng -->

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>*admin_id*</u> | Mã định danh duy nhất của admin. Khóa ngoại tham chiếu ADMINS. |
| <u>*role_id*</u> | Mã định danh duy nhất của role. Khóa ngoại tham chiếu ROLES. | -->

```{=typst}
#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[#emph[admin\_id]]], [Mã định danh duy nhất của admin. Khóa ngoại tham chiếu ADMINS.], [#underline[#emph[role\_id]]], [Mã định danh duy nhất của role. Khóa ngoại tham chiếu ROLES.]
  ),
  caption: [Mô Hình Mức Logic: ADMINS_ROLES],
)
```

#### ROLE_PERMISSIONS

- Giải quyết quan hệ N-N giữa ROLES và PERMISSIONS.
- Gán quyền cho Role.

ROLE_PERMISSIONS(<u>role_id</u>, <u>permission_id</u>)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>*role_id*</u> | Khóa ngoại tham chiếu ROLES. |
| <u>*permission_id*</u> | Khóa ngoại tham chiếu PERMISSIONS. | -->

```{=typst}
#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[#emph[role\_id]]], [Khóa ngoại tham chiếu ROLES.], [#underline[#emph[permission\_id]]], [Khóa ngoại tham chiếu PERMISSIONS.]
  ),
  caption: [Mô Hình Mức Logic: ROLES_PERMISSIONS],
)
```

#### CT_DATPHONG

- Giải quyết quan hệ N-N giữa DATPHONG và PHONG.
- Lưu trữ danh sách phòng trong một đơn đặt phòng.

CT_DATPHONG(<u>id</u>, *datphong_id*, *phong_id*, don_gia)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh dòng chi tiết (Surrogate Key). |
| *datphong_id* | Khóa ngoại tham chiếu DATPHONG. |
| *phong_id* | Khóa ngoại tham chiếu PHONG. |
| don_gia | Giá phòng được chốt tại thời điểm đặt (Lưu lịch sử giá). | -->

```{=typst}
#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh dòng chi tiết (Surrogate Key).], [#emph[datphong\_id]], [Khóa ngoại tham chiếu DATPHONG.], [#emph[phong\_id]], [Khóa ngoại tham chiếu PHONG.], [don\_gia], [Giá phòng được chốt tại thời điểm đặt (Lưu lịch sử giá).]
  ),
  caption: [Mô Hình Mức Logic: CT_DATPHONG],
)
```

#### CT_SUDUNG_DV

- Giải quyết quan hệ N-N giữa DATPHONG và DICHVU.
- Lưu trữ các dịch vụ khách sử dụng trong đơn đặt hàng.

CT_SUDUNG_DV(<u>id</u>, *datphong_id*, *dichvu_id*, so_luong, don_gia, thoi_diem_su_dung, ghi_chu, created_at)

<!-- | **Khóa** | **Mô tả** |
| --- | --- |
| <u>id</u> | Mã định danh dòng chi tiết (Surrogate Key). |
| *datphong_id* | Khóa ngoại tham chiếu DATPHONG. |
| *dichvu_id* | Khóa ngoại tham chiếu DICHVU. |
| so_luong | Số lượng dịch vụ sử dụng. |
| don_gia | Đơn giá dịch vụ tại thời điểm sử dụng. |
| thoi_diem_su_dung | Thời gian khách order dịch vụ. |
| ghi_chu | Ghi chú về việc sử dụng dịch vụ. |
| created_at | Ngày tạo. | -->

```{=typst}
#figure(
  table(
    columns: (30%, 70%),
    align: (left, left),
    [#strong[Khóa]], [#strong[Mô tả]], [#underline[id]], [Mã định danh dòng chi tiết (Surrogate Key).], [#emph[datphong\_id]], [Khóa ngoại tham chiếu DATPHONG.], [#emph[dichvu\_id]], [Khóa ngoại tham chiếu DICHVU.], [so\_luong], [Số lượng dịch vụ sử dụng.], [don\_gia], [Đơn giá dịch vụ tại thời điểm sử dụng.], [thoi\_diem\_su\_dung], [Thời gian khách order dịch vụ.], [ghi\_chu], [Ghi chú về việc sử dụng dịch vụ.], [created\_at], [Ngày tạo.]
  ),
  caption: [Mô Hình Mức Logic: CT_SUDUNG_DV],
)
```

### Tổng Hợp Danh Sách Bảng

<!-- | **STT** | **Tên Bảng** | **Loại** | **Mô Tả** |
|------|------|-------|-------|
| 1 | `ADMINS` | Thực Thể | Biểu diễn người quản trị. |
| 2 | `DATPHONG` | Thực Thể | Lưu trữ thông tin đơn đặt phòng. |
| 3 | `DICHVU` | Thực Thể | Danh mục các dịch vụ đi kèm. |
| 4 | `LOAIPHONG` | Thực Thể | Danh mục phân loại phòng. |
| 5 | `PAYMENTS` | Thực Thể | Lưu trữ lịch sử giao dịch thanh toán. |
| 6 | `PERMISSIONS` | Thực Thể | Danh sách các quyền hạn hệ thống. |
| 7 | `PHONG` | Thực Thể | Danh sách các phòng vật lý. |
| 8 | `REFUNDS` | Thực Thể | Lưu trữ yêu cầu và lịch sử hoàn tiền. |
| 9 | `REVIEWS` | Thực Thể | Lưu trữ đánh giá từ khách hàng. |
| 10 | `ROLES` | Thực Thể | Định nghĩa các vai trò trong hệ thống. |
| 11 | `USERS` | Thực Thể | Lưu trữ thông tin khách hàng. |
| 12 | `VOUCHERS` | Thực Thể | Quản lý các chương trình khuyến mãi. |
| 13 | `ADMIN_ROLES` | Liên Kết | Mối quan hệ giữa `ADMINS` và `ROLES`. |
| 14 | `ROLE_PERMISSIONS` | Liên Kết | Mối quan hệ giữa `ROLES` và `PERMISSIONS`. |
| 15 | `CT_DATPHONG` | Liên Kết | Chi tiết các phòng trong đơn đặt phòng. |
| 16 | `CT_SUDUNG_DV` | Liên Kết | Chi tiết các dịch vụ khách sử dụng. | -->

```{=typst}
#figure(
  table(
    columns: (10%, 20%, 20%, 50%),
    align: (right, left, left, left),
    [#strong[STT]], [#strong[Tên Bảng]], [#strong[Loại]], [#strong[Mô Tả]], [1], [`ADMINS`], [Thực Thể], [Biểu diễn người quản trị.], [2], [`DATPHONG`], [Thực Thể], [Lưu trữ thông tin đơn đặt phòng.], [3], [`DICHVU`], [Thực Thể], [Danh mục các dịch vụ đi kèm.], [4], [`LOAIPHONG`], [Thực Thể], [Danh mục phân loại phòng.], [5], [`PAYMENTS`], [Thực Thể], [Lưu trữ lịch sử giao dịch thanh toán.], [6], [`PERMISSIONS`], [Thực Thể], [Danh sách các quyền hạn hệ thống.], [7], [`PHONG`], [Thực Thể], [Danh sách các phòng vật lý.], [8], [`REFUNDS`], [Thực Thể], [Lưu trữ yêu cầu và lịch sử hoàn tiền.], [9], [`REVIEWS`], [Thực Thể], [Lưu trữ đánh giá từ khách hàng.], [10], [`ROLES`], [Thực Thể], [Định nghĩa các vai trò trong hệ thống.], [11], [`USERS`], [Thực Thể], [Lưu trữ thông tin khách hàng.], [12], [`VOUCHERS`], [Thực Thể], [Quản lý các chương trình khuyến mãi.], [13], [`ADMIN_ROLES`], [Liên Kết], [Mối quan hệ giữa `ADMINS` và `ROLES`.], [14], [`ROLE_PERMISSIONS`], [Liên Kết], [Mối quan hệ giữa `ROLES` và `PERMISSIONS`.], [15], [`CT_DATPHONG`], [Liên Kết], [Chi tiết các phòng trong đơn đặt phòng.], [16], [`CT_SUDUNG_DV`], [Liên Kết], [Chi tiết các dịch vụ khách sử dụng.]
  ),
  caption: [Mô Hình Mức Logic: Danh Sách Bảng],
)
```
