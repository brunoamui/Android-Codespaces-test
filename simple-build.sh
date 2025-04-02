#!/bin/bash
# Simple script to build the Android app with minimal dependencies

echo "=== Simple Android Build ==="

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

# Set up build directories
BUILD_DIR="app/build/simple"
mkdir -p "$BUILD_DIR/classes"
mkdir -p "$BUILD_DIR/apk"

# Create a simple BuildConfig class
mkdir -p "$BUILD_DIR/src/com/example/helloworld"
cat > "$BUILD_DIR/src/com/example/helloworld/BuildConfig.java" << EOF
package com.example.helloworld;

public final class BuildConfig {
    public static final boolean DEBUG = true;
    public static final String APPLICATION_ID = "com.example.helloworld";
    public static final String BUILD_TYPE = "debug";
    public static final int VERSION_CODE = 1;
    public static final String VERSION_NAME = "1.0";
}
EOF

# Compile Java files
echo "Compiling Java files..."
javac -d "$BUILD_DIR/classes" \
  -classpath "$SDK_DIR/platforms/android-33/android.jar" \
  "$BUILD_DIR/src/com/example/helloworld/BuildConfig.java" \
  app/src/main/java/com/example/helloworld/*.java

if [ $? -eq 0 ]; then
  echo "Java compilation successful!"
  echo "Classes are available at: $BUILD_DIR/classes"
  
  # Create a simple JAR file
  echo "Creating JAR file..."
  jar cf "$BUILD_DIR/app.jar" -C "$BUILD_DIR/classes" .
  
  echo "=== Build completed ==="
  echo "JAR is available at: $BUILD_DIR/app.jar"
else
  echo "Java compilation failed"
  exit 1
fi
