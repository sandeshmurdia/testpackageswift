#!/bin/bash
set -e

# Configuration
FRAMEWORK_NAME="RandomStringGenerator"
BUILD_DIR="$(pwd)/.build"
XCFRAMEWORK_PATH="$(pwd)/build/$FRAMEWORK_NAME.xcframework"

# Clean previous builds
rm -rf "$(pwd)/build"
mkdir -p "$(pwd)/build"

# Create temporary directories
IOS_SIM_DIR="$(pwd)/build/ios-simulator"
IOS_DIR="$(pwd)/build/ios"

mkdir -p "$IOS_SIM_DIR" "$IOS_DIR"

echo "Building for iOS Simulator..."
# Build for iOS Simulator
xcodebuild archive \
  -scheme $FRAMEWORK_NAME \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$FRAMEWORK_NAME-iOS-Simulator" \
  -sdk iphonesimulator \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES
  
echo "Building for iOS..."
# Build for iOS
xcodebuild archive \
  -scheme $FRAMEWORK_NAME \
  -destination "generic/platform=iOS" \
  -archivePath "$FRAMEWORK_NAME-iOS" \
  -sdk iphoneos \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Extract the frameworks
mkdir -p "$IOS_SIM_DIR" "$IOS_DIR"
cp -R "$FRAMEWORK_NAME-iOS-Simulator.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" "$IOS_SIM_DIR"
cp -R "$FRAMEWORK_NAME-iOS.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" "$IOS_DIR"

# Create XCFramework
echo "Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "$IOS_DIR/$FRAMEWORK_NAME.framework" \
  -framework "$IOS_SIM_DIR/$FRAMEWORK_NAME.framework" \
  -output "$XCFRAMEWORK_PATH"

# Clean up temporary files
rm -rf "$FRAMEWORK_NAME-iOS-Simulator.xcarchive" "$FRAMEWORK_NAME-iOS.xcarchive"

# Create a ZIP archive (optional)
cd "$(pwd)/build"
zip -r "$FRAMEWORK_NAME.xcframework.zip" "$FRAMEWORK_NAME.xcframework"
cd -

echo "✅ XCFramework created at $XCFRAMEWORK_PATH"
echo "✅ ZIP archive created at $(pwd)/build/$FRAMEWORK_NAME.xcframework.zip" 