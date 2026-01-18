import React, { useState, useEffect, useRef } from 'react';
import { useParams } from 'react-router-dom';
import { useConfig } from '../contexts/ConfigContext';
import { api } from '../services/api';
import SqlViewer from '../components/SqlViewer';
import MarkdownViewer from '../components/MarkdownViewer';
import HtmlViewer from '../components/HtmlViewer';
import TableSnapshot from '../components/TableSnapshot';
import DiffView from '../components/DiffView';
import {
      Play, RotateCcw, ChevronRight, Loader2, Database, ArrowRight, ArrowDown, RefreshCcw, AlertCircle, ChevronUp, ChevronDown, FileText, Code
} from 'lucide-react';

const ScenarioDetail: React.FC = () => {
      const { id } = useParams<{ id: string }>();
      const { config, loading, backendOnline } = useConfig();

      // Meta state
      const [scenarioMeta, setScenarioMeta] = useState<any>(null);
      const [sqlContent, setSqlContent] = useState<string>('-- Loading script...');

      // Input State & Validation
      const [paramValues, setParamValues] = useState<Record<string, string>>({});
      const [paramErrors, setParamErrors] = useState<Record<string, string>>({});

      // Data state
      const [initialData, setInitialData] = useState<any[]>([]); // Full table data (no filter)
      const [beforeData, setBeforeData] = useState<any[]>([]);
      const [afterData, setAfterData] = useState<any[]>([]);
      const [separateTablesInitial, setSeparateTablesInitial] = useState<Record<string, any[]>>({});
      const [separateTablesBefore, setSeparateTablesBefore] = useState<Record<string, any[]>>({});
      const [separateTablesAfter, setSeparateTablesAfter] = useState<Record<string, any[]>>({});
      const [separateTablesDiffs, setSeparateTablesDiffs] = useState<Record<string, any>>({});
      const [isFetchingInitial, setIsFetchingInitial] = useState(false);
      const [isFetchingBefore, setIsFetchingBefore] = useState(false);
      const [hasExecuted, setHasExecuted] = useState(false); // Track if executed

      // UI state
      const [isTablesCollapsed, setIsTablesCollapsed] = useState(true); // Start with tables hidden
      const [activeTableTab, setActiveTableTab] = useState<string>(''); // For separate tables tabs
      const [sqlViewerHeight, setSqlViewerHeight] = useState(250); // Height in pixels for SQL viewer
      const [isResizing, setIsResizing] = useState(false);
      const [activeResultTab, setActiveResultTab] = useState<'diff' | 'before' | 'after'>('diff');
      const [activeSourceTab, setActiveSourceTab] = useState<'problem' | 'sql'>('problem'); // Tab for problem.md vs SQL

      // Execution state
      const [status, setStatus] = useState<'idle' | 'loading_script' | 'running' | 'success' | 'error'>('loading_script');
      const [errorMessage, setErrorMessage] = useState<string>('');

      // Ref to prevent double requests and track mounted state
      const isMountedRef = useRef(true);
      const isExecutingRef = useRef(false);

      // 1. Initialize Scenario
      useEffect(() => {
            if (!id || loading) return;

            // Reset mounted flag when component mounts
            isMountedRef.current = true;

            const meta = config?.scenarios.find(s => s.id === id);
            if (meta) {
                  setScenarioMeta(meta);
                  setInitialData([]);
                  setBeforeData([]);
                  setAfterData([]);
                  setHasExecuted(false);
                  setStatus('idle');
                  setErrorMessage('');

                  // Set first table as active tab for separate tables
                  if (meta.separateTables && meta.separateTables.length > 0) {
                        setActiveTableTab(meta.separateTables[0].name);
                  }

                  // Initialize Params State
                  const initialValues: Record<string, string> = {};
                  meta.params?.forEach((p: any) => {
                        initialValues[p.name] = String(p.defaultValue ?? '');
                  });
                  setParamValues(initialValues);
                  setParamErrors({});

                  // Load SQL Content from demo folder
                  if (meta.sqlContent && meta.sqlContent.length > 20) {
                        // If inline SQL content exists in config, use it
                        setSqlContent(meta.sqlContent);
                  } else if (meta.sqlFile) {
                        // Load SQL from file in sql-demo folder
                        const fetchScript = async () => {
                              try {
                                    const response = await fetch(`/sql-demo/${meta.sqlFile}`);
                                    if (response.ok) {
                                          const sqlText = await response.text();
                                          setSqlContent(sqlText);
                                    } else {
                                          console.error(`Failed to load SQL file: ${meta.sqlFile}`);
                                          setSqlContent('-- Failed to load SQL script');
                                    }
                              } catch (error) {
                                    console.error('Error loading SQL file:', error);
                                    setSqlContent('-- Error loading SQL script');
                              }
                        };
                        fetchScript();
                  } else {
                        setSqlContent('-- No SQL script available');
                  }

                  // Don't load table data automatically - wait for user to click \"Show Tables\"
                  // fetchInitialData(meta);
            }

            // Cleanup function to prevent double execution in StrictMode
            return () => {
                  isMountedRef.current = false;
            };
      }, [id, config, loading]);

      // Validation Logic
      const validateInput = (value: string, type: string): string | null => {
            if (value === '' || value === undefined) {
                  // Allow empty strings for optional params
                  if (type === 'string') return null;
                  return 'Required';
            }

            if (type === 'int') {
                  const num = Number(value);
                  if (isNaN(num)) return 'Must be a number';
                  if (!Number.isInteger(num)) return 'Must be an integer';
            }
            if (type === 'decimal') {
                  if (isNaN(Number(value))) return 'Must be a valid number';
            }
            if (type === 'datetime' || type === 'date') {
                  // Basic datetime validation
                  if (!/^\d{4}-\d{2}-\d{2}/.test(value)) {
                        return 'Must be in format: YYYY-MM-DD HH:MM:SS';
                  }
            }
            return null;
      };

      const handleParamChange = (name: string, value: string, type: string) => {
            setParamValues(prev => ({ ...prev, [name]: value }));

            // Clear error on change
            if (paramErrors[name]) {
                  setParamErrors(prev => {
                        const newErrors = { ...prev };
                        delete newErrors[name];
                        return newErrors;
                  });
            }
      };

      // Helper to prepare params for API (converting strings to typed values)
      const prepareParams = (meta: any, values: Record<string, string>) => {
            if (!meta.params) return [];
            return meta.params.map((p: any) => {
                  const rawVal = values[p.name];
                  let finalVal: any = rawVal;

                  if (p.type === 'int') {
                        finalVal = parseInt(rawVal, 10);
                  } else if (p.type === 'decimal') {
                        finalVal = parseFloat(rawVal);
                  } else if (p.type === 'datetime' || p.type === 'date') {
                        // Keep as string, backend will convert to SQL DateTime
                        finalVal = rawVal;
                  } else if (p.type === 'boolean') {
                        finalVal = rawVal === 'true' || rawVal === '1';
                  }
                  // else keep as string

                  return { name: p.name, value: finalVal, type: p.type };
            });
      };

      // 2. Fetch Initial Full Table Data (no filter by params)
      const fetchInitialData = async (meta: any) => {
            if (!backendOnline || isFetchingInitial) return;

            setIsFetchingInitial(true);
            try {
                  if (meta.sqlFetchInitial) {
                        const data = await api.runQuery(meta.sqlFetchInitial, []);
                        if (isMountedRef.current) {
                              setInitialData(data);
                        }
                  }

                  // Fetch separate tables initial state
                  if (meta.separateTables) {
                        const results: Record<string, any[]> = {};
                        for (const table of meta.separateTables) {
                              const initialQuery = table.sqlBefore.replace(/WHERE.*$/i, '');
                              const data = await api.runQuery(initialQuery, []);
                              results[table.name] = data;
                        }
                        if (isMountedRef.current) {
                              setSeparateTablesInitial(results);
                        }
                  }
            } catch (e) {
                  console.error('Failed to fetch initial data', e);
            } finally {
                  if (isMountedRef.current) {
                        setIsFetchingInitial(false);
                  }
            }
      };

      // 2.1 Fetch data for a single separate table (lazy loading)
      const fetchSeparateTableData = async (tableDef: any) => {
            if (!backendOnline) return;

            try {
                  // Remove WHERE clause from sqlBefore to get all data initially
                  const initialQuery = tableDef.sqlBefore.replace(/WHERE.*$/i, '');
                  const data = await api.runQuery(initialQuery, []);
                  setSeparateTablesInitial(prev => ({ ...prev, [tableDef.name]: data }));
            } catch (e) {
                  console.error(`Failed to fetch data for table ${tableDef.name}`, e);
            }
      };

      // Handle tab change with lazy loading
      const handleTabChange = async (tableName: string) => {
            setActiveTableTab(tableName);

            // Check if data already loaded
            if (!separateTablesInitial[tableName] && scenarioMeta?.separateTables) {
                  const tableDef = scenarioMeta.separateTables?.find((t: any) => t.name === tableName);
                  if (tableDef) {
                        await fetchSeparateTableData(tableDef);
                  }
            }
      };

      // Resize handlers for SQL viewer
      const handleMouseDown = (e: React.MouseEvent) => {
            e.preventDefault();
            setIsResizing(true);
      };

      useEffect(() => {
            const handleMouseMove = (e: MouseEvent) => {
                  if (!isResizing) return;

                  // Calculate new height based on mouse Y position
                  const newHeight = e.clientY - 120; // Subtract header and controls height

                  // Limit between 150px and 600px
                  if (newHeight >= 150 && newHeight <= 600) {
                        setSqlViewerHeight(newHeight);
                  }
            };

            const handleMouseUp = () => {
                  setIsResizing(false);
            };

            if (isResizing) {
                  document.addEventListener('mousemove', handleMouseMove);
                  document.addEventListener('mouseup', handleMouseUp);
            }

            return () => {
                  document.removeEventListener('mousemove', handleMouseMove);
                  document.removeEventListener('mouseup', handleMouseUp);
            };
      }, [isResizing]);

      // 3. Fetch "Before" State Logic (with params, called before execute)
      const fetchBeforeState = async (meta: any, currentValues: Record<string, string>) => {
            if (!meta) return;

            const params = prepareParams(meta, currentValues);

            // Fetch separate tables if configured
            if (backendOnline && meta.separateTables) {
                  setIsFetchingBefore(true);
                  try {
                        const results: Record<string, any[]> = {};
                        for (const table of meta.separateTables) {
                              const data = await api.runQuery(table.sqlBefore, params);
                              results[table.name] = data;
                        }
                        setSeparateTablesBefore(results);
                  } catch (e) {
                        console.error("Failed to fetch separate tables before state", e);
                  } finally {
                        setIsFetchingBefore(false);
                  }
            }

            // Also fetch merged view if configured
            if (backendOnline && meta.sqlFetchBefore) {
                  setIsFetchingBefore(true);
                  try {
                        const data = await api.runQuery(meta.sqlFetchBefore, params);
                        setBeforeData(data);
                  } catch (e) {
                        console.error("Failed to fetch before state", e);
                        setBeforeData(meta.mockData?.before || []);
                  } finally {
                        setIsFetchingBefore(false);
                  }
            } else if (!meta.separateTables) {
                  // Use Mock Data if offline or no query config
                  setBeforeData(meta.mockData?.before || []);
            }
      };

      // 4. Execution Logic - Using unified executeDemo API
      const handleExecute = async () => {
            if (!scenarioMeta) return;

            // Prevent double execution
            if (isExecutingRef.current || status === 'running') {
                  console.log('⚠️ Execution already in progress, skipping...');
                  return;
            }

            // Validate all inputs first
            const newErrors: Record<string, string> = {};
            let isValid = true;

            scenarioMeta.params?.forEach((p: any) => {
                  const val = paramValues[p.name];
                  const error = validateInput(val, p.type);
                  if (error) {
                        newErrors[p.name] = error;
                        isValid = false;
                  }
            });

            if (!isValid) {
                  setParamErrors(newErrors);
                  return;
            }

            isExecutingRef.current = true;
            setStatus('running');
            setErrorMessage('');

            // UX: Clear previous results and auto-expand view
            setHasExecuted(false);
            setBeforeData([]);
            setAfterData([]);
            setSeparateTablesBefore({});
            setSeparateTablesAfter({});
            setSeparateTablesDiffs({});
            setSeparateTablesDiffs({});
            setIsTablesCollapsed(false); // Auto-show results area
            setActiveResultTab('diff'); // Reset to Diff view

            try {
                  const params = prepareParams(scenarioMeta, paramValues);

                  // Build before/after queries from scenario config
                  const beforeQueries: { name: string; query: string }[] = [];
                  const afterQueries: { name: string; query: string }[] = [];

                  // Use separateTables if configured
                  if (scenarioMeta.separateTables) {
                        for (const table of scenarioMeta.separateTables) {
                              if (table.sqlBefore) {
                                    beforeQueries.push({ name: table.name, query: table.sqlBefore });
                              }
                              if (table.sqlAfter) {
                                    afterQueries.push({ name: table.name, query: table.sqlAfter });
                              }
                        }
                  }

                  // Also add merged view queries if configured
                  if (scenarioMeta.sqlFetchBefore) {
                        beforeQueries.push({ name: '_merged', query: scenarioMeta.sqlFetchBefore });
                  }
                  if (scenarioMeta.sqlFetchAfter) {
                        afterQueries.push({ name: '_merged', query: scenarioMeta.sqlFetchAfter });
                  }

                  console.log('🚀 Executing demo with unified API...', { beforeQueries: beforeQueries.length, afterQueries: afterQueries.length });

                  // Call unified API - server handles everything
                  const response = await api.executeDemo(sqlContent, beforeQueries, afterQueries, params);
                  console.log('📦 Demo response:', response);

                  if (response.success) {
                        // Process response - populate state from server data
                        const { befores, afters } = response.data;

                        // Handle separate tables
                        if (scenarioMeta.separateTables) {
                              const beforeResults: Record<string, any[]> = {};
                              const afterResults: Record<string, any[]> = {};

                              for (const table of scenarioMeta.separateTables) {
                                    if (befores[table.name]) {
                                          beforeResults[table.name] = befores[table.name];
                                    }
                                    if (afters[table.name]) {
                                          afterResults[table.name] = afters[table.name];
                                    }
                              }

                              setSeparateTablesBefore(beforeResults);
                              setSeparateTablesAfter(afterResults);
                        }

                        // Handle merged view data
                        if (befores['_merged']) {
                              setBeforeData(befores['_merged']);
                        }
                        if (afters['_merged']) {
                              setAfterData(afters['_merged']);
                        }

                        if (response.data.diffs) {
                              setSeparateTablesDiffs(response.data.diffs);
                        }

                        setStatus('success');
                        setHasExecuted(true);
                  } else {
                        setStatus('error');
                        setErrorMessage(response.message || 'Unknown error occurred on server.');
                  }
            } catch (err: any) {
                  console.error('Execute error:', err);
                  const errorMsg = err?.response?.data?.error || err?.message || 'Lỗi không xác định khi thực thi';
                  setErrorMessage(errorMsg);
                  setStatus('error');
            } finally {
                  isExecutingRef.current = false;
            }
      };

      const handleReset = () => {
            setStatus('idle');
            setBeforeData([]);
            setAfterData([]);
            setSeparateTablesInitial({});
            setSeparateTablesBefore({});
            setSeparateTablesAfter({});
            setSeparateTablesDiffs({});
            setHasExecuted(false);
            setErrorMessage('');

            // Reset inputs to default
            const defaults: Record<string, string> = {};
            scenarioMeta?.params?.forEach((p: any) => {
                  defaults[p.name] = String(p.defaultValue ?? '');
            });
            setParamValues(defaults);
            setParamErrors({});

            // Reload initial full table data
            fetchInitialData(scenarioMeta);
      };

      if (loading) return <div className="p-8">Loading configuration...</div>;
      if (!scenarioMeta) return <div className="p-8">Scenario not found in config.json</div>;

      const pkField = scenarioMeta.columns?.find((c: any) => c.isPk)?.key || scenarioMeta.columns[0]?.key;

      return (
            <div className="flex flex-col h-full bg-slate-50 dark:bg-dark-bg">
                  {/* 1. Header Bar */}
                  <div className="flex-none px-4 py-2 border-b border-slate-200 dark:border-dark-border bg-white dark:bg-[#16181a] flex justify-between items-center shadow-sm z-30">
                        <div className="flex flex-col">
                              <div className="flex items-center gap-2 text-[10px] text-slate-500 uppercase tracking-wider font-bold">
                                    <span className="text-primary-600">{scenarioMeta.type}</span>
                                    <ChevronRight size={10} />
                                    <span>{scenarioMeta.id}</span>
                              </div>
                              <h1 className="text-sm font-bold text-slate-800 dark:text-slate-100">{scenarioMeta.title}</h1>
                        </div>
                        {/* Buttons removed - moved to SQL tab */}
                  </div>

                  {/* Error Alert */}
                  {errorMessage && (
                        <div className="flex-none mx-4 mt-2 p-4 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg">
                              <div className="flex items-start gap-3">
                                    <AlertCircle className="w-5 h-5 text-red-600 dark:text-red-400 mt-0.5 flex-shrink-0" />
                                    <div className="flex-1">
                                          <h3 className="text-sm font-semibold text-red-800 dark:text-red-300">Lỗi thực thi</h3>
                                          <p className="mt-1 text-sm text-red-700 dark:text-red-400">{errorMessage}</p>
                                    </div>
                                    <button
                                          onClick={() => setErrorMessage('')}
                                          className="text-red-400 hover:text-red-600 dark:hover:text-red-300 transition-colors"
                                          title="Đóng"
                                    >
                                          <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                                                <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
                                          </svg>
                                    </button>
                              </div>
                        </div>
                  )}

                  {/* 2. Main Layout - Conditional Grid based on collapse state */}
                  <div className="flex-1 flex flex-col p-2 gap-2 overflow-hidden">

                        {/* ROW 1: SQL Source & Params - Resizable */}
                        <div
                              className="flex gap-2 overflow-hidden transition-all duration-300 flex-shrink-0"
                              style={{ height: isTablesCollapsed ? 'calc(100% - 16px)' : `${sqlViewerHeight}px` }}
                        >
                              {/* Tabbed Viewer: Problem Description vs SQL Source */}
                              <div className="flex-1 flex flex-col rounded-lg border border-slate-300 dark:border-slate-700 overflow-hidden shadow-sm bg-white dark:bg-dark-surface">
                                    {/* Tab Headers - Redesigned for better UX */}
                                    <div className="flex items-center justify-between border-b-2 border-slate-700 dark:border-slate-600 bg-gradient-to-r from-slate-800 to-slate-900 dark:from-slate-900 dark:to-black h-14 flex-shrink-0 shadow-md">
                                          {/* Left: Tab buttons */}
                                          <div className="flex h-full">
                                                <button
                                                      onClick={() => setActiveSourceTab('problem')}
                                                      className={`h-full flex items-center gap-2.5 px-6 text-base font-bold transition-all duration-200 relative ${activeSourceTab === 'problem'
                                                            ? 'text-red-500 bg-slate-900 dark:bg-slate-950 scale-105 shadow-lg'
                                                            : 'text-slate-400 hover:text-slate-200 hover:bg-slate-700/50 dark:hover:bg-slate-800/50'
                                                            }`}
                                                >
                                                      <FileText size={20} strokeWidth={2.5} />
                                                      <span>Trình Bày Bài Toán</span>
                                                      {activeSourceTab === 'problem' && (
                                                            <div className="absolute bottom-0 left-0 right-0 h-1 bg-gradient-to-r from-red-500 to-red-600 shadow-lg shadow-red-500/50"></div>
                                                      )}
                                                </button>
                                                <button
                                                      onClick={() => setActiveSourceTab('sql')}
                                                      className={`h-full flex items-center gap-2.5 px-6 text-base font-bold transition-all duration-200 relative ${activeSourceTab === 'sql'
                                                            ? 'text-red-500 bg-slate-900 dark:bg-slate-950 scale-105 shadow-lg'
                                                            : 'text-slate-400 hover:text-slate-200 hover:bg-slate-700/50 dark:hover:bg-slate-800/50'
                                                            }`}
                                                >
                                                      <Code size={20} strokeWidth={2.5} />
                                                      <span>SQL Source</span>
                                                      {activeSourceTab === 'sql' && (
                                                            <div className="absolute bottom-0 left-0 right-0 h-1 bg-gradient-to-r from-red-500 to-red-600 shadow-lg shadow-red-500/50"></div>
                                                      )}
                                                </button>
                                          </div>

                                          {/* Right: Action buttons - Only show when SQL tab is active */}
                                          {activeSourceTab === 'sql' && (
                                                <div className="flex items-center gap-2 px-4">
                                                      <button
                                                            onClick={handleReset}
                                                            className="flex items-center gap-1.5 px-3 py-2 text-xs font-semibold text-slate-300 bg-slate-700 border border-slate-600 rounded-lg hover:bg-slate-600 hover:text-white hover:border-slate-500 transition-all shadow-sm hover:shadow-md"
                                                            title="Reset"
                                                      >
                                                            <RotateCcw size={14} strokeWidth={2.5} />
                                                            <span>Reset</span>
                                                      </button>
                                                      <button
                                                            onClick={() => {
                                                                  const newCollapsedState = !isTablesCollapsed;
                                                                  setIsTablesCollapsed(newCollapsedState);

                                                                  // Lazy load: fetch data when user first expands tables
                                                                  if (!newCollapsedState && initialData.length === 0 && Object.keys(separateTablesInitial).length === 0) {
                                                                        console.log('🔄 Lazy loading table data...');
                                                                        fetchInitialData(scenarioMeta);
                                                                  }
                                                            }}
                                                            className={`flex items-center gap-1.5 px-3 py-2 text-xs font-semibold rounded-lg transition-all shadow-sm hover:shadow-md ${isTablesCollapsed
                                                                  ? 'bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-500 hover:to-blue-600 text-white border border-blue-500'
                                                                  : 'bg-slate-700 text-slate-300 border border-slate-600 hover:bg-slate-600 hover:text-white hover:border-slate-500'
                                                                  }`}
                                                            title={isTablesCollapsed ? "Show tables" : "Hide tables"}
                                                      >
                                                            {isTablesCollapsed ? <ChevronDown size={14} strokeWidth={2.5} /> : <ChevronUp size={14} strokeWidth={2.5} />}
                                                            <span>{isTablesCollapsed ? 'Show Tables' : 'Hide Tables'}</span>
                                                      </button>
                                                      <button
                                                            onClick={handleExecute}
                                                            disabled={status === 'running' || status === 'loading_script'}
                                                            className="flex items-center gap-2 px-5 py-2 text-sm font-bold bg-gradient-to-r from-red-600 to-red-700 hover:from-red-500 hover:to-red-600 text-white rounded-lg shadow-md hover:shadow-xl transition-all active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed border border-red-500"
                                                      >
                                                            {status === 'running' ? <Loader2 size={16} className="animate-spin" strokeWidth={2.5} /> : <Play size={16} fill="currentColor" strokeWidth={2.5} />}
                                                            <span>EXECUTE</span>
                                                      </button>
                                                </div>
                                          )}
                                    </div>

                                    {/* Tab Content */}
                                    <div className="flex-1 overflow-hidden">
                                          {activeSourceTab === 'problem' ? (
                                                scenarioMeta.mdFile ? (
                                                      // Auto-detect file type and use appropriate viewer
                                                      scenarioMeta.mdFile.endsWith('.html') ? (
                                                            <HtmlViewer
                                                                  filePath={scenarioMeta.mdFile}
                                                                  title="Problem Description"
                                                            />
                                                      ) : (
                                                            <MarkdownViewer
                                                                  filePath={scenarioMeta.mdFile}
                                                                  title="Problem Description"
                                                            />
                                                      )
                                                ) : (
                                                      <div className="h-full flex items-center justify-center text-slate-400 text-sm">
                                                            <div className="text-center">
                                                                  <FileText size={48} className="mx-auto mb-3 opacity-30" />
                                                                  <p>No problem description available</p>
                                                                  <p className="text-xs mt-1">Add a problem.md or problem.html file to this demo</p>
                                                            </div>
                                                      </div>
                                                )
                                          ) : (
                                                <SqlViewer content={sqlContent} />
                                          )}
                                    </div>
                              </div>

                              {/* Params Panel - Only show when SQL Source tab is active */}
                              {activeSourceTab === 'sql' && (
                                    <div className="w-64 flex-shrink-0 bg-white dark:bg-dark-surface border border-slate-300 dark:border-slate-700 rounded-lg p-3 overflow-y-auto shadow-sm">
                                          <div className="flex items-center gap-2 mb-3 pb-2 border-b border-slate-100 dark:border-slate-700">
                                                <Database size={14} className="text-primary-500" />
                                                <h3 className="text-xs font-bold uppercase text-slate-700 dark:text-slate-300">Input Parameters</h3>
                                          </div>
                                          {scenarioMeta.params && scenarioMeta.params.length > 0 ? (
                                                <div className="space-y-3">
                                                      {scenarioMeta.params.map((param: any) => {
                                                            const hasError = !!paramErrors[param.name];
                                                            return (
                                                                  <div key={`${scenarioMeta.id}-${param.name}`} className="flex flex-col gap-1">
                                                                        <div className="flex justify-between items-baseline">
                                                                              <label className={`text-[10px] font-mono font-semibold transition-colors ${hasError ? 'text-red-500' : 'text-slate-600 dark:text-slate-400'}`} title={param.name}>
                                                                                    {param.name}
                                                                              </label>
                                                                              <span className="text-[9px] text-slate-400 italic">{param.type}</span>
                                                                        </div>
                                                                        <div className="relative">
                                                                              <input
                                                                                    type={param.type === 'int' || param.type === 'decimal' ? 'number' : 'text'}
                                                                                    value={paramValues[param.name] || ''}
                                                                                    onChange={(e) => handleParamChange(param.name, e.target.value, param.type)}
                                                                                    className={`
                                        w-full bg-slate-50 dark:bg-black/20 border rounded px-2 py-1 text-xs font-mono outline-none transition-all
                                        ${hasError
                                                                                                ? 'border-red-500 focus:ring-1 focus:ring-red-500 bg-red-50 dark:bg-red-900/10'
                                                                                                : 'border-slate-200 dark:border-slate-600 focus:ring-1 focus:ring-primary-500'
                                                                                          }
                                    `}
                                                                              />
                                                                              {hasError && (
                                                                                    <div className="absolute right-2 top-1.5 text-red-500 pointer-events-none">
                                                                                          <AlertCircle size={12} />
                                                                                    </div>
                                                                              )}
                                                                        </div>
                                                                        {hasError && (
                                                                              <span className="text-[9px] text-red-500 font-medium animate-in fade-in slide-in-from-top-1">
                                                                                    {paramErrors[param.name]}
                                                                              </span>
                                                                        )}
                                                                  </div>
                                                            )
                                                      })}
                                                </div>
                                          ) : (
                                                <div className="text-xs text-slate-400 italic text-center py-4">No parameters required.</div>
                                          )}
                                    </div>
                              )}
                        </div>

                        {/* Resize Handle - Only show when tables are visible */}
                        {!isTablesCollapsed && (
                              <div
                                    onMouseDown={handleMouseDown}
                                    className={`
                h-2 bg-gradient-to-b from-slate-200 via-slate-300 to-slate-200 
                dark:from-slate-700 dark:via-slate-600 dark:to-slate-700
                cursor-row-resize hover:bg-gradient-to-b hover:from-blue-300 hover:via-blue-400 hover:to-blue-300
                dark:hover:from-blue-700 dark:hover:via-blue-600 dark:hover:to-blue-700
                transition-all duration-200 rounded-full flex-shrink-0 relative group
                ${isResizing ? 'bg-gradient-to-b from-blue-400 via-blue-500 to-blue-400 dark:from-blue-600 dark:via-blue-500 dark:to-blue-600' : ''}
              `}
                                    title="Drag to resize SQL viewer"
                              >
                                    <div className="absolute inset-0 flex items-center justify-center">
                                          <div className="flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                                                <div className="w-8 h-0.5 bg-slate-400 dark:bg-slate-500 rounded-full"></div>
                                          </div>
                                    </div>
                              </div>
                        )}

                        {/* ROW 2 & 3: Tables and Diff - Collapsible */}
                        {/* Unified Result Area */}
                        {!isTablesCollapsed && (
                              <div className="flex-1 min-h-[300px] flex flex-col gap-2 relative">

                                    {/* Result Controls (Tabs) - Only show when executed */}
                                    {hasExecuted && (
                                          <div className="flex items-center justify-center mb-2">
                                                <div className="flex bg-slate-200 dark:bg-slate-800 p-1 rounded-lg shadow-inner">
                                                      <button
                                                            onClick={() => setActiveResultTab('before')}
                                                            className={`flex items-center gap-2 px-4 py-1.5 rounded-md text-xs font-bold transition-all ${activeResultTab === 'before'
                                                                  ? 'bg-white dark:bg-slate-700 text-blue-600 dark:text-blue-400 shadow-sm'
                                                                  : 'text-slate-500 hover:text-slate-700 dark:text-slate-400 dark:hover:text-slate-200'}`}
                                                      >
                                                            <ArrowRight className="rotate-180" size={14} /> Before
                                                      </button>
                                                      <button
                                                            onClick={() => setActiveResultTab('diff')}
                                                            className={`flex items-center gap-2 px-4 py-1.5 rounded-md text-xs font-bold transition-all ${activeResultTab === 'diff'
                                                                  ? 'bg-white dark:bg-slate-700 text-purple-600 dark:text-purple-400 shadow-sm'
                                                                  : 'text-slate-500 hover:text-slate-700 dark:text-slate-400 dark:hover:text-slate-200'}`}
                                                      >
                                                            <RotateCcw size={14} className="rotate-90" /> Diffs
                                                      </button>
                                                      <button
                                                            onClick={() => setActiveResultTab('after')}
                                                            className={`flex items-center gap-2 px-4 py-1.5 rounded-md text-xs font-bold transition-all ${activeResultTab === 'after'
                                                                  ? 'bg-white dark:bg-slate-700 text-green-600 dark:text-green-400 shadow-sm'
                                                                  : 'text-slate-500 hover:text-slate-700 dark:text-slate-400 dark:hover:text-slate-200'}`}
                                                      >
                                                            After <ArrowRight size={14} />
                                                      </button>
                                                </div>
                                          </div>
                                    )}

                                    {/* Content Area */}
                                    <div className="flex-1 overflow-hidden flex flex-col">
                                          {(isFetchingInitial || isFetchingBefore) && (
                                                <div className="absolute inset-0 bg-white/50 dark:bg-black/50 z-20 flex items-center justify-center rounded-lg backdrop-blur-[1px]">
                                                      <Loader2 className="animate-spin text-primary-500" />
                                                </div>
                                          )}

                                          {/* Logic for Separate Tables */}
                                          {scenarioMeta.separateTables ? (
                                                <div className="flex flex-col h-full">
                                                      {/* Table Tabs */}
                                                      <div className="flex items-center justify-between border-b border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-dark-surface/50 p-2">
                                                            <div className="flex gap-1">
                                                                  {scenarioMeta.separateTables.map((tableDef: any) => (
                                                                        <button
                                                                              key={tableDef.name}
                                                                              onClick={() => handleTabChange(tableDef.name)}
                                                                              className={`px-4 py-2 rounded-t text-sm font-medium transition-all ${activeTableTab === tableDef.name
                                                                                    ? 'bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-400 border-b-2 border-blue-500'
                                                                                    : 'text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800'}`}
                                                                        >
                                                                              {tableDef.label}
                                                                        </button>
                                                                  ))}
                                                            </div>
                                                            <button onClick={() => setIsTablesCollapsed(!isTablesCollapsed)} className="px-3 py-1.5 rounded text-xs font-semibold bg-orange-500 text-white">
                                                                  {isTablesCollapsed ? 'Show' : 'Hide'}
                                                            </button>
                                                      </div>

                                                      {/* Active Table Content */}
                                                      {!isTablesCollapsed && (
                                                            <div className="flex-1 overflow-y-auto p-2">
                                                                  {scenarioMeta.separateTables.map((tableDef: any) => {
                                                                        if (activeTableTab !== tableDef.name) return null;
                                                                        const tablePk = tableDef.columns.find((c: any) => c.isPk)?.key || tableDef.columns[0]?.key;

                                                                        // Decide what to render based on activeResultTab
                                                                        if (hasExecuted && activeResultTab === 'diff') {
                                                                              return (
                                                                                    <div key={tableDef.name} className="h-full">
                                                                                          <DiffView
                                                                                                before={separateTablesBefore[tableDef.name] || []}
                                                                                                after={separateTablesAfter[tableDef.name] || []}
                                                                                                columns={tableDef.columns}
                                                                                                pk={tablePk}
                                                                                          />
                                                                                    </div>
                                                                              );
                                                                        }
                                                                        if (hasExecuted && activeResultTab === 'before') {
                                                                              return (
                                                                                    <TableSnapshot
                                                                                          key={tableDef.name}
                                                                                          data={separateTablesBefore[tableDef.name] || []}
                                                                                          columns={tableDef.columns}
                                                                                          title={`${tableDef.label} - Before Execution`}
                                                                                          className="border-slate-300"
                                                                                    />
                                                                              );
                                                                        }
                                                                        if (hasExecuted && activeResultTab === 'after') {
                                                                              return (
                                                                                    <TableSnapshot
                                                                                          key={tableDef.name}
                                                                                          data={separateTablesAfter[tableDef.name] || []}
                                                                                          columns={tableDef.columns}
                                                                                          title={`${tableDef.label} - After Execution`}
                                                                                          className="border-green-300"
                                                                                    />
                                                                              );
                                                                        }

                                                                        // Default / Initial State
                                                                        return (
                                                                              <TableSnapshot
                                                                                    key={tableDef.name}
                                                                                    data={separateTablesInitial[tableDef.name] || []}
                                                                                    columns={tableDef.columns}
                                                                                    title={`${tableDef.label} - Current Data`}
                                                                              />
                                                                        );
                                                                  })}
                                                            </div>
                                                      )}
                                                </div>
                                          ) : (
                                                // Single Table View Logic
                                                <div className="flex-1 flex flex-col h-full relative">
                                                      <div className="absolute top-2 right-2 z-10">
                                                            <button onClick={() => setIsTablesCollapsed(!isTablesCollapsed)} className="px-3 py-1.5 bg-orange-500 text-white rounded text-xs">{isTablesCollapsed ? 'Show' : 'Hide'}</button>
                                                      </div>

                                                      {hasExecuted && activeResultTab === 'diff' ? (
                                                            <DiffView
                                                                  before={beforeData}
                                                                  after={afterData}
                                                                  columns={scenarioMeta.columns}
                                                                  pk={pkField}
                                                            />
                                                      ) : hasExecuted && activeResultTab === 'before' ? (
                                                            <TableSnapshot
                                                                  data={beforeData}
                                                                  columns={scenarioMeta.columns}
                                                                  title="Table State (Before)"
                                                            />
                                                      ) : hasExecuted && activeResultTab === 'after' ? (
                                                            <TableSnapshot
                                                                  data={afterData}
                                                                  columns={scenarioMeta.columns}
                                                                  title="Table State (After)"
                                                            />
                                                      ) : (
                                                            <TableSnapshot
                                                                  data={initialData}
                                                                  columns={scenarioMeta.columns}
                                                                  title="Current Table State"
                                                            />
                                                      )}
                                                </div>
                                          )}
                                    </div>
                              </div>
                        )}
                  </div>
            </div>
      );
};

export default ScenarioDetail;