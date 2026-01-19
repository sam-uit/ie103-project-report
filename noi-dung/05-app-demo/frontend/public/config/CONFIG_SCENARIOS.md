# 📚 Hướng Dẫn Cấu Hình File `scenarios.json`

## 🎯 Tổng Quan

File `scenarios.json` là file cấu hình chính để định nghĩa các demo cho Stored Procedures, Triggers, và Cursors trong SQL Demo Manager. Mỗi scenario sẽ hiển thị:
* Code SQL của procedure/cursor
* Input parameters để test
* Dữ liệu trước và sau khi thực thi
* So sánh thay đổi (diff view)

---

## 📋 Cấu Trúc Cơ Bản

File `scenarios.json` là một mảng JSON chứa các scenario objects:

```json
[
  {
    "id": "scenario-id",
    "title": "Tên hiển thị",
    "type": "Stored Procedure",
    "shortDesc": "Mô tả ngắn",
    "sqlFile": "filename.sql",
    "tables": ["TABLE1", "TABLE2"],
    "params": [...],
    "columns": [...],
    "sqlFetchInitial": "SELECT ...",
    "sqlFetchBefore": "SELECT ...",
    "sqlFetchAfter": "SELECT ...",
    "mockData": {...}
  },
  ...
]
```

---

## 🔑 Các Trường Bắt Buộc

### 1. `id` (string, bắt buộc)

**Định danh duy nhất** cho scenario. Dùng trong URL routing.

```json
"id": "sp-apply-voucher"
```

**Quy tắc:**
* Chỉ dùng chữ thường, số, và dấu gạch ngang `-`
* Không có khoảng trắng hoặc ký tự đặc biệt
* Nên bắt đầu bằng prefix: `sp-` (Stored Procedure),  `cs-` (Cursor),  `tg-` (Trigger)

---

### 2. `title` (string, bắt buộc)

**Tiêu đề hiển thị** trên UI.

```json
"title": "SP: Áp Dụng Voucher Giảm Giá"
```

**Tips:**
* Nên có prefix rõ ràng: `SP:`,  `Cursor:`,  `Trigger:`
* Dùng tiếng Việt có dấu để dễ đọc
* Ngắn gọn nhưng đầy đủ ý nghĩa

---

### 3. `type` (string, bắt buộc)

**Loại script SQL**. Hiển thị badge trên UI.

```json
"type": "Stored Procedure"
```

**Các giá trị hợp lệ:**
* `"Stored Procedure"`
* `"Cursor"`
* `"Trigger"`
* `"Function"`

---

### 4. `shortDesc` (string, bắt buộc)

**Mô tả ngắn** về chức năng của scenario.

```json
"shortDesc": "Gán voucher vào booking, tăng số lần dùng voucher, tính tiền giảm."
```

**Tips:**
* Nên dưới 150 ký tự
* Tóm tắt logic chính
* Liệt kê các thay đổi quan trọng

---

### 5. `sqlFile` (string, bắt buộc)

**Tên file SQL** trong thư mục `/backend/sql/` .

```json
"sqlFile": "sp_ApplyVoucher.sql"
```

**Lưu ý:**
* File phải tồn tại trong `/backend/sql/`
* Tên file chính xác, phân biệt hoa thường

---

### 6. `tables` (array, bắt buộc)

**Danh sách tên bảng** bị ảnh hưởng bởi scenario.

```json
"tables": ["VOUCHERS", "DATPHONG"]
```

**Mục đích:**
* Hiển thị metadata trên UI
* Giúp user biết script này làm việc với bảng nào

---

### 7. `columns` (array, bắt buộc)

**Định nghĩa các cột** hiển thị trong bảng kết quả.

```json
"columns": [
  { "key": "id", "label": "Booking ID", "isPk": true },
  { "key": "user_id", "label": "User ID" },
  { "key": "voucher_id", "label": "⚡ Voucher Gán" }
]
```

**Cấu trúc mỗi column:**
* `key` (string, bắt buộc): Tên cột trong kết quả SQL (phải khớp với SELECT)
* `label` (string, bắt buộc): Nhãn hiển thị trên UI
* `isPk` (boolean, optional): `true` nếu là Primary Key (sẽ highlight màu vàng)

**Tips:**
* Dùng emoji `⚡` để đánh dấu cột có thay đổi quan trọng
* Primary Key dùng để so sánh diff giữa before/after

---

