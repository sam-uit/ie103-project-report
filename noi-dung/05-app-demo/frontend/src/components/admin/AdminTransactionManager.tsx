import { useState, useMemo } from 'react';
import { TrendingUp, TrendingDown, FileText, CreditCard, Smartphone, Wallet } from 'lucide-react';
import { Transaction } from '../../types';
import { Button } from '../ui/Button';
import { formatCurrency, formatDateTime } from '../../utils/helpers';

interface AdminTransactionManagerProps {
  transactions: Transaction[];
}

export const AdminTransactionManager = ({ transactions }: AdminTransactionManagerProps) => {
  const [filter, setFilter] = useState<'ALL' | 'PAYMENT' | 'REFUND'>('ALL');

  const filteredTransactions = useMemo(() => {
    if (filter === 'ALL') return transactions;
    return transactions.filter(t => t.type === filter);
  }, [transactions, filter]);

  const totalRefund = transactions
    .filter(t => t.type === 'REFUND' && t.status === 'SUCCESS')
    .reduce((acc, curr) => acc + curr.amount, 0);
    
  const totalIncome = transactions
    .filter(t => t.type === 'PAYMENT' && t.status === 'SUCCESS')
    .reduce((acc, curr) => acc + curr.amount, 0);

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden h-full flex flex-col">
      <div className="p-4 border-b border-gray-200 bg-gray-50 flex flex-col sm:flex-row justify-between items-center gap-4">
        <div className="flex flex-col sm:flex-row items-start sm:items-center gap-4 w-full">
          <h3 className="font-bold text-gray-700 mr-2 whitespace-nowrap">Quản lý giao dịch</h3>
          <div className="flex bg-white rounded-lg p-1 border border-gray-200 w-full sm:w-auto overflow-x-auto">
            <button 
              onClick={() => setFilter('ALL')}
              className={`flex-1 sm:flex-none px-4 py-1.5 rounded-md text-xs font-bold transition-colors whitespace-nowrap ${filter === 'ALL' ? 'bg-blue-100 text-blue-700' : 'text-gray-600 hover:bg-gray-50'}`}
            >
              Tất cả
            </button>
            <button 
              onClick={() => setFilter('PAYMENT')}
              className={`flex-1 sm:flex-none px-4 py-1.5 rounded-md text-xs font-bold transition-colors whitespace-nowrap ${filter === 'PAYMENT' ? 'bg-green-100 text-green-700' : 'text-gray-600 hover:bg-gray-50'}`}
            >
              Thu tiền
            </button>
            <button 
              onClick={() => setFilter('REFUND')}
              className={`flex-1 sm:flex-none px-4 py-1.5 rounded-md text-xs font-bold transition-colors whitespace-nowrap ${filter === 'REFUND' ? 'bg-orange-100 text-orange-700' : 'text-gray-600 hover:bg-gray-50'}`}
            >
              Hoàn tiền
            </button>
          </div>
        </div>
        <Button variant="outline" size="sm" className="whitespace-nowrap">
          <FileText size={14} className="mr-1"/> Xuất báo cáo
        </Button>
      </div>

      <div className="grid grid-cols-2 gap-px bg-gray-200 border-b border-gray-200">
        {(filter === 'ALL' || filter === 'PAYMENT') && (
          <div className="bg-white p-4 flex items-center justify-between">
            <div>
              <p className="text-xs text-gray-500 uppercase font-bold">Tổng thu (Payment)</p>
              <p className="text-lg font-bold text-green-600">{formatCurrency(totalIncome)}</p>
            </div>
            <div className="p-2 bg-green-50 text-green-600 rounded-full">
              <TrendingUp size={20}/>
            </div>
          </div>
        )}
        {(filter === 'ALL' || filter === 'REFUND') && (
          <div className="bg-white p-4 flex items-center justify-between">
            <div>
              <p className="text-xs text-gray-500 uppercase font-bold">Tổng chi (Refund)</p>
              <p className="text-lg font-bold text-orange-600">{formatCurrency(totalRefund)}</p>
            </div>
            <div className="p-2 bg-orange-50 text-orange-600 rounded-full">
              <TrendingDown size={20}/>
            </div>
          </div>
        )}
      </div>

      <div className="overflow-auto flex-grow">
        <table className="w-full text-left">
          <thead className="bg-gray-50 border-b border-gray-200 text-xs text-gray-500 uppercase sticky top-0 z-10">
            <tr>
              <th className="p-4">Mã GD</th>
              <th className="p-4">Mã Đơn</th>
              <th className="p-4">Loại GD</th>
              <th className="p-4">Phương thức</th>
              <th className="p-4">Thời gian</th>
              <th className="p-4">Ghi chú</th>
              <th className="p-4 text-right">Số tiền</th>
              <th className="p-4 text-right">Trạng thái</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {filteredTransactions.map(trx => (
              <tr key={trx.id} className="hover:bg-gray-50 group">
                <td className="p-4 font-mono text-xs">{trx.id}</td>
                <td className="p-4 font-mono text-xs text-blue-600">{trx.bookingId}</td>
                <td className="p-4">
                  {trx.type === 'REFUND' ? 
                    <span className="inline-flex items-center gap-1 px-2 py-1 rounded bg-orange-100 text-orange-700 text-xs font-bold">
                      <TrendingDown size={12}/> HOÀN TIỀN
                    </span> : 
                    <span className="inline-flex items-center gap-1 px-2 py-1 rounded bg-green-100 text-green-700 text-xs font-bold">
                      <TrendingUp size={12}/> THANH TOÁN
                    </span>
                  }
                </td>
                <td className="p-4 text-sm text-gray-600">
                  {trx.method === 'CREDIT_CARD' && <span className="flex items-center gap-1"><CreditCard size={14}/> Thẻ tín dụng</span>}
                  {trx.method === 'MOMO' && <span className="flex items-center gap-1"><Smartphone size={14}/> Momo</span>}
                  {trx.method === 'BANK_TRANSFER' && <span className="flex items-center gap-1"><Wallet size={14}/> Chuyển khoản</span>}
                </td>
                <td className="p-4 text-xs text-gray-500">
                  {formatDateTime(trx.createdAt)}
                </td>
                <td className="p-4 text-xs text-gray-500 italic max-w-[200px] truncate">
                  {trx.note || '-'}
                </td>
                <td className={`p-4 text-right font-bold ${trx.type === 'REFUND' ? 'text-orange-600' : 'text-gray-800'}`}>
                  {trx.type === 'REFUND' ? '-' : '+'}{formatCurrency(trx.amount)}
                </td>
                <td className="p-4 text-right">
                  <span className="px-2 py-1 rounded-full text-xs font-bold bg-gray-100 text-gray-600">
                    Thành công
                  </span>
                </td>
              </tr>
            ))}
            {filteredTransactions.length === 0 && (
              <tr>
                <td colSpan={8} className="p-12 text-center text-gray-400 italic">
                  Không tìm thấy giao dịch nào phù hợp
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};
