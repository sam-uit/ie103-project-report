import express from 'express';
import { BookingAdapter } from '../adapters/BookingAdapter.js';
import { RoomAdapter } from '../adapters/RoomAdapter.js';
import { TransactionAdapter } from '../adapters/TransactionAdapter.js';
import { authenticate, requireAdmin, requireUser } from '../middleware/auth.js';

const router = express.Router();

// ============================================================================
// BOOKING ROUTES
// ============================================================================

/**
 * GET /bookings
 * Lấy tất cả bookings (Admin only)
 */
router.get('/', authenticate, requireAdmin, async (req, res) => {
  try {
    const bookings = await BookingAdapter.getAll();
    res.json({
      success: true,
      data: bookings
    });
  } catch (error) {
    console.error('Get All Bookings Error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi lấy danh sách booking'
      }
    });
  }
});

/**
 * GET /bookings/my
 * Lấy bookings của user hiện tại
 */
router.get('/my', authenticate, requireUser, async (req, res) => {
  try {
    const bookings = await BookingAdapter.getByUserId(req.user.id);
    res.json({
      success: true,
      data: bookings
    });
  } catch (error) {
    console.error('Get My Bookings Error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi lấy booking của bạn'
      }
    });
  }
});

/**
 * GET /bookings/:id
 * Lấy chi tiết booking
 */
router.get('/:id', authenticate, async (req, res) => {
  try {
    const booking = await BookingAdapter.getById(req.params.id);
    
    if (!booking) {
      return res.status(404).json({
        success: false,
        error: {
          code: 'NOT_FOUND',
          message: 'Không tìm thấy booking'
        }
      });
    }
    
    // Kiểm tra quyền: User chỉ xem được booking của mình, Admin xem tất cả
    if (req.user.role !== 'ADMIN' && booking.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        error: {
          code: 'FORBIDDEN',
          message: 'Bạn không có quyền xem booking này'
        }
      });
    }
    
    res.json({
      success: true,
      data: booking
    });
  } catch (error) {
    console.error('Get Booking Error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi lấy thông tin booking'
      }
    });
  }
});

/**
 * POST /bookings
 * Tạo booking mới
 */
router.post('/', authenticate, requireUser, async (req, res) => {
  try {
    const { roomId, checkIn, checkOut, guests, specialRequests } = req.body;
    
    // Validate required fields
    if (!roomId || !checkIn || !checkOut || !guests) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Vui lòng điền đầy đủ thông tin'
        }
      });
    }
    
    // Kiểm tra phòng tồn tại
    const room = await RoomAdapter.getById(roomId);
    if (!room) {
      return res.status(404).json({
        success: false,
        error: {
          code: 'NOT_FOUND',
          message: 'Phòng không tồn tại'
        }
      });
    }
    
    // Kiểm tra phòng còn trống
    const isAvailable = await BookingAdapter.checkAvailability(roomId, checkIn, checkOut);
    if (!isAvailable) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'ROOM_NOT_AVAILABLE',
          message: 'Phòng đã được đặt trong khoảng thời gian này'
        }
      });
    }
    
    // Tạo booking
    const booking = await BookingAdapter.create({
      userId: req.user.id,
      roomId,
      checkIn,
      checkOut,
      guests,
      roomPrice: room.price,
      specialRequests: specialRequests || ''
    });
    
    res.status(201).json({
      success: true,
      data: booking
    });
  } catch (error) {
    console.error('Create Booking Error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi tạo booking'
      }
    });
  }
});

/**
 * PUT /bookings/:id/status
 * Cập nhật status booking (Admin only)
 */
router.put('/:id/status', authenticate, requireAdmin, async (req, res) => {
  try {
    const { status } = req.body;
    
    if (!status) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Status là bắt buộc'
        }
      });
    }
    
    const booking = await BookingAdapter.updateStatus(req.params.id, status);
    
    if (!booking) {
      return res.status(404).json({
        success: false,
        error: {
          code: 'NOT_FOUND',
          message: 'Không tìm thấy booking'
        }
      });
    }
    
    // Cập nhật room status nếu cần
    if (status === 'CHECKED_IN') {
      await RoomAdapter.updateStatus(booking.roomId, 'OCCUPIED');
    } else if (['CHECKED_OUT', 'CANCELLED', 'REJECTED'].includes(status)) {
      await RoomAdapter.updateStatus(booking.roomId, 'AVAILABLE');
    }
    
    res.json({
      success: true,
      data: booking
    });
  } catch (error) {
    console.error('Update Booking Status Error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi cập nhật status booking'
      }
    });
  }
});

/**
 * POST /bookings/:id/payment
 * Xử lý thanh toán
 */
router.post('/:id/payment', authenticate, requireUser, async (req, res) => {
  try {
    const { amount, method } = req.body;
    
    if (!amount || !method) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Amount và method là bắt buộc'
        }
      });
    }
    
    const booking = await BookingAdapter.getById(req.params.id);
    
    if (!booking) {
      return res.status(404).json({
        success: false,
        error: {
          code: 'NOT_FOUND',
          message: 'Không tìm thấy booking'
        }
      });
    }
    
    // Kiểm tra quyền
    if (req.user.role !== 'ADMIN' && booking.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        error: {
          code: 'FORBIDDEN',
          message: 'Bạn không có quyền thanh toán booking này'
        }
      });
    }
    
    // Tạo transaction
    const transaction = await TransactionAdapter.create({
      bookingId: booking.id,
      userId: booking.userId,
      amount,
      method,
      type: 'PAYMENT',
      status: 'SUCCESS',
      note: 'Khách hàng thanh toán'
    });
    
    // Cập nhật payment status
    await BookingAdapter.updatePaymentStatus(booking.id, 'PAID');
    
    // Nếu booking đang pending, chuyển sang confirmed
    if (booking.status === 'PENDING') {
      await BookingAdapter.updateStatus(booking.id, 'CONFIRMED');
    }
    
    res.json({
      success: true,
      data: {
        transaction,
        message: 'Thanh toán thành công'
      }
    });
  } catch (error) {
    console.error('Payment Error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi xử lý thanh toán'
      }
    });
  }
});

/**
 * POST /bookings/:id/refund
 * Xử lý hoàn tiền (Admin only)
 */
router.post('/:id/refund', authenticate, requireAdmin, async (req, res) => {
  try {
    const { amount, note } = req.body;
    
    const booking = await BookingAdapter.getById(req.params.id);
    
    if (!booking) {
      return res.status(404).json({
        success: false,
        error: {
          code: 'NOT_FOUND',
          message: 'Không tìm thấy booking'
        }
      });
    }
    
    // Tạo transaction refund
    const transaction = await TransactionAdapter.create({
      bookingId: booking.id,
      userId: booking.userId,
      amount: amount || booking.totalAmount,
      method: 'BANK_TRANSFER',
      type: 'REFUND',
      status: 'SUCCESS',
      note: note || 'Hoàn tiền do hủy phòng'
    });
    
    // Cập nhật payment status và booking status
    await BookingAdapter.updatePaymentStatus(booking.id, 'REFUNDED');
    await BookingAdapter.updateStatus(booking.id, 'REFUNDED');
    
    // Cập nhật room status
    await RoomAdapter.updateStatus(booking.roomId, 'AVAILABLE');
    
    res.json({
      success: true,
      data: {
        transaction,
        message: 'Hoàn tiền thành công'
      }
    });
  } catch (error) {
    console.error('Refund Error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi xử lý hoàn tiền'
      }
    });
  }
});

export default router;
