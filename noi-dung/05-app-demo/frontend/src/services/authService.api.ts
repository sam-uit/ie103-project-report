import { User } from '../types';
import apiClient, { setAuthToken, clearAuthToken } from '../config/apiClient';


// ----------------------------------------------------------------------------
// REAL API IMPLEMENTATION
// ----------------------------------------------------------------------------
const ApiAuthService = {
  login: async (email: string, password: string): Promise<User | null> => {
    try {
      const response = await apiClient.post<{
        success: boolean;
        data: {
          user: User;
          token: string;
        };
      }>('/auth/login', { email, password });
      
      const { user, token } = response.data.data;
      
      // Lưu token và user info
      setAuthToken(token);
      localStorage.setItem('currentUser', JSON.stringify(user));
      
      return user;
    } catch (error: any) {
      console.error('Login failed:', error.response?.data || error.message);
      return null;
    }
  },
  
  register: async (userData: {
    name: string;
    email: string;
    password: string;
    phone: string;
  }): Promise<User> => {
    const response = await apiClient.post<{
      success: boolean;
      data: {
        user: User;
        token: string;
      };
    }>('/auth/register', userData);
    
    const { user, token } = response.data.data;
    
    // Auto login sau khi đăng ký
    setAuthToken(token);
    localStorage.setItem('currentUser', JSON.stringify(user));
    
    return user;
  },
  
  getCurrentUser: async (): Promise<User | null> => {
    try {
      const response = await apiClient.get<{
        success: boolean;
        data: User;
      }>('/auth/me');
      
      const user = response.data.data;
      localStorage.setItem('currentUser', JSON.stringify(user));
      
      return user;
    } catch (error) {
      // Nếu token hết hạn hoặc không hợp lệ
      clearAuthToken();
      return null;
    }
  },
  
  logout: async (): Promise<void> => {
    try {
      await apiClient.post('/auth/logout');
    } catch (error) {
      console.error('Logout error:', error);
    } finally {
      clearAuthToken();
    }
  }
};

// ----------------------------------------------------------------------------
// EXPORT - Tự động chọn Mock hoặc API dựa vào environment variable
// ----------------------------------------------------------------------------
export const AuthService = ApiAuthService;
