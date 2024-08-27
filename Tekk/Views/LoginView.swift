//
//  LoginView.swift
//  Tekk
//
//  Created by Jordan on 8/26/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @Binding var isLoggedIn: Bool

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
        ] as [String : Any]

        // sending HTTP POST request to FastAPI app running locally
        let url = URL(string: "http://127.0.0.1:8000/login/")!
        var request = URLRequest(url: url)

        // HTTP POST request to login user and receive JWT token
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // attempt to serialize the response
        request.httpBody = try? JSONSerialization.data(withJSONObject: loginDetails, options: [])

        // Send JSON payload to backend through URL session
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "No data")")
                DispatchQueue.main.async {
                    errorMessage = "Failed to login. Please try again."
                }
                return
            }

            // If valid URL response, return status code 200 and proceed
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Handle JWT token here
                if let responseObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = responseObject["access_token"] as? String {
                    // Save the token or use it as needed
                    DispatchQueue.main.async {
                        isLoggedIn = true
                        errorMessage = ""
                        print("Logged in with token: \(token)")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    errorMessage = "Failed to login. Please try again."
                }
            }
        }

        task.resume()
    }

}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
