CREATE TABLE [dbo].[CT_DATPHONG] (
    [id]          INT             IDENTITY (1, 1) NOT NULL,
    [datphong_id] INT             NOT NULL,
    [phong_id]    INT             NOT NULL,
    [don_gia]     DECIMAL (18, 2) NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [CK_CT_DATPHONG_DON_GIA] CHECK ([don_gia]>(0)),
    FOREIGN KEY ([datphong_id]) REFERENCES [dbo].[DATPHONG] ([id]) ON DELETE CASCADE,
    FOREIGN KEY ([phong_id]) REFERENCES [dbo].[PHONG] ([id]),
    CONSTRAINT [UQ_CT_DATPHONG] UNIQUE NONCLUSTERED ([datphong_id] ASC, [phong_id] ASC)
);
GO

ALTER TABLE [dbo].[CT_DATPHONG]
    ADD CONSTRAINT [UQ_CT_DATPHONG] UNIQUE NONCLUSTERED ([datphong_id] ASC, [phong_id] ASC);
GO

ALTER TABLE [dbo].[CT_DATPHONG]
    ADD CONSTRAINT [CK_CT_DATPHONG_DON_GIA] CHECK ([don_gia]>(0));
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

