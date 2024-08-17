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
    @State private var showDeleteConfirmation = false
    @State private var ballPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: 100)
    @State private var ballVelocity = CGPoint(x: 3, y: 4)
    @State private var ballSize: CGFloat = 50

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
                        
            ScrollView {
                VStack(spacing: 20) {
                    profileHeader
                    
                    profileInfoSection
                    
                    actionButtonsSection
                    
                    supportSection
                    
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
        VStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
                .padding()
                .background(Circle().fill(Color.white))
                .overlay(Circle().stroke(Color.green, lineWidth: 4))
                .shadow(radius: 10)
            
            Text("Your Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
    }
    
    private var profileInfoSection: some View {
        VStack(spacing: 15) {
            customTextField(title: "Name", text: $name, icon: "person.fill")
            customTextField(title: "Email", text: $email, icon: "envelope.fill")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.green, lineWidth: 2) // Green outline
                )
        )
        .shadow(radius: 5)
    }
    
    private func customTextField(title: String, text: Binding<String>, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.black)
            TextField(title, text: text)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.5), lineWidth: 1))
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 15) {
            customActionButton(title: "Past Conversations", icon: "clock.fill")
            customActionButton(title: "Share with a friend", icon: "square.and.arrow.up.fill")
            customActionButton(title: "Edit your details", icon: "pencil")
        }
    }
    
    private var supportSection: some View {
        VStack(spacing: 15) {
            customActionButton(title: "Report an error", icon: "exclamationmark.triangle.fill")
            customActionButton(title: "Talk to a founder", icon: "person.2.fill")
            customActionButton(title: "Drop a rating", icon: "star.fill")
            customActionButton(title: "Follow our socials", icon: "link")
        }
    }
    
    private func customActionButton(title: String, icon: String) -> some View {
        Button(action: {
            // Action here
        }) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.black)
                Text(title)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.black.opacity(0.7))
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.6), lineWidth: 1))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var deleteAccountButton: some View {
        Button(action: {
            showDeleteConfirmation = true
        }) {
            Text("Delete your account")
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 1))
        }
        .padding(.top, 20)
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
