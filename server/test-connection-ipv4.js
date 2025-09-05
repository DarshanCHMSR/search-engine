const { Client } = require('pg');
require('dotenv').config();

async function testIPv4Connection() {
  console.log('🔍 Testing Direct IPv4 Connection to AWS RDS\n');

  // Use IPv4 address directly instead of hostname
  const client = new Client({
    host: '16.16.50.81',  // Direct IPv4 address
    port: 5432,
    database: 'postgres',  // Try default postgres database first
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || 'postgres',
    ssl: {
      require: true,
      rejectUnauthorized: false
    },
    connectionTimeoutMillis: 10000,
  });

  console.log('Attempting connection with:');
  console.log('Host: 16.16.50.81 (IPv4)');
  console.log('Port: 5432');
  console.log('Database: postgres');
  console.log('User: postgres');
  console.log('SSL: enabled (no verification)\n');

  try {
    console.log('Connecting...');
    await client.connect();
    console.log('✅ Successfully connected to AWS RDS!\n');

    // Test basic query
    const result = await client.query('SELECT version();');
    console.log('📋 PostgreSQL Version:', result.rows[0].version);

    // List databases
    const dbResult = await client.query('SELECT datname FROM pg_database WHERE datistemplate = false;');
    console.log('\n📂 Available databases:');
    dbResult.rows.forEach(row => console.log(`  - ${row.datname}`));

    // Check if our target database exists
    const targetDb = process.env.DB_NAME || 'database-1';
    const exists = dbResult.rows.some(row => row.datname === targetDb);
    
    if (exists) {
      console.log(`\n✅ Target database '${targetDb}' exists!`);
    } else {
      console.log(`\n⚠️  Target database '${targetDb}' does not exist.`);
      console.log(`   You may need to create it or use an existing database.`);
    }

    await client.end();
    console.log('\n🎉 Connection test successful! You can now update your server configuration.');
    
  } catch (error) {
    console.error('❌ Connection failed:', error.message);
    
    if (error.code === 'ETIMEDOUT') {
      console.log('\n🔧 Still timing out. This could mean:');
      console.log('1. Security group still blocking access');
      console.log('2. RDS instance not in public subnet');
      console.log('3. Network ACLs blocking traffic');
    } else if (error.code === '28P01') {
      console.log('\n🔧 Authentication failed. Check:');
      console.log('1. Username and password are correct');
      console.log('2. User has permission to connect');
    } else if (error.code === '3D000') {
      console.log('\n🔧 Database does not exist. Try:');
      console.log('1. Connect to "postgres" database instead');
      console.log('2. Create the target database first');
    }
  }
}

testIPv4Connection();
