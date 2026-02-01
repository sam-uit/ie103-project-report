INSERT INTO ROLES (code, name, description) VALUES
('SUPER_ADMIN', N'Quản trị viên cấp cao', N'Toàn quyền quản lý hệ thống'),
('ADMIN', N'Quản trị viên', N'Quản lý phòng và đặt phòng'),
('STAFF', N'Nhân viên', N'Xử lý đặt phòng và thanh toán'),
('ACCOUNTANT', N'Kế toán', N'Quản lý thanh toán và doanh thu'),
('RECEPTIONIST', N'Lễ tân', N'Tiếp nhận khách và check-in/out'),
('MANAGER', N'Quản lý', N'Giám sát hoạt động'),
('MAINTENANCE', N'Bảo trì', N'Quản lý bảo trì phòng'),
('MARKETING', N'Marketing', N'Quản lý khuyến mãi và voucher'),
('SUPPORT', N'Hỗ trợ', N'Hỗ trợ khách hàng'),
('ANALYST', N'Phân tích', N'Xem báo cáo và thống kê');

GO

-- Insert PERMISSIONS
INSERT INTO PERMISSIONS (code, description) VALUES
('VIEW_ROOMS', N'Xem danh sách phòng'),
('CREATE_ROOM', N'Tạo phòng mới'),
('UPDATE_ROOM', N'Cập nhật thông tin phòng'),
('DELETE_ROOM', N'Xóa phòng'),
('VIEW_BOOKINGS', N'Xem danh sách đặt phòng'),
('CREATE_BOOKING', N'Tạo đặt phòng'),
('UPDATE_BOOKING', N'Cập nhật đặt phòng'),
('CANCEL_BOOKING', N'Hủy đặt phòng'),
('VIEW_PAYMENTS', N'Xem thanh toán'),
('PROCESS_PAYMENT', N'Xử lý thanh toán'),
('APPROVE_REFUND', N'Duyệt hoàn tiền'),
('VIEW_REPORTS', N'Xem báo cáo'),
('MANAGE_USERS', N'Quản lý người dùng'),
('MANAGE_VOUCHERS', N'Quản lý mã giảm giá'),
('APPROVE_REVIEWS', N'Duyệt đánh giá');

GO

-- Insert ADMINS (status: ACTIVE or INACTIVE)
INSERT INTO ADMINS (email, password_hash, full_name, status) VALUES
('superadmin@gmail.com', 'hash_password_1', N'Lê Kim Long', 'ACTIVE'),
('admin@gmail.com', 'hash_password_2', N'Đinh Xuân Sâm', 'ACTIVE'),
('staff@gmail.com', 'hash_password_3', N'Nguyễn Minh Triết', 'ACTIVE');

GO

-- Insert ADMIN_ROLES
INSERT INTO ADMIN_ROLES (admin_id, role_id) VALUES
(1, 1), -- Super Admin
(2, 2), -- Admin
(2, 6), -- Admin + Manager
(3, 3), -- Staff
(3, 5); -- Staff + Receptionist

GO

-- Insert ROLE_PERMISSIONS
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id) VALUES
-- SUPER_ADMIN có tất cả quyền
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 9), (1, 10), (1, 11), (1, 12), (1, 13), (1, 14), (1, 15),
-- ADMIN
(2, 1), (2, 2), (2, 3), (2, 5), (2, 6), (2, 7), (2, 9), (2, 12),
-- STAFF
(3, 1), (3, 5), (3, 6), (3, 7), (3, 8), (3, 9), (3, 10),
-- ACCOUNTANT
(4, 9), (4, 10), (4, 11), (4, 12),
-- RECEPTIONIST
(5, 1), (5, 5), (5, 6), (5, 7),
-- MANAGER
(6, 1), (6, 5), (6, 9), (6, 12), (6, 11),
-- MARKETING
(8, 14), (8, 12);

GO

