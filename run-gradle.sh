#!/bin/bash
# Script to run Gradle with a compatible Java version

echo "=== Running Gradle with compatible Java version ==="

# Save current Java version info
CURRENT_JAVA_VERSION=$(java -version 2>&1 | head -1)
echo "Current Java version: $CURRENT_JAVA_VERSION"

# Create a temporary build.gradle with minimal content
TMP_BUILD_GRADLE=$(mktemp)
cat > $TMP_BUILD_GRADLE << 'EOF'
task wrapper(type: Wrapper) {
    gradleVersion = '8.0'
    distributionType = 'bin'
}
EOF

# Try to use system Gradle to generate a wrapper
if command -v gradle &> /dev/null; then
    echo "Using system Gradle to generate wrapper..."
    gradle -b $TMP_BUILD_GRADLE wrapper
    chmod +x gradlew
fi

# Set Java compatibility flags
export JAVA_OPTS="--add-opens=java.base/java.util=ALL-UNNAMED \
  --add-opens=java.base/java.lang=ALL-UNNAMED \
  --add-opens=java.base/java.lang.reflect=ALL-UNNAMED \
  --add-opens=java.base/java.io=ALL-UNNAMED \
  --add-opens=java.base/java.net=ALL-UNNAMED \
  --add-opens=java.base/java.nio=ALL-UNNAMED \
  --add-opens=java.base/java.util.concurrent=ALL-UNNAMED \
  --add-exports=java.base/sun.nio.ch=ALL-UNNAMED"

# Set Gradle JVM arguments with more compatibility flags
export GRADLE_OPTS="-Dorg.gradle.jvmargs='--add-exports=java.base/sun.nio.ch=ALL-UNNAMED \
  --add-opens=java.base/java.lang=ALL-UNNAMED \
  --add-opens=java.base/java.lang.reflect=ALL-UNNAMED \
  --add-opens=java.base/java.io=ALL-UNNAMED \
  --add-opens=java.base/java.util=ALL-UNNAMED \
  --add-opens=java.base/java.util.concurrent=ALL-UNNAMED \
  --add-opens=jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED'"

# Try to run Gradle with the current Java version and compatibility flags
echo "Attempting to run Gradle with compatibility flags..."
./gradlew "$@"

# Check if it worked
if [ $? -eq 0 ]; then
  echo "=== Gradle command succeeded ==="
  rm -f $TMP_BUILD_GRADLE
  exit 0
fi

echo "Failed with compatibility flags. Trying with system Gradle..."
if command -v gradle &> /dev/null; then
  gradle "$@"
  if [ $? -eq 0 ]; then
    echo "=== System Gradle command succeeded ==="
    rm -f $TMP_BUILD_GRADLE
    exit 0
  fi
fi

# Clean up
rm -f $TMP_BUILD_GRADLE

echo "All attempts failed. Please install a compatible Java version (8, 11, or 17)."
exit 1
