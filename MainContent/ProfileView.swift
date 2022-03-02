//
//  ProfileView.swift
//  LoginExample
//
//  Created by Jacob MacKinnon on 2022-02-15.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct ProfileView: View {
    let auth = Auth.auth()
    @ObservedObject private var user = MainUserDataModel()
    
    let friends = ["Antoine", "Bas", "Curt", "Dave", "Erica"]
    
    var body: some View {
        NavigationView {
            VStack {
                Image("mank")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding()
                if let currentUser = user.currentUser {
                    Text("\(currentUser.firstName) \(currentUser.lastName)")
                        .fontWeight(.bold)
                    Text("\(currentUser.email)")
                        .font(.caption)
                        .padding(5)
                    NavigationLink("Edit Profile", destination: EditProfile())
                        .foregroundColor(Color.pink)
                } else {
                    //Loading
                }
                Form {
                    Section(header: Text("Friends")) {
                        List {
                            ForEach(friends, id: \.self) { friend in
                                NavigationLink(destination: friendProfile()) {
                                    Image("mountainbg")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .cornerRadius(20)
                                    Text(friend)
                                }
                                .swipeActions(allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        print("Deleting friend")
                                    } label: {
                                        Label("Remove", systemImage: "trash.fill")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .task {
                user.fetchUserData()
            }
            .navigationTitle("Profile")
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
