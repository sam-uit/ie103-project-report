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

