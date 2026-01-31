-- Insert ADMINS (status: ACTIVE or INACTIVE)
INSERT INTO ADMINS (email, password_hash, full_name, status) VALUES
('superadmin@gmail.com', 'hash_password_1', N'Lê Kim Long', 'ACTIVE'),
('admin@gmail.com', 'hash_password_2', N'Đinh Xuân Sâm', 'ACTIVE'),
('staff@gmail.com', 'hash_password_3', N'Nguyễn Minh Triết', 'ACTIVE');

GO