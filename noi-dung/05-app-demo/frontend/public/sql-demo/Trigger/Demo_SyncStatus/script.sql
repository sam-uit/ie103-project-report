/* ============================================================
   TRIGGER 3: Đồng bộ trạng thái phòng theo CT_DATPHONG
   - Mục đích: Đảm bảo PHONG.trang_thai phản ánh đúng tình trạng đặt
   - Chạy khi: INSERT/DELETE/UPDATE trên CT_DATPHONG
   - Sử dụng:
       inserted: phòng vừa thêm/đổi → BOOKED
       deleted : phòng vừa bị xóa/đổi → nếu không còn trong CT_DATPHONG thì AVAILABLE
   ============================================================ */

-- Xóa trigger cũ nếu tồn tại
IF OBJECT_ID('dbo.trg_CTDP_SyncRoomStatus', 'TR') IS NOT NULL 
    DROP TRIGGER dbo.trg_CTDP_SyncRoomStatus;
GO

-- Tạo trigger mới
CREATE TRIGGER dbo.trg_CTDP_SyncRoomStatus
ON dbo.CT_DATPHONG
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    /* Có thêm/đổi chi tiết đặt phòng → phòng đang bị giữ → BOOKED */
    UPDATE p
    SET p.trang_thai = 'OCCUPIED'
    FROM dbo.PHONG p
    JOIN inserted i ON i.phong_id = p.id;

    /* Có xóa/đổi phòng cũ:
       Chỉ trả về AVAILABLE nếu phòng đó không còn xuất hiện trong CT_DATPHONG */
    UPDATE p
    SET p.trang_thai = 'AVAILABLE'
    FROM dbo.PHONG p
    JOIN deleted d ON d.phong_id = p.id
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.CT_DATPHONG c
        WHERE c.phong_id = p.id
    );
END
GO

/* ============================================================
   KIỂM TRA TỔNG QUAN
SELECT 
    p.id,
    p.so_phong as ten_phong,
    p.trang_thai,
    COUNT(c.id) as so_lan_dat
FROM PHONG p
LEFT JOIN CT_DATPHONG c ON c.phong_id = p.id
GROUP BY p.id, p.so_phong, p.trang_thai
ORDER BY p.id;


   TEST CASE 1: Thêm đặt phòng (Phòng 2)
   Kỳ vọng: Phòng 2 chuyển sang OCCUPIED (theo script)
 
INSERT INTO CT_DATPHONG(datphong_id, phong_id, don_gia)
VALUES (2, 2, 500000);

-- Kiểm tra sau khi INSERT
SELECT id, so_phong AS ten_phong, trang_thai FROM PHONG WHERE id = 2;

   ============================================================ */
