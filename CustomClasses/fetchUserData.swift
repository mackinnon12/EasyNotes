//
//  fetchUserData.swift
//  LoginExample
//
//  Created by Jacob MacKinnon on 2022-02-17.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore

struct User {
    let firstName, lastName, uid, email: String
    
}

class MainUserDataModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var currentUser: User?

    init() {
        fetchUserData()
    }

     func fetchUserData() {
        let auth = Auth.auth()
        guard let uid = auth.currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }

            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return

            }
            let firstName = data["firstName"] as? String ?? ""
            let lastName = data["lastName"] as? String ?? ""
            let uid = data["uid"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            self.currentUser = User(firstName: firstName, lastName: lastName, uid: uid, email: email)
        }
    }

}
