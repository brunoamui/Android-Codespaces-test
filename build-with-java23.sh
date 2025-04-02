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
  --add-opens=java.prefs/java.util.prefs=ALL-UNNAMED \
  --add-opens=jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED \
  --add-opens=jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED \
  --add-opens=jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED \
  --add-opens=jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED \
  --add-opens=jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED"

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

# Create a simplified build.gradle file for testing
TEMP_BUILD_GRADLE="temp_build.gradle"
cat > $TEMP_BUILD_GRADLE << 'EOF'
plugins {
    id 'java'
}

repositories {
    mavenCentral()
}

tasks.register('testBuild') {
    doLast {
        println "Test build successful!"
    }
}
EOF

# Try different build approaches
echo "Trying multiple build approaches..."

# 1. Try with system Gradle first using the simplified build file
if command -v gradle &> /dev/null; then
  echo "Trying with system Gradle and simplified build file..."
  gradle -b $TEMP_BUILD_GRADLE testBuild
  
  if [ $? -eq 0 ]; then
    echo "=== System Gradle test successful! Trying actual build... ==="
    gradle clean assembleDebug --info
    
    if [ $? -eq 0 ]; then
      echo "=== System Gradle build successful! ==="
      echo "APK is available at: app/build/outputs/apk/debug/app-debug.apk"
      rm $TEMP_BUILD_GRADLE
      exit 0
    fi
  fi
fi

# 2. Try with direct build as it's more likely to work
echo "Trying direct build without Gradle..."
chmod +x build-direct.sh
./build-direct.sh

if [ $? -eq 0 ]; then
  echo "=== Direct build successful! ==="
  rm -f $TEMP_BUILD_GRADLE
  exit 0
fi

# 3. Try with Gradle wrapper as last resort
echo "Trying with Gradle wrapper..."
chmod +x gradlew
./gradlew clean assembleDebug --info

if [ $? -eq 0 ]; then
  echo "=== Gradle wrapper build successful! ==="
  echo "APK is available at: app/build/outputs/apk/debug/app-debug.apk"
  rm -f $TEMP_BUILD_GRADLE
  exit 0
fi

# Clean up
rm -f $TEMP_BUILD_GRADLE
echo "All build attempts completed."
