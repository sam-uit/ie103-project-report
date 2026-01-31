#import "../template/lib.typ": *

= Quản Lý Thông Tin
<quan-ly-thong-tin>

Trên nền tảng cơ sở dữ liệu đã thiết kế, chương này trình bày các kỹ thuật xử lý dữ liệu nâng cao (Business Logic) và các chính sách an toàn thông tin được áp dụng trong hệ thống.

== Xử Lý Thông Tin
<xu-ly-thong-tin>

Hệ thống sử dụng các đối tượng lập trình cơ sở dữ liệu (Database Programmability) để đảm bảo tính nhất quán và thực thi các nghiệp vụ phức tạp.

=== Stored Procedures (5)
<stored-procedures-5>

Nhóm xây dựng các thủ tục để xử lý các giao dịch chính như đặt phòng, thanh toán và áp dụng khuyến mãi.

==== SP1 -- Đặt Phòng
<sp1-dat-phong>

- Tên gọi: `SP_DATPHONG`.
- #strong[Mục đích:] Thực hiện chức năng #strong[đặt phòng] cho người dùng.
  - Kiểm tra phòng tồn tại và khả dụng.
  - Tạo bản ghi đặt phòng.
  - Lưu chi tiết phòng.
  - Cập nhật trạng thái phòng.
- #strong[Tham số vào:]

