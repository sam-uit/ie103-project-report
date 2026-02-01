CREATE OR ALTER VIEW V_REPORT_USER_VIP_2024 AS
SELECT
    U.ID AS UserID,
    U.Full_Name AS TenKhachHang,
    U.Email,
    U.Phone,
    P.so_tien AS TienChiTieu,
    P.created_at AS NgayThanhToan,
    MONTH(P.created_at) AS Thang
FROM
    USERS U
JOIN DATPHONG DP ON U.ID = DP.User_ID
JOIN PAYMENTS P ON DP.ID = P.Booking_ID
WHERE
    (P.trang_thai = 'SUCCESS' OR P.trang_thai = 'PAID')
    AND YEAR(P.created_at) = 2024
GO
