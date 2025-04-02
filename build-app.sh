#!/bin/bash
# Script to build the Android app

# Set up the project
./setup-android-project.sh

# Download the Gradle wrapper JAR
./download-gradle-wrapper.sh

# Clean the project first
./gradlew clean --stacktrace || {
    echo "Clean failed, but continuing with build..."
}

# Build the app
./gradlew assembleDebug --stacktrace

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "Build successful! APK is located at: app/build/outputs/apk/debug/app-debug.apk"
else
    echo "Build failed. See error messages above."
    
    # Print environment information for debugging
    echo "Environment information:"
    echo "Java version:"
    java -version
    echo "Android SDK location:"
    echo $ANDROID_SDK_ROOT
    echo "Gradle version:"
    ./gradlew --version
fi
