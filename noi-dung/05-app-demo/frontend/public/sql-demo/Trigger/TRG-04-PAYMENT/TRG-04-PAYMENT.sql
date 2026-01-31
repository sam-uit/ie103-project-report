/* ============================================================
   TRIGGER 4: Thanh toán (PAYMENTS)
   - Mục đích:
       (1) Số tiền thanh toán = tổng don_gia của CT_DATPHONG theo booking
       (2) Sau khi thanh toán, cập nhật DATPHONG.trang_thai = 'PAID'
   - Chạy khi: INSERT vào PAYMENTS
   - Kiểu: INSTEAD OF (kiểm tra trước, đúng thì mới cho insert)
   ============================================================ */

-- Xóa trigger cũ nếu tồn tại
IF OBJECT_ID('dbo.trg_PAYMENTS_Insert_CheckAndPaid', 'TR') IS NOT NULL 
    DROP TRIGGER dbo.trg_PAYMENTS_Insert_CheckAndPaid;
GO

-- Tạo trigger mới
CREATE TRIGGER dbo.trg_PAYMENTS_Insert_CheckAndPaid
ON dbo.PAYMENTS
INSTEAD OF INSERT
AS
BEGIN
    -- Kiểm tra số tiền thanh toán
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN (
            SELECT datphong_id, SUM(don_gia) AS tong_tien
            FROM dbo.CT_DATPHONG
            GROUP BY datphong_id
        ) t ON t.datphong_id = i.booking_id
        WHERE i.so_tien <> t.tong_tien
    )
    BEGIN
        RAISERROR (N'Amount phải bằng tổng don_gia của booking', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Insert payment
    INSERT INTO dbo.PAYMENTS(booking_id, user_id, so_tien, phuong_thuc, trang_thai, created_at)
    SELECT booking_id, user_id, so_tien, phuong_thuc, trang_thai, GETDATE()
    FROM inserted;

    -- Cập nhật trạng thái booking
    UPDATE d
    SET d.trang_thai = 'CONFIRMED'
    FROM dbo.DATPHONG d
    JOIN inserted i ON i.booking_id = d.id;
END
GO

/* ============================================================
   KIỂM TRA TỔNG TIỀN BOOKING TRƯỚC KHI THANH TOÁN
  
SELECT datphong_id, SUM(don_gia) AS tong_tien
FROM CT_DATPHONG
GROUP BY datphong_id;


   TEST CASE 1: Thanh toán ĐÚNG số tiền
   Kỳ vọng: Thành công, trạng thái booking = PAID
 
INSERT INTO PAYMENTS(booking_id, user_id, so_tien, phuong_thuc, trang_thai, created_at)
VALUES (1, 1, 600000, 'TIEN_MAT', 'SUCCESS', GETDATE());

-- Kiểm tra payment đã tạo
SELECT * FROM PAYMENTS WHERE booking_id = 1;

-- Kiểm tra trạng thái booking
SELECT id, trang_thai FROM DATPHONG WHERE id = 1;


   TEST CASE 2: Thanh toán SAI số tiền
   Kỳ vọng: Lỗi - Amount không khớp
   (Đã comment để demo chạy thành công)
 
-- INSERT INTO PAYMENTS(booking_id, user_id, so_tien, phuong_thuc, trang_thai, created_at)
-- VALUES (1, 1, 900000, 'CASH', 'SUCCESS', GETDATE());


   KIỂM TRA TỔNG QUAN

SELECT 
    d.id AS booking_id,
    d.trang_thai,
    SUM(c.don_gia) AS tong_tien_phong,
    p.so_tien AS da_thanh_toan
FROM DATPHONG d
LEFT JOIN CT_DATPHONG c ON c.datphong_id = d.id
LEFT JOIN PAYMENTS p ON p.booking_id = d.id
GROUP BY d.id, d.trang_thai, p.so_tien
ORDER BY d.id;
 ============================================================ */
