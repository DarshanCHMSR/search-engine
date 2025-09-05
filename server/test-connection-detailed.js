const { Client } = require('pg');
require('dotenv').config();

async function comprehensiveTest() {
  const host = process.env.DB_HOST;
  const port = process.env.DB_PORT || 5432;
  
  console.log('🔍 Comprehensive AWS RDS Connection Test');
  console.log('==========================================');
  console.log(`Host: ${host}`);
  console.log(`Port: ${port}`);
  console.log(`Database: ${process.env.DB_NAME}`);
  console.log(`User: ${process.env.DB_USER}`);
  console.log('');

  // Test 1: Basic network connectivity
  console.log('1. Testing basic network connectivity...');
  try {
    const { execSync } = require('child_process');
    const pingResult = execSync(`ping -c 1 ${host}`, { timeout: 5000 });
    console.log('✅ Host is reachable via ping');
  } catch (error) {
    console.log('❌ Host is not reachable via ping');
    console.log('This might be normal for RDS instances (ICMP might be blocked)');
  }

  // Test 2: Port connectivity
  console.log('\n2. Testing port connectivity...');
  const net = require('net');
  
  const testPort = () => {
    return new Promise((resolve, reject) => {
      const socket = new net.Socket();
      const timeout = 10000; // 10 seconds

      socket.setTimeout(timeout);
      
      socket.on('connect', () => {
        console.log('✅ Port 5432 is open and accepting connections');
        socket.destroy();
        resolve(true);
      });

      socket.on('timeout', () => {
        console.log('❌ Connection timed out - port might be blocked');
        socket.destroy();
        reject(new Error('Timeout'));
      });

      socket.on('error', (err) => {
        console.log('❌ Port connection failed:', err.code);
        if (err.code === 'ECONNREFUSED') {
          console.log('   - The port is closed or service is not running');
        } else if (err.code === 'EHOSTUNREACH') {
          console.log('   - Host is unreachable (network/routing issue)');
        } else if (err.code === 'ETIMEDOUT') {
          console.log('   - Connection timed out (firewall/security group issue)');
        }
        reject(err);
      });

      socket.connect(port, host);
    });
  };

  try {
    await testPort();
  } catch (error) {
    console.log('\n🔧 Troubleshooting suggestions:');
    console.log('1. Check AWS RDS Security Group:');
    console.log('   - Ensure inbound rule allows PostgreSQL (port 5432)');
    console.log('   - Source should be 0.0.0.0/0 or your specific IP');
    console.log('');
    console.log('2. Check RDS Instance Status:');
    console.log('   - Ensure the instance is in "Available" state');
    console.log('   - Check if the instance is in a public subnet');
    console.log('');
    console.log('3. Check Network ACLs:');
    console.log('   - Verify subnet network ACLs allow traffic on port 5432');
    console.log('');
    console.log('4. Check VPC Settings:');
    console.log('   - If RDS is in private subnet, you need VPN/bastion host');
    console.log('   - For public access, set "Publicly Accessible" to Yes');
    return;
  }

  // Test 3: PostgreSQL authentication
  console.log('\n3. Testing PostgreSQL authentication...');
  const client = new Client({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT || 5432,
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    ssl: {
      require: true,
      rejectUnauthorized: false
    },
    connectionTimeoutMillis: 10000
  });

  try {
    await client.connect();
    console.log('✅ PostgreSQL authentication successful!');
    
    const result = await client.query('SELECT version()');
    console.log('✅ Database query successful!');
    console.log('PostgreSQL version:', result.rows[0].version);
    
    // Test if database exists
    const dbCheck = await client.query('SELECT datname FROM pg_database WHERE datname = $1', [process.env.DB_NAME]);
    if (dbCheck.rows.length > 0) {
      console.log(`✅ Database '${process.env.DB_NAME}' exists`);
    } else {
      console.log(`⚠️  Database '${process.env.DB_NAME}' does not exist`);
      console.log('Creating database...');
      await client.query(`CREATE DATABASE ${process.env.DB_NAME}`);
      console.log('✅ Database created successfully');
    }
    
    await client.end();
    console.log('\n🎉 All tests passed! Database is ready to use.');
    
  } catch (error) {
    console.error('❌ PostgreSQL connection failed:');
    console.error('Error code:', error.code);
    console.error('Error message:', error.message);
    
    if (error.code === '28P01') {
      console.log('\n🔧 Authentication failed - check username/password');
    } else if (error.code === '3D000') {
      console.log('\n🔧 Database does not exist - it will be created automatically');
    }
  }
}

comprehensiveTest().catch(console.error);
