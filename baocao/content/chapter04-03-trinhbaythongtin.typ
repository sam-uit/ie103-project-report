#import "../template/lib.typ": *

== Trình Bày Thông Tin
<trinh-bay-thong-tin>

Hệ thống được thiết kế hướng tới trải nghiệm người dùng tối ưu hóa cho từng đối tượng.

=== Report
<report>

Các báo cáo đầu ra chính của hệ thống:

- Báo Cáo Doanh Thu Tháng: Tổng hợp doanh thu theo loại phòng và theo dịch vụ, phục vụ bộ phận kế toán.
- Phiếu Xác Nhận Đặt Phòng (Booking Confirmation): Gửi cho khách hàng sau khi đặt thành công.
- Hóa Đơn Thanh Toán (Invoice): Chi tiết tiền phòng, dịch vụ, giảm giá voucher và số tiền thực thu.

==== Báo Cáo 01 - Thống Kê Doanh Thu
<bao-cao-01-thong-ke-doanh-thu>

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

==== Báo Cáo 02 - Top Khách Hàng Chi Tiêu Nhiều Nhất
<bao-cao-02-top-khach-hang-chi-tieu-nhieu-nhat>

Mục đích:

- Giúp đánh giá xem khách hàng thân thiết để tặng voucher hay là nâng hạng khách hàng lên Premium,VIP phục vụ cho CSKH, CRM.

Các bước thực hiện:

+ Tạo View lấy danh sách Khách Hàng VIP (`V_REPORT_USER_VIP_2024`).
+ Kết nối Tableu vào database.
+ Kéo view `V_REPORT_USER_VIP_2024` vào Canvas.
+ Mapping dữ liệu từ View `V_REPORT_USER_VIP_2024` để tạo chart line:
  - Kéo "Tổng tiền chi tiêu" $arrow.r$ Row $arrow.r.double$ Tableau sẽ tự động tính tổng và làm trục đứng (Y).
  - Kéo "Tháng" $arrow.r$ Columns, chọn demension để làm trục ngang (X).
  - Kéo `UserID` vào Color chỗ Mark để hiển thị màu phân biệt.
  - Filter top 10 tùy mục đích.
+ Tạo Sheet hiển thị table chi tiết.
  - Kéo "Tháng" $arrow.r$ Columns, chọn demension và #emph[discrete].
  - Tạo calculated fields để hiển thị UserID - Tên.
  - Kéo calculated fields và phone vào để hiển thị.
  - Kéo "Tổng chi tiêu" và Text chỗ Marks để show tiền vào table.
  - Format màu, kiểu chữ kích thước.
  - Chọn Analysis $arrow.r$ Total $arrow.r$ show grands total và kéo về trái để hiển thị cột tổng.
+ Màn hình design và preview dashboard.

- Ta chọn kích cỡ A4 lanscape để in cho đẹp và đây đủ, chọn fit -\> entrie view để hiển thị hết width height.

#figure(image("./images/rpt2-10.png"),
  caption: [
    Báo Cáo 02 - Top Khách Hàng Chi Tiêu Nhiều Nhất - Design
  ]
)

#figure(image("./images/rpt2-11.png"),
  caption: [
    Báo Cáo 02 - Top Khách Hàng Chi Tiêu Nhiều Nhất - Preview
  ]
)