-- ===== NGƯỜI DÙNG =====

-- Insert USERS (status: ACTIVE or INACTIVE)
INSERT INTO USERS (email, phone, password_hash, full_name, status) VALUES
('user1@gmail.com', '0901234567', 'hash_u1', N'Nguyễn Minh Anh', 'ACTIVE'),
('user2@gmail.com', '0912345678', 'hash_u2', N'Trần Thị Bảo', 'ACTIVE'),
('user3@gmail.com', '0923456789', 'hash_u3', N'Lê Hoàng Cường', 'ACTIVE'),
('user4@gmail.com', '0934567890', 'hash_u4', N'Phạm Thùy Dương', 'ACTIVE'),
('user5@gmail.com', '0945678901', 'hash_u5', N'Võ Văn Em', 'ACTIVE'),
('user6@gmail.com', '0956789012', 'hash_u6', N'Đỗ Thị Phương', 'ACTIVE'),
('user7@gmail.com', '0967890123', 'hash_u7', N'Hoàng Văn Giang', 'ACTIVE'),
('user8@gmail.com', '0978901234', 'hash_u8', N'Bùi Minh Hải', 'INACTIVE'),
('user9@gmail.com', '0989012345', 'hash_u9', N'Ngô Thị Hương', 'ACTIVE'),
('user10@gmail.com', '0990123456', 'hash_u10', N'Phan Văn Khải', 'ACTIVE'),
('user11@gmail.com', '0901111111', 'hash_u11', N'Trương Thị Linh', 'ACTIVE'),
('user12@gmail.com', '0902222222', 'hash_u12', N'Lý Văn Minh', 'ACTIVE');

GO

-- ===== PHÒNG =====

INSERT INTO LOAIPHONG (ten_loai, gia_co_ban, mo_ta, suc_chua) VALUES
(N'Phòng Đơn Tiêu Chuẩn', 500000, N'Phòng đơn cơ bản, giường đơn', 1),
(N'Phòng Đơn Cao Cấp', 700000, N'Phòng đơn với tiện nghi cao cấp', 1),
(N'Phòng Đôi Tiêu Chuẩn', 800000, N'Phòng đôi với 2 giường đơn hoặc 1 giường đôi', 2),
(N'Phòng Đôi Cao Cấp', 1200000, N'Phòng đôi rộng rãi, view đẹp', 2),
(N'Phòng Gia Đình', 1500000, N'Phòng lớn cho gia đình, 2-3 giường', 4),
(N'Phòng VIP', 2000000, N'Phòng VIP với đầy đủ tiện nghi', 2),
(N'Suite Junior', 2500000, N'Suite nhỏ với phòng khách riêng', 2),
(N'Suite Executive', 3500000, N'Suite cao cấp với nhiều phòng', 4),
(N'Phòng Deluxe', 1800000, N'Phòng deluxe view biển', 2),
(N'Phòng Honeymoon', 2200000, N'Phòng trang trí lãng mạn cho cặp đôi', 2);

GO

-- Insert PHONG (trang_thai: AVAILABLE, OCCUPIED, MAINTENANCE, RESERVED)

INSERT INTO PHONG (so_phong, loai_phong_id, trang_thai) VALUES
-- Tầng 1
('101', 1, 'AVAILABLE'),
('102', 1, 'AVAILABLE'),
('103', 2, 'RESERVED'),
('104', 3, 'AVAILABLE'),
('105', 3, 'AVAILABLE'),
-- Tầng 2
('201', 4, 'RESERVED'),
('202', 4, 'AVAILABLE'),
('203', 5, 'AVAILABLE'),
('204', 5, 'MAINTENANCE'),
('205', 6, 'OCCUPIED'),
-- Tầng 3
('301', 7, 'OCCUPIED'),
('302', 7, 'AVAILABLE'),
('303', 8, 'AVAILABLE'),
('304', 9, 'AVAILABLE'),
('305', 9, 'OCCUPIED'),
-- Tầng 4
('401', 10, 'AVAILABLE'),
('402', 10, 'AVAILABLE'),
('403', 6, 'OCCUPIED'),
('404', 4, 'MAINTENANCE'),
('405', 3, 'AVAILABLE');

