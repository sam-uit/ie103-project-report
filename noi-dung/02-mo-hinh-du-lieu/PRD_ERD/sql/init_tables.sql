
-- ============================================
-- INIT DATABASE FOR ROOM BOOKING SYSTEM (MSSQL)
-- Phiên bản tối giản (Minimal Version)
-- ============================================

-- ===== NGƯỜI DÙNG & PHÂN QUYỀN =====

CREATE TABLE ADMINS (
    id INT IDENTITY PRIMARY KEY,
    email NVARCHAR(255) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    full_name NVARCHAR(255),
    status NVARCHAR(50) DEFAULT 'ACTIVE',
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE ROLES (
    id INT IDENTITY PRIMARY KEY,
    code NVARCHAR(50) NOT NULL UNIQUE,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(500)
);

CREATE TABLE PERMISSIONS (
    id INT IDENTITY PRIMARY KEY,
    code NVARCHAR(100) NOT NULL UNIQUE,
    description NVARCHAR(255)
);

CREATE TABLE ADMIN_ROLES (
    admin_id INT NOT NULL,
    role_id INT NOT NULL,
    PRIMARY KEY (admin_id, role_id),
    FOREIGN KEY (admin_id) REFERENCES ADMINS(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES ROLES(id) ON DELETE CASCADE
);

CREATE TABLE ROLE_PERMISSIONS (
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES ROLES(id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES PERMISSIONS(id) ON DELETE CASCADE
);

CREATE TABLE USERS (
    id INT IDENTITY PRIMARY KEY,
    email NVARCHAR(255) NOT NULL UNIQUE,
    phone NVARCHAR(20),
    password_hash NVARCHAR(255) NOT NULL,
    full_name NVARCHAR(255),
    status NVARCHAR(50) DEFAULT 'ACTIVE',
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- ===== PHÒNG & ĐẶT PHÒNG =====

CREATE TABLE LOAIPHONG (
    id INT IDENTITY PRIMARY KEY,
    ten_loai NVARCHAR(100) NOT NULL,
    gia_co_ban DECIMAL(18,2) NOT NULL,
    mo_ta NVARCHAR(500),
    suc_chua INT DEFAULT 2
);

CREATE TABLE PHONG (
    id INT IDENTITY PRIMARY KEY,
    so_phong NVARCHAR(20) NOT NULL UNIQUE,
    loai_phong_id INT NOT NULL,
    trang_thai NVARCHAR(50) DEFAULT 'AVAILABLE',
    FOREIGN KEY (loai_phong_id) REFERENCES LOAIPHONG(id)
);

-- ===== MÃ GIẢM GIÁ (VOUCHERS) =====

CREATE TABLE VOUCHERS (
    id INT IDENTITY PRIMARY KEY,
    ma_code NVARCHAR(50) NOT NULL UNIQUE,
    phan_tram_giam DECIMAL(5,2) NOT NULL,
    ngay_het_han DATE NOT NULL,
    so_tien_toi_thieu DECIMAL(18,2) DEFAULT 0,
    so_lan_toi_da INT DEFAULT 100,
    so_lan_da_dung INT DEFAULT 0,
    trang_thai NVARCHAR(50) DEFAULT 'ACTIVE',
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE DATPHONG (
    id INT IDENTITY PRIMARY KEY,
    user_id INT NOT NULL,
    voucher_id INT NULL,
    check_in DATETIME NOT NULL,
    check_out DATETIME NOT NULL,
    trang_thai NVARCHAR(50) DEFAULT 'PENDING',
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES USERS(id),
    FOREIGN KEY (voucher_id) REFERENCES VOUCHERS(id)
);

CREATE TABLE CT_DATPHONG (
    id INT IDENTITY PRIMARY KEY,
    datphong_id INT NOT NULL,
    phong_id INT NOT NULL,
    don_gia DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (datphong_id) REFERENCES DATPHONG(id) ON DELETE CASCADE,
    FOREIGN KEY (phong_id) REFERENCES PHONG(id),
    CONSTRAINT UQ_CT_DATPHONG UNIQUE (datphong_id, phong_id)
);

-- ===== THANH TOÁN =====

CREATE TABLE PAYMENTS (
    id INT IDENTITY PRIMARY KEY,
    booking_id INT NOT NULL,
    user_id INT NOT NULL,
    so_tien DECIMAL(18,2) NOT NULL,
    phuong_thuc NVARCHAR(50),
    trang_thai NVARCHAR(50),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (booking_id) REFERENCES DATPHONG(id),
    FOREIGN KEY (user_id) REFERENCES USERS(id)
);

CREATE TABLE REFUNDS (
    id INT IDENTITY PRIMARY KEY,
    payment_id INT NOT NULL,
    so_tien_hoan DECIMAL(18,2) NOT NULL,
    trang_thai NVARCHAR(50),
    ly_do NVARCHAR(500),
    requested_by INT NOT NULL,
    approved_by INT,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (payment_id) REFERENCES PAYMENTS(id),
    FOREIGN KEY (requested_by) REFERENCES USERS(id),
    FOREIGN KEY (approved_by) REFERENCES ADMINS(id)
);

-- ===== DỊCH VỤ =====

CREATE TABLE DICHVU (
    id INT IDENTITY PRIMARY KEY,
    ten_dich_vu NVARCHAR(255) NOT NULL,
    don_gia DECIMAL(18,2) NOT NULL,
    don_vi_tinh NVARCHAR(50) DEFAULT N'Lần',
    trang_thai NVARCHAR(50) DEFAULT 'ACTIVE',
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE CT_SUDUNG_DV (
    id INT IDENTITY PRIMARY KEY,
    datphong_id INT NOT NULL,
    dichvu_id INT NOT NULL,
    so_luong INT NOT NULL DEFAULT 1,
    don_gia DECIMAL(18,2) NOT NULL,
    thoi_diem_su_dung DATETIME DEFAULT GETDATE(),
    ghi_chu NVARCHAR(500),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (datphong_id) REFERENCES DATPHONG(id) ON DELETE CASCADE,
    FOREIGN KEY (dichvu_id) REFERENCES DICHVU(id)
);

-- ===== ĐÁNH GIÁ =====

CREATE TABLE REVIEWS (
    id INT IDENTITY PRIMARY KEY,
    user_id INT NOT NULL,
    phong_id INT NOT NULL,
    datphong_id INT NOT NULL UNIQUE,
    so_sao INT NOT NULL,
    binh_luan NVARCHAR(1000),
    ngay_danh_gia DATE DEFAULT CAST(GETDATE() AS DATE),
    trang_thai NVARCHAR(50) DEFAULT 'PENDING',
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES USERS(id),
    FOREIGN KEY (phong_id) REFERENCES PHONG(id),
    FOREIGN KEY (datphong_id) REFERENCES DATPHONG(id)
);

GO
