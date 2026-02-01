## An Toàn Thông Tin

Như đã đề cập một phần ở *Chương 3* -- mục *Thiết Lập Nền Tảng Quản Trị & Bảo Mật*, phần này của *Chương 4* sẽ trình bày đầy đủ hơn về cách hiện thực các biện pháp bảo mật thông tin trong hệ thống, bao gồm các biện pháp phân quyền, mã hóa mật khẩu, và các biện pháp bảo mật khác. Hệ thống áp dụng mô hình bảo mật đa lớp từ mức Hệ Quản Trị CSDL, tới phân quyền dựa trên vai trò (RBAC) ở mức dữ liệu.

Đồng thời trình bày các công việc của quản trị viên trong việc sao lưu/khôi phục dữ liệu, đảm bảo an toàn thông tin và tính liên tục của vận hành (Business Continuity).

### Bảo Mật Mức Hệ Quản Trị

Bảo mật mức hệ quản trị SQL Server là lớp đầu tiên trong *An Toàn Thông Tin* của Hệ Thống BMS.

Để tuân thủ nguyên tắc *Đặc Quyền Tối Thiểu* (Least Privilege) -- mỗi tài khoản chỉ có đủ quyền truy cập vào tài nguyên cần thiết cho các nghiệp vụ cụ thể, hệ thống KHÔNG SỬ DỤNG tài khoản `sa` (System Admin) để kết nối từ ứng dụng vào cơ sở dữ liệu. Thay vào đó, một tài khoản chuyên biệt được tạo ra để kết nối từ ứng dụng vào cơ sở dữ liệu.

- Tạo Login trên Server:

```{=typst}
#figure(
  ```sql
  CREATE LOGIN [BMS_App_User] WITH PASSWORD = 'P@ssw0rd123!';
  ```,
  caption: [Bảo Mật Mức Hệ Quản Trị - Tạo Login Server]
)
```

- Tạo Database User & Gán Quyền:

```{=typst}
#figure(
```sql
USE ROOM_BOOKING_SYSTEM;
CREATE USER [BMS_App_User] FOR LOGIN [BMS_App_User];
```,
caption: [Bảo Mật Mức Hệ Quản Trị - Tạo Database User]
)
```

- Gán Quyền: Chỉ cấp quyền thực thi (`EXECUTE`) trên các Stored Procedure, ngăn chặn truy cập trực tiếp vào bảng dữ liệu.

```{=typst}
#figure(
```sql
GRANT EXECUTE TO [BMS_App_User];
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO [BMS_App_User];
GO
```,
caption: [Bảo Mật Mức Hệ Quản Trị - Gán Quyền]
)
```

### Mã Hóa Mật Khẩu

Để đảm bảo an toàn dữ liệu người dùng, hệ thống không lưu trữ mật khẩu dưới dạng văn bản thuần (plain-text). Mọi mật khẩu đều được mã hóa một chiều bằng thuật toán SHA-256 thông qua hàm `HASHBYTES` của SQL Server trước khi lưu vào cơ sở dữ liệu.

Tồn tại một Stored Producedure (SP) thực hiện mã hóa mật khẩu mỗi khi tạo User mới (`SP_AUTH_REGISTER`) như miêu tả sau:

```{=typst}
#figure(
    raw(read("code/ch04-sp_auth_register.sql"), lang: "sql", block: true),
    caption: [An Toàn Thông Tin -- Mã Hóa Mật Khẩu]
)
```

Tồn tại một SP Đăng nhập (Kiểm tra Hash mật khẩu khi người dùng đăng nhập) `SP_AUTH_LOGIN`:

- Mã hóa mật khẩu nhập vào và so sánh với mật khẩu đã mã hóa trong database.
- Đảm bảo luôn so sánh cặp `email` đăng nhập và `password_hash` được nhập vào.

```{=typst}
#figure(
    raw(read("code/ch04-sp_auth_login.sql"), lang: "sql", block: true),
    caption: [An Toàn Thông Tin -- Kiểm Tra Mật Khẩu Đăng Nhập]
)
```

