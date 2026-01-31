## Các Chức Năng Của Hệ Thống

Dựa trên các yêu cầu nghiệp vụ đã phân tích tại *Chương 1* và mô hình dữ liệu đã thiết kế tại *Chương 2*, hệ thống BMS (Booking Management System) cung cấp các nhóm chức năng chính sau đây. Các chức năng này được vận hành dựa trên nền tảng các *Stored Procedures*, *Functions* và *Triggers*, vv... đã trình bày ở phần *Xử Lý Thông Tin*.

### Quản Lý Thông Tin Nền Tảng

Đây là nhóm chức năng dành cho **Quản trị viên (Admin)** để thiết lập dữ liệu cơ sở cho hệ thống vận hành.

#### Quản Lý Loại Phòng & Phòng

- Định nghĩa các hạng phòng (Standard, Deluxe, Suite) kèm đơn giá và sức chứa.
- Quản lý danh sách phòng vật lý, cập nhật trạng thái phòng (Sẵn sàng/Bảo trì).
- Kỹ thuật: Sử dụng các thủ tục *CRUD* trên bảng `LOAIPHONG` và `PHONG`.

#### Quản Lý Dịch Vụ

- Thiết lập danh mục dịch vụ đi kèm (Ăn sáng, Spa, Đưa đón).
- Cập nhật đơn giá dịch vụ theo thời điểm.

#### Quản Lý Chương Trình Khuyến Mãi

- Tạo mã giảm giá mới với các tham số: Mức giảm (%, Tiền mặt), Số lượng giới hạn, Thời gian hiệu lực.
- Kỹ thuật: Dữ liệu được lưu tại bảng `VOUCHERS` và được xử lý bởi `SP_AP_DUNG_VOUCHER`.

### Quản Lý Dữ Liệu Đặt Phòng

Nhóm chức năng cốt lõi phục vụ quy trình kinh doanh, được sử dụng bởi **Nhân viên (Staff)** và **Khách hàng (End User)**.

#### Tìm Kiếm & Kiểm Tra Phòng Trống

- Cho phép tra cứu phòng khả dụng theo khoảng thời gian (Check-in/Check-out).
- Kỹ thuật: Sử dụng Function `fn_TimPhongTrongTheoLoai` để loại trừ các phòng đã được đặt.

#### Tạo Đặt Phòng (Booking)

- Ghi nhận thông tin khách hàng, chọn phòng và tạo đơn hàng.
- Hệ thống tự động tính toán tổng tiền dựa trên giá phòng và số đêm lưu trú.
- Kỹ thuật: Sử dụng Stored Procedure `SP_DATPHONG`.

#### Sử Dụng Dịch Vụ & Áp Dụng Voucher

- Ghi nhận các dịch vụ phát sinh trong quá trình lưu trú.
- Áp dụng mã giảm giá để tính toán lại tổng tiền cuối cùng.
- Kỹ thuật: Sử dụng `SP_SU_DUNG_DICH_VU` và `SP_AP_DUNG_VOUCHER`.

#### Thanh Toán & Hóa Đơn

- Xử lý giao dịch thanh toán (Tiền mặt/Chuyển khoản).
- Tự động cập nhật trạng thái đơn hàng sang `CONFIRMED` hoặc `COMPLETED` sau khi thanh toán thành công.

#### Đánh Giá & Phản Hồi

- Cho phép khách hàng gửi đánh giá (số sao, bình luận) sau khi hoàn tất kỳ nghỉ.
- Kỹ thuật: Sử dụng `SP_DANH_GIA` với ràng buộc chỉ được đánh giá khi đơn hàng đã hoàn tất.

### Thống Kê Và Báo Cáo

Nhóm chức năng hỗ trợ ra quyết định dành cho **Quản lý (Manager/Admin)**, giải quyết bài toán "Khó tổng hợp báo cáo" đã nêu ở *Chương 1*.

#### Báo Cáo Doanh Thu

- Thống kê tổng doanh thu theo ngày, tháng, năm.
- Phân tích doanh thu theo nguồn (Tiền phòng vs Tiền dịch vụ).

#### Hiệu Suất Kinh Doanh

- Thống kê tỷ lệ lấp đầy phòng (Occupancy Rate).
- Thống kê các dịch vụ được sử dụng nhiều nhất.
- Thống kê hiệu quả của các mã giảm giá (Voucher nào được dùng nhiều nhất).

### Quản Trị Hệ Thống

Nhóm chức năng bảo mật và vận hành hệ thống.

#### Quản Lý Người Dùng & Phân Quyền

- Quản lý danh sách tài khoản nhân viên.
- Phân quyền truy cập dựa trên vai trò (*RBAC*) thông qua bảng `ADMIN_ROLES`.
- Kỹ thuật: Sử dụng Function `F_CHECK_PERMISSION` để kiểm soát các tác vụ nhạy cảm.

#### Sao Lưu & Phục Hồi

- Thực hiện sao lưu dữ liệu định kỳ (.bak hoặc `.bacpac`) để đảm bảo an toàn dữ liệu.

## Kết Luận Chương 4

Trong chương này, Nhóm 02 đã trình bày chi tiết về các khía cạnh kỹ thuật trong việc quản lý *An Toàn Thông Tin* và *Xử Lý Thông Tin* của Hệ Thống Quản Lý Đặt Phòng, hiện tại các chức năng và đặc điểm sau đây đã được hoàn thành:

1. **Hệ thống xử lý nghiệp vụ:** Thông qua tập hợp các Stored Procedures (Đặt phòng, Voucher, Dịch vụ) đảm bảo logic kinh doanh được thực thi nhất quán ngay tại tầng cơ sở dữ liệu.
2. **Cơ chế bảo mật đa lớp:** Kết hợp giữa bảo mật mức hệ quản trị, mã hóa dữ liệu nhạy cảm và cơ chế phân quyền RBAC/OBAC linh hoạt.
3. **Hệ thống chức năng:** Đáp ứng đầy đủ các yêu cầu đặt ra từ giai đoạn phân tích, giải quyết các vấn đề tồn đọng của quy trình quản lý thủ công.

Đây là nền tảng vững chắc để phát triển các giao diện ứng dụng (Web/Mobile) ở các bước tiếp theo của vòng đời hiện thực hóa và phát triển giải pháp.
