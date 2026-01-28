# Quản Lý Thông Tin

Trên nền tảng cơ sở dữ liệu đã thiết kế, chương này trình bày các kỹ thuật xử lý dữ liệu nâng cao (Business Logic) và các chính sách an toàn thông tin được áp dụng trong hệ thống.

## Xử Lý Thông Tin

Hệ thống sử dụng các đối tượng lập trình cơ sở dữ liệu (Database Programmability) để đảm bảo tính nhất quán và thực thi các nghiệp vụ phức tạp.

### Stored Procedures (5)

Nhóm xây dựng các thủ tục để xử lý các giao dịch chính như đặt phòng, thanh toán và áp dụng khuyến mãi.

#### SP1: ApplyVoucher

```{=typst}
#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]
```

#### SP2: BookingRoom

```{=typst}
#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]
```

#### SP3: Checkout

```{=typst}
#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]
```

#### SP4: Payment

```{=typst}
#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]
```

#### SP5: RegisterUser

```{=typst}
#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]
```

#### SPx: Review Room

```{=typst}
#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]
```

#### SPx: Service

```{=typst}
#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]
```

### Triggers (5)

Sử dụng Trigger để đảm bảo toàn vẹn dữ liệu và tự động cập nhật trạng thái.

#### TG1: AutoPrice

```{=typst}
#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]
```

#### TG2: CheckTime

```{=typst}
#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]
```

#### TG3: Payment

```{=typst}
#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]
```

#### TG4: Refund

```{=typst}
#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]
```

#### TG5: SyncStatus

```{=typst}
#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]
```

### Functions (3)

Các hàm hỗ trợ tính toán và kiểm tra nhanh.

#### F1: CheckRoomAvailable

```{=typst}
#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]
```

#### F2: RevertCreateError

```{=typst}
#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]
```

#### F3 (WIP)

```{=typst}
#todo[KIỂM TRA VÀ COPY MIÊU TẢ CỦA DEMO VÀO BÁO CÁO.]
```

### Cursors (2)

Sử dụng Cursor cho các tác vụ xử lý theo lô (Batch Processing) định kỳ.

- `C_UpdateOverdueBookings`: Quét toàn bộ các đơn đặt phòng trạng thái `PENDING`. Nếu quá hạn thanh toán (24h), hệ thống tự động hủy đơn và giải phóng phòng.

#### Cursor - Đồng Bộ Trạng Thái Phòng Thực Tế

- Tên gọi: `cur_phong_status`.
- **Mục đích:**
    - Cursor này đảm bảo trạng thái hiển thị của phòng (`AVAILABLE`, `OCCUPIED`, `MAINTENANCE`, `RESERVED`) trên giao diện luôn khớp với dữ liệu đặt phòng thực tế trong cơ sở dữ liệu.
- **Logic xử lý:**
    - Duyệt qua tất cả các phòng trong bảng `PHONG`, lấy thông tin `id`, `so_phong` và `trang_thai` hiện tại.
    - Với mỗi phòng, thực hiện truy vấn kiểm tra xem có đơn đặt phòng nào đang hoạt động (Trạng thái `CONFIRMED` và thời gian hiện tại nằm trong khoảng lưu trú).
    - Cập nhật:
        + Trường hợp 1 (Có khách đang ở):
            - Nếu trạng thái hiện tại chưa phải `OCCUPIED` $\to$ Cập nhật thành `OCCUPIED`.
        + Trường hợp 2 (Không có khách):
            - Nếu trạng thái hiện tại là `OCCUPIED` (tức là dữ liệu cũ bị sai/treo) $\to$ Trả về `AVAILABLE`.
            - Nếu trạng thái hiện tại là `MAINTENANCE` (Bảo trì) hoặc `RESERVED` (Đã đặt trước) $\to$ Giữ nguyên, không can thiệp.

**Kiểm Thử: Trước khi thực hiện.**

- Phòng 101: Đang trống thực tế và dữ liệu lỗi hiển thị là `AVAILABLE` (đúng).
- Phòng 102: Đang có khách ở thực tế nhưng hiển thị là `AVAILABLE` (sai).
- Phòng 503: Đang bảo trì (`MAINTENANCE`), không có khách (đúng).

![Cursor - SyncRoomStatus 01](demo/C-SyncRoomStatus03.png)

**Kiểm Thử: Kết quả.**

- Phòng 101: Giữ nguyên trạng thái (`AVAILABLE`).
- Phòng 102: Cập nhật sang Đang có khách (`OCCUPIED`).
- Phòng 503: Giữ nguyên trạng thái (`MAINTENANCE`).

![Cursor - SyncRoomStatus 02](demo/C-SyncRoomStatus04.png)

#### Cursor - Tự Động Hoàn Tất Đơn Đặt Phòng Khi Quá Hạn

- Tên gọi: `cursor_checkout`.
- **Mục Đích:**
    - Tự động hóa việc kết thúc quy trình đặt phòng.
    - Hệ thống quét các đơn đặt phòng đã quá hạn trả phòng (`Check-out`) nhưng trạng thái vẫn là `CONFIRMED` để chuyển sang `COMPLETED` và giải phóng phòng.
