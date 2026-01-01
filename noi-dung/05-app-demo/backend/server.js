import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { getPool } from './config/database.js';

// Routes
import authRoutes from './routes/auth.routes.js';
import roomRoutes from './routes/room.routes.js';
import bookingRoutes from './routes/booking.routes.js';
import transactionRoutes from './routes/transaction.routes.js';

// Load environment variables
dotenv.config();

// ============================================================================
// EXPRESS APP SETUP
// ============================================================================

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:5174',
  credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logging
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// ============================================================================
// ROUTES
// ============================================================================

app.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'BookingMS API Server',
    version: '1.0.0',
    endpoints: {
      auth: '/api/auth',
      rooms: '/api/rooms',
      bookings: '/api/bookings',
      transactions: '/api/transactions'
    }
  });
});

// API Routes
app.use('/api/auth', authRoutes);
app.use('/api/rooms', roomRoutes);
app.use('/api/bookings', bookingRoutes);
app.use('/api/transactions', transactionRoutes);

// 404 Handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: {
      code: 'NOT_FOUND',
      message: 'API endpoint không tồn tại'
    }
  });
});

// Error Handler
app.use((err, req, res, next) => {
  console.error('Server Error:', err);
  res.status(500).json({
    success: false,
    error: {
      code: 'SERVER_ERROR',
      message: err.message || 'Lỗi server'
    }
  });
});

// ============================================================================
// START SERVER
// ============================================================================

const startServer = async () => {
  try {
    // Test database connection
    await getPool();
    console.log('✅ Database connected');
    
    // Start Express server
    app.listen(PORT, () => {
      console.log(`✅ Server is running on http://localhost:${PORT}`);
      console.log(`✅ Environment: ${process.env.NODE_ENV || 'development'}`);
      console.log(`✅ CORS Origin: ${process.env.CORS_ORIGIN || 'http://localhost:5174'}`);
    });
  } catch (error) {
    console.error('❌ Failed to start server:', error);
    process.exit(1);
  }
};

startServer();
