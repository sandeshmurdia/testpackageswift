// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct RandomStringGenerator {
    public init() {}
    
    /// Generates a random 10-letter string
    /// - Returns: A string containing 10 random letters (both uppercase and lowercase)
    public func generate10LetterString() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0..<10).map { _ in letters.randomElement()! })
    }
}
