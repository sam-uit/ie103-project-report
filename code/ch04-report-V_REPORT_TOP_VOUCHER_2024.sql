CREATE OR ALTER VIEW V_REPORT_TOP_VOUCHER_2024 AS
SELECT
    V.id AS Voucher_ID,
    V.ma_code AS Ma_Voucher,
    COUNT(DISTINCT DP.id) AS So_Luot_Dung,
    CAST(SUM(
        CASE
            WHEN V.phan_tram_giam > 0 AND V.phan_tram_giam < 100 THEN
                (P.so_tien / (1.0 - (V.phan_tram_giam / 100.0))) - P.so_tien
            ELSE 0
        END
    ) AS DECIMAL(18, 0)) AS Tong_Tien_Da_Giam

FROM
    VOUCHERS V
JOIN
    DATPHONG DP ON V.id = DP.voucher_id
JOIN
    PAYMENTS P ON DP.id = P.booking_id
WHERE
    P.trang_thai = 'SUCCESS'
    AND YEAR(DP.Check_In) = 2024
GROUP BY
    V.id, V.ma_code, V.phan_tram_giam
GO
