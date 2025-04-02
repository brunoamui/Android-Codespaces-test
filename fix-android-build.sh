#!/bin/bash
# Script to fix common Android build issues

echo "=== Android Build Fixer ==="

# Step 1: Check Java installation
echo "Checking Java installation..."
if ! java -version 2>&1 >/dev/null; then
  echo "ERROR: Java is not installed or not in PATH"
  exit 1
else
  echo "Java is installed."
  java -version
fi

# Step 2: Check Android SDK
echo "Checking Android SDK..."
if [ -n "$ANDROID_SDK_ROOT" ]; then
  echo "ANDROID_SDK_ROOT is set to: $ANDROID_SDK_ROOT"
  SDK_DIR="$ANDROID_SDK_ROOT"
elif [ -n "$ANDROID_HOME" ]; then
  echo "ANDROID_HOME is set to: $ANDROID_HOME"
  SDK_DIR="$ANDROID_HOME"
else
  echo "Neither ANDROID_SDK_ROOT nor ANDROID_HOME is set."
  # Try to find Android SDK
  for dir in /opt/android /opt/android-sdk /usr/local/android-sdk $HOME/android-sdk; do
    if [ -d "$dir" ]; then
      echo "Found potential Android SDK at: $dir"
      SDK_DIR="$dir"
      break
    fi
  done
fi

if [ -n "$SDK_DIR" ]; then
  echo "Using Android SDK at: $SDK_DIR"
  echo "sdk.dir=$SDK_DIR" > local.properties
  echo "Updated local.properties with SDK location"
else
  echo "WARNING: Could not find Android SDK. Build will likely fail."
fi

# Step 3: Fix Gradle wrapper
echo "Fixing Gradle wrapper..."
mkdir -p gradle/wrapper

# Check if gradle-wrapper.jar exists and has content
if [ ! -s "gradle/wrapper/gradle-wrapper.jar" ]; then
  echo "gradle-wrapper.jar is missing or empty. Downloading..."
  
  # Try to download from multiple sources
  for url in \
    "https://repo.gradle.org/gradle/api/v1/dependency/download/gradle/gradle-wrapper/7.4.2/jar/gradle-wrapper-7.4.2.jar" \
    "https://github.com/gradle/gradle/raw/v7.4.2/gradle/wrapper/gradle-wrapper.jar" \
    "https://services.gradle.org/distributions/gradle-7.4.2-wrapper.jar"; do
    
    echo "Trying to download from: $url"
    if curl -L -o "gradle/wrapper/gradle-wrapper.jar" "$url"; then
      echo "Successfully downloaded Gradle wrapper JAR"
      break
    fi
  done
  
  # Check if download was successful
  if [ ! -s "gradle/wrapper/gradle-wrapper.jar" ]; then
    echo "WARNING: Failed to download Gradle wrapper JAR."
    
    # Try using system Gradle to generate wrapper
    if command -v gradle &> /dev/null; then
      echo "Using system Gradle to generate wrapper..."
      gradle wrapper --gradle-version 7.4.2
    else
      echo "ERROR: Gradle not found. Cannot generate wrapper."
      exit 1
    fi
  fi
else
  echo "gradle-wrapper.jar exists and has content."
fi

# Step 4: Make gradlew executable
echo "Making gradlew executable..."
chmod +x gradlew

# Step 5: Check for missing resource files
echo "Checking for missing resource files..."
mkdir -p app/src/main/res/mipmap-hdpi
mkdir -p app/src/main/res/mipmap-mdpi
mkdir -p app/src/main/res/mipmap-xhdpi
mkdir -p app/src/main/res/mipmap-xxhdpi
mkdir -p app/src/main/res/mipmap-xxxhdpi
mkdir -p app/src/main/res/drawable

# Step 6: Try building with system Gradle first
if command -v gradle &> /dev/null; then
  echo "Trying to build with system Gradle..."
  gradle clean build --info || echo "System Gradle build failed, will try with wrapper next."
fi

# Step 7: Try building with Gradle wrapper
echo "Building with Gradle wrapper..."
./gradlew clean build --info

# Check build result
if [ $? -eq 0 ]; then
  echo "=== Build successful! ==="
  echo "APK should be available at: app/build/outputs/apk/debug/app-debug.apk"
else
  echo "=== Build failed ==="
  echo "Check the error messages above for details."
  
  # Additional diagnostics
  echo "Showing environment information for debugging:"
  echo "Java version:"
  java -version
  echo "Gradle wrapper version (if available):"
  ./gradlew --version || echo "Gradle wrapper not working"
  echo "System Gradle version (if available):"
  gradle --version || echo "System Gradle not available"
  echo "Android SDK location:"
  echo "ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT"
  echo "ANDROID_HOME=$ANDROID_HOME"
  echo "local.properties content:"
  cat local.properties
fi

echo "=== End of Android Build Fixer ==="
