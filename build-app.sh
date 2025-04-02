#!/bin/bash
# Script to build the Android app

# Set up the project
./setup-android-project.sh

# Initialize Gradle wrapper
echo "Initializing Gradle wrapper..."
chmod +x init-gradle-wrapper.sh
./init-gradle-wrapper.sh || {
    echo "Failed to initialize Gradle wrapper. Trying download script..."
    chmod +x download-gradle-wrapper.sh
    ./download-gradle-wrapper.sh
}

# Verify Gradle wrapper is working
echo "Verifying Gradle wrapper..."
./gradlew --version || {
    echo "ERROR: Gradle wrapper verification failed. Cannot proceed with build."
    exit 1
}

# Clean the project first
echo "Cleaning project..."
./gradlew clean --stacktrace || {
    echo "Clean failed, but continuing with build..."
}

# Build the app
echo "Building app..."
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
    ./gradlew --version || echo "Gradle wrapper not working"
fi
