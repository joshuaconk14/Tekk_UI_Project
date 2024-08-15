//
//  ViewB.swift
//  Tekk-frontend
//
//  Created by Jordan on 7/6/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var name = ""
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                }
                
                Section {
                    Button("Past Conversations") { }
                    Button("Share with a friend") { }
                    Button("Edit your details") { }
                }
                
                Section {
                    Button("Report an error") { }
                    Button("Talk to a founder") { }
                    Button("Drop a rating") { }
                    Button("Follow our socials") { }
                }
                
                Section {
                    Button("Delete your account") {
                        // Add delete account functionality
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
