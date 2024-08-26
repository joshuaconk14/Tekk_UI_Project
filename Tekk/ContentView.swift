//
//  ContentView.swift
//  Tekk
//
//  Created by Jordan on 7/9/24.
//

import SwiftUI
//import GoogleGenerativeAI

struct ContentView: View {
    @State private var isDetailsSubmitted = false // Track if details are submitted
    @State private var messageText = "" // Current text input from user
    @State var chatMessages: [Message_Struct] = [Message_Struct(role: "system", content: "Welcome to TekkAI")] // Stores list of chat messages
    @State private var viewModel = ViewModel()

    // main view
    var body: some View {
        if isDetailsSubmitted {
            TabView {
                // chatMessages binded, sendMessage passed as closure
                ChatbotView(chatMessages: $chatMessages, sendMessage: sendMessage)
                    .tabItem {
                        Image(systemName: "message.fill")
                    }
                CameraView(image: $viewModel.currentFrame)
                    .tabItem {
                        Image(systemName: "camera.fill")
                    }
                SettingsView()
                    .tabItem {
                        Image(systemName: "slider.horizontal.3")
                    }
            }
            .accentColor(.green)
        } else {
            PlayerDetailsFormView(onDetailsSubmitted: {
                self.isDetailsSubmitted = true
            })
        }
    }
    
    func sendMessage(message: String) {
        withAnimation {
            chatMessages.append(Message_Struct(role: "user", content: "[USER]" + message))
            self.messageText = ""
        }


        // connecting to FastAPI locally
        let playerDetails = ["name": "Joe Lolley", "age": 18, "position": "LW"] as [String : Any]
        
        // sending HTTP POST request to FastAPI app running locally
        let url = URL(string: "http://127.0.0.1:8000/generate_tutorial/")!
//        let url = URL(string: "http://10.0.0.129:8000/generate_tutorial/")!
        var request = URLRequest(url: url)
        
        // HTTP POST request to get tutorial from backend
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // ChatbotRequest model defined in backend
        let parameters: [String: Any] = [
            "prompt": message,
            "player_details": playerDetails
        ]
        
        // attempt to serialize the response
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        // Send JSON payload to backend through URL session
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
                        self.chatMessages.append(Message_Struct(role: "assistant", content: tutorial))
                    }
                }
            } else {
                print("HTTP Response: \(response.debugDescription)")
            }
        }
        
        task.resume()
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 15 Pro Max")
    }
}
