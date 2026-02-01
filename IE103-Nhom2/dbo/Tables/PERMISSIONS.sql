CREATE TABLE [dbo].[PERMISSIONS] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [code]        NVARCHAR (100) NOT NULL,
    [description] NVARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    UNIQUE NONCLUSTERED ([code] ASC)
);
GO

