import { useState, useEffect, useMemo } from 'react';
import { Hotel, UserCircle, Calendar, Search, LogOut, SlidersHorizontal } from 'lucide-react';
import { User, Room } from './types';
import { Button, Badge } from './components/ui/Button';
import { formatCurrency } from './utils/helpers';
import { StorageService } from './utils/storage';
import { RoomService, AuthService } from './services/services';
import { AdminDashboard } from './components/admin/AdminDashboard';
import { BookingModal, UserBookingsList } from './components/user/UserBookings';
import { ToastProvider, toast } from './components/ui/Toast';
import { ErrorBoundary } from './components/ErrorBoundary';
import { LoginModal } from './components/modals/LoginModal';

export default function BMS_App() {
  const [currentUser, setCurrentUser] = useState<User | null>(null);
  const [view, setView] = useState<'HOME' | 'MY_BOOKINGS' | 'ADMIN'>('HOME');
  const [rooms, setRooms] = useState<Room[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedRoom, setSelectedRoom] = useState<Room | null>(null);
  const [priceFilter, setPriceFilter] = useState<'all' | 'low' | 'mid' | 'high'>('all');
  const [sortBy, setSortBy] = useState<'name' | 'price-asc' | 'price-desc'>('name');
  const [showFilters, setShowFilters] = useState(false);
  const [isLoginModalOpen, setIsLoginModalOpen] = useState(false);

  // Load user from localStorage on mount
  useEffect(() => {
    const savedUser = StorageService.getUser();
    if (savedUser) {
      setCurrentUser(savedUser);
      setView(savedUser.role === 'ADMIN' ? 'ADMIN' : 'HOME');
    }
  }, []);

  useEffect(() => { 
    loadRooms(); 
  }, [view]);

  const loadRooms = async () => { 
    setIsLoading(true); 
    const data = await RoomService.getAll(); 
    setRooms(data); 
    setIsLoading(false); 
  };

  const handleLoginSuccess = (user: User) => {
    setCurrentUser(user);
    StorageService.saveUser(user);
    setView(user.role === 'ADMIN' ? 'ADMIN' : 'HOME');
  };

  const handleLogout = () => {
    setCurrentUser(null);
    StorageService.clearUser();
    setView('HOME');
    toast.info('Đã đăng xuất');
  };

  const filteredRooms = useMemo(() => {
    let filtered = rooms.filter(r => 
      r.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      r.description.toLowerCase().includes(searchTerm.toLowerCase())
    );

    // Price filter
    if (priceFilter === 'low') {
      filtered = filtered.filter(r => r.price < 1000000);
    } else if (priceFilter === 'mid') {
      filtered = filtered.filter(r => r.price >= 1000000 && r.price < 2000000);
    } else if (priceFilter === 'high') {
      filtered = filtered.filter(r => r.price >= 2000000);
    }

    // Sort
    if (sortBy === 'price-asc') {
      filtered.sort((a, b) => a.price - b.price);
    } else if (sortBy === 'price-desc') {
      filtered.sort((a, b) => b.price - a.price);
    } else {
      filtered.sort((a, b) => a.name.localeCompare(b.name));
    }

    return filtered;
  }, [rooms, searchTerm, priceFilter, sortBy]);

  return (
    <ErrorBoundary>
      <ToastProvider>
        <div className="min-h-screen bg-gray-50 font-sans text-gray-900">
          <nav className="bg-white border-b border-gray-200 sticky top-0 z-40">
            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
              <div className="flex justify-between items-center h-16">
                <div className="flex items-center gap-3 cursor-pointer" onClick={() => setView('HOME')}>
                  <div className="p-2 bg-blue-600 text-white rounded-lg">
                    <Hotel size={24} />
                  </div>
                  <div>
                    <h1 className="text-lg font-bold text-gray-900">BookingMS</h1>
                    <p className="text-xs text-gray-500">Hotel Management System</p>
                  </div>
                </div>

                <div className="flex items-center gap-3">
                  {!currentUser ? (
                    <Button onClick={() => setIsLoginModalOpen(true)} size="sm">
                      <UserCircle size={16} /> Đăng nhập
                    </Button>
                  ) : (
                    <>
                      <div className="flex items-center gap-3">
                        {currentUser.role === 'USER' && (
                          <Button 
                            onClick={() => setView('MY_BOOKINGS')} 
                            variant={view === 'MY_BOOKINGS' ? 'primary' : 'ghost'} 
                            size="sm"
                          >
                            <Calendar size={16} /> Đơn của tôi
                          </Button>
                        )}
                        <div className="flex items-center gap-2 px-3 py-1.5 bg-gray-100 rounded-lg">
                          <img 
                            src={currentUser.avatar} 
                            className="w-6 h-6 rounded-full" 
                            alt={currentUser.name} 
                          />
                          <span className="text-sm font-medium">{currentUser.name}</span>
                        </div>
                        <Button 
                          onClick={handleLogout} 
                          variant="ghost" 
                          size="sm"
                        >
                          <LogOut size={16} />
                        </Button>
                      </div>
                    </>
                  )}
                </div>
              </div>
            </div>
          </nav>

          <main className="pb-20">
            {view === 'HOME' && (
              <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                <div className="mb-8">
                  <h2 className="text-3xl font-bold text-gray-900">Danh sách phòng khả dụng</h2>
                  <p className="text-gray-500 mt-1">Chọn phòng phù hợp với bạn</p>
                </div>

                <div className="mb-6 flex flex-col md:flex-row gap-4">
                  <div className="relative flex-1">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" size={20} />
                    <input 
                      type="text" 
                      placeholder="Tìm kiếm phòng..." 
                      className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none" 
                      value={searchTerm} 
                      onChange={e => setSearchTerm(e.target.value)} 
                    />
                  </div>
                  <Button 
                    variant="outline" 
                    onClick={() => setShowFilters(!showFilters)}
                    className="md:w-auto"
                  >
                    <SlidersHorizontal size={20} /> Bộ lọc
                  </Button>
                </div>

                {showFilters && (
                  <div className="mb-6 p-4 bg-white rounded-lg border border-gray-200">
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-2">Khoảng giá</label>
                        <div className="flex gap-2">
                          {[
                            { value: 'all', label: 'Tất cả' },
                            { value: 'low', label: '< 1 triệu' },
                            { value: 'mid', label: '1-2 triệu' },
                            { value: 'high', label: '> 2 triệu' }
                          ].map(option => (
                            <button
                              key={option.value}
                              onClick={() => setPriceFilter(option.value as any)}
                              className={`px-3 py-1.5 rounded-lg text-sm font-medium transition-colors ${
                                priceFilter === option.value
                                  ? 'bg-blue-600 text-white'
                                  : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                              }`}
                            >
                              {option.label}
                            </button>
                          ))}
                        </div>
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-2">Sắp xếp</label>
                        <select
                          value={sortBy}
                          onChange={(e) => setSortBy(e.target.value as any)}
                          className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
                        >
                          <option value="name">Tên A-Z</option>
                          <option value="price-asc">Giá thấp đến cao</option>
                          <option value="price-desc">Giá cao đến thấp</option>
                        </select>
                      </div>
                    </div>
                  </div>
                )}

                {isLoading ? (
                  <div className="text-center py-12 text-gray-500">Đang tải...</div>
                ) : filteredRooms.length === 0 ? (
                  <div className="text-center py-12">
                    <p className="text-gray-500 text-lg">Không tìm thấy phòng phù hợp</p>
                    <Button 
                      variant="outline" 
                      className="mt-4"
                      onClick={() => {
                        setSearchTerm('');
                        setPriceFilter('all');
                      }}
                    >
                      Xóa bộ lọc
                    </Button>
                  </div>
                ) : (
                  <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    {filteredRooms.map(room => (
                      <div 
                        key={room.id} 
                        className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden hover:shadow-lg transition-all cursor-pointer group"
                      >
                        <div className="relative h-48 bg-gray-100 overflow-hidden">
                          <img 
                            src={room.image} 
                            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300" 
                            alt={room.name} 
                          />
                          <div className="absolute top-3 right-3">
                            <Badge status={room.status} />
                          </div>
                        </div>
                        <div className="p-5">
                          <h3 className="font-bold text-lg text-gray-900">{room.name}</h3>
                          <p className="text-sm text-gray-500 mt-1 line-clamp-2">{room.description}</p>
                          <div className="flex justify-between items-center mt-4">
                            <div>
                              <div className="text-2xl font-bold text-blue-600">
                                {formatCurrency(room.price)}
                              </div>
                              <div className="text-xs text-gray-400">/ đêm</div>
                            </div>
                            <Button 
                              onClick={() => {
                                if (!currentUser) {
                                  toast.info('Vui lòng đăng nhập để đặt phòng');
                                  setIsLoginModalOpen(true);
                                } else if (currentUser.role === 'ADMIN') {
                                  toast.warning('Tài khoản Admin không thể đặt phòng. Vui lòng đăng nhập bằng tài khoản User.');
                                } else {
                                  setSelectedRoom(room);
                                }
                              }} 
                              disabled={room.status !== 'AVAILABLE'}
                            >
                              Đặt ngay
                            </Button>
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            )}
            
            {view === 'MY_BOOKINGS' && currentUser && (
              <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                <h2 className="text-2xl font-bold mb-6">Đơn đặt phòng của tôi</h2>
                <UserBookingsList userId={currentUser.id} />
              </div>
            )}
            
            {view === 'ADMIN' && currentUser?.role === 'ADMIN' && (
              <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                <AdminDashboard />
              </div>
            )}
          </main>

          {selectedRoom && (
            <BookingModal 
              room={selectedRoom} 
              user={currentUser} 
              onClose={() => setSelectedRoom(null)} 
              onSuccess={() => { 
                setSelectedRoom(null); 
                if (currentUser) setView('MY_BOOKINGS'); 
              }} 
            />
          )}

          <LoginModal
            isOpen={isLoginModalOpen}
            onClose={() => setIsLoginModalOpen(false)}
            onLoginSuccess={handleLoginSuccess}
          />
        </div>
      </ToastProvider>
    </ErrorBoundary>
  );
}
