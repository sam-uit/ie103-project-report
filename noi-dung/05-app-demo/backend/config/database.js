import sql from 'mssql';
import dotenv from 'dotenv';

dotenv.config();

// ============================================================================
// SQL SERVER CONNECTION CONFIGURATION
// ============================================================================

const config = {
  server: process.env.DB_SERVER || 'localhost',
  port: parseInt(process.env.DB_PORT) || 1433,
  database: process.env.DB_DATABASE || 'BookingMS',
  user: process.env.DB_USER || 'sa',
  password: process.env.DB_PASSWORD,
  options: {
    encrypt: process.env.DB_ENCRYPT === 'true', // Azure SQL requires encryption
    trustServerCertificate: process.env.DB_TRUST_SERVER_CERTIFICATE === 'true',
    enableArithAbort: true,
    connectionTimeout: 30000,
    requestTimeout: 30000,
  },
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000,
  },
};

// Connection pool
let pool;

/**
 * Khởi tạo connection pool
 */
export const getPool = async () => {
  if (!pool) {
    try {
      pool = await sql.connect(config);
      console.log('✅ SQL Server connected successfully');
      
      // Handle connection errors
      pool.on('error', (err) => {
        console.error('❌ SQL Pool Error:', err);
        pool = null;
      });
      
      return pool;
    } catch (err) {
      console.error('❌ Database Connection Failed:', err);
      pool = null;
      throw err;
    }
  }
  return pool;
};

/**
 * Execute query với error handling
 */
export const executeQuery = async (query, params = {}) => {
  try {
    const pool = await getPool();
    const request = pool.request();
    
    // Add parameters
    Object.keys(params).forEach(key => {
      request.input(key, params[key]);
    });
    
    const result = await request.query(query);
    return result;
  } catch (err) {
    console.error('❌ Query Error:', err);
    throw err;
  }
};

/**
 * Execute stored procedure
 */
export const executeStoredProcedure = async (procedureName, params = {}) => {
  try {
    const pool = await getPool();
    const request = pool.request();
    
    // Add parameters
    Object.keys(params).forEach(key => {
      request.input(key, params[key]);
    });
    
    const result = await request.execute(procedureName);
    return result;
  } catch (err) {
    console.error('❌ Stored Procedure Error:', err);
    throw err;
  }
};

/**
 * Close connection pool
 */
export const closePool = async () => {
  try {
    if (pool) {
      await pool.close();
      pool = null;
      console.log('✅ SQL Server connection closed');
    }
  } catch (err) {
    console.error('❌ Error closing connection:', err);
  }
};

// Graceful shutdown
process.on('SIGINT', async () => {
  await closePool();
  process.exit(0);
});

export default sql;
