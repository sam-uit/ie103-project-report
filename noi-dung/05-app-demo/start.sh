#!/bin/bash

# ============================================================================
# BOOKING MANAGEMENT SYSTEM - START SCRIPT
# ============================================================================
# Script này sẽ start cả Frontend và Backend cùng lúc

echo "🚀 Starting Booking Management System..."
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================================
# CHECK DEPENDENCIES
# ============================================================================

echo -e "${BLUE}📦 Checking dependencies...${NC}"

# Check Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed${NC}"
    echo "Please install Node.js from https://nodejs.org/"
    exit 1
fi

echo -e "${GREEN}✓ Node.js $(node -v)${NC}"

# Check npm
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm is not installed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ npm $(npm -v)${NC}"

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}⚠️  node_modules not found. Installing all dependencies...${NC}"
    npm install
fi

echo ""

# ============================================================================
# CHECK CONFIGURATION
# ============================================================================

echo -e "${BLUE}⚙️  Checking configuration...${NC}"

# Check frontend .env
if [ ! -f "frontend/.env" ]; then
    echo -e "${YELLOW}⚠️  Frontend .env not found. Copying from frontend/.env.example...${NC}"
    cp frontend/.env.example frontend/.env
fi

echo -e "${GREEN}✓ Frontend .env found${NC}"

# Check backend .env
if [ ! -f "backend/.env" ]; then
    echo -e "${YELLOW}⚠️  Backend .env not found. Copying from backend/.env.example...${NC}"
    cp backend/.env.example backend/.env
    echo -e "${YELLOW}⚠️  Please configure backend/.env with your database credentials${NC}"
fi

echo -e "${GREEN}✓ Backend .env found${NC}"
echo ""

# ============================================================================
# START SERVERS
# ============================================================================

echo -e "${BLUE}🚀 Starting servers...${NC}"
echo ""
echo -e "${GREEN}Frontend will run on: http://localhost:5174${NC}"
echo -e "${GREEN}Backend will run on:  http://localhost:3000${NC}"
echo ""
echo -e "${YELLOW}Press Ctrl+C to stop both servers${NC}"
echo ""

# Start both servers using npm workspaces
npm run dev
