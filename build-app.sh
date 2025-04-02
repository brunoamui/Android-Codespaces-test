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

# Make Java 17 script executable
chmod +x use-java-17.sh

# Verify Gradle wrapper is working with Java 17
echo "Verifying Gradle wrapper with Java 17..."
./use-java-17.sh --version || {
    echo "ERROR: Gradle wrapper verification failed. Cannot proceed with build."
    exit 1
}

# Clean the project first
echo "Cleaning project..."
./use-java-17.sh clean --stacktrace || {
    echo "Clean failed, but continuing with build..."
}

# Build the app
echo "Building app..."
./use-java-17.sh assembleDebug --stacktrace

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
