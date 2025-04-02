#!/bin/bash
# Script to build Android app with Java 23 compatibility

echo "=== Building Android App with Java 23 Compatibility ==="

# Set environment variables for Java 23 compatibility
export JAVA_OPTS="--add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.net=ALL-UNNAMED"
export GRADLE_OPTS="-Dorg.gradle.jvmargs='--add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.net=ALL-UNNAMED'"

# Ensure SDK path is correct
if [ -d "/opt/android-sdk" ]; then
  echo "sdk.dir=/opt/android-sdk" > local.properties
elif [ -d "/opt/android" ]; then
  echo "sdk.dir=/opt/android" > local.properties
elif [ -n "$ANDROID_HOME" ]; then
  echo "sdk.dir=$ANDROID_HOME" > local.properties
elif [ -n "$ANDROID_SDK_ROOT" ]; then
  echo "sdk.dir=$ANDROID_SDK_ROOT" > local.properties
fi

# Make sure Gradle wrapper is executable
chmod +x gradlew

# Clean and build
echo "Running Gradle build..."
./gradlew clean assembleDebug --info

# Check build result
if [ $? -eq 0 ]; then
  echo "=== Build successful! ==="
  echo "APK is available at: app/build/outputs/apk/debug/app-debug.apk"
else
  echo "=== Build failed ==="
  echo "See error messages above for details."
fi