## 📊 Các Trường SQL Query

### 8. `sqlFetchInitial` (string, bắt buộc)

**Query lấy dữ liệu ban đầu** để hiển thị overview (không filter theo params).

```json
"sqlFetchInitial": "SELECT TOP 20 id, user_id, voucher_id FROM DATPHONG ORDER BY created_at DESC"
```

**Quy tắc:**
* KHÔNG có WHERE với parameters
* Dùng `TOP N` để giới hạn số rows (tránh quá nhiều)
* ORDER BY để data có thứ tự logic

---

### 9. `sqlFetchBefore` (string, bắt buộc)

**Query lấy dữ liệu TRƯỚC** khi execute scenario (có filter theo params).

```json
"sqlFetchBefore": "SELECT id, user_id, voucher_id FROM DATPHONG WHERE id = @DatPhongId"
```

**Quy tắc:**
* CÓ WHERE với `@ParamName` để filter data cụ thể
* Phải khớp với các params đã định nghĩa
* Trả về data liên quan đến test case

---

### 10. `sqlFetchAfter` (string, bắt buộc)

**Query lấy dữ liệu SAU** khi execute scenario (có filter theo params).

```json
"sqlFetchAfter": "SELECT id, user_id, voucher_id FROM DATPHONG WHERE id = @DatPhongId"
```

**Quy tắc:**
* Giống `sqlFetchBefore` nhưng chạy SAU khi execute SP/Cursor
* Dùng cùng WHERE clause để so sánh chính xác
* Kết quả sẽ được diff với `sqlFetchBefore`

---

## 🎛️ Parameters Configuration

### 11. `params` (array, bắt buộc)

**Định nghĩa input parameters** cho Stored Procedure/Cursor.

```json
"params": [
  { "name": "@DatPhongId", "type": "int", "defaultValue": 4 },
  { "name": "@VoucherCode", "type": "string", "defaultValue": "DISCOUNT10" },
  { "name": "@CheckIn", "type": "datetime", "defaultValue": "2026-02-01 14:00:00" }
]
```

**Cấu trúc mỗi param:**
* `name` (string, bắt buộc): Tên parameter (bắt đầu bằng `@`)
* `type` (string, bắt buộc): Kiểu dữ liệu
* `defaultValue` (any, bắt buộc): Giá trị mặc định

**Các type hợp lệ:**
* `"int"` - Số nguyên
* `"decimal"` / `"float"` - Số thực
* `"string"` / `"nvarchar"` - Chuỗi
* `"datetime"` / `"date"` - Ngày giờ
* `"boolean"` / `"bit"` - True/False

**Format cho datetime:**

```json
"defaultValue": "2026-02-01 14:00:00"
```

**Nếu không có params:**

```json
"params": []
```

---

## 📦 Mock Data (Optional)

### 12. `mockData` (object, optional)

**Dữ liệu giả** để hiển thị khi backend offline hoặc test UI.

```json
"mockData": {
  "before": [
    { "id": 1, "user_id": 1, "voucher_id": null }
  ],
  "after": [
    { "id": 1, "user_id": 1, "voucher_id": 2 }
  ]
}
```

**Cấu trúc:**
* `before` (array): Data trước khi execute
* `after` (array): Data sau khi execute

**Lưu ý:**
* Các key trong object phải khớp với `columns[].key`
* Dùng cho testing hoặc demo mode

---

## 🗂️ Separate Tables Mode (Advanced)

### 13. `separateTables` (array, optional)

**Hiển thị nhiều bảng riêng biệt** thay vì 1 bảng merge. Dùng cho scenarios phức tạp với nhiều bảng.

```json
"separateTables": [
  {
    "name": "DATPHONG",
    "label": "📋 Bảng Đặt Phòng",
    "sqlBefore": "SELECT id, user_id, voucher_id FROM DATPHONG WHERE id = @DatPhongId",
    "sqlAfter": "SELECT id, user_id, voucher_id FROM DATPHONG WHERE id = @DatPhongId",
    "columns": [
      { "key": "id", "label": "ID", "isPk": true },
      { "key": "user_id", "label": "User" },
      { "key": "voucher_id", "label": "⚡ Voucher Gán" }
    ]
  },
  {
    "name": "VOUCHERS",
    "label": "🎟️ Bảng Vouchers",
    "sqlBefore": "SELECT id, ma_code, so_lan_da_dung FROM VOUCHERS WHERE ma_code = @VoucherCode",
    "sqlAfter": "SELECT id, ma_code, so_lan_da_dung FROM VOUCHERS WHERE ma_code = @VoucherCode",
    "columns": [
      { "key": "id", "label": "ID", "isPk": true },
      { "key": "ma_code", "label": "Mã Code" },
      { "key": "so_lan_da_dung", "label": "⚡ Đã Dùng" }
    ]
  }
]
```

