#!/bin/bash

# Pre-push script to catch compile errors before pushing to CI/CD

set -e

echo "🔍 Running pre-push checks..."

# 1. Flutter analyze
echo "📊 Running Flutter analyze..."
if ! flutter analyze; then
    echo "❌ Flutter analyze failed!"
    exit 1
fi

# 2. Check iOS build (this will catch all compile-time type errors)
echo "📱 Checking iOS build for compile errors..."
BUILD_OUTPUT=$(flutter build ios --release --no-codesign 2>&1)
if [ $? -ne 0 ]; then
    echo "❌ iOS build failed with errors:"
    echo "$BUILD_OUTPUT" | grep -E "Error:|error:" -A 2 -B 2
    exit 1
fi

echo "✅ All pre-push checks passed!"
echo "Build succeeded locally - safe to push."