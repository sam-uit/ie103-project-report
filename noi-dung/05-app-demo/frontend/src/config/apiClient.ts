import axios, { AxiosInstance, AxiosError, InternalAxiosRequestConfig } from 'axios';

// ============================================================================
// API CLIENT CONFIGURATION
// ============================================================================

// Base URL từ environment variable hoặc default localhost
export const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000/api';

// Tạo axios instance với cấu hình mặc định
const apiClient: AxiosInstance = axios.create({
  baseURL: API_BASE_URL,
  timeout: 30000, // 30 seconds
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
});

// ============================================================================
// REQUEST INTERCEPTOR - Tự động thêm token vào mỗi request
// ============================================================================
apiClient.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    // Lấy token từ localStorage
    const token = localStorage.getItem('authToken');
    
    if (token && config.headers) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    
    // Log request trong development mode
    if (import.meta.env.DEV) {
      console.log(`🚀 API Request: ${config.method?.toUpperCase()} ${config.url}`, {
        params: config.params,
        data: config.data,
      });
    }
    
    return config;
  },
  (error: AxiosError) => {
    console.error('❌ Request Error:', error);
    return Promise.reject(error);
  }
);

// ============================================================================
// RESPONSE INTERCEPTOR - Xử lý response và error tự động
// ============================================================================
apiClient.interceptors.response.use(
  (response) => {
    // Log response trong development mode
    if (import.meta.env.DEV) {
      console.log(`✅ API Response: ${response.config.method?.toUpperCase()} ${response.config.url}`, {
        status: response.status,
        data: response.data,
      });
    }
    
    return response;
  },
  (error: AxiosError) => {
    // Xử lý các lỗi phổ biến
    if (error.response) {
      const status = error.response.status;
      
      switch (status) {
        case 401:
          // Unauthorized - Token hết hạn hoặc không hợp lệ
          console.error('❌ Unauthorized: Token hết hạn hoặc không hợp lệ');
          localStorage.removeItem('authToken');
          localStorage.removeItem('currentUser');
          // Có thể redirect về trang login
          window.location.href = '/';
          break;
          
        case 403:
          // Forbidden - Không có quyền truy cập
          console.error('❌ Forbidden: Bạn không có quyền thực hiện thao tác này');
          break;
          
        case 404:
          // Not Found
          console.error('❌ Not Found: Không tìm thấy tài nguyên');
          break;
          
        case 422:
          // Validation Error
          console.error('❌ Validation Error:', error.response.data);
          break;
          
        case 500:
          // Server Error
          console.error('❌ Server Error: Lỗi từ phía server');
          break;
          
        default:
          console.error(`❌ Error ${status}:`, error.response.data);
      }
    } else if (error.request) {
      // Request được gửi nhưng không nhận được response
      console.error('❌ Network Error: Không thể kết nối đến server', error.request);
    } else {
      // Lỗi khác
      console.error('❌ Error:', error.message);
    }
    
    return Promise.reject(error);
  }
);

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

/**
 * Lưu auth token vào localStorage
 */
export const setAuthToken = (token: string) => {
  localStorage.setItem('authToken', token);
};

/**
 * Xóa auth token khỏi localStorage
 */
export const clearAuthToken = () => {
  localStorage.removeItem('authToken');
  localStorage.removeItem('currentUser');
};

/**
 * Kiểm tra xem có token hay không
 */
export const hasAuthToken = (): boolean => {
  return !!localStorage.getItem('authToken');
};

export default apiClient;
