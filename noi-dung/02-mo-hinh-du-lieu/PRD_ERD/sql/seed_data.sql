-- ============================================
-- SEED DATA FOR ROOM BOOKING SYSTEM (MSSQL)
-- Dữ liệu mẫu với nhiều trạng thái khác nhau
-- ============================================

-- ===== PHÂN QUYỀN =====

-- Insert ROLES
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

-- Insert ADMINS
INSERT INTO ADMINS (email, password_hash, full_name, status) VALUES
('superadmin@gmail.com', 'hash_password_1', N'Lê Kim Long', 'HOAT_DONG'),
('admin@gmail.com', 'hash_password_2', N'Đinh Xuân Sâm', 'HOAT_DONG'),
('staff@gmail.com', 'hash_password_3', N'Nguyễn Minh Triết', 'HOAT_DONG');

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

INSERT INTO USERS (email, phone, password_hash, full_name, status) VALUES
('user1@gmail.com', '0901234567', 'hash_u1', N'Nguyễn Minh Anh', 'HOAT_DONG'),
('user2@gmail.com', '0912345678', 'hash_u2', N'Trần Thị Bảo', 'HOAT_DONG'),
('user3@gmail.com', '0923456789', 'hash_u3', N'Lê Hoàng Cường', 'HOAT_DONG'),
('user4@gmail.com', '0934567890', 'hash_u4', N'Phạm Thùy Dương', 'HOAT_DONG'),
('user5@gmail.com', '0945678901', 'hash_u5', N'Võ Văn Em', 'HOAT_DONG'),
('user6@gmail.com', '0956789012', 'hash_u6', N'Đỗ Thị Phương', 'HOAT_DONG'),
('user7@gmail.com', '0967890123', 'hash_u7', N'Hoàng Văn Giang', 'HOAT_DONG'),
('user8@gmail.com', '0978901234', 'hash_u8', N'Bùi Minh Hải', 'NGUNG_HOAT_DONG'),
('user9@gmail.com', '0989012345', 'hash_u9', N'Ngô Thị Hương', 'HOAT_DONG'),
('user10@gmail.com', '0990123456', 'hash_u10', N'Phan Văn Khải', 'HOAT_DONG'),
('user11@gmail.com', '0901111111', 'hash_u11', N'Trương Thị Linh', 'HOAT_DONG'),
('user12@gmail.com', '0902222222', 'hash_u12', N'Lý Văn Minh', 'HOAT_DONG');

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

INSERT INTO PHONG (so_phong, loai_phong_id, trang_thai) VALUES
-- Tầng 1
('101', 1, 'TRONG'),
('102', 1, 'TRONG'),
('103', 2, 'DA_DAT'),
('104', 3, 'TRONG'),
('105', 3, 'TRONG'),
-- Tầng 2
('201', 4, 'DA_DAT'),
('202', 4, 'TRONG'),
('203', 5, 'TRONG'),
('204', 5, 'BAO_TRI'),
('205', 6, 'TRONG'),
-- Tầng 3
('301', 7, 'DA_DAT'),
('302', 7, 'TRONG'),
('303', 8, 'TRONG'),
('304', 9, 'TRONG'),
('305', 9, 'DA_DAT'),
-- Tầng 4
('401', 10, 'TRONG'),
('402', 10, 'TRONG'),
('403', 6, 'TRONG'),
('404', 4, 'BAO_TRI'),
('405', 3, 'TRONG');

GO

-- ===== MÃ GIẢM GIÁ =====

INSERT INTO VOUCHERS (ma_code, phan_tram_giam, ngay_het_han, so_tien_toi_thieu, so_lan_toi_da, so_lan_da_dung, trang_thai) VALUES
('SUMMER2024', 15.00, '2024-08-31', 1000000, 100, 23, 'HOAT_DONG'),
('WELCOME10', 10.00, '2024-12-31', 500000, 500, 145, 'HOAT_DONG'),
('VIP20', 20.00, '2024-12-31', 2000000, 50, 8, 'HOAT_DONG'),
('NEWYEAR25', 25.00, '2024-02-01', 1500000, 200, 89, 'HOAT_DONG'),
('FLASH50', 50.00, '2024-06-30', 3000000, 20, 20, 'HET_HAN'),
('WEEKEND15', 15.00, '2024-12-31', 800000, 300, 67, 'HOAT_DONG'),
('STUDENT5', 5.00, '2024-12-31', 0, 1000, 234, 'HOAT_DONG'),
('MEMBER30', 30.00, '2024-12-31', 2500000, 100, 34, 'HOAT_DONG'),
('BIRTHDAY20', 20.00, '2024-12-31', 1000000, 150, 45, 'HOAT_DONG'),
('LOYALTY40', 40.00, '2024-09-30', 5000000, 30, 12, 'HOAT_DONG'),
('EXPIRED10', 10.00, '2024-01-01', 500000, 100, 56, 'HET_HAN'),
('INACTIVE15', 15.00, '2024-12-31', 1000000, 50, 10, 'NGUNG_HOAT_DONG');

GO

-- ===== DỊCH VỤ =====