#table(
  columns: (20%, 20%, 20%, 40%),
  align: (left, left, left, left),
  [Tên tham số], [Kiểu dữ liệu], [Bắt buộc], [Mô tả],
  [`@UserId`], [`INT`], [#text(fill: blue)[#sym.checkmark]], [ID người dùng],
  [`@SoPhong`], [`NVARCHAR(20)`], [#text(fill: blue)[#sym.checkmark]], [Số phòng],
  [`@CheckIn`], [`DATETIME`], [#text(fill: blue)[#sym.checkmark]], [Thời gian check-in],
  [`@CheckOut`], [`DATETIME`], [#text(fill: blue)[#sym.checkmark]], [Thời gian check-out],
  [`@VoucherId`], [`INT`], [#text(fill: red)[#sym.crossmark]], [Voucher (nếu có)]
)
#strong[Ví dụ thực hiện]:

- Phòng ID = 30, Tên Phòng = 605, có Mã Vouher = 1:
  - Tạo ra đơn Đặt Phòng ID = 55, có Đơn Giá = 3,000,000.

#figure(image("demo/SP_DATPHONG.png"),
  caption: [
    SP\_DATPHONG - Tạo mới đơn Đặt Phòng.
  ]
)

==== SP2 - Thanh Toán Đặt Phòng
<sp2-thanh-toan-dat-phong>

- Tên gọi: `SP_THANHTOAN`.
- #strong[Mục đích:] Thực hiện chức năng #strong[thanh toán] cho người dùng.
  - Kiểm tra booking hợp lệ.
  - Kiểm tra số tiền thanh toán có đúng với số tiền cần trả.
  - Lưu lịch sử thanh toán.
  - Cập nhật trạng thái booking khi thanh toán hoàn tất.
- #strong[Bảng liên quan:]

#table(
  columns: (8%, 32%, 60%),
  align: (right, left, left),
  [STT], [Bảng], [Mô tả], [1], [`DATPHONG`], [Thông tin đặt phòng], [2], [`CT_DATPHONG`], [Chi tiết phòng và đơn giá], [3], [`CT_SUDUNG_DV`], [Dịch vụ phát sinh], [4], [`VOUCHERS`], [Mã giảm giá], [5], [`PAYMENTS`], [Lịch sử thanh toán]
)
- #strong[Tham số vào:]

#table(
  columns: (8%, 15%, 18%, 14%, 46%),
  align: (right, left, left, left, left),
  [STT], [Tham số], [Kiểu dữ liệu], [Bắt buộc], [Mô tả],
  [1], [`@BookingId`], [`INT`], [#text(fill: blue)[#sym.checkmark]], [ID đặt phòng],
  [2], [`@UserId`], [`INT`], [#text(fill: blue)[#sym.checkmark]], [ID người thanh toán],
  [3], [`@SoTien`], [`DECIMAL(18,2)`], [#text(fill: blue)[#sym.checkmark]], [Số tiền thanh toán],
  [4], [`@PhuongThuc`], [`NVARCHAR(50)`], [#text(fill: blue)[#sym.checkmark]], [Phương thức thanh toán (`TIEN_MAT`, `CHUYEN_KHOAN`, `THE`, `ONLINE`)]
)
#strong[Ví dụ thực hiện]:

- Một đơn Đặt Phòng có thể được thanh toán nhiều lần. Lần 1:

#figure(image("demo/SP_THANHTOAN-01.png"),
  caption: [
    SP\_THANHTOAN - Thanh Toán lần 1.
  ]
)

- Lần 2:

#figure(image("demo/SP_THANHTOAN-02.png"),
  caption: [
    SP\_THANHTOAN - Thanh Toán lần 2.
  ]
)

- Hoàn thành Thanh Toán: đơn Đặt Phòng chuyển trạng thái sang `COMPLETED`.

#figure(image("demo/SP_THANHTOAN-03.png"),
  caption: [
    SP\_THANHTOAN - Hoàn thành Thanh Toán.
  ]
)

==== SP3 - Đánh Giá
<sp3-danh-gia>

- Tên gọi: `SP_DANHGIA`.
- #strong[Mục đích:] Thực hiện chức năng #strong[đánh giá] của người dùng sau khi #emph[đã hoàn thành đặt phòng] (#emph[COMPLETED]).
  - Đảm bảo chỉ đánh giá khi đã ở xong.
  - Mỗi đặt phòng chỉ được đánh giá #strong[1 lần].
  - Lưu đánh giá ở trạng thái chờ duyệt (`CHO_XU_LY`).
  - Hỗ trợ quản trị viên kiểm duyệt nội dung.
- #strong[Bảng liên quan:]

#table(
  columns: (8%, 32%, 60%),
  align: (right, left, left),
  [stt], [Bảng], [Mô tả],
  [`1`], [`DATPHONG`], [Thông tin đặt phòng],
  [`2`], [`PHONG`], [Thông tin phòng],
  [`3`], [`REVIEWS`], [Đánh giá của người dùng],
  [`4`], [`USERS`], [Người đánh giá]
)
- #strong[Tham số vào:]

#table(
  columns: (8%, 15%, 18%, 14%, 46%),
  align: (right, left, left, left, left),
  [stt], [Tham số], [Kiểu dữ liệu], [Bắt buộc], [Mô tả],
  [`1`], [`@UserId`], [`INT`], [#text(fill: blue)[#sym.checkmark]], [ID người đánh giá],
  [`2`], [`@DatPhongId`], [`INT`], [#text(fill: blue)[#sym.checkmark]], [ID đặt phòng],
  [`3`], [`@SoPhong`], [`NVARCHAR(20)`], [#text(fill: blue)[#sym.checkmark]], [Số phòng được đánh giá],
  [`4`], [`@SoSao`], [`INT`], [#text(fill: blue)[#sym.checkmark]], [Số sao (1 → 5)],
  [`5`], [`@BinhLuan`], [`NVARCHAR(1000)`], [#text(fill: red)[#sym.crossmark]], [Nội dung đánh giá]
)
#strong[Ví dụ thực hiện]:

- Sau khi hoàn thành thanh toán, và trạng thái đơn Đặt Phòng là `COMPLETED`, người dùng có thể thực hiện đánh giá.

#figure(image("demo/SP_DANHGIA.png"),
  caption: [
    SP\_DANHGIA - Đánh Giá đơn Đặt Phòng.
  ]
)

==== SP4 - Áp Dụng Voucher
<sp4-ap-dung-voucher>

- #strong[Tên]: `SP_AP_DUNG_VOUCHER`
- #strong[Mục đích]: Áp dụng mã giảm giá (voucher) cho một đặt phòng và tự động tính toán số tiền giảm giá.
  - Mỗi đặt phòng chỉ có thể áp dụng tối đa một mã giảm giá.
  - Mã giảm giá phải còn hạn sử dụng và chưa hết số lượng.
  - Tổng tiền đặt phòng phải đạt mức tối thiểu để áp dụng voucher.
  - Chỉ áp dụng được khi đặt phòng ở trạng thái `PENDING`.
- #strong[Bảng liên quan]: `VOUCHERS`, `DATPHONG`, `CT_DATPHONG`.
- #strong[Tham số đầu vào]:
  - `@DatPhongId (INT)`: ID của đặt phòng.
  - `@VoucherCode (NVARCHAR(50))`: Mã voucher cần áp dụng.
- #strong[Tham số đầu ra]:
  - `@TongTienPhong (DECIMAL(18,2))`: Tổng tiền phòng trước khi giảm.
  - `@TienGiam (DECIMAL(18,2))`: Số tiền được giảm.
  - `@TongTienSauGiam (DECIMAL(18,2))`: Tổng tiền sau khi áp dụng giảm giá.

#strong[Ví dụ sử dụng]:

- Đặt Phòng ID số 4 hiện chưa có voucher.

#figure(image("demo/SP_AP_DUNG_VOUCHER-01.png"),
  caption: [
    SP\_AP\_DUNG\_VOUCHER - Trước khi thực hiện
  ]
)

- Thực thi SP áp dụng voucher.

#figure(image("demo/SP_AP_DUNG_VOUCHER-02.png"),
  caption: [
    SP\_AP\_DUNG\_VOUCHER - Áp Dụng Voucher
  ]
)

- Đặt Phòng ID số 4 hiện đã có voucher áp dụng.

#figure(image("demo/SP_AP_DUNG_VOUCHER-03.png"),
  caption: [
    SP\_AP\_DUNG\_VOUCHER - Kết quả
  ]
)

==== SP5 - Sử Dụng Dịch Vụ
<sp5-su-dung-dich-vu>

- #strong[Tên]: `SP_SU_DUNG_DICH_VU`.
- #strong[Mục đích]: Ghi nhận việc khách hàng sử dụng dịch vụ đi kèm (ăn sáng, giặt ủi, đưa đón sân bay, v.v.) trong thời gian lưu trú.
  - Khách hàng có thể gọi dịch vụ đi kèm bất cứ lúc nào trong thời gian lưu trú.
  - Mỗi lần gọi dịch vụ được ghi nhận riêng biệt.
  - Đơn giá được lưu lại tại thời điểm sử dụng (tránh thay đổi giá sau này ảnh hưởng đến hóa đơn).
- Tham số đầu vào:
  - `@DatPhongId (INT)`: ID của đặt phòng.
  - `@DichVuId (INT)`: ID của dịch vụ được sử dụng.
  - `@SoLuong (INT, mặc định = 1)`: Số lượng dịch vụ.
  - `@GhiChu (NVARCHAR(500), tùy chọn)`: Ghi chú về việc sử dụng dịch vụ.
  - `@ServiceUsageId (INT OUTPUT)`: ID của bản ghi sử dụng dịch vụ vừa tạo.

#strong[Ví dụ sử dụng]:

- Đặt Phòng ID số 2 hiện chưa có dịch vụ sử dụng.

#figure(image("demo/SP_SU_DUNG_DICH_VU-01.png"),
  caption: [
    SP\_SU\_DUNG\_DICH\_VU - Trước khi thực hiện
  ]
)

