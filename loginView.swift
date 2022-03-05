//
//  loginView.swift
//  LoginExample
//
//  Created by Jacob MacKinnon on 2022-02-15.
//

import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore

class AppViewModel: ObservableObject {
    @State private var showingError = false;
    let auth = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    //Success
                    let auth = Auth.auth()
                    if auth.currentUser?.isEmailVerified == true {
                    self?.signedIn = true
                    } else {
                        self?.signedIn = false
                        print("Please verify your email")
                    }
                }
            }
        }
    
    func signUp(firstName: String, lastName: String, email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                //Success
                let auth = Auth.auth()
                auth.currentUser?.sendEmailVerification()
                print("Please verify your email")
                //start of creation date
                let date_original = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY, MMM d"
                let date_formatted = dateFormatter.string(from: date_original)
                //end of creation date
                guard let uid = auth.currentUser?.uid else { return }
                let userData = ["firstName": firstName, "lastName": lastName, "email": email, "uid": uid, "creation_date": date_formatted]
                Firestore.firestore().collection("users")
                        .document(uid).setData(userData) { err in
                            if let err = err {
                                print(err)
                                return
                            }
                            print("Success")
                        }
                if auth.currentUser?.isEmailVerified == true {
                self?.signedIn = true
                }
            }
        }
    }
    
    func signOut() {
        try? auth.signOut()
        
        self.signedIn = false
    }
}

struct loginView: View {
    @EnvironmentObject var viewModel: AppViewModel
    let auth = Auth.auth()
    
    var body: some View {
        VStack {
            if viewModel.signedIn && auth.currentUser?.isEmailVerified == true {
                VStack {
                    MainContent()
                }
            } else {
                NavigationView {
                SignInView()
                }
            }
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
}

struct SignInView: View {
    
    let auth = Auth.auth()
    @State var errorMessage = ""
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            VStack {
                Text(errorMessage)
                    .foregroundColor(Color.red)
                TextInputField("Email Address", text: $email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                Button(action: {
                    if (email.isEmpty) {
                        errorMessage = "Email cannot be empty!"
                        return
                    } else if (password.isEmpty) {
                        errorMessage = "Password cannot be empty!"
                        return
                    }
                    errorMessage = ""
                    viewModel.signIn(email: email, password: password)
                    
                    
                }, label: {
                    Label("Sign In", systemImage: "rectangle.portrait.and.arrow.right.fill")
                        .foregroundColor(Color.white)
                        .frame(width: 150, height: 50)
                        .background(Color.pink)
                        .cornerRadius(8)
                        .padding()
                })
                NavigationLink("Forgot Password?", destination: forgotPassword())
                    .foregroundColor(Color.pink)
                    .padding()
                NavigationLink("Create Account", destination: SignUpView())
                    .foregroundColor(Color.pink)
                    .padding()
                
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Sign In")
    }
}

struct SignUpView: View {
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    @State var password = ""
    @State var errorMessage = ""
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            VStack {
                Text(errorMessage)
                    .foregroundColor(Color.red)
                TextInputField("First Name", text: $firstName)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                TextInputField("Last Name", text: $lastName)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                TextInputField("Email Address", text: $email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                Button(action: {
                    if (firstName.isEmpty) {
                        errorMessage = "Please enter a first name!"
                        return
                    }
                    else if (lastName.isEmpty) {
                        errorMessage = "Please enter a last name!"
                        return
                    }
                    else if (email.isEmpty) {
                        errorMessage = "Email cannot be empty!"
                        return
                    } else if (password.isEmpty) {
                        errorMessage = "Password cannot be empty!"
                        return
                    } else if (password.count <= 6) {
                        errorMessage = "Password must be greater than 6 characters!"
                        return
                    }
                    errorMessage = ""
                    showingAlert = true
                    self.presentationMode.wrappedValue.dismiss()
                    viewModel.signUp(firstName: firstName, lastName: lastName, email: email, password: password)
                    
                }, label: {
                    Text("Create Account")
                        .foregroundColor(Color.white)
                        .frame(width: 150, height: 50)
                        .background(Color.pink)
                        .cornerRadius(8)
                })
            }
            .alert(isPresented:$showingAlert) {
                Alert(
                title: Text("Account Created"),
                message: Text("Please verify your email"),
                dismissButton: .default(Text("Okay"))
                )
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Create Account")
    }
}

struct forgotPassword: View {
    
    @State var email = ""
    @State var errorMessage = ""
    let auth = Auth.auth()
    @State private var showingAlert = false
    @State private var showError = false
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            VStack {
                Text(errorMessage)
                    .foregroundColor(Color.red)
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .cornerRadius(5)
                
                Button(action: {
                    if (email.isEmpty) {
                        errorMessage = "Email cannot be empty!"
                        return
                    }
                    Auth.auth().sendPasswordReset(withEmail: email)
                    showingAlert = true
                    errorMessage = ""
                    email = ""
                    
                }, label: {
                    Text("Reset Password")
                        .foregroundColor(Color.white)
                        .frame(width: 150, height: 50)
                        .background(Color.pink)
                        .cornerRadius(8)
                        .padding()
                })
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Success"), message: Text("Please check your email!"), dismissButton: .default(Text("Okay")))
                        
                    }
            }
            .padding()
            Spacer()
        }
        .navigationTitle("Forgot Password")
    }
}

struct loginView_Previews: PreviewProvider {
    static var previews: some View {
        loginView()
    }
}
