#!/bin/bash
set -e

# Configuration
FRAMEWORK_NAME="RandomStringGenerator"
VERSION="1.0.0"
GITHUB_USERNAME="sandeshmurdia" # Already set to your username

# Clean previous builds
rm -rf "build"
mkdir -p "build"

# Create a temporary project structure for Xcode
TEMP_PROJECT_DIR="build/temp_project"
mkdir -p "$TEMP_PROJECT_DIR/RandomStringGenerator"

# Copy Swift source files to temp directory
cp -R Sources/RandomStringGenerator/*.swift "$TEMP_PROJECT_DIR/RandomStringGenerator/"

# Create an Xcode project
cat > "$TEMP_PROJECT_DIR/RandomStringGenerator.xcodeproj/project.pbxproj" << EOL
// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {
		8D8B9C542B99F4BE00ABC123 /* RandomStringGenerator.h */ = {
			isa = PBXFileReference;
			lastKnownFileType = sourcecode.c.h;
			path = RandomStringGenerator.h;
			sourceTree = "<group>";
		};
		8D8B9C552B99F4BE00ABC123 /* RandomStringGenerator.swift */ = {
			isa = PBXFileReference;
			lastKnownFileType = sourcecode.swift;
			path = RandomStringGenerator.swift;
			sourceTree = "<group>";
		};
	};
	rootObject = 8D8B9C472B99F4BE00ABC123 /* Project object */;
}
EOL

# Create framework header
mkdir -p "$TEMP_PROJECT_DIR/RandomStringGenerator"
cat > "$TEMP_PROJECT_DIR/RandomStringGenerator/RandomStringGenerator.h" << EOL
#import <Foundation/Foundation.h>

//! Project version number for RandomStringGenerator.
FOUNDATION_EXPORT double RandomStringGeneratorVersionNumber;

//! Project version string for RandomStringGenerator.
FOUNDATION_EXPORT const unsigned char RandomStringGeneratorVersionString[];
EOL

# Build binary directly using swiftc for iOS
echo "Building Swift module for iOS..."
mkdir -p build/ios/RandomStringGenerator.framework
mkdir -p build/ios-simulator/RandomStringGenerator.framework

# Compile for iOS devices
xcrun -sdk iphoneos swiftc \
  -emit-library \
  -o build/ios/RandomStringGenerator.framework/RandomStringGenerator \
  -emit-module \
  -module-name RandomStringGenerator \
  -parse-as-library \
  -target arm64-apple-ios13.0 \
  -O -whole-module-optimization \
  Sources/RandomStringGenerator/*.swift

# Compile for iOS simulators
xcrun -sdk iphonesimulator swiftc \
  -emit-library \
  -o build/ios-simulator/RandomStringGenerator.framework/RandomStringGenerator \
  -emit-module \
  -module-name RandomStringGenerator \
  -parse-as-library \
  -target arm64-apple-ios13.0-simulator -target x86_64-apple-ios13.0-simulator \
  -O -whole-module-optimization \
  Sources/RandomStringGenerator/*.swift

# Copy the module files
cp -R *.swiftmodule build/ios/RandomStringGenerator.framework/
cp -R *.swiftmodule build/ios-simulator/RandomStringGenerator.framework/

# Create XCFramework
echo "Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework build/ios/RandomStringGenerator.framework \
  -framework build/ios-simulator/RandomStringGenerator.framework \
  -output build/RandomStringGenerator.xcframework

# Create ZIP archive
echo "Creating ZIP archive..."
cd build
zip -r RandomStringGenerator.xcframework.zip RandomStringGenerator.xcframework
cd ..

# Calculate checksum
CHECKSUM=$(swift package compute-checksum build/RandomStringGenerator.xcframework.zip)
echo "Checksum: $CHECKSUM"

# Create Distribution.swift (Package.swift for binary distribution)
cat > Distribution.swift << EOL
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

echo "✅ XCFramework created at build/RandomStringGenerator.xcframework"
echo "✅ ZIP archive created at build/RandomStringGenerator.xcframework.zip"
echo "✅ Distribution.swift created with correct checksum"
echo ""
echo "Next steps:"
echo "1. Create a GitHub repository named RandomStringGenerator"
echo "2. Rename Distribution.swift to Package.swift and push it to the main branch"
echo "3. Create a release with tag v$VERSION"
echo "4. Upload build/RandomStringGenerator.xcframework.zip to the release"
echo ""
echo "Users can then add your iOS-only package using:"
echo "https://github.com/$GITHUB_USERNAME/RandomStringGenerator.git" 