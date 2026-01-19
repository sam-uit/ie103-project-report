import React from 'react';
import { Copy, Download, Code } from 'lucide-react';

interface SqlViewerProps {
  content: string;
}

const SqlViewer: React.FC<SqlViewerProps> = ({ content }) => {
  // Simple syntax highlighting via regex splitting (visual simulation)
  const renderCode = (code: string) => {
    return code.split('\n').map((line, i) => (
      <div key={i} className="table-row hover:bg-slate-800/50">
        <span className="table-cell text-right pr-3 text-slate-600 select-none w-6 text-[10px] align-middle">{i + 1}</span>
        <span className="table-cell whitespace-pre text-slate-300 align-middle">
          {line.split(' ').map((word, j) => {
            const keywords = ['CREATE', 'PROCEDURE', 'TABLE', 'SELECT', 'FROM', 'WHERE', 'UPDATE', 'SET', 'INSERT', 'INTO', 'VALUES', 'BEGIN', 'END', 'AS', 'INT', 'DATE', 'IF', 'THROW', 'DECLARE', 'MONEY', 'RETURN', 'FUNCTION', 'TRIGGER', 'ON', 'AFTER'];
            const isKeyword = keywords.includes(word.toUpperCase());
            const isVar = word.startsWith('@');
            const isString = word.startsWith("'") || word.endsWith("'");

            let colorClass = 'text-slate-300';
            if (isKeyword) colorClass = 'text-blue-400 font-semibold';
            if (isVar) colorClass = 'text-teal-300';
            if (isString) colorClass = 'text-orange-300';

            return <span key={j} className={colorClass}>{word} </span>
          })}
        </span>
      </div>
    ));
  };

  return (
    <div className="flex flex-col h-full bg-[#0f172a]">
      <div className="flex items-center justify-between px-3 py-1.5 bg-slate-100 dark:bg-dark-surface border-b border-slate-200 dark:border-dark-border flex-shrink-0">
        <div className="flex items-center gap-1.5">
          <Code size={12} className="text-slate-500" />
          <span className="text-[10px] font-bold uppercase tracking-wider text-slate-500 dark:text-dark-text-secondary">SQL Source</span>
        </div>
        <div className="flex gap-1">
          <button className="p-1 hover:bg-slate-200 dark:hover:bg-dark-hover rounded text-slate-500 transition-colors" title="Copy SQL">
            <Copy size={12} />
          </button>
        </div>
      </div>
      <div className="flex-1 overflow-auto p-2 font-mono text-[11px] leading-relaxed scrollbar-thin">
        <div className="table w-full">
          {renderCode(content)}
        </div>
      </div>
    </div>
  );
};

export default SqlViewer;