INSERT INTO PHONG (so_phong, loai_phong_id, trang_thai) VALUES
('501', 1, 'OCCUPIED'),
('502', 1, 'AVAILABLE'),
('503', 1, 'MAINTENANCE');


GO

-- ===== MÃ GIẢM GIÁ =====

-- Insert VOUCHERS (trang_thai: ACTIVE or INACTIVE)
-- Note: so_lan_da_dung must be <= so_lan_toi_da
INSERT INTO VOUCHERS (ma_code, phan_tram_giam, ngay_het_han, so_tien_toi_thieu, so_lan_toi_da, so_lan_da_dung, trang_thai) VALUES
('SUMMER2024', 15.00, '2024-08-31', 1000000, 100, 23, 'ACTIVE'),
('WELCOME10', 10.00, '2024-12-31', 500000, 500, 145, 'ACTIVE'),
('VIP20', 20.00, '2024-12-31', 2000000, 50, 8, 'ACTIVE'),
('NEWYEAR25', 25.00, '2024-02-01', 1500000, 200, 89, 'ACTIVE'),
('FLASH50', 50.00, '2024-06-30', 3000000, 20, 20, 'INACTIVE'), -- Đã hết lượt sử dụng
('WEEKEND15', 15.00, '2024-12-31', 800000, 300, 67, 'ACTIVE'),
('STUDENT5', 5.00, '2024-12-31', 0, 1000, 234, 'ACTIVE'),
('MEMBER30', 30.00, '2024-12-31', 2500000, 100, 34, 'ACTIVE'),
('BIRTHDAY20', 20.00, '2024-12-31', 1000000, 150, 45, 'ACTIVE'),
('LOYALTY40', 40.00, '2024-09-30', 5000000, 30, 12, 'ACTIVE'),
('EXPIRED10', 10.00, '2024-01-01', 500000, 100, 56, 'INACTIVE'), -- Đã hết hạn
('INACTIVE15', 15.00, '2024-12-31', 1000000, 50, 10, 'INACTIVE');

GO

-- ===== DỊCH VỤ =====

-- Insert DICHVU (trang_thai: ACTIVE or INACTIVE)
INSERT INTO DICHVU (ten_dich_vu, don_gia, don_vi_tinh, trang_thai) VALUES
(N'Ăn sáng Buffet', 150000, N'Suất', 'ACTIVE'),
(N'Ăn sáng Phòng', 200000, N'Suất', 'ACTIVE'),
(N'Ăn trưa Set', 250000, N'Suất', 'ACTIVE'),
(N'Ăn tối Set', 300000, N'Suất', 'ACTIVE'),
(N'Giặt ủi', 50000, N'Kg', 'ACTIVE'),
(N'Massage body', 500000, N'Giờ', 'ACTIVE'),
(N'Đưa đón sân bay', 400000, N'Lượt', 'ACTIVE'),
(N'Thuê xe máy', 150000, N'Ngày', 'ACTIVE'),
(N'Tour thành phố', 800000, N'Người', 'ACTIVE'),
(N'Spa chăm sóc da', 700000, N'Lần', 'ACTIVE'),
(N'Karaoke', 300000, N'Giờ', 'ACTIVE'),
(N'Minibar', 100000, N'Lần', 'ACTIVE'),
(N'Late checkout', 200000, N'Lần', 'ACTIVE'),
(N'Early checkin', 150000, N'Lần', 'INACTIVE');

GO

-- ===== ĐẶT PHÒNG =====

