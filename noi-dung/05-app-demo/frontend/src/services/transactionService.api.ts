import apiClient from '../config/apiClient';
import { Transaction } from '../types';

// ============================================================================
// TRANSACTION SERVICE - Real API Only
// ============================================================================

export const TransactionService = {
  /**
   * Lấy tất cả transactions (Admin only)
   */
  getAll: async (): Promise<Transaction[]> => {
    const response = await apiClient.get<{ success: boolean; data: Transaction[] }>('/transactions');
    return response.data.data;
  },

  /**
   * Lấy transactions của user hiện tại
   */
  getByUserId: async (userId: string): Promise<Transaction[]> => {
    const response = await apiClient.get<{ success: boolean; data: Transaction[] }>('/transactions/my');
    return response.data.data;
  },

  /**
   * Lấy transaction theo ID
   */
  getById: async (id: string): Promise<Transaction | null> => {
    try {
      const response = await apiClient.get<{ success: boolean; data: Transaction }>(
        `/transactions/${id}`
      );
      return response.data.data;
    } catch (error: any) {
      if (error.response?.status === 404) {
        return null;
      }
      throw error;
    }
  },

  /**
   * Lấy transactions theo booking ID
   */
  getByBookingId: async (bookingId: string): Promise<Transaction[]> => {
    const response = await apiClient.get<{ success: boolean; data: Transaction[] }>(
      `/transactions/booking/${bookingId}`
    );
    return response.data.data;
  },

  /**
   * Lấy thống kê transactions
   */
  getStatistics: async (startDate: string, endDate: string): Promise<{
    totalTransactions: number;
    totalPayments: number;
    totalRefunds: number;
    netAmount: number;
  }> => {
    const response = await apiClient.get<{
      success: boolean;
      data: {
        totalTransactions: number;
        totalPayments: number;
        totalRefunds: number;
        netAmount: number;
      };
    }>('/transactions/statistics/summary', {
      params: { startDate, endDate },
    });
    return response.data.data;
  },

  /**
   * Tạo transaction (thường được gọi từ BookingService)
   */
  create: async (transactionData: {
    bookingId: string;
    userId: string;
    amount: number;
    method: string;
    type: string;
    status?: string;
    note?: string;
  }): Promise<Transaction> => {
    const response = await apiClient.post<{ success: boolean; data: Transaction }>(
      '/transactions',
      transactionData
    );
    return response.data.data;
  },
};
