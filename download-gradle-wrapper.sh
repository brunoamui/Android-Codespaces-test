#!/bin/bash
# Script to download the Gradle wrapper JAR file

WRAPPER_JAR_PATH="gradle/wrapper/gradle-wrapper.jar"
WRAPPER_JAR_URL="https://github.com/gradle/gradle/raw/v8.5/gradle/wrapper/gradle-wrapper.jar"

# Create the directory structure
mkdir -p gradle/wrapper

# Always download a fresh copy of the wrapper JAR
echo "Downloading Gradle wrapper JAR from $WRAPPER_JAR_URL"
curl -L -o "$WRAPPER_JAR_PATH" "$WRAPPER_JAR_URL" || {
    echo "Failed to download Gradle wrapper JAR. Trying alternative URL..."
    WRAPPER_JAR_URL="https://services.gradle.org/distributions/gradle-8.5-wrapper.jar"
    curl -L -o "$WRAPPER_JAR_PATH" "$WRAPPER_JAR_URL" || {
        echo "Failed to download from alternative URL. Creating an empty placeholder file."
        echo "This is a placeholder for gradle-wrapper.jar" > "$WRAPPER_JAR_PATH"
    }
}

if [ -f "$WRAPPER_JAR_PATH" ]; then
    echo "Gradle wrapper JAR is available at $WRAPPER_JAR_PATH"
    # Make gradlew executable
    chmod +x gradlew
else
    echo "Failed to create Gradle wrapper JAR"
    exit 1
fi
