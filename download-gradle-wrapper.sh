#!/bin/bash
# Script to download the Gradle wrapper JAR file

WRAPPER_JAR_PATH="gradle/wrapper/gradle-wrapper.jar"
WRAPPER_JAR_URL="https://github.com/gradle/gradle/raw/v7.4.2/gradle/wrapper/gradle-wrapper.jar"

mkdir -p gradle/wrapper
if [ ! -f "$WRAPPER_JAR_PATH" ]; then
    echo "Downloading Gradle wrapper JAR from $WRAPPER_JAR_URL"
    curl -L -o "$WRAPPER_JAR_PATH" "$WRAPPER_JAR_URL"
    echo "Downloaded Gradle wrapper JAR to $WRAPPER_JAR_PATH"
else
    echo "Gradle wrapper JAR already exists at $WRAPPER_JAR_PATH"
fi

# Make gradlew executable
chmod +x gradlew
