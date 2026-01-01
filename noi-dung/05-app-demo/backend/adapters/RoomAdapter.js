import sql from 'mssql';
import { getPool } from '../config/database.js';

// ============================================================================
// ROOM ADAPTER - SQL Server Integration
// ============================================================================

export class RoomAdapter {
  /**
   * Lấy tất cả phòng
   */
  static async getAll() {
    const pool = await getPool();
    const result = await pool.request()
      .query(`
        SELECT 
          id,
          name,
          type,
          capacity,
          price,
          amenities,
          imageUrl,
          status,
          description,
          createdAt,
          updatedAt
        FROM Rooms
        ORDER BY createdAt DESC
      `);
    
    return result.recordset.map(room => ({
      ...room,
      amenities: room.amenities ? JSON.parse(room.amenities) : []
    }));
  }

  /**
   * Lấy phòng theo ID
   */
  static async getById(id) {
    const pool = await getPool();
    const result = await pool.request()
      .input('id', sql.VarChar(50), id)
      .query(`
        SELECT 
          id,
          name,
          type,
          capacity,
          price,
          amenities,
          imageUrl,
          status,
          description,
          createdAt,
          updatedAt
        FROM Rooms
        WHERE id = @id
      `);
    
    if (result.recordset.length === 0) {
      return null;
    }
    
    const room = result.recordset[0];
    return {
      ...room,
      amenities: room.amenities ? JSON.parse(room.amenities) : []
    };
  }

  /**
   * Tìm kiếm phòng theo điều kiện
   */
  static async search(filters = {}) {
    const pool = await getPool();
    const request = pool.request();
    
    let query = 'SELECT * FROM Rooms WHERE 1=1';
    
    if (filters.type) {
      query += ' AND type = @type';
      request.input('type', sql.VarChar(50), filters.type);
    }
    
    if (filters.status) {
      query += ' AND status = @status';
      request.input('status', sql.VarChar(50), filters.status);
    }
    
    if (filters.minPrice) {
      query += ' AND price >= @minPrice';
      request.input('minPrice', sql.Decimal(10, 2), filters.minPrice);
    }
    
    if (filters.maxPrice) {
      query += ' AND price <= @maxPrice';
      request.input('maxPrice', sql.Decimal(10, 2), filters.maxPrice);
    }
    
    query += ' ORDER BY createdAt DESC';
    
    const result = await request.query(query);
    return result.recordset.map(room => ({
      ...room,
      amenities: room.amenities ? JSON.parse(room.amenities) : []
    }));
  }

  /**
   * Tạo phòng mới
   */
  static async create(roomData) {
    const pool = await getPool();
    const result = await pool.request()
      .input('id', sql.VarChar(50), roomData.id || `R${Date.now()}`)
      .input('name', sql.NVarChar(200), roomData.name)
      .input('type', sql.VarChar(50), roomData.type)
      .input('capacity', sql.Int, roomData.capacity)
      .input('price', sql.Decimal(10, 2), roomData.price)
      .input('amenities', sql.NVarChar(sql.MAX), JSON.stringify(roomData.amenities || []))
      .input('imageUrl', sql.VarChar(500), roomData.imageUrl)
      .input('status', sql.VarChar(50), roomData.status || 'AVAILABLE')
      .input('description', sql.NVarChar(sql.MAX), roomData.description || '')
      .query(`
        INSERT INTO Rooms (id, name, type, capacity, price, amenities, imageUrl, status, description, createdAt, updatedAt)
        OUTPUT INSERTED.*
        VALUES (@id, @name, @type, @capacity, @price, @amenities, @imageUrl, @status, @description, GETDATE(), GETDATE())
      `);
    
    const room = result.recordset[0];
    return {
      ...room,
      amenities: room.amenities ? JSON.parse(room.amenities) : []
    };
  }

  /**
   * Cập nhật phòng
   */
  static async update(id, roomData) {
    const pool = await getPool();
    const result = await pool.request()
      .input('id', sql.VarChar(50), id)
      .input('name', sql.NVarChar(200), roomData.name)
      .input('type', sql.VarChar(50), roomData.type)
      .input('capacity', sql.Int, roomData.capacity)
      .input('price', sql.Decimal(10, 2), roomData.price)
      .input('amenities', sql.NVarChar(sql.MAX), JSON.stringify(roomData.amenities || []))
      .input('imageUrl', sql.VarChar(500), roomData.imageUrl)
      .input('status', sql.VarChar(50), roomData.status)
      .input('description', sql.NVarChar(sql.MAX), roomData.description || '')
      .query(`
        UPDATE Rooms
        SET 
          name = @name,
          type = @type,
          capacity = @capacity,
          price = @price,
          amenities = @amenities,
          imageUrl = @imageUrl,
          status = @status,
          description = @description,
          updatedAt = GETDATE()
        OUTPUT INSERTED.*
        WHERE id = @id
      `);
    
    if (result.recordset.length === 0) {
      return null;
    }
    
    const room = result.recordset[0];
    return {
      ...room,
      amenities: room.amenities ? JSON.parse(room.amenities) : []
    };
  }

  /**
   * Xóa phòng
   */
  static async delete(id) {
    const pool = await getPool();
    const result = await pool.request()
      .input('id', sql.VarChar(50), id)
      .query('DELETE FROM Rooms WHERE id = @id');
    
    return result.rowsAffected[0] > 0;
  }

  /**
   * Cập nhật status phòng
   */
  static async updateStatus(id, status) {
    const pool = await getPool();
    const result = await pool.request()
      .input('id', sql.VarChar(50), id)
      .input('status', sql.VarChar(50), status)
      .query(`
        UPDATE Rooms
        SET status = @status, updatedAt = GETDATE()
        WHERE id = @id
      `);
    
    return result.rowsAffected[0] > 0;
  }
}
