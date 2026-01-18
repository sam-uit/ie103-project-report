import React from 'react';
import { TableRow, TableColumn } from '../types';

interface TableSnapshotProps {
      data: TableRow[];
      columns: TableColumn[];
      title?: string;
      className?: string;
      headerColor?: string;
      emptyMessage?: string;
}

const TableSnapshot: React.FC<TableSnapshotProps> = ({
      data,
      columns,
      title,
      className = '',
      headerColor = 'bg-gradient-to-r from-slate-50 to-slate-100 dark:from-slate-800 dark:to-slate-800/50',
      emptyMessage = 'No data available'
}) => {
      const formatValue = (value: any) => {
            if (value === null || value === undefined) {
                  return <span className="text-slate-400 italic text-[10px] font-light">NULL</span>;
            }
            if (typeof value === 'boolean') {
                  return (
                        <span className={`text-[10px] font-bold px-1.5 py-0.5 rounded ${value ? 'bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400' : 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400'}`}>
                              {value ? '✓ TRUE' : '✗ FALSE'}
                        </span>
                  );
            }
            if (typeof value === 'number') {
                  return <span className="font-semibold text-blue-600 dark:text-blue-400">{value.toLocaleString()}</span>;
            }
            return value;
      };

      return (
            <div className={`flex flex-col h-full bg-white dark:bg-dark-surface border border-slate-200/80 dark:border-slate-700/60 rounded-xl overflow-hidden shadow-lg hover:shadow-xl transition-shadow duration-300 ${className}`}>
                  {title && (
                        <div className={`px-5 py-3.5 border-b border-slate-200/80 dark:border-slate-700/60 flex justify-between items-center ${headerColor}`}>
                              <h3 className="font-bold text-sm text-slate-800 dark:text-slate-100 font-sans tracking-tight flex items-center gap-2.5">
                                    <span className="w-1.5 h-5 bg-gradient-to-b from-blue-700 to-blue-900 rounded-full shadow-sm"></span>
                                    {title}
                              </h3>
                              <span className="text-xs font-bold text-slate-600 dark:text-slate-300 bg-gradient-to-br from-white to-slate-50 dark:from-slate-700 dark:to-slate-800 px-3.5 py-1.5 rounded-lg border border-slate-200/80 dark:border-slate-600/60 shadow-sm">
                                    📊 <span className="font-mono">{data.length}</span> {data.length === 1 ? 'row' : 'rows'}
                              </span>
                        </div>
                  )}
                  <div className="overflow-auto flex-1 scrollbar-thin scrollbar-thumb-slate-300 dark:scrollbar-thumb-slate-600 scrollbar-track-transparent">
                        {data.length === 0 ? (
                              <div className="flex flex-col items-center justify-center h-full text-slate-400 p-8">
                                    <div className="text-5xl mb-4 opacity-20">📭</div>
                                    <span className="text-sm font-semibold">{emptyMessage}</span>
                                    <span className="text-xs mt-2 opacity-60">No records to display</span>
                              </div>
                        ) : (
                              <table className="w-full text-left text-xs relative border-collapse">
                                    <thead className="bg-gradient-to-b from-slate-100 via-slate-50 to-white dark:from-slate-900 dark:via-slate-800 dark:to-slate-800/90 text-slate-700 dark:text-slate-300 font-sans sticky top-0 z-10 shadow-md">
                                          <tr>
                                                <th className="px-4 py-4 w-16 text-center border-b border-slate-200/80 dark:border-slate-600/60 font-bold text-slate-500 dark:text-slate-400 bg-slate-50/50 dark:bg-slate-900/30">
                                                      <span className="text-[10px] tracking-wider">#</span>
                                                </th>
                                                {columns.map((col) => (
                                                      <th key={col.key} className="px-4 py-4 font-bold border-b border-r border-slate-200/60 dark:border-slate-600/40 last:border-r-0 whitespace-nowrap group hover:bg-blue-50/50 dark:hover:bg-blue-900/10 transition-colors">
                                                            <div className="flex items-center gap-2">
                                                                  <span className="text-[11px] uppercase tracking-wide">{col.label}</span>
                                                                  {col.isPk && (
                                                                        <span className="text-[9px] px-2 py-0.5 rounded-md bg-gradient-to-br from-red-100 to-red-50 text-red-800 dark:from-red-900/50 dark:to-red-900/30 dark:text-red-300 font-black border border-red-300/60 dark:border-red-700/40 shadow-sm">
                                                                              🔑 PK
                                                                        </span>
                                                                  )}
                                                            </div>
                                                      </th>
                                                ))}
                                          </tr>
                                    </thead>
                                    <tbody className="font-mono divide-y divide-slate-200/60 dark:divide-slate-700/40">
                                          {data.map((row, idx) => (
                                                <tr key={idx} className={`hover:bg-gradient-to-r hover:from-blue-50 hover:to-transparent dark:hover:from-blue-900/10 dark:hover:to-transparent transition-all duration-200 group ${idx % 2 === 0 ? 'bg-white dark:bg-slate-900/20' : 'bg-slate-50/40 dark:bg-slate-800/20'}`}>
                                                      <td className="px-4 py-3.5 text-center text-slate-400 dark:text-slate-500 text-[10px] font-bold border-r border-slate-200/60 dark:border-slate-700/40 bg-slate-50/60 dark:bg-slate-900/40 group-hover:bg-blue-100/40 dark:group-hover:bg-blue-900/20 transition-colors">
                                                            {idx + 1}
                                                      </td>
                                                      {columns.map((col, colIdx) => (
                                                            <td key={col.key} className={`px-4 py-3.5 border-r border-slate-200/40 dark:border-slate-700/30 last:border-r-0 transition-colors ${col.isPk ? 'text-slate-900 dark:text-slate-100 font-bold bg-red-50/20 dark:bg-red-900/5 group-hover:bg-red-100/30 dark:group-hover:bg-red-900/10' : 'text-slate-700 dark:text-slate-300'}`}>
                                                                  <div className="whitespace-nowrap">
                                                                        {formatValue(row[col.key])}
                                                                  </div>
                                                            </td>
                                                      ))}
                                                </tr>
                                          ))}
                                    </tbody>
                              </table>
                        )}
                  </div>
            </div>
      );
};

export default TableSnapshot;