INSERT INTO DICHVU (ten_dich_vu, don_gia, don_vi_tinh, trang_thai) VALUES
(N'Ăn sáng Buffet', 150000, N'Suất', 'HOAT_DONG'),
(N'Ăn sáng Phòng', 200000, N'Suất', 'HOAT_DONG'),
(N'Ăn trưa Set', 250000, N'Suất', 'HOAT_DONG'),
(N'Ăn tối Set', 300000, N'Suất', 'HOAT_DONG'),
(N'Giặt ủi', 50000, N'Kg', 'HOAT_DONG'),
(N'Massage body', 500000, N'Giờ', 'HOAT_DONG'),
(N'Đưa đón sân bay', 400000, N'Lượt', 'HOAT_DONG'),
(N'Thuê xe máy', 150000, N'Ngày', 'HOAT_DONG'),
(N'Tour thành phố', 800000, N'Người', 'HOAT_DONG'),
(N'Spa chăm sóc da', 700000, N'Lần', 'HOAT_DONG'),
(N'Karaoke', 300000, N'Giờ', 'HOAT_DONG'),
(N'Minibar', 100000, N'Lần', 'HOAT_DONG'),
(N'Late checkout', 200000, N'Lần', 'HOAT_DONG'),
(N'Early checkin', 150000, N'Lần', 'NGUNG_HOAT_DONG');

GO

-- ===== ĐẶT PHÒNG =====

INSERT INTO DATPHONG (user_id, voucher_id, check_in, check_out, trang_thai, created_at) VALUES
-- Đặt phòng đã hoàn thành
(1, 1, '2024-01-05 14:00:00', '2024-01-08 12:00:00', 'HOAN_THANH', '2024-01-01 10:00:00'),
(2, 2, '2024-01-10 14:00:00', '2024-01-12 12:00:00', 'HOAN_THANH', '2024-01-05 15:30:00'),
(3, NULL, '2024-01-15 14:00:00', '2024-01-17 12:00:00', 'HOAN_THANH', '2024-01-10 09:00:00'),
(4, 3, '2024-01-20 14:00:00', '2024-01-25 12:00:00', 'HOAN_THANH', '2024-01-15 11:20:00'),
-- Đặt phòng đang diễn ra
(5, NULL, '2024-01-25 14:00:00', '2024-01-28 12:00:00', 'DA_XAC_NHAN', '2024-01-20 16:00:00'),
(6, 4, '2024-01-26 14:00:00', '2024-01-29 12:00:00', 'DA_XAC_NHAN', '2024-01-22 14:00:00'),
(7, NULL, '2024-01-27 14:00:00', '2024-01-30 12:00:00', 'DA_XAC_NHAN', '2024-01-23 10:30:00'),
-- Đặt phòng sắp tới
(8, 6, '2024-02-01 14:00:00', '2024-02-05 12:00:00', 'CHO_XU_LY', '2024-01-25 09:00:00'),
(9, NULL, '2024-02-05 14:00:00', '2024-02-08 12:00:00', 'CHO_XU_LY', '2024-01-26 11:00:00'),
(10, 7, '2024-02-10 14:00:00', '2024-02-15 12:00:00', 'CHO_XU_LY', '2024-01-27 15:00:00'),
-- Đặt phòng đã hủy
(11, NULL, '2024-01-18 14:00:00', '2024-01-20 12:00:00', 'DA_HUY', '2024-01-10 10:00:00'),
(12, 9, '2024-01-22 14:00:00', '2024-01-24 12:00:00', 'DA_HUY', '2024-01-15 14:00:00'),
-- Thêm một số đặt phòng nữa
(1, 8, '2024-02-12 14:00:00', '2024-02-14 12:00:00', 'DA_XAC_NHAN', '2024-01-28 10:00:00'),
(2, NULL, '2024-02-15 14:00:00', '2024-02-18 12:00:00', 'CHO_XU_LY', '2024-01-28 11:00:00'),
(3, 10, '2024-02-20 14:00:00', '2024-02-25 12:00:00', 'CHO_XU_LY', '2024-01-28 13:00:00');

GO

-- ===== CHI TIẾT ĐẶT PHÒNG =====

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

