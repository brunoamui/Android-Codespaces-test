#!/bin/bash
# Script to use Java 17 for Gradle builds

echo "Checking for Java 17..."

# Try to find Java 17 using update-alternatives
if command -v update-alternatives &> /dev/null; then
    JAVA17_PATH=$(update-alternatives --list java | grep "java-17" | head -n 1)
    if [ -n "$JAVA17_PATH" ]; then
        echo "Found Java 17 via update-alternatives: $JAVA17_PATH"
        # Extract the JDK path from the java binary path
        JAVA17_HOME=$(dirname $(dirname "$JAVA17_PATH"))
        echo "Setting JAVA_HOME to: $JAVA17_HOME"
        export JAVA_HOME="$JAVA17_HOME"
        export PATH="$JAVA_HOME/bin:$PATH"
        java -version
        ./gradlew "$@"
        exit $?
    fi
fi

# If we're here, we couldn't find Java 17 via update-alternatives
# Try to install it
echo "Java 17 not found. Attempting to install OpenJDK 17..."
if command -v apt-get &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y openjdk-17-jdk
    if [ $? -eq 0 ]; then
        echo "OpenJDK 17 installed successfully"
        export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
        export PATH="$JAVA_HOME/bin:$PATH"
        java -version
        ./gradlew "$@"
        exit $?
    else
        echo "Failed to install OpenJDK 17"
    fi
fi

# If we're here, we couldn't install Java 17
# Try to run with the current Java version but with special flags
echo "Attempting to run Gradle with current Java version and special flags..."
export GRADLE_OPTS="$GRADLE_OPTS -Dorg.gradle.jvmargs=--add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED"
./gradlew "$@"