### Xác Thực Và Phân Quyền

Để đảm bảo đúng và đủ quyền thực thi các thao tác tương ứng cho từng vai trò của *Nhân Viên* và của *Khách Hàng*, hệ thống áp dụng những cơ chế tương ứng cần thiết.

- Đối với *Nhân Viên*: Hệ thống áp dụng cơ chế phân quyền dựa trên vai trò (RBAC).
    - Mỗi *role* có các quyền tương ứng.
- Đối với *Khách Hàng*: Hệ thống áp dụng cơ chế xác thực quyền sở hữu (OBAC).
    - Mỗi *USER* chỉ được thao tác trên dữ liệu của mình.

#### RBAC (Role-Based Access Control) Cho Nhân Viên

```{=typst}
#co-warn[Mọi thủ tục dành cho #emph[Nhân Viên] (các thao tác quản trị: Thêm phòng, Duyệt hoàn tiền...) đều phải đi qua hàm kiểm tra `F_CHECK_PERMISSION` để xác thực xem nhân viên đó có sở hữu quyền (`PERMISSIONS.code`) tương ứng hay không.]
```

Hệ thống quản lý quyền hạn thông qua các bảng `ROLES`, `PERMISSIONS`, `ROLE_PERMISSIONS` và `ADMIN_ROLES`. Quyền truy cập không được gán cứng mà dựa trên vai trò và quyền hạn của *Admin* hoặc *Staff* (Nhân viên).

Mô hình phân quyền:

<!-- | STT | **Vai Trò** | **Quyền Hạn** |
|----:|----|----|
| 1 | `SUPER_ADMIN` | Quản trị viên cấp cao | Toàn quyền quản lý hệ thống |
| 2 | `ADMIN` | Quản trị viên | Quản lý phòng và đặt phòng |
| 3 | `STAFF` | Nhân viên | Xử lý đặt phòng và thanh toán |
| 4 | `ACCOUNTANT` | Kế toán | Quản lý thanh toán và doanh thu |
| 5 | `RECEPTIONIST` | Lễ tân | Tiếp nhận khách và check-in/out |
| 6 | `MANAGER` | Quản lý | Giám sát hoạt động |
| 7 | `MAINTENANCE` | Bảo trì | Quản lý bảo trì phòng |
| 8 | `MARKETING` | Marketing | Quản lý khuyến mãi và voucher |
| 9 | `SUPPORT` | Hỗ trợ | Hỗ trợ khách hàng |
| 10 | `ANALYST` | Phân tích | Xem báo cáo và thống kê | -->

```{=typst}
#figure(
    table(
    columns: (10%, 20%, 70%),
    align: (right + bottom, left + bottom, left + bottom),
    [STT], [#strong[Vai Trò]], [#strong[Quyền Hạn]],
    [1], [`SUPER_ADMIN`], [Quản trị viên cấp cao],
    [2], [`ADMIN`], [Quản trị viên],
    [3], [`STAFF`], [Nhân viên],
    [4], [`ACCOUNTANT`], [Kế toán],
    [5], [`RECEPTIONIST`], [Lễ tân],
    [6], [`MANAGER`], [Quản lý],
    [7], [`MAINTENANCE`], [Bảo trì],
    [8], [`MARKETING`], [Marketing],
    [9], [`SUPPORT`], [Hỗ trợ],
    [10], [`ANALYST`], [Phân tích]
    ),
    caption: [An Toàn Thông Tin - Bảng Phân Quyền]
)
```

Thủ tục kiểm tra quyền `F_CHECK_PERMISSION`:

- Kiểm tra quyền bằng cách liên kết các bảng, và chỉ cho phép truy cập vào tài nguyên hệ thống nếu staff/admin có quyền truy cập vào tài nguyên đó.
- Miêu tả nhanh như dưới đây.

