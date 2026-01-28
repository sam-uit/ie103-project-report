#import "../template/lib.typ": *

= Quản Lý Thông Tin
<quan-ly-thong-tin>

Trên nền tảng cơ sở dữ liệu đã thiết kế, chương này trình bày các kỹ thuật xử lý dữ liệu nâng cao (Business Logic) và các chính sách an toàn thông tin được áp dụng trong hệ thống.

== Xử Lý Thông Tin
<xu-ly-thong-tin>

Hệ thống sử dụng các đối tượng lập trình cơ sở dữ liệu (Database Programmability) để đảm bảo tính nhất quán và thực thi các nghiệp vụ phức tạp.

=== Stored Procedures (5)
<stored-procedures-5>

Nhóm xây dựng các thủ tục để xử lý các giao dịch chính như đặt phòng, thanh toán và áp dụng khuyến mãi.

==== SP1: ApplyVoucher
<sp1-applyvoucher>

#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]

==== SP2: BookingRoom
<sp2-bookingroom>

#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]

==== SP3: Checkout
<sp3-checkout>

#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]

==== SP4: Payment
<sp4-payment>

#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]

==== SP5: RegisterUser
<sp5-registeruser>

#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]

==== SPx: Review Room
<spx-review-room>

#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]

==== SPx: Service
<spx-service>

#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]

=== Triggers (5)
<triggers-5>

Sử dụng Trigger để đảm bảo toàn vẹn dữ liệu và tự động cập nhật trạng thái.

==== TG1: AutoPrice
<tg1-autoprice>

#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]

==== TG2: CheckTime
<tg2-checktime>

#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]

==== TG3: Payment
<tg3-payment>

#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]

==== TG4: Refund
<tg4-refund>

#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]

==== TG5: SyncStatus
<tg5-syncstatus>

#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]

=== Functions (3)
<functions-3>

Các hàm hỗ trợ tính toán và kiểm tra nhanh.

==== F1: CheckRoomAvailable
<f1-checkroomavailable>

#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]

==== F2: RevertCreateError
<f2-revertcreateerror>

#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]

==== F3 (WIP)
<f3-wip>

#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]

=== Cursors (2)
<cursors-2>

Sử dụng Cursor cho các tác vụ xử lý theo lô (Batch Processing) định kỳ.

==== Cursor - Tự Động Hoàn Tất Đơn Đặt Phòng Khi Quá Hạn
<cursor-tu-dong-hoan-tat-don-dat-phong-khi-qua-han>

- Tên gọi: `cursor_checkout`.
- #strong[Mục Đích:]
  - Tự động hóa việc kết thúc quy trình đặt phòng.
  - Hệ thống quét các đơn đặt phòng đã quá hạn trả phòng (`Check-out`) nhưng trạng thái vẫn là `CONFIRMED` để chuyển sang `COMPLETED` và giải phóng phòng.
- #strong[Logic Xử Lý:]
  - Khai báo Cursor quét bảng `DATPHONG`.
  - Điều kiện lọc: `trang_thai = 'CONFIRMED'` VÀ `check_out < GETDATE()` (Thời gian hiện tại đã vượt qua giờ check-out).
  - #strong[Xử Lý Ngoại Lệ:] Vòng lặp xử lý từng đơn:
    - Cập nhật trạng thái đơn (`DATPHONG`) thành `COMPLETED`.
    - Tìm các phòng liên quan trong bảng `CT_DATPHONG` và cập nhật trạng thái phòng (`PHONG`) về `AVAILABLE` (Sẵn sàng đón khách mới).
    - Đếm số lượng đơn đã xử lý và in log thông báo.

#strong[Kiểm Thử: Trước khi thực hiện.]

- Các phòng có trạng thái `CONFIRMED`.

#figure(image("demo/C-UpdateStatusWhenOverdue01.png"),
  caption: [
    Cursor - UpdateStatusWhenOverdue 01
  ]
)

#strong[Kiểm Thử: Kết quả.]

- Các phòng có trạng thái `AVAILABLE`.

#figure(image("demo/C-UpdateStatusWhenOverdue02.png"),
  caption: [
    Cursor - UpdateStatusWhenOverdue 02
  ]
)

