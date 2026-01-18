# Hướng Dẫn Cài Đặt Dự Án (SQL Demo Manager)

Tài liệu này hướng dẫn chi tiết cách thiết lập môi trường phát triển cho dự án **SQL Demo Manager**.

---

## 1. Cấu trúc thư mục

Dự án được tổ chức như sau:

```
sql-demo-manager/frontend
├── public/
│   ├── config/             # THƯ MỤC CẤU HÌNH (MỚI)
│   │   ├── settings.json   # Cài đặt app
│   │   ├── overview.json   # Trang tổng quan
│   │   ├── scenarios.json  # Kịch bản SQL -> Khai báo theo cấu trúc folder trong thư mục `@sql-demo`
│   │   ├── reports.json    # Báo cáo
│   │   └── team.json       # Thành viên nhóm
│   └── vite.svg
├── server/                 # Mã nguồn Backend
├── src/                    # Mã nguồn Frontend
└── ...
```

## 2. Cách thay đổi nội dung Web

Không cần sửa code React (File `.tsx`), bạn chỉ cần sửa các file `.json` trong thư mục `public/config/`.

*   Muốn thêm bài Demo SQL? -> Sửa sửa trong thư mục `@sql-demo`
*   Muốn thêm Báo cáo? -> Sửa `reports.json`
*   Muốn sửa tên thành viên? -> Sửa `team.json`

(Xem chi tiết trong file `CONFIG_GUIDE.md`)

---

## 3. Cài đặt & Chạy (Dev)

### Backend (Node.js)
```bash
cd server
npm install
npm start
```

### Frontend (React/Vite)
```bash
# Tại thư mục gốc
npm install
npm run dev
```
Truy cập: `http://localhost:5173`

---
### **Lưu ý:** Nếu website báo lỗi không load được config, hãy kiểm tra lại cú pháp JSON trong thư mục `public/config/`. Node version 18++