-- Insert DATPHONG
-- trang_thai: PENDING, CONFIRMED, CANCELLED, COMPLETED
-- check_in time >= 14:00:00, check_out time <= 12:00:00, check_out > check_in
INSERT INTO DATPHONG (user_id, voucher_id, check_in, check_out, trang_thai, created_at) VALUES
-- Đặt phòng đã hoàn thành
(1, 1, '2024-01-05 14:00:00', '2024-01-08 12:00:00', 'COMPLETED', '2024-01-01 10:00:00'),
(2, 2, '2024-01-10 14:00:00', '2024-01-12 12:00:00', 'COMPLETED', '2024-01-05 15:30:00'),
(3, NULL, '2024-01-15 14:00:00', '2024-01-17 12:00:00', 'COMPLETED', '2024-01-10 09:00:00'),
(4, 3, '2024-01-20 14:00:00', '2024-01-25 12:00:00', 'COMPLETED', '2024-01-15 11:20:00'),
-- Đặt phòng đang diễn ra
(5, NULL, '2024-01-25 14:00:00', '2024-01-28 12:00:00', 'CONFIRMED', '2024-01-20 16:00:00'),
(6, 4, '2024-01-26 14:00:00', '2024-01-29 12:00:00', 'CONFIRMED', '2024-01-22 14:00:00'),
(7, NULL, '2024-01-27 14:00:00', '2024-01-30 12:00:00', 'CONFIRMED', '2024-01-23 10:30:00'),
-- Đặt phòng sắp tới
(8, 6, '2024-02-01 14:00:00', '2024-02-05 12:00:00', 'PENDING', '2024-01-25 09:00:00'),
(9, NULL, '2024-02-05 14:00:00', '2024-02-08 12:00:00', 'PENDING', '2024-01-26 11:00:00'),
(10, 7, '2024-02-10 14:00:00', '2024-02-15 12:00:00', 'PENDING', '2024-01-27 15:00:00'),
-- Đặt phòng đã hủy
(11, NULL, '2024-01-18 14:00:00', '2024-01-20 12:00:00', 'CANCELLED', '2024-01-10 10:00:00'),
(12, 9, '2024-01-22 14:00:00', '2024-01-24 12:00:00', 'CANCELLED', '2024-01-15 14:00:00'),
-- Thêm một số đặt phòng nữa
(1, 8, '2024-02-12 14:00:00', '2024-02-14 12:00:00', 'CONFIRMED', '2024-01-28 10:00:00'),
(2, NULL, '2024-02-15 14:00:00', '2024-02-18 12:00:00', 'PENDING', '2024-01-28 11:00:00'),
(3, 10, '2024-02-20 14:00:00', '2024-02-25 12:00:00', 'PENDING', '2024-01-28 13:00:00');


INSERT INTO DATPHONG (user_id, voucher_id, check_in, check_out, trang_thai, created_at)
VALUES (
    1,
    NULL,
    CAST(CONVERT(VARCHAR(10), DATEADD(MONTH, -1, GETDATE()), 120) + ' 14:00:00' AS DATETIME),
    CAST(CONVERT(VARCHAR(10), DATEADD(MONTH, 1, GETDATE()), 120) + ' 12:00:00' AS DATETIME),
    'CONFIRMED',
    GETDATE()
);

INSERT INTO DATPHONG (user_id, voucher_id, check_in, check_out, trang_thai, created_at)
VALUES (
    2,
    NULL,
    CAST(CONVERT(VARCHAR(10), DATEADD(MONTH, -1, GETDATE()), 120) + ' 14:00:00' AS DATETIME),
    CAST(CONVERT(VARCHAR(10), DATEADD(MONTH, 2, GETDATE()), 120) + ' 12:00:00' AS DATETIME),
    'CONFIRMED',
    GETDATE()
);

