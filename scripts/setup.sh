#!/bin/bash
# ============================================
# OSEC Project — Initial Setup Script
# ============================================
# Run this script after cloning the repository
# to set up development environment for all
# project components.
# ============================================

set -e

echo "============================================"
echo "  OSEC — Development Setup"
echo "============================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check prerequisites
echo "Checking prerequisites..."

check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "  ${GREEN}✓${NC} $1 found: $(command -v $1)"
    else
        echo -e "  ${RED}✗${NC} $1 not found. Please install $1."
        exit 1
    fi
}

check_command node
check_command npm
check_command flutter
check_command dart

echo ""

# 1. Setup environment file
if [ ! -f .env ]; then
    echo -e "${YELLOW}Creating .env from .env.example...${NC}"
    cp .env.example .env
    echo -e "  ${GREEN}✓${NC} .env file created. Please edit it with your configuration."
else
    echo -e "  ${GREEN}✓${NC} .env file already exists."
fi

echo ""

# 2. Setup Backend
echo "Setting up Backend..."
cd backend

if [ ! -d "node_modules" ]; then
    echo "  Installing npm dependencies..."
    npm install
    echo -e "  ${GREEN}✓${NC} Backend dependencies installed."
else
    echo -e "  ${GREEN}✓${NC} Backend dependencies already installed."
fi

cd ..

echo ""

# 3. Setup Mobile App
echo "Setting up Mobile App..."
cd mobile-app

if [ ! -d ".dart_tool" ]; then
    echo "  Installing Flutter dependencies..."
    flutter pub get
    echo -e "  ${GREEN}✓${NC} Flutter dependencies installed."
else
    echo -e "  ${GREEN}✓${NC} Flutter dependencies already installed."
fi

echo -e "  Running Flutter analyze..."
flutter analyze

cd ..

echo ""

# 4. Create necessary directories (if not present)
echo "Verifying directory structure..."

directories=(
    "infrastructure/docker/data"
    "backend/logs"
)

for dir in "${directories[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo -e "  ${GREEN}✓${NC} Created $dir"
    fi
done

echo ""

# 5. Git hooks setup
echo "Setting up Git hooks..."
if [ -d ".git" ]; then
    # Configure git to use conventional commit message template
    git config commit.template .github/COMMIT_MESSAGE_TEMPLATE 2>/dev/null || true
    echo -e "  ${GREEN}✓${NC} Git hooks configured."
fi

echo ""
echo "============================================"
echo -e "  ${GREEN}OSEC setup complete!${NC}"
echo "============================================"
echo ""
echo "Next steps:"
echo "  1. Edit .env with your API keys and secrets"
echo "  2. Start the backend:    cd backend && npm run dev"
echo "  3. Start the app:        cd mobile-app && flutter run"
echo "  4. Read the docs:        docs/"
echo ""
