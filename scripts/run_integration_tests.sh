#!/bin/bash

echo "🧪 Running Flutter Integration Tests..."

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to run a test
run_test() {
    local test_file=$1
    local test_name=$2
    
    echo -e "\n${YELLOW}Running: $test_name${NC}"
    
    if flutter test integration_test/$test_file; then
        echo -e "${GREEN}✓ $test_name passed${NC}"
        return 0
    else
        echo -e "${RED}✗ $test_name failed${NC}"
        return 1
    fi
}

# Check if a specific test file was provided
if [ $# -eq 1 ]; then
    echo "Running specific test: $1"
    flutter test integration_test/$1
    exit $?
fi

# Track overall test status
FAILED=0

# Get list of devices
echo "📱 Available devices:"
flutter devices

# Ask user to select device for testing
echo -e "\n${YELLOW}Please ensure a device/emulator is running${NC}"
echo "Press Enter to continue..."
read

# Run all integration tests
echo -e "\n${YELLOW}Running all integration tests...${NC}"

# Run splash screen tests
if ! run_test "splash_screen_test.dart" "Splash Screen Tests"; then
    FAILED=1
fi

# Run login screen tests
if ! run_test "login_screen_test.dart" "Login Screen Tests"; then
    FAILED=1
fi

# Summary
echo -e "\n${YELLOW}=== Test Summary ===${NC}"
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
else
    echo -e "${RED}✗ Some tests failed${NC}"
fi

exit $FAILED