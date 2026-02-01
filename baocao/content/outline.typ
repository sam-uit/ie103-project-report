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


=== Đặt Vấn Đề
<dat-van-de>

#align(center)[Các Doanh Nghiệp vừa và nhỏ trong ngành Khách Sạn, Nhà Nghỉ.]
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

=== Giới Thiệu Đề Tài
<gioi-thieu-de-tai>

#align(center)[*Hệ Thống Quản Lý Đặt Phòng* #emph[(Booking Management System)].]
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

= PHÂN TÍCH VÀ THIẾT KẾ
<phan-tich-va-thiet-ke>


== Nghiệp Vụ
<nghiep-vu>

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

== Mô Hình ER (Quan Niệm)
<mo-hinh-er-quan-niem>

#align(center)[
    #image("diagrams/ch02-concept-erd.svg")
]

== Mô Hình Logic - Bảng và Khóa
<mo-hinh-logic-bang-va-khoa>

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

= CÀI ĐẶT VÀ TRIỂN KHAI
<cai-dat-va-trien-khai>


== Mô Hình Vật Lý
<mo-hinh-vat-ly>

- Hiện thực hóa mô hình logic.
- Sẵn sàng triển khai trên Hệ Quản Trị CSDL cụ thể.

#align(center + bottom)[
Ví dụ về *Mô Hình Vật Lý* của một bảng trong CSDL.
#show table.cell: set text(size: 1em, weight: "light", font: body-font)
#figure(
  table(
    columns: (20%, 20%, 30%, 30%),
    align: (left, left, left, left),
    stroke: (
        bottom: 0.5pt + gradient.linear(red, blue, green),
        top: none,
        left: none,
        right: none,
    ),
    [#strong[Thuộc Tính]], [#strong[Kiểu]], [#strong[Ràng Buộc]], [#strong[Mô Tả]], [`id`], [`INT`], [`PK`, `IDENTITY`], [Khóa chính tự tăng.], [`email`], [`NVARCHAR(255)`], [`NOT NULL`, `UNIQUE`], [Email đăng nhập.], [`password_hash`], [`NVARCHAR(255)`], [`NOT NULL`], [Mật khẩu (Hash).], [`full_name`], [`NVARCHAR(255)`], [`NULL`], [Họ tên đầy đủ.], [`status`], [`NVARCHAR(50)`], [`DEFAULT 'ACTIVE'`], [Trạng thái tài khoản.], [`created_at`], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [`updated_at`], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày cập nhật.], [#emph[CONSTRAINT]], [], [`status IN ('ACTIVE', 'INACTIVE')`], [Chỉ nhận giá trị quy định.]
  ),
  caption: [Mô Hình Mức Vật Lý: ADMINS],
)
]

== Triển Khai
<trien-khai>

- Hệ Quản Trị CSDL: Microsoft SQL Server 2019.

=== Khởi Tạo Database
<khoi-tao-database>

- Khởi tạo: Database, tên `ROOM_BOOKING_SYSTEM`.

#v(4em)
#align(center)[
#show raw: set text(size: 1em, weight: "light", font: "Iosevka")
#figure(
    raw(read("code/slide-create-database.sql"), lang: "sql", block: true),
  caption: [Khởi Tạo Database: `ROOM_BOOKING_SYSTEM`],
  supplement: "Mã Nguồn"
)
]

#pagebreak()

=== Khởi Tạo Các Bảng
<khoi-tao-cac-bang>

- Khai báo và khởi tạo bảng: tổng 16.

#align(center + bottom)[
Ví dụ về *Khởi Tạo Bảng*: ADMINS.
#show raw: set text(size: 1em, weight: "light", font: "Iosevka")
#figure(
    raw(read("code/slide-create-table-admins.sql"), lang: "sql", block: true),
  caption: [Khởi Tạo CSDL: ADMINS],
  supplement: "Mã Nguồn"
)
]

= QUẢN LÝ THÔNG TIN
<quan-ly-thong-tin>


== Xử Lý Thông Tin - (SP) Đặt Phòng
<xu-ly-thong-tin-sp-dat-phong>

#figure(image("demo/SP_DATPHONG.png"),
  caption: [
    SP\_DATPHONG - Tạo mới đơn Đặt Phòng.
  ]
)

== Xử Lý Thông Tin - (SP) Thanh Toán
<xu-ly-thong-tin-sp-thanh-toan>

#figure(image("demo/SP_THANHTOAN-03.png"),
  caption: [
    SP\_THANHTOAN - Hoàn thành Thanh Toán.
  ]
)

== Xử Lý Thông Tin - (SP) Đánh Giá
<xu-ly-thong-tin-sp-danh-gia>

#figure(image("demo/SP_DANHGIA.png"),
  caption: [
    SP\_DANHGIA - Đánh Giá đơn Đặt Phòng.
  ]
)

== Xử Lý Thông Tin - (SP) Áp Dụng Voucher
<xu-ly-thong-tin-sp-ap-dung-voucher>

#figure(image("demo/SP_AP_DUNG_VOUCHER-02.png"),
  caption: [
    SP\_AP\_DUNG\_VOUCHER - Áp Dụng Voucher
  ]
)

== Xử Lý Thông Tin - (SP) Sử Dụng Dịch Vụ
<xu-ly-thong-tin-sp-su-dung-dich-vu>

#figure(image("demo/SP_SU_DUNG_DICH_VU-02.png"),
  caption: [
    SP\_SU\_DUNG\_DICH\_VU - Sử Dụng Dịch Vụ
  ]
)

== Xử Lý Thông Tin - (TRG) Kiểm Tra Thời Gian
<xu-ly-thong-tin-trg-kiem-tra-thoi-gian>

#figure(image("demo/TRG-01-CHECKTIME.png"),
  caption: [
    TRG-01-CheckTime - Thời gian check-out lớn hơn check-in
  ]
)

== Xử Lý Thông Tin - (TRG) Tính Đơn Giá
<xu-ly-thong-tin-trg-tinh-don-gia>

#figure(image("demo/TRG-02-AUTOPRICE.png"),
  caption: [
    TRG-02-AutoPrice - Tự Động Tính Đơn Giá
  ]
)

== Xử Lý Thông Tin - (TRG) Đồng Bộ Trạng Thái
<xu-ly-thong-tin-trg-dong-bo-trang-thai>

#figure(image("demo/TRG-03-SYNCSTATUS.png"),
  caption: [
    TRG-03-SyncStatus - Đồng bộ trạng thái Phòng
  ]
)

== Xử Lý Thông Tin - (TRG) Kiểm Tra Thanh Toán
<xu-ly-thong-tin-trg-kiem-tra-thanh-toan>

#figure(image("demo/TRG-04-PAYMENT.png"),
  caption: [
    TRG-04-Payment - Kiểm Tra Khi Thanh Toán
  ]
)

== Xử Lý Thông Tin - (TRG) Kiểm Tra Hoàn Tiền
<xu-ly-thong-tin-trg-kiem-tra-hoan-tien>

#figure(image("demo/TRG-05-REFUND.png"),
  caption: [
    TRG-05-Refund - Kiểm Tra Hoàn Tiền
  ]
)

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
