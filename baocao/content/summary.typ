#import "/template/lib.typ": *
#import "/config/metadata.typ": data

= BÁO CÁO TÓM TẮT

== 1. Tiêu Đề Báo Cáo: #upper[#data.assignment.subtitle]
== 2. Danh Sách Thành Viên

#figure(
  align(center)[
    // Mono font in column 0, 1
    #show table.cell: current_cell => {
      // Check if row (y > 0) AND the column is (0, 1, or 3)
      if current_cell.y > 0 and current_cell.x in (0, 1) {
        // Use a monofont: Iosevka
        text(
          font: "Iosevka",
          weight: 300,
          fill: black.lighten(40%),
        )[#current_cell]
      } else {
        // Return normal formatting for other columns
        current_cell
      }
    }
    // TODO: Span full width automatically
    // TODO: import/use csv data instead of hardcoding
    #table(
      columns: (10%, 15%, 35%, 40%),
      align: (right, right, left, left),
      table.header([*No*], [*MSSV*], [*Họ và Tên*], [*Ghi Chú*]),
      table.hline(),
      [1], [25410291], [Đinh Xuân Sâm], [],
      [2], [25410319], [Đặng Hữu Toàn], [],
      [3], [25410321], [Nguyễn Điền Triết], [],
      [4], [25410204], [Trương Xuân Hậu], [],
      [5], [25410338], [Lê Anh Vũ], [],
      [6], [25410176], [Trần Sơn Bình], [],
      [7], [25410247], [Lê Kim Long], [],
      [8], [25410337], [La Anh Vũ], [],
      [9], [25410209], [Lê Ngọc Hiệp], [],
      [10], [25410271], [Nguyễn Thị Ngọc Nhung], [],
    )],
  kind: table,
  caption: [Danh Sách Thành Viên],
  outlined: false, // Hides it from the List of Tables
  numbering: none, // Hides the "Table X:" prefix (optional)
)

== 3. Nội Dung Chi Tiết

=== Mô Tả Bài Toán:

+ Tổng Quan Về Đề Tài.
+ Phạm Vi & Đối Tượng Nghiên Cứu.
+ Mô Tả Quy Trình Nghiệp Vụ Thực Tế.

=== Phân Tích Và Thiết Kế:

+ Các Chức Năng Nghiệp Vụ.
+ Quy Tắc Nghiệp Vụ & Xác Định Thực Thể.
+ Mô Hình Mức Quan Niệm.
+ Mô Hình Mức Logic.

=== Cài Đặt -- Triển Khai:

+ Môi Trường Cài Đặt.
+ Cài Đặt Mô Hình Dữ Liệu (Mức Vật Lý).
+ Khởi Tạo Cơ Sở Dữ Liệu.
+ Thiết Lập Nền Tảng Quản Trị & Bảo Mật.
+ Dữ Liệu Mẫu.

=== Quản Lý Thông Tin

+ Xử Lý Thông Tin.
+ An Toàn Thông Tin.
+ Trình Bày Thông Tin.
+ Các Chức Năng Của Hệ Thống.

== 4. Phân Công Công Việc

#figure(
  align(center)[
    // Mono font in column 0, 1
    #show table.cell: current_cell => {
      // Check if row (y > 0) AND the column is (0, 1, or 3)
      if current_cell.y > 0 and current_cell.x in (0, 1) {
        // Use a monofont: Iosevka
        text(
          font: "Iosevka",
          weight: 300,
          fill: black.lighten(40%),
        )[#current_cell]
      } else {
        // Return normal formatting for other columns
        current_cell
      }
    }
    // TODO: Span full width automatically
    // TODO: import/use csv data instead of hardcoding
    #table(
      columns: (10%, 15%, 35%, 40%),
      align: (right, right, left, left),
      table.header([No], [MSSV], [Họ và Tên], [Phụ Trách]),
      table.hline(),
      [1],
      [25410291],
      [Đinh Xuân Sâm],
      [],
      [2],
      [25410319],
      [Đặng Hữu Toàn],
      [],
      [3],
      [25410321],
      [Nguyễn Điền Triết],
      [],
      [4],
      [25410204],
      [Trương Xuân Hậu],
      [],
      [5],
      [25410338],
      [Lê Anh Vũ],
      [],
      [6],
      [25410176],
      [Trần Sơn Bình],
      [],
      [7],
      [25410247],
      [Lê Kim Long],
      [],
      [8],
      [25410337],
      [La Anh Vũ],
      [],
      [9],
      [25410209],
      [Lê Ngọc Hiệp],
      [],
      [10],
      [25410271],
      [Nguyễn Thị Ngọc Nhung],
      [],
    )],
  kind: table,
  caption: [Phân Công Công Việc],
  outlined: false, // Hides it from the List of Tables
  numbering: none, // Hides the "Table X:" prefix (optional)
)