INSERT INTO DATPHONG (user_id, voucher_id, check_in, check_out, trang_thai, created_at)
VALUES (
    3,
    NULL,
    CAST(CONVERT(VARCHAR(10), DATEADD(MONTH, -1, GETDATE()), 120) + ' 14:00:00' AS DATETIME),
    CAST(CONVERT(VARCHAR(10), DATEADD(MONTH, 2, GETDATE()), 120) + ' 12:00:00' AS DATETIME),
    'PENDING',
    GETDATE()
);


INSERT INTO CT_DATPHONG (datphong_id, phong_id, don_gia)
VALUES (16, 1, 500000.00);

INSERT INTO CT_DATPHONG (datphong_id, phong_id, don_gia)
VALUES (17, 2, 600000.00);

INSERT INTO CT_DATPHONG (datphong_id, phong_id, don_gia)
VALUES (18, 23, 600000.00);

GO

-- ===== CHI TIẾT ĐẶT PHÒNG =====

-- Insert CT_DATPHONG (don_gia > 0)
INSERT INTO CT_DATPHONG (datphong_id, phong_id, don_gia) VALUES
-- Booking 1: 3 đêm, phòng 103
(1, 3, 700000),
-- Booking 2: 2 đêm, phòng 104
(2, 4, 800000),
-- Booking 3: 2 đêm, phòng 201
(3, 6, 1200000),
-- Booking 4: 5 đêm, 2 phòng (301, 305)
(4, 11, 2500000),
(4, 15, 1800000),
-- Booking 5: 3 đêm, phòng 205
(5, 10, 2000000),
-- Booking 6: 3 đêm, phòng 301
(6, 11, 2500000),
-- Booking 7: 3 đêm, phòng 305
(7, 15, 1800000),
-- Booking 8: 4 đêm, phòng 302
(8, 12, 2500000),
-- Booking 9: 3 đêm, phòng 303
(9, 13, 3500000),
-- Booking 10: 5 đêm, 2 phòng (401, 402)
(10, 16, 2200000),
(10, 17, 2200000),
-- Booking 11 (cancelled): phòng 102
(11, 2, 500000),
-- Booking 12 (cancelled): phòng 202
(12, 7, 1200000),
-- Booking 13: phòng 403
(13, 18, 2000000),
-- Booking 14: phòng 405
(14, 20, 800000),
-- Booking 15: 2 phòng
(15, 16, 2200000),
(15, 17, 2200000);

GO

-- ===== THANH TOÁN =====

-- Insert PAYMENTS
-- trang_thai: PENDING, SUCCESS, FAILED, CANCELLED, PAID, UNPAID, REFUNDED
-- phuong_thuc: TIEN_MAT, CHUYEN_KHOAN, THE, ONLINE (or NULL)
-- so_tien > 0
INSERT INTO PAYMENTS (booking_id, user_id, so_tien, phuong_thuc, trang_thai, created_at) VALUES
-- Thanh toán thành công
(1, 1, 1785000, 'THE', 'SUCCESS', '2024-01-01 10:30:00'), -- 2100000 - 15%
(2, 2, 1440000, 'CHUYEN_KHOAN', 'SUCCESS', '2024-01-05 16:00:00'), -- 1600000 - 10%
(3, 3, 2400000, 'ONLINE', 'SUCCESS', '2024-01-10 09:30:00'), -- No voucher
(4, 4, 17200000, 'CHUYEN_KHOAN', 'SUCCESS', '2024-01-15 12:00:00'), -- (2500000 + 1800000) * 5 nights * 0.8
-- Thanh toán đang xử lý
(5, 5, 6000000, 'THE', 'PENDING', '2024-01-20 16:30:00'),
(6, 6, 5625000, 'CHUYEN_KHOAN', 'PENDING', '2024-01-22 14:30:00'), -- 7500000 - 25%
-- Thanh toán thất bại
(7, 7, 5400000, 'THE', 'FAILED', '2024-01-23 11:00:00'),
(8, 8, 8500000, 'ONLINE', 'FAILED', '2024-01-25 09:30:00'),
-- Thanh toán đã hủy
(11, 11, 1000000, 'TIEN_MAT', 'CANCELLED', '2024-01-10 10:30:00'),
(12, 12, 2400000, 'CHUYEN_KHOAN', 'CANCELLED', '2024-01-15 14:30:00'),
-- Thanh toán thành công khác
(13, 1, 5100000, 'THE', 'SUCCESS', '2024-01-28 10:30:00'),
(14, 2, 2400000, 'TIEN_MAT', 'SUCCESS', '2024-01-28 11:30:00');

