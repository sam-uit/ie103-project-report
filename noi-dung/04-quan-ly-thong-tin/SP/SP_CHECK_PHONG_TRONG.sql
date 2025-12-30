CREATE PROCEDURE SP_CHECK_PHONG_TRONG
(
    @CheckIn DATETIME,
    @CheckOut DATETIME
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @CheckIn >= @CheckOut
    BEGIN
        RAISERROR(N'Check-in phải nhỏ hơn Check-out', 16, 1);
        RETURN;
    END

    SELECT
        p.id AS phong_id,
        p.so_phong,
        p.loai_phong_id,
        lp.ten_loai,
        lp.gia_co_ban
    FROM PHONG p
    JOIN LOAIPHONG lp ON lp.id = p.loai_phong_id
    WHERE NOT EXISTS (
        SELECT 1
        FROM CT_DATPHONG ct
        JOIN DATPHONG dp ON dp.id = ct.datphong_id
        WHERE ct.phong_id = p.id
          AND dp.trang_thai IN ('PENDING', 'CONFIRMED')
          AND @CheckIn < dp.check_out
          AND @CheckOut > dp.check_in
    )
END;
GO
