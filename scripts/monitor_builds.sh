#!/bin/bash

# Codemagic Build Monitor Script
# This script helps monitor and manage Codemagic builds

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_ID="${CODEMAGIC_APP_ID}"
API_TOKEN="${CODEMAGIC_API_TOKEN}"

# Function to display usage
usage() {
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  list            List recent builds"
    echo "  status <id>     Get status of a specific build"
    echo "  logs <id>       Download logs for a build"
    echo "  artifacts <id>  List artifacts for a build"
    echo "  download <id>   Download artifacts for a build"
    echo "  trigger-ios     Trigger iOS build with next version"
    echo "  trigger-android Trigger Android build with next version"
    echo "  setup           Set up API credentials"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    exit 1
}

# Function to check if credentials are set
check_credentials() {
    if [ -z "$API_TOKEN" ]; then
        echo -e "${RED}Error: CODEMAGIC_API_TOKEN not set${NC}"
        echo "Run '$0 setup' to configure credentials"
        exit 1
    fi
    if [ -z "$APP_ID" ]; then
        echo -e "${RED}Error: CODEMAGIC_APP_ID not set${NC}"
        echo "Run '$0 setup' to configure credentials"
        exit 1
    fi
}

# Function to setup credentials
setup_credentials() {
    echo -e "${BLUE}Setting up Codemagic CLI credentials...${NC}"
    echo ""
    
    # Check if .env file exists
    ENV_FILE="$(dirname "$0")/../.env.local"
    
    if [ -f "$ENV_FILE" ]; then
        echo -e "${YELLOW}Loading existing credentials from .env.local${NC}"
        source "$ENV_FILE"
    fi
    
    # Prompt for App ID if not set
    if [ -z "$CODEMAGIC_APP_ID" ]; then
        echo "Enter your Codemagic App ID:"
        read -r app_id
        echo "CODEMAGIC_APP_ID=$app_id" >> "$ENV_FILE"
    else
        echo -e "${GREEN}App ID already set${NC}"
    fi
    
    # Prompt for API Token if not set
    if [ -z "$CODEMAGIC_API_TOKEN" ]; then
        echo ""
        echo "Enter your Codemagic API Token:"
        echo "(Get it from: https://codemagic.io/team/<team-id>/settings/integrations/api)"
        read -r -s api_token
        echo "CODEMAGIC_API_TOKEN=$api_token" >> "$ENV_FILE"
        echo ""
    else
        echo -e "${GREEN}API Token already set${NC}"
    fi
    
    echo -e "${GREEN}Credentials saved to .env.local${NC}"
    echo ""
    echo "To use these credentials, run:"
    echo "  source .env.local"
    echo ""
    echo "Or add to your shell profile:"
    echo "  echo 'source $(pwd)/.env.local' >> ~/.zshrc"
}

# Function to list builds
list_builds() {
    check_credentials
    
    echo -e "${BLUE}Fetching recent builds...${NC}"
    echo ""
    
    curl -s -H "x-auth-token: $API_TOKEN" \
        "https://api.codemagic.io/builds?appId=$APP_ID&limit=10" | \
    jq -r '.builds[] | "[\(.status)] \(.id) - \(.workflow.name) - Started: \(.startedAt) - Branch: \(.branch)"'
}

# Function to get build status
get_build_status() {
    check_credentials
    
    local build_id=$1
    
    if [ -z "$build_id" ]; then
        echo -e "${RED}Error: Build ID required${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}Fetching build status for $build_id...${NC}"
    echo ""
    
    response=$(curl -s -H "x-auth-token: $API_TOKEN" \
        "https://api.codemagic.io/builds/$build_id")
    
    echo "$response" | jq -r '
        "Build ID: \(.id)",
        "Status: \(.status)",
        "Workflow: \(.workflow.name)",
        "Branch: \(.branch)",
        "Started: \(.startedAt)",
        "Finished: \(.finishedAt)",
        "Duration: \(.duration) seconds",
        "",
        "Artifacts:",
        (.artifacts[] | "  - \(.name) (\(.size) bytes)")
    '
}

