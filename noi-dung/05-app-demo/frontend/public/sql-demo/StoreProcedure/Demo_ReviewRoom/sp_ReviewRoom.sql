CREATE OR ALTER PROCEDURE [dbo].[SP_DANHGIA]
    @UserId INT,
    @DatPhongId INT,
    @SoPhong NVARCHAR(20),
    @SoSao INT,
    @BinhLuan NVARCHAR(1000)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PhongId INT;

    -- 1. Lấy phong_id từ so_phong
    SELECT @PhongId = id
    FROM PHONG
    WHERE so_phong = @SoPhong;

    IF @PhongId IS NULL
    BEGIN
        RAISERROR(N'Số phòng không tồn tại', 16, 1);
        RETURN;
    END

    -- 2. Booking hợp lệ & COMPLETED
    PRINT @DatPhongId;
    PRINT @UserId;
    IF NOT EXISTS (
        SELECT 1 FROM DATPHONG
        WHERE id = @DatPhongId
          AND user_id = @UserId
          AND trang_thai = N'HOAN_THANH'
    )
    BEGIN
        RAISERROR(N'Chỉ được đánh giá khi đặt phòng đã hoàn thành', 16, 1);
        RETURN;
    END

    -- 3. Phòng thuộc booking
    IF NOT EXISTS (
        SELECT 1
        FROM CT_DATPHONG
        WHERE datphong_id = @DatPhongId
          AND phong_id = @PhongId
    )
    BEGIN
        RAISERROR(N'Phòng không thuộc đặt phòng này', 16, 1);
        RETURN;
    END

    -- 4. Đã đánh giá chưa
    IF EXISTS (
        SELECT 1 FROM REVIEWS WHERE datphong_id = @DatPhongId
    )
    BEGIN
        RAISERROR(N'Đặt phòng này đã được đánh giá', 16, 1);
        RETURN;
    END

    -- 5. Validate số sao
    IF @SoSao < 1 OR @SoSao > 5
    BEGIN
        RAISERROR(N'Số sao phải từ 1 đến 5', 16, 1);
        RETURN;
    END

    BEGIN TRAN;

    INSERT INTO REVIEWS (
        user_id, phong_id, datphong_id,
        so_sao, binh_luan, trang_thai
    )
    VALUES (
        @UserId, @PhongId, @DatPhongId,
        @SoSao, @BinhLuan, N'CHO_XU_LY'
    );

    COMMIT TRAN;
END
