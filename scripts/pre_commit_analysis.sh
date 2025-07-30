#!/bin/bash

echo "🔍 Running pre-commit analysis..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track if any checks fail
FAILED=0

# 1. Run Flutter analyze
echo "📊 Running Flutter analyze..."
if flutter analyze; then
    echo -e "${GREEN}✓ Flutter analyze passed${NC}"
else
    echo -e "${RED}✗ Flutter analyze failed${NC}"
    FAILED=1
fi

# 2. Check for formatting issues
echo "🎨 Checking code formatting..."
if dart format --set-exit-if-changed --output=none . > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Code formatting is correct${NC}"
else
    echo -e "${YELLOW}⚠ Code needs formatting. Run: dart format .${NC}"
    FAILED=1
fi

# 3. Run tests if they exist
if [ -d "test" ] && [ "$(ls -A test)" ]; then
    echo "🧪 Running tests..."
    if flutter test; then
        echo -e "${GREEN}✓ All tests passed${NC}"
    else
        echo -e "${RED}✗ Some tests failed${NC}"
        FAILED=1
    fi
else
    echo -e "${YELLOW}ℹ No tests found${NC}"
fi

# 4. Check for TODOs and FIXMEs
echo "📝 Checking for TODOs and FIXMEs..."
TODO_COUNT=$(grep -r "TODO\|FIXME" lib/ --include="*.dart" | wc -l | tr -d ' ')
if [ "$TODO_COUNT" -gt 0 ]; then
    echo -e "${YELLOW}⚠ Found $TODO_COUNT TODO/FIXME comments:${NC}"
    grep -r "TODO\|FIXME" lib/ --include="*.dart" -n | head -5
    if [ "$TODO_COUNT" -gt 5 ]; then
        echo "   ... and $((TODO_COUNT - 5)) more"
    fi
fi

# 5. Check for print statements (should use debugPrint in production)
echo "🖨️  Checking for print statements..."
PRINT_COUNT=$(grep -r "print(" lib/ --include="*.dart" | grep -v "debugPrint" | wc -l | tr -d ' ')
if [ "$PRINT_COUNT" -gt 0 ]; then
    echo -e "${YELLOW}⚠ Found $PRINT_COUNT print statements (consider using debugPrint):${NC}"
    grep -r "print(" lib/ --include="*.dart" | grep -v "debugPrint" -n | head -3
fi

# 6. Check pubspec.lock is committed
if ! git ls-files --error-unmatch pubspec.lock > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠ pubspec.lock is not tracked by git${NC}"
fi

# Summary
echo ""
echo "📋 Pre-commit analysis complete!"
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some checks failed. Please fix the issues before committing.${NC}"
    exit 1
fi