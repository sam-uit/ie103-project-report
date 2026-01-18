import React, { useState, useEffect } from 'react';
import { FileText, Loader2 } from 'lucide-react';

interface HtmlViewerProps {
      content?: string;
      filePath?: string;
      title?: string;
      className?: string;
}

const HtmlViewer: React.FC<HtmlViewerProps> = ({
      content,
      filePath,
      title = "Problem Description",
      className = ""
}) => {
      const [html, setHtml] = useState<string>(content || '');
      const [loading, setLoading] = useState<boolean>(false);
      const [error, setError] = useState<string>('');

      useEffect(() => {
            if (content) {
                  setHtml(content);
                  return;
            }

            if (filePath) {
                  setLoading(true);
                  setError('');

                  fetch(`/sql-demo/${filePath}`)
                        .then(res => {
                              if (!res.ok) throw new Error(`Failed to load: ${res.statusText}`);
                              return res.text();
                        })
                        .then(text => {
                              setHtml(text);
                              setLoading(false);
                        })
                        .catch(err => {
                              console.error('Error loading HTML:', err);
                              setError(`Failed to load HTML file: ${err.message}`);
                              setLoading(false);
                        });
            }
      }, [content, filePath]);

      // Extract body content and style from HTML
      const processHtml = (htmlString: string) => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(htmlString, 'text/html');

            // Get body content
            const bodyContent = doc.body?.innerHTML || htmlString;

            // Get style content
            const styleTag = doc.querySelector('style');
            let scopedCss = '';

            if (styleTag) {
                  // Scope all CSS rules to .html-viewer-content
                  const cssText = styleTag.textContent || '';
                  scopedCss = cssText
                        .split('}')
                        .map(rule => {
                              if (!rule.trim()) return '';
                              const trimmedRule = rule.trim();
                              // Add .html-viewer-content prefix to each selector
                              const parts = trimmedRule.split('{');
                              if (parts.length === 2) {
                                    const selectors = parts[0].split(',').map(s => `.html-viewer-content ${s.trim()}`).join(', ');
                                    return `${selectors} { ${parts[1]}`;
                              }
                              return trimmedRule;
                        })
                        .filter(r => r)
                        .join(' }\n') + ' }';
            }

            return { bodyContent, scopedCss };
      };

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
                                    <h3 className="text-sm font-semibold text-red-800 dark:text-red-300">Error Loading HTML</h3>
                                    <p className="text-xs text-red-600 dark:text-accent-orange-400 mt-1">{error}</p>
                              </div>
                        </div>
                  </div>
            );
      }

      const { bodyContent, scopedCss } = processHtml(html);

      // NO HEADER - just content with dark theme
      return (
            <div className="flex flex-col h-full bg-[#0f172a]">
                  {/* Content - full height */}
                  <div className="flex-1 overflow-auto p-4 scrollbar-thin">
                        {/* Dark theme override CSS - FORCE dark backgrounds and light text */}
                        <style dangerouslySetInnerHTML={{
                              __html: `
                              /* FORCE DARK THEME - Override all HTML file styles */
                              .html-viewer-content * {
                                    background: transparent !important;
                                    border-color: #475569 !important;
                              }
                              
                              .html-viewer-content body {
                                    background: transparent !important;
                                    color: #cbd5e1 !important;
                              }
                              
                              /* Headings - dark theme colors */
                              .html-viewer-content h1 {
                                    color: #60a5fa !important;
                                    border-bottom-color: #334155 !important;
                              }
                              .html-viewer-content h2 {
                                    color: #f87171 !important;
                              }
                              .html-viewer-content h3 {
                                    color: #a78bfa !important;
                              }
                              .html-viewer-content h4 {
                                    color: #cbd5e1 !important;
                              }
                              
                              /* Text */
                              .html-viewer-content p,
                              .html-viewer-content li {
                                    color: #94a3b8 !important;
                              }
                              .html-viewer-content strong {
                                    color: #fbbf24 !important;
                              }
                              
                              /* Tables - dark theme */
                              .html-viewer-content table {
                                    background: transparent !important;
                                    box-shadow: none !important;
                              }
                              .html-viewer-content th {
                                    background: #1e3a8a !important;
                                    color: #fff !important;
                                    border-bottom-color: #475569 !important;
                              }
                              .html-viewer-content td {
                                    background: transparent !important;
                                    color: #cbd5e1 !important;
                                    border-bottom-color: #334155 !important;
                              }
                              .html-viewer-content tbody tr:hover {
                                    background: #1e293b !important;
                              }
                              
                              /* Code */
                              .html-viewer-content code {
                                    background: #1e293b !important;
                                    color: #34d399 !important;
                              }
                              .html-viewer-content pre {
                                    background: #1e293b !important;
                                    color: #e2e8f0 !important;
                              }
                              
                              /* Flow steps and warnings - dark theme */
                              .html-viewer-content .flow-step {
                                    background: #1e293b !important;
                                    border-left-color: #60a5fa !important;
                                    color: #cbd5e1 !important;
                              }
                              .html-viewer-content .warning {
                                    background: #422006 !important;
                                    border-left-color: #f59e0b !important;
                                    color: #fbbf24 !important;
                              }
                              
                              /* HR */
                              .html-viewer-content hr {
                                    border-top-color: #334155 !important;
                              }
                        ` }} />

                        {/* Scoped CSS from HTML file (will be overridden by dark theme) */}
                        {scopedCss && <style dangerouslySetInnerHTML={{ __html: scopedCss }} />}

                        {/* HTML content wrapped in scoped container */}
                        <div className="html-viewer-content" dangerouslySetInnerHTML={{ __html: bodyContent }} />
                  </div>
            </div>
      );
};

export default HtmlViewer;
