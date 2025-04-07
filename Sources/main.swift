// Example of using RandomStringGenerator
import RandomStringGenerator

// Create a new random string generator
let generator = RandomStringGenerator()

// Generate a random string of length 10
let randomString = generator.generateRandomString(length: 10)
print("Generated random string: \(randomString)")

// Generate a 10-letter string using the convenience method
let tenLetterString = generator.generate10LetterString()
print("Generated 10-letter string: \(tenLetterString)") 