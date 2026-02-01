CREATE OR ALTER PROCEDURE [dbo].[SP_DATPHONG]
(
    @UserId INT,
    @SoPhong NVARCHAR(20),
    @CheckIn DATETIME,
    @CheckOut DATETIME,
    @VoucherId INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @PhongId INT,
        @DonGia DECIMAL(18,2),
        @DatPhongId INT;

    /* ===============================
       1. Validate ngày
    =============================== */
    IF @CheckIn >= @CheckOut OR @CheckIn < GETDATE()
    BEGIN
        RAISERROR(N'Thời gian nhận / trả phòng không hợp lệ', 16, 1);
        RETURN;
    END

    /* ===============================
       2. Lấy phòng + giá
    =============================== */
    SELECT 
        @PhongId = p.id,
        @DonGia = lp.gia_co_ban
    FROM PHONG p
    JOIN LOAIPHONG lp ON p.loai_phong_id = lp.id
    WHERE p.so_phong = @SoPhong
      AND p.trang_thai IN ('AVAILABLE', 'RESERVED');

    IF @PhongId IS NULL
    BEGIN
        RAISERROR(N'Số phòng không tồn tại hoặc không khả dụng', 16, 1);
        RETURN;
    END

    /* ===============================
       3. Check trùng ngày
    =============================== */
    IF EXISTS (
        SELECT 1
        FROM DATPHONG d
        JOIN CT_DATPHONG c ON d.id = c.datphong_id
        WHERE c.phong_id = @PhongId
          AND d.trang_thai IN ('PENDING', 'CONFIRMED')
          AND @CheckIn < d.check_out
          AND @CheckOut > d.check_in
    )
    BEGIN
        RAISERROR(N'Phòng đã được đặt trong khoảng thời gian này', 16, 1);
        RETURN;
    END

    /* ===============================
       4. Check voucher
    =============================== */
    IF @VoucherId IS NOT NULL
    BEGIN
        IF NOT EXISTS (
            SELECT 1 FROM VOUCHERS
            WHERE id = @VoucherId
              AND trang_thai = 'ACTIVE'
              AND ngay_het_han >= CAST(GETDATE() AS DATE)
              AND so_lan_da_dung < so_lan_toi_da
        )
        BEGIN
            RAISERROR(N'Voucher không hợp lệ', 16, 1);
            RETURN;
        END
    END

    /* ===============================
       5. Giao dịch
    =============================== */
    BEGIN TRY
        BEGIN TRAN;

        INSERT INTO DATPHONG
        (
            user_id,
            voucher_id,
            check_in,
            check_out,
            trang_thai
        )
        VALUES
        (
            @UserId,
            @VoucherId,
            @CheckIn,
            @CheckOut,
            'PENDING'
        );

        SET @DatPhongId = SCOPE_IDENTITY();

        INSERT INTO CT_DATPHONG
        (
            datphong_id,
            phong_id,
            don_gia
        )
        VALUES
        (
            @DatPhongId,
            @PhongId,
            @DonGia
        );

        UPDATE PHONG
        SET trang_thai = 'RESERVED'
        WHERE id = @PhongId;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        THROW;
    END CATCH

    /* ===============================
       6. Output
    =============================== */
    SELECT 
        @DatPhongId AS DatPhongId,
        @PhongId AS PhongId,
        @SoPhong AS SoPhong,
        @DonGia AS DonGia;
END
