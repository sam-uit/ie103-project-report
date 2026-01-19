# Hướng Dẫn Sử Dụng Hệ Thống Demo Auto-Discovery

## Cách Hoạt Động

Hệ thống tự động scan thư mục `sql-demo/` và load tất cả demos mà không cần hardcode trong config.

### Cấu Trúc

```
sql-demo/
├── Trigger/
│   ├── manifest.json          ← Danh sách demos
│   ├── Demo_CheckTime/
│   │   ├── config.json        ← Metadata demo
│   │   ├── problem.md
│   │   └── script.sql
│   └── Demo_AutoPrice/
│       ├── config.json
│       ├── problem.md
│       └── script.sql
├── StoreProcedure/
│   ├── manifest.json
│   └── ...
├── Function/
│   ├── manifest.json
│   └── ...
└── Cursor/
    ├── manifest.json
    └── ...
```

---

## Thêm Demo Mới (3 Bước)

### 1. Tạo Thư Mục Demo

```bash
mkdir -p sql-demo/Trigger/Demo_MyTrigger
```

### 2. Tạo 3 Files

**config.json:**
```json
{
  "id": "trg-my-trigger",
  "title": "Trigger X: Tên Demo",
  "type": "Trigger",
  "shortDesc": "Mô tả ngắn",
  "mdFile": "Trigger/Demo_MyTrigger/problem.md",
  "sqlFile": "Trigger/Demo_MyTrigger/script.sql",
  "tables": ["TABLE_NAME"],
  "columns": [
    { "key": "id", "label": "ID", "isPk": true }
  ],
  "params": []
}
```

**problem.md:** (Theo cấu trúc B1-B5)

**script.sql:** (SQL code)

### 3. Cập Nhật manifest.json

Thêm tên folder vào `sql-demo/Trigger/manifest.json`:

```json
{
  "demos": [
    "Demo_CheckTime",
    "Demo_AutoPrice",
    "Demo_MyTrigger"  ← Thêm dòng này
  ]
}
```

### 4. Reload Browser

Nhấn F5 → Demo mới sẽ xuất hiện tự động!

---

## Cách Frontend Load Demos

1. **Scan manifest files**: Load `manifest.json` từ mỗi type folder
2. **Load configs**: Với mỗi demo trong manifest, load `config.json`
3. **Display**: Hiển thị tất cả demos trong Dashboard
4. **Execute**: Khi click EXECUTE, load `script.sql` và gửi lên server

---

## Lợi Ích

- ✅ **Không cần sửa code**: Chỉ thêm files trong sql-demo
- ✅ **Tự động discover**: Frontend tự tìm và load demos
- ✅ **Dễ quản lý**: Mỗi demo tự chứa metadata
- ✅ **Scalable**: Thêm bao nhiêu demo cũng được

---

## Troubleshooting

### Demo không hiện

1. Kiểm tra `manifest.json` đã thêm tên folder chưa
2. Kiểm tra `config.json` có đúng format không
3. Xem console browser (F12) để check lỗi

### SQL không execute

1. Kiểm tra `sqlFile` path trong config.json
2. Kiểm tra file `script.sql` có tồn tại không
3. Verify SQL syntax

---

## Files Cần Thiết

Mỗi demo folder **BẮT BUỘC** có:
- ✅ `config.json` - Metadata
- ✅ `script.sql` - SQL code
- ⚠️ `problem.md` - Optional nhưng nên có

Mỗi type folder **BẮT BUỘC** có:
- ✅ `manifest.json` - Danh sách demos