GO

-- ===== HOÀN TIỀN =====

-- Insert REFUNDS
-- trang_thai: REQUESTED, APPROVED, REJECTED, COMPLETED
-- so_tien_hoan > 0
INSERT INTO REFUNDS (payment_id, so_tien_hoan, trang_thai, ly_do, requested_by, approved_by, created_at) VALUES
-- Hoàn tiền đã hoàn thành
(9, 1000000, 'COMPLETED', N'Hủy đặt phòng trước 48 giờ', 11, 1, '2024-01-11 09:00:00'),
(10, 2400000, 'COMPLETED', N'Lý do cá nhân, hủy trước 24 giờ', 12, 2, '2024-01-16 10:00:00'),
-- Hoàn tiền đang chờ duyệt
(1, 500000, 'REQUESTED', N'Dịch vụ không như cam kết', 1, NULL, '2024-01-09 14:00:00'),
-- Hoàn tiền đã duyệt, chờ xử lý
(2, 1440000, 'APPROVED', N'Lỗi từ phía khách sạn', 2, 1, '2024-01-13 11:00:00'),
-- Hoàn tiền bị từ chối
(7, 5400000, 'REJECTED', N'Hủy quá muộn, không đủ điều kiện hoàn tiền', 7, 2, '2024-01-24 09:00:00'),
(8, 8500000, 'REJECTED', N'Không đủ điều kiện hoàn tiền', 8, 1, '2024-01-26 10:00:00'),
-- Hoàn tiền đang chờ
(3, 1200000, 'REQUESTED', N'Thay đổi lịch trình đột xuất', 3, NULL, '2024-01-18 15:00:00'),
(4, 5000000, 'REQUESTED', N'Khẩn cấp gia đình', 4, NULL, '2024-01-26 08:00:00'),
-- Hoàn tiền một phần
(11, 2550000, 'APPROVED', N'Hoàn 50% do hủy trước 12 giờ', 1, 2, '2024-01-28 11:00:00'),
(12, 1200000, 'COMPLETED', N'Hoàn 50% theo chính sách', 2, 1, '2024-01-28 12:00:00');

GO

-- ===== CHI TIẾT SỬ DỤNG DỊCH VỤ =====

