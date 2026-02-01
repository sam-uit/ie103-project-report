#import "../template/lib.typ": *

= GIỚI THIỆU
<gioi-thieu>


== Lời Cảm Ơn
<loi-cam-on>


=== Giảng Viên
<giang-vien>

#show table.cell: set text(weight: "light", font: body-font)
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
    columns: (5%, 15%, 25%, 5%, 15%, 35%),
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

#align(center)[
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
        [Các Doanh Nghiệp vừa và nhỏ trong ngành Khách Sạn, Du Lịch:]
    )
]
#table(
columns: (45%, 55%),
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
#align(center)[
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
        [Hệ Thống Quản Lý Đặt Phòng #emph[(Booking Management System)]:]
    )
]
#table(
columns: (45%, 55%),
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


== Chức Năng Nghiệp Vụ
<chuc-nang-nghiep-vu>

#show table.cell: set text(size: 0.9em, weight: "light", font: body-font)
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

#show table.cell: set text(size: 1.5em, weight: "light", font: body-font)
#table(
columns: (100%),
inset: (bottom: 0.6em),
align: (left),
stroke: (
    bottom: 0.5pt + gradient.linear(red, blue, green),
    top: none,
    left: none,
    right: none,
),
[- Hiện thực hóa mô hình logic.],
[- Sẵn sàng triển khai trên Hệ Quản Trị CSDL cụ thể.]
)
#align(center)[
    #table(
        columns: (100%),
        inset: (bottom: 0.6em),
        align: (center),
        stroke: (
            bottom: 0.5pt + gradient.linear(red, blue, green),
            top: none,
            left: none,
            right: none,
        ),
        [Ví dụ về *Mô Hình Vật Lý* của một bảng trong CSDL: ADMINS]
    )
]
#align(center + bottom)[
#show table.cell: set text(size: 0.9em, weight: "light", font: body-font)
#table(
    columns: (20%, 20%, 30%, 30%),
    align: (left, left, left, left),
    stroke: (
        bottom: 0.5pt + gradient.linear(red, blue, green),
        top: none,
        left: none,
        right: none,
    ),
    [#strong[Thuộc Tính]], [#strong[Kiểu]], [#strong[Ràng Buộc]], [#strong[Mô Tả]], [`id`], [`INT`], [`PK`, `IDENTITY`], [Khóa chính tự tăng.], [`email`], [`NVARCHAR(255)`], [`NOT NULL`, `UNIQUE`], [Email đăng nhập.], [`password_hash`], [`NVARCHAR(255)`], [`NOT NULL`], [Mật khẩu (Hash).], [`full_name`], [`NVARCHAR(255)`], [`NULL`], [Họ tên đầy đủ.], [`status`], [`NVARCHAR(50)`], [`DEFAULT 'ACTIVE'`], [Trạng thái tài khoản.], [`created_at`], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày tạo.], [`updated_at`], [`DATETIME`], [`DEFAULT GETDATE()`], [Ngày cập nhật.], [#emph[CONSTRAINT]], [], [`status IN ('ACTIVE', 'INACTIVE')`], [Chỉ nhận giá trị quy định.]
  )
]

== Triển Khai
<trien-khai>

#align(center)[
    #table(
        columns: (100%),
        inset: (bottom: 0.6em),
        align: (left),
        stroke: (
            bottom: 0.5pt + gradient.linear(red, blue, green),
            top: none,
            left: none,
            right: none,
        ),
        [- Hệ Quản Trị CSDL: Microsoft SQL Server 2019.]
    )
]

=== Khởi Tạo Database
<khoi-tao-database>

#align(center)[
    #table(
        columns: (100%),
        inset: (bottom: 0.6em),
        align: (left),
        stroke: (
            bottom: 0.5pt + gradient.linear(red, blue, green),
            top: none,
            left: none,
            right: none,
        ),
        [- Khởi tạo: Database, tên `ROOM_BOOKING_SYSTEM`.]
    )
]
#v(2em)
#align(center)[
#show raw: set text(size: 1em, weight: "light", font: "Iosevka")
#raw(read("code/slide-create-database.sql"), lang: "sql", block: true)
]

=== Khởi Tạo Các Bảng
<khoi-tao-cac-bang>

