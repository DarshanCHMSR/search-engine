const { Client } = require('pg');
require('dotenv').config();

const testConnection = async () => {
    const connectionString = process.env.DATABASE_URL;
    console.log('Connection string length:', connectionString.length);
    console.log('Connection starts with:', connectionString.substring(0, 50) + '...');
    
    // Parse the connection string manually
    try {
        const url = new URL(connectionString);
        console.log('\nParsed connection details:');
        console.log('Protocol:', url.protocol);
        console.log('Hostname:', url.hostname);
        console.log('Port:', url.port || '5432');
        console.log('Database:', url.pathname.substring(1));
        console.log('Username:', url.username);
        console.log('Search params:', url.searchParams.toString());
    } catch (parseError) {
        console.error('❌ Error parsing connection string:', parseError.message);
        return;
    }

    const client = new Client({
        connectionString: connectionString,
        ssl: true
    });

    try {
        console.log('\n🔌 Attempting connection...');
        await client.connect();
        console.log('✅ Connected successfully!');
        
        const result = await client.query('SELECT NOW()');
        console.log('📅 Server time:', result.rows[0].now);
        
    } catch (error) {
        console.error('❌ Connection failed:');
        console.error('Error code:', error.code);
        console.error('Error message:', error.message);
        console.error('Error details:', error.detail || 'No additional details');
    } finally {
        try {
            await client.end();
            console.log('🔌 Disconnected');
        } catch (e) {
            console.log('Note: Client was not connected');
        }
    }
};

testConnection();
