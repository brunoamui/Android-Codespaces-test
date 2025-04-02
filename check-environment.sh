#!/bin/bash
# Script to check the environment and fix common issues

echo "=== Environment Check ==="

# Check Java version
echo "Java version:"
java -version

# Check Android SDK location
echo "Checking Android SDK location..."
if [ -d "/opt/android-sdk" ]; then
  echo "Found Android SDK at /opt/android-sdk"
  echo "sdk.dir=/opt/android-sdk" > local.properties
elif [ -d "/opt/android" ]; then
  echo "Found Android SDK at /opt/android"
  echo "sdk.dir=/opt/android" > local.properties
elif [ -n "$ANDROID_HOME" ]; then
  echo "Using ANDROID_HOME: $ANDROID_HOME"
  echo "sdk.dir=$ANDROID_HOME" > local.properties
elif [ -n "$ANDROID_SDK_ROOT" ]; then
  echo "Using ANDROID_SDK_ROOT: $ANDROID_SDK_ROOT"
  echo "sdk.dir=$ANDROID_SDK_ROOT" > local.properties
else
  echo "Could not find Android SDK"
fi

# Check if we need to update Gradle wrapper
echo "Checking Gradle wrapper..."
JAVA_VERSION=$(java -version 2>&1 | grep -i version | cut -d'"' -f2 | cut -d'.' -f1)
echo "Java major version: $JAVA_VERSION"

if [ "$JAVA_VERSION" -ge "21" ]; then
  echo "Using Java $JAVA_VERSION, updating Gradle wrapper to 8.4..."
  sed -i 's/distributionUrl=.*$/distributionUrl=https\\:\/\/services.gradle.org\/distributions\/gradle-8.4-bin.zip/' gradle/wrapper/gradle-wrapper.properties
elif [ "$JAVA_VERSION" -ge "17" ]; then
  echo "Using Java $JAVA_VERSION, updating Gradle wrapper to 8.0..."
  sed -i 's/distributionUrl=.*$/distributionUrl=https\\:\/\/services.gradle.org\/distributions\/gradle-8.0-bin.zip/' gradle/wrapper/gradle-wrapper.properties
else
  echo "Using Java $JAVA_VERSION, keeping current Gradle version"
fi

echo "=== Environment Check Complete ==="
