import React, { useMemo } from 'react';
import { TableRow, TableColumn } from '../types';
import { ArrowRight, Plus, Minus, Edit2 } from 'lucide-react';

interface DiffViewProps {
  before: TableRow[];
  after: TableRow[];
  columns: TableColumn[];
  pk: string;
}

const DiffView: React.FC<DiffViewProps> = ({ before, after, columns, pk }) => {

  const diffs = useMemo(() => {
    const changes: any[] = [];
    const beforeMap = new Map(before.map(r => [r[pk], r]));
    const afterMap = new Map(after.map(r => [r[pk], r]));

    // Check for updates and inserts
    after.forEach(row => {
      const id = row[pk];
      const oldRow = beforeMap.get(id);

      if (!oldRow) {
        changes.push({ type: 'INSERT', data: row });
      } else {
        if (JSON.stringify(oldRow) !== JSON.stringify(row)) {
          changes.push({ type: 'UPDATE', before: oldRow, after: row });
        }
      }
    });

    // Check for deletes
    before.forEach(row => {
      if (!afterMap.has(row[pk])) {
        changes.push({ type: 'DELETE', data: row });
      }
    });

    return changes;
  }, [before, after, pk]);

  if (diffs.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center h-full text-slate-400 bg-gradient-to-br from-slate-50 via-white to-slate-100 dark:from-slate-900 dark:via-slate-850 dark:to-slate-800 rounded-xl border-2 border-dashed border-slate-300/60 dark:border-dark-border/40 shadow-inner">
        <div className="text-7xl mb-5 opacity-15 animate-pulse">✨</div>
        <span className="text-base font-bold text-slate-600 dark:text-dark-text-secondary">No Changes Detected</span>
        <span className="text-sm mt-2 opacity-70 text-center max-w-md px-4">The operation completed successfully but did not modify any rows in the database.</span>
      </div>
    )
  }

  return (
    <div className="flex flex-col h-full bg-white dark:bg-dark-surface border border-slate-200/80 dark:border-dark-border/60 rounded-xl overflow-hidden shadow-xl hover:shadow-2xl transition-shadow duration-300">
      <div className="px-6 py-4 bg-gradient-to-r from-purple-50 via-blue-50 to-indigo-50 dark:from-purple-900/20 dark:via-blue-900/20 dark:to-indigo-900/20 border-b border-purple-200/60 dark:border-purple-800/40 flex items-center justify-between">
        <h3 className="font-bold text-sm text-slate-800 dark:text-dark-text-primary tracking-tight flex items-center gap-2.5">
          <span className="w-1.5 h-6 bg-gradient-to-b from-purple-500 to-purple-600 rounded-full shadow-sm"></span>
          <ArrowRight className="text-purple-500 dark:text-purple-400" size={17} />
          <span>Changes Summary</span>
        </h3>
        <div className="flex gap-2.5">
          <span className="text-xs font-bold px-3.5 py-1.5 rounded-lg bg-gradient-to-br from-emerald-100 to-green-100 text-emerald-800 dark:from-emerald-900/50 dark:to-green-900/40 dark:text-emerald-300 border border-emerald-300/60 dark:border-emerald-700/40 shadow-md hover:shadow-lg transition-shadow flex items-center gap-1.5">
            <Plus size={13} strokeWidth={3} /> <span className="font-mono">{diffs.filter(d => d.type === 'INSERT').length}</span> Added
          </span>
          <span className="text-xs font-bold px-3.5 py-1.5 rounded-lg bg-gradient-to-br from-amber-100 to-orange-100 text-amber-800 dark:from-amber-900/50 dark:to-orange-900/40 dark:text-amber-300 border border-amber-300/60 dark:border-amber-700/40 shadow-md hover:shadow-lg transition-shadow flex items-center gap-1.5">
            <Edit2 size={13} /> <span className="font-mono">{diffs.filter(d => d.type === 'UPDATE').length}</span> Modified
          </span>
          <span className="text-xs font-bold px-3.5 py-1.5 rounded-lg bg-gradient-to-br from-red-100 to-rose-100 text-red-800 dark:from-red-900/50 dark:to-rose-900/40 dark:text-red-300 border border-red-300/60 dark:border-red-700/40 shadow-md hover:shadow-lg transition-shadow flex items-center gap-1.5">
            <Minus size={13} strokeWidth={3} /> <span className="font-mono">{diffs.filter(d => d.type === 'DELETE').length}</span> Deleted
          </span>
        </div>
      </div>

      <div className="flex-1 overflow-auto scrollbar-thin scrollbar-thumb-slate-300 dark:scrollbar-thumb-slate-600">
        <table className="w-full text-left text-xs font-mono border-collapse">
          <thead className="bg-gradient-to-b from-slate-100 via-slate-50 to-white dark:from-slate-900 dark:via-slate-850 dark:to-slate-800 text-slate-700 dark:text-dark-text-secondary sticky top-0 z-10 shadow-md">
            <tr>
              <th className="px-5 py-4 w-24 border-b border-slate-200/80 dark:border-dark-border/60 font-bold uppercase text-[11px] tracking-wider bg-slate-50/50 dark:bg-dark-surface/30">
                <span className="flex items-center gap-1.5">
                  🔄 <span>Type</span>
                </span>
              </th>
              {columns.map(c => (
                <th key={c.key} className="px-5 py-4 border-b border-r border-slate-200/60 dark:border-dark-border/40 last:border-r-0 whitespace-nowrap font-bold uppercase text-[11px] tracking-wider hover:bg-blue-50/30 dark:hover:bg-blue-900/10 transition-colors">
                  {c.label}
                </th>
              ))}
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-200/60 dark:divide-slate-700/40">
            {diffs.map((diff, i) => {
              if (diff.type === 'UPDATE') {
                return (
                  <tr key={i} className="bg-gradient-to-r from-amber-50/60 via-orange-50/40 to-transparent hover:from-amber-100/70 hover:via-orange-100/50 hover:to-amber-50/20 dark:from-amber-900/8 dark:via-orange-900/5 dark:to-transparent dark:hover:from-amber-900/15 dark:hover:via-orange-900/10 dark:hover:to-amber-900/5 transition-all duration-200 group">
                    <td className="px-5 py-4 font-black text-amber-700 dark:text-amber-400 border-l-4 border-amber-500 dark:border-amber-600 shadow-inner bg-amber-100/40 dark:bg-amber-900/20">
                      <div className="flex items-center gap-2">
                        <Edit2 size={15} className="group-hover:scale-110 transition-transform" />
                        <span className="text-[11px] tracking-wide">MOD</span>
                      </div>
                    </td>
                    {columns.map(col => {
                      const valBefore = diff.before[col.key];
                      const valAfter = diff.after[col.key];
                      const changed = JSON.stringify(valBefore) !== JSON.stringify(valAfter);
                      return (
                        <td key={col.key} className="px-5 py-4 align-top border-r border-slate-200/40 dark:border-dark-border/30 last:border-r-0">
                          {changed ? (
                            <div className="flex flex-col gap-2">
                              <div className="flex items-center gap-2">
                                <ArrowRight className="text-amber-600 dark:text-amber-400 flex-shrink-0" size={13} strokeWidth={2.5} />
                                <span className="text-amber-900 dark:text-amber-200 font-bold bg-gradient-to-br from-amber-200 via-orange-200 to-amber-100 dark:from-amber-900/80 dark:via-orange-900/70 dark:to-amber-900/60 px-2.5 py-1.5 rounded-md border border-amber-400/60 dark:border-amber-700/50 shadow-sm">
                                  {valAfter === null ? <span className="italic text-[10px]">NULL</span> : valAfter}
                                </span>
                              </div>
                              <div className="flex items-center gap-2 ml-5">
                                <span className="text-[9px] text-slate-500 dark:text-dark-text-muted font-semibold">was:</span>
                                <span className="text-slate-500 dark:text-dark-text-secondary line-through text-[10px] opacity-60">
                                  {valBefore === null ? <span className="italic">NULL</span> : valBefore}
                                </span>
                              </div>
                            </div>
                          ) : (
                            <span className="text-slate-600 dark:text-dark-text-secondary opacity-40">
                              {valAfter === null ? <span className="italic text-[10px]">NULL</span> : valAfter}
                            </span>
                          )}
                        </td>
                      )
                    })}
                  </tr>
                )
              }
              if (diff.type === 'INSERT') {
                return (
                  <tr key={i} className="bg-gradient-to-r from-emerald-50/60 via-green-50/40 to-transparent hover:from-emerald-100/70 hover:via-green-100/50 hover:to-emerald-50/20 dark:from-emerald-900/8 dark:via-green-900/5 dark:to-transparent dark:hover:from-emerald-900/15 dark:hover:via-green-900/10 dark:hover:to-emerald-900/5 transition-all duration-200 group">
                    <td className="px-5 py-4 font-black text-emerald-700 dark:text-emerald-400 border-l-4 border-emerald-500 dark:border-emerald-600 shadow-inner bg-emerald-100/40 dark:bg-emerald-900/20">
                      <div className="flex items-center gap-2">
                        <Plus size={15} strokeWidth={3} className="group-hover:scale-110 transition-transform" />
                        <span className="text-[11px] tracking-wide">ADD</span>
                      </div>
                    </td>
                    {columns.map(col => (
                      <td key={col.key} className="px-5 py-4 text-slate-800 dark:text-dark-text-primary font-semibold border-r border-slate-200/40 dark:border-dark-border/30 last:border-r-0">
                        {diff.data[col.key] === null ? <span className="italic text-[10px] text-slate-400">NULL</span> : diff.data[col.key]}
                      </td>
                    ))}
                  </tr>
                )
              }
              // DELETE
              return (
                <tr key={i} className="bg-gradient-to-r from-red-50/60 via-rose-50/40 to-transparent hover:from-red-100/70 hover:via-rose-100/50 hover:to-red-50/20 dark:from-red-900/8 dark:via-rose-900/5 dark:to-transparent dark:hover:from-red-900/15 dark:hover:via-rose-900/10 dark:hover:to-red-900/5 transition-all duration-200 group">
                  <td className="px-5 py-4 font-black text-red-700 dark:text-accent-orange-400 border-l-4 border-red-500 dark:border-red-600 shadow-inner bg-red-100/40 dark:bg-red-900/20">
                    <div className="flex items-center gap-2">
                      <Minus size={15} strokeWidth={3} className="group-hover:scale-110 transition-transform" />
                      <span className="text-[11px] tracking-wide">DEL</span>
                    </div>
                  </td>
                  {columns.map(col => (
                    <td key={col.key} className="px-5 py-4 line-through text-red-600 dark:text-accent-orange-400/70 opacity-70 border-r border-slate-200/40 dark:border-dark-border/30 last:border-r-0">
                      {diff.data[col.key] === null ? <span className="italic text-[10px]">NULL</span> : diff.data[col.key]}
                    </td>
                  ))}
                </tr>
              )
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default DiffView;