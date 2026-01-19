# 📘 STORED PROCEDURE – ĐÁNH GIÁ PHÒNG

---

## 1Tên Stored Procedure

**SP_DANHGIA**

---

## Mục đích

Stored Procedure `SP_DANHGIA` dùng để **người dùng đánh giá phòng sau khi đã hoàn thành đặt phòng**, nhằm:

- Đảm bảo chỉ đánh giá khi đã ở xong
- Mỗi đặt phòng chỉ được đánh giá **1 lần**
- Lưu đánh giá ở trạng thái chờ duyệt (`CHO_XU_LY`)
- Hỗ trợ quản trị viên kiểm duyệt nội dung

---

## Bảng liên quan

| Bảng | Mô tả |
|----|------|
| `DATPHONG` | Thông tin đặt phòng |
| `PHONG` | Thông tin phòng |
| `REVIEWS` | Đánh giá của người dùng |
| `USERS` | Người đánh giá |

---

## Tham số vào

| Tên tham số | Kiểu dữ liệu | Bắt buộc | Mô tả |
|------------|------------|----------|------|
| `@UserId` | INT | ✔ | ID người đánh giá |
| `@DatPhongId` | INT | ✔ | ID đặt phòng |
| `@SoPhong` | NVARCHAR(20) | ✔ | Số phòng được đánh giá |
| `@SoSao` | INT | ✔ | Số sao (1 → 5) |
| `@BinhLuan` | NVARCHAR(1000) | ✖ | Nội dung đánh giá |

---

## Điều kiện nghiệp vụ

- Booking phải:
  - Thuộc về user
  - Có trạng thái `COMPLETED`
- Mỗi `DATPHONG` **chỉ được đánh giá một lần**
- Số sao phải từ **1 đến 5**
- Đánh giá mặc định ở trạng thái `PENDING`

---

## Luồng xử lý

1. Kiểm tra booking tồn tại, đúng user và đã hoàn thành
2. Lấy `PhongId` từ `SoPhong`
3. Kiểm tra phòng có thuộc booking không
4. Kiểm tra booking đã được đánh giá chưa
5. Insert bản ghi vào `REVIEWS`
6. Đặt trạng thái đánh giá là `PENDING`

---

## Ví dụ gọi Stored Procedure

```sql
EXEC SP_DANHGIA
    @UserId = 1,
    @DatPhongId = 1,
    @SoPhong = '103',
    @SoSao = 5,
    @BinhLuan = N'Phòng sạch sẽ, nhân viên thân thiện, rất hài lòng!';
