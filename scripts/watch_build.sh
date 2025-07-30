#!/bin/bash

# Watch a specific build
BUILD_ID=${1:-6889eab6e7817e4beb36a547}

source .env.local

echo "Monitoring build: $BUILD_ID"
echo "Build URL: https://codemagic.io/app/$CODEMAGIC_APP_ID/build/$BUILD_ID"
echo ""

while true; do
    STATUS=$(curl -s -H "x-auth-token: $CODEMAGIC_API_TOKEN" \
        "https://api.codemagic.io/builds?appId=$CODEMAGIC_APP_ID&limit=1" | \
        jq -r '.builds[0] | "\(.status)"')
    
    DETAILS=$(curl -s -H "x-auth-token: $CODEMAGIC_API_TOKEN" \
        "https://api.codemagic.io/builds?appId=$CODEMAGIC_APP_ID&limit=1" | \
        jq -r '.builds[0] | "Status: \(.status)\nWorkflow: \(.workflow.name // "ios-workflow")\nStarted: \(.startedAt // "pending")"')
    
    clear
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Build Monitor"
    echo "================================"
    echo "$DETAILS"
    echo "================================"
    
    if [[ "$STATUS" == "finished" ]] || [[ "$STATUS" == "failed" ]] || [[ "$STATUS" == "canceled" ]]; then
        echo ""
        echo "Build completed with status: $STATUS"
        
        if [[ "$STATUS" == "finished" ]]; then
            echo "✅ Build successful!"
        elif [[ "$STATUS" == "failed" ]]; then
            echo "❌ Build failed!"
        else
            echo "🚫 Build canceled!"
        fi
        break
    fi
    
    sleep 10
done