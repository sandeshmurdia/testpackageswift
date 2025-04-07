#!/bin/bash
set -e

# Configuration
FRAMEWORK_NAME="RandomStringGenerator"
VERSION="1.0.0"
GITHUB_USERNAME="sandeshmurdia" # Already set to your username

# Clean previous builds
rm -rf "build"
mkdir -p "build"

# Create temporary directories for archives
mkdir -p "build/archives"

# Build for iOS Device
echo "Building for iOS Device..."
xcodebuild archive \
  -scheme $FRAMEWORK_NAME \
  -destination "generic/platform=iOS" \
  -archivePath "build/archives/ios-device" \
  -sdk iphoneos \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Build for iOS Simulator
echo "Building for iOS Simulator..."
xcodebuild archive \
  -scheme $FRAMEWORK_NAME \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "build/archives/ios-simulator" \
  -sdk iphonesimulator \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Create XCFramework
echo "Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "build/archives/ios-device.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
  -framework "build/archives/ios-simulator.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
  -output "build/$FRAMEWORK_NAME.xcframework"

# Create a ZIP archive of the XCFramework
echo "Creating ZIP archive..."
cd build
zip -r "$FRAMEWORK_NAME.xcframework.zip" "$FRAMEWORK_NAME.xcframework"
cd ..

# Calculate the checksum for SPM
CHECKSUM=$(swift package compute-checksum "build/$FRAMEWORK_NAME.xcframework.zip")
echo "Checksum: $CHECKSUM"

# Update Distribution.swift with the checksum
cat > "Distribution.swift" << EOL
// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RandomStringGenerator",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "RandomStringGenerator",
            targets: ["RandomStringGenerator"]),
    ],
    targets: [
        .binaryTarget(
            name: "RandomStringGenerator",
            url: "https://github.com/$GITHUB_USERNAME/RandomStringGenerator/releases/download/$VERSION/RandomStringGenerator.xcframework.zip",
            checksum: "$CHECKSUM"
        )
    ]
)
EOL

echo "✅ XCFramework created at build/$FRAMEWORK_NAME.xcframework"
echo "✅ ZIP archive created at build/$FRAMEWORK_NAME.xcframework.zip"
echo "✅ Distribution.swift updated with correct checksum"
echo ""
echo "Next steps:"
echo "1. Create a new GitHub repository named RandomStringGenerator"
echo "2. Push your Distribution.swift as Package.swift to the main branch"
echo "3. Create a release with tag v$VERSION"
echo "4. Upload build/$FRAMEWORK_NAME.xcframework.zip to the release"
echo ""
echo "Users can then add your package using:"
echo "https://github.com/$GITHUB_USERNAME/RandomStringGenerator.git" 