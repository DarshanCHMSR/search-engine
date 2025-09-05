const { PrismaClient } = require('@prisma/client');
require('dotenv').config();

console.log('DATABASE_URL:', process.env.DATABASE_URL);

const prisma = new PrismaClient({
    log: ['query', 'info', 'warn', 'error'],
});

async function testConnection() {
    try {
        console.log('Testing connection...');
        await prisma.$connect();
        console.log('✅ Connected successfully!');
        
        // Try a simple query
        const result = await prisma.$queryRaw`SELECT 1 as test`;
        console.log('Query result:', result);
        
    } catch (error) {
        console.error('❌ Connection failed:', error);
    } finally {
        await prisma.$disconnect();
    }
}

testConnection();