==== Cursor - Đồng Bộ Trạng Thái Phòng Thực Tế
<cursor-dong-bo-trang-thai-phong-thuc-te>

- Tên gọi: `cur_phong_status`.
- #strong[Mục đích:]
  - Cursor này đảm bảo trạng thái hiển thị của phòng (`AVAILABLE`, `OCCUPIED`, `MAINTENANCE`, `RESERVED`) trên giao diện luôn khớp với dữ liệu đặt phòng thực tế trong cơ sở dữ liệu.
- #strong[Logic xử lý:]
  - Duyệt qua tất cả các phòng trong bảng `PHONG`, lấy thông tin `id`, `so_phong` và `trang_thai` hiện tại.
  - Với mỗi phòng, thực hiện truy vấn kiểm tra xem có đơn đặt phòng nào đang hoạt động (Trạng thái `CONFIRMED` và thời gian hiện tại nằm trong khoảng lưu trú).
  - Cập nhật:
    - Trường hợp 1 (Có khách đang ở):
      - Nếu trạng thái hiện tại chưa phải `OCCUPIED` $arrow.r$ Cập nhật thành `OCCUPIED`.
    - Trường hợp 2 (Không có khách):
      - Nếu trạng thái hiện tại là `OCCUPIED` (tức là dữ liệu cũ bị sai/treo) $arrow.r$ Trả về `AVAILABLE`.
      - Nếu trạng thái hiện tại là `MAINTENANCE` (Bảo trì) hoặc `RESERVED` (Đã đặt trước) $arrow.r$ Giữ nguyên, không can thiệp.

#strong[Kiểm Thử: Trước khi thực hiện.]

- Phòng 101: Đang trống thực tế và dữ liệu lỗi hiển thị là `AVAILABLE` (đúng).
- Phòng 102: Đang có khách ở thực tế nhưng hiển thị là `AVAILABLE` (sai).
- Phòng 503: Đang bảo trì (`MAINTENANCE`), không có khách (đúng).

#figure(image("demo/C-SyncRoomStatus03.png"),
  caption: [
    Cursor - SyncRoomStatus 01
  ]
)

#strong[Kiểm Thử: Kết quả.]

- Phòng 101: Giữ nguyên trạng thái (`AVAILABLE`).
- Phòng 102: Cập nhật sang Đang có khách (`OCCUPIED`).
- Phòng 503: Giữ nguyên trạng thái (`MAINTENANCE`).

#figure(image("demo/C-SyncRoomStatus04.png"),
  caption: [
    Cursor - SyncRoomStatus 02
  ]
)

== An Toàn Thông Tin
<an-toan-thong-tin>


=== Xác thực và phân quyền
<xac-thuc-va-phan-quyen>

Hệ thống áp dụng mô hình bảo mật dựa trên vai trò (RBAC - Role Based Access Control).

- Xác thực: Mật khẩu người dùng được mã hóa (Hashing) trước khi lưu vào cơ sở dữ liệu (giả lập logic ứng dụng).
- Phân quyền:

#table(
  columns: (1fr,) * 2,
  align: (left, left),
  [Vai Trò], [Quyền Hạn], [Admin], [Quản lý tất cả], [Staff], [Quản lý đặt phòng], [End User], [Đặt phòng]
)

=== Sao Lưu & Phục Hồi
<sao-luu-phuc-hoi>

Chiến lược sao lưu dữ liệu được đề xuất:

- Full Backup: Thực hiện định kỳ vào 00:00 Chủ Nhật hàng tuần.
- Differential Backup: Thực hiện vào 00:00 các ngày trong tuần.
- Transaction Log Backup: Mỗi 4 giờ/lần để giảm thiểu rủi ro mất dữ liệu giao dịch.

==== Import - Export Dữ Liệu
<import-export-du-lieu>


==== Backup -- Restore Dữ Liệu
<backup-restore-du-lieu>


== Trình Bày Thông Tin
<trinh-bay-thong-tin>

Hệ thống được thiết kế hướng tới trải nghiệm người dùng tối ưu hóa cho từng đối tượng.

=== Report
<report>

Các báo cáo đầu ra chính của hệ thống:

