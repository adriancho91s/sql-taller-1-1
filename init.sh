#!/bin/bash

# =====================================================
# SQL Workshop 1 - Initialization Script
# Universidad Tecnológica de Pereira
# =====================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print banner
echo -e "${BLUE}"
echo "=========================================="
echo "  SQL Workshop 1 - Hotel Management DB"
echo "  Universidad Tecnológica de Pereira"
echo "=========================================="
echo -e "${NC}"

# Check if Docker is installed
echo -e "${YELLOW}[1/6] Checking Docker installation...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    echo "Please install Docker from https://docs.docker.com/get-docker/"
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}Error: Docker Compose is not installed${NC}"
    echo "Please install Docker Compose from https://docs.docker.com/compose/install/"
    exit 1
fi
echo -e "${GREEN}✓ Docker is installed${NC}"

# Check if Docker is running
echo -e "${YELLOW}[2/6] Checking Docker daemon...${NC}"
if ! docker info &> /dev/null; then
    echo -e "${RED}Error: Docker daemon is not running${NC}"
    echo "Please start Docker and try again"
    exit 1
fi
echo -e "${GREEN}✓ Docker daemon is running${NC}"

# Stop existing containers if running
echo -e "${YELLOW}[3/6] Stopping existing containers (if any)...${NC}"
if docker-compose version &> /dev/null; then
    docker-compose down 2>/dev/null || true
else
    docker compose down 2>/dev/null || true
fi
echo -e "${GREEN}✓ Cleanup completed${NC}"

# Build and start containers
echo -e "${YELLOW}[4/6] Building and starting containers...${NC}"
if docker-compose version &> /dev/null; then
    docker-compose up -d --build
else
    docker compose up -d --build
fi
echo -e "${GREEN}✓ Containers started${NC}"

# Wait for MySQL to be ready
echo -e "${YELLOW}[5/6] Waiting for MySQL to be ready...${NC}"
MAX_TRIES=30
COUNT=0
while [ $COUNT -lt $MAX_TRIES ]; do
    if docker exec hotel_management_db mysqladmin ping -h localhost -u root -prootpassword --silent &> /dev/null; then
        echo -e "${GREEN}✓ MySQL is ready${NC}"
        break
    fi
    COUNT=$((COUNT+1))
    if [ $COUNT -eq $MAX_TRIES ]; then
        echo -e "${RED}Error: MySQL failed to start within expected time${NC}"
        echo "Check logs with: docker-compose logs mysql"
        exit 1
    fi
    echo -n "."
    sleep 2
done
echo ""

# Display connection information
echo -e "${YELLOW}[6/6] Setup complete!${NC}"
echo ""
echo -e "${GREEN}=========================================="
echo "  Connection Information"
echo "==========================================${NC}"
echo ""
echo -e "${BLUE}MySQL Database:${NC}"
echo "  Host: localhost"
echo "  Port: 3306"
echo "  Database: hotel_management"
echo "  Username: hotel_admin"
echo "  Password: hotel123"
echo ""
echo -e "${BLUE}Root Access:${NC}"
echo "  Username: root"
echo "  Password: rootpassword"
echo ""
echo -e "${BLUE}Web Interface (Adminer):${NC}"
echo "  URL: http://localhost:8080"
echo "  System: MySQL"
echo "  Server: mysql"
echo "  Username: hotel_admin"
echo "  Password: hotel123"
echo ""
echo -e "${GREEN}=========================================="
echo "  Useful Commands"
echo "==========================================${NC}"
echo ""
echo "Access MySQL CLI:"
echo "  docker exec -it hotel_management_db mysql -u hotel_admin -photel123 hotel_management"
echo ""
echo "View logs:"
echo "  docker-compose logs -f mysql"
echo ""
echo "Stop services:"
echo "  docker-compose down"
echo ""
echo "Stop and remove all data:"
echo "  docker-compose down -v"
echo ""
echo -e "${BLUE}Opening Adminer in browser...${NC}"

# Try to open Adminer in browser
if command -v open &> /dev/null; then
    # macOS
    open http://localhost:8080 2>/dev/null || true
elif command -v xdg-open &> /dev/null; then
    # Linux
    xdg-open http://localhost:8080 2>/dev/null || true
elif command -v wslview &> /dev/null; then
    # WSL
    wslview http://localhost:8080 2>/dev/null || true
fi

echo ""
echo -e "${GREEN}✓ All done! Your database is ready to use.${NC}"
echo ""
