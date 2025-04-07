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
            type: .dynamic,
            targets: ["RandomStringGenerator"]),
    ],
    targets: [
        .target(
            name: "RandomStringGenerator",
            dependencies: []),
        .testTarget(
            name: "RandomStringGeneratorTests",
            dependencies: ["RandomStringGenerator"]),
    ]
)
