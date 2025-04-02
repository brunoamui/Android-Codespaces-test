#!/bin/bash
# Script to fix common Android build issues

echo "=== Android Build Fixer ==="

# Fix local.properties
echo "Updating local.properties..."
if [ -d "/opt/android-sdk" ]; then
    echo "sdk.dir=/opt/android-sdk" > local.properties
    echo "Updated to use /opt/android-sdk"
elif [ -d "/opt/android" ]; then
    echo "sdk.dir=/opt/android" > local.properties
    echo "Updated to use /opt/android"
elif [ -n "$ANDROID_HOME" ]; then
    echo "sdk.dir=$ANDROID_HOME" > local.properties
    echo "Updated to use ANDROID_HOME: $ANDROID_HOME"
elif [ -n "$ANDROID_SDK_ROOT" ]; then
    echo "sdk.dir=$ANDROID_SDK_ROOT" > local.properties
    echo "Updated to use ANDROID_SDK_ROOT: $ANDROID_SDK_ROOT"
else
    echo "WARNING: Could not find Android SDK"
fi

# Fix Gradle wrapper
echo "Fixing Gradle wrapper..."
if command -v gradle &> /dev/null; then
    echo "Using system Gradle to generate wrapper..."
    gradle wrapper --gradle-version 8.0
    chmod +x gradlew
else
    echo "System Gradle not found. Downloading wrapper JAR..."
    mkdir -p gradle/wrapper
    curl -L -o "gradle/wrapper/gradle-wrapper.jar" "https://github.com/gradle/gradle/raw/v8.0/gradle/wrapper/gradle-wrapper.jar"
    curl -L -o "gradle/wrapper/gradle-wrapper.properties" "https://raw.githubusercontent.com/gradle/gradle/v8.0/gradle/wrapper/gradle-wrapper.properties"
    chmod +x gradlew
fi

# Update build.gradle to use Java 17
echo "Updating build.gradle files..."
sed -i 's/sourceCompatibility JavaVersion.VERSION_1_8/sourceCompatibility JavaVersion.VERSION_17/g' app/build.gradle
sed -i 's/targetCompatibility JavaVersion.VERSION_1_8/targetCompatibility JavaVersion.VERSION_17/g' app/build.gradle

# Try to build with special flags for Java 23
echo "Building with special flags for Java 23..."
export GRADLE_OPTS="$GRADLE_OPTS -Dorg.gradle.jvmargs=--add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED"
./gradlew clean assembleDebug --stacktrace

if [ $? -eq 0 ]; then
    echo "=== Build successful! ==="
    echo "APK should be available at: app/build/outputs/apk/debug/app-debug.apk"
else
    echo "=== Build failed ==="
    echo "Trying alternative approach with Java 17..."
    chmod +x use-java-17.sh
    ./use-java-17.sh clean assembleDebug --stacktrace
fi

echo "=== End of Android Build Fixer ==="
