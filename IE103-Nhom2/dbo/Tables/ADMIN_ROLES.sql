CREATE TABLE [dbo].[ADMIN_ROLES] (
    [admin_id] INT NOT NULL,
    [role_id]  INT NOT NULL,
    PRIMARY KEY CLUSTERED ([admin_id] ASC, [role_id] ASC),
    FOREIGN KEY ([admin_id]) REFERENCES [dbo].[ADMINS] ([id]) ON DELETE CASCADE,
    FOREIGN KEY ([role_id]) REFERENCES [dbo].[ROLES] ([id]) ON DELETE CASCADE
);
GO

