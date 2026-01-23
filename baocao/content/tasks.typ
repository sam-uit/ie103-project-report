#import "../template/lib.typ": *
#heading("Báo Cáo Tiến Độ", numbering: none)
\(Sẽ xóa file này sau khi hoàn thành.)

Các hạng mục công việc:

- ☒ 1. Mô tả bài toán
- ☒ 2. Phân Tích Và Thiết Kế
- ☒ 2.1 Các Chức Năng Nghiệp Vụ
- ☒ 2.2 Đối Tượng Và Mối Quan Hệ
- ☒ 2.3 Mô Hình Mức Quan Niệm
- ☒ 2.4 Thiết Kế Cơ Sở Dữ Liệu
- ☒ 3. Cài Đặt Và Triển Khai
- ☒ 3.1 Cài Đặt Mô Hình Dữ Liệu
- ☒ 3.2 Dữ Liệu Mẫu
- ☒ 4. Quản Lý Thông Tin
- ☒ 4.1 Xử Lý Thông Tin
- ☒ 4.1.1 Stored Procedures
- ☒ 4.1.1.a SP\_TAO\_DANH\_GIA: Tạo đánh giá cho đặt phòng sau khi đã thanh toán và trả phòng
- ☒ 4.1.1.b SP\_AP\_DUNG\_VOUCHER: Áp dụng voucher cho một đặt phòng
- ☒ 4.1.1.c SP\_SU\_DUNG\_DICH\_VU: Sử dụng dịch vụ đi kèm trong thời gian lưu trú
- ☒ 4.1.1.d SP\_CHECK\_PHONG\_TRONG: Kiểm tra phòng trống
- ☒ 4.1.1.e SP\_HOAN\_TIEN: Hoàn tiền cho một giao dịch
- ☒ 4.1.2 Triggers
- ☒ 4.1.2.a trg\_DATPHONG\_CheckTime: Kiểm tra thời gian đặt phòng (DATPHONG)
- ☒ 4.1.2.b trg\_CTDP\_Insert\_ValidatePrice: Chèn chi tiết đặt phòng + tự động đơn giá (CT\_DATPHONG)
- ☒ 4.1.2.c trg\_CTDP\_SyncRoomStatus: Đồng bộ trạng thái phòng theo CT\_DATPHONG
- ☒ 4.1.2.d trg\_REFUNDS\_Insert\_CheckAndUpdate: Kiểm tra Hoàn Tiền + Cập nhật lại giao dịch
- ☒ 4.1.2.e trg\_PAYMENTS\_Insert\_CheckAndPaid: Kiểm tra thanh toán + Cập nhật lại giao dịch
- ☒ 4.1.3 Functions
- ☒ 4.1.3.a fn\_TinhTongTien: Tính tổng tiền
- ☒ 4.1.3.b fn\_KiemTraPhongTrong: Kiểm tra phòng trống
- ☒ 4.1.3.c fn\_TaoMaDatPhong: Tạo mã đặt phòng
- ☒ 4.1.4 Cursors
- \[/\] 4.1.4.a cur\_BaoTriVoucher: Kiểm tra và cập nhật trạng thái Voucher
- \[/\] 4.1.4.b cur\_ThongKeDoanhThu: Thống kê doanh thu đặt phòng
- \[/\] 4.2 An Toàn Thông Tin
- ☐ 4.2.1 Backup
- ☐ 4.2.2 Restore
- ☐ 4.2.3 Import
- ☐ 4.2.4 Export
- ☐ 4.3 Trình Bày Thông Tin
- ☐ 4.3.1 Menu
- ☐ 4.3.2 Form
- ☐ 4.3.3 Report