#align(center)[
    #table(
        columns: (100%),
        inset: (bottom: 0.6em),
        align: (left),
        stroke: (
            bottom: 0.5pt + gradient.linear(red, blue, green),
            top: none,
            left: none,
            right: none,
        ),
        [- Khai báo và khởi tạo bảng: tổng 16.]
    )
]
#align(center)[
    #table(
        columns: (100%),
        inset: (bottom: 0.6em),
        align: (center),
        stroke: (
            bottom: 0.5pt + gradient.linear(red, blue, green),
            top: none,
            left: none,
            right: none,
        ),
        [Ví dụ về *Khởi Tạo Bảng*: ADMINS.]
    )
]
#align(center + bottom)[
#show raw: set text(size: 0.9em, weight: "light", font: "Iosevka")
#raw(read("code/slide-create-table-admins.sql"), lang: "sql", block: true)
]

= QUẢN LÝ THÔNG TIN
<quan-ly-thong-tin>


== Xử Lý Thông Tin - (SP) Đặt Phòng
<xu-ly-thong-tin-sp-dat-phong>

#grid(
  columns: (40%, 60%),
  rows: (auto),
  [Thực hiện chức năng #emph[đặt phòng] cho người dùng:
    - Kiểm tra phòng tồn tại và khả dụng.
    - Tạo bản ghi đặt phòng.
    - Lưu chi tiết phòng.
    - Cập nhật trạng thái phòng.
  ],
  [
    #align(center)[
      #figure(image("demo/SP_DATPHONG.png"),
      caption: [(SP) Đặt Phòng],
      supplement: "Ảnh"
      )]
  ],
)

== Xử Lý Thông Tin - (SP) Thanh Toán
<xu-ly-thong-tin-sp-thanh-toan>

#grid(
  columns: (40%, 60%),
  rows: (auto),
  [Thực hiện chức năng #emph[thanh toán] cho người dùng:
    - Kiểm tra booking hợp lệ.
    - Kiểm tra số tiền thanh toán có đúng với số tiền cần trả.
    - Lưu lịch sử thanh toán.
    - Cập nhật trạng thái booking khi thanh toán hoàn tất.
  ],
  [
    #align(center)[
      #figure(image("demo/SP_THANHTOAN-03.png"),
      caption: [(SP) Thanh Toán],
      supplement: "Ảnh"
      )]
  ],
)

== Xử Lý Thông Tin - (SP) Đánh Giá
<xu-ly-thong-tin-sp-danh-gia>

#grid(
  columns: (40%, 60%),
  rows: (auto),
  [Thực hiện chức năng #emph[đánh giá] cho người dùng:
    - Đảm bảo chỉ đánh giá khi đã ở xong.
    - Mỗi đặt phòng chỉ được đánh giá #emph[1 lần].
    - Lưu đánh giá ở trạng thái chờ duyệt (CHO_XU_LY).
    - Hỗ trợ quản trị viên kiểm duyệt nội dung.
  ],
  [
    #align(center)[
      #figure(image("demo/SP_DANHGIA.png"),
      caption: [(SP) Đánh Giá],
      supplement: "Ảnh"
      )]
  ],
)

== Xử Lý Thông Tin - (SP) Áp Dụng Voucher
<xu-ly-thong-tin-sp-ap-dung-voucher>

#grid(
  columns: (40%, 60%),
  rows: (auto),
  [Áp dụng mã giảm giá (voucher) cho một đặt phòng và tự động tính toán số tiền giảm giá:
    - Mỗi đặt phòng chỉ có thể áp dụng tối đa một mã giảm giá.
    - Mã giảm giá phải còn hạn sử dụng và chưa hết số lượng.
    - Tổng tiền đặt phòng phải đạt mức tối thiểu để áp dụng voucher.
    - Chỉ áp dụng được khi đặt phòng ở trạng thái PENDING.
  ],
  [
    #align(center)[
      #figure(image("demo/SP_AP_DUNG_VOUCHER-02.png"),
      caption: [(SP) Áp Dụng Voucher],
      supplement: "Ảnh"
      )]
  ],
)

== Xử Lý Thông Tin - (SP) Sử Dụng Dịch Vụ
<xu-ly-thong-tin-sp-su-dung-dich-vu>

