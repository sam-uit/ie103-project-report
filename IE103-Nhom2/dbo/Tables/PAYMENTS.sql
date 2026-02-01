CREATE TABLE [dbo].[PAYMENTS] (
    [id]          INT             IDENTITY (1, 1) NOT NULL,
    [booking_id]  INT             NOT NULL,
    [user_id]     INT             NOT NULL,
    [so_tien]     DECIMAL (18, 2) NOT NULL,
    [phuong_thuc] NVARCHAR (50)   NULL,
    [trang_thai]  NVARCHAR (50)   NULL,
    [created_at]  DATETIME        DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [CK_PAYMENTS_PHUONG_THUC] CHECK ([phuong_thuc]='ONLINE' OR [phuong_thuc]='THE' OR [phuong_thuc]='CHUYEN_KHOAN' OR [phuong_thuc]='TIEN_MAT' OR [phuong_thuc] IS NULL),
    CONSTRAINT [CK_PAYMENTS_SO_TIEN] CHECK ([so_tien]>(0)),
    CONSTRAINT [CK_PAYMENTS_TRANG_THAI] CHECK ([trang_thai]='REFUNDED' OR [trang_thai]='UNPAID' OR [trang_thai]='PAID' OR [trang_thai]='CANCELLED' OR [trang_thai]='FAILED' OR [trang_thai]='SUCCESS' OR [trang_thai]='PENDING'),
    FOREIGN KEY ([booking_id]) REFERENCES [dbo].[DATPHONG] ([id]),
    FOREIGN KEY ([user_id]) REFERENCES [dbo].[USERS] ([id])
);
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

