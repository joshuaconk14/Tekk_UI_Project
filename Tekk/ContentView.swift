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
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 15 Pro Max")
    }
}
