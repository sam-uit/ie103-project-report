import { useState, useEffect } from 'react';
import { XCircle } from 'lucide-react';
import { Room } from '../../types';
import { Button } from '../ui/Button';
import { validatePrice, validateCapacity } from '../../utils/validation';
import { toast } from '../ui/Toast';

interface RoomFormModalProps {
  room: Room | null;
  isOpen: boolean;
  onClose: () => void;
  onSave: (room: Room) => void;
}

export const RoomFormModal = ({ room, isOpen, onClose, onSave }: RoomFormModalProps) => {
  const [formData, setFormData] = useState<Partial<Room>>({
    name: '', 
    type: 'Standard', 
    price: 0, 
    capacity: 2, 
    description: '', 
    image: '', 
    status: 'AVAILABLE'
  });
  const [errors, setErrors] = useState<Record<string, string>>({});

  useEffect(() => {
    if (room) {
      setFormData(room);
    } else {
      setFormData({
        name: '', 
        type: 'Standard', 
        price: 0, 
        capacity: 2, 
        description: '', 
        image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&q=80&w=1000', 
        status: 'AVAILABLE'
      });
    }
    setErrors({});
  }, [room, isOpen]);

  const validateForm = (): boolean => {
    const newErrors: Record<string, string> = {};

    if (!formData.name || formData.name.trim().length < 3) {
      newErrors.name = 'Tên phòng phải có ít nhất 3 ký tự';
    }

    const priceValidation = validatePrice(formData.price || 0);
    if (!priceValidation.valid) {
      newErrors.price = priceValidation.error || '';
    }

    const capacityValidation = validateCapacity(formData.capacity || 0);
    if (!capacityValidation.valid) {
      newErrors.capacity = capacityValidation.error || '';
    }

    if (!formData.image || !formData.image.startsWith('http')) {
      newErrors.image = 'URL hình ảnh không hợp lệ';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!validateForm()) {
      toast.error('Vui lòng kiểm tra lại thông tin nhập vào');
      return;
    }

    onSave(formData as Room);
    toast.success(room ? 'Cập nhật phòng thành công!' : 'Thêm phòng mới thành công!');
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4 backdrop-blur-sm">
      <div className="bg-white rounded-xl w-full max-w-2xl overflow-hidden shadow-2xl flex flex-col max-h-[90vh]">
        <div className="p-5 border-b border-gray-100 flex justify-between items-center bg-gray-50">
          <h2 className="text-lg font-bold text-gray-800">{room ? 'Cập nhật phòng' : 'Thêm phòng mới'}</h2>
          <button onClick={onClose} className="text-gray-400 hover:text-gray-600">
            <XCircle size={24}/>
          </button>
        </div>
        <div className="overflow-y-auto p-6">
          <form 
            id="roomForm" 
            onSubmit={handleSubmit} 
            className="space-y-4"
          >
            <div className="grid grid-cols-2 gap-4">
              <div className="col-span-2">
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Tên phòng <span className="text-red-500">*</span>
                </label>
                <input 
                  required 
                  className={`w-full p-2 border rounded-lg ${errors.name ? 'border-red-500' : 'border-gray-300'}`}
                  value={formData.name} 
                  onChange={e => setFormData({...formData, name: e.target.value})} 
                />
                {errors.name && <p className="text-red-500 text-xs mt-1">{errors.name}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Loại phòng</label>
                <select 
                  className="w-full p-2 border rounded-lg" 
                  value={formData.type} 
                  onChange={e => setFormData({...formData, type: e.target.value})}
                >
                  <option value="Standard">Standard</option>
                  <option value="Deluxe">Deluxe</option>
                  <option value="Suite">Suite</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Trạng thái</label>
                <select 
                  className="w-full p-2 border rounded-lg" 
                  value={formData.status} 
                  onChange={e => setFormData({...formData, status: e.target.value as Room['status']})}
                >
                  <option value="AVAILABLE">Sẵn sàng</option>
                  <option value="MAINTENANCE">Bảo trì</option>
                  <option value="OCCUPIED">Đang có khách</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Giá (VNĐ) <span className="text-red-500">*</span>
                </label>
                <input 
                  type="number" 
                  required 
                  className={`w-full p-2 border rounded-lg ${errors.price ? 'border-red-500' : 'border-gray-300'}`}
                  value={formData.price} 
                  onChange={e => setFormData({...formData, price: Number(e.target.value)})} 
                />
                {errors.price && <p className="text-red-500 text-xs mt-1">{errors.price}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Sức chứa <span className="text-red-500">*</span>
                </label>
                <input 
                  type="number" 
                  required 
                  className={`w-full p-2 border rounded-lg ${errors.capacity ? 'border-red-500' : 'border-gray-300'}`}
                  value={formData.capacity} 
                  onChange={e => setFormData({...formData, capacity: Number(e.target.value)})} 
                />
                {errors.capacity && <p className="text-red-500 text-xs mt-1">{errors.capacity}</p>}
              </div>
              <div className="col-span-2">
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  URL Hình ảnh <span className="text-red-500">*</span>
                </label>
                <input 
                  className={`w-full p-2 border rounded-lg ${errors.image ? 'border-red-500' : 'border-gray-300'}`}
                  value={formData.image} 
                  onChange={e => setFormData({...formData, image: e.target.value})} 
                />
                {errors.image && <p className="text-red-500 text-xs mt-1">{errors.image}</p>}
              </div>
              <div className="col-span-2">
                <label className="block text-sm font-medium text-gray-700 mb-1">Mô tả</label>
                <textarea 
                  className="w-full p-2 border rounded-lg border-gray-300"
                  rows={3}
                  value={formData.description} 
                  onChange={e => setFormData({...formData, description: e.target.value})} 
                />
              </div>
            </div>
          </form>
        </div>
        <div className="p-4 border-t border-gray-100 flex justify-end gap-3 bg-gray-50">
          <Button variant="ghost" onClick={onClose}>Hủy</Button>
          <Button type="submit" form="roomForm">Lưu</Button>
        </div>
      </div>
    </div>
  );
};
