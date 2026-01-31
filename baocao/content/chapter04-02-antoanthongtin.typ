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

Chiến lược sao lưu dữ liệu được đề xuất:

- Full Backup: Thực hiện định kỳ vào 00:00 Chủ Nhật hàng tuần.
- Differential Backup: Thực hiện vào 00:00 các ngày trong tuần.
- Export/Import: Sử dụng trong các tình huống cụ thể.

==== Backup -- Restore Dữ Liệu
<backup-restore-du-lieu>

#strong[Backup:]

+ Chuột phải vào Database, chọn #emph[Task] \> #emph[Back Up…].

#figure(image("images/backup-01.jpg"),
  caption: [
    Backup - 01 - Task \> Back Up.
  ]
)

#block[
#set enum(numbering: "1.", start: 2)
+ Chọn #emph[Full] trong mục #emph[Backup type]. Chọn #emph[Destination] là #emph[Disk]
]

#figure(image("images/backup-02.jpg"),
  caption: [
    Backup - 02 - Backup Type.
  ]
)

#block[
#set enum(numbering: "1.", start: 3)
+ Thêm đường dẫn thư mục lưu file backup.
]

#figure(image("images/backup-03.jpg"),
  caption: [
    Backup - 03 - Backup Destination.
  ]
)

#block[
#set enum(numbering: "1.", start: 4)
+ Nhấn #emph[OK].
]

#figure(image("images/backup-04.jpg"),
  caption: [
    Backup - 04 - Xác Nhận.
  ]
)

#block[
#set enum(numbering: "1.", start: 5)
+ Thông báo Hoàn Thành.
]

#figure(image("images/backup-05.jpg"),
  caption: [
    Backup - 05 - Backup Hoàn Thành.
  ]
)

#strong[Restore:]

+ Chuột phải vào mục Database của Server, chọn #emph[Restore Database…].

#figure(image("images/restore-01.jpg"),
  caption: [
    Restore - 01 - Restore Database.
  ]
)

#block[
#set enum(numbering: "1.", start: 2)
+ Chọn #emph[Source] là #emph[Device] và chọn #emph[File name] là file backup.
]

#figure(image("images/restore-02.jpg"),
  caption: [
    Restore - 02 - Source.
  ]
)

#block[
#set enum(numbering: "1.", start: 3)
+ Chọn file `.bak` để khôi phục.
]

#figure(image("images/restore-03.jpg"),
  caption: [
    Restore - 03 - Destination.
  ]
)

#block[
#set enum(numbering: "1.", start: 4)
+ Chọn #emph[Destination] là #emph[Database] và đặt tên #emph[Database] là #emph[BookingMS].
]

#figure(image("images/restore-04.jpg"),
  caption: [
    Restore - 04 - Xác Nhận.
  ]
)

#block[
#set enum(numbering: "1.", start: 5)
+ Thông báo Hoàn Thành.
]

#figure(image("images/restore-05.jpg"),
  caption: [
    Restore - 05 - Restore Hoàn Thành.
  ]
)

#block[
#set enum(numbering: "1.", start: 6)
+ Kiểm tra các thành phần của Database vừa được khôi phục.
]

#figure(image("images/restore-06.jpg"),
  caption: [
    Restore - 06 - Kiểm Tra.
  ]
)

==== Export - Import Dữ Liệu
<export-import-du-lieu>

#strong[Export:]

+ Chuột phải vào Database cần Export, chọn #emph[Task] \> #emph[Export Data-Tier Application…].

#figure(image("images/export-01.jpg"),
  caption: [
    Export - 01 - Task \> Export Data-Tier Application.
  ]
)

#block[
#set enum(numbering: "1.", start: 2)
+ Chọn #emph[Next] ở trang #emph[Introduction].
]

#figure(image("images/export-02.jpg"),
  caption: [
    Export - 02 - Introduction.
  ]
)

#block[
#set enum(numbering: "1.", start: 3)
+ Ở trang #emph[Export Settings], mục #emph[Save to local disk], chỉ định đường dẫn lưu file `.bacpac`.
]

#figure(image("images/export-03.jpg"),
  caption: [
    Export - 03 - Export Settings.
  ]
)

#block[
#set enum(numbering: "1.", start: 4)
+ Ở trang #emph[Export Settings], #emph[Next] và chọn các thành phần (#emph[tables]) cần export.
]

#figure(image("images/export-04.jpg"),
  caption: [
    Export - 04 - Export Settings.
  ]
)

#block[
#set enum(numbering: "1.", start: 5)
+ Ở trang #emph[Summary], xác nhận thông tin và nhấn #emph[Finish].
]

#figure(image("images/export-05.jpg"),
  caption: [
    Export - 05 - Summary.
  ]
)

#block[
#set enum(numbering: "1.", start: 6)
+ Kiểm tra tiến độ và kết quả ở trang #emph[Results].
]

#figure(image("images/export-06.jpg"),
  caption: [
    Export - 06 - Results.
  ]
)

#block[
#set enum(numbering: "1.", start: 7)
+ Kiểm tra kết quả và chắc chắn file `.bacpac` đã được tạo thành công.
]

#figure(image("images/export-07.jpg"),
  caption: [
    Export - 07 - Kiểm Tra.
  ]
)

#strong[Import:]

+ Chuột phải vào Database cần Import, chọn #emph[Import Data-Tier Application…].

#figure(image("images/import-01.jpg"),
  caption: [
    Import - 01 - Import Data-Tier Application.
  ]
)

#block[
#set enum(numbering: "1.", start: 2)
+ Chọn #emph[Next] ở trang #emph[Introduction].
]

#figure(image("images/import-02.jpg"),
  caption: [
    Import - 02 - Introduction.
  ]
)

#block[
#set enum(numbering: "1.", start: 3)
+ Chọn #emph[Browse] để tìm file `.bacpac`.
]

#figure(image("images/import-03.jpg"),
  caption: [
    Import - 03 - Browse.
  ]
)

#block[
#set enum(numbering: "1.", start: 4)
+ Ở trang #emph[Database Settings], đặt tên cho database tại #emph[New database name].
]

#figure(image("images/import-04.jpg"),
  caption: [
    Import - 04 - Database Settings.
  ]
)

#block[
#set enum(numbering: "1.", start: 5)
+ Ở trang #emph[Summary], xác nhận thông tin và nhấn #emph[Finish].
]

#figure(image("images/import-05.jpg"),
  caption: [
    Import - 05 - Summary.
  ]
)

#block[
#set enum(numbering: "1.", start: 6)
+ Kiểm tra tiến độ và kết quả ở trang #emph[Results].
]

#figure(image("images/import-06.jpg"),
  caption: [
    Import - 06 - Results.
  ]
)

#block[
#set enum(numbering: "1.", start: 7)
+ Kiểm tra kết quả bằng cách xem các thành phần của Database vừa được import.
]

#figure(image("images/import-07.jpg"),
  caption: [
    Import - 07 - Kiểm Tra.
  ]
)
