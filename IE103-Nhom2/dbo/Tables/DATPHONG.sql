CREATE TABLE [dbo].[DATPHONG] (
    [id]         INT           IDENTITY (1, 1) NOT NULL,
    [user_id]    INT           NOT NULL,
    [voucher_id] INT           NULL,
    [check_in]   DATETIME      NOT NULL,
    [check_out]  DATETIME      NOT NULL,
    [trang_thai] NVARCHAR (50) DEFAULT ('PENDING') NULL,
    [created_at] DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [CK_DATPHONG_CHECK_IN_TIME] CHECK (CONVERT([time],[check_in])>='14:00:00'),
    CONSTRAINT [CK_DATPHONG_CHECK_OUT_AFTER_CHECK_IN] CHECK ([check_out]>[check_in]),
    CONSTRAINT [CK_DATPHONG_CHECK_OUT_TIME] CHECK (CONVERT([time],[check_out])<='12:00:00'),
    CONSTRAINT [CK_DATPHONG_TRANG_THAI] CHECK ([trang_thai]='COMPLETED' OR [trang_thai]='CANCELLED' OR [trang_thai]='CONFIRMED' OR [trang_thai]='PENDING'),
    FOREIGN KEY ([user_id]) REFERENCES [dbo].[USERS] ([id]),
    FOREIGN KEY ([voucher_id]) REFERENCES [dbo].[VOUCHERS] ([id])
);
GO

ALTER TABLE [dbo].[DATPHONG]
    ADD CONSTRAINT [CK_DATPHONG_TRANG_THAI] CHECK ([trang_thai]='COMPLETED' OR [trang_thai]='CANCELLED' OR [trang_thai]='CONFIRMED' OR [trang_thai]='PENDING');
GO

ALTER TABLE [dbo].[DATPHONG]
    ADD CONSTRAINT [CK_DATPHONG_CHECK_OUT_AFTER_CHECK_IN] CHECK ([check_out]>[check_in]);
GO

ALTER TABLE [dbo].[DATPHONG]
    ADD CONSTRAINT [CK_DATPHONG_CHECK_IN_TIME] CHECK (CONVERT([time],[check_in])>='14:00:00');
GO

ALTER TABLE [dbo].[DATPHONG]
    ADD CONSTRAINT [CK_DATPHONG_CHECK_OUT_TIME] CHECK (CONVERT([time],[check_out])<='12:00:00');
GO



-- Tạo trigger mới
CREATE TRIGGER dbo.trg_DATPHONG_CheckTime
ON dbo.DATPHONG
AFTER INSERT, UPDATE
AS
BEGIN
    -- inserted: chứa các dòng vừa mới thêm / sửa
    -- Kiểm tra: check_out phải >= check_in
    IF EXISTS (SELECT 1 FROM inserted WHERE check_out < check_in)
    BEGIN
        RAISERROR (N'check_out không được nhỏ hơn check_in', 16, 1);
        ROLLBACK TRANSACTION;  -- Hủy thao tác
        RETURN;                -- Dừng trigger
    END
END
GO

