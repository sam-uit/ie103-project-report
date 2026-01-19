import React, { createContext, useContext, useEffect, useState } from 'react';
import { Scenario, ReportGroup, LogEntry, TeamMember, OverviewConfig } from '../types';
import { SCENARIOS as DEFAULT_SCENARIOS, REPORTS as DEFAULT_REPORTS_FLAT, LOGS as DEFAULT_LOGS } from '../data';
import { api } from '../services/api';
import { scanDemoConfigs } from '../utils/demoScanner';

interface AppConfig {
      appSettings: {
            title: string;
            description: string;
            version: string;
      };
      overview?: OverviewConfig;
      teamMembers?: TeamMember[];
      scenarios: Scenario[];
      reportGroups: ReportGroup[];
      logs: LogEntry[];
}

interface ConfigContextType {
      config: AppConfig | null;
      loading: boolean;
      error: string | null;
      backendOnline: boolean;
      refreshConfig: () => Promise<void>;
      checkBackendStatus: () => Promise<void>;
}

const ConfigContext = createContext<ConfigContextType | undefined>(undefined);

// Get base URL from Vite config (e.g., '/ie103-project-report/')
const base = import.meta.env.BASE_URL;

export const ConfigProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
      const [config, setConfig] = useState<AppConfig | null>(null);
      const [loading, setLoading] = useState(true);
      const [error, setError] = useState<string | null>(null);
      const [backendOnline, setBackendOnline] = useState(false);

      const fetchJson = async (path: string, fallback: any) => {
            try {
                  const res = await fetch(`${import.meta.env.BASE_URL}${path}`);
                  if (!res.ok) throw new Error(`Failed to load ${path}`);
                  return await res.json();
            } catch (e) {
                  console.warn(e);
                  return fallback;
            }
      };

      const checkBackendStatus = async () => {
            const isOnline = await api.checkHealth();
            setBackendOnline(isOnline);
      };

      const refreshConfig = async () => {
            setLoading(true);
            // Check backend concurrently with config loading
            checkBackendStatus();

            try {
                  // Fetch all config files in parallel
                  const [settings, overview, reports, team] = await Promise.all([
                        fetchJson('/config/settings.json', { title: "Hệ Thống Demo", description: "Config missing", version: "0.0" }),
                        fetchJson('/config/overview.json', {}),
                        fetchJson('/config/reports.json', []),
                        fetchJson('/config/team.json', [])
                  ]);

                  // Load scenarios from sql-demo folder using demo scanner
                  let scenarios: Scenario[] = [];
                  try {
                        console.log('🔍 Scanning sql-demo folder for demos...');
                        scenarios = await scanDemoConfigs() as Scenario[];
                        console.log(`✅ Found ${scenarios.length} demos:`, scenarios.map(s => s.id));
                  } catch (scanError) {
                        console.error('❌ Failed to scan demos:', scanError);
                        // Fallback to empty array or try loading from config file
                        const configScenarios = await fetchJson('/config/scenarios.json', []);
                        scenarios = configScenarios;
                  }

                  if (scenarios.length === 0 && reports.length === 0) {
                        throw new Error("Empty config loaded");
                  }

                  setConfig({
                        appSettings: settings,
                        overview: overview,
                        scenarios: scenarios,
                        reportGroups: reports,
                        teamMembers: team,
                        logs: []
                  });
                  setError(null);

            } catch (err) {
                  console.error("Failed to load dynamic configs, falling back to static data:", err);

                  const fallbackReportGroups: ReportGroup[] = [{
                        id: 'default-group',
                        title: 'Tài liệu mặc định (Offline)',
                        description: 'Danh sách các báo cáo mẫu được tải từ dữ liệu tĩnh.',
                        files: DEFAULT_REPORTS_FLAT as any
                  }];

                  setConfig({
                        appSettings: { title: "Hệ Thống BMS (Static)", description: "Offline Mode", version: "1.0" },
                        scenarios: DEFAULT_SCENARIOS,
                        reportGroups: fallbackReportGroups,
                        logs: DEFAULT_LOGS,
                        teamMembers: [],
                        overview: undefined
                  });
                  setError('Using static fallback data.');
            } finally {
                  setLoading(false);
            }
      };

      useEffect(() => {
            refreshConfig();
            // Optional: Poll backend status every 30 seconds
            const interval = setInterval(checkBackendStatus, 30000);
            return () => clearInterval(interval);
      }, []);

      return (
            <ConfigContext.Provider value={{ config, loading, error, backendOnline, refreshConfig, checkBackendStatus }}>
                  {children}
            </ConfigContext.Provider>
      );
};

export const useConfig = () => {
      const context = useContext(ConfigContext);
      if (context === undefined) {
            throw new Error('useConfig must be used within a ConfigProvider');
      }
      return context;
};