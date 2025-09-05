require('dotenv').config();

console.log('=== DEBUGGING .env FILE ===');
console.log('Working directory:', process.cwd());
console.log('NODE_ENV:', process.env.NODE_ENV);
console.log('Full DATABASE_URL:', process.env.DATABASE_URL);
console.log('DATABASE_URL length:', process.env.DATABASE_URL?.length);

// Check if .env file exists and read it directly
const fs = require('fs');
const path = require('path');

const envPath = path.join(process.cwd(), '.env');
console.log('\nChecking .env file at:', envPath);
console.log('File exists:', fs.existsSync(envPath));

if (fs.existsSync(envPath)) {
    const envContent = fs.readFileSync(envPath, 'utf8');
    console.log('\n=== .env FILE CONTENT ===');
    console.log(envContent);
    console.log('=== END .env FILE ===');
    
    // Look for DATABASE_URL line specifically
    const lines = envContent.split('\n');
    const dbUrlLine = lines.find(line => line.startsWith('DATABASE_URL'));
    console.log('\nDATABASE_URL line from file:', dbUrlLine);
}
