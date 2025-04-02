#!/bin/bash
# Script to use Java 17 for Gradle builds

# Check if JAVA_HOME is set
if [ -z "$JAVA_HOME" ]; then
    echo "JAVA_HOME is not set. Cannot determine current Java installation."
    exit 1
fi

# Save current Java version
echo "Current Java version:"
java -version

# Find Java 17 in common locations
JAVA17_PATHS=(
    "/usr/lib/jvm/java-17-openjdk-amd64"
    "/usr/lib/jvm/java-17-oracle"
    "/opt/java/jdk-17"
)

JAVA17_PATH=""
for path in "${JAVA17_PATHS[@]}"; do
    if [ -d "$path" ]; then
        JAVA17_PATH="$path"
        break
    fi
done

if [ -z "$JAVA17_PATH" ]; then
    echo "Could not find Java 17 installation. Trying to install it..."
    
    # Try to install OpenJDK 17
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y openjdk-17-jdk
        JAVA17_PATH="/usr/lib/jvm/java-17-openjdk-amd64"
    else
        echo "Cannot install Java 17 automatically. Please install it manually."
        exit 1
    fi
fi

# Set JAVA_HOME to Java 17 for this session
export JAVA_HOME_BACKUP="$JAVA_HOME"
export JAVA_HOME="$JAVA17_PATH"
export PATH="$JAVA_HOME/bin:$PATH"

echo "Switched to Java 17 for Gradle build:"
java -version

# Run Gradle with Java 17
echo "Running Gradle with Java 17..."
./gradlew "$@"

# Restore original JAVA_HOME
export JAVA_HOME="$JAVA_HOME_BACKUP"
echo "Restored original Java version."
