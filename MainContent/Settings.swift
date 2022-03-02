//
//  Settings.swift
//  LoginExample
//
//  Created by Jacob MacKinnon on 2022-02-15.
//

import SwiftUI
import FirebaseAuth

struct Settings: View {
    @EnvironmentObject var viewModel: AppViewModel
    let auth = Auth.auth()
    @State private var userEmail = Auth.auth().currentUser?.email ?? "User"
    
    var body: some View {
        NavigationView {
        VStack {
            Text("You are signed in as \(userEmail)")
            NavigationLink("Change Password", destination: changePassword())
                .foregroundColor(Color.pink)
                .padding()
            Button(action: {
                viewModel.signOut()
            }, label: {
                Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right.fill")
                    .foregroundColor(Color.white)
                    .frame(width: 150, height: 50)
                    .background(Color.pink)
                    .cornerRadius(8)
                    .padding()
            })
        }
        .navigationTitle("Settings")
        }
    }
    
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