-- Insert CT_SUDUNG_DV
-- so_luong > 0, don_gia > 0
INSERT INTO CT_SUDUNG_DV (datphong_id, dichvu_id, so_luong, don_gia, thoi_diem_su_dung, ghi_chu) VALUES
-- Booking 1 - User 1
(1, 1, 3, 150000, '2024-01-06 07:30:00', N'Ăn sáng 3 người'),
(1, 1, 3, 150000, '2024-01-07 07:45:00', N'Ăn sáng 3 người'),
(1, 5, 2, 50000, '2024-01-07 14:00:00', N'Giặt quần áo'),
(1, 12, 1, 100000, '2024-01-07 20:00:00', N'Minibar'),
-- Booking 2 - User 2
(2, 1, 2, 150000, '2024-01-11 08:00:00', N'Ăn sáng 2 người'),
(2, 7, 1, 400000, '2024-01-10 15:00:00', N'Đưa đón sân bay đến'),
(2, 7, 1, 400000, '2024-01-12 10:00:00', N'Đưa đón sân bay về'),
-- Booking 3 - User 3
(3, 2, 2, 200000, '2024-01-16 08:30:00', N'Ăn sáng phòng'),
(3, 2, 2, 200000, '2024-01-17 09:00:00', N'Ăn sáng phòng'),
(3, 6, 1, 500000, '2024-01-16 19:00:00', N'Massage thư giãn'),
(3, 10, 1, 700000, '2024-01-16 15:00:00', N'Spa chăm sóc da'),
-- Booking 4 - User 4 (5 đêm, 2 phòng)
(4, 1, 10, 150000, '2024-01-21 07:30:00', N'Ăn sáng 10 người (5 ngày)'),
(4, 9, 4, 800000, '2024-01-22 09:00:00', N'Tour 4 người'),
(4, 11, 2, 300000, '2024-01-23 20:00:00', N'Karaoke 2 giờ'),
-- Booking 5 - User 5
(5, 1, 3, 150000, '2024-01-26 08:00:00', N'Ăn sáng'),
(5, 8, 3, 150000, '2024-01-26 10:00:00', N'Thuê xe 3 ngày'),
-- Booking 6 - User 6
(6, 2, 6, 200000, '2024-01-27 08:00:00', N'Ăn sáng phòng 3 ngày'),
(6, 13, 1, 200000, '2024-01-28 14:00:00', N'Late checkout'),
-- Booking 7 - User 7
(7, 1, 3, 150000, '2024-01-28 07:30:00', N'Ăn sáng'),
-- Booking 13 - User 1
(13, 1, 2, 150000, '2024-02-13 08:00:00', N'Ăn sáng'),
(13, 6, 1, 500000, '2024-02-13 18:00:00', N'Massage'),
-- Booking 14 - User 2
(14, 1, 6, 150000, '2024-02-16 08:00:00', N'Ăn sáng 3 ngày');

GO

-- ===== ĐÁNH GIÁ =====

-- Insert REVIEWS
-- trang_thai: PENDING, APPROVED, REJECTED
-- so_sao: 1-5
INSERT INTO REVIEWS (user_id, phong_id, datphong_id, so_sao, binh_luan, ngay_danh_gia, trang_thai) VALUES
-- Reviews đã được duyệt
(1, 3, 1, 5, N'Phòng rất đẹp, sạch sẽ, nhân viên thân thiện. Sẽ quay lại!', '2024-01-09', 'APPROVED'),
(2, 4, 2, 4, N'Phòng tốt, giá cả hợp lý. Dịch vụ đưa đón tận tình.', '2024-01-13', 'APPROVED'),
(3, 6, 3, 5, N'Trải nghiệm tuyệt vời! Spa và massage rất chuyên nghiệp.', '2024-01-18', 'APPROVED'),
(4, 11, 4, 5, N'Đặt phòng cho gia đình rất hài lòng. Phòng rộng, view đẹp.', '2024-01-26', 'APPROVED'),
-- Reviews đang chờ duyệt
(11, 2, 11, 2, N'Hủy phòng nhưng phải đợi lâu mới được hoàn tiền.', '2024-01-12', 'PENDING'),
(12, 7, 12, 3, N'Phòng ổn nhưng dịch vụ chậm. Giá hơi cao.', '2024-01-17', 'PENDING'),
-- Reviews bị từ chối (vi phạm quy định)
(7, 15, 7, 1, N'[Nội dung vi phạm đã bị xóa]', '2024-01-24', 'REJECTED'),
-- Reviews tốt khác
(1, 18, 13, 4, N'Phòng VIP sang trọng, đáng giá tiền bỏ ra.', '2024-01-29', 'APPROVED'),
(2, 20, 14, 5, N'Phòng đơn giản nhưng sạch sẽ, giá tốt cho sinh viên.', '2024-01-29', 'APPROVED'),
-- Reviews trung bình
(5, 10, 5, 3, N'Phòng tốt nhưng hơi ồn vào buổi tối.', '2024-01-28', 'PENDING');

GO