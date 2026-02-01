CREATE TABLE [dbo].[ROLES] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [code]        NVARCHAR (50)  NOT NULL,
    [name]        NVARCHAR (255) NOT NULL,
    [description] NVARCHAR (500) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    UNIQUE NONCLUSTERED ([code] ASC)
);
GO

