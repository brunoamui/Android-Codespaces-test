#!/bin/bash
# Script to use Java compatibility flags for Gradle builds

echo "Setting up Java compatibility for Gradle..."

# Save original Java version for reference
echo "Current Java version:"
java -version

# Set special JVM arguments for Java 23 compatibility
export JAVA_OPTS="$JAVA_OPTS --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.net=ALL-UNNAMED"
export GRADLE_OPTS="$GRADLE_OPTS -Dorg.gradle.jvmargs='--add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.net=ALL-UNNAMED'"

echo "Running Gradle with compatibility flags..."
./gradlew "$@"