- Thực thi SP sử dụng dịch vụ: Dịch Vụ ID = 1, Coca Cola.

#figure(image("demo/SP_SU_DUNG_DICH_VU-02.png"),
  caption: [
    SP\_SU\_DUNG\_DICH\_VU - Sử Dụng Dịch Vụ
  ]
)

- Đặt Phòng ID số 2 hiện đã có dịch vụ sử dụng.

#figure(image("demo/SP_SU_DUNG_DICH_VU-03.png"),
  caption: [
    SP\_SU\_DUNG\_DICH\_VU - Kết quả
  ]
)

=== Triggers (5)
<triggers-5>

Sử dụng Trigger để đảm bảo toàn vẹn dữ liệu và tự động cập nhật trạng thái.

==== TRG-01 - Kiểm Tra Thời Gian Đặt Phòng
<trg-01-kiem-tra-thoi-gian-dat-phong>

- Tên: `trg_DATPHONG_CheckTime`.
- Mục đích: Đảm bảo tính hợp lệ của dữ liệu thời gian khi đặt phòng trong hệ thống quản lý khách sạn.

Trong hệ thống đặt phòng khách sạn, cần đảm bảo rằng:

- Thời gian trả phòng (`check_out`) phải #strong[lớn hơn hoặc bằng] thời gian nhận phòng (`check_in`).
- Ngăn chặn dữ liệu không hợp lệ được lưu vào cơ sở dữ liệu.
- Báo lỗi rõ ràng cho người dùng khi nhập sai.

