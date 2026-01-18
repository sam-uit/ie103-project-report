import { SCENARIOS } from '../data';
// Default fallback if nothing is configured
// const DEFAULT_API_URL = 'http://localhost:3001/api';
const DEFAULT_API_URL = 'http://localhost:3001/api';
export const getBaseUrl = () => {
      // Read from localStorage to allow dynamic configuration
      return localStorage.getItem('app_api_base_url') || DEFAULT_API_URL;
};
export interface ExecuteResponse {
      success: boolean;
      data?: any;
      error?: string;
      logs?: string;
}
export const api = {
      /**
       * Kiểm tra trạng thái Backend
       * @param customUrl (Optional) URL cụ thể để test (dùng trong màn hình Settings)
       */
      async checkHealth(customUrl?: string): Promise<boolean> {
            const baseUrl = customUrl || getBaseUrl();
            try {
                  // Remove trailing slash if exists to avoid double slash
                  const cleanUrl = baseUrl.replace(/\/$/, '');
                  const res = await fetch(`${cleanUrl}/health`, { method: 'GET', signal: AbortSignal.timeout(2000) });
                  return res.ok;
            } catch (e) {
                  return false;
            }
      },
      /**
       * Lấy nội dung script SQL từ server
       * Fallback về dữ liệu local nếu không kết nối được backend
       */
      async getSqlContent(scenarioId: string): Promise<{ sqlContent: string; filename?: string }> {
            const baseUrl = getBaseUrl().replace(/\/$/, '');
            try {
                  const res = await fetch(`${baseUrl}/scenario/${scenarioId}`);
                  if (!res.ok) throw new Error('Failed to fetch SQL');
                  return await res.json();
            } catch (error) {
                  console.warn("Backend not accessible, falling back to local data.", error);
                  const scenario = SCENARIOS.find(s => s.id === scenarioId);
                  return {
                        sqlContent: scenario?.sqlContent || '-- No script available (Offline Mode)',
                        filename: scenario?.sqlFile
                  };
            }
      },
      /**
       * Chạy câu truy vấn SELECT tùy ý (Fetch Before/After data)
       */
      async runQuery(sql: string, params: any[]): Promise<any[]> {
            const baseUrl = getBaseUrl().replace(/\/$/, '');
            try {
                  const res = await fetch(`${baseUrl}/query`, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ sql, params })
                  });
                  const json = await res.json();
                  if (json.success) return json.data;
                  throw new Error(json.error);
            } catch (error) {
                  console.warn("API query failed", error);
                  return [];
            }
      },
      /**
       * Gửi yêu cầu thực thi xuống Backend
       * Fallback về mock execution nếu không kết nối được backend
       */
      async executeScenario(scenarioId: string, params: any[]): Promise<ExecuteResponse> {
            const baseUrl = getBaseUrl().replace(/\/$/, '');
            try {
                  const res = await fetch(`${baseUrl}/execute`, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ scenarioId, params })
                  });
                  return await res.json();
            } catch (error) {
                  console.warn("Backend not accessible, falling back to local mock execution.", error);
                  // Fallback simulation
                  const scenario = SCENARIOS.find(s => s.id === scenarioId);
                  // Simulate network delay for realistic feel
                  await new Promise(resolve => setTimeout(resolve, 800));
                  if (scenario) {
                        return {
                              success: true,
                              data: {
                                    // In offline mode, we simulate returning the 'after' mock data directly
                                    // In online mode, this field might be ignored in favor of fetching via runQuery
                                    after: scenario.mockData.after
                              },
                              logs: `Executed ${scenario.title} successfully (Offline Simulation)`
                        };
                  }
                  return { success: false, error: 'Cannot connect to Backend Server and local scenario not found.' };
            }
      },
      /**
       * Gửi raw SQL script lên server để thực thi
       * Đây là cách mới - gửi nguyên câu SQL thay vì scenarioId
       */
      async executeRawSql(sqlContent: string, params: any[]): Promise<ExecuteResponse> {
            const baseUrl = getBaseUrl().replace(/\/$/, '');
            try {
                  const res = await fetch(`${baseUrl}/execute-sql`, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ sql: sqlContent, params })
                  });
                  const result = await res.json();
                  if (!result.success) {
                        throw new Error(result.error);
                  }
                  return result;
            } catch (error) {
                  console.warn("Backend not accessible for raw SQL execution.", error);
                  // Simulate network delay
                  await new Promise(resolve => setTimeout(resolve, 800));
                  return {
                        success: false,
                        data: {},
                        error: error.message ?? 'Unknown error',
                        logs: 'SQL executed successfully (Offline Simulation - no actual execution)'
                  };
            }
      },
      /**
       * Unified demo execution - sends SQL script + before/after queries to server
       * Server executes everything and returns { befores, afters, diffs }
       */
      async executeDemo(
            sql: string,
            beforeQueries: { name: string; query: string }[],
            afterQueries: { name: string; query: string }[],
            params: any[]
      ): Promise<ExecuteDemoResponse> {
            const baseUrl = getBaseUrl().replace(/\/$/, '');
            try {
                  const res = await fetch(`${baseUrl}/execute-demo`, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ sql, beforeQueries, afterQueries, params })
                  });
                  const result = await res.json();
                  if (!result.success) {
                        throw new Error(result.error || result.message);
                  }
                  return result;
            } catch (error: any) {
                  console.error("Execute demo failed:", error);
                  return {
                        success: false,
                        message: error.message ?? 'Unknown error',
                        data: { befores: {}, afters: {}, diffs: {} }
                  };
            }
      }
};
// Response type for executeDemo
export interface ExecuteDemoResponse {
      success: boolean;
      message?: string;
      data: {
            befores: Record<string, any[]>;
            afters: Record<string, any[]>;
            diffs: Record<string, {
                  added: any[];
                  removed: any[];
                  modified: { before: any; after: any }[];
            }>;
      };
}