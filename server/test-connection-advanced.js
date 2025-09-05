const { Client } = require('pg');
require('dotenv').config();

// Alternative connection test with different configurations
async function testVariousConnections() {
  console.log('🔍 Testing Multiple Connection Configurations\n');
  
  const baseConfig = {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT || 5432,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    connectionTimeoutMillis: 10000,
    statement_timeout: 10000,
    query_timeout: 10000,
  };

  console.log('Base configuration:');
  console.log(`Host: ${baseConfig.host}`);
  console.log(`Port: ${baseConfig.port}`);
  console.log(`Database: ${baseConfig.database}`);
  console.log(`User: ${baseConfig.user}\n`);

  // Test 1: Without SSL
  console.log('Test 1: Connection without SSL');
  try {
    const client1 = new Client({
      ...baseConfig,
      ssl: false
    });
    await client1.connect();
    console.log('✅ Connected without SSL!');
    await client1.end();
  } catch (error) {
    console.log('❌ Failed without SSL:', error.code || error.message);
  }

  // Test 2: With SSL require but no verification
  console.log('\nTest 2: Connection with SSL (no verification)');
  try {
    const client2 = new Client({
      ...baseConfig,
      ssl: {
        require: true,
        rejectUnauthorized: false
      }
    });
    await client2.connect();
    console.log('✅ Connected with SSL (no verification)!');
    await client2.end();
  } catch (error) {
    console.log('❌ Failed with SSL:', error.code || error.message);
  }

  // Test 3: Try connecting to postgres database instead
  console.log('\nTest 3: Connection to default postgres database');
  try {
    const client3 = new Client({
      ...baseConfig,
      database: 'postgres',
      ssl: {
        require: true,
        rejectUnauthorized: false
      }
    });
    await client3.connect();
    console.log('✅ Connected to postgres database!');
    
    // List available databases
    const result = await client3.query('SELECT datname FROM pg_database WHERE datistemplate = false;');
    console.log('Available databases:', result.rows.map(row => row.datname));
    
    await client3.end();
  } catch (error) {
    console.log('❌ Failed connecting to postgres database:', error.code || error.message);
  }

  // Test 4: Check if it's a DNS issue
  console.log('\nTest 4: DNS Resolution Test');
  const dns = require('dns');
  try {
    await new Promise((resolve, reject) => {
      dns.lookup(baseConfig.host, (err, address) => {
        if (err) reject(err);
        else {
          console.log(`✅ DNS resolved: ${baseConfig.host} -> ${address}`);
          resolve(address);
        }
      });
    });
  } catch (error) {
    console.log('❌ DNS resolution failed:', error.message);
  }
}

testVariousConnections().catch(console.error);