Sử dụng `AFTER Trigger` trên bảng `DATPHONG` để:

+ Kiểm tra điều kiện thời gian sau khi `INSERT` hoặc `UPDATE`.
+ Sử dụng bảng ảo `inserted` để truy cập dữ liệu mới.
+ `ROLLBACK` transaction nếu phát hiện lỗi.
+ Hiển thị thông báo lỗi chi tiết.

#strong[Ví dụ thực hiện]:

- Thời gian check-out lớn hơn check-in, nên thực hiện thành công.

#figure(image("demo/TRG-01-CHECKTIME.png"),
  caption: [
    TRG-01-CheckTime - Kết quả
  ]
)

==== TRG-02 - Tự Động Tính Đơn Giá Khi Đặt Phòng
<trg-02-tu-dong-tinh-don-gia-khi-dat-phong>

- Tên: `trg_CTDP_Insert_ValidatePrice`.
- Mục đích: Tự động hóa quy trình đặt phòng và đảm bảo tính chính xác của đơn giá.

Khi thêm chi tiết đặt phòng vào bảng `CT_DATPHONG`, cần:

+ #strong[Kiểm tra trạng thái phòng]: Chỉ cho phép đặt phòng có trạng thái `AVAILABLE`.
+ #strong[Tự động lấy đơn giá]: Lấy giá từ bảng `LOAIPHONG` thay vì nhập thủ công (tránh sai sót).

Sử dụng `INSTEAD OF` Trigger để:

- Chặn `INSERT` không hợp lệ (phòng không `AVAILABLE`).
- Tự động điền `don_gia` từ `LOAIPHONG.gia_co_ban`.
- Đảm bảo tính nhất quán của dữ liệu.

#strong[Ví dụ thực hiện]:

- Tự động tính đơn giá khi thêm chi tiết đặt phòng vào bảng `CT_DATPHONG`.
  - Đặt Phòng ID = 71.
  - Phòng ID = 8.

#figure(image("demo/TRG-02-AUTOPRICE.png"),
  caption: [
    TRG-02-AutoPrice - Kết quả
  ]
)

==== TRG-03 - Đồng Bộ Trạng Thái Phòng
<trg-03-dong-bo-trang-thai-phong>

- Tên: `trg_CTDP_SyncRoomStatus`.
- Mục đích: Tự động đồng bộ trạng thái phòng khi có thay đổi trong chi tiết đặt phòng.

Khi có thao tác `INSERT`/`UPDATE`/`DELETE` trên bảng `CT_DATPHONG`:

- Phòng được đặt $arrow.r$ Cần chuyển trạng thái sang `OCCUPIED`.
- Phòng bị hủy đặt $arrow.r$ Cần trả về trạng thái `AVAILABLE`.
- Đảm bảo đồng bộ thời gian thực.

Sử dụng `AFTER Trigger` với:

- Bảng ảo `inserted`: Phòng vừa được đặt.
- Bảng ảo `deleted`: Phòng vừa bị hủy.
- Cập nhật trạng thái tự động.

#strong[Ví dụ thực hiện]:

#figure(image("demo/TRG-03-SYNCSTATUS.png"),
  caption: [
    TRG-03-SYNCSTATUS - Tự động cập nhật trạng thái Phòng
  ]
)

==== TG4: Payment
<tg4-payment>

- Xây dựng #strong[Trigger] để đảm bảo tính chính xác của số tiền thanh toán và tự động cập nhật trạng thái đơn đặt phòng.

Khi khách hàng thanh toán (`INSERT` vào bảng `PAYMENTS`):

+ #strong[Kiểm tra số tiền]: Số tiền thanh toán phải bằng tổng đơn giá các phòng đã đặt.
+ #strong[Cập nhật trạng thái]: Tự động chuyển trạng thái booking sang `PAID`.
+ #strong[Ngăn gian lận]: Không cho thanh toán sai số tiền.

Sử dụng `INSTEAD OF` Trigger để:

- Tính tổng tiền từ `CT_DATPHONG`.
- So sánh với số tiền thanh toán.
- Tự động cập nhật trạng thái nếu hợp lệ.

