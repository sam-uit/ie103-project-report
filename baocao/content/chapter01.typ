#import "../template/lib.typ": *

= Mô Tả Bài Toán
<mo-ta-bai-toan>

Mở đầu cho bản #emph[Báo Cáo Đồ Án], trong chương này, nhóm 02 sẽ trình bày tổng quan về bối cảnh thực tế, lý do lựa chọn đề tài #strong["Hệ Thống Quản Lý Đặt Phòng"], đồng thời xác định rõ phạm vi và mục tiêu mà nhóm hướng tới.

== Tổng Quan Về Đề Tài
<tong-quan-ve-de-tai>


=== Đặt Vấn Đề
<dat-van-de>

Trong bối cảnh ngành du lịch và dịch vụ lưu trú phát triển mạnh mẽ, nhu cầu quản lý vận hành tại các khách sạn, nhà nghỉ và homestay ngày càng trở nên cấp thiết. Tuy nhiên, tại các cơ sở quy mô nhỏ và vừa, quy trình quản lý hiện tại vẫn còn tồn tại nhiều bất cập:

- #strong[Quản lý thủ công:] Việc ghi chép sổ sách hoặc sử dụng Excel rời rạc hoặc các cuộc chat Zalo, Facebook riêng lẻ, dẫn đến sai sót, khó tra cứu lịch sử và dễ mất mát dữ liệu.
- #strong[Xung đột đặt phòng:] Khó kiểm soát trạng thái phòng theo thời gian thực, dẫn đến nhận trùng khách cho cùng một phòng.
- #strong[Báo cáo khó khăn:] Chủ doanh nghiệp gặp khó khăn trong việc tổng hợp doanh thu, thống kê hiệu suất kinh doanh theo ngày/tháng.

Xuất phát từ thực tế đó, nhóm 02 quyết định xây dựng #strong["Booking Management System (BMS)"] - Hệ Thống Quản Lý Đặt Phòng tập trung, nhằm giải quyết các bài toán trên bằng công nghệ cơ sở dữ liệu quan hệ.

=== Mục Tiêu Đề Tài
<muc-tieu-de-tai>

Đồ án tập trung vào hai mục tiêu chính:

+ #strong[Mục tiêu học thuật:]
  - Vận dụng kiến thức môn Quản Lý Thông Tin để phân tích, thiết kế và cài đặt một cơ sở dữ liệu hoàn chỉnh (SQL Server), bao gồm các ràng buộc toàn vẹn và kỹ thuật xử lý nâng cao (Store Procedure, Trigger).
+ #strong[Mục tiêu ứng dụng:] Xây dựng giải pháp phần mềm hỗ trợ 3 nhóm đối tượng chính:
  - #strong[Quản trị viên (Admin):]
    - Quản lý toàn diện hệ thống (Phòng, Giá, Nhân viên).
  - #strong[Nhân viên (Staff):]
    - Thao tác nghiệp vụ hàng ngày (Check-in, Check-out, Thanh toán).
  - #strong[Khách hàng (End User):]
    - Tìm kiếm và đặt phòng trực tuyến.

== Phạm Vi & Đối Tượng Nghiên Cứu
<pham-vi-doi-tuong-nghien-cuu>


=== Phạm Vi Áp Dụng
<pham-vi-ap-dung>

Hệ thống được thiết kế phù hợp cho mô hình:

- Khách sạn, nhà nghỉ, homestay quy mô nhỏ và vừa.
- Hỗ trợ quy trình đặt phòng trực tiếp (tại quầy) và đặt phòng trực tuyến (qua ứng dụng).

Trong khuôn khổ #emph[Đồ Án Môn Học], hệ thống sẽ mô phỏng tính năng thanh toán trực tuyến và chưa tích hợp với các kênh OTA (như Agoda, Booking.com).

=== Các Bên Liên Quan (Stakeholders)
<cac-ben-lien-quan-stakeholders>

Bảng dưới đây mô tả vai trò và trách nhiệm của các đối tượng tham gia hệ thống:

#figure(
    table(
    columns: (20%, 80%),
    align: (left, left),
    [#strong[Vai Trò]], [#strong[Mô Tả Trách Nhiệm]],
    [#strong[Admin]], [
        - Quản trị viên cấp cao.
        - Chịu trách nhiệm cấu hình hệ thống, quản lý danh mục phòng, thiết lập giá và quản lý tài khoản nhân viên.],
    [#strong[Staff]], [
        - Nhân viên vận hành (Lễ tân/Sale).
        - Chịu trách nhiệm xử lý các đơn đặt phòng, thực hiện thủ tục nhận/trả phòng và ghi nhận thanh toán.],
    [#strong[End User]], [
        - Khách hàng cá nhân.
        - Có thể tìm kiếm phòng, tạo đơn đặt phòng, xem lịch sử giao dịch và gửi đánh giá chất lượng.]
  ),
  caption: [Tổng Quan Đề Tài: Các Bên Liên Quan]
)

== Mô Tả Quy Trình Nghiệp Vụ Thực Tế
<mo-ta-quy-trinh-nghiep-vu-thuc-te>

Quy trình quản lý đặt phòng trong thực tế (Business Process) mà hệ thống hướng tới tin học hóa được mô tả qua các bước sau:

+ #strong[Tiếp nhận yêu cầu:]
  - Khách hàng yêu cầu đặt phòng (qua điện thoại, trực tiếp hoặc website).
  - Cung cấp các thông tin: Ngày đến, Ngày đi, Loại phòng, Số lượng người, vv…
+ #strong[Kiểm tra tình trạng (Availability Check):]
  - Nhân viên/Hệ thống kiểm tra danh sách phòng trống trong khoảng thời gian yêu cầu.
  - Nếu hết phòng: Thông báo và đề xuất thời gian/loại phòng khác.
  - Nếu còn phòng: Tiến hành tạm giữ phòng.
+ #strong[Tạo đơn đặt phòng (Booking):]
  - Ghi nhận thông tin khách hàng và thông tin phòng.
  - Hệ thống tính toán tổng tiền tạm tính.
+ #strong[Thanh toán & Xác nhận:]
  - Khách hàng thực hiện thanh toán (Cọc hoặc toàn bộ).
  - Đơn hàng chuyển sang trạng thái "Đã xác nhận" (Confirmed).
+ #strong[Lưu trú & Sử dụng dịch vụ:] Khách check-in.
  - Trong quá trình ở, khách có thể sử dụng thêm dịch vụ (Ăn uống, Spa) $arrow.r$ Ghi nhận vào chi tiết hóa đơn.
+ #strong[Trả phòng & Quyết toán:] Khách check-out.
  - Hệ thống tổng hợp tiền phòng + tiền dịch vụ - tiền cọc/khuyến mãi.
  - Khách thanh toán số còn lại và hoàn tất giao dịch.

== Tổng Kết Chương 1
<tong-ket-chuong-1>

#emph[Chương 01] đã trình bày tổng quan về bài toán #strong[Quản Lý Đặt Phòng Khách Sạn], xác định rõ những bất cập trong quy trình quản lý thủ công hiện tại và đề xuất giải pháp số hóa thông qua hệ thống BMS. Các yêu cầu về nghiệp vụ và phạm vi người dùng được xác định trong chương này sẽ là cơ sở quan trọng để tiến hành #strong[Phân Tích và Thiết Kế Hệ Thống] chi tiết trong #emph[Chương 02].
