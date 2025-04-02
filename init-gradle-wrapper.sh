#!/bin/bash
# Script to initialize Gradle wrapper from scratch

echo "=== Initializing Gradle Wrapper ==="

# Check if Gradle is installed
if ! command -v gradle &> /dev/null; then
    echo "ERROR: Gradle is not installed. Please install Gradle first."
    exit 1
fi

# Create basic build.gradle if it doesn't exist
if [ ! -f "build.gradle" ]; then
    echo "Creating minimal build.gradle file..."
    cat > build.gradle << EOF
// Minimal build file
task wrapper(type: Wrapper) {
    gradleVersion = '8.0'
    distributionType = 'bin'
}
EOF
fi

# Generate wrapper files
echo "Generating Gradle wrapper files..."
gradle wrapper --gradle-version 8.0 --distribution-type bin

# Make gradlew executable
chmod +x gradlew

# Verify wrapper
echo "Verifying Gradle wrapper..."
./gradlew --version

if [ $? -eq 0 ]; then
    echo "=== Gradle wrapper initialized successfully ==="
else
    echo "=== Failed to initialize Gradle wrapper ==="
    exit 1
fi
