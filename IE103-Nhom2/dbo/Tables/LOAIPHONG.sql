CREATE TABLE [dbo].[LOAIPHONG] (
    [id]         INT             IDENTITY (1, 1) NOT NULL,
    [ten_loai]   NVARCHAR (100)  NOT NULL,
    [gia_co_ban] DECIMAL (18, 2) NOT NULL,
    [mo_ta]      NVARCHAR (500)  NULL,
    [suc_chua]   INT             DEFAULT ((2)) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);
GO

ALTER TABLE [dbo].[LOAIPHONG]
    ADD CONSTRAINT [CK_LOAIPHONG_GIA_CO_BAN] CHECK ([gia_co_ban]>(0));
GO

ALTER TABLE [dbo].[LOAIPHONG]
    ADD CONSTRAINT [CK_LOAIPHONG_SUC_CHUA] CHECK ([suc_chua]>(0));
GO

