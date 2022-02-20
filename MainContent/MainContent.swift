//
//  MainContent.swift
//  LoginExample
//
//  Created by Jacob MacKinnon on 2022-02-15.
//

import SwiftUI
import FirebaseAuth

struct MainContent: View {
    var body: some View {
        TabView() {
            NotesView()
                .tabItem {
                    Image(systemName: "pencil.circle.fill")
                    Text("Notes")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
            Settings()
                .tabItem {
                    Image(systemName: "gear.circle.fill")
                    Text("Settings")
                }
        }
        .accentColor(.pink)

    }
        
}

struct MainContent_Previews: PreviewProvider {
    static var previews: some View {
        MainContent()
    }
}
