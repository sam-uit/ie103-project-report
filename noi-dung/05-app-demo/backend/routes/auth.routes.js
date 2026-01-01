import express from 'express';
import { AuthAdapter } from '../adapters/AuthAdapter.js';
import { authenticate } from '../middleware/auth.js';

const router = express.Router();

// ============================================================================
// AUTH ROUTES
// ============================================================================

/**
 * POST /auth/login
 * Đăng nhập
 */
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Email và password là bắt buộc'
        }
      });
    }
    
    const result = await AuthAdapter.login(email, password);
    
    if (!result.success) {
      return res.status(401).json(result);
    }
    
    res.json(result);
  } catch (error) {
    console.error('Login Error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi đăng nhập'
      }
    });
  }
});

/**
 * POST /auth/register
 * Đăng ký tài khoản mới
 */
router.post('/register', async (req, res) => {
  try {
    const { name, email, password, phone } = req.body;
    
    if (!name || !email || !password || !phone) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Vui lòng điền đầy đủ thông tin'
        }
      });
    }
    
    const result = await AuthAdapter.register({ name, email, password, phone });
    
    if (!result.success) {
      return res.status(400).json(result);
    }
    
    res.status(201).json(result);
  } catch (error) {
    console.error('Register Error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi đăng ký'
      }
    });
  }
});

/**
 * GET /auth/me
 * Lấy thông tin user hiện tại
 */
router.get('/me', authenticate, async (req, res) => {
  try {
    res.json({
      success: true,
      data: req.user
    });
  } catch (error) {
    console.error('Get Current User Error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi lấy thông tin user'
      }
    });
  }
});

/**
 * POST /auth/logout
 * Đăng xuất (client sẽ xóa token)
 */
router.post('/logout', authenticate, async (req, res) => {
  res.json({
    success: true,
    message: 'Đăng xuất thành công'
  });
});

export default router;
