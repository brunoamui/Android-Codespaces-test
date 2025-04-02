#!/bin/bash
# Script to find the Android SDK location

# Common locations for Android SDK
POSSIBLE_LOCATIONS=(
  "/opt/android-sdk"
  "/usr/local/android-sdk"
  "$HOME/android-sdk"
  "$ANDROID_SDK_ROOT"
  "$ANDROID_HOME"
)

# Check each location
for location in "${POSSIBLE_LOCATIONS[@]}"; do
  if [ -d "$location" ]; then
    echo "Found Android SDK at: $location"
    # Update local.properties
    echo "sdk.dir=$location" > local.properties
    echo "Updated local.properties with SDK location"
    exit 0
  fi
done

# If we get here, we couldn't find the SDK
echo "Could not find Android SDK. Please set sdk.dir in local.properties manually."
echo "Checking environment variables:"
echo "ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT"
echo "ANDROID_HOME=$ANDROID_HOME"
exit 1
