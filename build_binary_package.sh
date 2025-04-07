#!/bin/bash
set -e

# Configuration
FRAMEWORK_NAME="RandomStringGenerator"
VERSION="1.0.0"
GITHUB_USERNAME="sandeshmurdia" # Replace with your actual GitHub username

# Clean previous builds
rm -rf "build"
mkdir -p "build"

# Step 1: Build the framework with static Swift interface
echo "Building Swift Package..."
swift build -c release

# Find the binary
BINARY_PATH=$(find .build -name "libRandomStringGenerator.a" | head -n 1)
if [ -z "$BINARY_PATH" ]; then
    echo "Error: Could not find libRandomStringGenerator.a"
    exit 1
fi

echo "Found binary at $BINARY_PATH"

# Step 2: Create a framework structure
FRAMEWORK_DIR="build/$FRAMEWORK_NAME.framework"
mkdir -p "$FRAMEWORK_DIR/Modules"
mkdir -p "$FRAMEWORK_DIR/Headers"

# Copy the binary
cp "$BINARY_PATH" "$FRAMEWORK_DIR/$FRAMEWORK_NAME"

# Create module map
cat > "$FRAMEWORK_DIR/Modules/module.modulemap" << EOL
framework module $FRAMEWORK_NAME {
    header "$FRAMEWORK_NAME.h"
    export *
}
EOL

# Create a dummy header file
cat > "$FRAMEWORK_DIR/Headers/$FRAMEWORK_NAME.h" << EOL
#import <Foundation/Foundation.h>

//! Project version number for $FRAMEWORK_NAME.
FOUNDATION_EXPORT double ${FRAMEWORK_NAME}VersionNumber;

//! Project version string for $FRAMEWORK_NAME.
FOUNDATION_EXPORT const unsigned char ${FRAMEWORK_NAME}VersionString[];
EOL

# Create Info.plist
cat > "$FRAMEWORK_DIR/Info.plist" << EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>$FRAMEWORK_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>com.$GITHUB_USERNAME.$FRAMEWORK_NAME</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$FRAMEWORK_NAME</string>
    <key>CFBundlePackageType</key>
    <string>FMWK</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
</dict>
</plist>
EOL

# Step 3: Create XCFramework
echo "Creating XCFramework..."
xcodebuild -create-xcframework \
  -library "$BINARY_PATH" \
  -output "build/$FRAMEWORK_NAME.xcframework"

# Step 4: Create a ZIP archive
echo "Creating ZIP archive..."
cd build
zip -r "$FRAMEWORK_NAME.xcframework.zip" "$FRAMEWORK_NAME.xcframework"
cd ..

# Step 5: Calculate the checksum
CHECKSUM=$(swift package compute-checksum "build/$FRAMEWORK_NAME.xcframework.zip")
echo "Checksum: $CHECKSUM"

# Step 6: Update the Distribution.swift file with the correct checksum
sed -i '' "s/CHECKSUM_PLACEHOLDER/$CHECKSUM/g" Distribution.swift
sed -i '' "s/YOUR_ACTUAL_GITHUB_USERNAME/$GITHUB_USERNAME/g" Distribution.swift

echo "✅ XCFramework created at build/$FRAMEWORK_NAME.xcframework"
echo "✅ ZIP archive created at build/$FRAMEWORK_NAME.xcframework.zip"
echo "✅ Distribution.swift updated with correct checksum"
echo ""
echo "Next steps:"
echo "1. Create a new GitHub repository named $FRAMEWORK_NAME"
echo "2. Push your code to GitHub (or just push the Distribution.swift and the binary)"
echo "3. Create a new release with tag v$VERSION"
echo "4. Upload the build/$FRAMEWORK_NAME.xcframework.zip file to the release"
echo "5. Rename Distribution.swift to Package.swift and push it to the main branch"
echo ""
echo "Users can then add your package using:"
echo "https://github.com/$GITHUB_USERNAME/$FRAMEWORK_NAME.git" 