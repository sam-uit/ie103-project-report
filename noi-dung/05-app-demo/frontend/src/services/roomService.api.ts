import { Room } from '../types';
import apiClient from '../config/apiClient';
import { mapRoomFromAPI, mapRoomToAPI } from '../utils/mappers';

// ----------------------------------------------------------------------------
// REAL API IMPLEMENTATION
// ----------------------------------------------------------------------------
const ApiRoomService = {
  getAll: async (): Promise<Room[]> => {
    const response = await apiClient.get<{ success: boolean; data: any[] }>('/rooms');
    return response.data.data.map(mapRoomFromAPI);
  },
  
  getById: async (id: string): Promise<Room | null> => {
    try {
      const response = await apiClient.get<{ success: boolean; data: any }>(`/rooms/${id}`);
      return mapRoomFromAPI(response.data.data);
    } catch (error: any) {
      if (error.response?.status === 404) {
        return null;
      }
      throw error;
    }
  },
  
  create: async (room: Omit<Room, 'id'>): Promise<Room> => {
    const apiData = mapRoomToAPI(room);
    const response = await apiClient.post<{ success: boolean; data: any }>('/rooms', apiData);
    return mapRoomFromAPI(response.data.data);
  },
  
  update: async (room: Room): Promise<Room> => {
    const apiData = mapRoomToAPI(room);
    const response = await apiClient.put<{ success: boolean; data: any }>(`/rooms/${room.id}`, apiData);
    return mapRoomFromAPI(response.data.data);
  },
  
  delete: async (id: string): Promise<boolean> => {
    try {
      await apiClient.delete(`/rooms/${id}`);
      return true;
    } catch (error) {
      console.error('Failed to delete room:', error);
      return false;
    }
  }
};

// ----------------------------------------------------------------------------
// EXPORT - Tự động chọn Mock hoặc API dựa vào environment variable
// ----------------------------------------------------------------------------
export const RoomService =  ApiRoomService;
