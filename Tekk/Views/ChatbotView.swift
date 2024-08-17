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
    @State private var isShowingHistory = false
    @State private var selectedSessionID = ""
    @State private var messageText = ""
    @Binding var chatMessages: [Message_Struct]
    var sendMessage: (String) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            // Allow ChatbotHistoryView to show in front of ChatbotView
            ZStack {
                // Main chat view
                VStack {
                    // Header
                    HStack {
                        Button(action: {
                            withAnimation(.spring()) {
                                isShowingHistory.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.largeTitle)
                                .foregroundColor(.green)
                        }
                        Text("TekkAI")
                            .font(.largeTitle)
                            .bold()
                        
                        Image(systemName: "bubble.left.fill")
                            .font(.system(size: 26))
                            .foregroundColor(Color.green)
                    }
                    .padding()
                    
                    // Chat messages
                    ScrollView {
                        ForEach(chatMessages) { message in
                            MessageView(message: message)
                        }
                        .rotationEffect(.degrees(180))
                    }
                    .rotationEffect(.degrees(180))
                    .background(Color.gray.opacity(0.10))
                    
                    // Message input
                    HStack {
                        TextField("Let's get Tekky", text: $messageText)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .onSubmit {
                                sendMessage(messageText)
                                messageText = ""
                            }
                        
                        Button {
                            sendMessage(messageText)
                            messageText = ""
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.green)
                        }
                        .font(.system(size: 26))
                        .padding(.horizontal, 10)
                    }
                    .padding()
                }
                .zIndex(0)
                
                // Overlay when history is showing
                Color.black
                    .opacity(isShowingHistory ? 0.5 : 0)
                    .ignoresSafeArea()
                    .zIndex(1)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isShowingHistory = false
                        }
                    }
                
                // Sliding chat history view
                HStack {
                    ChatHistoryView(isShowingHistory: $isShowingHistory, selectedSessionID: $selectedSessionID)
                        .frame(width: geometry.size.width * 0.75)
                        .offset(x: isShowingHistory ? 0 : -geometry.size.width * 0.75)
                    
                    Spacer()
                }
                .zIndex(2)
            }
        }
    }
}

struct MessageView: View {
    let message: Message_Struct
    
    var body: some View {
        if message.content.contains("[USER]") {
            let newMessage = message.content.replacingOccurrences(of: "[USER]", with: "")
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
    }
}

struct ChatHistoryView: View {
    @Binding var isShowingHistory: Bool
    @Binding var selectedSessionID: String
    
    @State private var sessionIDs: [String] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Chat History")
                .font(.largeTitle)
                .padding(.top, 20)
                .padding(.leading, 10)
            
            List(sessionIDs, id: \.self) { sessionID in
                Button(action: {
                    selectedSessionID = sessionID
                    withAnimation(.spring()) {
                        isShowingHistory = false
                    }
                }) {
                    Text(sessionID)
                }
            }
            .onAppear(perform: loadSessionIDs)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
    
    func loadSessionIDs() {
        // Simulating session loading here. Replace this with your actual data fetching logic.
        sessionIDs = ["Yesterday", "3 days ago", "Last week"]
    }
}

#Preview {
    ChatbotView(chatMessages: .constant([Message_Struct(role: "assistant", content: "Welcome to TekkAI")]), sendMessage: { _ in })
}
