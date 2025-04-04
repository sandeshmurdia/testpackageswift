import XCTest
@testable import RandomStringGenerator

final class RandomStringGeneratorTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }

    func testGenerate10LetterString() {
        let generator = RandomStringGenerator()
        let result = generator.generate10LetterString()
        
        // Test string length
        XCTAssertEqual(result.count, 10, "Generated string should be exactly 10 characters long")
        
        // Test that string contains only letters
        let letterSet = CharacterSet.letters
        XCTAssertTrue(result.unicodeScalars.allSatisfy { letterSet.contains($0) }, "Generated string should contain only letters")
        
        // Test uniqueness (generate multiple strings and verify they're different)
        let anotherResult = generator.generate10LetterString()
        XCTAssertNotEqual(result, anotherResult, "Multiple generations should produce different strings")
    }
}
