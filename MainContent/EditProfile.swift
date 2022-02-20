//
//  EditProfile.swift
//  LoginExample
//
//  Created by Jacob MacKinnon on 2022-02-15.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Firebase

struct EditProfile: View {
    @ObservedObject private var user = MainUserDataModel() //pulls user data from firebase (located in fetchUserData.swift) works like: user.currentUser?.uid ?? ""
    let auth = Auth.auth()
    @State private var firstName = ""
    @State private var lastName = ""
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
                Form {
                    Section(header: Text("Personal Info")) {
                        TextInputField("First Name", text: $firstName)
                        TextInputField("Last Name", text: $lastName)
                    }
                }
                Button(action: {
                    editUserData(firstName: firstName, lastName: lastName)
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save Changes")
                        .foregroundColor(Color.white)
                        .frame(width: 150, height: 50)
                        .background(Color.pink)
                        .cornerRadius(8)
                        .padding()
                })
        }
        //wait for user data to fetch
        .task {
            firstName = user.currentUser?.firstName ?? ""
            lastName = user.currentUser?.lastName ?? ""
        }
        .navigationTitle("Edit Profile")
        
    }
}

func editUserData(firstName: String, lastName: String) {
    let auth = Auth.auth()
    guard let uid = auth.currentUser?.uid else { return }
    let firstName = ["firstName": firstName]
    let lastName = ["lastName": lastName]

    Firestore.firestore().collection("users").document(uid).updateData(firstName)
    Firestore.firestore().collection("users").document(uid).updateData(lastName)
}

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile()
    }
}