- Báo Cáo Doanh Thu Tháng: Tổng hợp doanh thu theo loại phòng và theo dịch vụ, phục vụ bộ phận kế toán.
- Phiếu Xác Nhận Đặt Phòng (Booking Confirmation): Gửi cho khách hàng sau khi đặt thành công.
- Hóa Đơn Thanh Toán (Invoice): Chi tiết tiền phòng, dịch vụ, giảm giá voucher và số tiền thực thu.

==== Thống Kê Doanh Thu
<thong-ke-doanh-thu>

Tóm tắt:

- Thống kê doanh thu từng tháng trong năm 2024, và doanh thu của từng phòng trong tháng.

Miêu tả:

- Giúp thống kê được doanh thu của từng phòng để đánh giá xem phòng nào ít khách đặt để tìm ra lý do, hoặc thay đổi loại phòng theo xu hướng của khách.
- Chúng ta sẽ có phần chart thể hiển tổng doanh thu của từng tháng, và phần hiển thị chi tiết tổng số lượt đặt và tổng số tiền đem về của từng phòng trong năm 2024.

Các bước thực hiện:

+ Tạo View tính tổng doanh thu và số lần đặt phòng của từng phòng trong từng tháng của năm 2024: `V_RPT_DOANHTHU_THEO_PHONG_2024`.
+ Kết nối Tableau vào CSDL.
+ Kéo view `V_RPT_DOANHTHU_THEO_PHONG_2024` vào Canvas.
+ Sheet tạo chart bar, mapping dữ liệu từ View `V_RPT_DOANHTHU_THEO_PHONG_2024` để tạo report:
  - `Thang` $arrow.r$ Columns, edit chọn #emph[Discrete] $arrow.r.double$ để hiển thị từng tháng theo cột.
  - `Doanh Thu Phong` $arrow.r$ Rows $arrow.r.double$ để Tableau tự tính `SUM` doanh thu theo từng tháng tương ứng.
  - Kéo thả vào mục Marks các trường trong view:
    - `Doanh Thu Phong` $arrow.r$ Color $arrow.r.double$ để hiển thị màu phân biệt giá trị doanh thu.
    - `Doanh Thu Phong` và `So Luot Dat` $arrow.r$ Label $arrow.r.double$ để hiển thị doanh thu, số lần đặt trên bar.
    - Kéo `So Luot Dat` vào tooltip và edit thông tin để hiển thị khi rê chuột.
    - Tạo calculated fields để hiển thị mã phòng - tên loại phòng.
+ Màn hình design và preview chart bar.

#figure(image("./images/rpt1-2.png"),
  caption: [
    Report 1 - Màn hình Design Chart Bar
  ]
)

#figure(image("./images/rpt1-3.png"),
  caption: [
    Report 1 - Màn hình Preview Chart Bar
  ]
)

#block[
#set enum(numbering: "1.", start: 6)
+ Màn hình Design và Preview sheet hiển thị bảng chi tiết.
]

#figure(image("./images/rpt1-4.png"),
  caption: [
    Report 1 - Màn hình Design Hiển Thị Bảng Chi Tiết
  ]
)

#figure(image("./images/rpt1-5.png"),
  caption: [
    Report 1 - Màn hình Preview Hiển Thị Bảng Chi Tiết
  ]
)

#block[
#set enum(numbering: "1.", start: 7)
+ Tạo dashboard để hiển thị report.
  - Hiển thị 2 sheet charts ở trên.
    - Dạng cột.
    - Dạng bảng.
]

#figure(image("./images/rpt1-6.png"),
  caption: [
    Report 1 - Dashboard Để Hiển Thị Teport - Design
  ]
)

#figure(image("./images/rpt1-7.png"),
  caption: [
    Report 1 - Dashboard Để Hiển Thị Teport - Preview
  ]
)

== Các Chức Năng Của Hệ Thống
<cac-chuc-nang-cua-he-thong>

\(Hướng dẫn: Chỉ miêu tả)

=== Quản Lý Thông Tin Nền Tảng
<quan-ly-thong-tin-nen-tang>


=== Quản Lý Dữ Liệu Đặt Phòng
<quan-ly-du-lieu-dat-phong>


=== Thống Kê Và Báo Cáo
<thong-ke-va-bao-cao>


=== Quản Trị Hệ Thống
<quan-tri-he-thong>
