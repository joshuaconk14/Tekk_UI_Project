//
//  LoginView.swift
//  Tekk
//
//  Created by Jordan on 8/26/24.
//

import SwiftUI

// expected response structure from backend after POST request to login endpoint
struct LoginResponse: Codable {
    let access_token: String
    let token_type: String
}

struct ConversationsResponse: Codable {
    let conversations: [Conversation]
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var conversations: [Conversation] = []
    @Binding var isLoggedIn: Bool
    @Binding var authToken: String

    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .padding()

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button(action: loginUser) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .padding()
    }

    func loginUser() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        let loginDetails = [
            "email": email,
            "password": password
        ]

        // sending HTTP POST request to FastAPI app running locally
        let url = URL(string: "http://127.0.0.1:8000/login/")!
        var request = URLRequest(url: url)

        print("current token: \(authToken)")
        // HTTP POST request to login user and receive JWT token
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: loginDetails)

        // start URL session to interact with backend
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let decodedResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.authToken = decodedResponse.access_token
                    self.isLoggedIn = true
                    print("Login token: \(self.authToken)")
                    print("Login success: \(self.isLoggedIn)")
                    // TODO make this a secure key
                    UserDefaults.standard.set(self.authToken, forKey: "authToken")

                    // // Fetch conversations after successful login
                    // self.fetchConversations()
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to login. Please try again."
                    if let error = error {
                        print("Login error: \(error.localizedDescription)")
                    }
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Response data: \(responseString)")
                    }
                }
            }
        }.resume()
    }

    // func fetchConversations() {
    //     let url = URL(string: "http://127.0.0.1:8000/get_conversation_history")!
    //     var request = URLRequest(url: url)
    //     request.httpMethod = "GET"
    //     request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

    //     URLSession.shared.dataTask(with: request) { data, response, error in
    //         if let error = error {
    //             print("Error fetching conversations: \(error.localizedDescription)")
    //             return
    //         }
            
    //         guard let data = data else {
    //             print("No data received when fetching conversations")
    //             return
    //         }
            
    //         do {
    //             let decoder = JSONDecoder()
    //             decoder.dateDecodingStrategy = .iso8601
    //             let response = try decoder.decode(ConversationsResponse.self, from: data)
    //             DispatchQueue.main.async {
    //                 self.conversations = response.conversations
    //             }
    //         } catch {
    //             print("Error parsing conversations response: \(error.localizedDescription)")
    //         }
    //     }.resume()
    // }

}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
