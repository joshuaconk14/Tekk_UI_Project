//  BotResponse.swift
//  Tekk-frontend
//
//  Created by Jordan on 7/6/24.
//

import Foundation

func getBotResponse(message: String) -> String {
    let tempMessage = message.lowercased()
    
    if tempMessage.contains("hello") {
        return "Hey there!"
    } else if tempMessage.contains("how are you") {
        return "I'm fine"
    } else {
        return "That's cool"
    }
}

//func getBotResponse(prompt: String, completion: @escaping (String) -> Void) {
//        guard let url = URL(string: "https://api.yourgeminiendpoint.com/v1/generate") else { return }
//
//        // Retrieve the API key from Secrets.plist
//        guard let apiKey = Bundle.main.infoDictionary?["GEMINI_API_KEY"] as? String else {
//            completion("API key not found")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//
//        let playerDetails: [String: Any] = ["name": "Joe Lolley", "age": 18, "position": "LW"]
//        let body: [String: Any] = [
//            "model": "gemini-1.5-pro-latest",
//            "prompt": "You are a soccer coach. \(prompt) for a player with details: \(playerDetails). Provide the instructions in a single, coherent paragraph.",
//            "temperature": 1,
//            "top_p": 0.95,
//            "top_k": 0,
//            "max_tokens": 500
//        ]
//
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                completion("Failed to get response")
//                return
//            }
//
//            if let response = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//               let tutorial = response["text"] as? String {
//                completion(tutorial)
//            } else {
//                completion("Invalid response from server")
//            }
//        }.resume()
//    }
