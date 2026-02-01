CREATE TABLE [dbo].[USERS] (
    [id]            INT            IDENTITY (1, 1) NOT NULL,
    [email]         NVARCHAR (255) NOT NULL,
    [phone]         NVARCHAR (20)  NULL,
    [password_hash] NVARCHAR (255) NOT NULL,
    [full_name]     NVARCHAR (255) NULL,
    [status]        NVARCHAR (50)  DEFAULT ('ACTIVE') NULL,
    [created_at]    DATETIME       DEFAULT (getdate()) NULL,
    [updated_at]    DATETIME       DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    UNIQUE NONCLUSTERED ([email] ASC)
);
GO

ALTER TABLE [dbo].[USERS]
    ADD CONSTRAINT [CK_USERS_STATUS] CHECK ([status]='INACTIVE' OR [status]='ACTIVE');
GO

