import express from 'express';
import { RoomAdapter } from '../adapters/RoomAdapter.js';
import { authenticate, requireAdmin } from '../middleware/auth.js';

const router = express.Router();

// ============================================================================
// ROOM ROUTES
// ============================================================================

/**
 * GET /rooms
 * Lấy tất cả phòng (public)
 */
router.get('/', async (req, res) => {
  try {
    const rooms = await RoomAdapter.getAll();
    res.json({
      success: true,
      data: rooms
    });
  } catch (error) {
    console.error('Get Rooms Error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi lấy danh sách phòng'
      }
    });
  }
});

/**
 * GET /rooms/:id
 * Lấy chi tiết phòng
 */
router.get('/:id', async (req, res) => {
  try {
    const room = await RoomAdapter.getById(req.params.id);
    
    if (!room) {
      return res.status(404).json({
        success: false,
        error: {
          code: 'NOT_FOUND',
          message: 'Không tìm thấy phòng'
        }
      });
    }
    
    res.json({
      success: true,
      data: room
    });
  } catch (error) {
    console.error('Get Room Error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi lấy thông tin phòng'
      }
    });
  }
});

/**
 * POST /rooms
 * Tạo phòng mới (Admin only)
 */
router.post('/', authenticate, requireAdmin, async (req, res) => {
  try {
    const room = await RoomAdapter.create(req.body);
    res.status(201).json({
      success: true,
      data: room
    });
  } catch (error) {
    console.error('Create Room Error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi tạo phòng'
      }
    });
  }
});

/**
 * PUT /rooms/:id
 * Cập nhật phòng (Admin only)
 */
router.put('/:id', authenticate, requireAdmin, async (req, res) => {
  try {
    const room = await RoomAdapter.update(req.params.id, req.body);
    
    if (!room) {
      return res.status(404).json({
        success: false,
        error: {
          code: 'NOT_FOUND',
          message: 'Không tìm thấy phòng'
        }
      });
    }
    
    res.json({
      success: true,
      data: room
    });
  } catch (error) {
    console.error('Update Room Error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi cập nhật phòng'
      }
    });
  }
});

/**
 * DELETE /rooms/:id
 * Xóa phòng (Admin only)
 */
router.delete('/:id', authenticate, requireAdmin, async (req, res) => {
  try {
    const success = await RoomAdapter.delete(req.params.id);
    
    if (!success) {
      return res.status(404).json({
        success: false,
        error: {
          code: 'NOT_FOUND',
          message: 'Không tìm thấy phòng'
        }
      });
    }
    
    res.json({
      success: true,
      message: 'Xóa phòng thành công'
    });
  } catch (error) {
    console.error('Delete Room Error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi xóa phòng'
      }
    });
  }
});

export default router;
