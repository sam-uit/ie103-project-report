import sql from 'mssql';
import { getPool } from '../config/database.js';

// ============================================================================
// BOOKING ADAPTER - SQL Server Integration
// ============================================================================

export class BookingAdapter {
  /**
   * Lấy tất cả bookings
   */
  static async getAll() {
    const pool = await getPool();
    const result = await pool.request()
      .query(`
        SELECT 
          b.*,
          r.name as roomName,
          r.type as roomType,
          u.name as userName,
          u.email as userEmail
        FROM Bookings b
        LEFT JOIN Rooms r ON b.roomId = r.id
        LEFT JOIN Users u ON b.userId = u.id
        ORDER BY b.createdAt DESC
      `);
    
    return result.recordset;
  }

  /**
   * Lấy bookings theo user
   */
  static async getByUserId(userId) {
    const pool = await getPool();
    const result = await pool.request()
      .input('userId', sql.VarChar(50), userId)
      .query(`
        SELECT 
          b.*,
          r.name as roomName,
          r.type as roomType,
          r.imageUrl as roomImage
        FROM Bookings b
        LEFT JOIN Rooms r ON b.roomId = r.id
        WHERE b.userId = @userId
        ORDER BY b.createdAt DESC
      `);
    
    return result.recordset;
  }

  /**
   * Lấy booking theo ID
   */
  static async getById(id) {
    const pool = await getPool();
    const result = await pool.request()
      .input('id', sql.VarChar(50), id)
      .query(`
        SELECT 
          b.*,
          r.name as roomName,
          r.type as roomType,
          r.price as roomPrice,
          u.name as userName,
          u.email as userEmail,
          u.phone as userPhone
        FROM Bookings b
        LEFT JOIN Rooms r ON b.roomId = r.id
        LEFT JOIN Users u ON b.userId = u.id
        WHERE b.id = @id
      `);
    
    return result.recordset.length > 0 ? result.recordset[0] : null;
  }

  /**
   * Kiểm tra phòng còn trống
   */
  static async checkAvailability(roomId, checkIn, checkOut, excludeBookingId = null) {
    const pool = await getPool();
    const request = pool.request()
      .input('roomId', sql.VarChar(50), roomId)
      .input('checkIn', sql.DateTime, new Date(checkIn))
      .input('checkOut', sql.DateTime, new Date(checkOut));
    
    let query = `
      SELECT COUNT(*) as conflicts
      FROM Bookings
      WHERE roomId = @roomId
        AND status NOT IN ('CANCELLED', 'REJECTED', 'REFUNDED')
        AND (
          (checkIn >= @checkIn AND checkIn < @checkOut) OR
          (checkOut > @checkIn AND checkOut <= @checkOut) OR
          (checkIn <= @checkIn AND checkOut >= @checkOut)
        )
    `;
    
    if (excludeBookingId) {
      query += ' AND id != @excludeBookingId';
      request.input('excludeBookingId', sql.VarChar(50), excludeBookingId);
    }
    
    const result = await request.query(query);
    return result.recordset[0].conflicts === 0;
  }

  /**
   * Tạo booking mới
   */
  static async create(bookingData) {
    const pool = await getPool();
    
    // Tính số ngày và tổng tiền
    const checkIn = new Date(bookingData.checkIn);
    const checkOut = new Date(bookingData.checkOut);
    const nights = Math.ceil((checkOut - checkIn) / (1000 * 60 * 60 * 24));
    const totalAmount = nights * bookingData.roomPrice;
    
    const result = await pool.request()
      .input('id', sql.VarChar(50), `B${Date.now()}`)
      .input('userId', sql.VarChar(50), bookingData.userId)
      .input('roomId', sql.VarChar(50), bookingData.roomId)
      .input('checkIn', sql.DateTime, checkIn)
      .input('checkOut', sql.DateTime, checkOut)
      .input('guests', sql.Int, bookingData.guests)
      .input('totalAmount', sql.Decimal(10, 2), totalAmount)
      .input('status', sql.VarChar(50), 'PENDING')
      .input('paymentStatus', sql.VarChar(50), 'UNPAID')
      .input('specialRequests', sql.NVarChar(sql.MAX), bookingData.specialRequests || '')
      .query(`
        INSERT INTO Bookings (id, userId, roomId, checkIn, checkOut, guests, totalAmount, status, paymentStatus, specialRequests, createdAt, updatedAt)
        OUTPUT INSERTED.*
        VALUES (@id, @userId, @roomId, @checkIn, @checkOut, @guests, @totalAmount, @status, @paymentStatus, @specialRequests, GETDATE(), GETDATE())
      `);
    
    return result.recordset[0];
  }

  /**
   * Cập nhật status booking
   */
  static async updateStatus(id, status) {
    const pool = await getPool();
    const result = await pool.request()
      .input('id', sql.VarChar(50), id)
      .input('status', sql.VarChar(50), status)
      .query(`
        UPDATE Bookings
        SET status = @status, updatedAt = GETDATE()
        OUTPUT INSERTED.*
        WHERE id = @id
      `);
    
    return result.recordset.length > 0 ? result.recordset[0] : null;
  }

  /**
   * Cập nhật payment status
   */
  static async updatePaymentStatus(id, paymentStatus) {
    const pool = await getPool();
    const result = await pool.request()
      .input('id', sql.VarChar(50), id)
      .input('paymentStatus', sql.VarChar(50), paymentStatus)
      .query(`
        UPDATE Bookings
        SET paymentStatus = @paymentStatus, updatedAt = GETDATE()
        OUTPUT INSERTED.*
        WHERE id = @id
      `);
    
    return result.recordset.length > 0 ? result.recordset[0] : null;
  }
}
