#import "../template/lib.typ": *

= Quản Lý Thông Tin
<quan-ly-thong-tin>


== Xử Lý Thông Tin
<xu-ly-thong-tin>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque doleamus animo, cum corpore dolemus, fieri.

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat.

#figure(
  ```sql
  -- Tạo mới VIEW (hoặc thay thế)
  CREATE OR REPLACE VIEW account_activity_view AS
  SELECT
    ba.account_number,
    ba.account_holder,
    ba.balance,
    ul.action AS latest_action,
    ul.timestamp AS latest_action_time
  FROM
    BankAccounts ba
  -- Join nhiều bảng
  LEFT JOIN
    (
        -- Một truy vấn cụ thể
        SELECT DISTINCT ON (account_number)
            account_number,
            action,
            timestamp
        FROM
            UserLogs
        ORDER BY
            account_number,
            timestamp DESC
    ) ul ON ba.account_number = ul.account_number;
  ```,
  caption: [@xu-ly-thong-tin[Mục] -- Khai báo/Khởi tạo VIEW],
)

#figure(
  ```sql
  -- Truy vấn từ VIEW như một bảng bình thường
  SELECT * FROM account_activity_view;
  ```,
  caption: [@xu-ly-thong-tin[Mục] -- Truy vấn VIEW],
)

== An Toàn Thông Tin
<an-toan-thong-tin>


=== Xác thực và phân quyền
<xac-thuc-va-phan-quyen>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque doleamus animo, cum corpore dolemus, fieri.

=== Import - Export Dữ Liệu
<import-export-du-lieu>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque doleamus animo, cum corpore dolemus, fieri.

=== Backup -- Restore Dữ Liệu
<backup-restore-du-lieu>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque doleamus animo, cum corpore dolemus, fieri.

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat.

== Trình Bày Thông Tin
<trinh-bay-thong-tin>


=== Menu
<menu>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque doleamus animo, cum corpore dolemus, fieri.

=== Form
<form>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque doleamus animo, cum corpore dolemus, fieri.

=== Report
<report>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque doleamus animo, cum corpore dolemus, fieri.

== Các Chức Năng Của Hệ Thống
<cac-chuc-nang-cua-he-thong>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque doleamus animo, cum corpore dolemus, fieri.

=== Quản Lý Thông Tin Nền Tảng
<quan-ly-thong-tin-nen-tang>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque doleamus animo, cum corpore dolemus, fieri.

=== Quản Lý Dữ Liệu Đặt Phòng
<quan-ly-du-lieu-dat-phong>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque doleamus animo, cum corpore dolemus, fieri.

=== Thống Kê Và Báo Cáo
<thong-ke-va-bao-cao>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque doleamus animo, cum corpore dolemus, fieri.

=== Quản Trị Hệ Thống
<quan-tri-he-thong>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque doleamus animo, cum corpore dolemus, fieri.

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnam aliquam quaerat.
