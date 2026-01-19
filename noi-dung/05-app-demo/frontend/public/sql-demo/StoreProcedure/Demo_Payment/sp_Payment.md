# 📘 STORED PROCEDURE – THANH TOÁN ĐẶT PHÒNG

---

## Tên Stored Procedure

**SP_THANHTOAN**

---

## Mục đích

Stored Procedure `SP_THANHTOAN` dùng để **xử lý thanh toán cho đặt phòng** trong hệ thống Room Booking:

- Kiểm tra booking hợp lệ
- Kiểm tra số tiền thanh toán có đúng với số tiền cần trả
- Lưu lịch sử thanh toán
- Cập nhật trạng thái đặt phòng khi thanh toán hoàn tất

---

## Bảng liên quan

| Bảng | Mô tả |
|----|------|
| `DATPHONG` | Thông tin đặt phòng |
| `CT_DATPHONG` | Chi tiết phòng và đơn giá |
| `CT_SUDUNG_DV` | Dịch vụ phát sinh |
| `VOUCHERS` | Mã giảm giá |
| `PAYMENTS` | Lịch sử thanh toán |

---

## Tham số vào

| Tên tham số | Kiểu dữ liệu | Bắt buộc | Mô tả |
|------------|------------|----------|------|
| `@BookingId` | INT | ✔ | ID đặt phòng |
| `@UserId` | INT | ✔ | ID người thanh toán |
| `@SoTien` | DECIMAL(18,2) | ✔ | Số tiền thanh toán |
| `@PhuongThuc` | NVARCHAR(50) | ✔ | Phương thức thanh toán (`TIEN_MAT`, `CHUYEN_KHOAN`, `THE`, `ONLINE`) |

---

## Điều kiện nghiệp vụ

- Booking phải tồn tại và thuộc về user
- Booking **không bị hủy**
- Cho phép thanh toán **nhiều lần**
- Tổng tiền thanh toán **không được vượt quá** tổng tiền cần trả
- Thanh toán đủ → cập nhật booking `COMPLETED`

---

## Luồng xử lý

1. Kiểm tra booking tồn tại và thuộc user
2. Kiểm tra trạng thái booking ≠ `CANCELLED`
3. Tính số **đêm ở**:
4. Tính **tiền phòng**
5. Tính **tiền dịch vụ phát sinh**
6. Tính **giảm giá voucher** (nếu có)
7. Tính **tổng tiền cần thanh toán**
8. Tính **tổng tiền đã thanh toán trước đó**
9. Kiểm tra số tiền thanh toán hợp lệ
10. Insert bản ghi vào `PAYMENTS`
11. Nếu đã thanh toán đủ → cập nhật `DATPHONG.trang_thai = 'COMPLETED'`

---

## 7️⃣ Ví dụ gọi Stored Procedure

```sql
EXEC SP_THANHTOAN
 @BookingId = 5,
 @UserId = 5,
 @SoTien = 6000000,
 @PhuongThuc = 'THE';

