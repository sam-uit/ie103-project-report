# Quick Start: Auto-Discovery System

## ✅ Đã Hoàn Thành

Hệ thống tự động load demos từ thư mục `sql-demo/` - không cần hardcode config!

## 🚀 Cách Sử Dụng

### Xem Demos Hiện Tại

1. Mở browser: `http://localhost:5173`
2. Vào "Xử lý thông tin"
3. Thấy tất cả demos được load tự động từ `sql-demo/`

### Thêm Demo Mới (3 Bước)

#### **Bước 1:** Tạo thư mục

```bash
mkdir -p sql-demo/Trigger/Demo_MyDemo
```

#### **Bước 2:** Tạo 3 files

- `config.json`:

```json
{
  "id": "trg-my-demo",
  "title": "Trigger X: Tên Demo",
  "type": "Trigger",
  "shortDesc": "Mô tả",
  "mdFile": "Trigger/Demo_MyDemo/problem.md",
  "sqlFile": "Trigger/Demo_MyDemo/script.sql",
  "tables": ["TABLE"],
  "columns": [{"key": "id", "label": "ID", "isPk": true}],
  "params": []
}
```

- `problem.md`: Theo cấu trúc B1-B5
- `script.sql`: SQL code

#### **Bước 3:** Update manifest

```json
// sql-demo/Trigger/manifest.json
{
  "demos": ["Demo_CheckTime", "Demo_MyDemo"]
}
```

#### **Bước 4:** Reload browser

- **Reload browser** → Demo mới xuất hiện!

## 📁 Demos Hiện Tại

- ✅ 5 Trigger demos (Demo_CheckTime, Demo_AutoPrice, Demo_SyncStatus, Demo_Payment, Demo_Refund)
- Mỗi demo có: config.json, problem.md, script.sql

## 🔍 Debug

Mở Console (F12) để xem:

- `🔍 Scanning sql-demo folder...`
- `✅ Found X demos: [...]`
