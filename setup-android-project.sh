#!/bin/bash
# Script to set up the Android project from scratch

echo "Setting up Android project..."

# Create necessary directories
mkdir -p app/src/main/java/com/example/helloworld
mkdir -p app/src/main/res/layout
mkdir -p app/src/main/res/values
mkdir -p app/src/main/res/drawable
mkdir -p app/src/main/res/mipmap-hdpi
mkdir -p app/src/test/java/com/example/helloworld
mkdir -p app/src/androidTest/java/com/example/helloworld
mkdir -p gradle/wrapper

# Download Gradle wrapper
./download-gradle-wrapper.sh

# Find Android SDK and update local.properties
chmod +x find-android-sdk.sh
./find-android-sdk.sh

# Make build scripts executable
chmod +x gradlew
chmod +x build-app.sh
chmod +x download-gradle-wrapper.sh

echo "Android project setup complete!"
