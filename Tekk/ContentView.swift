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
    @State var chatMessages: [Message_Struct] = [Message_Struct(content: "Welcome to TekkAI")]
    
    // main view
    var body: some View {
        TabView {
            ViewB()
                .tabItem() {
                    Image(systemName: "person.2.fill")
                    Text("Contacts")
                }
            View_Chatbot(messages: $chatMessages, sendMessage: sendMessage)
                .tabItem() {
                    Image(systemName: "message.fill")
                    Text("Chat")
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
            chatMessages.append(Message_Struct(content: "[USER]" + message))
            self.messageText = ""
        }

    
        // connecting to FastAPI locally
        let playerDetails = ["name": "Joe Lolley", "age": 18, "position": "LW"] as [String : Any]
        let url = URL(string: "http://127.0.0.1:8000/generate_tutorial/")!
        var request = URLRequest(url: url)
        // HTTP POST request to get tutorial from backend
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "prompt": message,
            "player_details": playerDetails
        ]
        
        // attempt to serialize the response
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "No data")")
                return
            }
            
            // If valid URL response, return status code 200 and proceed
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // try to parse json response and extract tutorial string
                if let responseObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let tutorial = responseObject["tutorial"] as? String {
                    DispatchQueue.main.async {
                        self.chatMessages.append(Message_Struct(content: tutorial))
                    }
                }
            } else {
                print("HTTP Response: \(response.debugDescription)")
            }
        }
        
        task.resume()
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            messages.append(getBotResponse(message: message))
//        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 15 Pro Max")
    }
}
