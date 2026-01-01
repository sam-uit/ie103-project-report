import { AuthAdapter } from '../adapters/AuthAdapter.js';

// ============================================================================
// AUTHENTICATION MIDDLEWARE
// ============================================================================

/**
 * Verify JWT token từ Authorization header
 */
export const authenticate = async (req, res, next) => {
  try {
    // Lấy token từ header
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        error: {
          code: 'UNAUTHORIZED',
          message: 'Token không hợp lệ hoặc không tồn tại'
        }
      });
    }
    
    const token = authHeader.substring(7); // Remove 'Bearer '
    
    // Verify token
    const decoded = AuthAdapter.verifyToken(token);
    
    if (!decoded) {
      return res.status(401).json({
        success: false,
        error: {
          code: 'TOKEN_INVALID',
          message: 'Token không hợp lệ hoặc đã hết hạn'
        }
      });
    }
    
    // Lấy thông tin user
    const user = await AuthAdapter.getCurrentUser(decoded.id);
    
    if (!user) {
      return res.status(401).json({
        success: false,
        error: {
          code: 'USER_NOT_FOUND',
          message: 'Không tìm thấy user'
        }
      });
    }
    
    // Attach user to request
    req.user = user;
    next();
  } catch (error) {
    console.error('Authentication Error:', error);
    return res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: 'Lỗi xác thực'
      }
    });
  }
};

/**
 * Kiểm tra role ADMIN
 */
export const requireAdmin = (req, res, next) => {
  if (req.user.role !== 'ADMIN') {
    return res.status(403).json({
      success: false,
      error: {
        code: 'FORBIDDEN',
        message: 'Bạn không có quyền thực hiện thao tác này'
      }
    });
  }
  next();
};

/**
 * Kiểm tra role USER hoặc ADMIN
 */
export const requireUser = (req, res, next) => {
  if (!['USER', 'ADMIN'].includes(req.user.role)) {
    return res.status(403).json({
      success: false,
      error: {
        code: 'FORBIDDEN',
        message: 'Bạn không có quyền thực hiện thao tác này'
      }
    });
  }
  next();
};
