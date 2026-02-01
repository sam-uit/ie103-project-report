CREATE TABLE [dbo].[CT_DATPHONG] (
    [id]          INT             IDENTITY (1, 1) NOT NULL,
    [datphong_id] INT             NOT NULL,
    [phong_id]    INT             NOT NULL,
    [don_gia]     DECIMAL (18, 2) NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    FOREIGN KEY ([datphong_id]) REFERENCES [dbo].[DATPHONG] ([id]) ON DELETE CASCADE,
    FOREIGN KEY ([phong_id]) REFERENCES [dbo].[PHONG] ([id])
);
GO

ALTER TABLE [dbo].[CT_DATPHONG]
    ADD CONSTRAINT [UQ_CT_DATPHONG] UNIQUE NONCLUSTERED ([datphong_id] ASC, [phong_id] ASC);
GO

ALTER TABLE [dbo].[CT_DATPHONG]
    ADD CONSTRAINT [CK_CT_DATPHONG_DON_GIA] CHECK ([don_gia]>(0));
GO

