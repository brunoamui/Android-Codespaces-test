#!/bin/bash
# Script to download the Gradle wrapper JAR file

WRAPPER_JAR_PATH="gradle/wrapper/gradle-wrapper.jar"
GRADLE_VERSION="8.5"

# Create the directory structure
mkdir -p gradle/wrapper

# Try multiple sources for the Gradle wrapper JAR
echo "Downloading Gradle wrapper JAR..."

# First try: Direct download from Gradle's GitHub repository
curl -L -o "$WRAPPER_JAR_PATH" "https://github.com/gradle/gradle/raw/v$GRADLE_VERSION/gradle/wrapper/gradle-wrapper.jar" || {
    echo "Failed first download attempt. Trying alternative URL..."
    
    # Second try: From Gradle distributions
    curl -L -o "$WRAPPER_JAR_PATH" "https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-wrapper.jar" || {
        echo "Failed second download attempt. Trying another alternative..."
        
        # Third try: From Maven Central
        curl -L -o "$WRAPPER_JAR_PATH" "https://repo1.maven.org/maven2/org/gradle/gradle-wrapper/$GRADLE_VERSION/gradle-wrapper-$GRADLE_VERSION.jar" || {
            echo "All download attempts failed. Generating wrapper using Gradle if available..."
            
            # Try using system Gradle to generate the wrapper
            if command -v gradle &> /dev/null; then
                echo "Using system Gradle to generate wrapper..."
                gradle wrapper --gradle-version $GRADLE_VERSION
            else
                echo "ERROR: Could not download or generate Gradle wrapper JAR."
                exit 1
            fi
        }
    }
}

# Verify the JAR file is valid
if [ -s "$WRAPPER_JAR_PATH" ]; then
    echo "Gradle wrapper JAR is available at $WRAPPER_JAR_PATH ($(du -h "$WRAPPER_JAR_PATH" | cut -f1) in size)"
    # Make gradlew executable
    chmod +x gradlew
    echo "Made gradlew executable"
else
    echo "ERROR: Gradle wrapper JAR is empty or missing"
    exit 1
fi
