import { useState, useMemo } from 'react';
import { Search, Eye, X, List, User, BedDouble, Calendar, DollarSign, LogOut, CheckCircle, XCircle, Clock, Filter } from 'lucide-react';
import { Booking, BookingStatus, Room } from '../../types';
import { Button, Badge } from '../ui/Button';
import { formatCurrency, formatDate, formatDateTime } from '../../utils/helpers';
import { RefundConfirmModal } from '../modals/PaymentModals';
import { toast } from '../ui/Toast';

interface AdminBookingManagerProps {
  bookings: Booking[];
  rooms: Room[];
  onStatusUpdate: (id: string, status: BookingStatus) => Promise<void>;
  onRefund: (id: string, amount: number) => Promise<void>;
}

export const AdminBookingManager = ({ 
  bookings, 
  rooms, 
  onStatusUpdate, 
  onRefund 
}: AdminBookingManagerProps) => {
  const [filterStatus, setFilterStatus] = useState<BookingStatus | 'ALL'>('ALL');
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedBooking, setSelectedBooking] = useState<Booking | null>(null);
  const [refundTarget, setRefundTarget] = useState<Booking | null>(null);
  const [processingId, setProcessingId] = useState<string | null>(null);
  const [viewMode, setViewMode] = useState<'table' | 'card'>('card');

  const filteredBookings = useMemo(() => {
    return bookings.filter(b => {
      const matchStatus = filterStatus === 'ALL' || b.status === filterStatus;
      const matchSearch = b.guestName?.toLowerCase().includes(searchTerm.toLowerCase()) || 
                          b.id.toLowerCase().includes(searchTerm.toLowerCase());
      return matchStatus && matchSearch;
    }).sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
  }, [bookings, filterStatus, searchTerm]);

  // Statistics
  const stats = useMemo(() => {
    const pending = bookings.filter(b => b.status === 'PENDING').length;
    const confirmed = bookings.filter(b => b.status === 'CONFIRMED').length;
    const checkedIn = bookings.filter(b => b.status === 'CHECKED_IN').length;
    const totalRevenue = bookings
      .filter(b => b.paymentStatus === 'PAID' && b.status !== 'CANCELLED')
      .reduce((sum, b) => sum + b.totalPrice, 0);
    
    return { pending, confirmed, checkedIn, totalRevenue };
  }, [bookings]);

  const handleAction = async (id: string, action: BookingStatus) => {
    setProcessingId(id);
    if (action === 'CANCELLED' || action === 'REJECTED') {
      const target = bookings.find(b => b.id === id);
      if (target && target.paymentStatus === 'PAID') {
        setProcessingId(null);
        setRefundTarget(target); 
        return;
      }
    }
    try {
      await onStatusUpdate(id, action);
      if (selectedBooking && selectedBooking.id === id) {
        const updated = bookings.find(b => b.id === id);
        if (updated) setSelectedBooking({...updated, status: action});
      }
      const statusMessages: Record<BookingStatus, string> = {
        'PENDING': 'Đã chuyển về trạng thái chờ xử lý',
        'CONFIRMED': 'Đã xác nhận đặt phòng',
        'CHECKED_IN': 'Đã nhận phòng',
        'CHECKED_OUT': 'Đã trả phòng',
        'CANCELLED': 'Đã hủy đặt phòng',
        'REJECTED': 'Đã từ chối đặt phòng'
      };
      toast.success(statusMessages[action] || 'Cập nhật trạng thái thành công');
    } catch (error) {
      toast.error('Không thể cập nhật trạng thái. Vui lòng thử lại.');
      console.error('Error updating booking status:', error);
    } finally {
      setProcessingId(null);
    }
  };

  const handleRefundConfirm = async () => {
    if (refundTarget) {
      await onRefund(refundTarget.id, refundTarget.totalPrice);
      setRefundTarget(null);
      if (selectedBooking && selectedBooking.id === refundTarget.id) {
        setSelectedBooking(null);
      }
    }
  };

  return (
    <div className="space-y-6">
      {/* Statistics Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="bg-gradient-to-br from-yellow-50 to-yellow-100 border border-yellow-200 rounded-xl p-4 shadow-sm">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-xs font-bold text-yellow-700 uppercase mb-1">Chờ duyệt</p>
              <p className="text-2xl font-bold text-yellow-800">{stats.pending}</p>
            </div>
            <div className="w-12 h-12 bg-yellow-200 rounded-full flex items-center justify-center">
              <Clock size={24} className="text-yellow-700" />
            </div>
          </div>
        </div>

        <div className="bg-gradient-to-br from-blue-50 to-blue-100 border border-blue-200 rounded-xl p-4 shadow-sm">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-xs font-bold text-blue-700 uppercase mb-1">Đã xác nhận</p>
              <p className="text-2xl font-bold text-blue-800">{stats.confirmed}</p>
            </div>
            <div className="w-12 h-12 bg-blue-200 rounded-full flex items-center justify-center">
              <CheckCircle size={24} className="text-blue-700" />
            </div>
          </div>
        </div>

        <div className="bg-gradient-to-br from-green-50 to-green-100 border border-green-200 rounded-xl p-4 shadow-sm">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-xs font-bold text-green-700 uppercase mb-1">Đang ở</p>
              <p className="text-2xl font-bold text-green-800">{stats.checkedIn}</p>
            </div>
            <div className="w-12 h-12 bg-green-200 rounded-full flex items-center justify-center">
              <BedDouble size={24} className="text-green-700" />
            </div>
          </div>
        </div>

        <div className="bg-gradient-to-br from-purple-50 to-purple-100 border border-purple-200 rounded-xl p-4 shadow-sm">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-xs font-bold text-purple-700 uppercase mb-1">Doanh thu</p>
              <p className="text-lg font-bold text-purple-800">{formatCurrency(stats.totalRevenue)}</p>
            </div>
            <div className="w-12 h-12 bg-purple-200 rounded-full flex items-center justify-center">
              <DollarSign size={24} className="text-purple-700" />
            </div>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
        {/* Header with filters */}
        <div className="p-4 border-b border-gray-200 bg-gradient-to-r from-gray-50 to-white">
          <div className="flex flex-col lg:flex-row gap-4 justify-between items-start lg:items-center">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                <List size={20} className="text-blue-600" />
              </div>
              <div>
                <h3 className="font-bold text-gray-800">Quản lý đặt phòng</h3>
                <p className="text-xs text-gray-500">{filteredBookings.length} đơn đặt phòng</p>
              </div>
            </div>

            <div className="flex flex-col sm:flex-row gap-3 w-full lg:w-auto">
              <div className="relative flex-1 lg:w-64">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" size={16} />
                <input 
                  type="text" 
                  placeholder="Tìm tên khách, mã đơn..." 
                  className="w-full pl-9 pr-4 py-2 text-sm border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" 
                  value={searchTerm} 
                  onChange={e => setSearchTerm(e.target.value)} 
                />
              </div>

              <div className="flex gap-2 bg-gray-100 p-1 rounded-lg">
                <button
                  onClick={() => setViewMode('card')}
                  className={`px-3 py-1.5 rounded-md text-xs font-medium transition-all ${
                    viewMode === 'card' ? 'bg-white shadow-sm text-blue-600' : 'text-gray-600'
                  }`}
                >
                  Cards
                </button>
                <button
                  onClick={() => setViewMode('table')}
                  className={`px-3 py-1.5 rounded-md text-xs font-medium transition-all ${
                    viewMode === 'table' ? 'bg-white shadow-sm text-blue-600' : 'text-gray-600'
                  }`}
                >
                  Table
                </button>
              </div>
            </div>
          </div>

          {/* Status Filters */}
          <div className="flex gap-2 overflow-x-auto pb-2 mt-4 hide-scrollbar">
            {[
              { key: 'ALL', label: 'Tất cả', color: 'gray' },
              { key: 'PENDING', label: 'Chờ duyệt', color: 'yellow' },
              { key: 'CONFIRMED', label: 'Đã xác nhận', color: 'blue' },
              { key: 'CHECKED_IN', label: 'Đang ở', color: 'green' },
              { key: 'CHECKED_OUT', label: 'Đã trả', color: 'purple' },
            ].map(({ key, label, color }) => (
              <button 
                key={key} 
                onClick={() => setFilterStatus(key as BookingStatus | 'ALL')} 
                className={`px-4 py-2 rounded-lg text-xs font-medium whitespace-nowrap transition-all ${
                  filterStatus === key 
                    ? `bg-${color}-600 text-white shadow-md` 
                    : `bg-${color}-50 text-${color}-700 hover:bg-${color}-100 border border-${color}-200`
                }`}
              >
                {label}
              </button>
            ))}
          </div>
        </div>

        {/* Content Area */}
        {viewMode === 'card' ? (
          <div className="p-4 space-y-3 max-h-[600px] overflow-y-auto">
            {filteredBookings.length === 0 ? (
              <div className="text-center py-16 text-gray-400">
                <Filter size={48} className="mx-auto mb-4 opacity-50" />
                <p className="text-lg font-medium">Không tìm thấy đơn đặt phòng</p>
                <p className="text-sm">Thử thay đổi bộ lọc hoặc tìm kiếm</p>
              </div>
            ) : (
              filteredBookings.map(booking => {
                const room = rooms.find(r => r.id === booking.roomId);
                return (
                  <div 
                    key={booking.id} 
                    className="bg-white border border-gray-200 rounded-lg hover:shadow-md transition-all cursor-pointer group"
                    onClick={() => setSelectedBooking(booking)}
                  >
                    <div className="flex gap-4 p-4">
                      {/* Room Image */}
                      <div className="w-28 h-28 rounded-xl overflow-hidden flex-shrink-0 relative shadow-sm">
                        <img 
                          src={room?.image || 'https://via.placeholder.com/200x200?text=Room'} 
                          alt={room?.name} 
                          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                        />
                      </div>

                      {/* Main Content */}
                      <div className="flex-1 min-w-0 flex flex-col justify-between">
                        {/* Top Section: Title + Badges */}
                        <div>
                          <div className="flex items-start justify-between gap-3 mb-2">
                            <div className="flex-1 min-w-0">
                              <h4 className="font-bold text-base text-gray-900 truncate group-hover:text-blue-600 transition-colors mb-1">
                                {room?.name || 'N/A'}
                              </h4>
                              <p className="text-xs text-gray-500">
                                <span className="font-mono">#{booking.id}</span>
                                <span className="mx-1.5">•</span>
                                <span className="font-medium">{booking.guestName}</span>
                              </p>
                            </div>
                          </div>
                          
                          {/* Status Badges */}
                          <div className="flex gap-2 mb-3">
                            <Badge status={booking.status} />
                            <Badge status={booking.paymentStatus} />
                          </div>
                        </div>

                        {/* Bottom Section: Date + Time */}
                        <div className="flex items-center gap-3 text-xs">
                          <div className="flex items-center gap-1.5 bg-gradient-to-r from-blue-50 to-blue-100 px-3 py-1.5 rounded-lg border border-blue-200">
                            <Calendar size={13} className="text-blue-600 flex-shrink-0" />
                            <div>
                              <span className="font-semibold text-blue-800">Nhận:</span>
                              <span className="ml-1 text-gray-700 font-medium">{formatDate(booking.checkIn, 'short')}</span>
                              <span className="ml-1.5 text-blue-600 font-bold">14:00</span>
                            </div>
                          </div>
                          <div className="flex items-center gap-1.5 bg-gradient-to-r from-orange-50 to-orange-100 px-3 py-1.5 rounded-lg border border-orange-200">
                            <Calendar size={13} className="text-orange-600 flex-shrink-0" />
                            <div>
                              <span className="font-semibold text-orange-800">Trả:</span>
                              <span className="ml-1 text-gray-700 font-medium">{formatDate(booking.checkOut, 'short')}</span>
                              <span className="ml-1.5 text-orange-600 font-bold">12:00</span>
                            </div>
                          </div>
                        </div>
                      </div>

                      {/* Right Section: Price + Actions */}
                      <div className="flex flex-col items-end justify-between gap-2 min-w-[140px]">
                        {/* Price at Top */}
                        <div className="bg-gradient-to-br from-red-500 to-blue-600 text-white px-4 py-2 rounded-xl shadow-md">
                          <p className="text-xs font-medium opacity-90 mb-0.5">Tổng tiền</p>
                          <p className="text-xl font-bold tracking-tight">
                            {formatCurrency(booking.totalPrice)}
                          </p>
                        </div>

                        {/* Action Buttons at Bottom */}
                        <div className="flex flex-col gap-1.5 w-full">
                          {booking.status === 'PENDING' && (
                            <>
                              <Button 
                                size="sm" 
                                variant="success"
                                onClick={(e) => {
                                  e.stopPropagation();
                                  handleAction(booking.id, 'CONFIRMED');
                                }}
                                isLoading={processingId === booking.id}
                                className="text-xs py-2 px-3 whitespace-nowrap w-full justify-center font-semibold"
                              >
                                <CheckCircle size={14} className="mr-1.5" />
                                Duyệt
                              </Button>
                              <Button 
                                size="sm" 
                                variant="danger"
                                onClick={(e) => {
                                  e.stopPropagation();
                                  handleAction(booking.id, 'REJECTED');
                                }}
                                isLoading={processingId === booking.id}
                                className="text-xs py-2 px-3 whitespace-nowrap w-full justify-center font-semibold"
                              >
                                <XCircle size={14} className="mr-1.5" />
                                Từ chối
                              </Button>
                            </>
                          )}
                          {booking.status === 'CONFIRMED' && (
                            <Button 
                              size="sm" 
                              variant="primary"
                              onClick={(e) => {
                                e.stopPropagation();
                                handleAction(booking.id, 'CHECKED_IN');
                              }}
                              isLoading={processingId === booking.id}
                              className="text-xs py-2 px-3 whitespace-nowrap w-full justify-center font-semibold"
                            >
                              <CheckCircle size={14} className="mr-1.5" />
                              Check-in
                            </Button>
                          )}
                          {booking.status === 'CHECKED_IN' && (
                            <Button 
                              size="sm" 
                              variant="secondary"
                              onClick={(e) => {
                                e.stopPropagation();
                                handleAction(booking.id, 'CHECKED_OUT');
                              }}
                              isLoading={processingId === booking.id}
                              className="text-xs py-2 px-3 whitespace-nowrap w-full justify-center font-semibold"
                            >
                              <LogOut size={14} className="mr-1.5" />
                              Check-out
                            </Button>
                          )}
                          <Button 
                            size="sm" 
                            variant="outline"
                            onClick={(e) => {
                              e.stopPropagation();
                              setSelectedBooking(booking);
                            }}
                            className="py-2 px-3 w-full justify-center"
                          >
                            <Eye size={14} className="mr-1.5" />
                            <span className="text-xs font-medium">Chi tiết</span>
                          </Button>
                        </div>
                      </div>
                    </div>
                  </div>
                );
              })
            )}
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left">
          <thead className="bg-gray-50 border-b border-gray-200 text-xs font-bold text-gray-500 uppercase">
            <tr>
              <th className="p-4">Mã</th>
              <th className="p-4">Khách hàng</th>
              <th className="p-4">Phòng</th>
              <th className="p-4 text-center">Trạng thái</th>
              <th className="p-4 text-center">Thanh toán</th>
              <th className="p-4 text-right">Tổng tiền</th>
              <th className="p-4 text-right">Thao tác</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {filteredBookings.map(booking => (
              <tr key={booking.id} className="hover:bg-blue-50/30 transition-colors">
                <td className="p-4 text-xs font-mono text-gray-500">#{booking.id}</td>
                <td className="p-4">
                  <div className="font-medium text-sm">{booking.guestName}</div>
                  <div className="text-xs text-gray-400">{formatDate(booking.checkIn)} → {formatDate(booking.checkOut)}</div>
                </td>
                <td className="p-4 text-sm text-blue-600 font-medium">
                  {rooms.find(r => r.id === booking.roomId)?.name || booking.roomId}
                </td>
                <td className="p-4 text-center"><Badge status={booking.status} /></td>
                <td className="p-4 text-center"><Badge status={booking.paymentStatus} /></td>
                <td className="p-4 text-right font-semibold text-gray-800">{formatCurrency(booking.totalPrice)}</td>
                <td className="p-4 text-right">
                  <button 
                    onClick={() => setSelectedBooking(booking)} 
                    className="p-2 text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
                  >
                    <Eye size={18}/>
                  </button>
                </td>
              </tr>
            ))}
            {filteredBookings.length === 0 && (
              <tr>
                <td colSpan={7} className="p-12 text-center text-gray-400">
                  <Filter size={48} className="mx-auto mb-4 opacity-50" />
                  <p className="text-lg font-medium">Không tìm thấy đơn đặt phòng</p>
                  <p className="text-sm">Thử thay đổi bộ lọc hoặc tìm kiếm</p>
                </td>
              </tr>
            )}
          </tbody>
        </table>
          </div>
        )}
      </div>

      {/* Detail Modal */}
      {selectedBooking && (
        <div className="fixed inset-0 bg-black/60 z-50 flex items-center justify-center p-4 backdrop-blur-sm">
          <div className="bg-white rounded-2xl shadow-2xl w-full max-w-2xl overflow-hidden animate-in fade-in zoom-in">
            {/* Modal Header */}
            <div className="bg-gradient-to-r from-blue-600 to-blue-700 p-6 text-white">
              <div className="flex justify-between items-start">
                <div>
                  <h3 className="text-xl font-bold mb-1 flex items-center gap-2">
                    <List size={20} /> Chi tiết đơn đặt phòng
                  </h3>
                  <p className="text-blue-100 text-sm font-mono">#{selectedBooking.id}</p>
                </div>
                <button 
                  onClick={() => setSelectedBooking(null)} 
                  className="text-white/80 hover:text-white bg-white/10 hover:bg-white/20 rounded-lg p-2 transition-colors"
                >
                  <X size={20}/>
                </button>
              </div>
            </div>
            
            <div className="p-6 space-y-6 max-h-[70vh] overflow-y-auto">
              {/* Guest Info */}
              <div className="flex items-start gap-4 bg-gradient-to-r from-gray-50 to-white p-4 rounded-xl border border-gray-100">
                <div className="w-14 h-14 bg-gradient-to-br from-blue-500 to-blue-600 rounded-full flex items-center justify-center text-white shadow-md">
                  <User size={28} />
                </div>
                <div className="flex-1">
                  <h4 className="font-bold text-gray-900 text-lg mb-1">{selectedBooking.guestName}</h4>
                  <p className="text-sm text-gray-500 mb-3">User ID: {selectedBooking.userId}</p>
                  <div className="flex gap-2">
                    <Badge status={selectedBooking.status} />
                    <Badge status={selectedBooking.paymentStatus} />
                  </div>
                </div>
              </div>

              {/* Room Info with Image */}
              <div className="bg-white border border-gray-200 rounded-xl overflow-hidden">
                <div className="flex flex-col sm:flex-row">
                  <div className="sm:w-40 h-40 sm:h-auto flex-shrink-0">
                    <img 
                      src={rooms.find(r => r.id === selectedBooking.roomId)?.image || 'https://via.placeholder.com/200x200?text=Room'} 
                      alt="Room" 
                      className="w-full h-full object-cover"
                    />
                  </div>
                  <div className="flex-1 p-4">
                    <div className="flex items-center gap-2 mb-2">
                      <BedDouble className="text-blue-500" size={18} />
                      <span className="text-xs text-gray-500 uppercase font-bold">Phòng</span>
                    </div>
                    <h4 className="font-bold text-gray-900 text-lg">
                      {rooms.find(r => r.id === selectedBooking.roomId)?.name || selectedBooking.roomId}
                    </h4>
                    <p className="text-sm text-gray-500 mt-1">
                      {rooms.find(r => r.id === selectedBooking.roomId)?.type || 'N/A'}
                    </p>
                  </div>
                </div>
              </div>

              {/* Dates & Price */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div className="bg-blue-50 p-4 rounded-xl border border-blue-100">
                  <div className="flex items-center gap-2 mb-2">
                    <Calendar size={16} className="text-blue-600"/>
                    <span className="text-xs text-blue-700 font-bold uppercase">Check-in</span>
                  </div>
                  <p className="font-bold text-gray-900 text-lg">{formatDate(selectedBooking.checkIn, 'medium')}</p>
                </div>
                <div className="bg-orange-50 p-4 rounded-xl border border-orange-100">
                  <div className="flex items-center gap-2 mb-2">
                    <Calendar size={16} className="text-orange-600"/>
                    <span className="text-xs text-orange-700 font-bold uppercase">Check-out</span>
                  </div>
                  <p className="font-bold text-gray-900 text-lg">{formatDate(selectedBooking.checkOut, 'medium')}</p>
                </div>
              </div>

              <div className="bg-gradient-to-r from-green-50 to-emerald-50 p-5 rounded-xl border-2 border-green-200">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <DollarSign size={20} className="text-green-600"/>
                    <span className="text-sm text-green-700 font-bold uppercase">Tổng tiền</span>
                  </div>
                  <p className="font-bold text-green-700 text-2xl">
                    {formatCurrency(selectedBooking.totalPrice)}
                  </p>
                </div>
              </div>

              {/* Notes */}
              {selectedBooking.notes && (
                <div className="bg-yellow-50 border border-yellow-200 rounded-xl p-4">
                  <p className="text-xs text-yellow-700 font-bold uppercase mb-2">Ghi chú</p>
                  <p className="text-sm text-gray-700">{selectedBooking.notes}</p>
                </div>
              )}

              {/* Action Buttons */}
              <div className="border-t border-gray-200 pt-4">
                <div className="grid grid-cols-2 gap-3">
                  {selectedBooking.status === 'PENDING' && (
                    <>
                      <Button 
                        onClick={() => handleAction(selectedBooking.id, 'REJECTED')} 
                        variant="danger" 
                        size="md" 
                        isLoading={processingId === selectedBooking.id}
                        className="w-full"
                      >
                        <XCircle size={16} className="mr-2" />
                        Từ chối
                      </Button>
                      <Button 
                        onClick={() => handleAction(selectedBooking.id, 'CONFIRMED')} 
                        variant="success" 
                        size="md" 
                        isLoading={processingId === selectedBooking.id}
                        className="w-full"
                      >
                        <CheckCircle size={16} className="mr-2" />
                        Duyệt đơn
                      </Button>
                    </>
                  )}
                  {selectedBooking.status === 'CONFIRMED' && (
                    <>
                      <Button 
                        onClick={() => handleAction(selectedBooking.id, 'CANCELLED')} 
                        variant="outline" 
                        size="md" 
                        isLoading={processingId === selectedBooking.id}
                        className="w-full"
                      >
                        <XCircle size={16} className="mr-2" />
                        Hủy (No-show)
                      </Button>
                      <Button 
                        onClick={() => handleAction(selectedBooking.id, 'CHECKED_IN')} 
                        variant="primary" 
                        size="md" 
                        isLoading={processingId === selectedBooking.id}
                        className="w-full"
                      >
                        <CheckCircle size={16} className="mr-2" />
                        Check-in
                      </Button>
                    </>
                  )}
                  {selectedBooking.status === 'CHECKED_IN' && (
                    <Button 
                      onClick={() => handleAction(selectedBooking.id, 'CHECKED_OUT')} 
                      variant="secondary" 
                      size="md"
                      className="col-span-2 w-full" 
                      isLoading={processingId === selectedBooking.id}
                    >
                      <LogOut size={18} className="mr-2" /> Check-out & Hoàn tất
                    </Button>
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

      {refundTarget && (
        <RefundConfirmModal 
          booking={refundTarget} 
          onClose={() => setRefundTarget(null)} 
          onConfirm={handleRefundConfirm}
        />
      )}
    </div>
  );
};
