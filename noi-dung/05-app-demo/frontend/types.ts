
export enum ScenarioType {
  StoredProcedure = 'Stored Procedure',
  Trigger = 'Trigger',
  Function = 'Function',
  Cursor = 'Cursor',
  View = 'View'
}

export interface TableRow {
  [key: string]: any;
}

export interface TableColumn {
  key: string;
  label: string;
  isPk?: boolean;
}

export interface MockDataSet {
  before: TableRow[];
  after: TableRow[];
}

export interface Scenario {
  id: string;
  title: string;
  type: ScenarioType;
  shortDesc: string;
  sqlFile: string;
  sqlContent: string;

  // New fields for dynamic state fetching
  sqlFetchBefore?: string; // Query to get "Before" state
  sqlFetchAfter?: string;  // Query to get "After" state
  sqlFetchInitial?: string; // Query to get Initial state

  mdFile?: string; // Relative path to markdown/html file

  separateTables?: {
    name: string;
    label: string;
    sqlBefore: string;
    sqlAfter?: string;
    sqlFetchInitial?: string; // Query for specific table initial state
    columns: TableColumn[];
  }[];

  tables: string[];
  params?: Parameter[];
  columns: TableColumn[];
  mockData: MockDataSet; // Keep as fallback for offline mode
}

export interface Parameter {
  name: string;
  type: 'int' | 'string' | 'date' | 'boolean' | 'decimal';
  defaultValue: any;
  description?: string;
}

export interface DiffResult {
  added: TableRow[];
  removed: TableRow[];
  updated: { before: TableRow; after: TableRow }[];
  unchangedCount: number;
}

// --- UPDATED REPORT TYPES ---

export interface ReportFile {
  id: string;
  name: string;
  type: 'pdf' | 'png' | 'jpg' | 'doc' | 'excel';
  size?: string;
  date?: string;
  url: string;
  thumbnailUrl?: string;
  category?: string;
}

export interface ReportGroup {
  id: string;
  title: string;
  description: string;
  files: ReportFile[];
}

export interface LogEntry {
  id: string;
  timestamp: string;
  scenarioTitle: string;
  type: ScenarioType;
  status: 'Success' | 'Error';
  durationMs: number;
}

export interface TeamMember {
  mssv: string;
  name: string;
  tasks: string;
  notes?: string;
}

export interface OverviewConfig {
  header: {
    title: string;
    subtitle: string;
  };
  section1: {
    title: string;
    problemStatement: string;
    steps: { step: string; title: string; desc: string }[];
  };
  section2: {
    title: string;
    erdHighlights: string[];
    businessConstraints: string[];
  };
  section3: {
    title: string;
    dbSystem: string;
    features: { title: string; desc: string }[];
  };
  section4: {
    title: string;
    stats: { label: string; value: string; color: string }[];
    security: { label: string; desc: string }[];
  };
}