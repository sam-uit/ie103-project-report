# Quản Lý Thông Tin

Trên nền tảng cơ sở dữ liệu đã thiết kế, chương này trình bày các kỹ thuật xử lý dữ liệu nâng cao (Business Logic) và các chính sách an toàn thông tin được áp dụng trong hệ thống.

## Xử Lý Thông Tin

Hệ thống sử dụng các đối tượng lập trình cơ sở dữ liệu (Database Programmability) để đảm bảo tính nhất quán và thực thi các nghiệp vụ phức tạp.

### Stored Procedures (5)

Nhóm xây dựng các thủ tục để xử lý các giao dịch chính như đặt phòng, thanh toán và áp dụng khuyến mãi.

#### SP1: ApplyVoucher

#### SP2: BookingRoom

#### SP3: Checkout

#### SP4: Payment

#### SP5: RegisterUser

#### SPx: Review Room

#### SPx: Service

### Triggers (5)

Sử dụng Trigger để đảm bảo toàn vẹn dữ liệu và tự động cập nhật trạng thái.

#### TG1: AutoPrice

#### TG2: CheckTime

#### TG3: Payment

#### TG4: Refund

#### TG5: SyncStatus

### Functions (3)

Các hàm hỗ trợ tính toán và kiểm tra nhanh.

#### F1: CheckRoomAvailable

#### F2: RevertCreateError

#### F3 (WIP)

### Cursors (2)

Sử dụng Cursor cho các tác vụ xử lý theo lô (Batch Processing) định kỳ.

- `C_UpdateOverdueBookings`: Quét toàn bộ các đơn đặt phòng trạng thái `PENDING`. Nếu quá hạn thanh toán (24h), hệ thống tự động hủy đơn và giải phóng phòng.

#### C1: SyncRoomStatus

#### C2: UpdateStatusWhenOverdue

## An Toàn Thông Tin

### Xác thực và phân quyền

Hệ thống áp dụng mô hình bảo mật dựa trên vai trò (RBAC - Role Based Access Control).

- Xác thực: Mật khẩu người dùng được mã hóa (Hashing) trước khi lưu vào cơ sở dữ liệu (giả lập logic ứng dụng).
- Phân quyền:

| Vai Trò | Quyền Hạn |
|----|----|
| Admin | Quản lý tất cả |
| Staff | Quản lý đặt phòng |
| End User | Đặt phòng |

### Sao Lưu & Phục Hồi

Chiến lược sao lưu dữ liệu được đề xuất:

- Full Backup: Thực hiện định kỳ vào 00:00 Chủ Nhật hàng tuần.
- Differential Backup: Thực hiện vào 00:00 các ngày trong tuần.
- Transaction Log Backup: Mỗi 4 giờ/lần để giảm thiểu rủi ro mất dữ liệu giao dịch.

#### Import - Export Dữ Liệu

#### Backup – Restore Dữ Liệu

## Trình Bày Thông Tin

Hệ thống được thiết kế hướng tới trải nghiệm người dùng tối ưu hóa cho từng đối tượng.

### Menu

- Module Khách Hàng (Front-Office):
    - Trang chủ / Tìm kiếm phòng.
    - Chi tiết phòng & Đặt phòng.
    - Lịch sử đặt phòng / Đánh giá.
- Module Quản Trị (Back-Office):
    - Dashboard: Thống kê doanh thu, tỷ lệ lấp đầy.
    - Quản lý phòng: Sơ đồ phòng, cập nhật trạng thái.
    - Nghiệp vụ: Check-in, Check-out, Dịch vụ đi kèm.
    - Cấu hình: Quản lý Voucher, Tài khoản nhân viên.

### Form

### Report

Các báo cáo đầu ra chính của hệ thống:

- Phiếu Xác Nhận Đặt Phòng (Booking Confirmation): Gửi cho khách hàng sau khi đặt thành công.
- Hóa Đơn Thanh Toán (Invoice): Chi tiết tiền phòng, dịch vụ, giảm giá voucher và số tiền thực thu.
- Báo Cáo Doanh Thu Tháng: Tổng hợp doanh thu theo loại phòng và theo dịch vụ, phục vụ bộ phận kế toán.

## Các Chức Năng Của Hệ Thống

### Quản Lý Thông Tin Nền Tảng

### Quản Lý Dữ Liệu Đặt Phòng

### Thống Kê Và Báo Cáo

### Quản Trị Hệ Thống
