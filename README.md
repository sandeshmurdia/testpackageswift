# RandomStringGenerator

A Swift library for generating random strings. This SDK is available as a binary framework specifically for iOS apps.

## Features

- Generate random strings of specified length
- Generate 10-letter random strings with a convenient method
- iOS-only optimized binary

## Requirements

- iOS 13.0+
- Swift 5.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/sandeshmurdia/RandomStringGenerator.git", from: "1.0.0")
]
```

Or add it directly in Xcode:
1. File > Add Packages...
2. Enter the repository URL: `https://github.com/sandeshmurdia/RandomStringGenerator.git`
3. Specify the version constraints

### CocoaPods

Add the following to your Podfile:

```ruby
pod 'RandomStringGenerator', '~> 1.0.0'
```

Then run:

```bash
pod install
```

## Usage

```swift
import RandomStringGenerator

// Create a new random string generator
let generator = RandomStringGenerator()

// Generate a random string of length 10
let randomString = generator.generateRandomString(length: 10)
print("Generated random string: \(randomString)")

// Generate a 10-letter string using the convenience method
let tenLetterString = generator.generate10LetterString()
print("Generated 10-letter string: \(tenLetterString)")
```

## License

This project is available under the MIT license. See the LICENSE file for more info.
