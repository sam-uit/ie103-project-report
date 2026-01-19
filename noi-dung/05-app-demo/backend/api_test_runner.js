const fs = require('fs');
const path = require('path');
const glob = require('glob');

const API_BASE = 'http://localhost:3001/api';
const FRONTEND_DIR = path.resolve(__dirname, '../frontend/sql-demo');
const MOCK_DIR = path.resolve(__dirname, 'mock');

// Helper: Read File
const readFile = (filePath) =>
{
      try
      {
            return fs.readFileSync(filePath, 'utf8');
      } catch (err)
      {
            console.error(`Error reading file: ${filePath}`, err.message);
            return null;
      }
};

// Helper: API Call
const apiCall = async (endpoint, body) =>
{
      try
      {
            const response = await fetch(`${API_BASE}${endpoint}`, {
                  method: 'POST',
                  headers: { 'Content-Type': 'application/json' },
                  body: JSON.stringify(body)
            });
            const data = await response.json();
            return data;
      } catch (err)
      {
            return { success: false, error: err.message };
      }
};

// Utility: Generate diff between two result sets
function generateDiff(before, after)
{
      const beforeStr = JSON.stringify(before, null, 2);
      const afterStr = JSON.stringify(after, null, 2);
      if (beforeStr === afterStr) return '';
      return `Diff:\n${beforeStr}\n -> \n${afterStr}`;
}

