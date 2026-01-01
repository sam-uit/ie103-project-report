// ============================================================================
// DATA MAPPERS - Backend to Frontend field mapping
// ============================================================================

import type { Room, Booking } from '../types';

/**
 * Map Room data from backend to frontend format
 */
export const mapRoomFromAPI = (apiRoom: any): Room => {
  return {
    id: apiRoom.id || '',
    name: apiRoom.name || 'N/A',
    type: apiRoom.type || 'N/A',
    price: apiRoom.price || 0,
    capacity: apiRoom.capacity || 0,
    description: apiRoom.description || 'N/A',
    image: apiRoom.imageUrl || apiRoom.image || 'https://via.placeholder.com/400x300?text=No+Image',
    status: apiRoom.status || 'AVAILABLE'
  };
};

/**
 * Map Room data from frontend to backend format
 */
export const mapRoomToAPI = (room: Partial<Room>): any => {
  return {
    id: room.id,
    name: room.name,
    type: room.type,
    price: room.price,
    capacity: room.capacity,
    description: room.description,
    imageUrl: room.image, // FE 'image' -> BE 'imageUrl'
    status: room.status
  };
};

/**
 * Map Booking data from backend to frontend format
 */
export const mapBookingFromAPI = (apiBooking: any): Booking => {
  return {
    id: apiBooking.id || '',
    roomId: apiBooking.roomId || '',
    userId: apiBooking.userId || '',
    checkIn: apiBooking.checkIn || '',
    checkOut: apiBooking.checkOut || '',
    totalPrice: apiBooking.totalAmount || apiBooking.totalPrice || 0, // BE 'totalAmount' -> FE 'totalPrice'
    status: apiBooking.status || 'PENDING',
    paymentStatus: apiBooking.paymentStatus || 'UNPAID',
    createdAt: apiBooking.createdAt || new Date().toISOString(),
    guestName: apiBooking.guestName || apiBooking.userName || 'N/A',
    notes: apiBooking.notes || apiBooking.specialRequests || ''
  };
};

/**
 * Map Booking data from frontend to backend format
 */
export const mapBookingToAPI = (booking: Partial<Booking>): any => {
  return {
    id: booking.id,
    roomId: booking.roomId,
    userId: booking.userId,
    checkIn: booking.checkIn,
    checkOut: booking.checkOut,
    totalAmount: booking.totalPrice, // FE 'totalPrice' -> BE 'totalAmount'
    status: booking.status,
    paymentStatus: booking.paymentStatus,
    specialRequests: booking.notes
  };
};
