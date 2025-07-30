#!/bin/bash

# Navigate to the Flutter project directory
cd /Users/rohansharma/Documents/GitHub/dlms-bcs/dlms-cloud/urjaview-mobile

# Check for connected devices
echo "Checking for connected devices..."
flutter devices

# Get dependencies
echo "Getting dependencies..."
flutter pub get

# Run the app on the connected device
echo "Running the app..."
flutter run