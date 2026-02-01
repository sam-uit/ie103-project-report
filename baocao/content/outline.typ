#import "../template/lib.typ": *

= GIỚI THIỆU
<gioi-thieu>


== Lời Cảm Ơn
<loi-cam-on>


=== Giảng Viên
<giang-vien>

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

=== Nhà Trường
<nha-truong>

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

=== Nhóm 02
<nhom-02>

- Các thành viên của Nhóm 02.

== Nhóm 02
<nhom-02>

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

== Giới Thiệu Đề Tài
<gioi-thieu-de-tai>

- #lorem(10)

= PHÂN TÍCH VÀ THIẾT KẾ
<phan-tich-va-thiet-ke>


== Nghiệp Vụ
<nghiep-vu>

- #lorem(10)

== Mô Hình Quan Niệm
<mo-hinh-quan-niem>

- #lorem(10)

== Mô Hình Logic
<mo-hinh-logic>

- #lorem(10)

= CÀI ĐẶT VÀ TRIỂN KHAI
<cai-dat-va-trien-khai>


== Mô Hình Vật Lý
<mo-hinh-vat-ly>

- #lorem(10)

== Triển Khai
<trien-khai>

- #lorem(10)

= QUẢN LÝ THÔNG TIN
<quan-ly-thong-tin>


== Xử Lý Thông Tin
<xu-ly-thong-tin>

\(Mỗi mục sau sẽ được chuyển thành slide riêng)

=== Stored Procedures (5)
<stored-procedures-5>


==== SP1: ApplyVoucher
<sp1-applyvoucher>

- #lorem(10)
#pagebreak()

==== SP2: BookingRoom
<sp2-bookingroom>

- #lorem(10)
#pagebreak()

==== SP3: Checkout
<sp3-checkout>

- #lorem(10)
#pagebreak()

==== SP4: Payment
<sp4-payment>

- #lorem(10)
#pagebreak()

==== SP5: RegisterUser
<sp5-registeruser>

- #lorem(10)
#pagebreak()

==== SPx: Review Room
<spx-review-room>

- #lorem(10)
#pagebreak()

==== SPx: Service
<spx-service>

- #lorem(10)
#pagebreak()

=== Triggers (5)
<triggers-5>


==== TG1: AutoPrice
<tg1-autoprice>

- #lorem(10)
#pagebreak()

==== TG2: CheckTime
<tg2-checktime>

- #lorem(10)
#pagebreak()

==== TG3: Payment
<tg3-payment>

- #lorem(10)
#pagebreak()

==== TG4: Refund
<tg4-refund>

- #lorem(10)
#pagebreak()

==== TG5: SyncStatus
<tg5-syncstatus>

- #lorem(10)
#pagebreak()

=== Functions (3)
<functions-3>


==== F1: CheckRoomAvailable
<f1-checkroomavailable>

- #lorem(10)
#pagebreak()

==== F2: RevertCreateError
<f2-revertcreateerror>

- #lorem(10)
#pagebreak()

==== F3
<f3>

- #lorem(10)
#pagebreak()

=== Cursors (2)
<cursors-2>


==== C1: SyncRoomStatus
<c1-syncroomstatus>

- #lorem(10)
#pagebreak()

==== C2: UpdateStatusWhenOverdue
<c2-updatestatuswhenoverdue>

- #lorem(10)
#pagebreak()

== Trình Bày Thông Tin
<trinh-bay-thong-tin>


=== Report
<report>

- #lorem(10)

= KẾT LUẬN
<ket-luan>


== Phần Đã Đạt Được
<phan-da-dat-duoc>

- #lorem(10)

== Phần Chưa Đạt Được
<phan-chua-dat-duoc>

- #lorem(10)

== Mở Rộng & Nâng Cấp
<mo-rong-nang-cap>

- #lorem(10)
