CREATE OR ALTER PROCEDURE SP_THANHTOAN
(
    @BookingId INT,
    @UserId INT,
    @SoTien DECIMAL(18,2),
    @PhuongThuc NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @TongTienPhong DECIMAL(18,2),
        @TongTienDV DECIMAL(18,2),
        @TongTien DECIMAL(18,2),
        @GiamGia DECIMAL(18,2),
        @DaThanhToan DECIMAL(18,2),
        @VoucherId INT,
        @PhanTramGiam DECIMAL(5,2),
        @SoTienToiThieu DECIMAL(18,2),
        @TrangThaiBooking NVARCHAR(50);

    /* ===============================
       1. Kiểm tra booking hợp lệ
    =============================== */
    SELECT 
        @VoucherId = voucher_id,
        @TrangThaiBooking = trang_thai
    FROM DATPHONG
    WHERE id = @BookingId
      AND user_id = @UserId;

    IF @TrangThaiBooking IS NULL
    BEGIN
        RAISERROR (N'Đặt phòng không tồn tại', 16, 1);
        RETURN;
    END

    IF @TrangThaiBooking = 'COMPLETED'
    BEGIN
        RAISERROR (N'Đặt phòng đã thanh toán đủ', 16, 1);
        RETURN;
    END

    /* ===============================
       2. Tính tiền phòng
    =============================== */
    SELECT @TongTienPhong = SUM(don_gia)
    FROM CT_DATPHONG
    WHERE datphong_id = @BookingId;

    SET @TongTienPhong = ISNULL(@TongTienPhong, 0);

    /* ===============================
       3. Tính tiền dịch vụ
    =============================== */
    SELECT @TongTienDV = SUM(so_luong * don_gia)
    FROM CT_SUDUNG_DV
    WHERE datphong_id = @BookingId;

    SET @TongTienDV = ISNULL(@TongTienDV, 0);

    SET @TongTien = @TongTienPhong + @TongTienDV;

    /* ===============================
       4. Áp dụng voucher (nếu có)
    =============================== */
    SET @GiamGia = 0;

    IF @VoucherId IS NOT NULL
    BEGIN
        SELECT 
            @PhanTramGiam = phan_tram_giam,
            @SoTienToiThieu = so_tien_toi_thieu
        FROM VOUCHERS
        WHERE id = @VoucherId
          AND trang_thai = 'ACTIVE'
          AND ngay_het_han >= CAST(GETDATE() AS DATE)
          AND so_lan_da_dung < so_lan_toi_da;

        IF @PhanTramGiam IS NOT NULL
           AND @TongTien >= @SoTienToiThieu
        BEGIN
            SET @GiamGia = @TongTien * @PhanTramGiam / 100.0;
        END
    END

    SET @TongTien = @TongTien - @GiamGia;

    /* ===============================
       5. Tổng tiền đã thanh toán
    =============================== */
    SELECT @DaThanhToan = SUM(so_tien)
    FROM PAYMENTS
    WHERE booking_id = @BookingId
      AND trang_thai = 'SUCCESS';

    SET @DaThanhToan = ISNULL(@DaThanhToan, 0);

    IF (@DaThanhToan + @SoTien) > @TongTien
    BEGIN
        RAISERROR (N'Số tiền thanh toán vượt quá số tiền cần trả', 16, 1);
        RETURN;
    END

    /* ===============================
       6. Giao dịch thanh toán
    =============================== */
    BEGIN TRY
        BEGIN TRAN;

        INSERT INTO PAYMENTS
        (
            booking_id,
            user_id,
            so_tien,
            phuong_thuc,
            trang_thai,
            created_at
        )
        VALUES
        (
            @BookingId,
            @UserId,
            @SoTien,
            @PhuongThuc,
            'SUCCESS',
            GETDATE()
        );

        -- Nếu thanh toán đủ
        IF (@DaThanhToan + @SoTien) = @TongTien
        BEGIN
            UPDATE DATPHONG
            SET trang_thai = 'COMPLETED'
            WHERE id = @BookingId;

            -- tăng số lần dùng voucher
            IF @VoucherId IS NOT NULL
            BEGIN
                UPDATE VOUCHERS
                SET so_lan_da_dung = so_lan_da_dung + 1
                WHERE id = @VoucherId;
            END
        END
        ELSE
        BEGIN
            UPDATE DATPHONG
            SET trang_thai = 'CONFIRMED'
            WHERE id = @BookingId;
        END

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        THROW;
    END CATCH
END
