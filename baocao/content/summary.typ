#import "/template/lib.typ": *
#import "/config/metadata.typ": data

= BÁO CÁO TÓM TẮT

== 1. Tiêu đề báo cáo: #upper[#data.assignment.subtitle]
== 2. Danh sách thành viên

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
      columns: (10%, 15%, 35%, 45%),
      align: (right, right, left, left),
      table.header([No], [MSSV], [Họ và Tên], [Ghi Chú]),
      table.hline(),
      [01],
      [15410301],
      [Nguyễn Văn A],
      [],
      [02],
      [15410319],
      [Trần Minh Tuấn],
      [],
      [03],
      [15410321],
      [Lê Hoàng Phúc],
      [],
      [04],
      [15410204],
      [Phạm Minh Tuấn],
      [],
      [05],
      [15410338],
      [Lê Trần Minh Nhật],
      [],
      [06],
      [15410176],
      [Phan Văn Dũng],
      [],
      [07],
      [15410247],
      [Trần Thị Bích Ngọc],
      [],
      [08],
      [15410337],
      [Võ Thị Thu Hà],
      [],
      [09],
      [15410209],
      [Võ Nguyễn Thành Vinh],
      [],
      [10],
      [15410271],
      [Lê Thị Bảo Trân],
      [],
    )],
  kind: table,
  caption: [Danh Sách Thành Viên],
  outlined: false, // Hides it from the List of Tables
  numbering: none, // Hides the "Table X:" prefix (optional)
)

== 3. Nội dung chi tiết

=== Nội dung 1:

+ Đề mục 1:
+ Đề mục 2:
+ Đề mục 3:

=== Nội dung 2:

+ Đề mục 1:
+ Đề mục 2:
+ Đề mục 3:

=== Nội dung 3:

+ Đề mục 1:
+ Đề mục 2:
+ Đề mục 3:

== 4. Phân công công việc

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
      columns: (10%, 15%, 35%, 45%),
      align: (right, right, left, left),
      table.header([No], [MSSV], [Họ và Tên], [Phụ Trách]),
      table.hline(),
      [01],
      [15410301],
      [Nguyễn Văn A],
      [],
      [02],
      [15410319],
      [Trần Minh Tuấn],
      [],
      [03],
      [15410321],
      [Lê Hoàng Phúc],
      [],
      [04],
      [15410204],
      [Phạm Minh Tuấn],
      [],
      [05],
      [15410338],
      [Lê Trần Minh Nhật],
      [],
      [06],
      [15410176],
      [Phan Văn Dũng],
      [],
      [07],
      [15410247],
      [Trần Thị Bích Ngọc],
      [],
      [08],
      [15410337],
      [Võ Thị Thu Hà],
      [],
      [09],
      [15410209],
      [Võ Nguyễn Thành Vinh],
      [],
      [10],
      [15410271],
      [Lê Thị Bảo Trân],
      [],
    )],
  kind: table,
  caption: [Phân Công Công Việc],
  outlined: false, // Hides it from the List of Tables
  numbering: none, // Hides the "Table X:" prefix (optional)
)
