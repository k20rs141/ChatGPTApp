import Foundation
import OpenAISwift

final class ChatGPTViewModel: ObservableObject {
    private var client: OpenAISwift?
    
    init() {
        client = OpenAISwift(authToken: apiKey)
    }
    
    func getData(text: String) async -> String? {
        guard let client = client else { return nil }
        
        do {
            let result = try await client.sendCompletion(with: text, maxTokens: 500)
            print("chatGPT: \(String(describing: result.choices.first?.text))")
            return result.choices.first?.text
        } catch {
            print(error)
            return nil
        }
    }
}