#grid(
  columns: (40%, 60%),
  rows: (auto),
  [Ghi nhận việc khách hàng sử dụng dịch vụ đi kèm trong thời gian lưu trú.:
    - Khách hàng có thể gọi dịch vụ đi kèm bất cứ lúc nào trong thời gian lưu trú.
    - Mỗi lần gọi dịch vụ được ghi nhận riêng biệt.
    - Đơn giá được lưu lại tại thời điểm sử dụng (tránh thay đổi giá sau này ảnh hưởng đến hóa đơn).
  ],
  [
    #align(center)[
      #figure(image("demo/SP_SU_DUNG_DICH_VU-02.png"),
      caption: [(SP) Sử Dụng Dịch Vụ],
      supplement: "Ảnh"
      )]
  ],
)

== Xử Lý Thông Tin - (TRG) Kiểm Tra Thời Gian
<xu-ly-thong-tin-trg-kiem-tra-thoi-gian>

#grid(
  columns: (40%, 60%),
  rows: (auto),
  [Kiểm tra thời gian check-out lớn hơn check-in:
    - Đảm bảo thời gian check-out lớn hơn check-in.
    - Ngăn chặn dữ liệu không hợp lệ được lưu vào cơ sở dữ liệu.
    - Báo lỗi rõ ràng cho người dùng khi nhập sai.
  ],
  [
    #align(center)[
      #figure(image("demo/TRG-01-CHECKTIME.png"),
      caption: [(TRG) Kiểm Tra Thời Gian],
      supplement: "Ảnh"
      )]
  ],
)

== Xử Lý Thông Tin - (TRG) Tính Đơn Giá
<xu-ly-thong-tin-trg-tinh-don-gia>

#grid(
  columns: (40%, 60%),
  rows: (auto),
  [Tự động tính đơn giá khi đặt phòng:
    - Chỉ cho phép đặt phòng có trạng thái AVAILABLE.
    - Lấy giá từ bảng LOAIPHONG và tính đơn giá.
    - Đảm bảo tính nhất quán của dữ liệu.
  ],
  [
    #align(center)[
      #figure(image("demo/TRG-02-AUTOPRICE.png"),
      caption: [(TRG) Tính Đơn Giá],
      supplement: "Ảnh"
      )]
  ],
)

== Xử Lý Thông Tin - (TRG) Đồng Bộ Trạng Thái
<xu-ly-thong-tin-trg-dong-bo-trang-thai>

#grid(
  columns: (40%, 60%),
  rows: (auto),
  [Đồng bộ trạng thái phòng khi có thay đổi trong chi tiết đặt phòng:
    - Phòng được đặt $\to$ Cần chuyển trạng thái sang OCCUPIED.
    - Phòng bị hủy đặt $\to$ Cần trả về trạng thái AVAILABLE.
    - Đảm bảo đồng bộ thời gian thực.
  ],
  [
    #align(center)[
      #figure(image("demo/TRG-03-SYNCSTATUS.png"),
      caption: [(TRG) Đồng Bộ Trạng Thái],
      supplement: "Ảnh"
      )]
  ],
)

== Xử Lý Thông Tin - (TRG) Kiểm Tra Thanh Toán
<xu-ly-thong-tin-trg-kiem-tra-thanh-toan>

#grid(
  columns: (40%, 60%),
  rows: (auto),
  [Đảm bảo tính chính xác của số tiền thanh toán:
    - Số tiền thanh toán phải bằng tổng đơn giá các phòng đã đặt.
    - Tự động chuyển trạng thái đặt phòng sang PAID.
    - Không cho thanh toán sai số tiền.
  ],
  [
    #align(center)[
      #figure(image("demo/TRG-04-PAYMENT.png"),
      caption: [(TRG) Kiểm Tra Thanh Toán],
      supplement: "Ảnh"
      )]
  ],
)

== Xử Lý Thông Tin - (TRG) Kiểm Tra Hoàn Tiền
<xu-ly-thong-tin-trg-kiem-tra-hoan-tien>

