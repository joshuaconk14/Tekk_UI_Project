//
//  View_Chatbot.swift
//  Tekk-frontend
//
//  Created by Jordan on 7/6/24.
//

import SwiftUI

struct Message_Struct: Identifiable {
    let id = UUID()
    let role: String
    let content: String
}

struct ChatbotView: View {
//    @State private var messageText = ""
//    @State var chatMessages: [String] = ["Welcome to TekkAI"]
    @State private var messageText = ""
    @Binding var chatMessages: [Message_Struct]
    var sendMessage: (String) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("TekkAI")
                    .font(.largeTitle)
                    .bold()
                
                Image(systemName: "bubble.left.fill")
                    .font(.system(size: 26))
                    .foregroundColor(Color.green)
            }
            
            ScrollView {
                ForEach(chatMessages) { message in
                    if message.content.contains("[USER]") {
                        let newMessage = message.content.replacingOccurrences(of:
                            "[USER]", with: "")
                        
                        HStack {
                            Spacer()
                            Text(newMessage)
                                .padding()
                                .foregroundColor(.white)
                                .background(.green.opacity(0.8))
                                .cornerRadius(10)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                        }
                    } else {
                        HStack {
                            Text(message.content)
                                .padding()
                                .background(.gray.opacity(0.15))
                                .cornerRadius(10)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                            Spacer()
                        }
                    }
                }.rotationEffect(.degrees(180))
            }.rotationEffect(.degrees(180))
                .background(Color.gray.opacity(0.10))
            
            HStack {    
                TextField("Lets get Tekky", text: $messageText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    // Case 1: user presses 'enter' on keyboard
                    .onSubmit {
                        sendMessage(messageText)
                        messageText = ""
                    }
                
                // Case 2: user clicks on submit button
                Button {
                    sendMessage(messageText)
                    messageText = ""
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.green)
                }
                .font(.system(size: 26))
                .padding(.horizontal, 10)
            }.padding()
        }
    }

}

#Preview {
    ChatbotView(chatMessages: .constant([Message_Struct(role: "assistant", content: "Welcome to TekkAI")]), sendMessage: { _ in })
}


/*
 import swiftui
 
 
 */
