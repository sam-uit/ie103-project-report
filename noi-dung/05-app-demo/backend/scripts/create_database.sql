-- ============================================================================
-- BOOKING MANAGEMENT SYSTEM - DATABASE SCHEMA
-- ============================================================================
-- SQL Server 2019+
-- Author: VuLA Team
-- Date: 2025-12-31

-- Create Database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'BookingMS')
BEGIN
    CREATE DATABASE BookingMS;
END
GO

USE BookingMS;
GO

-- ============================================================================
-- TABLES
-- ============================================================================

-- Table: Users
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
BEGIN
    CREATE TABLE Users (
        id VARCHAR(50) PRIMARY KEY,
        name NVARCHAR(200) NOT NULL,
        email VARCHAR(255) NOT NULL UNIQUE,
        password VARCHAR(255) NOT NULL,
        phone VARCHAR(20),
        role VARCHAR(20) NOT NULL DEFAULT 'USER',
        status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
        createdAt DATETIME NOT NULL DEFAULT GETDATE(),
        updatedAt DATETIME
    );
    PRINT '✓ Table Users created';
END
ELSE
    PRINT '✓ Table Users already exists';
GO

-- Table: Rooms
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Rooms]') AND type in (N'U'))
BEGIN
    CREATE TABLE Rooms (
        id VARCHAR(50) PRIMARY KEY,
        name NVARCHAR(200) NOT NULL,
        type VARCHAR(50) NOT NULL,
        capacity INT NOT NULL,
        price DECIMAL(10,2) NOT NULL,
        amenities NVARCHAR(MAX),
        imageUrl VARCHAR(500),
        status VARCHAR(50) NOT NULL DEFAULT 'AVAILABLE',
        description NVARCHAR(MAX),
        createdAt DATETIME NOT NULL DEFAULT GETDATE(),
        updatedAt DATETIME
    );
    PRINT '✓ Table Rooms created';
END
ELSE
    PRINT '✓ Table Rooms already exists';
GO

-- Table: Bookings
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Bookings]') AND type in (N'U'))
BEGIN
    CREATE TABLE Bookings (
        id VARCHAR(50) PRIMARY KEY,
        userId VARCHAR(50) NOT NULL,
        roomId VARCHAR(50) NOT NULL,
        checkIn DATETIME NOT NULL,
        checkOut DATETIME NOT NULL,
        guests INT NOT NULL,
        totalAmount DECIMAL(10,2) NOT NULL,
        status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
        paymentStatus VARCHAR(50) NOT NULL DEFAULT 'UNPAID',
        specialRequests NVARCHAR(MAX),
        createdAt DATETIME NOT NULL DEFAULT GETDATE(),
        updatedAt DATETIME,
        CONSTRAINT FK_Bookings_Users FOREIGN KEY (userId) REFERENCES Users(id),
        CONSTRAINT FK_Bookings_Rooms FOREIGN KEY (roomId) REFERENCES Rooms(id)
    );
    PRINT '✓ Table Bookings created';
END
ELSE
    PRINT '✓ Table Bookings already exists';
GO

-- Table: Transactions
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Transactions]') AND type in (N'U'))
BEGIN
    CREATE TABLE Transactions (
        id VARCHAR(50) PRIMARY KEY,
        bookingId VARCHAR(50) NOT NULL,
        userId VARCHAR(50) NOT NULL,
        amount DECIMAL(10,2) NOT NULL,
        method VARCHAR(50) NOT NULL,
        type VARCHAR(50) NOT NULL,
        status VARCHAR(50) NOT NULL DEFAULT 'SUCCESS',
        note NVARCHAR(500),
        createdAt DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_Transactions_Bookings FOREIGN KEY (bookingId) REFERENCES Bookings(id),
        CONSTRAINT FK_Transactions_Users FOREIGN KEY (userId) REFERENCES Users(id)
    );
    PRINT '✓ Table Transactions created';
END
ELSE
    PRINT '✓ Table Transactions already exists';
GO

-- ============================================================================
-- INDEXES
-- ============================================================================

-- Users indexes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_users_email' AND object_id = OBJECT_ID('Users'))
BEGIN
    CREATE INDEX idx_users_email ON Users(email);
    PRINT '✓ Index idx_users_email created';
END
GO

-- Bookings indexes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_bookings_userId' AND object_id = OBJECT_ID('Bookings'))
BEGIN
    CREATE INDEX idx_bookings_userId ON Bookings(userId);
    PRINT '✓ Index idx_bookings_userId created';
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_bookings_roomId' AND object_id = OBJECT_ID('Bookings'))
BEGIN
    CREATE INDEX idx_bookings_roomId ON Bookings(roomId);
    PRINT '✓ Index idx_bookings_roomId created';
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_bookings_dates' AND object_id = OBJECT_ID('Bookings'))
BEGIN
    CREATE INDEX idx_bookings_dates ON Bookings(checkIn, checkOut);
    PRINT '✓ Index idx_bookings_dates created';
END
GO

-- Transactions indexes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_transactions_bookingId' AND object_id = OBJECT_ID('Transactions'))
BEGIN
    CREATE INDEX idx_transactions_bookingId ON Transactions(bookingId);
    PRINT '✓ Index idx_transactions_bookingId created';
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_transactions_userId' AND object_id = OBJECT_ID('Transactions'))
BEGIN
    CREATE INDEX idx_transactions_userId ON Transactions(userId);
    PRINT '✓ Index idx_transactions_userId created';
END
GO

-- ============================================================================
-- CONSTRAINTS & CHECKS
-- ============================================================================

-- Room capacity check
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'chk_room_capacity')
BEGIN
    ALTER TABLE Rooms ADD CONSTRAINT chk_room_capacity CHECK (capacity > 0);
    PRINT '✓ Constraint chk_room_capacity created';
END
GO

-- Room price check
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'chk_room_price')
BEGIN
    ALTER TABLE Rooms ADD CONSTRAINT chk_room_price CHECK (price >= 0);
    PRINT '✓ Constraint chk_room_price created';
END
GO

-- Booking guests check
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'chk_booking_guests')
BEGIN
    ALTER TABLE Bookings ADD CONSTRAINT chk_booking_guests CHECK (guests > 0);
    PRINT '✓ Constraint chk_booking_guests created';
END
GO

-- Transaction amount check
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'chk_transaction_amount')
BEGIN
    ALTER TABLE Transactions ADD CONSTRAINT chk_transaction_amount CHECK (amount > 0);
    PRINT '✓ Constraint chk_transaction_amount created';
END
GO

PRINT '';
PRINT '========================================';
PRINT '✅ Database schema created successfully!';
PRINT '========================================';
PRINT '';
PRINT '📊 Tables created:';
PRINT '  - Users';
PRINT '  - Rooms';
PRINT '  - Bookings';
PRINT '  - Transactions';
PRINT '';
PRINT '🔍 Indexes created: 6';
PRINT '✓ Constraints created: 4';
PRINT '';
PRINT '📝 Next steps:';
PRINT '  1. Run seed script: npm run seed';
PRINT '  2. Start backend server: npm run dev';
PRINT '';
