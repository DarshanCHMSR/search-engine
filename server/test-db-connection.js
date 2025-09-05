const { Client } = require('pg');
const path = require('path');

// Load environment variables from the correct path
require('dotenv').config({ path: path.join(__dirname, '.env') });

async function testConnection() {
  console.log('Environment check:');
  console.log('Current directory:', __dirname);
  console.log('NODE_ENV:', process.env.NODE_ENV);
  
  const client = new Client({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT || 5432,
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    ssl: {
      require: true,
      rejectUnauthorized: false
    }
  });

  console.log('\nTesting database connection...');
  console.log(`Host: ${process.env.DB_HOST}`);
  console.log(`Port: ${process.env.DB_PORT}`);
  console.log(`Database: ${process.env.DB_NAME}`);
  console.log(`User: ${process.env.DB_USER}`);

  try {
    await client.connect();
    console.log('✅ Database connection successful!');
    
    const result = await client.query('SELECT version()');
    console.log('PostgreSQL version:', result.rows[0].version);
    
    await client.end();
  } catch (error) {
    console.error('❌ Database connection failed:');
    console.error('Error:', error.message);
    
    if (error.code === 'ECONNREFUSED') {
      console.log('\n🔍 Troubleshooting suggestions:');
      console.log('1. Check if the RDS instance is running and available');
      console.log('2. Verify security group allows inbound connections on port 5432');
      console.log('3. Check if your IP address is whitelisted');
      console.log('4. Ensure the database endpoint is correct');
      console.log('5. Try connecting from an EC2 instance in the same VPC');
    } else if (error.code === 'ENOTFOUND') {
      console.log('\n🔍 The database hostname could not be resolved');
      console.log('Check if the RDS endpoint is correct');
    } else if (error.code === '28P01') {
      console.log('\n🔍 Authentication failed');
      console.log('Check username and password');
    }
  }
}

testConnection();
