/* ============================================================
   TRIGGER 2: Chèn chi tiết đặt phòng + tự động đơn giá
   - Mục đích:
       (1) Chặn đặt phòng nếu phòng không AVAILABLE
       (2) Tự động lấy don_gia theo LOAIPHONG.gia_co_ban
   - Chạy khi: INSERT vào CT_DATPHONG
   - Kiểu: INSTEAD OF (chặn trước, nếu hợp lệ thì INSERT lại)
   ============================================================ */

-- Xóa trigger cũ nếu tồn tại
IF OBJECT_ID('dbo.trg_CTDP_Insert_ValidatePrice', 'TR') IS NOT NULL 
    DROP TRIGGER dbo.trg_CTDP_Insert_ValidatePrice;
GO

-- Tạo trigger mới
CREATE TRIGGER dbo.trg_CTDP_Insert_ValidatePrice
ON dbo.CT_DATPHONG
INSTEAD OF INSERT
AS
BEGIN
    /*  Kiểm tra trạng thái phòng:
       Nếu phòng muốn đặt mà trang_thai <> 'AVAILABLE' thì không cho đặt */
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dbo.PHONG p ON p.id = i.phong_id
        WHERE p.trang_thai <> 'AVAILABLE'
    )
    BEGIN
        RAISERROR (N'Phòng không AVAILABLE nên không đặt được', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    /* Nếu hợp lệ: thêm vào CT_DATPHONG
       - don_gia lấy từ LOAIPHONG.gia_co_ban thông qua PHONG.loai_phong_id */
    INSERT INTO dbo.CT_DATPHONG(datphong_id, phong_id, don_gia)
    SELECT  i.datphong_id,
            i.phong_id,
            lp.gia_co_ban
    FROM inserted i
    JOIN dbo.PHONG p      ON p.id = i.phong_id
    JOIN dbo.LOAIPHONG lp ON lp.id = p.loai_phong_id;
END
GO

/* ============================================================
   KIỂM TRA TRẠNG THÁI PHÒNG TRƯỚC KHI TEST
   ============================================================ */
SELECT id, so_phong AS ten_phong, trang_thai FROM PHONG WHERE id IN (1, 2, 3);

/* ============================================================
   TEST CASE 1: Đặt phòng AVAILABLE (Phòng 2)
   Kỳ vọng: Thành công, don_gia tự động = 500000
   ============================================================ */
INSERT INTO CT_DATPHONG(datphong_id, phong_id)
VALUES (2, 2);

/* ============================================================
   TEST CASE 2: Đặt phòng BOOKED (Phòng 1)
   Kỳ vọng: Lỗi - Phòng không AVAILABLE
   (Đã comment để demo chạy thành công)
   ============================================================ */
-- INSERT INTO CT_DATPHONG(datphong_id, phong_id)
-- VALUES (2, 1);

/* ============================================================
   KIỂM TRA KẾT QUẢ
   ============================================================ */
SELECT * FROM CT_DATPHONG ORDER BY id DESC;
