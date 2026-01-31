#import "../template/lib.typ": *

== Các Chức Năng Của Hệ Thống
<cac-chuc-nang-cua-he-thong>

Dựa trên các yêu cầu nghiệp vụ đã phân tích tại #emph[Chương 1] và mô hình dữ liệu đã thiết kế tại #emph[Chương 2], hệ thống BMS (Booking Management System) cung cấp các nhóm chức năng chính sau đây. Các chức năng này được vận hành dựa trên nền tảng các #emph[Stored Procedures], #emph[Functions] và #emph[Triggers], vv… đã trình bày ở phần #emph[Xử Lý Thông Tin].

=== Quản Lý Thông Tin Nền Tảng
<quan-ly-thong-tin-nen-tang>

Đây là nhóm chức năng dành cho #strong[Quản trị viên (Admin)] để thiết lập dữ liệu cơ sở cho hệ thống vận hành.

==== Quản Lý Loại Phòng & Phòng
<quan-ly-loai-phong-phong>

- Định nghĩa các hạng phòng (Standard, Deluxe, Suite) kèm đơn giá và sức chứa.
- Quản lý danh sách phòng vật lý, cập nhật trạng thái phòng (Sẵn sàng/Bảo trì).
- Kỹ thuật: Sử dụng các thủ tục #emph[CRUD] trên bảng `LOAIPHONG` và `PHONG`.

==== Quản Lý Dịch Vụ
<quan-ly-dich-vu>

- Thiết lập danh mục dịch vụ đi kèm (Ăn sáng, Spa, Đưa đón).
- Cập nhật đơn giá dịch vụ theo thời điểm.

==== Quản Lý Chương Trình Khuyến Mãi
<quan-ly-chuong-trinh-khuyen-mai>

- Tạo mã giảm giá mới với các tham số: Mức giảm (%, Tiền mặt), Số lượng giới hạn, Thời gian hiệu lực.
- Kỹ thuật: Dữ liệu được lưu tại bảng `VOUCHERS` và được xử lý bởi `SP_AP_DUNG_VOUCHER`.

=== Quản Lý Dữ Liệu Đặt Phòng
<quan-ly-du-lieu-dat-phong>

Nhóm chức năng cốt lõi phục vụ quy trình kinh doanh, được sử dụng bởi #strong[Nhân viên (Staff)] và #strong[Khách hàng (End User)].

==== Tìm Kiếm & Kiểm Tra Phòng Trống
<tim-kiem-kiem-tra-phong-trong>

- Cho phép tra cứu phòng khả dụng theo khoảng thời gian (Check-in/Check-out).
- Kỹ thuật: Sử dụng Function `fn_TimPhongTrongTheoLoai` để loại trừ các phòng đã được đặt.

==== Tạo Đặt Phòng (Booking)
<tao-dat-phong-booking>

- Ghi nhận thông tin khách hàng, chọn phòng và tạo đơn hàng.
- Hệ thống tự động tính toán tổng tiền dựa trên giá phòng và số đêm lưu trú.
- Kỹ thuật: Sử dụng Stored Procedure `SP_DATPHONG`.

==== Sử Dụng Dịch Vụ & Áp Dụng Voucher
<su-dung-dich-vu-ap-dung-voucher>

- Ghi nhận các dịch vụ phát sinh trong quá trình lưu trú.
- Áp dụng mã giảm giá để tính toán lại tổng tiền cuối cùng.
- Kỹ thuật: Sử dụng `SP_SU_DUNG_DICH_VU` và `SP_AP_DUNG_VOUCHER`.

==== Thanh Toán & Hóa Đơn
<thanh-toan-hoa-don>

- Xử lý giao dịch thanh toán (Tiền mặt/Chuyển khoản).
- Tự động cập nhật trạng thái đơn hàng sang `CONFIRMED` hoặc `COMPLETED` sau khi thanh toán thành công.

==== Đánh Giá & Phản Hồi
<danh-gia-phan-hoi>

- Cho phép khách hàng gửi đánh giá (số sao, bình luận) sau khi hoàn tất kỳ nghỉ.
- Kỹ thuật: Sử dụng `SP_DANH_GIA` với ràng buộc chỉ được đánh giá khi đơn hàng đã hoàn tất.

=== Thống Kê Và Báo Cáo
<thong-ke-va-bao-cao>

Nhóm chức năng hỗ trợ ra quyết định dành cho #strong[Quản lý (Manager/Admin)], giải quyết bài toán "Khó tổng hợp báo cáo" đã nêu ở #emph[Chương 1].

==== Báo Cáo Doanh Thu
<bao-cao-doanh-thu>

- Thống kê tổng doanh thu theo ngày, tháng, năm.
- Phân tích doanh thu theo nguồn (Tiền phòng vs Tiền dịch vụ).

==== Hiệu Suất Kinh Doanh
<hieu-suat-kinh-doanh>

- Thống kê tỷ lệ lấp đầy phòng (Occupancy Rate).
- Thống kê các dịch vụ được sử dụng nhiều nhất.
- Thống kê hiệu quả của các mã giảm giá (Voucher nào được dùng nhiều nhất).

=== Quản Trị Hệ Thống
<quan-tri-he-thong>

Nhóm chức năng bảo mật và vận hành hệ thống.

==== Quản Lý Người Dùng & Phân Quyền
<quan-ly-nguoi-dung-phan-quyen>

- Quản lý danh sách tài khoản nhân viên.
- Phân quyền truy cập dựa trên vai trò (#emph[RBAC]) thông qua bảng `ADMIN_ROLES`.
- Kỹ thuật: Sử dụng Function `F_CHECK_PERMISSION` để kiểm soát các tác vụ nhạy cảm.

==== Sao Lưu & Phục Hồi
<sao-luu-phuc-hoi>

- Thực hiện sao lưu dữ liệu định kỳ (.bak hoặc `.bacpac`) để đảm bảo an toàn dữ liệu.

== Kết Luận Chương 4
<ket-luan-chuong-4>

Trong chương này, Nhóm 02 đã trình bày chi tiết về các khía cạnh kỹ thuật trong việc quản lý #emph[An Toàn Thông Tin] và #emph[Xử Lý Thông Tin] của Hệ Thống Quản Lý Đặt Phòng, hiện tại các chức năng và đặc điểm sau đây đã được hoàn thành:

+ #strong[Hệ thống xử lý nghiệp vụ:] Thông qua tập hợp các Stored Procedures (Đặt phòng, Voucher, Dịch vụ) đảm bảo logic kinh doanh được thực thi nhất quán ngay tại tầng cơ sở dữ liệu.
+ #strong[Cơ chế bảo mật đa lớp:] Kết hợp giữa bảo mật mức hệ quản trị, mã hóa dữ liệu nhạy cảm và cơ chế phân quyền RBAC/OBAC linh hoạt.
+ #strong[Hệ thống chức năng:] Đáp ứng đầy đủ các yêu cầu đặt ra từ giai đoạn phân tích, giải quyết các vấn đề tồn đọng của quy trình quản lý thủ công.

Đây là nền tảng vững chắc để phát triển các giao diện ứng dụng (Web/Mobile) ở các bước tiếp theo của vòng đời hiện thực hóa và phát triển giải pháp.
