//
//  ContentView.swift
//  Tekk
//
//  Created by Jordan on 7/9/24.
//

import SwiftUI
//import GoogleGenerativeAI

struct ContentView: View {
    @State private var isLoggedIn = false // Track if user is logged in
    @State private var isDetailsSubmitted = false // Track if details are submitted
    @State private var token: String? = nil // Store the JWT token
    @State private var messageText = "" // Current text input from user
    @State var chatMessages: [Message_Struct] = [Message_Struct(role: "system", content: "Welcome to TekkAI")] // Stores list of chat messages
    @State private var viewModel = ViewModel()

    // main view
    var body: some View {
        if isDetailsSubmitted || isLoggedIn {
            TabView {
                ChatbotView(chatMessages: $chatMessages)
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
            PlayerDetailsFormView(isLoggedIn: $isLoggedIn, onDetailsSubmitted: {
                self.isDetailsSubmitted = true
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 15 Pro Max")
    }
}