#strong[Ví dụ thực hiện]:

#figure(image("demo/TRG-04-PAYMENT.png"),
  caption: [
    TRG-04-Payment - Kết quả
  ]
)

==== TG5: Refund
<tg5-refund>

- Xây dựng #strong[Trigger] để quản lý quy trình hoàn tiền an toàn và chính xác.

Khi xử lý hoàn tiền (`INSERT` vào bảng `REFUNDS`):

+ #strong[Kiểm tra số tiền hoàn]: Không được vượt quá số tiền đã thanh toán.
+ #strong[Đồng bộ trạng thái]: Cập nhật `PAYMENTS.trang_thai = 'REFUNDED'` và `DATPHONG.trang_thai = 'REFUNDED'`.
+ #strong[Ngăn gian lận]: Không cho hoàn tiền nhiều hơn đã trả.

Sử dụng `INSTEAD OF` Trigger để:

- Kiểm tra `REFUNDS.so_tien_hoan <= PAYMENTS.so_tien`.
- Tự động cập nhật trạng thái payment và booking.
- Đảm bảo tính toàn vẹn dữ liệu.

#strong[Ví dụ thực hiện]:

#figure(image("demo/TRG-05-REFUND.png"),
  caption: [
    TRG-05-Refund - Kết quả
  ]
)

=== Functions (3)
<functions-3>

Các hàm hỗ trợ tính toán và kiểm tra nhanh.

==== F1: CheckRoomAvailable
<f1-checkroomavailable>

#todo[(Xử Lý Thông Tin) TRÌNH BÀY DEMO.]

==== F2: RevertCreateError
<f2-revertcreateerror>

#todo[(Xử Lý Thông Tin) TRÌNH BÀY DEMO.]

==== F3 (WIP)
<f3-wip>

#todo[(Xử Lý Thông Tin) TRÌNH BÀY DEMO.]

=== Cursors (2)
<cursors-2>

Sử dụng Cursor cho các tác vụ xử lý theo lô (Batch Processing) định kỳ.

==== Cursor - Tự Động Hoàn Tất Đơn Đặt Phòng Khi Quá Hạn
<cursor-tu-dong-hoan-tat-don-dat-phong-khi-qua-han>

- Tên gọi: `cursor_checkout`.
- #strong[Mục Đích:]
  - Tự động hóa việc kết thúc quy trình đặt phòng.
  - Hệ thống quét các đơn đặt phòng đã quá hạn trả phòng (`Check-out`) nhưng trạng thái vẫn là `CONFIRMED` để chuyển sang `COMPLETED` và giải phóng phòng.
- #strong[Logic Xử Lý:]
  - Khai báo Cursor quét bảng `DATPHONG`.
  - Điều kiện lọc: `trang_thai = 'CONFIRMED'` VÀ `check_out < GETDATE()` (Thời gian hiện tại đã vượt qua giờ check-out).
  - #strong[Xử Lý Ngoại Lệ:] Vòng lặp xử lý từng đơn:
    - Cập nhật trạng thái đơn (`DATPHONG`) thành `COMPLETED`.
    - Tìm các phòng liên quan trong bảng `CT_DATPHONG` và cập nhật trạng thái phòng (`PHONG`) về `AVAILABLE` (Sẵn sàng đón khách mới).
    - Đếm số lượng đơn đã xử lý và in log thông báo.

#strong[Kiểm Thử: Trước khi thực hiện.]

- Các phòng có trạng thái `CONFIRMED`.

#figure(image("demo/C-UpdateStatusWhenOverdue01.png"),
  caption: [
    Cursor - UpdateStatusWhenOverdue 01
  ]
)

#strong[Kiểm Thử: Kết quả.]

- Các phòng có trạng thái `AVAILABLE`.

#figure(image("demo/C-UpdateStatusWhenOverdue02.png"),
  caption: [
    Cursor - UpdateStatusWhenOverdue 02
  ]
)

==== Cursor - Đồng Bộ Trạng Thái Phòng Thực Tế
<cursor-dong-bo-trang-thai-phong-thuc-te>

- Tên gọi: `cur_phong_status`.
- #strong[Mục đích:]
  - Cursor này đảm bảo trạng thái hiển thị của phòng (`AVAILABLE`, `OCCUPIED`, `MAINTENANCE`, `RESERVED`) trên giao diện luôn khớp với dữ liệu đặt phòng thực tế trong cơ sở dữ liệu.