```{=typst}
#figure(
    raw(read("code/ch04-f_check_permission.sql"), lang: "sql", block: true),
    caption: [An Toàn Thông Tin -- Hàm Kiểm Tra Quyền]
)
```

Luôn sử dụng hàm `F_CHECK_PERMISSION` trên mọi thao thác của *Nhân Viên*, để đảm bảo *Nhân Viên* có quyền thực hiện thao tác đó.

- Ví dụ: Thủ tục Hủy đơn Đặt Phòng.

```{=typst}
#figure(
    raw(read("code/ch04-f_check_permission_ex.sql"), lang: "sql", block: true),
    caption: [An Toàn Thông Tin -- Sử Dụng Hàm Kiểm Tra Quyền]
)
```

#### OBAC (Ownership-Based Access Control) Cho Khách Hàng

- Quyền hạn được kiểm tra dựa trên tính sở hữu dữ liệu.

```{=typst}
#co-warn[Mọi thủ tục dành cho #emph[Khách Hàng] đều cần có logic kiểm tra tính sở hữu dữ liệu. Mỗi Khách Hàng chỉ được phép thao tác trên dữ liệu thuộc về người đó.]
```

Ví dụ 1: Đối với End User, quyền "Đặt Phòng" là quyền mặc định. Ta chỉ cần kiểm tra: User có tồn tại và đang hoạt động hay không.

```{=typst}
#figure(
    raw(read("code/ch04-obac-ex1.sql"), lang: "sql", block: true),
    caption: [An Toàn Thông Tin -- OBAC đối với USERS -- Ví dụ 1.]
)
```

Ví dụ 2: Trong thủ tục Hủy Đặt Phòng (giả sử), hệ thống bắt buộc kiểm tra điều kiện `WHERE user_id = @CurrentUserId` để đảm bảo người dùng chỉ có thể thao tác trên các đơn đặt phòng của chính họ.

```{=typst}
#figure(
    raw(read("code/ch04-obac-ex2.sql"), lang: "sql", block: true),
    caption: [An Toàn Thông Tin -- OBAC đối với USERS -- Ví dụ 2.]
)
```

### Sao Lưu & Phục Hồi

Để đảm bảo tính sẵn sàng (Availability) và liên tục (Business Contuinity) cũng như khả năng phục hồi sau thảm họa (Disaster Recovery), quy trình sao lưu dữ liệu được thực hiện định kỳ với chiến lược sao lưu dữ liệu được đề xuất sau đây.

- Full Backup: Thực hiện định kỳ vào 00:00 Chủ Nhật hàng tuần.
    - Mỗi bản Full backup được lưu giữ trong 2 tuần.
- Differential Backup: Thực hiện vào 00:00 các ngày trong tuần.
    - Mỗi bản Differential backup được lưu giữ trong 1 tuần.
- Export/Import: Sử dụng trong các tình huống cụ thể.
    - Không quy định thời gian lưu giữ, tùy tình huống hoặc yêu cầu khi thực hiện.
    - Cần có bản ghi chú về thời gian, và mục đích tạo.

#### Backup – Restore Dữ Liệu

**Backup:**

1. Chuột phải vào Database, chọn *Task* > *Back Up...*.
2. Chọn *Full* hoặc *Differential* trong mục *Backup type*. Chọn *Destination* là *Disk*
3. Thêm đường dẫn thư mục lưu file backup.
4. Nhấn *OK*.
5. Thông báo Hoàn Thành.

<!-- ![Backup - 01 - Task > Back Up.](images/backup-01.jpg.jpeg) -->


<!-- ![Backup - 02 - Backup Type.](images/backup-02.jpg.jpeg) -->


<!-- ![Backup - 03 - Backup Destination.](images/backup-03.jpg.jpeg) -->


<!-- ![Backup - 04 - Xác Nhận.](images/backup-04.jpg.jpeg) -->


<!-- ![Backup - 05 - Backup Hoàn Thành.](images/backup-05.jpg.jpeg) -->

**Restore:**

