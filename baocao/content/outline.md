# GIỚI THIỆU

## Lời Cảm Ơn

### Giảng Viên

```{=typst}
#table(
columns: (100%),
inset: (top: 0.6em, bottom: 0.6em),
align: (left),
stroke: (
    bottom: 0.5pt + gradient.linear(red, blue, green),
    top: none,
    left: none,
    right: none,
),
[- Thạc Sĩ Nguyễn Thành Luân.],
[- IE103 - Quản Lý Thông Tin.]
)
```

### Nhà Trường

```{=typst}
#table(
columns: (100%),
inset: (top: 0.6em, bottom: 0.6em),
align: (left),
stroke: (
    bottom: 0.5pt + gradient.linear(red, blue, green),
    top: none,
    left: none,
    right: none,
),
[- Trung Tâm Phát Triển Công Nghệ Thông Tin.],
[- Trường Đại Học Công Nghệ Thông Tin.]
)
```

### Nhóm 02

```{=typst}
#table(
columns: (100%),
inset: (top: 0.6em, bottom: 0.6em),
align: (left),
stroke: (
    bottom: 0.5pt + gradient.linear(red, blue, green),
    top: none,
    left: none,
    right: none,
),
[- Các thành viên của Nhóm 02.],
)
```

## Nhóm 02

```{=typst}
#align(center)[
  #show table.cell: current_cell => {
    if current_cell.x in (0, 1, 3, 4) {
      text(
        //font: code-font,
        weight: "light",
        //size: 0.9em,
        fill: gray,
      )[#current_cell]
    } else {
      current_cell
    }
  }
  #table(
    columns: (auto, auto, auto, auto, auto, auto),
    inset: (top: 1.2em, bottom: 1.2em),
    align: (right + bottom, right + bottom, left + bottom, right + bottom, right + bottom, left + bottom),
    stroke: (
      bottom: 0.5pt + gradient.linear(red, blue, green),
      top: none,
      left: none,
      right: none,
    ),
      [1], [25410247], [Lê Kim Long],
      [2], [25410291], [Đinh Xuân Sâm],
      [3], [25410319], [Đặng Hữu Toàn],
      [4], [25410321], [Nguyễn Điền Triết],
      [5], [25410204], [Trương Xuân Hậu],
      [6], [25410338], [Lê Anh Vũ],
      [7], [25410176], [Trần Sơn Bình],
      [8], [25410337], [La Anh Vũ],
      [9], [25410209], [Lê Ngọc Hiệp],
      [10], [25410271], [Nguyễn Thị Ngọc Nhung],
  )
]
```

## Giới Thiệu Đề Tài

### Đặt Vấn Đề

```{=typst}
#align(center)[Các Doanh Nghiệp vừa và nhỏ trong ngành Khách Sạn, Nhà Nghỉ.]
```

```{=typst}
#table(
columns: (40%, 60%),
inset: (top: 0.6em, bottom: 0.6em),
align: (left, left),
stroke: (
    bottom: 0.5pt + gradient.linear(red, blue, green),
    top: none,
    left: none,
    right: none,
),
[- Quản lý *thủ công*.],
[- *Khó khăn* trong thống kê/báo cáo.],
[- Số hóa *hạn chế*.],
[- Không có *điểm chạm* với khách hàng.]
)
```

### Giới Thiệu Đề Tài

```{=typst}
#align(center)[*Hệ Thống Quản Lý Đặt Phòng* #emph[(Booking Management System)].]
```

```{=typst}
#table(
columns: (50%, 50%),
inset: (top: 0.6em, bottom: 0.6em),
align: (left, left),
stroke: (
    bottom: 0.5pt + gradient.linear(red, blue, green),
    top: none,
    left: none,
    right: none,
),
[- *Số hóa* quy trình quản lý.],
[- *Chuyển đổi số* cách làm dịch vụ.],
[- Xây dựng *điểm chạm* số.],
[- Tìm kiếm, sử dụng, đánh giá.]
)
```

# PHÂN TÍCH VÀ THIẾT KẾ

## Nghiệp Vụ

```{=typst}
#table(
  columns: (10%, 90%),
    inset: (top: 0.4em, bottom: 0.4em),
    align: (right, left),
    stroke: (
        bottom: 0.5pt + gradient.linear(red, blue, green),
        top: none,
        left: none,
        right: none,
    ),
    [], [- Quản lý phòng và loại phòng (BMS).],
    [], [- Quản lý khách hàng (BMS).],
    [], [- Quản lý đặt phòng (BMS).],
    [], [- Kiểm tra phòng trống (BMS & Khách Hàng).],
    [], [- Đặt phòng và hủy đặt phòng (Khách Hàng).],
    [], [- Hoàn tiền và hủy giao dịch theo chính sách.],
    [], [- Quản lý và phân quyền người dùng (Admin / Staff / End User).],
    [], [- Hiển thị trạng thái đặt phòng và thanh toán (Khách Hàng).],
    [], [- Hệ thống khuyến mãi & mã giảm giá (Vouchers).],
    [], [- Quản lý dịch vụ đi kèm như ăn sáng, giặt ủi, đưa đón sân bay.],
    [], [- Hệ thống đánh giá & phản hồi sau khi hoàn tất thanh toán.],
    [], [- Thanh toán trực tuyến (mô phỏng).],
)
```

