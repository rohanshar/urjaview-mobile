#!/bin/bash

# Quick Codemagic CLI wrapper
# Usage: ./scripts/cm.sh [command]

# Load environment variables
if [ -f ".env.local" ]; then
    export $(cat .env.local | xargs)
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

case "$1" in
    "list"|"ls")
        echo -e "${BLUE}Recent builds:${NC}"
        ./scripts/monitor_builds.sh list
        ;;
    "status"|"st")
        if [ -z "$2" ]; then
            echo -e "${RED}Error: Build ID required${NC}"
            echo "Usage: $0 status <build-id>"
            exit 1
        fi
        ./scripts/monitor_builds.sh status "$2"
        ;;
    "logs")
        if [ -z "$2" ]; then
            echo -e "${RED}Error: Build ID required${NC}"
            echo "Usage: $0 logs <build-id>"
            exit 1
        fi
        ./scripts/monitor_builds.sh logs "$2"
        ;;
    "ios")
        echo -e "${BLUE}Triggering iOS build...${NC}"
        ./scripts/monitor_builds.sh trigger-ios
        ;;
    "android")
        echo -e "${BLUE}Triggering Android build...${NC}"
        ./scripts/monitor_builds.sh trigger-android
        ;;
    "help"|"-h"|"--help"|"")
        echo "Codemagic CLI Quick Commands"
        echo ""
        echo "Usage: $0 [command] [options]"
        echo ""
        echo "Commands:"
        echo "  list, ls        List recent builds"
        echo "  status, st      Get build status"
        echo "  logs            Download build logs"
        echo "  ios             Trigger iOS build"
        echo "  android         Trigger Android build"
        echo "  help            Show this help"
        echo ""
        echo "Environment:"
        echo "  App ID: ${CODEMAGIC_APP_ID:-Not set}"
        echo "  API Token: ${CODEMAGIC_API_TOKEN:+Set}"
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        echo "Run '$0 help' for usage"
        exit 1
        ;;
esac