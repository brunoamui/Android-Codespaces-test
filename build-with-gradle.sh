#!/bin/bash
# Script to build the Android app with Gradle

echo "=== Building Android App with Gradle ==="

# Ensure SDK path is correct
if [ -d "/opt/android-sdk" ]; then
  SDK_DIR="/opt/android-sdk"
elif [ -d "/opt/android" ]; then
  SDK_DIR="/opt/android"
elif [ -n "$ANDROID_HOME" ]; then
  SDK_DIR="$ANDROID_HOME"
elif [ -n "$ANDROID_SDK_ROOT" ]; then
  SDK_DIR="$ANDROID_SDK_ROOT"
else
  echo "ERROR: Could not find Android SDK"
  exit 1
fi

echo "Using Android SDK at: $SDK_DIR"
echo "sdk.dir=$SDK_DIR" > local.properties

# Set Java compatibility flags for Java 23
export JAVA_OPTS="--add-opens=java.base/java.util=ALL-UNNAMED \
  --add-opens=java.base/java.lang=ALL-UNNAMED \
  --add-opens=java.base/java.lang.reflect=ALL-UNNAMED \
  --add-opens=java.base/java.io=ALL-UNNAMED \
  --add-opens=java.base/java.net=ALL-UNNAMED \
  --add-opens=java.base/java.nio=ALL-UNNAMED \
  --add-opens=java.base/java.util.concurrent=ALL-UNNAMED"

export GRADLE_OPTS="-Dorg.gradle.jvmargs='$JAVA_OPTS'"

# Make gradlew executable
chmod +x gradlew

# Clean and build the project
echo "Building the project with Gradle..."
./gradlew clean assembleDebug --info

if [ $? -eq 0 ]; then
  echo "=== Build successful! ==="
  echo "APK is available at: app/build/outputs/apk/debug/app-debug.apk"
  
  # Check if an Android device is connected
  if adb devices | grep -q "device$"; then
    echo "Android device detected. Would you like to install the APK? (y/n)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
      echo "Installing APK on device..."
      adb install -r app/build/outputs/apk/debug/app-debug.apk
      
      # Launch the app
      echo "Launching the app..."
      adb shell am start -n com.example.helloworld/.MainActivity
    fi
  else
    echo "No Android device detected. Connect a device to install the app."
  fi
else
  echo "=== Build failed ==="
  echo "Check the error messages above for details."
fi
