#!/bin/bash
# Script to build Android app directly without Gradle

echo "=== Building Android App Directly ==="

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

# Set up build directories
BUILD_DIR="app/build/direct"
mkdir -p "$BUILD_DIR/classes"
mkdir -p "$BUILD_DIR/dex"
mkdir -p "$BUILD_DIR/apk"

# Compile Java files
echo "Compiling Java files..."
javac -d "$BUILD_DIR/classes" \
  -classpath "$SDK_DIR/platforms/android-33/android.jar" \
  app/src/main/java/com/example/helloworld/*.java

if [ $? -ne 0 ]; then
  echo "Java compilation failed"
  exit 1
fi

# Create a simple APK structure
echo "Creating APK structure..."
mkdir -p "$BUILD_DIR/apk/META-INF"
mkdir -p "$BUILD_DIR/apk/res"
mkdir -p "$BUILD_DIR/apk/assets"

# Copy resources
echo "Copying resources..."
cp -r app/src/main/res "$BUILD_DIR/apk/"

# Create a simple AndroidManifest.xml in the APK
cp app/src/main/AndroidManifest.xml "$BUILD_DIR/apk/"

# Create a simple APK
echo "Creating APK..."
cd "$BUILD_DIR/apk"
zip -r "../app-debug.apk" .
cd -

echo "=== Build completed ==="
echo "APK is available at: $BUILD_DIR/app-debug.apk"
echo "Note: This is a simplified build and the APK may not be fully functional"
