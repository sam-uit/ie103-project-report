CREATE TABLE [dbo].[REFUNDS] (
    [id]           INT             IDENTITY (1, 1) NOT NULL,
    [payment_id]   INT             NOT NULL,
    [so_tien_hoan] DECIMAL (18, 2) NOT NULL,
    [trang_thai]   NVARCHAR (50)   NULL,
    [ly_do]        NVARCHAR (500)  NULL,
    [requested_by] INT             NOT NULL,
    [approved_by]  INT             NULL,
    [created_at]   DATETIME        DEFAULT (getdate()) NULL,
    [updated_at]   DATETIME        DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [CK_REFUNDS_SO_TIEN_HOAN] CHECK ([so_tien_hoan]>(0)),
    CONSTRAINT [CK_REFUNDS_TRANG_THAI] CHECK ([trang_thai]='COMPLETED' OR [trang_thai]='REJECTED' OR [trang_thai]='APPROVED' OR [trang_thai]='REQUESTED'),
    FOREIGN KEY ([approved_by]) REFERENCES [dbo].[ADMINS] ([id]),
    FOREIGN KEY ([payment_id]) REFERENCES [dbo].[PAYMENTS] ([id]),
    FOREIGN KEY ([requested_by]) REFERENCES [dbo].[USERS] ([id])
);
GO

ALTER TABLE [dbo].[REFUNDS]
    ADD CONSTRAINT [CK_REFUNDS_SO_TIEN_HOAN] CHECK ([so_tien_hoan]>(0));
GO

ALTER TABLE [dbo].[REFUNDS]
    ADD CONSTRAINT [CK_REFUNDS_TRANG_THAI] CHECK ([trang_thai]='COMPLETED' OR [trang_thai]='REJECTED' OR [trang_thai]='APPROVED' OR [trang_thai]='REQUESTED');
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

