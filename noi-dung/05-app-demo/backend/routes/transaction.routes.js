import express from 'express';
import { TransactionAdapter } from '../adapters/TransactionAdapter.js';
import { authenticate, requireAdmin } from '../middleware/auth.js';

const router = express.Router();

// ============================================================================
// TRANSACTION ROUTES
// ============================================================================

/**
 * GET /transactions
 * Lấy tất cả transactions (Admin only)
 */
router.get('/', authenticate, requireAdmin, async (req, res) => {
  try {
    const transactions = await TransactionAdapter.getAll();
    res.json({
      success: true,
      data: transactions
    });
  } catch (error) {
    console.error('Get All Transactions Error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi lấy danh sách transaction'
      }
    });
  }
});

/**
 * GET /transactions/my
 * Lấy transactions của user hiện tại
 */
router.get('/my', authenticate, async (req, res) => {
  try {
    const transactions = await TransactionAdapter.getByUserId(req.user.id);
    res.json({
      success: true,
      data: transactions
    });
  } catch (error) {
    console.error('Get My Transactions Error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi lấy transaction của bạn'
      }
    });
  }
});

/**
 * GET /transactions/:id
 * Lấy chi tiết transaction
 */
router.get('/:id', authenticate, async (req, res) => {
  try {
    const transaction = await TransactionAdapter.getById(req.params.id);
    
    if (!transaction) {
      return res.status(404).json({
        success: false,
        error: {
          code: 'NOT_FOUND',
          message: 'Không tìm thấy transaction'
        }
      });
    }
    
    // Kiểm tra quyền: User chỉ xem được transaction của mình, Admin xem tất cả
    if (req.user.role !== 'ADMIN' && transaction.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        error: {
          code: 'FORBIDDEN',
          message: 'Bạn không có quyền xem transaction này'
        }
      });
    }
    
    res.json({
      success: true,
      data: transaction
    });
  } catch (error) {
    console.error('Get Transaction Error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi lấy thông tin transaction'
      }
    });
  }
});

/**
 * GET /transactions/booking/:bookingId
 * Lấy transactions theo booking ID
 */
router.get('/booking/:bookingId', authenticate, async (req, res) => {
  try {
    const transactions = await TransactionAdapter.getByBookingId(req.params.bookingId);
    res.json({
      success: true,
      data: transactions
    });
  } catch (error) {
    console.error('Get Transactions by Booking Error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi lấy transaction theo booking'
      }
    });
  }
});

/**
 * GET /transactions/statistics
 * Lấy thống kê transactions (Admin only)
 */
router.get('/statistics/summary', authenticate, requireAdmin, async (req, res) => {
  try {
    const { startDate, endDate } = req.query;
    
    if (!startDate || !endDate) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: 'startDate và endDate là bắt buộc'
        }
      });
    }
    
    const statistics = await TransactionAdapter.getStatistics(startDate, endDate);
    res.json({
      success: true,
      data: statistics
    });
  } catch (error) {
    console.error('Get Statistics Error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi lấy thống kê'
      }
    });
  }
});

export default router;