- #strong[Logic xử lý:]
  - Duyệt qua tất cả các phòng trong bảng `PHONG`, lấy thông tin `id`, `so_phong` và `trang_thai` hiện tại.
  - Với mỗi phòng, thực hiện truy vấn kiểm tra xem có đơn đặt phòng nào đang hoạt động (Trạng thái `CONFIRMED` và thời gian hiện tại nằm trong khoảng lưu trú).
  - Cập nhật:
    - Trường hợp 1 (Có khách đang ở):
      - Nếu trạng thái hiện tại chưa phải `OCCUPIED` $arrow.r$ Cập nhật thành `OCCUPIED`.
    - Trường hợp 2 (Không có khách):
      - Nếu trạng thái hiện tại là `OCCUPIED` (tức là dữ liệu cũ bị sai/treo) $arrow.r$ Trả về `AVAILABLE`.
      - Nếu trạng thái hiện tại là `MAINTENANCE` (Bảo trì) hoặc `RESERVED` (Đã đặt trước) $arrow.r$ Giữ nguyên, không can thiệp.

#strong[Kiểm Thử: Trước khi thực hiện.]

- Phòng 101: Đang trống thực tế và dữ liệu lỗi hiển thị là `AVAILABLE` (đúng).
- Phòng 102: Đang có khách ở thực tế nhưng hiển thị là `AVAILABLE` (sai).
- Phòng 503: Đang bảo trì (`MAINTENANCE`), không có khách (đúng).

#figure(image("demo/C-SyncRoomStatus03.png"),
  caption: [
    Cursor - SyncRoomStatus 01
  ]
)

#strong[Kiểm Thử: Kết quả.]

- Phòng 101: Giữ nguyên trạng thái (`AVAILABLE`).
- Phòng 102: Cập nhật sang Đang có khách (`OCCUPIED`).
- Phòng 503: Giữ nguyên trạng thái (`MAINTENANCE`).

#figure(image("demo/C-SyncRoomStatus04.png"),
  caption: [
    Cursor - SyncRoomStatus 02
  ]
)

== An Toàn Thông Tin
<an-toan-thong-tin>


=== Xác Thực Và Phân Quyền
<xac-thuc-va-phan-quyen>

#todo[(Xác Thực Và Phân Quyền) THỰC HIỆN PHÂN QUYỀN.]
Hệ thống áp dụng mô hình bảo mật dựa trên vai trò (RBAC - Role Based Access Control).

- Xác thực:
  - Mật khẩu người dùng được mã hóa (Hashing) trước khi lưu vào cơ sở dữ liệu (giả lập logic ứng dụng).
- Bảng phân quyền:

#figure(
    table(
    columns: (10%, 20%, 70%),
    align: (right, left, left),
    [STT], [#strong[Vai Trò]], [#strong[Quyền Hạn]], [1], [Admin], [Quản lý tất cả], [2], [Staff], [Quản lý đặt phòng], [3], [End User], [Đặt phòng]
    ),
    caption: [An Toàn Thông Tin - Bảng Phân Quyền]
)

=== Sao Lưu & Phục Hồi
<sao-luu-phuc-hoi>

#todo[(Sao Lưu & Phục Hồi) TRÌNH BÀY BACKUP/RESTORE.]
Chiến lược sao lưu dữ liệu được đề xuất:

- Full Backup: Thực hiện định kỳ vào 00:00 Chủ Nhật hàng tuần.
- Differential Backup: Thực hiện vào 00:00 các ngày trong tuần.
- Transaction Log Backup: Mỗi 4 giờ/lần để giảm thiểu rủi ro mất dữ liệu giao dịch.

==== Import - Export Dữ Liệu
<import-export-du-lieu>


==== Backup -- Restore Dữ Liệu
<backup-restore-du-lieu>


== Trình Bày Thông Tin
<trinh-bay-thong-tin>

Hệ thống được thiết kế hướng tới trải nghiệm người dùng tối ưu hóa cho từng đối tượng.

=== Report
<report>

Các báo cáo đầu ra chính của hệ thống:

