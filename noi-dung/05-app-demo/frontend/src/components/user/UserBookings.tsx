import React, { useState, useEffect } from 'react';
import { XCircle, CheckCircle, Calendar } from 'lucide-react';
import { Room, User, Booking } from '../../types';
import { Button, Badge } from '../ui/Button';
import { formatCurrency, formatDate } from '../../utils/helpers';
import { validateDateRange } from '../../utils/validation';
import { BookingService, RoomService } from '../../services/services';
import { PaymentGatewayModal } from '../modals/PaymentModals';
import { toast } from '../ui/Toast';

interface BookingModalProps {
  room: Room;
  user: User | null;
  onClose: () => void;
  onSuccess: () => void;
}

export const BookingModal = ({ room, user, onClose, onSuccess }: BookingModalProps) => {
  const [checkIn, setCheckIn] = useState('');
  const [checkOut, setCheckOut] = useState('');
  const [step, setStep] = useState(1); 
  const [newBooking, setNewBooking] = useState<Booking | null>(null);
  const [showPayment, setShowPayment] = useState(false);
  const [error, setError] = useState(''); 

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    if (!user) { 
      setError("Vui lòng đăng nhập (chọn Khách/Admin ở menu) để đặt phòng!"); 
      toast.error("Vui lòng đăng nhập để đặt phòng!");
      return; 
    }
    
    // Validate date range
    const dateValidation = validateDateRange(checkIn, checkOut);
    if (!dateValidation.valid) {
      setError(dateValidation.error || '');
      toast.error(dateValidation.error || 'Ngày không hợp lệ');
      return;
    }

    // Check room availability
    const isAvailable = await BookingService.checkAvailability(room.id, checkIn, checkOut);
    if (!isAvailable) {
      setError("Phòng đã được đặt trong khoảng thời gian này. Vui lòng chọn ngày khác.");
      toast.error("Phòng không còn trống trong thời gian này!");
      return;
    }

    const start = new Date(checkIn);
    const end = new Date(checkOut);
    const diffTime = Math.abs(end.getTime() - start.getTime());
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
    
    const booking: Booking = {
      id: `B${Date.now()}`, 
      roomId: room.id, 
      userId: user.id,
      checkIn, 
      checkOut, 
      totalPrice: diffDays * room.price,
      status: 'PENDING', 
      paymentStatus: 'UNPAID',
      createdAt: new Date().toISOString(), 
      guestName: user.name
    };

    await BookingService.create(booking);
    setNewBooking(booking);
    setStep(2);
    toast.success("Đặt phòng thành công!");
  };

  const handleSkipPayment = () => {
    onSuccess();
    toast.info("Đặt phòng thành công! Vui lòng thanh toán sau.");
  };

  if (showPayment && newBooking) {
    return (
      <PaymentGatewayModal 
        booking={newBooking} 
        onClose={handleSkipPayment} 
        onSuccess={() => { 
          onSuccess(); 
          toast.success("Đặt phòng & Thanh toán thành công!"); 
        }} 
      />
    );
  }

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4 backdrop-blur-sm">
      <div className="bg-white rounded-2xl w-full max-w-md overflow-hidden shadow-2xl animate-in zoom-in duration-200">
        <div className="p-6 border-b flex justify-between items-center">
          <h2 className="text-xl font-bold text-gray-800">
            {step === 1 ? 'Thông tin đặt phòng' : 'Xác nhận & Thanh toán'}
          </h2>
          <button onClick={onClose}>
            <XCircle size={24} className="text-gray-400 hover:text-gray-600"/>
          </button>
        </div>
        
        {step === 1 ? (
          <form onSubmit={handleSubmit} className="p-6 space-y-4">
            <div className="flex gap-4 mb-4">
              <img src={room.image} className="w-20 h-20 rounded-lg object-cover" alt={room.name} />
              <div>
                <h3 className="font-bold">{room.name}</h3>
                <p className="text-blue-600 font-bold">{formatCurrency(room.price)} / đêm</p>
              </div>
            </div>

            {error && (
              <div className="bg-red-50 text-red-600 text-sm p-3 rounded-lg flex items-center gap-2">
                <XCircle size={16} /> {error}
              </div>
            )}
            {!user && !error && (
              <div className="bg-yellow-50 text-yellow-700 text-sm p-3 rounded-lg">
                Bạn đang xem với tư cách khách vãng lai. Vui lòng đăng nhập để tiếp tục.
              </div>
            )}

            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm mb-1 font-medium text-gray-700">Check-in</label>
                <input 
                  type="date" 
                  required 
                  className="w-full p-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none" 
                  onChange={e => setCheckIn(e.target.value)} 
                />
              </div>
              <div>
                <label className="block text-sm mb-1 font-medium text-gray-700">Check-out</label>
                <input 
                  type="date" 
                  required 
                  className="w-full p-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none" 
                  onChange={e => setCheckOut(e.target.value)} 
                />
              </div>
            </div>

            {checkIn && checkOut && new Date(checkIn) < new Date(checkOut) && (
              <div className="flex justify-between items-center bg-gray-50 p-3 rounded-lg text-sm">
                <span className="text-gray-600">
                  Tạm tính ({Math.ceil(Math.abs(new Date(checkOut).getTime() - new Date(checkIn).getTime()) / (1000 * 60 * 60 * 24))} đêm):
                </span>
                <span className="font-bold text-blue-600 text-lg">
                  {formatCurrency(Math.ceil(Math.abs(new Date(checkOut).getTime() - new Date(checkIn).getTime()) / (1000 * 60 * 60 * 24)) * room.price)}
                </span>
              </div>
            )}

            <Button type="submit" className="w-full mt-4">Tiếp tục</Button>
          </form>
        ) : (
          <div className="p-6 text-center space-y-4">
            <div className="w-16 h-16 bg-green-100 text-green-600 rounded-full flex items-center justify-center mx-auto">
              <CheckCircle size={32}/>
            </div>
            <h3 className="text-xl font-bold">Đặt phòng thành công!</h3>
            <p className="text-gray-500">Bạn có muốn thanh toán ngay để được xác nhận tự động không?</p>
            <div className="flex flex-col gap-3 pt-2">
              <Button 
                onClick={() => setShowPayment(true)} 
                className="w-full bg-blue-600 hover:bg-blue-700"
              >
                Thanh toán ngay ({formatCurrency(newBooking?.totalPrice || 0)})
              </Button>
              <Button onClick={handleSkipPayment} variant="ghost" className="w-full">
                Thanh toán sau
              </Button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

interface UserBookingsListProps {
  userId: string;
}

export const UserBookingsList = ({ userId }: UserBookingsListProps) => {
  const [myBookings, setMyBookings] = useState<Booking[]>([]);
  const [rooms, setRooms] = useState<Room[]>([]);
  const [payingBooking, setPayingBooking] = useState<Booking | null>(null);
  const [filter, setFilter] = useState<'all' | 'upcoming' | 'past'>('all');

  useEffect(() => { 
    loadData(); 
  }, [userId]);

  const loadData = async () => {
    const [bookings, roomsData] = await Promise.all([
      BookingService.getByUser(userId),
      RoomService.getAll()
    ]);
    setMyBookings(bookings);
    setRooms(roomsData);
  };

  const getDayCount = (checkIn: string, checkOut: string) => {
    const start = new Date(checkIn);
    const end = new Date(checkOut);
    const diffTime = Math.abs(end.getTime() - start.getTime());
    return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  };

  const filteredBookings = myBookings.filter(booking => {
    if (filter === 'all') return true;
    const checkOut = new Date(booking.checkOut);
    const today = new Date();
    if (filter === 'upcoming') return checkOut >= today;
    if (filter === 'past') return checkOut < today;
    return true;
  });

  return (
    <div className="space-y-6">
      {/* Header with filters */}
      <div className="bg-gradient-to-r from-blue-500 to-blue-600 rounded-2xl p-6 text-white shadow-lg">
        <h2 className="text-2xl font-bold mb-4">Đơn đặt phòng của tôi</h2>
        <div className="flex gap-2">
          <button
            onClick={() => setFilter('all')}
            className={`px-4 py-2 rounded-lg text-sm font-medium transition-all ${
              filter === 'all' 
                ? 'bg-white text-blue-600 shadow-md' 
                : 'bg-blue-600/50 hover:bg-blue-600/70 text-white'
            }`}
          >
            Tất cả ({myBookings.length})
          </button>
          <button
            onClick={() => setFilter('upcoming')}
            className={`px-4 py-2 rounded-lg text-sm font-medium transition-all ${
              filter === 'upcoming' 
                ? 'bg-white text-blue-600 shadow-md' 
                : 'bg-blue-600/50 hover:bg-blue-600/70 text-white'
            }`}
          >
            Sắp tới
          </button>
          <button
            onClick={() => setFilter('past')}
            className={`px-4 py-2 rounded-lg text-sm font-medium transition-all ${
              filter === 'past' 
                ? 'bg-white text-blue-600 shadow-md' 
                : 'bg-blue-600/50 hover:bg-blue-600/70 text-white'
            }`}
          >
            Đã qua
          </button>
        </div>
      </div>

      {/* Bookings list */}
      <div className="space-y-4">
        {filteredBookings.map(booking => {
          const room = rooms.find(r => r.id === booking.roomId);
          const dayCount = getDayCount(booking.checkIn, booking.checkOut);
          
          return (
            <div 
              key={booking.id} 
              className="bg-white rounded-2xl border border-gray-200 shadow-sm hover:shadow-md transition-shadow overflow-hidden"
            >
              <div className="flex flex-col md:flex-row">
                {/* Room Image */}
                <div className="md:w-48 h-48 md:h-auto flex-shrink-0">
                  <img 
                    src={room?.image || 'https://via.placeholder.com/400x300?text=No+Image'} 
                    alt={room?.name || 'Room'} 
                    className="w-full h-full object-cover"
                  />
                </div>

                {/* Booking Details */}
                <div className="flex-1 p-5">
                  <div className="flex flex-col md:flex-row md:items-start md:justify-between gap-4">
                    {/* Left side - Room & Booking Info */}
                    <div className="flex-1">
                      <div className="flex items-start justify-between mb-2">
                        <div>
                          <h3 className="text-lg font-bold text-gray-900 mb-1">
                            {room?.name || 'N/A'}
                          </h3>
                          <p className="text-sm text-gray-500">
                            Mã đơn: <span className="font-medium text-gray-700">#{booking.id}</span>
                          </p>
                        </div>
                      </div>

                      {/* Check-in/out dates */}
                      <div className="grid grid-cols-2 gap-4 mt-4 bg-gray-50 rounded-lg p-3">
                        <div>
                          <p className="text-xs text-gray-500 mb-1">Check-in</p>
                          <p className="font-semibold text-gray-900">{formatDate(booking.checkIn, 'medium')}</p>
                        </div>
                        <div>
                          <p className="text-xs text-gray-500 mb-1">Check-out</p>
                          <p className="font-semibold text-gray-900">{formatDate(booking.checkOut, 'medium')}</p>
                        </div>
                      </div>

                      {/* Additional Info */}
                      <div className="mt-3 flex flex-wrap gap-2 text-sm text-gray-600">
                        <span className="flex items-center gap-1">
                          <Calendar size={14} />
                          {dayCount} đêm
                        </span>
                        {room?.type && (
                          <span className="px-2 py-1 bg-blue-50 text-blue-700 rounded-md text-xs font-medium">
                            {room.type}
                          </span>
                        )}
                      </div>
                    </div>

                    {/* Right side - Price & Status */}
                    <div className="flex flex-col items-end gap-3 min-w-[180px]">
                      <div className="text-right">
                        <p className="text-xs text-gray-500 mb-1">Tổng tiền</p>
                        <p className="text-2xl font-bold text-blue-600">
                          {formatCurrency(booking.totalPrice)}
                        </p>
                      </div>

                      {/* Status badges */}
                      <div className="flex flex-wrap gap-2 justify-end">
                        <Badge status={booking.status} />
                        <Badge status={booking.paymentStatus} />
                      </div>

                      {/* Payment button */}
                      {booking.paymentStatus === 'UNPAID' && 
                       booking.status !== 'CANCELLED' && 
                       booking.status !== 'REJECTED' && (
                        <Button 
                          size="sm" 
                          onClick={() => setPayingBooking(booking)}
                          className="w-full bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 shadow-md"
                        >
                          Thanh toán ngay
                        </Button>
                      )}
                    </div>
                  </div>

                  {/* Notes section */}
                  {booking.notes && (
                    <div className="mt-4 pt-4 border-t border-gray-100">
                      <p className="text-xs text-gray-500 mb-1">Ghi chú</p>
                      <p className="text-sm text-gray-700">{booking.notes}</p>
                    </div>
                  )}
                </div>
              </div>
            </div>
          );
        })}
      </div>

      {/* Payment Modal */}
      {payingBooking && (
        <PaymentGatewayModal 
          booking={payingBooking} 
          onClose={() => setPayingBooking(null)} 
          onSuccess={() => { 
            setPayingBooking(null); 
            loadData(); 
          }} 
        />
      )}

      {/* Empty state */}
      {filteredBookings.length === 0 && (
        <div className="text-center py-16 bg-white rounded-2xl border-2 border-dashed border-gray-200">
          <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <Calendar size={32} className="text-gray-400" />
          </div>
          <h3 className="text-lg font-semibold text-gray-900 mb-2">
            {filter === 'all' ? 'Chưa có đơn đặt phòng' : 
             filter === 'upcoming' ? 'Không có đơn sắp tới' : 
             'Không có đơn đã qua'}
          </h3>
          <p className="text-gray-500 text-sm">
            {filter === 'all' ? 'Hãy đặt phòng đầu tiên của bạn!' : 
             'Thử chọn bộ lọc khác để xem các đơn đặt phòng.'}
          </p>
        </div>
      )}
    </div>
  );
};
