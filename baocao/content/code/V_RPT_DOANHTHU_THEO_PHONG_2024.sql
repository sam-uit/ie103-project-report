CREATE OR ALTER VIEW V_RPT_DOANHTHU_THEO_PHONG_2024 AS
WITH 

TargetMonths AS (
    SELECT DISTINCT MONTH(Check_In) AS Thang, YEAR(Check_In) AS Nam
    FROM DATPHONG
    WHERE Trang_Thai = 'COMPLETED' 
      AND YEAR(Check_In) = 2024 
    -- AND YEAR(Check_In) = YEAR(GETDATE())
),

AllRooms AS (
    SELECT P.ID AS Phong_ID, P.So_Phong, LP.Ten_Loai
    FROM PHONG P
    JOIN LOAIPHONG LP ON P.loai_phong_id = LP.ID
),

ReportSkeleton AS (
    SELECT 
        M.Nam,
        M.Thang, 
        R.Phong_ID, 
        R.So_Phong, 
        R.Ten_Loai
    FROM TargetMonths M
    CROSS JOIN AllRooms R
),

ActualData AS (
    SELECT 
        MONTH(DP.Check_In) AS Thang,
        CT.Phong_ID,
        COUNT(DP.ID) AS SoLuotDat,
        SUM(CT.Don_Gia * DATEDIFF(day, DP.Check_In, DP.Check_Out)) AS DoanhThu
    FROM DATPHONG DP
    JOIN CT_DATPHONG CT ON DP.ID = CT.DatPhong_ID
    WHERE DP.Trang_Thai = 'COMPLETED'
      AND YEAR(DP.Check_In) = 2024
    GROUP BY MONTH(DP.Check_In), CT.Phong_ID
)

SELECT 
    S.Nam,
    S.Thang,
    S.So_Phong,
    S.Ten_Loai,
    ISNULL(D.SoLuotDat, 0) AS SoLuotDat,
    ISNULL(D.DoanhThu, 0) AS DoanhThuPhong
FROM 
    ReportSkeleton S
LEFT JOIN 
    ActualData D ON S.Thang = D.Thang 
                 AND S.Phong_ID = D.Phong_ID;
GO
