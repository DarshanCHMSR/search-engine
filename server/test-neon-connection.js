const { PrismaClient } = require('@prisma/client');
require('dotenv').config();

const prisma = new PrismaClient();

const testNeonConnection = async () => {
    console.log('🔍 Testing Neon PostgreSQL Connection with Prisma\n');
    
    console.log('Configuration:');
    console.log('DATABASE_URL:', process.env.DATABASE_URL ? 'Set (hidden for security)' : 'Not set');
    console.log('Environment:', process.env.NODE_ENV || 'development');
    console.log('\n');

    try {
        console.log('🔌 Connecting to Neon PostgreSQL...');
        
        // Test connection
        await prisma.$connect();
        console.log('✅ Successfully connected to Neon PostgreSQL!');
        
        // Test a simple query
        const result = await prisma.$queryRaw`SELECT version()`;
        console.log('📊 Database version:', result[0].version);
        
        // Test if the users table exists (it might not exist yet)
        try {
            const userCount = await prisma.user.count();
            console.log('👥 Current users in database:', userCount);
        } catch (error) {
            if (error.code === 'P2021') {
                console.log('⚠️  Users table does not exist yet. Run `npx prisma migrate dev` to create it.');
            } else {
                console.log('⚠️  Error querying users table:', error.message);
            }
        }
        
        console.log('\n✅ Connection test completed successfully!');
        
    } catch (error) {
        console.log('❌ Connection failed:', error.message);
        
        if (error.code) {
            console.log('Error code:', error.code);
        }
        
        console.log('\n💡 Troubleshooting suggestions:');
        console.log('1. Make sure your DATABASE_URL in .env is correct');
        console.log('2. Verify your Neon project is active and accessible');
        console.log('3. Check if your IP address is allowed in Neon settings');
        console.log('4. Ensure the DATABASE_URL includes ?sslmode=require');
        console.log('\nExample DATABASE_URL format:');
        console.log('postgresql://username:password@hostname/database?sslmode=require');
        
    } finally {
        await prisma.$disconnect();
        console.log('\n🔌 Disconnected from database');
    }
};

testNeonConnection();
