CREATE OR ALTER VIEW V_REPORT_ROOM_RATING AS
SELECT
    R.id AS Review_ID,
    LP.Ten_Loai,
    P.so_phong ,
    CAST(R.so_sao AS DECIMAL(10,2)) AS Diem_Danh_Gia,

    R.binh_luan,
    R.ngay_danh_gia

FROM
    REVIEWS R
JOIN
    PHONG P ON R.phong_id = P.id
JOIN
    LOAIPHONG LP ON P.loai_phong_id = LP.id
WHERE
    R.trang_thai = 'APPROVED'
GO
