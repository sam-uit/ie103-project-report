#import "../template/lib.typ": *

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

==== Export - Import Dữ Liệu
<export-import-du-lieu>

Export:

+ Chuột phải vào Database cần Export, chọn #emph[Task] \> #emph[Export Data-Tier Application…].
+ Chọn #emph[Next] ở trang #emph[Introduction].
+ Ở trang #emph[Export Settings], mục #emph[Save to local disk], chỉ định đường dẫn lưu file `.bacpac`.
+ Ở trang #emph[Export Settings], #emph[Next] và chọn các thành phần (#emph[tables]) cần export.
+ Ở trang #emph[Summary], xác nhận thông tin và nhấn #emph[Finish].
+ Kiểm tra tiến độ và kết quả ở trang #emph[Results].
+ Kiểm tra kết quả và chắc chắn file `.bacpac` đã được tạo thành công.

Import:

+ Chuột phải vào Database cần Import, chọn #emph[Import Data-Tier Application…].
+ Chọn #emph[Next] ở trang #emph[Introduction].
+ Chọn #emph[Browse] để tìm file `.bacpac`.
+ Ở trang #emph[Database Settings], đặt tên cho database tại #emph[New database name].
+ Ở trang #emph[Summary], xác nhận thông tin và nhấn #emph[Finish].
+ Kiểm tra tiến độ và kết quả ở trang #emph[Results].
+ Kiểm tra kết quả bằng cách xem các thành phần của Database vừa được import.

==== Backup -- Restore Dữ Liệu
<backup-restore-du-lieu>

Backup:

+ Chuột phải vào Database, chọn #emph[Task] \> #emph[Back Up…].
+ Chọn #emph[Full] trong mục #emph[Backup type].
+ Chọn #emph[Destination] là #emph[Disk]
+ Thêm đường dẫn thư mục lưu file backup.
+ Nhấn #emph[OK].
+ Thông báo Hoàn Thành.

Restore:

+ Chuột phải vào mục Database của Server, chọn #emph[Restore Database…].
+ Chọn #emph[Source] là #emph[Device] và chọn #emph[File name] là file backup.
+ Chọn #emph[Destination] là #emph[Database] và chọn #emph[Database] là #emph[BookingMS] (tên của Database muốn khôi phục thành).
+ Nhấn #emph[OK].
+ Thông báo Hoàn Thành.
+ Kiểm tra các thành phần của Database vừa được khôi phục.
