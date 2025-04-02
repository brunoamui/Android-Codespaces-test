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
BUILD_DIR="app/build/direct"
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

# Create a simple R class to avoid compilation errors
cat > "$BUILD_DIR/src/com/example/helloworld/R.java" << EOF
package com.example.helloworld;

public final class R {
    public static final class layout {
        public static final int activity_main = 0x7f030001;
    }
    
    public static final class id {
        public static final int button_click_me = 0x7f070001;
        public static final int text_hello_world = 0x7f070002;
    }
}
EOF

# Compile Java files
echo "Compiling Java files..."
javac -d "$BUILD_DIR/classes" \
  -classpath "$SDK_DIR/platforms/android-33/android.jar" \
  "$BUILD_DIR/src/com/example/helloworld/BuildConfig.java" \
  "$BUILD_DIR/src/com/example/helloworld/R.java" \
  app/src/main/java/com/example/helloworld/BuildHelper.java \
  app/src/main/java/com/example/helloworld/MainActivity.java

if [ $? -eq 0 ]; then
  echo "Java compilation successful!"
  
  # Create APK structure
  echo "Creating APK structure..."
  mkdir -p "$BUILD_DIR/apk/META-INF"
  mkdir -p "$BUILD_DIR/apk/assets"
  mkdir -p "$BUILD_DIR/apk/classes"
  
  # Copying compiled classes
  echo "Copying compiled classes..."
  cp -r "$BUILD_DIR/classes/"* "$BUILD_DIR/apk/classes/"
  
  # Copying resources
  echo "Copying resources..."
  cp -r app/src/main/res "$BUILD_DIR/apk/"
  
  # Create a simple AndroidManifest.xml in the APK
  cp app/src/main/AndroidManifest.xml "$BUILD_DIR/apk/"
  
  # Create a simple APK
  echo "Creating APK..."
  cd "$BUILD_DIR/apk"
  zip -r "../app-debug.apk" .
  cd $(pwd | sed 's|/app/build/direct/apk||')
  
  echo "=== Build completed ==="
  echo "APK is available at: $BUILD_DIR/app-debug.apk"
  echo "Note: This is a simplified build and the APK may not be fully functional"
else
  echo "Java compilation failed"
  exit 1
fi
