/**
 * ===============================================
 * INIT PROCEDURES
 * ===============================================
 * Script này sẽ tạo tất cả stored procedures cần thiết
 * ===============================================
 */

const fs = require('fs');
const path = require('path');

const API_BASE = 'http://localhost:3001/api';

async function fetchApi(endpoint, method = 'GET', body = null) {
    const url = `${API_BASE}${endpoint}`;
    const options = {
        method,
        headers: { 'Content-Type': 'application/json' }
    };
    if (body) {
        options.body = JSON.stringify(body);
    }
    
    const response = await fetch(url, options);
    return response.json();
}

async function executeRawSql(sql) {
    return fetchApi('/execute-sql', 'POST', { sql, params: [] });
}

async function initProcedures() {
    console.log('🔧 Initializing Stored Procedures...\n');
    
    const sqlDir = path.join(__dirname, 'sql');
    const files = fs.readdirSync(sqlDir).filter(f => f.endsWith('.sql'));
    
    for (const file of files) {
        console.log(`📄 Processing: ${file}`);
        try {
            const content = fs.readFileSync(path.join(sqlDir, file), 'utf8');
            const result = await executeRawSql(content);
            if (result.success) {
                console.log(`   ✅ Success`);
            } else {
                console.log(`   ❌ Error: ${result.error}`);
            }
        } catch (e) {
            console.log(`   ❌ Fatal: ${e.message}`);
        }
    }
    
    console.log('\n✅ Done initializing procedures!');
}

initProcedures().catch(console.error);
