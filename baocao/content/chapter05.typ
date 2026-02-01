#import "../template/lib.typ": *

= Kết Luận
<ket-luan>

Trong chương cuối cùng này, Nhóm 02 xin tổng kết lại toàn bộ quá trình thực hiện đồ án, đánh giá mức độ hoàn thành so với mục tiêu đặt ra ban đầu, đồng thời đề xuất lộ trình phát triển để đưa hệ thống #emph[BMS] từ một #emph[Đồ Án Môn Học] trở thành một sản phẩm thực tế.

== Kết Quả Đạt Được
<ket-qua-dat-duoc>

Sau quá trình nghiên cứu và triển khai, hệ thống #emph[Booking Management System (BMS)] đã hoàn thiện phần lõi CSDL (Database), bám sát các yêu cầu nghiệp vụ của #emph[Nhà Nghỉ 999] nói riêng và mô hình lưu trú vừa và nhỏ nói chung.

Các kết quả cụ thể có thể kể đến như:

- #strong[Chuẩn hóa quy trình nghiệp vụ:] Đã chuyển đổi thành công các quy trình thủ công (ghi chép sổ sách, chat Zalo) thành các luồng dữ liệu và quy tắc nghiệp vụ chặt chẽ.
- #strong[Thiết kế CSDL toàn diện:] Hoàn thành thiết kế qua 3 mức: #emph[Quan Niệm], #emph[Logic] và #emph[Vật Lý] với hơn 15 bảng dữ liệu được chuẩn hóa.
- #strong[Xử lý thông tin tự động:] Xây dựng hệ thống các Stored Procedures và Triggers để tự động hóa các tác vụ phức tạp như: tính toán hóa đơn, áp dụng Voucher, kiểm tra phòng trống và cập nhật trạng thái phòng.
- #strong[Cơ chế bảo mật đa lớp:] Triển khai thành công mô hình bảo mật từ mức vật lý (#emph[SQL Login]) đến mức ứng dụng (#emph[Mã hóa mật khẩu]) và mức dữ liệu (#emph[Phân quyền RBAC cho nhân viên và OBAC cho khách hàng]).
- #strong[Khả năng sẵn sàng:] Hệ thống đã có đầy đủ kịch bản #emph[Sao Lưu] và #emph[Phục Hồi], đảm bảo tính liên tục của hoạt động kinh doanh.

== Hạn Chế
<han-che>

Bên cạnh những kết quả đạt được, trong khuôn khổ giới hạn về thời gian và phạm vi của một đồ án môn học, dự án vẫn tồn tại một số hạn chế:

- #strong[Thiếu giao diện người dùng (UI/UX):] Chưa xây dựng được giao diện Web/Mobile hoàn chỉnh để người dùng cuối có thể trải nghiệm trực quan. Các tương tác hiện tại chủ yếu thực hiện thông qua câu lệnh SQL hoặc giao diện quản trị cơ sở dữ liệu.
- #strong[Mô phỏng thanh toán:] Chức năng thanh toán trực tuyến mới dừng lại ở mức mô phỏng dữ liệu, chưa tích hợp với các cổng thanh toán thực tế như VNPay hay Stripe.
- #strong[Quản lý tài sản (Asset Management):] Chưa đi sâu vào quy trình quản lý trang thiết bị trong phòng (khăn, ga giường, minibar…) và khấu hao tài sản.

== Hướng Phát Triển
<huong-phat-trien>

Dựa trên nền tảng CSDL vững chắc đã xây dựng, Nhóm 02 định hướng phát triển hệ thống trong tương lai theo các giai đoạn sau:

=== Hệ Sinh Thái Ứng Dụng và Các Điểm Chạm Số
<he-sinh-thai-ung-dung-va-cac-diem-cham-so>

- #strong[Web App]: Dành cho #emph[Nhân Viên] (#emph[Bộ Phận Quản Lý/Lễ Tân]) để thao tác nghiệp vụ nhanh chóng và chính xác.
- #strong[Mobile App]: Dành cho #emph[Khách Hàng] (End User), đóng vai trò là #emph["điểm chạm số"], cho phép khách tự tìm phòng, đặt phòng và theo dõi lịch sử tích điểm ngay trên điện thoại.

=== Mô Hình SaaS (Software as a Service)
<mo-hinh-saas-software-as-a-service>

- Nâng cấp kiến trúc cơ sở dữ liệu để hỗ trợ mô hình #emph[thuê bao nhiều tài khoản (multi-tenancy subscription)].
- Thay vì chỉ phục vụ một nhà nghỉ đơn lẻ, hệ thống sẽ trở thành một nền tảng dịch vụ đám mây, cho phép các chủ nhà nghỉ/homestay khác tạo tài khoản và tự quản lý dữ liệu của riêng họ trên cùng một hạ tầng chung.

=== Tích Hợp Thông Minh
<tich-hop-thong-minh>

- Kết nối API với các kênh OTA (Online Travel Agencies) như Booking.com, Agoda để đồng bộ lịch trống phòng (Channel Manager).
- Tích hợp thanh toán điện tử và hóa đơn điện tử tự động.

== Kết Luận
<ket-luan>

Đồ án #strong["Hệ Thống Quản Lý Đặt Phòng"] vừa là bài báo cáo kết thúc môn học #emph[Quản Lý Thông Tin], đồng thời là nỗ lực trong việc giải quyết bài toán #emph[chuyển đổi số] cho các doanh nghiệp quy mô gia đình như #emph[Nhà Nghỉ 999].

Nhóm 02 đã vận dụng các kiến thức lý thuyết về #emph[Phân Tích Thiết Kế Hệ Thống], #emph[Mô Hình Dữ Liệu] và #emph[An Toàn Thông Tin] để xây dựng một giải pháp lưu trữ và xử lý dữ liệu khoa học. Dù vẫn còn những hạn chế nhất định, nhưng đồ án này đã chứng minh được tính khả thi và hiệu quả trong việc giảm thiểu sai sót, minh bạch hóa tài chính và nâng cao hiệu suất vận hành.

Đây sẽ là tiền đề vững chắc để Nhóm 02 tiếp tục hoàn thiện và phát triển sản phẩm trong các #emph[Đồ Án Chuyên Ngành] tiếp theo.
