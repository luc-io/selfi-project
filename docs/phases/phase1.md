# Phase 1: Basic Setup & Launch

## Overview
In Phase 1, we set up the core infrastructure and get the bot live on Telegram with basic image generation and payment functionality.

## Repositories

### Selfi Bot V2 (`selfi-bot-v2`)
Backend Telegram bot handling image generation and payment processing.

Key features:
- Image generation with FAL AI
- Star system with Telegram payments
- Database for user management
- Error handling and monitoring

### Selfi Mini App V2 (`selfi-miniapp-v2`)
Frontend Telegram Mini App for a better user experience.

Key features:
- Generation interface
- Model selection
- Star purchase flow
- Image history

## Bot Implementation

### 1.1 Initial Setup
- [x] Project structure established
- [x] Dependencies installed
- [x] Environment configuration set up
- [x] Basic bot setup with Grammy

### 1.2 Database Setup
- [x] Prisma schema defined
- [x] Models created:
  - User (stars, transactions)
  - BaseModel (Flux)
  - Generation
  - Payment
- [x] Initial migrations
- [x] Database seeding

### 1.3 Core Services
- [x] User management
  - Creation and updates
  - Star balance tracking
  - Welcome bonus
- [x] Payment handling
  - Star packages
  - Telegram payments integration
  - Transaction tracking
- [x] Image generation
  - FAL AI integration
  - Generation tracking
  - Error handling

### 1.4 Commands
- [x] /start - Bot initialization
- [x] /gen - Image generation
- [x] /stars - Purchase stars
- [x] /balance - Check balance

### 1.5 Error Handling & Monitoring
- [x] Global error handler
- [x] Pino logging
- [x] Payment validation
- [x] Transaction atomicity

### 1.6 Deployment
- [x] PM2 configuration
- [x] Deployment scripts
- [x] Database migrations
- [x] Environment setup

## Mini App Implementation

### 2.1 Project Setup
- [x] Vite + React configuration
- [x] TypeScript setup
- [x] Tailwind CSS integration
- [x] Component library

### 2.2 Core Components
- [x] Layout system
- [x] Generation form
- [x] Model selector
- [x] Loading states

### 2.3 API Integration
- [x] API client setup
- [x] Authentication handling
- [x] Error handling
- [x] Data fetching with React Query

## Testing & Verification

Before going live:

1. Bot Tests
```bash
# Generate image
/gen a red cat playing with yarn

# Check balance
/balance

# Buy stars
/stars

# Test payment flow
```

2. Database Checks
```sql
-- Check user creation
SELECT * FROM "User" ORDER BY "createdAt" DESC LIMIT 5;

-- Verify transactions
SELECT * FROM "StarTransaction" ORDER BY "createdAt" DESC LIMIT 5;

-- Check generations
SELECT * FROM "Generation" ORDER BY "createdAt" DESC LIMIT 5;
```

3. API Tests
```bash
# Health check
curl http://localhost:3000/health

# Test generation
curl -X POST http://localhost:3000/generate \
  -H "x-user-id: YOUR_USER_ID" \
  -H "Content-Type: application/json" \
  -d '{"prompt":"test prompt"}'
```

## Going Live Checklist

### 1. Environment Setup
- [ ] Get production database credentials
- [ ] Set up DO Spaces bucket
- [ ] Get FAL AI production keys
- [ ] Configure Telegram payment token

### 2. Server Setup
```bash
# Install dependencies
sudo apt update
sudo apt install -y nodejs npm postgresql
npm install -g pnpm pm2

# Clone repositories
git clone https://github.com/luc-io/selfi-bot-v2.git
git clone https://github.com/luc-io/selfi-miniapp-v2.git

# Set up bot
cd selfi-bot-v2
pnpm install
cp .env.example .env
# Edit .env with production values

# Initialize database
pnpm prisma generate
pnpm prisma db push
pnpm prisma db seed

# Start bot
pm2 start ecosystem.config.js
```

### 3. Bot Setup with BotFather
1. Create new bot or update existing
2. Set commands
3. Enable payments
4. Configure inline mode
5. Set webhook URL (if using webhooks)

### 4. Final Checks
- [ ] Verify database connections
- [ ] Test payment processing
- [ ] Check image generation
- [ ] Monitor error logs
- [ ] Verify star transactions

## Common Issues & Solutions

### Payment Issues
- Ensure payment provider token is correct
- Check pre-checkout query handling
- Verify star credit timing

### Generation Issues
- Check FAL AI credentials
- Verify model availability
- Monitor generation queue

### Database Issues
- Check connection string
- Verify migrations
- Monitor transaction locks

## Support & Monitoring

### Logging
All major events are logged with Pino:
- User registration
- Star transactions
- Image generation
- Payment processing
- Errors and warnings

### Monitoring
Use PM2 for process monitoring:
```bash
# View logs
pm2 logs selfi-bot

# Monitor processes
pm2 monit
```

### Alerts
Set up alerts for:
- Process crashes
- Payment failures
- High error rates
- Database issues

## Next Steps
After successful launch:
1. Monitor user feedback
2. Track error patterns
3. Plan Phase 2 features
4. Optimize costs