#grid(
  columns: (40%, 60%),
  rows: (auto),
  [Quản lý quy trình hoàn tiền an toàn và chính xác:
    - Không được vượt quá số tiền đã thanh toán.
    - Không được hoàn tiền khi đặt phòng chưa thanh toán.
    - Cập nhật PAYMENTS.trang_thai = 'REFUNDED' và DATPHONG.trang_thai = 'REFUNDED'.
  ],
  [
    #align(center)[
      #figure(image("demo/TRG-05-REFUND.png"),
      caption: [(TRG) Kiểm Tra Hoàn Tiền],
      supplement: "Ảnh"
      )]
  ],
)

== Xử Lý Thông Tin - (FN) Tính Hạng Thành Viên
<xu-ly-thong-tin-fn-tinh-hang-thanh-vien>

#grid(
  columns: (40%, 60%),
  rows: (auto),
  [Tính toán và cập nhật hạng thành viên dựa trên tổng chi tiêu:
    - < 5.000.000 VNĐ: *STANDARD*.
    - 5.000.000 - 20.000.000 VNĐ: *GOLD*.
    - > 20.000.000 VNĐ: *PLATINUM*.
  ],
  [
    #align(center)[
      #figure(image("demo/FN-01-TinhHangThanhVien-01.png"),
      caption: [(FN) Tính Hạng Thành Viên],
      supplement: "Ảnh"
      )]
  ],
)

== Xử Lý Thông Tin - (FN) Tìm Phòng Trống
<xu-ly-thong-tin-fn-tim-phong-trong>

#grid(
  columns: (40%, 60%),
  rows: (auto),
  [Tìm kiếm phòng trống dựa trên loại phòng trong khoảng thời gian yêu cầu:
    - Chỉ hiển thị phòng có trạng thái AVAILABLE.
    - Lấy thông tin từ bảng LOAIPHONG và PHONG.
    - Bỏ qua các đơn đặt phòng đã bị Hủy hoặc Hoàn tiền.
  ],
  [
    #align(center)[
      #figure(image("demo/FN-02-TimPhongTrongTheoLoai.png"),
      caption: [(FN) Tìm Phòng Trống],
      supplement: "Ảnh"
      )]
  ],
)

== Xử Lý Thông Tin - (FN) Phí Hủy Đặt Phòng
<xu-ly-thong-tin-fn-phi-huy-dat-phong>

#grid(
  columns: (40%, 60%),
  rows: (auto),
  [Tính toán phí hủy dựa trên thời điểm hủy:
    - Tính khoảng cách ngày: Số ngày = Ngày Check-in - Ngày Báo Hủy.
    - Trước 1 ngày: 100%.
    - Trong vòng 1 - 3 ngày: 50%.
    - Sau 3 ngày: 0%.
  ],
  [
    #align(center)[
      #figure(image("demo/FN-03-TinhPhiHuyPhong-02.png"),
      caption: [(FN) Tính Phí Hủy Đặt Phòng],
      supplement: "Ảnh"
      )]
  ],
)

== Xử Lý Thông Tin - (CR) Hoàn Tất Đặt Phòng
<xu-ly-thong-tin-cr-hoan-tat-dat-phong>

#grid(
  columns: (40%, 60%),
  rows: (auto),
  [Tự động hoàn tất đơn đặt phòng khi quá hạn:
    - Tự động hóa việc kết thúc quy trình đặt phòng.
    - Quét các đơn đặt phòng đã quá hạn trả phòng (Check-out) nhưng trạng thái vẫn là CONFIRMED để chuyển sang COMPLETED và giải phóng phòng.
  ],
  [
    #align(center)[
      #figure(image("demo/C-UpdateStatusWhenOverdue02.png"),
      caption: [(CR) Hoàn Tất Đặt Phòng],
      supplement: "Ảnh"
      )]
  ],
)

== Xử Lý Thông Tin - (CR) Đồng Bộ Trạng Thái
<xu-ly-thong-tin-cr-dong-bo-trang-thai>

#grid(
  columns: (40%, 60%),
  rows: (auto),
  [Đảm bảo tính nhất quán của dữ liệu giữa các module:
    - Khi có thay đổi trong module đặt phòng (ví dụ: hủy đặt phòng), trạng thái phòng phải được cập nhật ngay lập tức.
    - Tránh tình trạng dữ liệu không đồng bộ gây ra lỗi logic.
  ],
  [
    #align(center)[
      #figure(image("demo/C-SyncRoomStatus04.png"),
      caption: [(CR) Đồng Bộ Trạng Thái],
      supplement: "Ảnh"
      )]
  ],
)

