//
//  ContentView.swift
//  Tekk
//
//  Created by Jordan on 7/9/24.
//

import SwiftUI
//import GoogleGenerativeAI

struct ContentView: View {
//    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    @State private var messageText = ""
    @State var chatMessages: [String] = ["Welcome to TekkAI"]
    
    var body: some View {
        TabView {
            View_Chatbot()
                .tabItem() {
                    Image(systemName: "message.fill")
                    Text("Chat")
                }
            ViewB()
                .tabItem() {
                    Image(systemName: "person.2.fill")
                    Text("Contacts")
                }
            ViewC()
                .tabItem() {
                    Image(systemName: "slider.horizontal.3")
                    Text("Settings")
                }
        }
        .accentColor(.green)
    }
    
    func sendMessage(message: String) {
        withAnimation {
            chatMessages.append("[USER]" + message)
            self.messageText = ""
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            chatMessages.append(getBotResponse(message: message))
        }
    }
    
//    func sendMessage(message: String) {
//        guard !message.isEmpty else { return }
//        chatMessages.append("You: \(message)")
//        messageText = ""
//
//        // Make the network request to the Gemini API
//        getBotResponse(prompt: message) { response in
//            DispatchQueue.main.async {
//                chatMessages.append("Coach: \(response)")
//            }
//        }
//    }

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
