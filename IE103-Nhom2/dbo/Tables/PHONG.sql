CREATE TABLE [dbo].[PHONG] (
    [id]            INT           IDENTITY (1, 1) NOT NULL,
    [so_phong]      NVARCHAR (20) NOT NULL,
    [loai_phong_id] INT           NOT NULL,
    [trang_thai]    NVARCHAR (50) DEFAULT ('AVAILABLE') NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    FOREIGN KEY ([loai_phong_id]) REFERENCES [dbo].[LOAIPHONG] ([id]),
    UNIQUE NONCLUSTERED ([so_phong] ASC)
);
GO

ALTER TABLE [dbo].[PHONG]
    ADD CONSTRAINT [CK_PHONG_TRANG_THAI] CHECK ([trang_thai]='RESERVED' OR [trang_thai]='MAINTENANCE' OR [trang_thai]='OCCUPIED' OR [trang_thai]='AVAILABLE');
GO

