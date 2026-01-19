import React, { useState } from 'react';
import { useConfig } from '../contexts/ConfigContext';
import { FileText, Image as ImageIcon, X, Eye, ExternalLink, Cloud, Sparkles } from 'lucide-react';

const Reports: React.FC = () => {
  const { config, loading } = useConfig();
  const [selectedFile, setSelectedFile] = useState<any>(null);

  const getPreviewUrl = (url: string) => {
    // Logic to convert Google Drive View/Share links to Preview/Embed links
    if (url.includes('drive.google.com') && (url.includes('/view') || url.includes('/edit'))) {
      return url.replace(/\/view.*$/, '/preview').replace(/\/edit.*$/, '/preview');
    }
    return url;
  };

  const openPreview = (file: any, groupName: string) => {
    setSelectedFile({
      ...file,
      groupName: groupName,
      previewUrl: getPreviewUrl(file.url)
    });
  };

  const closePreview = () => {
    setSelectedFile(null);
  };

  const reportGroups = config?.reportGroups || [];

  if (loading) return <div className="p-8">Loading reports...</div>;

  return (
    <div className="h-full overflow-y-auto bg-gradient-to-br from-slate-50 via-slate-100 to-slate-200 dark:from-dark-bg dark:via-dark-surface dark:to-dark-bg relative">
      <div className="max-w-7xl mx-auto p-8 flex flex-col gap-10">

        {/* Modern Header with Glassmorphism */}
        <div className="relative">
          {/* Gradient Overlay */}
          <div className="absolute inset-0 bg-gradient-to-r from-primary-500/10 via-accent-purple-500/10 to-accent-cyan-500/10 dark:from-primary-500/5 dark:via-accent-purple-500/5 dark:to-accent-cyan-500/5 blur-3xl"></div>

          <div className="relative backdrop-blur-xl bg-white/80 dark:bg-dark-surface/80 border border-slate-200/50 dark:border-dark-border/50 rounded-3xl p-8 shadow-2xl">
            <div className="flex items-center gap-4 mb-3">
              <div className="p-3 rounded-2xl bg-gradient-to-br from-accent-purple-500 to-accent-cyan-500 shadow-lg shadow-accent-purple-500/30">
                <Sparkles className="text-white" size={28} strokeWidth={2.5} />
              </div>
              <div>
                <h1 className="text-3xl font-bold bg-gradient-to-r from-slate-900 to-slate-700 dark:from-dark-text-primary dark:to-dark-text-secondary bg-clip-text text-transparent">
                  Trình Bày Thông Tin
                </h1>
                <p className="text-slate-600 dark:text-dark-text-secondary mt-1 text-base font-medium">
                  Kho lưu trữ báo cáo, biểu đồ. Dữ liệu được cấu hình động theo từng nhóm.
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Groups Loop */}
        <div className="flex flex-col gap-12 pb-10">
          {reportGroups.length === 0 && <div className="text-slate-400 italic">Chưa có nhóm báo cáo nào trong config.json</div>}

          {reportGroups.map((group, groupIndex) => (
            <div key={group.id} className="flex flex-col gap-6 animate-in fade-in slide-in-from-bottom-4 duration-500" style={{ animationDelay: `${groupIndex * 100}ms` }}>
              {/* Group Header with Gradient */}
              <div className="relative">
                <div className="absolute inset-0 bg-gradient-to-r from-primary-500/10 to-accent-cyan-500/10 blur-xl rounded-2xl"></div>
                <div className="relative backdrop-blur-xl bg-white/80 dark:bg-white/10 border-l-4 border-primary-500 pl-6 pr-6 py-4 rounded-r-2xl shadow-lg">
                  <div className="flex items-center justify-between">
                    <div>
                      <h2 className="text-2xl font-bold bg-gradient-to-r from-primary-600 to-accent-cyan-600 dark:from-primary-400 dark:to-accent-cyan-400 bg-clip-text text-transparent flex items-center gap-3">
                        {group.title}
                        <span className="text-sm font-bold px-3 py-1 rounded-xl bg-gradient-to-r from-primary-50 to-accent-cyan-50 dark:from-primary-500/20 dark:to-accent-cyan-500/20 text-primary-600 dark:text-primary-400 shadow-sm">
                          {group.files.length} files
                        </span>
                      </h2>
                      <p className="text-slate-600 dark:text-dark-text-secondary text-sm mt-1 max-w-3xl leading-relaxed">
                        {group.description}
                      </p>
                    </div>
                  </div>
                </div>
              </div>

              {/* Files Grid with 3D Cards */}
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                {group.files.length === 0 && <span className="text-slate-400 text-sm italic col-span-full ml-4">Danh sách trống.</span>}

                {group.files.map((file, fileIndex) => {
                  const isGoogleDrive = file.url.includes('drive.google.com');
                  return (
                    <div
                      key={file.id}
                      className="group relative flex flex-col rounded-2xl border border-slate-200/50 dark:border-dark-border/50 backdrop-blur-xl bg-white/90 dark:bg-white/10 overflow-hidden hover:shadow-2xl hover:scale-105 hover:border-primary-500/50 dark:hover:border-primary-500/50 transition-all duration-300 cursor-pointer"
                      onClick={() => openPreview(file, group.title)}
                      style={{ animationDelay: `${fileIndex * 50}ms` }}
                    >
                      {/* Glow Effect on Hover */}
                      <div className="absolute inset-0 bg-gradient-to-r from-primary-500/20 to-accent-cyan-500/20 blur-xl rounded-2xl opacity-0 group-hover:opacity-100 transition-opacity"></div>

                      {/* Thumbnail Container */}
                      <div className="relative h-48 bg-slate-100 dark:bg-slate-800/50 overflow-hidden flex items-center justify-center">
                        {file.thumbnailUrl ? (
                          <img
                            src={file.thumbnailUrl}
                            alt={file.name}
                            className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                            onError={(e) => {
                              // Fallback if image fails
                              (e.target as HTMLImageElement).style.display = 'none';
                              (e.target as HTMLImageElement).nextElementSibling?.classList.remove('hidden');
                            }}
                          />
                        ) : (
                          <div className="w-full h-full flex items-center justify-center bg-slate-100 dark:bg-slate-800/50 text-slate-300">
                            {file.type === 'pdf' ? <FileText size={48} /> : <ImageIcon size={48} />}
                          </div>
                        )}

                        {/* Fallback Icon Container */}
                        <div className={`hidden w-full h-full flex items-center justify-center bg-slate-100 dark:bg-slate-800/50 text-slate-300 absolute inset-0 ${!file.thumbnailUrl ? '!flex' : ''}`}>
                          {file.type === 'pdf' ? <FileText size={48} /> : <ImageIcon size={48} />}
                        </div>

                        {/* Type Badge */}
                        <div className="absolute top-3 left-3 px-2.5 py-1 bg-black/70 backdrop-blur-sm rounded-lg text-xs font-bold text-white uppercase tracking-wider flex items-center gap-1.5 z-10 shadow-lg">
                          {file.type === 'pdf' ? <FileText size={12} className="text-red-400" /> : <ImageIcon size={12} className="text-blue-400" />}
                          {file.type}
                        </div>

                        {/* Drive Badge */}
                        {isGoogleDrive && (
                          <div className="absolute top-3 right-3 px-2.5 py-1 bg-blue-600/90 backdrop-blur-sm rounded-lg text-xs font-bold text-white flex items-center gap-1 z-10 shadow-lg">
                            <Cloud size={12} /> Drive
                          </div>
                        )}

                        {/* Hover Overlay */}
                        <div className="absolute inset-0 bg-slate-900/50 opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex items-center justify-center gap-2 backdrop-blur-sm z-20">
                          <button className="bg-white hover:bg-white/90 text-slate-900 px-5 py-2.5 rounded-xl font-bold text-sm flex items-center gap-2 shadow-xl transform translate-y-2 group-hover:translate-y-0 transition-all">
                            <Eye size={16} strokeWidth={2.5} /> Xem trước
                          </button>
                        </div>
                      </div>

                      {/* Card Footer */}
                      <div className="relative p-4 flex flex-col gap-2 border-t border-slate-200/50 dark:border-dark-border/50 z-10">
                        <div className="flex justify-between items-start">
                          <h3 className="text-sm font-bold text-slate-800 dark:text-white truncate pr-2 group-hover:text-primary-600 dark:group-hover:text-primary-400 transition-colors" title={file.name}>
                            {file.name}
                          </h3>
                        </div>
                        <div className="flex justify-between text-xs text-slate-500 dark:text-dark-text-secondary font-mono mt-1">
                          <span className="px-2 py-1 rounded-lg bg-slate-100 dark:bg-slate-800/50 font-semibold">{file.size || 'N/A'}</span>
                          <span className="px-2 py-1">{file.date || '-'}</span>
                        </div>
                      </div>
                    </div>
                  )
                })}
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Modern Preview Modal */}
      {selectedFile && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/95 backdrop-blur-md p-4 md:p-8 animate-in fade-in duration-200">
          <button
            onClick={(e) => { e.stopPropagation(); closePreview(); }}
            className="absolute top-4 right-4 md:top-6 md:right-6 p-3 rounded-xl bg-white/10 hover:bg-white/20 text-white transition-all hover:scale-110 z-50 shadow-xl"
          >
            <X size={24} strokeWidth={2.5} />
          </button>

          <div className="relative w-full h-full max-w-6xl max-h-[90vh] flex flex-col bg-transparent rounded-2xl overflow-hidden shadow-2xl ring-1 ring-white/10" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between bg-slate-900/95 backdrop-blur-xl text-white px-6 py-4 border-b border-white/10">
              <div className="flex items-center gap-3">
                {selectedFile.type === 'pdf' ? <FileText size={22} className="text-red-400" strokeWidth={2.5} /> : <ImageIcon size={22} className="text-blue-400" strokeWidth={2.5} />}
                <div className="flex flex-col">
                  <span className="font-bold truncate max-w-md text-base">{selectedFile.name}</span>
                  <span className="text-xs text-slate-400">{selectedFile.groupName}</span>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <a
                  href={selectedFile.url}
                  target="_blank"
                  rel="noreferrer"
                  className="p-2.5 hover:bg-white/10 rounded-xl text-slate-300 hover:text-white transition-all"
                  title="Open in new tab"
                >
                  <ExternalLink size={20} strokeWidth={2.5} />
                </a>
              </div>
            </div>

            <div className="flex-1 bg-black flex items-center justify-center overflow-hidden relative">
              <iframe
                src={selectedFile.previewUrl}
                className="w-full h-full bg-white"
                title="File Preview"
                allow="autoplay"
              />
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default Reports;