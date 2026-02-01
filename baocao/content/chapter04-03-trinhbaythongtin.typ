#import "../template/lib.typ": *

== Trình Bày Thông Tin
<trinh-bay-thong-tin>

Phần này hiện thực yêu cầu Trình Bày Thông Tin, phục vụ cho người sử dụng trên hệ thống, bao gồm USERS (qua Menu hoặc Form), Admin/Quản Lý qua các Báo Cáo (Report), vv…

Mỗi hình thức trình bày thông tin hướng đến những yêu cầu khác nhau nhằm tối ưu hóa trải nghiệm người dùng và hỗ trợ ra quyết định hiệu quả.

=== Menu
<menu>

\(Không trình bày).

=== Form
<form>

\(Không trình bày).

=== Report - Các Báo Cáo
<report-cac-bao-cao>

Các báo cáo đầu ra chính của hệ thống phục vụ quá trình khai thác dữ liệu và ra quyết định của quản lý:

- Báo Cáo 01 - Thống Kê Doanh Thu:
  - Thống kê doanh thu từng tháng và doanh thu của từng phòng trong tháng.
- Báo Cáo 02 - Top Khách Hàng Chi Tiêu Nhiều Nhất:
  - Thống kê và xếp hạng khách hàng chi tiêu nhiều nhất.
- Báo Cáo 03 - Thống Kê Doanh Thu Dịch Vụ:
  - Thống kê "Dịch vụ được yêu thích nhất".
- Báo Cáo 04 - Thống Kê Top Voucher Được Săn Đón Nhất:
  - Thống kê và xếp hạng voucher được sử dụng nhiều nhất.
- Báo Cáo 05 - Thống Kê Top Loại Phòng Được Yêu Thích Nhất:
  - Thống kê và xếp hạng loại phòng được yêu thích nhất.

==== Báo Cáo 01 - Thống Kê Doanh Thu
<bao-cao-01-thong-ke-doanh-thu>

Tóm tắt:

- Thống kê doanh thu từng tháng trong năm 2024, và doanh thu của từng phòng trong tháng.

Miêu tả:

- Giúp thống kê được doanh thu của từng phòng để đánh giá xem phòng nào ít khách đặt để tìm ra lý do, hoặc thay đổi loại phòng theo xu hướng của khách.
- Chúng ta sẽ có phần chart thể hiện tổng doanh thu của từng tháng, và phần hiển thị chi tiết tổng số lượt đặt và tổng số tiền đem về của từng phòng trong năm 2024.

#figure(image("./images/rpt1-7.png"),
  caption: [
    Báo Cáo 01 - Dashboard Để Hiển Thị Teport - Preview.
  ]
)

==== Báo Cáo 02 - Top Khách Hàng Chi Tiêu Nhiều Nhất
<bao-cao-02-top-khach-hang-chi-tieu-nhieu-nhat>

Mục đích:

- Giúp đánh giá xem khách hàng thân thiết để tặng voucher hay là nâng hạng khách hàng lên Premium, VIP phục vụ cho CSKH, CRM.

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
    Báo Cáo 02 - Màn Hình Design.
  ]
)

#figure(image("./images/rpt2-11.png"),
  caption: [
    Báo Cáo 02 - Màn Hình Preview.
  ]
)

==== Báo Cáo 03 - Thống Kê Doanh Thu Dịch Vụ
<bao-cao-03-thong-ke-doanh-thu-dich-vu>

Miêu tả:

- Để xác định "Dịch vụ nào được ưa chuộng nhất" (Best Seller) sẽ giúp quản lý có kế hoạch nhập hàng và đẩy mạnh khuyến mãi.
- Vì mỗi dịch vụ thời giá sẽ khác nhau nên ở table chi tiết ta sẽ thống kê từng đơn giá của dịch vụ.

Các bước thực hiện:

+ Tạo View lấy danh sách Dịch Vụ Yêu Thích Nhất (`V_REPORT_TOP_SERVICE_2024`).
+ Kết nối Tableu vào database.
+ Kéo view `V_REPORT_TOP_SERVICE_2024` vào Canvas.
+ Mapping dữ liệu từ View `V_REPORT_TOP_SERVICE_2024` để tạo chart line.
+ Tạo Sheet hiển thị table chi tiết.

Màn hình design và preview dashboard:

#figure(image("./images/rpt3-8.png"),
  caption: [
    Báo Cáo 03 - Màn Hình Design.
  ]
)

#figure(image("./images/rpt3-9.png"),
  caption: [
    Báo Cáo 03 - Màn Hình Preview.
  ]
)

==== Báo Cáo 04 - Thống Kê Top Voucher Được Săn Đón Nhất
<bao-cao-04-thong-ke-top-voucher-duoc-san-don-nhat>

Miêu tả:

- Để thống kê xem mình đưa ra bao nhiêu mã giảm giá, và cái nào khách xài nhiều nhất.
- Tổng số tiền của voucher nào sử dụng nhiều nhất.
- Chỉ tính dòng trong bảng `PAYMENTS` có trạng thái `SUCCESS`, hiểu là thanh toán thành công.
- Công thức tính số tiền giảm: (tiền thực / (100% - %giảm)) - tiền thực .

Các bước thực hiện:

+ Tạo View lấy danh sách Top Voucher Được Săn Đón Nhất & Số Tiền Đã Giảm Giá Năm 2024 (`V_REPORT_TOP_VOUCHER_2024`).
+ Kết nối Tableu vào database.
+ Kéo view `V_REPORT_TOP_VOUCHER_2024` vào Canvas.
+ Mapping dữ liệu từ View `V_REPORT_TOP_VOUCHER_2024` để tạo chart line.
+ Tạo Sheet hiển thị table chi tiết.

Màn hình design và preview dashboard:

#figure(image("./images/rpt4-2.png"),
  caption: [
    Báo Cáo 04 - Màn Hình Design.
  ]
)

#figure(image("./images/rpt4-6.png"),
  caption: [
    Báo Cáo 04 - Màn Hình Preview.
  ]
)

==== Báo Cáo 05 - Thống Kê Top Loại Phòng Được Yêu Thích Nhất
<bao-cao-05-thong-ke-top-loai-phong-duoc-yeu-thich-nhat>

Miêu tả:

- Dựa trên số sao được khách hàng đánh giá, ta sẽ thống kê xem xem là loại phòng nào làm khách hàng thích nhất, để điều chỉnh phòng theo xu hướng của khách hàng, giúp đánh giá tăng doanh thu, thu hút khách.
- Chúng ta chỉ lấy những reviews nào đã được admin duyệt(`trang_thai = 'APPROVED'`), vì có thể có những review spam hoặc rác.

Các bước thực hiện:

+ Tạo View lấy danh sách Top Loại Phòng Được Yêu Thích Nhất (`V_REPORT_ROOM_RATING`).
+ Kết nối Tableu vào database.
+ Kéo view `V_REPORT_ROOM_RATING` vào Canvas.
+ Mapping dữ liệu từ View `V_REPORT_ROOM_RATING` để tạo chart line.
+ Tạo Sheet hiển thị table chi tiết.

Màn hình design và preview dashboard:

#figure(image("./images/rpt5-5.png"),
  caption: [
    Báo Cáo 05 - Màn Hình Design.
  ]
)

#figure(image("./images/rpt5-6.png"),
  caption: [
    Báo Cáo 05 - Màn Hình Preview.
  ]
)
