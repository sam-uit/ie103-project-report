import React, { useState, useEffect } from 'react';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import { FileText, Loader2 } from 'lucide-react';

interface MarkdownViewerProps {
      content?: string;
      filePath?: string;
      title?: string;
      className?: string;
}

const MarkdownViewer: React.FC<MarkdownViewerProps> = ({
      content,
      filePath,
      title = "Problem Description",
      className = ""
}) => {
      const [markdown, setMarkdown] = useState<string>(content || '');
      const [loading, setLoading] = useState<boolean>(false);
      const [error, setError] = useState<string>('');

      useEffect(() => {
            if (content) {
                  setMarkdown(content);
                  return;
            }

            if (filePath) {
                  setLoading(true);
                  setError('');

                  // Load markdown file from sql-demo folder
                  fetch(`${import.meta.env.BASE_URL}sql-demo/${filePath}`)
                        .then(res => {
                              if (!res.ok) throw new Error(`Failed to load: ${res.statusText}`);
                              return res.text();
                        })
                        .then(text => {
                              setMarkdown(text);
                              setLoading(false);
                        })
                        .catch(err => {
                              console.error('Error loading markdown:', err);
                              setError(`Failed to load markdown file: ${err.message}`);
                              setLoading(false);
                        });
            }
      }, [content, filePath]);

      if (loading) {
            return (
                  <div className={`bg-white dark:bg-dark-surface border border-slate-300 dark:border-dark-border rounded-lg p-6 ${className}`}>
                        <div className="flex items-center justify-center gap-3 text-slate-500">
                              <Loader2 className="animate-spin" size={20} />
                              <span className="text-sm">Loading problem description...</span>
                        </div>
                  </div>
            );
      }

      if (error) {
            return (
                  <div className={`bg-red-50 dark:bg-red-900/20 border border-red-300 dark:border-red-800 rounded-lg p-6 ${className}`}>
                        <div className="flex items-start gap-3">
                              <FileText className="text-accent-orange-500 flex-shrink-0 mt-1" size={20} />
                              <div>
                                    <h3 className="text-sm font-semibold text-red-800 dark:text-red-300">Error Loading Markdown</h3>
                                    <p className="text-xs text-red-600 dark:text-accent-orange-400 mt-1">{error}</p>
                              </div>
                        </div>
                  </div>
            );
      }

      return (
            <div className={`flex flex-col h-full bg-white dark:bg-dark-surface border border-slate-300 dark:border-dark-border rounded-lg overflow-hidden ${className}`}>
                  {/* Header */}
                  <div className="flex-none bg-gradient-to-r from-blue-50 to-indigo-50 dark:from-blue-900/20 dark:to-indigo-900/20 border-b border-slate-200 dark:border-dark-border px-4 py-3">
                        <div className="flex items-center gap-2">
                              <FileText className="text-blue-600 dark:text-primary-400" size={18} />
                              <h3 className="text-sm font-bold text-slate-800 dark:text-dark-text-primary">{title}</h3>
                        </div>
                  </div>

                  {/* Markdown Content */}
                  <div className="flex-1 overflow-y-auto p-8 bg-white dark:bg-dark-surface">
                        <div className="prose prose-lg dark:prose-invert max-w-none
        prose-headings:font-bold
        prose-h1:text-3xl prose-h1:mb-6 prose-h1:pb-3 prose-h1:border-b-2 prose-h1:border-blue-500 prose-h1:text-blue-700 dark:prose-h1:text-blue-400
        prose-h2:text-2xl prose-h2:mt-8 prose-h2:mb-4 prose-h2:text-slate-800 dark:prose-h2:text-slate-100
        prose-h3:text-xl prose-h3:mt-6 prose-h3:mb-3 prose-h3:text-slate-700 dark:prose-h3:text-slate-200
        prose-p:text-slate-600 dark:prose-p:text-slate-300 prose-p:leading-relaxed prose-p:my-4
        prose-a:text-blue-600 dark:prose-a:text-blue-400 prose-a:font-medium hover:prose-a:underline
        prose-strong:text-slate-900 dark:prose-strong:text-white prose-strong:font-bold
        prose-em:text-slate-700 dark:prose-em:text-slate-300 prose-em:italic
        prose-code:text-pink-600 dark:prose-code:text-pink-400 prose-code:bg-pink-50 dark:prose-code:bg-pink-950 prose-code:px-2 prose-code:py-1 prose-code:rounded prose-code:text-sm prose-code:font-mono prose-code:before:content-none prose-code:after:content-none
        prose-pre:bg-slate-900 dark:prose-pre:bg-black prose-pre:text-slate-100 prose-pre:p-5 prose-pre:rounded-xl prose-pre:overflow-x-auto prose-pre:border prose-pre:border-slate-700 prose-pre:shadow-lg prose-pre:my-6
        prose-ul:my-4 prose-ul:list-disc prose-ul:pl-6 prose-ul:text-slate-600 dark:prose-ul:text-slate-300
        prose-ol:my-4 prose-ol:list-decimal prose-ol:pl-6 prose-ol:text-slate-600 dark:prose-ol:text-slate-300
        prose-li:my-2 prose-li:leading-relaxed
        prose-table:border-collapse prose-table:w-full prose-table:my-6 prose-table:text-sm prose-table:shadow-sm
        prose-thead:bg-blue-50 dark:prose-thead:bg-blue-950
        prose-th:bg-blue-100 dark:prose-th:bg-blue-900/50 prose-th:border prose-th:border-slate-300 dark:prose-th:border-slate-600 prose-th:px-4 prose-th:py-3 prose-th:text-left prose-th:font-bold prose-th:text-slate-800 dark:prose-th:text-slate-100
        prose-td:border prose-td:border-slate-300 dark:prose-td:border-slate-600 prose-td:px-4 prose-td:py-3 prose-td:text-slate-700 dark:prose-td:text-slate-300
        prose-tr:even:bg-slate-50 dark:prose-tr:even:bg-slate-900/30
        prose-blockquote:border-l-4 prose-blockquote:border-blue-500 prose-blockquote:bg-blue-50 dark:prose-blockquote:bg-blue-950 prose-blockquote:pl-6 prose-blockquote:py-3 prose-blockquote:my-6 prose-blockquote:italic prose-blockquote:text-slate-600 dark:prose-blockquote:text-slate-400 prose-blockquote:rounded-r
        prose-hr:border-slate-300 dark:prose-hr:border-slate-700 prose-hr:my-8
        prose-img:rounded-lg prose-img:shadow-md prose-img:my-6
      ">
                              <ReactMarkdown
                                    remarkPlugins={[remarkGfm]}
                                    components={{
                                          table: ({ node, ...props }) => (
                                                <table className="border-collapse w-full my-6 text-sm shadow-sm" {...props} />
                                          ),
                                          thead: ({ node, ...props }) => (
                                                <thead className="bg-blue-50 dark:bg-blue-950" {...props} />
                                          ),
                                          th: ({ node, ...props }) => (
                                                <th className="bg-blue-100 dark:bg-blue-900/50 border border-slate-300 dark:border-dark-border px-4 py-3 text-left font-bold text-slate-800 dark:text-dark-text-primary" {...props} />
                                          ),
                                          td: ({ node, ...props }) => (
                                                <td className="border border-slate-300 dark:border-dark-border px-4 py-3 text-slate-700 dark:text-dark-text-secondary" {...props} />
                                          ),
                                          tr: ({ node, ...props }) => (
                                                <tr className="even:bg-slate-50 dark:even:bg-slate-900/30" {...props} />
                                          ),
                                    }}
                              >
                                    {markdown}
                              </ReactMarkdown>
                        </div>
                  </div>
            </div>
      );
};

export default MarkdownViewer;
