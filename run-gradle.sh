#!/bin/bash
# Script to run Gradle with Java 23 compatibility flags

echo "=== Running Gradle with Java 23 compatibility flags ==="

# Set Java compatibility flags
export JAVA_OPTS="--add-opens=java.base/java.util=ALL-UNNAMED \
  --add-opens=java.base/java.lang=ALL-UNNAMED \
  --add-opens=java.base/java.lang.reflect=ALL-UNNAMED \
  --add-opens=java.base/java.io=ALL-UNNAMED \
  --add-opens=java.base/java.net=ALL-UNNAMED \
  --add-opens=java.base/java.nio=ALL-UNNAMED \
  --add-opens=java.base/java.util.concurrent=ALL-UNNAMED \
  --add-opens=java.base/java.text=ALL-UNNAMED \
  --add-opens=java.base/java.time=ALL-UNNAMED \
  --add-opens=java.base/java.util.stream=ALL-UNNAMED \
  --add-opens=java.base/java.util.regex=ALL-UNNAMED \
  --add-opens=java.base/java.util.concurrent.atomic=ALL-UNNAMED"

# Set Gradle JVM arguments
export GRADLE_OPTS="-Dorg.gradle.jvmargs='$JAVA_OPTS'"

# Run Gradle command
echo "Running: ./gradlew $@"
./gradlew "$@"

# Check exit code
if [ $? -eq 0 ]; then
  echo "=== Gradle command succeeded ==="
else
  echo "=== Gradle command failed ==="
fi
