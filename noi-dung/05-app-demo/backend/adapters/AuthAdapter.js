import sql from 'mssql';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { getPool } from '../config/database.js';

// ============================================================================
// AUTH ADAPTER - SQL Server Integration
// ============================================================================

export class AuthAdapter {
  /**
   * Đăng nhập
   */
  static async login(email, password) {
    const pool = await getPool();
    const result = await pool.request()
      .input('email', sql.VarChar(255), email)
      .query(`
        SELECT 
          id,
          name,
          email,
          password,
          phone,
          role,
          status,
          createdAt
        FROM Users
        WHERE email = @email
      `);
    
    if (result.recordset.length === 0) {
      return { success: false, message: 'Email hoặc mật khẩu không đúng' };
    }
    
    const user = result.recordset[0];
    
    // Kiểm tra account status
    if (user.status !== 'ACTIVE') {
      return { success: false, message: 'Tài khoản đã bị khóa' };
    }
    
    // Verify password
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return { success: false, message: 'Email hoặc mật khẩu không đúng' };
    }
    
    // Generate JWT token
    const token = jwt.sign(
      { 
        id: user.id, 
        email: user.email, 
        role: user.role 
      },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
    );
    
    // Remove password from response
    delete user.password;
    
    return {
      success: true,
      data: {
        user,
        token
      }
    };
  }

  /**
   * Đăng ký tài khoản mới
   */
  static async register(userData) {
    const pool = await getPool();
    
    // Kiểm tra email đã tồn tại chưa
    const checkEmail = await pool.request()
      .input('email', sql.VarChar(255), userData.email)
      .query('SELECT id FROM Users WHERE email = @email');
    
    if (checkEmail.recordset.length > 0) {
      return { success: false, message: 'Email đã được sử dụng' };
    }
    
    // Hash password
    const hashedPassword = await bcrypt.hash(userData.password, 10);
    
    // Create user
    const result = await pool.request()
      .input('id', sql.VarChar(50), `U${Date.now()}`)
      .input('name', sql.NVarChar(200), userData.name)
      .input('email', sql.VarChar(255), userData.email)
      .input('password', sql.VarChar(255), hashedPassword)
      .input('phone', sql.VarChar(20), userData.phone)
      .input('role', sql.VarChar(20), 'USER')
      .input('status', sql.VarChar(20), 'ACTIVE')
      .query(`
        INSERT INTO Users (id, name, email, password, phone, role, status, createdAt)
        OUTPUT INSERTED.id, INSERTED.name, INSERTED.email, INSERTED.phone, INSERTED.role, INSERTED.status, INSERTED.createdAt
        VALUES (@id, @name, @email, @password, @phone, @role, @status, GETDATE())
      `);
    
    const user = result.recordset[0];
    
    // Generate token
    const token = jwt.sign(
      { 
        id: user.id, 
        email: user.email, 
        role: user.role 
      },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
    );
    
    return {
      success: true,
      data: {
        user,
        token
      }
    };
  }

  /**
   * Lấy thông tin user hiện tại từ token
   */
  static async getCurrentUser(userId) {
    const pool = await getPool();
    const result = await pool.request()
      .input('id', sql.VarChar(50), userId)
      .query(`
        SELECT 
          id,
          name,
          email,
          phone,
          role,
          status,
          createdAt
        FROM Users
        WHERE id = @id
      `);
    
    if (result.recordset.length === 0) {
      return null;
    }
    
    return result.recordset[0];
  }

  /**
   * Verify JWT token
   */
  static verifyToken(token) {
    try {
      return jwt.verify(token, process.env.JWT_SECRET);
    } catch (error) {
      return null;
    }
  }
}
