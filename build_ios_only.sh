#!/bin/bash
set -e

# Configuration
FRAMEWORK_NAME="RandomStringGenerator"
VERSION="1.0.0"
GITHUB_USERNAME="sandeshmurdia"

# Clean previous builds
rm -rf "build"
mkdir -p "build"

# Create temporary build directories
mkdir -p "build/ios"
mkdir -p "build/ios-simulator"

echo "Building static library for iOS devices..."
# Build for iOS devices
xcrun -sdk iphoneos swiftc \
  Sources/RandomStringGenerator/*.swift \
  -emit-library \
  -emit-module \
  -module-name RandomStringGenerator \
  -O -whole-module-optimization \
  -target arm64-apple-ios13.0 \
  -output-file-map <(echo '{"": {"object": "build/ios/RandomStringGenerator.o"}}') \
  -o build/ios/libRandomStringGenerator.a

echo "Building static library for iOS simulators..."
# Build for iOS simulators
xcrun -sdk iphonesimulator swiftc \
  Sources/RandomStringGenerator/*.swift \
  -emit-library \
  -emit-module \
  -module-name RandomStringGenerator \
  -O -whole-module-optimization \
  -target arm64-apple-ios13.0-simulator \
  -target x86_64-apple-ios13.0-simulator \
  -output-file-map <(echo '{"": {"object": "build/ios-simulator/RandomStringGenerator.o"}}') \
  -o build/ios-simulator/libRandomStringGenerator.a

# Create XCFramework
echo "Creating XCFramework..."
xcodebuild -create-xcframework \
  -library build/ios/libRandomStringGenerator.a \
  -library build/ios-simulator/libRandomStringGenerator.a \
  -output build/RandomStringGenerator.xcframework

# Create ZIP archive
echo "Creating ZIP archive..."
cd build
zip -r RandomStringGenerator.xcframework.zip RandomStringGenerator.xcframework
cd ..

# Calculate checksum
CHECKSUM=$(swift package compute-checksum build/RandomStringGenerator.xcframework.zip)
echo "Checksum: $CHECKSUM"

# Create Package.swift for binary distribution
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

# Update CocoaPods podspec
cat > RandomStringGenerator.podspec << EOL
Pod::Spec.new do |spec|
  spec.name         = "RandomStringGenerator"
  spec.version      = "$VERSION"
  spec.summary      = "A Swift library for generating random strings"
  spec.description  = <<-DESC
                   RandomStringGenerator is a Swift library that provides functionality to generate random strings of specified lengths.
                   DESC
  spec.homepage     = "https://github.com/$GITHUB_USERNAME/RandomStringGenerator"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Your Name" => "email@example.com" }
  spec.ios.deployment_target = "13.0"
  spec.swift_version = "5.0"
  
  # Distribution as a binary framework
  spec.vendored_frameworks = "RandomStringGenerator.xcframework"
  
  # Specify the source location - this will be your GitHub repo
  spec.source       = { :http => "https://github.com/$GITHUB_USERNAME/RandomStringGenerator/releases/download/$VERSION/RandomStringGenerator.xcframework.zip" }
end
EOL

echo "✅ XCFramework created at build/RandomStringGenerator.xcframework"
echo "✅ ZIP archive created at build/RandomStringGenerator.xcframework.zip"
echo "✅ Distribution.swift created with checksum: $CHECKSUM"
echo "✅ CocoaPods podspec updated"
echo ""
echo "Next steps:"
echo "1. Create a GitHub repository named RandomStringGenerator"
echo "2. Push the essential files to GitHub:"
echo "   - LICENSE"
echo "   - README.md (create one if you don't have it)"
echo "   - Rename Distribution.swift to Package.swift and push it"
echo "   - RandomStringGenerator.podspec"
echo "3. Create a release with tag v$VERSION"
echo "4. Upload build/RandomStringGenerator.xcframework.zip to the release"
echo ""
echo "iOS developers can then use your package via:"
echo "- Swift Package Manager: https://github.com/$GITHUB_USERNAME/RandomStringGenerator.git"
echo "- CocoaPods: pod 'RandomStringGenerator'" 