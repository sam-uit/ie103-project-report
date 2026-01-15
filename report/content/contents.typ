#import "@preview/touying:0.6.1": *
#import themes.stargazer: *
#import "../config/metadata.typ": *

// TODO: Use the config/metadata file.

= Giới Thiệu

== Lời Cảm Ơn

=== Giảng Viên

- #data.instructor

=== Nhà Trường

- #data.university.name

=== Công Ty

- #data.company

== Nhóm 1

#align(center)[
  #show table.cell: current_cell => {
    if current_cell.x in (0, 1, 3, 4) {
      text(
        font: "Iosevka",
        weight: "light",
        size: 0.9em,
        fill: gray,
      )[#current_cell]
    } else {
      current_cell
    }
  }
  #table(
    columns: (auto, auto, auto, auto, auto, auto),
    inset: 0.5em,
    align: (right, right, left, right, right, left),
    stroke: (
      bottom: 0.5pt + gradient.linear(red, blue, green),
      top: none,
      left: none,
      right: none,
    ),
    [01], [25410291], [_Đinh Xuân Sâm_], [09], [25410213], [Phan Chí Hiếu],
    [02], [25410240], [_Nguyễn Tạ Quí Lan_], [10], [25410220], [Vũ Huy Hoàng],
    [03], [25410179], [Giang Hải Chương], [11], [25410239], [Phạm Tuấn Kiệt],
    [04], [25410171], [Lê Thị Tú Anh], [12], [25410244], [Nguyễn Thành Lộc],
    [05], [25410338], [Lê Anh Vũ], [13], [25410319], [Đặng Hữu Toàn],
    [06], [25410183], [Nguyễn Đào Anh Đạt], [14], [25410321], [Nguyễn Điền Triết],
    [15], [25410325], [Nguyễn Văn Trung],
  )
]

= Đề Tài

== Lý Do Chọn Đề Tài

- #lorem(10)

= Các Thành Phần Của Hạ Tầng

== Hạ Tầng Phần Cứng (Hardware)

=== Tổng Quan

#align(center)[
  #grid(
    columns: (50%, 50%),
    inset: 0.5em,
    align: (left, left),
    stroke: (
      bottom: 0.5pt + gradient.linear(red, blue, green),
      top: none,
      left: none,
      right: none,
    ),
    [- Server], [- Storage],
    [- Network Devices], [- Rack],
    [- Power Supply (UPS)], [- End Devices],
    [- Air Conditioner], [- Security Room],
    [- CCTV], [- FingerPrint],
    [- Và các thành phần khác...],
  )
]

== Hạ Tầng Phần Mềm (Software)

=== Tổng Quan

#align(center)[
  #grid(
    columns: 100%,
    inset: 0.5em,
    align: (left),
    stroke: (
      bottom: 0.5pt + gradient.linear(red, blue, green),
      top: none,
      left: none,
      right: none,
    ),
    [- Phần Mềm Nền Tảng], [- Phần Mềm Quản Lý], [- Phần Mềm Ứng Dụng Và Dịch Vụ],
  )
]

=== Phần Mềm Quản Lý

- #lorem(10)

=== Phần Mềm Ứng Dụng Và Dịch Vụ

- #lorem(10)

= Quy Trình Hoạt Động

== Quản Trị Và Bảo Mật

- #lorem(10)

= Đánh Giá

== Ưu điểm

- #lorem(10)

= Kết Luận

== Đánh Giá Chung

#tblock(title: lorem(3))[
  #lorem(30)
]

== Bài Học Kinh Nghiệm

- #lorem(10)