**Cấu trúc mỗi table:**
* `name` (string, bắt buộc): Tên bảng (unique identifier)
* `label` (string, bắt buộc): Nhãn hiển thị trên tab (có thể dùng emoji)
* `sqlBefore` (string, bắt buộc): Query lấy data trước execute
* `sqlAfter` (string, bắt buộc): Query lấy data sau execute
* `columns` (array, bắt buộc): Định nghĩa cột (giống như trường `columns` chính)

**Khi dùng `separateTables` :**
* UI sẽ hiển thị tabs để switch giữa các bảng
* Mỗi tab sẽ lazy load data khi click
* Diff view sẽ hiển thị riêng cho từng bảng
* Vẫn CẦN giữ các trường `sqlFetchBefore` và `sqlFetchAfter` (cho merged view nếu cần)

**Khi KHÔNG dùng `separateTables` :**
* Chỉ hiển thị 1 bảng kết quả merge
* Dùng `columns`,  `sqlFetchBefore`,  `sqlFetchAfter` như bình thường

---

## 📝 Ví Dụ Hoàn Chỉnh

### Ví Dụ 1: Stored Procedure Đơn Giản (Không có separateTables)

```json
{
  "id": "sp-cancel-room",
  "title": "SP: Hủy Đặt Phòng",
  "type": "Stored Procedure",
  "shortDesc": "Chuyển trạng thái PENDING → CANCELLED. Chỉ cho phép hủy khi chưa check-in.",
  "sqlFile": "sp_CancelRoom.sql",
  "tables": ["DATPHONG"],
  "sqlFetchInitial": "SELECT TOP 20 id, user_id, trang_thai FROM DATPHONG ORDER BY created_at DESC",
  "sqlFetchBefore": "SELECT id, user_id, trang_thai FROM DATPHONG WHERE id = @BookingId",
  "sqlFetchAfter": "SELECT id, user_id, trang_thai FROM DATPHONG WHERE id = @BookingId",
  "columns": [
    { "key": "id", "label": "Booking ID", "isPk": true },
    { "key": "user_id", "label": "User ID" },
    { "key": "trang_thai", "label": "Trạng Thái" }
  ],
  "params": [
    { "name": "@BookingId", "type": "int", "defaultValue": 1 },
    { "name": "@UserId", "type": "int", "defaultValue": 1 },
    { "name": "@LyDo", "type": "string", "defaultValue": "Thay đổi kế hoạch" }
  ],
  "mockData": {
    "before": [
      { "id": 1, "user_id": 1, "trang_thai": "PENDING" }
    ],
    "after": [
      { "id": 1, "user_id": 1, "trang_thai": "CANCELLED" }
    ]
  }
}
```

---

### Ví Dụ 2: Stored Procedure Phức Tạp (Có separateTables)