# Function to download logs
download_logs() {
    check_credentials
    
    local build_id=$1
    
    if [ -z "$build_id" ]; then
        echo -e "${RED}Error: Build ID required${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}Downloading logs for build $build_id...${NC}"
    
    curl -s -H "x-auth-token: $API_TOKEN" \
        "https://api.codemagic.io/builds/$build_id/logs" \
        -o "build-$build_id-logs.txt"
    
    echo -e "${GREEN}Logs saved to build-$build_id-logs.txt${NC}"
}

# Function to list artifacts
list_artifacts() {
    check_credentials
    
    local build_id=$1
    
    if [ -z "$build_id" ]; then
        echo -e "${RED}Error: Build ID required${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}Fetching artifacts for build $build_id...${NC}"
    echo ""
    
    curl -s -H "x-auth-token: $API_TOKEN" \
        "https://api.codemagic.io/builds/$build_id" | \
    jq -r '.artifacts[] | "  - \(.name) (\(.size) bytes) - \(.url)"'
}

# Function to download artifacts
download_artifacts() {
    check_credentials
    
    local build_id=$1
    
    if [ -z "$build_id" ]; then
        echo -e "${RED}Error: Build ID required${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}Downloading artifacts for build $build_id...${NC}"
    
    # Create artifacts directory
    mkdir -p "artifacts-$build_id"
    
    # Get artifact URLs and download
    artifacts=$(curl -s -H "x-auth-token: $API_TOKEN" \
        "https://api.codemagic.io/builds/$build_id" | \
    jq -r '.artifacts[] | "\(.name)|\(.url)"')
    
    while IFS='|' read -r name url; do
        echo "Downloading $name..."
        curl -s -L -o "artifacts-$build_id/$name" "$url"
    done <<< "$artifacts"
    
    echo -e "${GREEN}Artifacts saved to artifacts-$build_id/${NC}"
}

# Function to trigger iOS build
trigger_ios_build() {
    check_credentials
    
    # Get latest tag
    latest_tag=$(git describe --tags --match "ios-*" 2>/dev/null || echo "ios-0.0.0")
    
    # Extract version and increment
    version=$(echo $latest_tag | sed 's/ios-//')
    IFS='.' read -ra ADDR <<< "$version"
    patch=$((ADDR[2] + 1))
    new_version="${ADDR[0]}.${ADDR[1]}.$patch"
    new_tag="ios-$new_version"
    
    echo -e "${BLUE}Creating and pushing tag $new_tag...${NC}"
    
    git tag -a "$new_tag" -m "iOS Release $new_version"
    git push origin "$new_tag"
    
    echo -e "${GREEN}iOS build triggered with tag $new_tag${NC}"
    echo "Monitor the build at: https://codemagic.io/app/$APP_ID/build/latest"
}

# Function to trigger Android build
trigger_android_build() {
    check_credentials
    
    # Get latest tag
    latest_tag=$(git describe --tags --match "android-*" 2>/dev/null || echo "android-0.0.0")
    
    # Extract version and increment
    version=$(echo $latest_tag | sed 's/android-//')
    IFS='.' read -ra ADDR <<< "$version"
    patch=$((ADDR[2] + 1))
    new_version="${ADDR[0]}.${ADDR[1]}.$patch"
    new_tag="android-$new_version"
    
    echo -e "${BLUE}Creating and pushing tag $new_tag...${NC}"
    
    git tag -a "$new_tag" -m "Android Release $new_version"
    git push origin "$new_tag"
    
    echo -e "${GREEN}Android build triggered with tag $new_tag${NC}"
    echo "Monitor the build at: https://codemagic.io/app/$APP_ID/build/latest"
}

# Main script logic
case "${1:-}" in
    list)
        list_builds
        ;;
    status)
        get_build_status "$2"
        ;;
    logs)
        download_logs "$2"
        ;;
    artifacts)
        list_artifacts "$2"
        ;;
    download)
        download_artifacts "$2"
        ;;
    trigger-ios)
        trigger_ios_build
        ;;
    trigger-android)
        trigger_android_build
        ;;
    setup)
        setup_credentials
        ;;
    -h|--help|"")
        usage
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        usage
        ;;
esac