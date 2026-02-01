CREATE TABLE [dbo].[ROLE_PERMISSIONS] (
    [role_id]       INT NOT NULL,
    [permission_id] INT NOT NULL,
    PRIMARY KEY CLUSTERED ([role_id] ASC, [permission_id] ASC),
    FOREIGN KEY ([permission_id]) REFERENCES [dbo].[PERMISSIONS] ([id]) ON DELETE CASCADE,
    FOREIGN KEY ([role_id]) REFERENCES [dbo].[ROLES] ([id]) ON DELETE CASCADE
);
GO

