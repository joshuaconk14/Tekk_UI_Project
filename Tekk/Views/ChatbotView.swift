//
//  ChatbotView.swift
//  Tekk-frontend
//
//  Created by Jordan on 7/6/24.
//

import SwiftUI

// structure for chat messages
struct Message_Struct: Identifiable {
    let id = UUID()
    let role: String
    var content: String
}

// expected response structure from backend after POST request to generate_tutorial endpoint
struct TutorialResponse: Codable {
    let tutorial: String
    let session_id: String
    // let created_at: String
}

struct Conversation: Identifiable, Codable {
    let id: String
    var title: String
    let createdAt: Date
}

// Main chatbot view of the app
struct ChatbotView: View {
    @State private var isShowingHistory = false
    @State private var selectedSessionID = ""
    @State private var messageText = ""
    @Binding var chatMessages: [Message_Struct]
    @Binding var authToken: String
    @State private var viewModel = ViewModel()
    @State private var conversations: [Conversation] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
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
                        
                        Button(action: startNewConversation) {
                            Image(systemName: "bubble.left.fill")
                                .font(.system(size: 26))
                                .foregroundColor(Color.green)
                        }
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
                                sendMessage(message: messageText)
                                messageText = ""
                            }
                        
                        Button {
                            sendMessage(message: messageText)
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
                
                // Overlay when history is showing (only over the chat area)
                if isShowingHistory {
                    Color.black.opacity(0.3)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isShowingHistory = false
                            }
                        }
                        .zIndex(1)
                }
                
                // Sliding chat history view
                if isShowingHistory {
                    ChatHistoryView(isShowingHistory: $isShowingHistory, 
                                    selectedSessionID: $selectedSessionID,
                                    conversations: $conversations)
                    .frame(width: geometry.size.width * 0.75)
                    .transition(.move(edge: .leading))
                    .zIndex(2)  
                }
            }
        }
    }
    
    func sendMessage(message: String) {
        withAnimation {
            chatMessages.append(Message_Struct(role: "user", content: "[USER]" + message))
            self.messageText = ""
        }
        
        let url = URL(string: "http://127.0.0.1:8000/generate_tutorial/")!
        var request = URLRequest(url: url)
        
        let storedToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        print("Token in ChatbotView: \(storedToken)")
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(storedToken)", forHTTPHeaderField: "Authorization")
        
        let parameters: [String: Any] = [
            "prompt": message,
            "session_id": selectedSessionID
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            print("Status code: \(httpResponse.statusCode)")
            
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response data: \(responseString)")
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(TutorialResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.chatMessages.append(Message_Struct(role: "assistant", content: decodedResponse.tutorial))
                        self.selectedSessionID = decodedResponse.session_id
                        
                        // Update the conversation title if it's a new conversation
                        if let index = self.conversations.firstIndex(where: { $0.id == decodedResponse.session_id }) {
                            self.conversations[index].title = message
                        } else {
                            let newConversation = Conversation(id: decodedResponse.session_id, title: message, createdAt: Date())
                            self.conversations.insert(newConversation, at: 0)
                        }
                    }
                } catch {
                    print("Failed to decode response: \(error)")
                }
            } else {
                print("No data received")
            }
        }
        .resume()
    }
    
    func loadConversations() {
        // API call to fetch user's conversations
        // Update the `conversations` state variable
    }

    func loadConversation(_ id: String) {
        // API call to fetch specific conversation
        // Update the `chatMessages` and `currentConversationId` state variables
    }

    func startNewConversation() {
        let url = URL(string: "http://127.0.0.1:8000/conversations/new")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        let storedToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        request.setValue("Bearer \(storedToken)", forHTTPHeaderField: "Authorization")

        print("Starting new conversation with auth token: \(storedToken)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error creating new conversation: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received when creating new conversation")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let newSessionId = json["session_id"] as? String {
                    DispatchQueue.main.async {
                        self.selectedSessionID = newSessionId
                        self.chatMessages = [Message_Struct(role: "system", content: "Welcome to TekkAI")]
                        let newConversation = Conversation(id: newSessionId, title: "New Conversation", createdAt: Date())
                        self.conversations.insert(newConversation, at: 0)
                        print("New conversation started with session ID: \(newSessionId)")
                    }
                }
            } catch {
                print("Error parsing new conversation response: \(error.localizedDescription)")
            }
        }
        .resume()
    }
}

// The messages in the chatbot corresponding to if message is from user or AI
struct MessageView: View {
    let message: Message_Struct
    
    var body: some View {
        // User message
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
        // System message
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

// View of previous user conversations
struct ChatHistoryView: View {
    @Binding var isShowingHistory: Bool
    @Binding var selectedSessionID: String
    @Binding var conversations: [Conversation]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Chat History")
                .font(.largeTitle)
                .padding(.top, 20)
                .padding(.leading, 10)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(conversations) { conversation in
                        Button(action: {
                            selectedSessionID = conversation.id
                            withAnimation(.spring()) {
                                isShowingHistory = false
                            }
                        }) {
                            HStack {
                                Text(conversation.title)
                                    .foregroundColor(.primary)
                                    .padding(.leading, 10)
                                
                                Spacer()
                                
                                Text(conversation.createdAt, style: .date)
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 10)
            }
            Spacer()
        }
        .background(Color.white)
    }
}

//#Preview {
//    // Allow chatmessages to be accessed by parent ContentView
//    ChatbotView(chatMessages: .constant([Message_Struct(role: "assistant", content: "Welcome to TekkAI")]))
//}
