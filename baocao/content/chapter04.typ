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


==== SP2: BookingRoom
<sp2-bookingroom>


==== SP3: Checkout
<sp3-checkout>


==== SP4: Payment
<sp4-payment>


==== SP5: RegisterUser
<sp5-registeruser>


==== SPx: Review Room
<spx-review-room>


==== SPx: Service
<spx-service>


=== Triggers (5)
<triggers-5>

Sử dụng Trigger để đảm bảo toàn vẹn dữ liệu và tự động cập nhật trạng thái.

==== TG1: AutoPrice
<tg1-autoprice>


==== TG2: CheckTime
<tg2-checktime>


==== TG3: Payment
<tg3-payment>


==== TG4: Refund
<tg4-refund>


==== TG5: SyncStatus
<tg5-syncstatus>


=== Functions (3)
<functions-3>

Các hàm hỗ trợ tính toán và kiểm tra nhanh.

==== F1: CheckRoomAvailable
<f1-checkroomavailable>


==== F2: RevertCreateError
<f2-revertcreateerror>


==== F3 (WIP)
<f3-wip>


=== Cursors (2)
<cursors-2>

Sử dụng Cursor cho các tác vụ xử lý theo lô (Batch Processing) định kỳ.

- `C_UpdateOverdueBookings`: Quét toàn bộ các đơn đặt phòng trạng thái `PENDING`. Nếu quá hạn thanh toán (24h), hệ thống tự động hủy đơn và giải phóng phòng.

==== C1: SyncRoomStatus
<c1-syncroomstatus>


==== C2: UpdateStatusWhenOverdue
<c2-updatestatuswhenoverdue>


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
  - `Thang` -\> Columns, edit chọn Discrete =\> để hiển thị từng tháng theo cột.
  - `Doanh Thu Phong` -\> Rows =\> để tableau tự tính SUM doanh thu theo từng tháng tương ứng.
  - Kéo thả vào mục Marks các trường trong view:
    - `Doanh Thu Phong` -\> Color =\> để hiển thị màu phân biệt giá trị doanh thu.
    - `Doanh Thu Phong` và `So Luot Dat` -\> Label =\> để hiển thị doanh thu, số lần đặt trên bar.
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
    Report 1 - Màn hình Design Sheet Hiển Thị Bảng Chi Tiết
  ]
)

#figure(image("./images/rpt1-5.png"),
  caption: [
    Report 1 - Màn hình Preview Sheet Hiển Thị Bảng Chi Tiết
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
