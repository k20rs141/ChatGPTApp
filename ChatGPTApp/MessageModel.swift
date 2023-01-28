import Foundation

struct MessageModel: Identifiable, Hashable {
    let id: String
    let type: MessageSender
    let message: String

    init(type: MessageSender, message: String) {
        self.id = UUID().uuidString
        self.type = type
        self.message = message
    }
    
    enum MessageSender: String {
        case chatGPT = "GPT"
        case me = "ME"
    }
}
