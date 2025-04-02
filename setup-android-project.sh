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

# Create a simple local.properties file
echo "sdk.dir=$ANDROID_SDK_ROOT" > local.properties

# Make build scripts executable
chmod +x gradlew
chmod +x build-app.sh
chmod +x download-gradle-wrapper.sh

echo "Android project setup complete!"
