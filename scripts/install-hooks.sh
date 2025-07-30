#!/bin/bash

# Script to install git hooks for the project

HOOKS_DIR=".git/hooks"
SCRIPTS_DIR="scripts/git-hooks"

echo "🔧 Installing git hooks..."

# Create hooks directory if it doesn't exist
mkdir -p "$HOOKS_DIR"

# Copy pre-commit hook
if [ -f "$SCRIPTS_DIR/pre-commit" ]; then
    cp "$SCRIPTS_DIR/pre-commit" "$HOOKS_DIR/pre-commit"
    chmod +x "$HOOKS_DIR/pre-commit"
    echo "✅ Installed pre-commit hook"
else
    echo "⚠️  Pre-commit hook not found in $SCRIPTS_DIR"
fi

# Copy pre-push hook if exists
if [ -f "$SCRIPTS_DIR/pre-push" ]; then
    cp "$SCRIPTS_DIR/pre-push" "$HOOKS_DIR/pre-push"
    chmod +x "$HOOKS_DIR/pre-push"
    echo "✅ Installed pre-push hook"
fi

echo ""
echo "🎉 Git hooks installed successfully!"
echo ""
echo "The following checks will run:"
echo "  • Pre-commit: flutter analyze + code formatting"
echo ""
echo "To skip hooks temporarily, use: git commit --no-verify"
echo "