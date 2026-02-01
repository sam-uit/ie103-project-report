#import "../template/lib.typ": *

== Các Chức Năng Nghiệp Vụ
<cac-chuc-nang-nghiep-vu>


=== Bao Gồm
<bao-gom>

#figure(
  table(
  columns: (10%, 90%),
  align: (right, left),
  [STT], [#strong[Chức Năng Nghiệp Vụ]],
  [1], [Quản lý phòng và loại phòng (BMS).],
  [2], [Quản lý khách hàng (BMS).],
  [3], [Quản lý đặt phòng (BMS).],
  [4], [Kiểm tra phòng trống (BMS & Khách Hàng).],
  [5], [Đặt phòng và hủy đặt phòng (Khách Hàng).],
  [6], [Thanh toán trực tuyến (mô phỏng).],
  [7], [Hoàn tiền và hủy giao dịch theo chính sách.],
  [8], [Quản lý và phân quyền người dùng (Admin / Staff / End User).],
  [9], [Hiển thị trạng thái đặt phòng và thanh toán (Khách Hàng).],
  [10], [Ứng dụng web hoặc mobile hoàn chỉnh phục vụ thao tác đặt phòng.],
  [11], [Hệ thống khuyến mãi & mã giảm giá (Vouchers).],
  [12], [Quản lý dịch vụ đi kèm như ăn sáng, giặt ủi, đưa đón sân bay.],
  [13], [Hệ thống đánh giá & phản hồi sau khi hoàn tất thanh toán.]
),
caption: [Các Chức Năng Nhiệm Vụ -- Bao Gồm.]
)

=== Không Bao Gồm
<khong-bao-gom>

#figure(
  table(
  columns: (10%, 90%),
  align: (right, left),
  [STT], [#strong[Chức Năng Nghiệp Vụ]],
  [1], [Tích hợp cổng thanh toán thực tế (VNPay, Stripe, PayPal).],
  [2], [Hệ thống kế toán hoặc xuất hóa đơn điện tử.],
  [3], [Tối ưu hiệu năng cho quy mô lớn (high traffic).],
  [4], [Tích hợp bên thứ ba (OTA như Booking, Agoda).]
),
caption: [Các Chức Năng Nhiệm Vụ -- KHÔNG Bao Gồm.]
)