== Trình Bày Thông Tin - Thống Kê Doanh Thu
<trinh-bay-thong-tin-thong-ke-doanh-thu>

#grid(
  columns: (40%, 60%),
  rows: (auto),
  [Thống kê doanh thu từng tháng trong năm, và doanh thu của từng phòng trong tháng.
  - Thể hiện dưới dạng biểu đồ cột và bảng chi tiết.
  - Để đánh giá xem phòng nào ít khách đặt để tìm ra lý do.
  - Hoặc thay đổi loại phòng theo xu hướng của khách.
  ],
  [
    #align(center)[
      #figure(image("./images/rpt1-7.png"),
      caption: [Báo Cáo 01 - Thống Kê Doanh Thu],
      supplement: "Ảnh"
      )]
  ],
)

== Trình Bày Thông Tin - Top Khách Hàng
<trinh-bay-thong-tin-top-khach-hang>

#grid(
  columns: (40%, 60%),
  rows: (auto),
  [Top khách hàng chi tiêu nhiều nhất
  - Đánh giá xem khách hàng thân thiết để tặng voucher hay là nâng hạng khách hàng.
  - Thể hiện dưới dạng biểu đồ line và bảng chi tiết.
  ],
  [
    #align(center)[
      #figure(image("./images/rpt2-11.png"),
      caption: [Báo Cáo 02 - Top Khách Hàng Chi Tiêu],
      supplement: "Ảnh"
      )]
  ],
)

== Trình Bày Thông Tin - Doanh Thu Dịch Vụ
<trinh-bay-thong-tin-doanh-thu-dich-vu>

#grid(
  columns: (40%, 60%),
  rows: (auto),
  [Dịch vụ nào được ưa chuộng nhất" (Best Seller).
  - Có kế hoạch nhập hàng và đẩy mạnh khuyến mãi.
  - Thể hiện dưới dạng biểu đồ pie và bảng chi tiết.
  ],
  [
    #align(center)[
      #figure(image("./images/rpt3-9.png"),
      caption: [Báo Cáo 03 - Thống Kê Doanh Thu Dịch Vụ],
      supplement: "Ảnh"
      )]
  ],
)

== Trình Bày Thông Tin - Top Voucher
<trinh-bay-thong-tin-top-voucher>

#figure(image("./images/rpt4-6.png"),
  caption: [
    Báo Cáo 04 - Thống Kê Top Voucher.
  ]
)

== Trình Bày Thông Tin - Top Loại Phòng
<trinh-bay-thong-tin-top-loai-phong>

#figure(image("./images/rpt5-6.png"),
  caption: [
    Báo Cáo 05 - Top Loại Phòng Được Yêu Thích Nhất.
  ]
)

= KẾT LUẬN
<ket-luan>


== Phần Đã Đạt Được
<phan-da-dat-duoc>

#align(center)[
    #table(
        columns: (100%),
        inset: (bottom: 0.6em),
        align: (left),
        stroke: (
            bottom: 0.5pt + gradient.linear(red, blue, green),
            top: none,
            left: none,
            right: none,
        ),
        [- Chuẩn hóa quy trình nghiệp vụ.],
        [- Thiết kế bộ khung CSDL.],
        [- Xử lý thông tin tự động.],
        [- Cơ chế bảo mật đa lớp.],
        [- Khả năng sẵn sàng, sao lưu/dự phòng.],
    )
]

== Phần Chưa Đạt Được
<phan-chua-dat-duoc>

- Giao diện cho người dùng cuối.
- Các kênh thanh toán thực thế.
- Quản lý vòng đời tài khoản/người dùng.

== Mở Rộng & Nâng Cấp
<mo-rong-nang-cap>

- #strong[Web App]:
  - #emph[Nhân Viên] (#emph[Bộ Phận Quản Lý/Lễ Tân])
  - Thao tác nghiệp vụ nhanh chóng và chính xác.
- #strong[Mobile App]:
  - #emph[Khách Hàng] (End User)
  - #emph["điểm chạm số"].
  - Tìm phòng, đặt phòng và theo dõi lịch sử tích điểm ngay trên điện thoại.