- **Logic xử lý:**
    - Khai báo Cursor quét bảng `DATPHONG`.
    - Điều kiện lọc: `trang_thai = 'CONFIRMED'` VÀ `check_out < GETDATE()` (Thời gian hiện tại đã vượt qua giờ check-out).
    - **Xử lý ngoại lệ:** Vòng lặp xử lý từng đơn:
        + Cập nhật trạng thái đơn (`DATPHONG`) thành `COMPLETED`.
        + Tìm các phòng liên quan trong bảng `CT_DATPHONG` và cập nhật trạng thái phòng (`PHONG`) về `AVAILABLE` (Sẵn sàng đón khách mới).
        + Đếm số lượng đơn đã xử lý và in log thông báo.

**Kiểm Thử: Trước khi thực hiện.**

- Các phòng có trạng thái `CONFIRMED`.

![Cursor - UpdateStatusWhenOverdue 01](demo/C-UpdateStatusWhenOverdue01.png)

**Kiểm Thử: Kết quả.**

- Các phòng có trạng thái `AVAILABLE`.

![Cursor - UpdateStatusWhenOverdue 02](demo/C-UpdateStatusWhenOverdue02.png)

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

<!-- Menu: Không sử dụng -->
<!-- ### Menu

- Module Khách Hàng (Front-Office):
    - Trang chủ / Tìm kiếm phòng.
    - Chi tiết phòng & Đặt phòng.
    - Lịch sử đặt phòng / Đánh giá.
- Module Quản Trị (Back-Office):
    - Dashboard: Thống kê doanh thu, tỷ lệ lấp đầy.
    - Quản lý phòng: Sơ đồ phòng, cập nhật trạng thái.
    - Nghiệp vụ: Check-in, Check-out, Dịch vụ đi kèm.
    - Cấu hình: Quản lý Voucher, Tài khoản nhân viên. -->

<!-- Form: Không sử dụng -->
<!-- ### Form -->

### Report

Các báo cáo đầu ra chính của hệ thống:

- Báo Cáo Doanh Thu Tháng: Tổng hợp doanh thu theo loại phòng và theo dịch vụ, phục vụ bộ phận kế toán.
- Phiếu Xác Nhận Đặt Phòng (Booking Confirmation): Gửi cho khách hàng sau khi đặt thành công.
- Hóa Đơn Thanh Toán (Invoice): Chi tiết tiền phòng, dịch vụ, giảm giá voucher và số tiền thực thu.

#### Thống Kê Doanh Thu

Tóm tắt:

- Thống kê doanh thu từng tháng trong năm 2024, và doanh thu của từng phòng trong tháng.

Miêu tả:

- Giúp thống kê được doanh thu của từng phòng để đánh giá xem phòng nào ít khách đặt để tìm ra lý do, hoặc thay đổi loại phòng theo xu hướng của khách.
- Chúng ta sẽ có phần chart thể hiển tổng doanh thu của từng tháng, và phần hiển thị chi tiết tổng số lượt đặt và tổng số tiền đem về của từng phòng trong năm 2024.

Các bước thực hiện:

1. Tạo View tính tổng doanh thu và số lần đặt phòng của từng phòng trong từng tháng của năm 2024: `V_RPT_DOANHTHU_THEO_PHONG_2024`.
2. Kết nối Tableau vào CSDL.
3. Kéo view `V_RPT_DOANHTHU_THEO_PHONG_2024` vào Canvas.
4. Sheet tạo chart bar, mapping dữ liệu từ View `V_RPT_DOANHTHU_THEO_PHONG_2024` để tạo report:
    - `Thang` $\to$ Columns, edit chọn *Discrete* $\Rightarrow$ để hiển thị từng tháng theo cột.
    - `Doanh Thu Phong` $\to$ Rows $\Rightarrow$ để Tableau tự tính `SUM` doanh thu theo từng tháng tương ứng.
    - Kéo thả vào mục Marks các trường trong view:
        - `Doanh Thu Phong` $\to$ Color $\Rightarrow$ để hiển thị màu phân biệt giá trị doanh thu.
        - `Doanh Thu Phong` và `So Luot Dat`  $\to$ Label $\Rightarrow$ để hiển thị doanh thu, số lần đặt trên bar.
        - Kéo `So Luot Dat` vào tooltip và edit thông tin để hiển thị khi rê chuột.
        - Tạo calculated fields để hiển thị mã phòng - tên loại phòng.
5. Màn hình design và preview chart bar.

![Report 1 - Màn hình Design Chart Bar](./images/rpt1-2.png)

![Report 1 - Màn hình Preview Chart Bar](./images/rpt1-3.png)

6. Màn hình Design và Preview sheet hiển thị bảng chi tiết.

![Report 1 - Màn hình Design Hiển Thị Bảng Chi Tiết](./images/rpt1-4.png)

![Report 1 - Màn hình Preview Hiển Thị Bảng Chi Tiết](./images/rpt1-5.png)

7. Tạo dashboard để hiển thị report.
    - Hiển thị 2 sheet charts ở trên.
        - Dạng cột.
        - Dạng bảng.

![Report 1 - Dashboard Để Hiển Thị Teport - Design](./images/rpt1-6.png)

![Report 1 - Dashboard Để Hiển Thị Teport - Preview](./images/rpt1-7.png)

## Các Chức Năng Của Hệ Thống

(Hướng dẫn: Chỉ miêu tả)

### Quản Lý Thông Tin Nền Tảng

### Quản Lý Dữ Liệu Đặt Phòng

### Thống Kê Và Báo Cáo

### Quản Trị Hệ Thống