// Main Runner
const run = async () =>
{
      console.log("🚀 Starting API-Based SQL Verification...");

      // 1. Load Init & Seed Scripts
      const initSql = readFile(path.join(MOCK_DIR, 'init_tables.sql'));
      const seedSql = readFile(path.join(MOCK_DIR, 'seed.sql'));

      if (!initSql || !seedSql)
      {
            console.error("❌ Failed to load init/seed scripts. Exiting.");
            process.exit(1);
      }

      // 2. Discover Scenarios
      const configFiles = glob.sync(`${FRONTEND_DIR}/**/config.json`);
      console.log(`📂 Found ${configFiles.length} scenarios.`);

      let passed = 0;
      let failed = 0;
      let results = [];

      for (const configFile of configFiles)
      {
            const config = JSON.parse(readFile(configFile));
            const dir = path.dirname(configFile);
            const scenarioId = config.id || path.basename(dir);

            console.log(`\n---------------------------------------------------`);
            console.log(`🧪 Testing Scenario: ${config.title} (${config.type})`);

            try
            {
                  // A. Reset DB
                  // We use execute-sql for batch execution of init and seed
                  process.stdout.write("   🔄 Resetting Database... ");
                  const initRes = await apiCall('/execute-sql', { sql: initSql });
                  if (!initRes.success) throw new Error(`Init Failed: ${initRes.error}`);

                  const seedRes = await apiCall('/execute-sql', { sql: seedSql });
                  if (!seedRes.success) throw new Error(`Seed Failed: ${seedRes.error}`);
                  console.log("✅");

                  // B. Fetch Before State
                  process.stdout.write("   📸 Fetching Before State... ");
                  // Resolve params for fetch query (replace @Param with defaultValue)
                  let fetchBeforeSql = config.sqlFetchBefore;
                  // Note: sqlFetchBefore in config usually uses @Params. 
                  // We need to either pass params to API or replace them.
                  // API /query accepts { sql, params }. Let's construct params list.
                  const params = config.params || [];
                  // Map params to { name, type, value } format expected by backend db.js (maybe?)
                  // Backend db.js connectAndExecute expects: inputParams mapped from req.body.params
                  // Let's use the format: { name: 'BookingId', type: 'int', value: 1 }
                  // config.json params: { name: '@BookingId', type: 'int', defaultValue: 1 }

                  const apiParams = params.map(p => ({
                        name: p.name.replace('@', ''), // Backend usually expects name without @ for input() but @ in query
                        type: p.type,
                        value: p.defaultValue,
                        isOutput: p.isOutput || false
                  }));

                  const beforeRes = await apiCall('/query', { sql: fetchBeforeSql, params: apiParams });
                  if (!beforeRes.success) throw new Error(`Fetch Before Failed: ${beforeRes.error}`);
                  const dataBefore = beforeRes.data || [];

                  if (!Array.isArray(dataBefore) || dataBefore.length === 0)
                  {
                        throw new Error("FE Preview Failed: sqlFetchBefore returned 0 rows. FE must see data before execution.");
                  }
                  console.log(`✅ (${dataBefore.length} rows)`);

                  // C. Execute Scenario
                  process.stdout.write("   ⚡ Executing Scenario Script... ");

                  // 1. Deploy/Run the SQL File
                  const sqlFilePath = path.join(dir, path.basename(config.sqlFile));
                  let sqlFileContent = readFile(sqlFilePath);
                  if (!sqlFileContent) throw new Error(`SQL File not found: ${sqlFilePath}`);

                  // Remove BOM
                  sqlFileContent = sqlFileContent.replace(/^\uFEFF/, '');

                  // DEPLOY: Run script WITHOUT params to avoid "Variable already declared" if script has DECLARE
                  const deployRes = await apiCall('/execute-sql', { sql: sqlFileContent });
                  if (!deployRes.success) throw new Error(`Deploy/Script Failed: ${deployRes.error || deployRes.hint}`);

                  // 2. Perform Action (if SP or Function)
                  // If the script was just a Definition (CREATE), we need to manually CALL it.
                  // If it was Definition + Test (like Triggers), data might already be changed.

                  // Try to extract Name to potentially run it
                  let spName = null;
                  let funcName = null;

                  const spMatch = sqlFileContent.match(/CREATE(?:\s+OR\s+ALTER)?\s+PROC(?:EDURE)?\s+(?:\[?dbo\]?\.)?\[?([\w_]+)\]?/i);
                  if (spMatch) spName = spMatch[1];

                  const funcMatch = sqlFileContent.match(/CREATE(?:\s+OR\s+ALTER)?\s+FUNC(?:TION)?\s+(?:\[?dbo\]?\.)?\[?([\w_]+)\]?/i);
                  if (funcMatch) funcName = funcMatch[1];

                  // Execution Logic
                  if (config.type === 'Stored Procedure' && spName)
                  {
                        // Construct EXEC command
                        // e.g. EXEC SP_NAME @P1 = @P1
                        // Use params from config
                        const msg = `   ⚙️ Manually Executing SP: ${spName}...`;
                        process.stdout.write(msg);

                        const args = apiParams.map(p =>
                        {
                              const suffix = p.isOutput ? ' OUTPUT' : '';
                              return `@${p.name} = @${p.name}${suffix}`;
                        }).join(', ');
                        const execSql = `EXEC ${spName} ${args}`;

                        const execRes = await apiCall('/execute-sql', { sql: execSql, params: apiParams });
                        if (!execRes.success)
                        {
                              console.log("❌");
                              throw new Error(`SP Execution Failed: ${execRes.error}`);
                        }
                        console.log("✅");
                  } else if (config.type === 'Function' && funcName)
                  {
                        const msg = `   ⚙️ Manually Executing Function: ${funcName}...`;
                        process.stdout.write(msg);

                        const args = apiParams.map(p => `@${p.name}`).join(', ');
                        const selectSql = `SELECT dbo.${funcName}(${args}) as Result`;

                        const funcRes = await apiCall('/query', { sql: selectSql, params: apiParams });
                        if (!funcRes.success)
                        {
                              console.log("❌");
                              throw new Error(`Function Execution Failed: ${funcRes.error}`);
                        }
                        console.log("✅");
                  }

                  console.log("✅");

                  // D. Fetch After State
                  process.stdout.write("   📸 Fetching After State... ");
                  const afterRes = await apiCall('/query', { sql: config.sqlFetchAfter, params: apiParams });
                  if (!afterRes.success) throw new Error(`Fetch After Failed: ${afterRes.error}`);
                  const dataAfter = afterRes.data || [];
                  console.log(`✅ (${dataAfter.length} rows)`);

                  // E. Assert
                  const jsonBefore = JSON.stringify(dataBefore);
                  const jsonAfter = JSON.stringify(dataAfter);
                  const diffStr = generateDiff(dataBefore, dataAfter);

                  if (jsonBefore === jsonAfter && !['Function', 'Cursor'].includes(config.type))
                  {
                        // Functions/Cursors might not change data stated in fetchBefore/After if they just return data.
                        // But the requirement says "Data must change". 
                        // However, for Functions, usually they return a value, they don't change DB.
                        // Re-reading requirements: "Compare Before vs After... Data must have significant change... evidence data change"
                        // For function: Maybe the "data" itself is the result of the function?
                        // But sqlFetchBefore/After usually query Tables.
                        // If a function checks availability, table data shouldn't change.
                        // The previous runner allowed Functions/Cursors to pass unchanged.
                        // "Allow Functions and specific Cursors to pass even if data doesn't change."
                        // I will keep this logic.
                        console.log(`   🛑 Error: Data did not change! (Before == After)`);
                        console.log(`   Before: ${jsonBefore}`);
                        console.log(`   After:  ${jsonAfter}`);
                        throw new Error("Data did not change! (Before == After)");
                  }

                  console.log(`   🎉 Result: PASS`);
                  if (config.type !== 'Function' && config.type !== 'Cursor')
                  {
                        console.log(`   Diff: ${diffStr}`);
                  }
                  results.push({ scenarioId, status: 'PASS', diff: diffStr });
                  passed++;

            } catch (err)
            {
                  console.log(`❌`);
                  console.error(`   🛑 Error: ${err.message}`);
                  results.push({ scenarioId, status: 'FAIL', error: err.message });
                  failed++;
            }
      }

      console.log(`\n===================================================`);
      console.log(`SUMMARY: ${passed} Passed, ${failed} Failed`);
      console.log(`===================================================`);
      console.log('RESULT_SUMMARY', JSON.stringify({ passed, failed, details: results }, null, 2));

      if (failed > 0) process.exit(1);
};

run();
