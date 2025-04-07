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
            url: "https://github.com/sandeshmurdia/RandomStringGenerator/releases/download/1.0.0/RandomStringGenerator.xcframework.zip",
            checksum: "b7b89dadc53cea048bc4c9966831efab837bdde81f2278d68cabb6704f52b03e"
        )
    ]
)
