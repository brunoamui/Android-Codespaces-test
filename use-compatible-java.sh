#!/bin/bash
# Script to use a specific Java version for Gradle

echo "=== Setting up Java environment for Gradle ==="

# Save current Java version
CURRENT_JAVA_HOME=$JAVA_HOME
CURRENT_PATH=$PATH

# Try to find a compatible Java version
for java_version in 17 11 8; do
  echo "Looking for Java $java_version..."
  
  # Check common Java installation paths
  for java_path in \
    "/usr/lib/jvm/java-$java_version-openjdk-amd64" \
    "/usr/lib/jvm/java-$java_version-oracle" \
    "/usr/lib/jvm/java-$java_version-amazon-corretto" \
    "/usr/lib/jvm/java-$java_version-*"; do
    
    # Use glob expansion to find matching directories
    for dir in $java_path; do
      if [ -d "$dir" ] && [ -x "$dir/bin/java" ]; then
        echo "Found Java $java_version at $dir"
        export JAVA_HOME="$dir"
        export PATH="$JAVA_HOME/bin:$PATH"
        
        echo "Using Java version:"
        java -version
        
        # Run Gradle with this Java version
        echo "Running Gradle with Java $java_version..."
        ./gradlew "$@"
        
        # Save exit code
        RESULT=$?
        
        # Restore original Java environment
        export JAVA_HOME=$CURRENT_JAVA_HOME
        export PATH=$CURRENT_PATH
        
        # Return with the same exit code
        exit $RESULT
      fi
    done
  done
done

# If we get here, we couldn't find a compatible Java version
echo "Could not find a compatible Java version. Trying with current Java and compatibility flags..."

# Set Java compatibility flags
export JAVA_OPTS="--add-opens=java.base/java.util=ALL-UNNAMED \
  --add-opens=java.base/java.lang=ALL-UNNAMED \
  --add-opens=java.base/java.lang.reflect=ALL-UNNAMED \
  --add-opens=java.base/java.io=ALL-UNNAMED \
  --add-opens=java.base/java.net=ALL-UNNAMED"

# Set Gradle JVM arguments
export GRADLE_OPTS="-Dorg.gradle.jvmargs='$JAVA_OPTS'"

# Run Gradle command
echo "Running: ./gradlew $@"
./gradlew "$@"
