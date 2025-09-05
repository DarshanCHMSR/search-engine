# AWS RDS Configuration Guide for Golligog Database

## Current Connection Issue
Your Node.js application cannot connect to the AWS RDS PostgreSQL instance because of network security restrictions.

## Required AWS Configuration Steps

### 1. Security Group Configuration
**Navigate to**: AWS Console → EC2 → Security Groups

**Find your RDS security group** (usually named something like `rds-launch-wizard-X`)

**Add Inbound Rule**:
- Type: PostgreSQL
- Protocol: TCP
- Port: 5432
- Source: 0.0.0.0/0 (for testing) or your specific IP address

**To find your IP address**, run: `curl ifconfig.me`

### 2. RDS Instance Public Accessibility
**Navigate to**: AWS Console → RDS → Databases → Your Instance

**Check**: "Publicly Accessible" should be set to "Yes"

**If it's set to "No"**:
1. Select your RDS instance
2. Click "Modify"
3. Under "Network & Security" → Set "Public access" to "Yes"
4. Apply changes (may require a brief restart)

### 3. VPC and Subnet Configuration
**Ensure your RDS is in a public subnet**:
- Navigate to: VPC → Subnets
- Check that your RDS subnet has an Internet Gateway route

### 4. Network ACLs (if using custom NACLs)
**Default NACLs usually allow all traffic**, but if you have custom ones:
- Inbound: Allow TCP 5432 from 0.0.0.0/0
- Outbound: Allow TCP 5432 to 0.0.0.0/0

## Security Best Practices (After Testing)

### For Production:
1. **Restrict IP Access**: Instead of 0.0.0.0/0, use your specific IP ranges
2. **VPC Private Subnets**: Move RDS to private subnet with NAT Gateway
3. **Bastion Host**: Use EC2 bastion host for database access
4. **SSL/TLS**: Enable SSL certificate verification

## Quick Test Commands

### Test from your current machine:
```bash
# Check if port is open
telnet database-1.cv62gywq2djb.eu-north-1.rds.amazonaws.com 5432

# Or using nc (netcat)
nc -zv database-1.cv62gywq2djb.eu-north-1.rds.amazonaws.com 5432
```

### Test with psql (if installed):
```bash
psql -h database-1.cv62gywq2djb.eu-north-1.rds.amazonaws.com -p 5432 -U postgres -d database-1
```

## After Configuration:
Once you've updated the AWS settings, wait 2-3 minutes for changes to take effect, then run:
```bash
cd /home/kali/search_engine/server
node test-connection-detailed.js
```

## Current Database Settings Detected:
- Host: database-1.cv62gywq2djb.eu-north-1.rds.amazonaws.com
- Port: 5432
- Database: database-1 (updated from golligog_db)
- User: postgres
- Password: postgres

## Next Steps:
1. Configure AWS Security Group (most important)
2. Ensure RDS is publicly accessible
3. Test the connection again
4. Once connected, we'll start the full server with database integration