- Báo Cáo Doanh Thu Tháng: Tổng hợp doanh thu theo loại phòng và theo dịch vụ, phục vụ bộ phận kế toán.
- Phiếu Xác Nhận Đặt Phòng (Booking Confirmation): Gửi cho khách hàng sau khi đặt thành công.
- Hóa Đơn Thanh Toán (Invoice): Chi tiết tiền phòng, dịch vụ, giảm giá voucher và số tiền thực thu.

==== Thống Kê Doanh Thu
<thong-ke-doanh-thu>

Tóm tắt:

- Thống kê doanh thu từng tháng trong năm 2024, và doanh thu của từng phòng trong tháng.

Miêu tả:

- Giúp thống kê được doanh thu của từng phòng để đánh giá xem phòng nào ít khách đặt để tìm ra lý do, hoặc thay đổi loại phòng theo xu hướng của khách.
- Chúng ta sẽ có phần chart thể hiển tổng doanh thu của từng tháng, và phần hiển thị chi tiết tổng số lượt đặt và tổng số tiền đem về của từng phòng trong năm 2024.

Các bước thực hiện:

+ Tạo View tính tổng doanh thu và số lần đặt phòng của từng phòng trong từng tháng của năm 2024: `V_RPT_DOANHTHU_THEO_PHONG_2024`.
+ Kết nối Tableau vào CSDL.
+ Kéo view `V_RPT_DOANHTHU_THEO_PHONG_2024` vào Canvas.
+ Sheet tạo chart bar, mapping dữ liệu từ View `V_RPT_DOANHTHU_THEO_PHONG_2024` để tạo report:
  - `Thang` $arrow.r$ Columns, edit chọn #emph[Discrete] $arrow.r.double$ để hiển thị từng tháng theo cột.
  - `Doanh Thu Phong` $arrow.r$ Rows $arrow.r.double$ để Tableau tự tính `SUM` doanh thu theo từng tháng tương ứng.
  - Kéo thả vào mục Marks các trường trong view:
    - `Doanh Thu Phong` $arrow.r$ Color $arrow.r.double$ để hiển thị màu phân biệt giá trị doanh thu.
    - `Doanh Thu Phong` và `So Luot Dat` $arrow.r$ Label $arrow.r.double$ để hiển thị doanh thu, số lần đặt trên bar.
    - Kéo `So Luot Dat` vào tooltip và edit thông tin để hiển thị khi rê chuột.
    - Tạo calculated fields để hiển thị mã phòng - tên loại phòng.
+ Màn hình design và preview chart bar.

#figure(image("./images/rpt1-2.png"),
  caption: [
    Report 1 - Màn hình Design Chart Bar
  ]
)

#figure(image("./images/rpt1-3.png"),
  caption: [
    Report 1 - Màn hình Preview Chart Bar
  ]
)

#block[
#set enum(numbering: "1.", start: 6)
+ Màn hình Design và Preview sheet hiển thị bảng chi tiết.
]

#figure(image("./images/rpt1-4.png"),
  caption: [
    Report 1 - Màn hình Design Hiển Thị Bảng Chi Tiết
  ]
)

#figure(image("./images/rpt1-5.png"),
  caption: [
    Report 1 - Màn hình Preview Hiển Thị Bảng Chi Tiết
  ]
)

#block[
#set enum(numbering: "1.", start: 7)
+ Tạo dashboard để hiển thị report.
  - Hiển thị 2 sheet charts ở trên.
    - Dạng cột.
    - Dạng bảng.
]

#figure(image("./images/rpt1-6.png"),
  caption: [
    Report 1 - Dashboard Để Hiển Thị Teport - Design
  ]
)

#figure(image("./images/rpt1-7.png"),
  caption: [
    Report 1 - Dashboard Để Hiển Thị Teport - Preview
  ]
)

== Các Chức Năng Của Hệ Thống
<cac-chuc-nang-cua-he-thong>

\(Hướng dẫn: Chỉ miêu tả)

=== Quản Lý Thông Tin Nền Tảng
<quan-ly-thong-tin-nen-tang>


=== Quản Lý Dữ Liệu Đặt Phòng
<quan-ly-du-lieu-dat-phong>


=== Thống Kê Và Báo Cáo
<thong-ke-va-bao-cao>


=== Quản Trị Hệ Thống
<quan-tri-he-thong>
