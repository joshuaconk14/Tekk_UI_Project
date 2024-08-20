//
//  SettingsView.swift
//  Tekk-frontend
//
//  Created by Jordan on 7/6/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var name = "Jordan Conklin"
    @State private var email = "jordinhoconk@gmail.com"
    @State private var showDeleteConfirmation = false

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    profileHeader
                    
                    actionSection(title: "Account", buttons: [
                        customActionButton(title: "Past Conversations", icon: "clock.fill"),
                        customActionButton(title: "Share With a Friend", icon: "square.and.arrow.up.fill"),
                        customActionButton(title: "Edit your details", icon: "pencil")
                    ])
                    
                    actionSection(title: "Settings", buttons: [
                        customActionButton(title: "Report an Error", icon: "exclamationmark.bubble.fill"),
                        customActionButton(title: "Talk to a Founder", icon: "phone.fill"),
                        customActionButton(title: "Drop a Rating", icon: "star.fill"),
                        customActionButton(title: "Follow our Socials", icon: "link")
                    ])
                    
                    deleteAccountButton
                }
                .padding()
            }
        }
        .navigationBarTitle("Profile", displayMode: .large)
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Delete Account"),
                message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    // Add delete account functionality
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private var profileHeader: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 10) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.green)
                
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text(email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
        }
    }
    
    private func actionSection(title: String, buttons: [AnyView]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(buttons.indices, id: \.self) { index in
                buttons[index]
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.90)))
        .shadow(radius: 1)
    }
    
    private func customActionButton(title: String, icon: String) -> AnyView {
        AnyView(
            Button(action: {
                // Action here
            }) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.green)
                    Text(title)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black.opacity(0.7))
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.90)))
            }
            .buttonStyle(PlainButtonStyle())
        )
    }
    
    private var deleteAccountButton: some View {
        Button(action: {
            showDeleteConfirmation = true
        }) {
            Text("Delete Account")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.red))
        }
        .padding(.top, 20)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

