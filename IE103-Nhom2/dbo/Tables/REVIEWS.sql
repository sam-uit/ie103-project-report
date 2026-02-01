CREATE TABLE [dbo].[REVIEWS] (
    [id]            INT             IDENTITY (1, 1) NOT NULL,
    [user_id]       INT             NOT NULL,
    [phong_id]      INT             NOT NULL,
    [datphong_id]   INT             NOT NULL,
    [so_sao]        INT             NOT NULL,
    [binh_luan]     NVARCHAR (1000) NULL,
    [ngay_danh_gia] DATE            DEFAULT (CONVERT([date],getdate())) NULL,
    [trang_thai]    NVARCHAR (50)   DEFAULT ('PENDING') NULL,
    [created_at]    DATETIME        DEFAULT (getdate()) NULL,
    [updated_at]    DATETIME        DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    FOREIGN KEY ([datphong_id]) REFERENCES [dbo].[DATPHONG] ([id]),
    FOREIGN KEY ([phong_id]) REFERENCES [dbo].[PHONG] ([id]),
    FOREIGN KEY ([user_id]) REFERENCES [dbo].[USERS] ([id]),
    UNIQUE NONCLUSTERED ([datphong_id] ASC)
);
GO

ALTER TABLE [dbo].[REVIEWS]
    ADD CONSTRAINT [CK_REVIEWS_TRANG_THAI] CHECK ([trang_thai]='REJECTED' OR [trang_thai]='APPROVED' OR [trang_thai]='PENDING');
GO

ALTER TABLE [dbo].[REVIEWS]
    ADD CONSTRAINT [CK_REVIEWS_SO_SAO] CHECK ([so_sao]>=(1) AND [so_sao]<=(5));
GO