## Mô Hình ER (Quan Niệm)

```{=typst}
#align(center)[
    #image("diagrams/ch02-concept-erd.svg")
]
```

## Mô Hình Logic - Bảng và Khóa

```{=typst}
#show table.cell: set text(size: 0.6em, weight: "light", font: body-font)
#table(
  columns: (5%, 95%),
    inset: (top: 0.5em, bottom: 0.5em),
    align: (right, left),
    stroke: (
        bottom: 0.5pt + gradient.linear(red, blue, green),
        top: none,
        left: none,
        right: none,
    ),
    [1], [ADMINS(#underline[id], email, password_hash, full_name, status, created_at, updated_at)],
    [2], [DATPHONG(#underline[id], #emph[user_id], #emph[voucher_id], check_in, check_out, trang_thai, created_at)],
    [3], [DICHVU(#underline[id], ten_dich_vu, don_gia, don_vi_tinh, trang_thai, created_at, updated_at)],
    [4], [LOAIPHONG(#underline[id], ten_loai, gia_co_ban, mo_ta, suc_chua)],
    [5], [PAYMENTS(#underline[id], #emph[booking_id], #emph[user_id], so_tien, phuong_thuc, trang_thai, created_at)],
    [6], [PERMISSIONS(#underline[id], code, description)],
    [7], [PHONG(#underline[id], so_phong, #emph[loai_phong_id], trang_thai)],
    [8], [REFUNDS(#underline[id], #emph[payment_id], #emph[requested_by], #emph[approved_by], so_tien_hoan, ly_do, trang_thai, created_at, updated_at)],
    [9], [REVIEWS(#underline[id], #emph[user_id], #emph[phong_id], #emph[datphong_id], so_sao, binh_luan, ngay_danh_gia, trang_thai, created_at, updated_at)],
    [10], [ROLES(#underline[id], code, name, description)],
    [11], [USERS(#underline[id], email, phone, password_hash, full_name, status, created_at, updated_at)],
    [12], [VOUCHERS(#underline[id], ma_code, phan_tram_giam, ngay_het_han, so_tien_toi_thieu, so_lan_toi_da, so_lan_da_dung, trang_thai, created_at, updated_at)],
    [13], [ADMIN_ROLES(#underline[admin_id], #underline[role_id])],
    [14], [ROLE_PERMISSIONS(#underline[role_id], #underline[permission_id])],
    [15], [CT_DATPHONG(#underline[id], #emph[datphong_id], #emph[phong_id], don_gia)],
    [16], [CT_SUDUNG_DV(#underline[id], #emph[datphong_id], #emph[dichvu_id], so_luong, don_gia, thoi_diem_su_dung, ghi_chu, created_at)]
)
```

# CÀI ĐẶT VÀ TRIỂN KHAI

## Mô Hình Vật Lý

```{=typst}
- #lorem(10)
```

## Triển Khai

```{=typst}
- #lorem(10)
```

# QUẢN LÝ THÔNG TIN

## Xử Lý Thông Tin

(Mỗi mục sau sẽ được chuyển thành slide riêng)

### Stored Procedures (5)

#### SP1: ApplyVoucher

```{=typst}
- #lorem(10)
#pagebreak()
```

#### SP2: BookingRoom

```{=typst}
- #lorem(10)
#pagebreak()
```

#### SP3: Checkout

```{=typst}
- #lorem(10)
#pagebreak()
```

#### SP4: Payment

```{=typst}
- #lorem(10)
#pagebreak()
```

#### SP5: RegisterUser

```{=typst}
- #lorem(10)
#pagebreak()
```

#### SPx: Review Room

```{=typst}
- #lorem(10)
#pagebreak()
```

#### SPx: Service

```{=typst}
- #lorem(10)
#pagebreak()
```

### Triggers (5)

#### TG1: AutoPrice

```{=typst}
- #lorem(10)
#pagebreak()
```

#### TG2: CheckTime

```{=typst}
- #lorem(10)
#pagebreak()
```

#### TG3: Payment

```{=typst}
- #lorem(10)
#pagebreak()
```

#### TG4: Refund

```{=typst}
- #lorem(10)
#pagebreak()
```

#### TG5: SyncStatus

```{=typst}
- #lorem(10)
#pagebreak()
```

### Functions (3)

#### F1: CheckRoomAvailable

```{=typst}
- #lorem(10)
#pagebreak()
```

#### F2: RevertCreateError

```{=typst}
- #lorem(10)
#pagebreak()
```

#### F3

```{=typst}
- #lorem(10)
#pagebreak()
```

### Cursors (2)

#### C1: SyncRoomStatus

```{=typst}
- #lorem(10)
#pagebreak()
```

#### C2: UpdateStatusWhenOverdue

```{=typst}
- #lorem(10)
#pagebreak()
```

## Trình Bày Thông Tin

### Report

```{=typst}
- #lorem(10)
```

# KẾT LUẬN

## Phần Đã Đạt Được

```{=typst}
- #lorem(10)
```

## Phần Chưa Đạt Được

```{=typst}
- #lorem(10)
```

## Mở Rộng & Nâng Cấp

```{=typst}
- #lorem(10)
```
