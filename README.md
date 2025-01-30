# Selfi Project

Selfi is a Telegram bot and mini application for AI image generation and LoRA training using FAL AI. This repository contains project documentation and manages the bot and miniapp repositories as submodules.

## Repositories

### [Selfi Bot V2](https://github.com/luc-io/selfi-bot-v2)
The Telegram bot backend handling:
- Image generation with FAL
- LoRA training management
- Star/payment system
- User management

Tech Stack:
- Node.js & TypeScript
- Grammy (Telegram Bot Framework)
- Prisma (Database ORM)
- PostgreSQL
- Digital Ocean Spaces
- FAL AI SDK

### [Selfi Mini App V2](https://github.com/luc-io/selfi-miniapp-v2)
Telegram Mini App frontend providing:
- Image generation interface
- LoRA training interface
- Model management
- Generation history

Tech Stack:
- React & TypeScript
- Vite
- TailwindCSS
- React Query
- Telegram Web App SDK

## Getting Started

1. Clone with submodules:
```bash
git clone --recursive https://github.com/luc-io/selfi-project.git
cd selfi-project
```

2. Initialize submodules if needed:
```bash
git submodule update --init --recursive
```

3. Set up bot:
```bash
cd selfi-bot-v2
pnpm install
cp .env.example .env
# Edit .env with your credentials
```

4. Set up miniapp:
```bash
cd selfi-miniapp-v2
pnpm install
cp .env.example .env
# Edit .env with your credentials
```

## Development Flow

1. Follow the phase documentation in `docs/phases/`
2. Use the issue tracker for tasks and bugs
3. Create pull requests for new features
4. Update documentation as you go

## Project Structure

```
selfi-project/
├── docs/
│   ├── architecture/  # Technical documentation
│   ├── phases/        # Implementation phases
│   └── api/           # API documentation
├── selfi-bot-v2/     # Bot submodule
└── selfi-miniapp-v2/ # Mini app submodule
```

## Implementation Phases

### [Phase 1: Basic Setup & Launch](./docs/phases/phase1.md)
- Bot core functionality
- Basic command handling
- Payment system
- Initial deployment

### [Phase 2: Training & Models](./docs/phases/phase2.md)
- LoRA training
- Model management
- Advanced generation options

### [Phase 3: Advanced Features](./docs/phases/phase3.md)
- Style presets
- Community features
- Advanced analytics

## Deployment

### Bot Deployment
```bash
cd selfi-bot-v2
./scripts/deploy.sh
```

### Mini App Deployment
```bash
cd selfi-miniapp-v2
pnpm build
# Deploy dist/ to your static hosting
```

## Environment Setup

### Bot Environment
Required variables:
```env
# Bot
TELEGRAM_BOT_TOKEN=
TELEGRAM_PAYMENT_TOKEN=

# Database
DATABASE_URL=

# Storage
SPACES_BUCKET=
SPACES_ENDPOINT=
SPACES_KEY=
SPACES_SECRET=

# FAL
FAL_KEY=
FAL_KEY_SECRET=
```

### Mini App Environment
Required variables:
```env
# API URL
VITE_API_URL=http://localhost:3000
```

## Contributing

1. Pick an issue or create one
2. Create a branch
3. Make your changes
4. Submit a pull request

## Testing

### Bot Testing
```bash
cd selfi-bot-v2
pnpm test
```

### Mini App Testing
```bash
cd selfi-miniapp-v2
pnpm test
```

## Monitoring

### Bot Monitoring
```bash
pm2 monit
pm2 logs selfi-bot
```

### Mini App Monitoring
- Use browser dev tools
- Check API logs

## Common Issues

### Bot Issues
- Payment processing
- Image generation timeouts
- Database connection

### Mini App Issues
- Telegram Web App SDK
- API connectivity
- File upload limits

## License

MIT