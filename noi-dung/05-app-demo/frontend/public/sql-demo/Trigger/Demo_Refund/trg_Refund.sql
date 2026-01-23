/* ============================================================
   TRIGGER 5: Hoàn tiền (REFUNDS)
   - Mục đích:
       (1) bo_tien_hoan không được vượt quá PAYMENTS.so_tien
       (2) Đồng bộ trạng thái: PAYMENTS.trang_thai = 'REFUNDED', DATPHONG.trang_thai = 'REFUNDED'
   - Chạy khi: INSERT vào REFUNDS
   - Kiểu: INSTEAD OF (kiểm tra trước, đúng thì mới cho insert)
   ============================================================ */

-- Xóa trigger cũ nếu tồn tại
IF OBJECT_ID('dbo.trg_REFUNDS_Insert_CheckAndUpdate', 'TR') IS NOT NULL 
    DROP TRIGGER dbo.trg_REFUNDS_Insert_CheckAndUpdate;
GO

-- Tạo trigger mới
CREATE TRIGGER dbo.trg_REFUNDS_Insert_CheckAndUpdate
ON dbo.REFUNDS
INSTEAD OF INSERT
AS
BEGIN
    /* Kiểm tra số tiền hoàn không vượt quá số tiền thanh toán */
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dbo.PAYMENTS p ON p.id = i.payment_id
        WHERE i.so_tien_hoan > p.so_tien
    )
    BEGIN
        RAISERROR (N'Refund vượt quá thanh toán', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    /* Insert refund */
    INSERT INTO dbo.REFUNDS(payment_id, so_tien_hoan, trang_thai, ly_do, requested_by, approved_by, created_at)
    SELECT payment_id, so_tien_hoan, trang_thai, ly_do, requested_by, approved_by, ISNULL(created_at, GETDATE())
    FROM inserted;

    /* Cập nhật trạng thái payment */
    UPDATE p
    SET p.trang_thai = 'REFUNDED'
    FROM dbo.PAYMENTS p
    JOIN inserted i ON i.payment_id = p.id;

    /* Cập nhật trạng thái booking theo booking_id trong PAYMENTS */
    UPDATE d
    SET d.trang_thai = 'CANCELLED'
    FROM dbo.DATPHONG d
    JOIN dbo.PAYMENTS p ON p.booking_id = d.id
    JOIN inserted i ON i.payment_id = p.id;
END
GO

/* ============================================================
   KIỂM TRA THANH TOÁN TRƯỚC KHI HOÀN TIỀN
   
SELECT id, booking_id, so_tien, trang_thai FROM PAYMENTS;


   TEST CASE 1: Hoàn tiền HỢP LỆ (bằng số tiền đã trả)
   Kỳ vọng: Thành công, cập nhật trạng thái

INSERT INTO REFUNDS(payment_id, so_tien_hoan, trang_thai, ly_do, requested_by, approved_by, created_at)
VALUES (1, 1000000, 'APPROVED', 'Khách hủy phòng', 1, 1, GETDATE());

-- Kiểm tra refund đã tạo
SELECT * FROM REFUNDS WHERE payment_id = 1;

-- Kiểm tra trạng thái payment
SELECT id, trang_thai FROM PAYMENTS WHERE id = 1;

-- Kiểm tra trạng thái booking
SELECT id, trang_thai FROM DATPHONG WHERE id = 1;


   TEST CASE 2: Hoàn tiền VƯỢT QUÁ
   Kỳ vọng: Lỗi - Refund vượt quá thanh toán
   (Đã comment để demo chạy thành công)
 
-- INSERT INTO REFUNDS(payment_id, so_tien_hoan, trang_thai, reason, approved_by, created_at)
-- VALUES (1, 1500000, 'APPROVED', 'Test vượt quá', 1, GETDATE());


   KIỂM TRA TỔNG QUAN
 
SELECT 
    d.id AS booking_id,
    d.trang_thai AS booking_status,
    p.so_tien AS payment_amount,
    p.trang_thai AS payment_status,
    r.so_tien_hoan AS refund_amount,
    r.trang_thai AS refund_status
FROM DATPHONG d
LEFT JOIN PAYMENTS p ON p.booking_id = d.id
LEFT JOIN REFUNDS r ON r.payment_id = p.id
ORDER BY d.id;
============================================================ */
