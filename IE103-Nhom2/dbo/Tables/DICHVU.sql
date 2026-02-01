CREATE TABLE [dbo].[DICHVU] (
    [id]          INT             IDENTITY (1, 1) NOT NULL,
    [ten_dich_vu] NVARCHAR (255)  NOT NULL,
    [don_gia]     DECIMAL (18, 2) NOT NULL,
    [don_vi_tinh] NVARCHAR (50)   DEFAULT (N'Lần') NULL,
    [trang_thai]  NVARCHAR (50)   DEFAULT ('ACTIVE') NULL,
    [created_at]  DATETIME        DEFAULT (getdate()) NULL,
    [updated_at]  DATETIME        DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);
GO

ALTER TABLE [dbo].[DICHVU]
    ADD CONSTRAINT [CK_DICHVU_DON_GIA] CHECK ([don_gia]>(0));
GO

ALTER TABLE [dbo].[DICHVU]
    ADD CONSTRAINT [CK_DICHVU_TRANG_THAI] CHECK ([trang_thai]='INACTIVE' OR [trang_thai]='ACTIVE');
GO

