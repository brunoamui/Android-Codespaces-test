#!/bin/bash
# Script to build Android app with Java 23 compatibility

echo "=== Building Android App with Java 23 Compatibility ==="

# Set extensive environment variables for Java 23 compatibility
export JAVA_OPTS="--add-opens=java.base/java.util=ALL-UNNAMED \
  --add-opens=java.base/java.lang=ALL-UNNAMED \
  --add-opens=java.base/java.lang.reflect=ALL-UNNAMED \
  --add-opens=java.base/java.io=ALL-UNNAMED \
  --add-opens=java.base/java.net=ALL-UNNAMED \
  --add-opens=java.base/java.nio=ALL-UNNAMED \
  --add-opens=java.base/java.util.concurrent=ALL-UNNAMED \
  --add-opens=java.base/java.text=ALL-UNNAMED \
  --add-opens=java.base/java.util.stream=ALL-UNNAMED \
  --add-opens=java.base/java.util.regex=ALL-UNNAMED \
  --add-opens=java.base/java.time=ALL-UNNAMED \
  --add-exports=java.base/sun.nio.ch=ALL-UNNAMED \
  --add-opens=java.prefs/java.util.prefs=ALL-UNNAMED"

export GRADLE_OPTS="-Dorg.gradle.jvmargs='$JAVA_OPTS'"

# Ensure SDK path is correct
if [ -d "/opt/android-sdk" ]; then
  echo "sdk.dir=/opt/android-sdk" > local.properties
  echo "Using SDK at /opt/android-sdk"
elif [ -d "/opt/android" ]; then
  echo "sdk.dir=/opt/android" > local.properties
  echo "Using SDK at /opt/android"
elif [ -n "$ANDROID_HOME" ]; then
  echo "sdk.dir=$ANDROID_HOME" > local.properties
  echo "Using SDK from ANDROID_HOME: $ANDROID_HOME"
elif [ -n "$ANDROID_SDK_ROOT" ]; then
  echo "sdk.dir=$ANDROID_SDK_ROOT" > local.properties
  echo "Using SDK from ANDROID_SDK_ROOT: $ANDROID_SDK_ROOT"
fi

# Try different build approaches
echo "Trying multiple build approaches..."

# 1. Try with system Gradle first
if command -v gradle &> /dev/null; then
  echo "Trying with system Gradle..."
  gradle clean assembleDebug --info
  
  if [ $? -eq 0 ]; then
    echo "=== System Gradle build successful! ==="
    echo "APK is available at: app/build/outputs/apk/debug/app-debug.apk"
    exit 0
  fi
fi

# 2. Try with Gradle wrapper
echo "Trying with Gradle wrapper..."
chmod +x gradlew
./gradlew clean assembleDebug --info

if [ $? -eq 0 ]; then
  echo "=== Gradle wrapper build successful! ==="
  echo "APK is available at: app/build/outputs/apk/debug/app-debug.apk"
  exit 0
fi

# 3. Try with run-gradle.sh script
echo "Trying with run-gradle.sh script..."
chmod +x run-gradle.sh
./run-gradle.sh clean assembleDebug --info

if [ $? -eq 0 ]; then
  echo "=== run-gradle.sh build successful! ==="
  echo "APK is available at: app/build/outputs/apk/debug/app-debug.apk"
  exit 0
fi

# 4. Try direct build as last resort
echo "Trying direct build without Gradle..."
chmod +x build-direct.sh
./build-direct.sh

echo "All build attempts completed."
