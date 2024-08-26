//
//  PlayerDetailsFormView.swift
//  Tekk
//
//  Created by Jordan on 8/26/24.
//

import Foundation
import SwiftUI

struct PlayerDetailsFormView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var age = ""
    @State private var position = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isSubmitted = false
    @State private var errorMessage = ""
    
    var onDetailsSubmitted: () -> Void // Closure to notify when details are submitted

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Player Information")) {
                    TextField("First Name", text: $firstName)
                        .disableAutocorrection(true)
                    TextField("Last Name", text: $lastName)
                        .disableAutocorrection(true)
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                    TextField("Position", text: $position)
                        .disableAutocorrection(true)
                }

                Section(header: Text("Contact Information")) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    TextField("Password", text: $password)
                        .disableAutocorrection(true)
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button(action: submitDetails) {
                    Text("Submit")
                }
                .disabled(isSubmitted)

                // "Already have an account?" section
                Section {
                    NavigationLink(destination: LoginView()) {
                        Text("Already have an account? Log in here")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Player Details")
        }
    }

    func submitDetails() {
        guard let ageInt = Int(age), !firstName.isEmpty, !lastName.isEmpty, !position.isEmpty, !email.isEmpty else {
            errorMessage = "Please fill in all fields correctly."
            return
        }

        let playerDetails = [
            "first_name": firstName,
            "last_name": lastName,
            "age": ageInt,
            "position": position,
            "email": email,
            "password": password
        ] as [String : Any]

        // sending HTTP POST request to FastAPI app running locally
        let url = URL(string: "http://127.0.0.1:8000/register/")!
        var request = URLRequest(url: url)

        // HTTP POST request to store player details
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // attempt to serialize the response
        request.httpBody = try? JSONSerialization.data(withJSONObject: playerDetails, options: [])

        // Send JSON payload to backend through URL session
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "No data")")
                DispatchQueue.main.async {
                    errorMessage = "Failed to submit details. Please try again."
                }
                return
            }

            // If valid URL response, return status code 200 and proceed
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    isSubmitted = true
                    errorMessage = ""
                    onDetailsSubmitted() // Notify that details are submitted
                }
            } else {
                DispatchQueue.main.async {
                    errorMessage = "Failed to submit details. Please try again."
                }
            }
        }

        task.resume()
    }
}


struct PlayerDetailsFormView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerDetailsFormView(onDetailsSubmitted: {})
    }
}
