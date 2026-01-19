# Hướng Dẫn Cấu Hình Hệ Thống

Hệ thống đã được cập nhật để sử dụng cấu trúc file cấu hình chia nhỏ, giúp việc quản lý dữ liệu dễ dàng hơn.

Các file cấu hình nằm trong thư mục: `public/config/`

---

## 1. Danh sách file cấu hình

Mỗi file JSON tương ứng với một mục trên thanh Menu của ứng dụng:

1.  **`settings.json`** -> Cài đặt chung (Tiêu đề, phiên bản).
2.  **`overview.json`** -> Dữ liệu hiển thị trang **Tổng quan**.
3.  **`scenarios.json`** -> Danh sách các bài demo ở trang **Xử lý thông tin**.
4.  **`reports.json`** -> Các nhóm tài liệu ở trang **Trình bày thông tin**.
5.  **`team.json`** -> Danh sách sinh viên ở trang **Thành Viên Nhóm**.

---

## 2. Chi tiết từng file

### A. `settings.json`
```json
{
  "title": "Hệ Thống BMS",
  "description": "Mô tả ngắn...",
  "version": "2.0"
}
```

### B. `scenarios.json` (Quan trọng)
Đây là một **Danh sách (Array)** chứa các kịch bản demo.
```json
[
  {
    "id": "sp-01",
    "title": "Tên kịch bản",
    "type": "Stored Procedure",
    "tables": ["TEN_BANG"],
    "columns": [...],
    "mockData": { ... }
    // ... các trường khác
  },
  { ... kịch bản tiếp theo ... }
]
```

### C. `reports.json`
Danh sách các nhóm báo cáo.
```json
[
  {
    "id": "group-1",
    "title": "Báo Cáo Tài Chính",
    "description": "...",
    "files": [
       { "name": "Báo cáo 1.pdf", "url": "..." }
    ]
  }
]
```

### D. `team.json`
Danh sách thành viên.
```json
[
  { "mssv": "123", "name": "Nguyen Van A", "tasks": "Dev" },
  { "mssv": "456", "name": "Tran Van B", "tasks": "Test" }
]
```

---

## 3. Lưu ý
*   Khi sửa file, hãy đảm bảo **đúng cú pháp JSON**.
*   Sau khi lưu file, chỉ cần **Reload (F5)** trình duyệt để thấy thay đổi.
*   File `public/config.json` cũ không còn được sử dụng.
