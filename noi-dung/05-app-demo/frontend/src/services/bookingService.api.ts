import apiClient from '../config/apiClient';
import { Booking } from '../types';
import { mapBookingFromAPI, mapBookingToAPI } from '../utils/mappers';

// ============================================================================
// BOOKING SERVICE - Real API Only
// ============================================================================

export const BookingService = {
  /**
   * Lấy tất cả bookings (Admin only)
   */
  getAll: async (): Promise<Booking[]> => {
    const response = await apiClient.get<{ success: boolean; data: any[] }>('/bookings');
    return response.data.data.map(mapBookingFromAPI);
  },

  /**
   * Lấy bookings của user hiện tại
   */
  getByUser: async (userId: string): Promise<Booking[]> => {
    const response = await apiClient.get<{ success: boolean; data: any[] }>('/bookings/my');
    return response.data.data.map(mapBookingFromAPI);
  },

  /**
   * Lấy booking theo ID
   */
  getById: async (id: string): Promise<Booking | null> => {
    try {
      const response = await apiClient.get<{ success: boolean; data: any }>(`/bookings/${id}`);
      return mapBookingFromAPI(response.data.data);
    } catch (error: any) {
      if (error.response?.status === 404) {
        return null;
      }
      throw error;
    }
  },

  /**
   * Kiểm tra phòng còn trống
   */
  checkAvailability: async (
    roomId: string,
    checkIn: string,
    checkOut: string,
    excludeBookingId?: string
  ): Promise<boolean> => {
    try {
      await apiClient.post('/bookings/check-availability', {
        roomId,
        checkIn,
        checkOut,
        excludeBookingId,
      });
      return true;
    } catch (error) {
      return false;
    }
  },

  /**
   * Tạo booking mới
   */
  create: async (bookingData: {
    roomId: string;
    checkIn: string;
    checkOut: string;
    guests: number;
    specialRequests?: string;
  }): Promise<Booking> => {
    const response = await apiClient.post<{ success: boolean; data: any }>(
      '/bookings',
      bookingData
    );
    return mapBookingFromAPI(response.data.data);
  },

  /**
   * Cập nhật status booking
   */
  updateStatus: async (id: string, status: string): Promise<Booking> => {
    const response = await apiClient.put<{ success: boolean; data: any }>(
      `/bookings/${id}/status`,
      { status }
    );
    return mapBookingFromAPI(response.data.data);
  },

  /**
   * Xử lý thanh toán
   */
  processPayment: async (
    bookingId: string,
    amount: number,
    method: string
  ): Promise<{ transaction: any; message: string }> => {
    const response = await apiClient.post<{
      success: boolean;
      data: { transaction: any; message: string };
    }>(`/bookings/${bookingId}/payment`, {
      amount,
      method,
    });
    return response.data.data;
  },

  /**
   * Xử lý hoàn tiền
   */
  processRefund: async (
    bookingId: string,
    amount?: number,
    note?: string
  ): Promise<{ transaction: any; message: string }> => {
    const response = await apiClient.post<{
      success: boolean;
      data: { transaction: any; message: string };
    }>(`/bookings/${bookingId}/refund`, {
      amount,
      note,
    });
    return response.data.data;
  },
};
