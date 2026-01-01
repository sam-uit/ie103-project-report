import sql from 'mssql';
import { getPool } from '../config/database.js';

// ============================================================================
// TRANSACTION ADAPTER - SQL Server Integration
// ============================================================================

export class TransactionAdapter {
  /**
   * Lấy tất cả transactions
   */
  static async getAll() {
    const pool = await getPool();
    const result = await pool.request()
      .query(`
        SELECT 
          t.*,
          u.name as userName,
          b.id as bookingId
        FROM Transactions t
        LEFT JOIN Users u ON t.userId = u.id
        LEFT JOIN Bookings b ON t.bookingId = b.id
        ORDER BY t.createdAt DESC
      `);
    
    return result.recordset;
  }

  /**
   * Lấy transaction theo ID
   */
  static async getById(id) {
    const pool = await getPool();
    const result = await pool.request()
      .input('id', sql.VarChar(50), id)
      .query(`
        SELECT 
          t.*,
          u.name as userName,
          u.email as userEmail,
          b.id as bookingId
        FROM Transactions t
        LEFT JOIN Users u ON t.userId = u.id
        LEFT JOIN Bookings b ON t.bookingId = b.id
        WHERE t.id = @id
      `);
    
    return result.recordset.length > 0 ? result.recordset[0] : null;
  }

  /**
   * Lấy transactions theo booking ID
   */
  static async getByBookingId(bookingId) {
    const pool = await getPool();
    const result = await pool.request()
      .input('bookingId', sql.VarChar(50), bookingId)
      .query(`
        SELECT *
        FROM Transactions
        WHERE bookingId = @bookingId
        ORDER BY createdAt DESC
      `);
    
    return result.recordset;
  }

  /**
   * Lấy transactions theo user ID
   */
  static async getByUserId(userId) {
    const pool = await getPool();
    const result = await pool.request()
      .input('userId', sql.VarChar(50), userId)
      .query(`
        SELECT 
          t.*,
          b.id as bookingId,
          r.name as roomName
        FROM Transactions t
        LEFT JOIN Bookings b ON t.bookingId = b.id
        LEFT JOIN Rooms r ON b.roomId = r.id
        WHERE t.userId = @userId
        ORDER BY t.createdAt DESC
      `);
    
    return result.recordset;
  }

  /**
   * Tạo transaction mới
   */
  static async create(transactionData) {
    const pool = await getPool();
    const result = await pool.request()
      .input('id', sql.VarChar(50), transactionData.id || `TRX${Date.now()}`)
      .input('bookingId', sql.VarChar(50), transactionData.bookingId)
      .input('userId', sql.VarChar(50), transactionData.userId)
      .input('amount', sql.Decimal(10, 2), transactionData.amount)
      .input('method', sql.VarChar(50), transactionData.method)
      .input('type', sql.VarChar(50), transactionData.type)
      .input('status', sql.VarChar(50), transactionData.status || 'SUCCESS')
      .input('note', sql.NVarChar(500), transactionData.note || '')
      .query(`
        INSERT INTO Transactions (id, bookingId, userId, amount, method, type, status, note, createdAt)
        OUTPUT INSERTED.*
        VALUES (@id, @bookingId, @userId, @amount, @method, @type, @status, @note, GETDATE())
      `);
    
    return result.recordset[0];
  }

  /**
   * Lấy thống kê theo khoảng thời gian
   */
  static async getStatistics(startDate, endDate) {
    const pool = await getPool();
    const result = await pool.request()
      .input('startDate', sql.DateTime, new Date(startDate))
      .input('endDate', sql.DateTime, new Date(endDate))
      .query(`
        SELECT 
          COUNT(*) as totalTransactions,
          SUM(CASE WHEN type = 'PAYMENT' THEN amount ELSE 0 END) as totalPayments,
          SUM(CASE WHEN type = 'REFUND' THEN amount ELSE 0 END) as totalRefunds,
          SUM(CASE WHEN type = 'PAYMENT' THEN amount ELSE -amount END) as netAmount
        FROM Transactions
        WHERE createdAt >= @startDate AND createdAt <= @endDate
          AND status = 'SUCCESS'
      `);
    
    return result.recordset[0];
  }
}
