import { useState } from 'react';
import { AlertCircle, CreditCard, Smartphone, Wallet, QrCode, CheckCircle, XCircle } from 'lucide-react';
import { Booking, PaymentMethod } from '../../types';
import { Button } from '../ui/Button';
import { formatCurrency } from '../../utils/helpers';
import { BookingService } from '../../services/services';
import { toast } from '../ui/Toast';

interface RefundConfirmModalProps {
  booking: Booking;
  onClose: () => void;
  onConfirm: () => Promise<void>;
}

export const RefundConfirmModal = ({ booking, onClose, onConfirm }: RefundConfirmModalProps) => {
  const [isProcessing, setIsProcessing] = useState(false);

  const handleRefund = async () => {
    setIsProcessing(true);
    try {
      await onConfirm(); 
      toast.success('Hoàn tiền thành công!');
    } catch (error) {
      toast.error('Có lỗi xảy ra khi hoàn tiền');
    } finally {
      setIsProcessing(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-black/60 flex items-center justify-center z-[70] p-4 backdrop-blur-sm">
      <div className="bg-white rounded-xl w-full max-w-sm overflow-hidden shadow-2xl animate-in zoom-in">
        <div className="p-6 text-center">
          <div className="w-12 h-12 bg-orange-100 text-orange-600 rounded-full flex items-center justify-center mx-auto mb-4">
             <AlertCircle size={24} />
          </div>
          <h3 className="text-lg font-bold text-gray-900">Xác nhận hoàn tiền?</h3>
          <p className="text-sm text-gray-500 mt-2">
            Đơn hàng <strong>#{booking.id}</strong> đã thanh toán <strong>{formatCurrency(booking.totalPrice)}</strong>.
          </p>
          <p className="text-sm text-gray-500 mt-1">
            Bạn có muốn tạo giao dịch hoàn tiền và hủy đơn này không?
          </p>
          
          <div className="grid grid-cols-1 gap-3 mt-6">
             <Button onClick={handleRefund} isLoading={isProcessing} className="w-full bg-orange-600 hover:bg-orange-700">
               Đồng ý Hoàn tiền & Hủy
             </Button>
             <Button variant="ghost" onClick={onClose} disabled={isProcessing}>
               Không, quay lại
             </Button>
          </div>
        </div>
      </div>
    </div>
  );
};

interface PaymentGatewayModalProps {
  booking: Booking;
  onClose: () => void;
  onSuccess: () => void;
}

export const PaymentGatewayModal = ({ booking, onClose, onSuccess }: PaymentGatewayModalProps) => {
  const [method, setMethod] = useState<PaymentMethod>('CREDIT_CARD');
  const [isProcessing, setIsProcessing] = useState(false);
  const [step, setStep] = useState<'SELECT' | 'PROCESS' | 'SUCCESS'>('SELECT');

  const handlePay = async () => {
    setIsProcessing(true);
    setTimeout(async () => {
      try {
        await BookingService.processPayment(booking.id, booking.totalPrice, method);
        setIsProcessing(false);
        setStep('SUCCESS');
        toast.success('Thanh toán thành công!');
        setTimeout(() => {
          onSuccess();
        }, 1500);
      } catch (error) {
        setIsProcessing(false);
        toast.error('Thanh toán thất bại. Vui lòng thử lại.');
      }
    }, 2000);
  };

  return (
    <div className="fixed inset-0 bg-black/60 flex items-center justify-center z-[60] p-4 backdrop-blur-sm">
      <div className="bg-white rounded-2xl w-full max-w-md overflow-hidden shadow-2xl animate-in fade-in zoom-in duration-200">
        <div className="bg-blue-600 p-6 text-white text-center">
          <h3 className="text-xl font-bold">Cổng Thanh Toán An Toàn</h3>
          <p className="text-blue-100 text-sm mt-1">BookingMS Secure Payment</p>
        </div>

        <div className="p-6">
          {step === 'SELECT' && (
            <>
              <div className="mb-6 text-center">
                 <p className="text-gray-500 text-sm">Tổng tiền thanh toán</p>
                 <p className="text-3xl font-bold text-blue-600">{formatCurrency(booking.totalPrice)}</p>
              </div>

              <div className="space-y-3 mb-6">
                 <label className={`flex items-center p-4 border rounded-xl cursor-pointer transition-all ${method === 'CREDIT_CARD' ? 'border-blue-500 bg-blue-50' : 'hover:bg-gray-50'}`}>
                    <input type="radio" name="method" className="mr-3" checked={method === 'CREDIT_CARD'} onChange={() => setMethod('CREDIT_CARD')} />
                    <CreditCard className="mr-3 text-blue-600" />
                    <div className="flex-1">
                       <div className="font-bold text-gray-800">Thẻ Tín dụng / Ghi nợ</div>
                       <div className="text-xs text-gray-500">Visa, Mastercard, JCB</div>
                    </div>
                 </label>
                 <label className={`flex items-center p-4 border rounded-xl cursor-pointer transition-all ${method === 'MOMO' ? 'border-pink-500 bg-pink-50' : 'hover:bg-gray-50'}`}>
                    <input type="radio" name="method" className="mr-3" checked={method === 'MOMO'} onChange={() => setMethod('MOMO')} />
                    <Smartphone className="mr-3 text-pink-600" />
                    <div className="flex-1">
                       <div className="font-bold text-gray-800">Ví MoMo</div>
                       <div className="text-xs text-gray-500">Quét mã QR để thanh toán</div>
                    </div>
                 </label>
                 <label className={`flex items-center p-4 border rounded-xl cursor-pointer transition-all ${method === 'BANK_TRANSFER' ? 'border-green-500 bg-green-50' : 'hover:bg-gray-50'}`}>
                    <input type="radio" name="method" className="mr-3" checked={method === 'BANK_TRANSFER'} onChange={() => setMethod('BANK_TRANSFER')} />
                    <Wallet className="mr-3 text-green-600" />
                    <div className="flex-1">
                       <div className="font-bold text-gray-800">Chuyển khoản Ngân hàng</div>
                       <div className="text-xs text-gray-500">Vietcombank, Techcombank...</div>
                    </div>
                 </label>
              </div>

              <div className="flex gap-3">
                 <Button variant="ghost" className="flex-1" onClick={onClose}>Hủy</Button>
                 <Button className="flex-1" onClick={() => setStep('PROCESS')}>Tiếp tục</Button>
              </div>
            </>
          )}

          {step === 'PROCESS' && (
             <div className="space-y-4">
                {method === 'CREDIT_CARD' && (
                   <div className="p-4 bg-gray-50 rounded-lg border border-gray-200 space-y-3">
                      <input type="text" placeholder="Số thẻ" className="w-full p-2 border rounded" defaultValue="4242 4242 4242 4242" />
                      <div className="flex gap-3">
                         <input type="text" placeholder="MM/YY" className="w-1/2 p-2 border rounded" defaultValue="12/25" />
                         <input type="text" placeholder="CVV" className="w-1/2 p-2 border rounded" defaultValue="123" />
                      </div>
                      <input type="text" placeholder="Tên chủ thẻ" className="w-full p-2 border rounded" defaultValue="NGUYEN VAN A" />
                   </div>
                )}
                {method === 'MOMO' && (
                   <div className="flex flex-col items-center p-4 bg-pink-50 rounded-lg">
                      <div className="bg-white p-2 rounded mb-2"><QrCode size={120} /></div>
                      <p className="text-sm text-pink-600 font-medium">Quét mã để thanh toán</p>
                   </div>
                )}
                
                <div className="pt-2">
                   <Button className="w-full" onClick={handlePay} disabled={isProcessing}>
                      {isProcessing ? 'Đang xử lý giao dịch...' : `Thanh toán ${formatCurrency(booking.totalPrice)}`}
                   </Button>
                   <Button variant="ghost" className="w-full mt-2" onClick={() => setStep('SELECT')} disabled={isProcessing}>Quay lại</Button>
                </div>
             </div>
          )}

          {step === 'SUCCESS' && (
             <div className="text-center py-6 animate-in zoom-in">
                <div className="w-16 h-16 bg-green-100 text-green-600 rounded-full flex items-center justify-center mx-auto mb-4">
                   <CheckCircle size={32} />
                </div>
                <h3 className="text-xl font-bold text-gray-800">Thanh toán Thành công!</h3>
                <p className="text-gray-500 mt-2">Mã đơn: #{booking.id}</p>
                <p className="text-gray-500">Hệ thống đang chuyển hướng...</p>
             </div>
          )}
        </div>
      </div>
    </div>
  );
};
