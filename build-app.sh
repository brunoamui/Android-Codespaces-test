#!/bin/bash
# Script to build the Android app

# Download the Gradle wrapper JAR
./download-gradle-wrapper.sh

# Build the app
./gradlew assembleDebug --stacktrace

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "Build successful! APK is located at: app/build/outputs/apk/debug/app-debug.apk"
else
    echo "Build failed. See error messages above."
fi
