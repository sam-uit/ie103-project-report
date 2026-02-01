CREATE TABLE [dbo].[CT_SUDUNG_DV] (
    [id]                INT             IDENTITY (1, 1) NOT NULL,
    [datphong_id]       INT             NOT NULL,
    [dichvu_id]         INT             NOT NULL,
    [so_luong]          INT             DEFAULT ((1)) NOT NULL,
    [don_gia]           DECIMAL (18, 2) NOT NULL,
    [thoi_diem_su_dung] DATETIME        DEFAULT (getdate()) NULL,
    [ghi_chu]           NVARCHAR (500)  NULL,
    [created_at]        DATETIME        DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    FOREIGN KEY ([datphong_id]) REFERENCES [dbo].[DATPHONG] ([id]) ON DELETE CASCADE,
    FOREIGN KEY ([dichvu_id]) REFERENCES [dbo].[DICHVU] ([id])
);
GO

ALTER TABLE [dbo].[CT_SUDUNG_DV]
    ADD CONSTRAINT [CK_CT_SUDUNG_DV_SO_LUONG] CHECK ([so_luong]>(0));
GO

ALTER TABLE [dbo].[CT_SUDUNG_DV]
    ADD CONSTRAINT [CK_CT_SUDUNG_DV_DON_GIA] CHECK ([don_gia]>(0));
GO

