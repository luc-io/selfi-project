#!/bin/bash

# Exit on any error
set -e

echo "Setting up Selfi project..."

# Initialize submodules if needed
if [ ! -d "selfi-bot-v2" ] || [ ! -d "selfi-miniapp-v2" ]; then
  echo "Initializing submodules..."
  git submodule update --init --recursive
fi

# Set up bot
echo "Setting up bot..."
cd selfi-bot-v2
if [ ! -f ".env" ]; then
  cp .env.example .env
  echo "Created .env file for bot. Please edit with your credentials."
fi
pnpm install

# Set up database
echo "Setting up database..."
pnpm prisma generate
if [ "$1" = "--migrate" ]; then
  pnpm prisma db push
  if [ "$2" = "--seed" ]; then
    pnpm prisma db seed
  fi
fi

# Set up miniapp
echo "Setting up miniapp..."
cd ../selfi-miniapp-v2
if [ ! -f ".env" ]; then
  cp .env.example .env
  echo "Created .env file for miniapp. Please edit with your credentials."
fi
pnpm install

echo "Setup completed!"
echo "Next steps:"
echo "1. Configure .env files in both projects"
echo "2. Run database migrations"
echo "3. Start development servers"