```json
{
  "id": "sp-apply-voucher",
  "title": "SP: Áp Dụng Voucher Giảm Giá",
  "type": "Stored Procedure",
  "shortDesc": "Gán voucher vào booking, tăng số lần dùng voucher, tính tiền giảm.",
  "sqlFile": "sp_ApplyVoucher.sql",
  "tables": ["VOUCHERS", "DATPHONG"],
  "separateTables": [
    {
      "name": "DATPHONG",
      "label": "📋 Bảng Đặt Phòng",
      "sqlBefore": "SELECT id, user_id, voucher_id FROM DATPHONG WHERE id = @DatPhongId",
      "sqlAfter": "SELECT id, user_id, voucher_id FROM DATPHONG WHERE id = @DatPhongId",
      "columns": [
        { "key": "id", "label": "ID", "isPk": true },
        { "key": "user_id", "label": "User" },
        { "key": "voucher_id", "label": "⚡ Voucher Gán" }
      ]
    },
    {
      "name": "VOUCHERS",
      "label": "🎟️ Bảng Vouchers",
      "sqlBefore": "SELECT id, ma_code, so_lan_da_dung, trang_thai FROM VOUCHERS WHERE ma_code = @VoucherCode",
      "sqlAfter": "SELECT id, ma_code, so_lan_da_dung, trang_thai FROM VOUCHERS WHERE ma_code = @VoucherCode",
      "columns": [
        { "key": "id", "label": "ID", "isPk": true },
        { "key": "ma_code", "label": "Mã Code" },
        { "key": "so_lan_da_dung", "label": "⚡ Đã Dùng" },
        { "key": "trang_thai", "label": "Status" }
      ]
    }
  ],
  "sqlFetchInitial": "SELECT TOP 20 dp.id, dp.voucher_id, v.ma_code FROM DATPHONG dp LEFT JOIN VOUCHERS v ON dp.voucher_id = v.id",
  "sqlFetchBefore": "SELECT dp.id, dp.voucher_id, v.so_lan_da_dung FROM DATPHONG dp CROSS JOIN VOUCHERS v WHERE dp.id = @DatPhongId AND v.ma_code = @VoucherCode",
  "sqlFetchAfter": "SELECT dp.id, dp.voucher_id, v.so_lan_da_dung FROM DATPHONG dp LEFT JOIN VOUCHERS v ON dp.voucher_id = v.id WHERE dp.id = @DatPhongId",
  "columns": [
    { "key": "id", "label": "Booking ID", "isPk": true },
    { "key": "voucher_id", "label": "⚡ Voucher Đã Gán" },
    { "key": "so_lan_da_dung", "label": "⚡ Đã Dùng" }
  ],
  "params": [
    { "name": "@DatPhongId", "type": "int", "defaultValue": 4 },
    { "name": "@VoucherCode", "type": "string", "defaultValue": "DISCOUNT10" }
  ],
  "mockData": {
    "before": [
      { "id": 4, "voucher_id": null, "so_lan_da_dung": 0 }
    ],
    "after": [
      { "id": 4, "voucher_id": 2, "so_lan_da_dung": 1 }
    ]
  }
}
```

---

### Ví Dụ 3: Cursor (Read-Only, Không Có Params)

```json
{
  "id": "cs-book-revenue-report",
  "title": "Cursor: Báo Cáo Doanh Thu",
  "type": "Cursor",
  "shortDesc": "Cursor READ-ONLY: Duyệt qua DATPHONG, tính tổng tiền phòng + dịch vụ.",
  "sqlFile": "cs_BookRevenueReport.sql",
  "tables": ["DATPHONG", "CT_DATPHONG", "CT_SUDUNG_DV"],
  "sqlFetchInitial": "SELECT TOP 20 dp.id, u.full_name, dp.trang_thai FROM DATPHONG dp JOIN USERS u ON dp.user_id = u.id",
  "sqlFetchBefore": "SELECT dp.id, u.full_name, 0 as tong_cong FROM DATPHONG dp JOIN USERS u ON dp.user_id = u.id",
  "sqlFetchAfter": "SELECT dp.id, u.full_name, (ISNULL(SUM(ct.don_gia), 0) + ISNULL(SUM(dv.so_luong * dv.don_gia), 0)) as tong_cong FROM DATPHONG dp JOIN USERS u ON dp.user_id = u.id LEFT JOIN CT_DATPHONG ct ON ct.datphong_id = dp.id LEFT JOIN CT_SUDUNG_DV dv ON dv.datphong_id = dp.id GROUP BY dp.id, u.full_name",
  "columns": [
    { "key": "id", "label": "Booking ID", "isPk": true },
    { "key": "full_name", "label": "Khách Hàng" },
    { "key": "tong_cong", "label": "Tổng Cộng" }
  ],
  "params": [],
  "mockData": {
    "before": [
      { "id": 1, "full_name": "Nguyễn Văn A", "tong_cong": 0 }
    ],
    "after": [
      { "id": 1, "full_name": "Nguyễn Văn A", "tong_cong": 2300000 }
    ]
  }
}
```

---

## 🎨 Best Practices

### ✅ Nên Làm

1. **Dùng emoji cho labels** để dễ phân biệt:
   

```json
   "label": "📋 Bảng Đặt Phòng"
   "label": "⚡ Số Lượng" // Cột có thay đổi
   ```

2. **Đánh dấu Primary Key** để diff chính xác:
   

```json
   { "key": "id", "label": "ID", "isPk": true }
   ```

