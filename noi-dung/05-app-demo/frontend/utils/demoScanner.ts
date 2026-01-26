// Demo Scanner Utility
// Scans sql-demo folder and loads all demo configs

export interface DemoConfig {
      id: string;
      title: string;
      type: 'Trigger' | 'StoreProcedure' | 'Function' | 'Cursor';
      shortDesc: string;
      mdFile: string;
      sqlFile: string;
      tables: string[];
      columns: Array<{ key: string; label: string; isPk?: boolean }>;
      params?: Array<{ name: string; type: string; defaultValue?: any }>;
      sqlContent?: string;  // Optional: inline SQL content
      mockData?: {          // Optional: mock data for offline mode
            before?: any[];
            after?: any[];
      };
}

// List of demo types and their folders
const DEMO_TYPES = ['Trigger', 'StoreProcedure', 'Function', 'Cursor'];

/**
 * Scan sql-demo folder and load all demo configs
 * Returns array of demo configurations
 */
export async function scanDemoConfigs(): Promise<DemoConfig[]> {
      const allConfigs: DemoConfig[] = [];

      for (const type of DEMO_TYPES) {
            try {
                  const BASE_URL = import.meta.env.BASE_URL;
                  // Fetch the list of demo folders for this type
                  const demoFolders = await getDemoFolders(type);

                  for (const folder of demoFolders) {
                        try {
                              // Load config.json for this demo
                              const configPath = `${BASE_URL}sql-demo/${type}/${folder}/config.json`;
                              console.log({ configPath });
                              const response = await fetch(configPath);

                              if (response.ok) {
                                    const config: DemoConfig = await response.json();
                                    allConfigs.push(config);
                              } else {
                                    console.warn(`Config not found for ${type}/${folder}`);
                              }
                        } catch (error) {
                              console.error(`Error loading config for ${type}/${folder}:`, error);
                        }
                  }
            } catch (error) {
                  console.error(`Error scanning ${type} demos:`, error);
            }
      }

      return allConfigs;
}

/**
 * Get list of demo folders for a specific type
 * This requires a manifest file or API endpoint
 */
async function getDemoFolders(type: string): Promise<string[]> {
      try {
            // Try to load manifest file
            const manifestPath = `${import.meta.env.BASE_URL}/sql-demo/${type}/manifest.json`;
            const response = await fetch(manifestPath);

            if (response.ok) {
                  const manifest = await response.json();
                  return manifest.demos || [];
            }
      } catch (error) {
            console.warn(`No manifest found for ${type}, using hardcoded list`);
      }

      // Fallback: hardcoded list (will be generated)
      return getHardcodedDemoList(type);
}

/**
 * Hardcoded demo list (fallback)
 * This should be auto-generated or replaced with manifest files
 */
function getHardcodedDemoList(type: string): string[] {
      const demoLists: Record<string, string[]> = {
            'Trigger': [
                  'Demo_CheckTime',
                  'Demo_AutoPrice',
                  'Demo_SyncStatus',
                  'Demo_Payment',
                  'Demo_Refund'
            ],
            'StoreProcedure': [
                  'Demo_BookingRoom',
                  'Demo_Payment',
                  'Demo_ReviewRoom',
                  'Demo_Service',
                  'Demo_ApplyVoucher'
            ],
            'Function': [
                  'Demo_CheckRoomAvailable',
                  'Demo_RevertCreateErorr'
            ],
            'Cursor': [
                  'Demo_CheckAndUpdateVoucher',
                  'Demo_ReportRevenueService'
            ]
      };

      return demoLists[type] || [];
}

/**
 * Load a single demo config by ID
 */
export async function loadDemoConfig(id: string): Promise<DemoConfig | null> {
      const allConfigs = await scanDemoConfigs();
      return allConfigs.find(config => config.id === id) || null;
}
