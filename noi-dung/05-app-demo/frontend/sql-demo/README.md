# Hướng Dẫn Cấu Hình SQL Demo

Thư mục này chứa các kịch bản demo SQL được tổ chức theo loại: `StoreProcedure`, `Trigger`, `Function`, `Cursor`. Hệ thống sẽ tự động quét (auto-discovery) các thư mục này để nạp vào ứng dụng.

## Cấu Trúc Thư Mục

Mỗi demo là một thư mục riêng biệt (ví dụ: `StoreProcedure/Demo_RegisterUser`) và **BẮT BUỘC** phải có các file sau:

1.  **`config.json`**: File cấu hình chính định nghĩa UI và logic data.
2.  **`script.sql`** (hoặc tên khác đuôi .sql): Chứa mã SQL thực thi chính (tạo SP, Trigger, hoặc đoạn script chạy demo).
3.  **`problem.html`** (hoặc .md): Mô tả bài toán/yêu cầu nghiệp vụ hiển thị trên UI.

---

## Cấu Hình `config.json`

Đây là file quan trọng nhất để điều khiển hiển thị trên trang `ScenarioDetail`.

### Mẫu Chuẩn (Standard Format)

```json
{
  "id": "unique-id",
  "title": "Tiêu đề Demo",
  "type": "Stored Procedure",
  "shortDesc": "Mô tả ngắn gọn",
  "mdFile": "StoreProcedure/Demo_Name/problem.html",
  "sqlFile": "StoreProcedure/Demo_Name/script.sql",
  "separateTables": [
    {
      "name": "MY_TABLE",
      "label": "📋 Tiêu Đề Tab",
      "sqlBefore": "SELECT * FROM MY_TABLE WHERE id = @Id",
      "sqlAfter": "SELECT * FROM MY_TABLE WHERE id = @Id",
      "sqlFetchInitial": "SELECT TOP 20 * FROM MY_TABLE ORDER BY id DESC",
      "columns": [
        { "key": "id", "label": "ID", "isPk": true },
        { "key": "name", "label": "Tên" },
        { "key": "status", "label": "⚡ Trạng Thái" } 
      ]
    }
  ],
  "params": [
    { "name": "@Id", "type": "int", "defaultValue": 1 },
    { "name": "@Name", "type": "string", "defaultValue": "Test" }
  ]
}
```

### Giải Thích Chi Tiết

#### 1. Thông tin chung
*   `id`: Mã định danh duy nhất (dùng cho URL).
*   `mdFile` / `sqlFile`: Đường dẫn tương đối từ `frontend/sql-demo`.

#### 2. `separateTables` (Quan Trọng)
Định nghĩa các bảng dữ liệu sẽ hiển thị trong phần kết quả. Mỗi item trong mảng này sẽ tạo ra một **Tab** riêng biệt trên UI.

*   **`name`**: Tên bảng (dùng làm key nội bộ).
*   **`label`**: Tên hiển thị trên Tab (có thể dùng emoji).
*   **`sqlFetchInitial`**: 
    *   Query dùng cho nút **"Show Tables"** (Preview).
    *   Thường là `SELECT TOP 20 ...` không có điều kiện `WHERE` phức tạp để người dùng xem dữ liệu trước khi chạy.
    *   Nếu không có trường này, hệ thống sẽ tự động dùng `sqlBefore` và cắt bỏ phần `WHERE`.
*   **`sqlBefore`**:
    *   Query để lấy trạng thái **TRƯỚC** khi chạy script chính (khi nhấn Execute).
    *   **Bắt buộc** phải dùng tham số (ví dụ `@Id`) để chỉ lấy đúng dòng dữ liệu sẽ bị tác động.
*   **`sqlAfter`**:
    *   Query để lấy trạng thái **SAU** khi chạy script chính.
    *   Thường giống hệt `sqlBefore`.
*   **`columns`**: Định nghĩa các cột hiển thị.
    *   `isPk`: Đánh dấu khóa chính (để tính diff).
    *   Thêm `⚡` vào `label` để làm nổi bật các cột quan trọng (thường là các cột sẽ thay đổi).

#### 3. `params`
Danh sách tham số đầu vào cho user nhập.
*   `type`: `int`, `string`, `decimal`, `datetime`, `boolean`.
*   `defaultValue`: Giá trị mặc định.
*   `isOutput`: `true` nếu là tham số OUTPUT của Stored Procedure (UI sẽ ẩn hoặc readonly).

---

## Luồng Xử Lý Dữ Liệu (Data Flow)

1.  **Khi Load Trang**: Chưa load dữ liệu bảng ngay.
2.  **Nhấn "Show Tables"**: 
    *   Hệ thống chạy `sqlFetchInitial` của từng bảng trong `separateTables`.
    *   Hiển thị tab **"Initial State"**.
3.  **Nhấn "EXECUTE"**:
    *   Frontend gửi lên Server:
        *   Script chính (`sqlContent`).
        *   Các câu query `sqlBefore` và `sqlAfter` của từng bảng.
        *   Tham số (`params`).
    *   Server thực thi theo thứ tự:
        1.  Chạy `sqlBefore` -> Lưu kết quả "Before".
        2.  Chạy Script chính (Transaction).
        3.  Chạy `sqlAfter` -> Lưu kết quả "After".
        4.  So sánh và tạo **Server-side Diff**.
    *   Frontend nhận kết quả và hiển thị 3 tab: **Before**, **Diff**, **After**.

## Lưu Ý Khi Tạo Demo Mới
*   Luôn định nghĩa `isPk: true` cho ít nhất 1 cột trong `columns` để tính năng Diff hoạt động chính xác.
*   Query `sqlBefore` và `sqlAfter` nên trả về cùng cấu trúc cột.
*   Không cần định nghĩa `tables` hay `columns` ở cấp root (đã bỏ deprecated).
