CREATE TABLE [dbo].[PAYMENTS] (
    [id]          INT             IDENTITY (1, 1) NOT NULL,
    [booking_id]  INT             NOT NULL,
    [user_id]     INT             NOT NULL,
    [so_tien]     DECIMAL (18, 2) NOT NULL,
    [phuong_thuc] NVARCHAR (50)   NULL,
    [trang_thai]  NVARCHAR (50)   NULL,
    [created_at]  DATETIME        DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    FOREIGN KEY ([booking_id]) REFERENCES [dbo].[DATPHONG] ([id]),
    FOREIGN KEY ([user_id]) REFERENCES [dbo].[USERS] ([id])
);
GO

ALTER TABLE [dbo].[PAYMENTS]
    ADD CONSTRAINT [CK_PAYMENTS_PHUONG_THUC] CHECK ([phuong_thuc]='ONLINE' OR [phuong_thuc]='THE' OR [phuong_thuc]='CHUYEN_KHOAN' OR [phuong_thuc]='TIEN_MAT' OR [phuong_thuc] IS NULL);
GO

ALTER TABLE [dbo].[PAYMENTS]
    ADD CONSTRAINT [CK_PAYMENTS_SO_TIEN] CHECK ([so_tien]>(0));
GO

ALTER TABLE [dbo].[PAYMENTS]
    ADD CONSTRAINT [CK_PAYMENTS_TRANG_THAI] CHECK ([trang_thai]='REFUNDED' OR [trang_thai]='UNPAID' OR [trang_thai]='PAID' OR [trang_thai]='CANCELLED' OR [trang_thai]='FAILED' OR [trang_thai]='SUCCESS' OR [trang_thai]='PENDING');
GO

