import SwiftUI
import RandomStringGenerator

struct ContentView: View {
    @State private var randomString: String = ""
    private let generator = RandomStringGenerator()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(randomString.isEmpty ? "Press the button to generate" : randomString)
                .font(.title)
                .padding()
            
            Button("Generate Random String") {
                randomString = generator.generateRandomString(length: 10)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
} 