1. Chuột phải vào mục Database của Server, chọn *Restore Database...*.
2. Chọn *Source* là *Device* và chọn *File name* là file backup.
3. Chọn file `.bak` để khôi phục.
4. Chọn *Destination* là *Database* và đặt tên *Database* là *BookingMS*.
5. Thông báo Hoàn Thành.
6. Kiểm tra các thành phần của Database vừa được khôi phục.

<!-- ![Restore - 01 - Restore Database.](images/restore-01.jpg.jpeg) -->


<!-- ![Restore - 02 - Source.](images/restore-02.jpg.jpeg) -->


<!-- ![Restore - 03 - Destination.](images/restore-03.jpg.jpeg) -->


<!-- ![Restore - 04 - Xác Nhận.](images/restore-04.jpg.jpeg) -->


<!-- ![Restore - 05 - Restore Hoàn Thành.](images/restore-05.jpg.jpeg) -->


<!-- ![Restore - 06 - Kiểm Tra.](images/restore-06.jpg.jpeg) -->

#### Export - Import Dữ Liệu

**Export:**

1. Chuột phải vào Database cần Export, chọn *Task* > *Export Data-Tier Application...*.
2. Chọn *Next* ở trang *Introduction*.
3. Ở trang *Export Settings*, mục *Save to local disk*, chỉ định đường dẫn lưu file `.bacpac`.
4. Ở trang *Export Settings*, *Next* và chọn các thành phần (*tables*) cần export.
5. Ở trang *Summary*, xác nhận thông tin và nhấn *Finish*.
6. Kiểm tra tiến độ và kết quả ở trang *Results*.
7. Kiểm tra kết quả và chắc chắn file `.bacpac` đã được tạo thành công.

<!-- ![Export - 01 - Task > Export Data-Tier Application.](images/export-01.jpg.jpeg)


![Export - 02 - Introduction.](images/export-02.jpg.jpeg)


![Export - 03 - Export Settings.](images/export-03.jpg.jpeg)


![Export - 04 - Export Settings.](images/export-04.jpg.jpeg)


![Export - 05 - Summary.](images/export-05.jpg.jpeg)


![Export - 06 - Results.](images/export-06.jpg.jpeg)


![Export - 07 - Kiểm Tra.](images/export-07.jpg.jpeg) -->

**Import:**

1. Chuột phải vào Database cần Import, chọn *Import Data-Tier Application...*.
2. Chọn *Next* ở trang *Introduction*.
3. Chọn *Browse* để tìm file `.bacpac`.
4. Ở trang *Database Settings*, đặt tên cho database tại *New database name*.
5. Ở trang *Summary*, xác nhận thông tin và nhấn *Finish*.
6. Kiểm tra tiến độ và kết quả ở trang *Results*.
7. Kiểm tra kết quả bằng cách xem các thành phần của Database vừa được import.

<!-- 1. Chuột phải vào Database cần Import, chọn *Import Data-Tier Application...*.

![Import - 01 - Import Data-Tier Application.](images/import-01.jpg.jpeg)

2. Chọn *Next* ở trang *Introduction*.

![Import - 02 - Introduction.](images/import-02.jpg.jpeg)

3. Chọn *Browse* để tìm file `.bacpac`.

![Import - 03 - Browse.](images/import-03.jpg.jpeg)

4. Ở trang *Database Settings*, đặt tên cho database tại *New database name*.

![Import - 04 - Database Settings.](images/import-04.jpg.jpeg)

5. Ở trang *Summary*, xác nhận thông tin và nhấn *Finish*.

![Import - 05 - Summary.](images/import-05.jpg.jpeg)

6. Kiểm tra tiến độ và kết quả ở trang *Results*.

![Import - 06 - Results.](images/import-06.jpg.jpeg)

7. Kiểm tra kết quả bằng cách xem các thành phần của Database vừa được import.

![Import - 07 - Kiểm Tra.](images/import-07.jpg.jpeg) -->
