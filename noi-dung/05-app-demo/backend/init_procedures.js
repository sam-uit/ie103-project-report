const sql = require('mssql');
const fs = require('fs');
const path = require('path');

const config = {
    user: 'sa',
    password: 'Anhvu1999',
    server: 'localhost',
    port: 1433,
    database: 'BookingMS',
    options: {
        encrypt: true,
        trustServerCertificate: true
    }
};

const sqlFiles = [
    'sp_BookingRoom.sql',
    'sp_ApplyVoucher.sql',
    'sp_CancelRoom.sql',
    'sp_UsedService.sql',
    'sp_CreateReviews.sql'
];

async function initProcedures() {
    try {
        console.log('Connecting to SQL Server...');
        const pool = await sql.connect(config);
        console.log('✓ Connected to BookingMS database\n');

        for (const file of sqlFiles) {
            const filePath = path.join(__dirname, 'sql', file);
            const sqlContent = fs.readFileSync(filePath, 'utf8');
            
            console.log(`Creating ${file}...`);
            
            try {
                // Remove GO statements as they're not valid T-SQL, just batch separators
                const cleanSql = sqlContent.replace(/\r?\nGO\r?\n?/gi, '\n');
                
                await pool.request().query(cleanSql);
                
                console.log(`✓ ${file} created successfully\n`);
            } catch (err) {
                console.error(`✗ Error creating ${file}:`, err.message, '\n');
            }
        }

        // Verify created procedures
        const result = await pool.request().query(`
            SELECT name FROM sys.objects WHERE type = 'P' ORDER BY name
        `);
        
        console.log('\n=== Stored Procedures in Database ===');
        result.recordset.forEach(sp => {
            console.log(`✓ ${sp.name}`);
        });
        console.log(`\nTotal: ${result.recordset.length} procedures\n`);

        await pool.close();
        console.log('✓ Database initialization completed!');
        
    } catch (err) {
        console.error('Error:', err.message);
        process.exit(1);
    }
}

initProcedures();