3. **Dùng `separateTables`** khi có nhiều bảng thay đổi:
   - Dễ theo dõi thay đổi từng bảng
   - Lazy loading giúp performance tốt hơn

4. **Test data thật** trước khi config:
   - Chạy các query SQL trong SSMS
   - Kiểm tra kết quả có đúng columns không

5. **Dùng `TOP N`** trong `sqlFetchInitial`:
   

```sql
   SELECT TOP 20 ... ORDER BY created_at DESC
   ```

6. **WHERE clause nhất quán** giữa Before và After:
   

```sql
   -- Before
   WHERE id = @BookingId
   -- After
   WHERE id = @BookingId  // Giống nhau
   ```

### ❌ Không Nên Làm

1. **Đặt `id` trùng lặp** giữa các scenarios
2. **Thiếu params** trong WHERE clause:
   

```sql
   -- SAI: Thiếu @DatPhongId trong params
   "sqlBefore": "SELECT * FROM DATPHONG WHERE id = @DatPhongId"
   ```

3. **Columns không khớp** với query result:
   

```json
   // SAI: Query trả về "booking_id" nhưng column dùng "id"
   "sqlFetchBefore": "SELECT dp.id as booking_id FROM ...",
   "columns": [{ "key": "id", ... }]  // Sai!
   ```

4. **Quên set `isPk`** cho Primary Key - sẽ làm diff không chính xác

5. **Query quá phức tạp** trong `separateTables`:
   - Nên tách thành nhiều tables đơn giản
   - Tránh nested subqueries quá sâu

---

## 🔍 Troubleshooting

### Lỗi: "No changes detected"

**Nguyên nhân:** Primary key không được set hoặc data before/after giống nhau.

**Giải pháp:**
* Kiểm tra `isPk: true` đã được set cho đúng column
* Verify query `sqlFetchBefore` và `sqlFetchAfter` có filter đúng data
* Test execute SP manually để xem có thay đổi data không

---

### Lỗi: "Column not found"

**Nguyên nhân:** `columns[].key` không khớp với tên cột trong query result.

**Giải pháp:**
* Chạy query trong SSMS và check tên cột trả về
* Đảm bảo dùng alias chính xác:
  

```sql
  SELECT id as booking_id  -- Thì columns.key phải là "booking_id"
  ```

---

### Lỗi: "Parameter @ParamName not provided"

**Nguyên nhân:** Query có `@ParamName` nhưng không có trong `params` array.

**Giải pháp:**
* Thêm param vào `params` array:
  

```json
  "params": [
    { "name": "@ParamName", "type": "int", "defaultValue": 1 }
  ]
  ```

---

### Data không load khi switch tabs

**Nguyên nhân:** Lazy loading chưa hoàn thành hoặc query bị lỗi.

**Giải pháp:**
* Check console log trong browser (F12)
* Verify query `separateTables[].sqlBefore` chạy được trong SSMS
* Đảm bảo backend đang running

---

## 📚 Tài Liệu Tham Khảo

* [SQL Server Data Types](https://learn.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql)
* [Stored Procedures Best Practices](https://learn.microsoft.com/en-us/sql/relational-databases/stored-procedures/stored-procedures-database-engine)
* [JSON Schema Validation](https://json-schema.org/)

---

## 💡 Tips & Tricks

1. **Copy từ scenario tương tự** để tránh lỗi cú pháp
2. **Test từng phần**:
   - Test query riêng trong SSMS trước
   - Test params với default values
   - Test execute SP manual
   - Sau đó mới config vào scenarios.json

3. **Dùng VSCode Extensions**:
   - JSON Tools: Format và validate JSON
   - SQL Server: Test SQL queries

4. **Git commit thường xuyên** khi thêm/sửa scenarios để dễ rollback

5. **Comment trong SQL queries** để dễ hiểu logic:
   

```sql
   -- Lấy booking cụ thể với voucher
   SELECT dp.id, dp.voucher_id 
   FROM DATPHONG dp 
   WHERE dp.id = @DatPhongId
   ```

---

## 🎓 Kết Luận

File `scenarios.json` là trái tim của SQL Demo Manager. Config đúng sẽ giúp:
* ✅ Demo rõ ràng logic của Stored Procedures
* ✅ Dễ test với nhiều test cases khác nhau
* ✅ So sánh before/after một cách trực quan
* ✅ Lazy loading data hiệu quả với separate tables

**Happy Configuring! 🚀**
