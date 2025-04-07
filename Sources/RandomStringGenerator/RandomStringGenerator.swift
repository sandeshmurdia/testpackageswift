// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@frozen public struct RandomStringGenerator {
    public let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    public init() {}
    
    /// Generates a random 10-letter string
    /// - Returns: A string containing 10 random letters (both uppercase and lowercase)
    @inlinable public func generate10LetterString() -> String {
        generateRandomString(length: 10)
    }
    
    /// Generates a random string of specified length
    /// - Parameter length: The length of the string to generate
    /// - Returns: A string containing random letters (both uppercase and lowercase)
    @inlinable public func generateRandomString(length: Int) -> String {
        guard length > 0 else { return "" }
        
        return String((0..<length).map { _ in 
            letters.randomElement()! 
        })
    }
}
