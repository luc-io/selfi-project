#!/bin/bash

# Exit on any error
set -e

echo "Updating Selfi project..."

# Update main repo
echo "Pulling main repository updates..."
git pull origin main

# Update submodules
echo "Updating submodules..."
git submodule update --remote --merge

# Update bot dependencies
echo "Updating bot dependencies..."
cd selfi-bot-v2
pnpm install
if [ "$1" = "--migrate" ]; then
  echo "Running bot database migrations..."
  pnpm prisma generate
  pnpm prisma db push
fi

# Update miniapp dependencies
echo "Updating miniapp dependencies..."
cd ../selfi-miniapp-v2
pnpm install

echo "Update completed!"