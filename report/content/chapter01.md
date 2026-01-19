# Mô Tả Bài Toán 

## Động Lực, Mục Tiêu, Ý Nghĩa của Đề Tài

### Tên Sản Phẩm

- **Booking Management System (BMS)**

### Mục Tiêu

Hệ thống Quản Lý Đặt Phòng (BMS) được xây dựng nhằm hỗ trợ quản lý thông tin phòng, khách hàng, đặt phòng và thanh toán ở mức cơ bản. Hệ thống tập trung vào quản lý dữ liệu bằng cơ sở dữ liệu quan hệ, phục vụ cho việc học tập và thực hành SQL trong môn Quản Lý Thông Tin.

### Đối Tượng Sử Dụng

- Quản trị viên (Admin).
- Nhân viên (Staff).
- Người dùng cuối (End User) - Khách hàng.

### Phạm Vi Áp Dụng

- Khách sạn, nhà nghỉ, homestay quy mô nhỏ và vừa.
- Có giao diện quản lý (BMS) cho Admin/Staff.
- Có giao diện người dùng (User Application) cho End User.
- Có triển khai ứng dụng web hoặc mobile ở mức hoàn chỉnh cho mục đích demo và đồ án.
- Có tích hợp thanh toán trực tuyến ở mức mô phỏng.

## Quy Trình Thực Tế Liên Quan Đến Đề Tài

### Vấn Đề Cần Giải Quyết

Việc quản lý đặt phòng thủ công hoặc bằng bảng tính gặp nhiều hạn chế:

- Dễ xảy ra trùng lịch đặt phòng.
- Khó theo dõi trạng thái phòng theo thời gian.
- Dữ liệu khách hàng phân tán, khó truy vấn.
- Khó tổng hợp báo cáo và thống kê doanh thu.
- Dữ liệu có thể được sao lưu tự động và bảo mật.

### Mục Tiêu Sản Phẩm

- Quản lý dữ liệu tập trung bằng cơ sở dữ liệu quan hệ.
- Đảm bảo toàn vẹn và nhất quán dữ liệu.
- Hỗ trợ truy vấn và thống kê hiệu quả bằng SQL.
- Phù hợp để triển khai các ràng buộc, trigger và procedure, cursor.

### Stakeholders

| Vai trò  | Mô tả                                                           |
| -------- | --------------------------------------------------------------- |
| Admin    | Quản lý phòng, loại phòng, giá phòng                            |
| Staff    | Quản lý đặt phòng, xác nhận / hủy đặt, ghi nhận thanh toán      |
| End User | Tìm kiếm phòng, đặt phòng, hủy đặt phòng và theo dõi thanh toán |
