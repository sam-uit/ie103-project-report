CREATE TABLE [dbo].[VOUCHERS] (
    [id]                INT             IDENTITY (1, 1) NOT NULL,
    [ma_code]           NVARCHAR (50)   NOT NULL,
    [phan_tram_giam]    DECIMAL (5, 2)  NOT NULL,
    [ngay_het_han]      DATE            NOT NULL,
    [so_tien_toi_thieu] DECIMAL (18, 2) DEFAULT ((0)) NULL,
    [so_lan_toi_da]     INT             DEFAULT ((100)) NULL,
    [so_lan_da_dung]    INT             DEFAULT ((0)) NULL,
    [trang_thai]        NVARCHAR (50)   DEFAULT ('ACTIVE') NULL,
    [created_at]        DATETIME        DEFAULT (getdate()) NULL,
    [updated_at]        DATETIME        DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    UNIQUE NONCLUSTERED ([ma_code] ASC)
);
GO

ALTER TABLE [dbo].[VOUCHERS]
    ADD CONSTRAINT [CK_VOUCHERS_SO_TIEN_TOI_THIEU] CHECK ([so_tien_toi_thieu]>=(0));
GO

ALTER TABLE [dbo].[VOUCHERS]
    ADD CONSTRAINT [CK_VOUCHERS_TRANG_THAI] CHECK ([trang_thai]='INACTIVE' OR [trang_thai]='ACTIVE');
GO

ALTER TABLE [dbo].[VOUCHERS]
    ADD CONSTRAINT [CK_VOUCHERS_SO_LAN_TOI_DA] CHECK ([so_lan_toi_da]>(0));
GO

ALTER TABLE [dbo].[VOUCHERS]
    ADD CONSTRAINT [CK_VOUCHERS_SO_LAN_DA_DUNG] CHECK ([so_lan_da_dung]>=(0));
GO

ALTER TABLE [dbo].[VOUCHERS]
    ADD CONSTRAINT [CK_VOUCHERS_PHAN_TRAM_GIAM] CHECK ([phan_tram_giam]>=(0) AND [phan_tram_giam]<=(100));
GO

ALTER TABLE [dbo].[VOUCHERS]
    ADD CONSTRAINT [CK_VOUCHERS_SO_LAN_DUNG] CHECK ([so_lan_da_dung]<=[so_lan_toi_da]);
GO

