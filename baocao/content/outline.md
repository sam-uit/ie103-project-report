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
  #show table.cell: current_cell => {
    if current_cell.x in (0,) {
      text(
        weight: "light",
        fill: gray,
      )[#current_cell]
    } else {
      current_cell
    }
  }
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

## Mô Hình Quan Niệm

```{=typst}
- #lorem(10)
```

## Mô Hình Logic

```{=typst}
- #lorem(10)
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
