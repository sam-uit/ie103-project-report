#import "../template/lib.typ": *
#import "../config/metadata.typ": *

// YOUR CONTENT HERE

= #data.author.name

Thành viên của nhóm và bảng nhiệm vụ.

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
      [- Tổng hợp & Biên tập.],
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
  caption: [#data.author.name],
  outlined: false, // Hides it from the List of Tables
  numbering: none, // Hides the "Table X:" prefix (optional)
)
