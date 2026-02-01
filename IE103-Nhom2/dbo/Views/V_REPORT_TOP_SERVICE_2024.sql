CREATE   VIEW V_REPORT_TOP_SERVICE_2024 AS
SELECT
    DV.Ten_Dich_Vu,
    DP.ID AS Booking_ID,
    CT.created_at AS Thoi_Gian_Su_Dung,
    CT.So_Luong,
    ISNULL(CT.Don_Gia, 0) AS Don_Gia,
    (ISNULL(CT.So_Luong, 0) * ISNULL(CT.Don_Gia, 0)) AS Thanh_Tien

FROM
    CT_SUDUNG_DV CT
JOIN
    DICHVU DV ON CT.DichVu_ID = DV.ID
JOIN
    DATPHONG DP ON CT.DatPhong_ID = DP.ID
WHERE
    YEAR(DP.Check_In) = 2024
    AND DP.Trang_Thai NOT IN ('CANCELLED')
GO

