//
//  changePassword.swift
//  LoginExample
//
//  Created by Jacob MacKinnon on 2022-02-15.
//

import SwiftUI
import FirebaseAuth

struct changePassword: View {
    @State var password = ""
    @State var errorMessage = ""
    let auth = Auth.auth()
    @State private var showingAlert = false
    @State private var showError = false
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            VStack {
                Text(errorMessage)
                    .foregroundColor(Color.red)
                SecureField("New Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5)
                
                Button(action: {
                    if (password.isEmpty) {
                        errorMessage = "Password cannot be empty!"
                        return
                    } else if (password.count <= 6) {
                        errorMessage = "Password must be greater than 6 characters!"
                        return
                    }
                    Auth.auth().currentUser?.updatePassword(to: password)
                    showingAlert = true
                    errorMessage = ""
                    password = ""
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Change Password")
                        .foregroundColor(Color.white)
                        .frame(width: 150, height: 50)
                        .background(Color.pink)
                        .cornerRadius(8)
                        .padding()
                })
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Success"), message: Text("Password has been updated."), dismissButton: .default(Text("Okay")))
                        
                    }
            }
            .padding()
            Spacer()
        }
        .navigationTitle("Change Password")
    }
    
}

struct changePassword_Previews: PreviewProvider {
    static var previews: some View {
        changePassword()
    }
}
