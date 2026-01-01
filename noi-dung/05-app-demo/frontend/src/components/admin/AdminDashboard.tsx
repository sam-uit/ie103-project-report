import { useState, useEffect } from 'react';
import { DollarSign, List, User, Home, PlusCircle, Edit } from 'lucide-react';
import { Booking, Room, Transaction, BookingStatus } from '../../types';
import { Button, Badge } from '../ui/Button';
import { formatCurrency } from '../../utils/helpers';
import { BookingService, RoomService, TransactionService } from '../../services/services';
import { AdminBookingManager } from './AdminBookingManager';
import { AdminTransactionManager } from './AdminTransactionManager';
import { RoomFormModal } from '../modals/RoomFormModal';
import { toast } from '../ui/Toast';

export const AdminDashboard = () => {
  const [activeTab, setActiveTab] = useState<'bookings' | 'rooms' | 'transactions'>('bookings');
  const [bookings, setBookings] = useState<Booking[]>([]);
  const [rooms, setRooms] = useState<Room[]>([]);
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [isRoomModalOpen, setIsRoomModalOpen] = useState(false);
  const [editingRoom, setEditingRoom] = useState<Room | null>(null);

  useEffect(() => { 
    loadData(); 
  }, [activeTab]);

  const loadData = async () => {
    const [bData, rData, tData] = await Promise.all([
      BookingService.getAll(), 
      RoomService.getAll(), 
      TransactionService.getAll()
    ]);
    setBookings(bData);
    setRooms(rData);
    setTransactions(tData);
  };

  const handleStatusUpdate = async (id: string, status: BookingStatus) => {
    await BookingService.updateStatus(id, status);
    const bData = await BookingService.getAll();
    setBookings(bData);
    const rData = await RoomService.getAll();
    setRooms(rData);
  };
  
  const handleRefund = async (id: string, amount: number) => {
    await BookingService.processRefund(id, amount);
    loadData();
  };

  const handleSaveRoom = async (roomData: Room) => {
    try {
      if (editingRoom) {
        await RoomService.update(roomData);
        toast.success('Cập nhật phòng thành công');
      } else {
        await RoomService.create(roomData);
        toast.success('Thêm phòng mới thành công');
      }
      setIsRoomModalOpen(false);
      loadData();
    } catch (error) {
      toast.error('Không thể lưu thông tin phòng. Vui lòng thử lại.');
      console.error('Error saving room:', error);
    }
  };

  const revenue = transactions
    .filter(t => t.type === 'PAYMENT' && t.status === 'SUCCESS')
    .reduce((s, t) => s + t.amount, 0) 
    - transactions
    .filter(t => t.type === 'REFUND' && t.status === 'SUCCESS')
    .reduce((s, t) => s + t.amount, 0);
    
  const pending = bookings.filter(b => b.status === 'PENDING').length;
  const occupied = bookings.filter(b => b.status === 'CHECKED_IN').length;

  return (
    <div className="space-y-6 animate-in fade-in duration-500">
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="bg-white p-5 rounded-xl shadow-sm border border-gray-100 flex items-center justify-between">
          <div>
            <div className="text-gray-500 text-xs font-bold uppercase">Doanh thu thực</div>
            <div className="text-xl font-bold text-blue-600 mt-1">{formatCurrency(revenue)}</div>
          </div>
          <div className="p-3 bg-blue-50 text-blue-600 rounded-full">
            <DollarSign size={20}/>
          </div>
        </div>
        <div className="bg-white p-5 rounded-xl shadow-sm border border-gray-100 flex items-center justify-between">
          <div>
            <div className="text-gray-500 text-xs font-bold uppercase">Chờ xử lý</div>
            <div className="text-xl font-bold text-orange-500 mt-1">{pending}</div>
          </div>
          <div className="p-3 bg-orange-50 text-orange-600 rounded-full">
            <List size={20}/>
          </div>
        </div>
        <div className="bg-white p-5 rounded-xl shadow-sm border border-gray-100 flex items-center justify-between">
          <div>
            <div className="text-gray-500 text-xs font-bold uppercase">Đang ở</div>
            <div className="text-xl font-bold text-purple-600 mt-1">{occupied}</div>
          </div>
          <div className="p-3 bg-purple-50 text-purple-600 rounded-full">
            <User size={20}/>
          </div>
        </div>
        <div className="bg-white p-5 rounded-xl shadow-sm border border-gray-100 flex items-center justify-between">
          <div>
            <div className="text-gray-500 text-xs font-bold uppercase">Tổng phòng</div>
            <div className="text-xl font-bold text-gray-700 mt-1">{rooms.length}</div>
          </div>
          <div className="p-3 bg-gray-100 text-gray-600 rounded-full">
            <Home size={20}/>
          </div>
        </div>
      </div>

      <div className="flex justify-between items-center">
        <div className="flex bg-gray-100 p-1 rounded-lg">
          <button 
            onClick={() => setActiveTab('bookings')} 
            className={`px-4 py-2 rounded-md text-sm font-medium transition-all ${
              activeTab === 'bookings' ? 'bg-white shadow text-blue-600' : 'text-gray-500'
            }`}
          >
            Đặt phòng
          </button>
          <button 
            onClick={() => setActiveTab('transactions')} 
            className={`px-4 py-2 rounded-md text-sm font-medium transition-all ${
              activeTab === 'transactions' ? 'bg-white shadow text-blue-600' : 'text-gray-500'
            }`}
          >
            Giao dịch
          </button>
          <button 
            onClick={() => setActiveTab('rooms')} 
            className={`px-4 py-2 rounded-md text-sm font-medium transition-all ${
              activeTab === 'rooms' ? 'bg-white shadow text-blue-600' : 'text-gray-500'
            }`}
          >
            Phòng ốc
          </button>
        </div>
        {activeTab === 'rooms' && (
          <Button 
            onClick={() => { 
              setEditingRoom(null); 
              setIsRoomModalOpen(true); 
            }} 
            size="sm"
          >
            <PlusCircle size={16} /> Thêm phòng
          </Button>
        )}
      </div>

      <div className="min-h-[400px]">
        {activeTab === 'bookings' && (
          <AdminBookingManager 
            bookings={bookings} 
            rooms={rooms} 
            onStatusUpdate={handleStatusUpdate} 
            onRefund={handleRefund} 
          />
        )}
        {activeTab === 'transactions' && (
          <AdminTransactionManager transactions={transactions} />
        )}
        {activeTab === 'rooms' && (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {rooms.map(room => (
              <div 
                key={room.id} 
                className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden hover:shadow-md transition-all group"
              >
                <div className="relative h-40 bg-gray-100">
                  <img src={room.image} className="w-full h-full object-cover" alt={room.name} />
                  <div className="absolute top-2 right-2">
                    <Badge status={room.status} />
                  </div>
                </div>
                <div className="p-4">
                  <div className="flex justify-between items-start mb-1">
                    <h3 className="font-bold text-gray-900">{room.name}</h3>
                    <button 
                      onClick={() => { 
                        setEditingRoom(room); 
                        setIsRoomModalOpen(true); 
                      }} 
                      className="p-1 text-blue-600 hover:bg-blue-50 rounded"
                    >
                      <Edit size={16} />
                    </button>
                  </div>
                  <div className="font-bold text-blue-600">
                    {formatCurrency(room.price)} 
                    <span className="text-xs font-normal text-gray-400">/đêm</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      <RoomFormModal 
        isOpen={isRoomModalOpen} 
        onClose={() => setIsRoomModalOpen(false)} 
        room={editingRoom} 
        onSave={handleSaveRoom} 
      />
    </div>
  );
};
