#import "../template/lib.typ": *

= Phân Tích Và Thiết Kế
<phan-tich-va-thiet-ke>


== Các Chức Năng Nghiệp Vụ
<cac-chuc-nang-nghiep-vu>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque doleamus animo, cum corpore dolemus, fieri.

#figure(image("assets/macos-fhs-root-system.png"), caption: [
  Bài 2. Cây thư mục trong CLI của macOS.
])

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat.

== Đối Tượng và Mối Quan Hệ
<doi-tuong-va-moi-quan-he>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque doleamus animo, cum corpore dolemus, fieri.

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat.

#figure(
  align(center)[
    #table(
      columns: (1fr,) * 4,
      align: (left, left, left, left),
      [#strong[Thuộc tính]], [#strong[Ổ đĩa (Volume/Drive)]], [#strong[Thư mục (Folder)]], [#strong[Tập tin (File)]],
      [#strong[Tên (Name)]],
      [Tên phân vùng (VD: Macintosh HD).],
      [Tên thư mục.],
      [Tên file + Đuôi mở rộng (Extension).],

      [#strong[Loại (Kind)]], [Định dạng (APFS, NTFS…).], [Folder.], [Định dạng (PDF, JPG, Docx…).],
      [#strong[Kích thước (Size)]],
      [Dung lượng tổng / Khả dụng.],
      [Tổng kích thước nội dung.],
      [Kích thước thực của file.],

      [#strong[Ngày tháng]],
      [Ngày tạo phân vùng.],
      [Ngày tạo, ngày sửa đổi nội dung.],
      [Ngày tạo, sửa đổi, mở gần nhất.],

      [#strong[Quyền (Permissions)]],
      [Quản trị hệ thống (System R/W).],
      [Read/Write/Execute (truy cập).],
      [Read/Write/Execute (thao tác).],

      [#strong[Khác]],
      [Mount point, thông tin phần cứng.],
      [Số lượng mục con (items count).],
      [App mặc định (Open with).],
    )
  ],
  caption: [
    @phan-tich-va-thiet-ke[Chương] -- Ví Dụ Về Bảng
  ],
)

== Mô Hình Mức Quan Niệm
<mo-hinh-muc-quan-niem>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque doleamus animo, cum corpore dolemus, fieri.

== Thiết Kế Cơ Sở Dữ Liệu
<thiet-ke-co-so-du-lieu>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque doleamus animo, cum corpore dolemus, fieri.
