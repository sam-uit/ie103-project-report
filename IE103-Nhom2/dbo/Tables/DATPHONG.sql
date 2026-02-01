CREATE TABLE [dbo].[DATPHONG] (
    [id]         INT           IDENTITY (1, 1) NOT NULL,
    [user_id]    INT           NOT NULL,
    [voucher_id] INT           NULL,
    [check_in]   DATETIME      NOT NULL,
    [check_out]  DATETIME      NOT NULL,
    [trang_thai] NVARCHAR (50) DEFAULT ('PENDING') NULL,
    [created_at] DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
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

