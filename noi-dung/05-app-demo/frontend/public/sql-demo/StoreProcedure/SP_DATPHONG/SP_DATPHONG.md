# 📘 STORED PROCEDURES – Đặt phòng

## SP_DATPHONG – Đặt phòng


### 📌 Mục đích
Thực hiện chức năng **đặt phòng** cho người dùng:
- Kiểm tra phòng tồn tại và khả dụng
- Tạo bản ghi đặt phòng
- Lưu chi tiết phòng
- Cập nhật trạng thái phòng


---


### 📥 Tham số vào

| Tên tham số | Kiểu dữ liệu | Bắt buộc | Mô tả |
|------------|------------|----------|------|
| `@UserId` | INT | ✔ | ID người dùng |
| `@SoPhong` | NVARCHAR(20) | ✔ | Số phòng |
| `@CheckIn` | DATETIME | ✔ | Thời gian check-in |
| `@CheckOut` | DATETIME | ✔ | Thời gian check-out |
| `@VoucherId` | INT | ✖ | Voucher (nếu có) |

---

### 🔄 Luồng xử lý
1. Kiểm tra phòng có tồn tại và đang `AVAILABLE`
2. Kiểm tra thời gian check-in / check-out hợp lệ
3. Lấy đơn giá phòng
4. Tạo bản ghi trong `DATPHONG`
5. Tạo chi tiết trong `CT_DATPHONG`
6. Cập nhật trạng thái phòng → `RESERVED`

---

### ✅ Ví dụ gọi

```sql
EXEC SP_DATPHONG
    @UserId = 5,
    @SoPhong = '101',
    @CheckIn = '2024-02-20 14:00:00',
    @CheckOut = '2024-02-22 12:00:00',
    @VoucherId = NULL;
