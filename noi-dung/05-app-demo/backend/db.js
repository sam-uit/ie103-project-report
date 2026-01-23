const sql = require('mssql');

// Cấu hình kết nối
const config = {
    user: process.env.DB_USER || 'sa',
    password: process.env.DB_PASSWORD || 'Anhvu1999',
    server: process.env.DB_SERVER || 'localhost',
    port: parseInt(process.env.DB_PORT) || 1433,
    database: process.env.DB_NAME || 'BookingMS',
    options: {
        encrypt: true, // Sử dụng cho Azure hoặc bắt buộc encrypt
        trustServerCertificate: true // Bỏ qua lỗi self-signed certificate (Dev env)
    }
};


let pool;

async function initDb()
{
    try
    {
        console.log('DB Config', JSON.stringify(config))
        pool = await sql.connect(config);
        console.log("Connected to SQL Server", `${config.server}:${config.port}`, config.database, config.user);
    } catch (err)
    {
        const intervalConnect = setInterval(async () =>
        {

            console.log('DB Config', JSON.stringify(config))
            pool = await sql.connect(config);
            console.log("Connected to SQL Server", `${config.server}:${config.port}`, config.database, config.user);
            clearInterval(intervalConnect);

        }, 10000);

        console.log(`DB Connection failed, retrying... ${config.server}:${config.port} ${config.database}`, '- ErrorMessage :::', err.message);
    }
}

async function connect()
{
    try
    {
        pool = await sql.connect(config);
        console.log("DB Connection Established Manually.");
        return pool;
    } catch (err)
    {
        console.error("Manual DB Connection Failed:", err);
        throw err;
    }
}

async function connectAndExecute(query, params = [])
{
    try
    {
        console.log('Executing:', query);
        console.log('With params:', params);

        let pool = await sql.connect(config);
        let request = pool.request();

        // Add INPUT parameters with proper SQL types
        params.forEach(p =>
        {
            const paramName = p.name.replace('@', ''); // Remove @ prefix if exists

            // Map JavaScript types to SQL types
            let sqlType;
            switch (p.type)
            {
                case 'int':
                    sqlType = sql.Int;
                    break;
                case 'string':
                    sqlType = sql.NVarChar;
                    break;
                case 'decimal':
                    sqlType = sql.Decimal(18, 2);
                    break;
                case 'date':
                case 'datetime':
                    sqlType = sql.DateTime;
                    break;
                case 'boolean':
                    sqlType = sql.Bit;
                    break;
                default:
                    sqlType = sql.NVarChar;
            }

            request.input(paramName, sqlType, p.value);
        });

        // Check if it's a stored procedure call
        const isSP = query.trim().toUpperCase().startsWith('EXEC') ||
            query.trim().toUpperCase().startsWith('EXECUTE') ||
            (!query.includes('SELECT') && !query.includes('INSERT') && !query.includes('UPDATE') && !query.includes('DELETE'));

        let result;
        if (isSP)
        {
            // Extract SP name if query starts with EXEC/EXECUTE
            let spName = query.trim();
            if (spName.toUpperCase().startsWith('EXEC ')) spName = spName.substring(5).trim();
            if (spName.toUpperCase().startsWith('EXECUTE ')) spName = spName.substring(8).trim();

            // Remove parameters from SP name if any
            spName = spName.split(/[\s(]/)[0];

            console.log('Executing SP:', spName);

            // Add OUTPUT parameters for SP_AP_DUNG_VOUCHER
            if (spName === 'SP_AP_DUNG_VOUCHER')
            {
                request.output('TongTienPhong', sql.Decimal(18, 2));
                request.output('TienGiam', sql.Decimal(18, 2));
                request.output('TongTienSauGiam', sql.Decimal(18, 2));
            }

            result = await request.execute(spName);

            // Log output params if any
            if (result.output)
            {
                console.log('Output params:', result.output);
            }
        } else
        {
            // Regular query
            result = await request.query(query);
        }

        return {
            recordset: result.recordset || result.recordsets?.[0] || [],
            rowsAffected: result.rowsAffected,
            output: result.output || {}
        };
    } catch (err)
    {
        console.error("SQL Error:", err);
        throw err;
    }
}

async function executeBatch(script, params = [])
{
    try
    {
        if (script.charCodeAt(0) === 0xFEFF)
            script = script.slice(1);

        const batches = script
            .split(/^\s*GO\s*$/im)
            .filter(b => b.trim().length > 0);

        console.log(`Batches found: ${batches.length}`);

        let lastResult = null;

        for (const batchSql of batches)
        {
            const request = pool.request();

            const cleanedSql = batchSql
                .replace(/^\s*\/\*[\s\S]*?\*\//, '')
                .replace(/^\s*(--.*\n)+/g, '')
                .trimStart();

            const ddlMatch = cleanedSql.match(
                /^CREATE(\s+OR\s+ALTER)?\s+PROCEDURE\s+([\[\]\w\.]+)/i
            );

            const isDDL = !!ddlMatch;
            console.log("Batch identified as DDL:", isDDL);

            // ======================
            // PHA 1: DEPLOY
            // ======================
            if (isDDL)
            {
                console.log("Deploying procedure...");
                await request.batch(batchSql);

                // ======================
                // PHA 2: AUTO EXEC (DEMO)
                // ======================
                if (params && params.length > 0)
                {
                    const procName = ddlMatch[2].replace(/[\[\]]/g, '');
                    console.log("Auto executing:", procName);

                    const execReq = pool.request();

                    params.forEach(p =>
                    {
                        const name = p.name.replace('@', '');
                        let sqlType;

                        switch (p.type)
                        {
                            case 'int': sqlType = sql.Int; break;
                            case 'decimal': sqlType = sql.Decimal(18, 2); break;
                            case 'datetime': sqlType = sql.DateTime; break;
                            default: sqlType = sql.NVarChar;
                        }

                        execReq.input(name, sqlType, p.value);
                    });

                    lastResult = await execReq.execute(procName);
                }

                continue;
            }

            // ======================
            // NON-DDL
            // ======================
            if (params && params.length > 0)
            {
                params.forEach(p =>
                {
                    request.input(p.name.replace('@', ''), p.value);
                });
            }

            lastResult = await request.query(batchSql);
        }

        return lastResult ?? { success: true };

    }
    catch (err)
    {
        console.error("Batch Execution Error:", err);
        throw err;
    }
}


module.exports = {
    connectAndExecute,
    executeBatch,
    connect,
    initDb
};
