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
}

struct Conversation: Identifiable, Codable {
    let id: String
    let title: String
    // Add other relevant fields
}

// Main chatbot view of the app
struct ChatbotView: View {
    @State private var isShowingHistory = false
    @State private var selectedSessionID = ""
    @State private var messageText = ""
    @Binding var chatMessages: [Message_Struct]
    @Binding var authToken: String
    @State private var viewModel = ViewModel()
    
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
                        
                        Button(action: {
                            startNewConversation()
                        }) {
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
                    ChatHistoryView(isShowingHistory: $isShowingHistory, selectedSessionID: $selectedSessionID
                    )
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
        
        // sending HTTP POST request to FastAPI app running locally
        let url = URL(string: "http://127.0.0.1:8000/generate_tutorial/")!
        // let url = URL(string: "http://10.0.0.129:8000/generate_tutorial/")!
        var request = URLRequest(url: url)
        
        // TODO make this a secure key
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        print("Token in ChatbotView: \(authToken)")
        
        // HTTP POST request to get tutorial from backend
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
    //    let selectedSessionID = "189917d0-7f9c-412d-847d-99a26ec0dd59"
    //    let userID = 18
        
        // ChatbotRequest model defined in backend
        let parameters: [String: Any] = [
        //    "user_id": userID,
            "prompt": message,
           "session_id": selectedSessionID  // Include the current session ID
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
                
                if let decodedResponse = try? JSONDecoder().decode(TutorialResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.chatMessages.append(Message_Struct(role: "assistant", content: decodedResponse.tutorial))
                        self.selectedSessionID = decodedResponse.session_id
                    }
                } else {
                    print("Failed to decode response")
                }
            } else {
                print("No data received")
            }
        }.resume()
    }
    
    // Function to start a new conversation
    private func startNewConversation() {
        chatMessages.removeAll { message in
            message.content != "Welcome to TekkAI"
        }
        // TODO: generate new session id
        // selectedSessionID = generateNewSessionID()
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
    @State private var sessionIDs: [String] = []
    
//    @State private var sessionIDs: [String] = [
//        "TEKK",
//        "mini",
//        "4o",
//        "CO Landing page"
//    ]
    
//    func fetchUserSessions() {
//        let url = URL(string: "http://127.0.0.1:8000/user_sessions/\(userID)")!
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                if let decodedResponse = try? JSONDecoder().decode([String].self, from: data) {
//                    DispatchQueue.main.async {
//                        self.sessionIDs = decodedResponse
//                    }
//                    return
//                }
//            }
//            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
//        }
//        .resume()
//    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Chat History")
                .font(.largeTitle)
                .padding(.top, 20)
                .padding(.leading, 10)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(sessionIDs, id: \.self) { sessionID in
                        Button(action: {
                            selectedSessionID = sessionID
                            withAnimation(.spring()) {
                                isShowingHistory = false
                            }
                        }) {
                            HStack {
                                Text(sessionID)
                                    .foregroundColor(.primary)
                                    .padding(.leading, 10)
                                
                                Spacer() // Pushes content to the left
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
//        .onAppear {
//            fetchUserSessions()
//        }
    }
}

//#Preview {
//    // Allow chatmessages to be accessed by parent ContentView
//    ChatbotView(chatMessages: .constant([Message_Struct(role: "assistant", content: "Welcome to TekkAI")]))
//}
