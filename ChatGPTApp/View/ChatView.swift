import SwiftUI
import OpenAISwift

struct ChatView: View {
    @ObservedObject var viewModel = ChatGPTViewModel()
    @State private var models = [MessageModel]()
    @State private var message = ""
    @FocusState var isActive: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollViewReader { proxy in
                    List(models) { model in
                        let alignment: HorizontalAlignment = (model.type == .me) ? .trailing : .leading
                        HStack {
                            if alignment == .trailing {
                                Spacer(minLength: 0)
                            }
                            
                            MessageView(message: model.message, sender: model.type.rawValue, alignment: alignment)
                                .padding(.top)
                            
                            if alignment == .leading {
                                Spacer(minLength: 0)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                    }
                    .listRowSeparator(.hidden)
                    .scrollContentBackground(.hidden)
                }
                .onTapGesture {
                    isActive = false
                }
                .background(.cyan)
                KeyboardToolbarView(message: $message, isActive: _isActive) {
                    sendMessage()
                }
            }
            .navigationTitle("ChatGPTへ質問")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    func sendMessage() {
        models.append(MessageModel(type: .me, message: message))
        Task {
            let meMessage = message
            if let reply = await viewModel.getData(text: meMessage) {
                models.append((MessageModel(type: .chatGPT, message: reply.trimmingCharacters(in: .newlines))))
            }
        }
    }
}

struct KeyboardToolbarView: View {
    @Binding var message: String
    @FocusState var isActive: Bool
    let sendMessage: (() -> Void)

    var body: some View {
        HStack(alignment: .center) {
            HStack(alignment: .center) {
                TextField("メッセージを入力…", text: $message)
                    .textFieldStyle(PlainTextFieldStyle())
                    .focused($isActive)
                    .padding(.leading)
            }
            .frame(height: 35)
            .background(.white)
            .cornerRadius(8)
            .padding(.leading)

            Button {
                sendMessage()
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
            }
            .padding(.trailing)
        }
    }
}

struct MessageView: View {
    let message: String
    let sender: String
    let alignment: HorizontalAlignment
    
    var body: some View {
        VStack(alignment: alignment) {
            Text(sender)
                .font(.caption)
            Text(message)
                .font(.body)
                .padding(.all, 5)
                .padding()
                .background(.green)
                .cornerRadius(8)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