INSERT INTO PAYMENTS (booking_id, user_id, so_tien, phuong_thuc, trang_thai, created_at) VALUES
-- Thanh toán thành công
(1, 1, 1785000, 'THE_TIN_DUNG', 'THANH_CONG', '2024-01-01 10:30:00'), -- 2100000 - 15%
(2, 2, 1440000, 'CHUYEN_KHOAN', 'THANH_CONG', '2024-01-05 16:00:00'), -- 1600000 - 10%
(3, 3, 2400000, 'VI_DIEN_TU', 'THANH_CONG', '2024-01-10 09:30:00'), -- No voucher
(4, 4, 17200000, 'CHUYEN_KHOAN', 'THANH_CONG', '2024-01-15 12:00:00'), -- (2500000 + 1800000) * 5 nights * 0.8
-- Thanh toán đang xử lý
(5, 5, 6000000, 'THE_TIN_DUNG', 'CHO_XU_LY', '2024-01-20 16:30:00'),
(6, 6, 5625000, 'CHUYEN_KHOAN', 'CHO_XU_LY', '2024-01-22 14:30:00'), -- 7500000 - 25%
-- Thanh toán thất bại
(7, 7, 5400000, 'THE_TIN_DUNG', 'THAT_BAI', '2024-01-23 11:00:00'),
(8, 8, 8500000, 'VI_DIEN_TU', 'THAT_BAI', '2024-01-25 09:30:00'),
-- Thanh toán đã hủy
(11, 11, 1000000, 'TIEN_MAT', 'DA_HUY', '2024-01-10 10:30:00'),
(12, 12, 2400000, 'CHUYEN_KHOAN', 'DA_HUY', '2024-01-15 14:30:00'),
-- Thanh toán thành công khác
(13, 1, 5100000, 'THE_TIN_DUNG', 'THANH_CONG', '2024-01-28 10:30:00'),
(14, 2, 2400000, 'TIEN_MAT', 'THANH_CONG', '2024-01-28 11:30:00');

GO

-- ===== HOÀN TIỀN =====

INSERT INTO REFUNDS (payment_id, so_tien_hoan, trang_thai, ly_do, requested_by, approved_by, created_at) VALUES
-- Hoàn tiền đã hoàn thành
(9, 1000000, 'HOAN_THANH', N'Hủy đặt phòng trước 48 giờ', 11, 1, '2024-01-11 09:00:00'),
(10, 2400000, 'HOAN_THANH', N'Lý do cá nhân, hủy trước 24 giờ', 12, 2, '2024-01-16 10:00:00'),
-- Hoàn tiền đang chờ duyệt
(1, 500000, 'YEU_CAU', N'Dịch vụ không như cam kết', 1, NULL, '2024-01-09 14:00:00'),
-- Hoàn tiền đã duyệt, chờ xử lý
(2, 1440000, 'DA_DUYET', N'Lỗi từ phía khách sạn', 2, 1, '2024-01-13 11:00:00'),
-- Hoàn tiền bị từ chối
(7, 5400000, 'TU_CHOI', N'Hủy quá muộn, không đủ điều kiện hoàn tiền', 7, 2, '2024-01-24 09:00:00'),
(8, 8500000, 'TU_CHOI', N'Không đủ điều kiện hoàn tiền', 8, 1, '2024-01-26 10:00:00'),
-- Hoàn tiền đang chờ
(3, 1200000, 'YEU_CAU', N'Thay đổi lịch trình đột xuất', 3, NULL, '2024-01-18 15:00:00'),
(4, 5000000, 'YEU_CAU', N'Khẩn cấp gia đình', 4, NULL, '2024-01-26 08:00:00'),
-- Hoàn tiền một phần
(11, 2550000, 'DA_DUYET', N'Hoàn 50% do hủy trước 12 giờ', 1, 2, '2024-01-28 11:00:00'),
(12, 1200000, 'HOAN_THANH', N'Hoàn 50% theo chính sách', 2, 1, '2024-01-28 12:00:00');

GO

-- ===== CHI TIẾT SỬ DỤNG DỊCH VỤ =====

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

INSERT INTO REVIEWS (user_id, phong_id, datphong_id, so_sao, binh_luan, ngay_danh_gia, trang_thai) VALUES
-- Reviews đã được duyệt
(1, 3, 1, 5, N'Phòng rất đẹp, sạch sẽ, nhân viên thân thiện. Sẽ quay lại!', '2024-01-09', 'DA_DUYET'),
(2, 4, 2, 4, N'Phòng tốt, giá cả hợp lý. Dịch vụ đưa đón tận tình.', '2024-01-13', 'DA_DUYET'),
(3, 6, 3, 5, N'Trải nghiệm tuyệt vời! Spa và massage rất chuyên nghiệp.', '2024-01-18', 'DA_DUYET'),
(4, 11, 4, 5, N'Đặt phòng cho gia đình rất hài lòng. Phòng rộng, view đẹp.', '2024-01-26', 'DA_DUYET'),
-- Reviews đang chờ duyệt
(11, 2, 11, 2, N'Hủy phòng nhưng phải đợi lâu mới được hoàn tiền.', '2024-01-12', 'CHO_DUYET'),
(12, 7, 12, 3, N'Phòng ổn nhưng dịch vụ chậm. Giá hơi cao.', '2024-01-17', 'CHO_DUYET'),
-- Reviews bị từ chối (vi phạm quy định)
(7, 15, 7, 1, N'[Nội dung vi phạm đã bị xóa]', '2024-01-24', 'TU_CHOI'),
-- Reviews tốt khác
(1, 18, 13, 4, N'Phòng VIP sang trọng, đáng giá tiền bỏ ra.', '2024-01-29', 'DA_DUYET'),
(2, 20, 14, 5, N'Phòng đơn giản nhưng sạch sẽ, giá tốt cho sinh viên.', '2024-01-29', 'DA_DUYET'),
-- Reviews trung bình
(5, 10, 5, 3, N'Phòng tốt nhưng hơi ồn vào buổi tối.', '2024-01-28', 'CHO_DUYET');

GO