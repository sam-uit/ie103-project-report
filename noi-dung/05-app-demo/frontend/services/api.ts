

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
       * Unified demo execution - sends SQL script + before/after queries to server
       * Server executes everything and returns { befores, afters, diffs }
       */
      async executeDemo(
            sql: string,
            beforeQueries: { name: string; query: string }[],
            afterQueries: { name: string; query: string }[],
            params: any[]
      ): Promise<ExecuteDemoResponse> {
            try {
                  const baseUrl = getBaseUrl().replace(/\/$/, '');
                  console.log("API executeDemo", baseUrl);
                  console.log("API executeDemo", sql);
                  console.log("API executeDemo", beforeQueries);
                  console.log("API executeDemo", afterQueries);
                  console.log("API executeDemo", params);
                  console.log("API executeDemo", `${baseUrl}/execute-demo`);
                  
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