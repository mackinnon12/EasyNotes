//
//  CreateNoteView.swift
//  EasyNotes
//
//  Created by Jacob MacKinnon on 2022-02-21.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct CreateNoteView: View {
    
    @ObservedObject var user = MainUserDataModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showingAlert = false
    
    @State private var title = ""
    @State private var note = ""
    
    var body: some View {
        VStack {
            TextField("Enter a title", text: $title)
                .font(Font.title.weight(.heavy))
                .padding(10)
//            TextField("Start typing here...", text: $note)
//                .padding(6)
                TextEditor(text: $note)
                    .padding(6)
            
        }
        NavigationView {
        }
        .navigationBarTitle("Create Note", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    print("Save note")
                    createNote(title: title, note: note, email: user.currentUser?.email ?? "Error no email found")
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save")
                })
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    showingAlert = true
                }, label: {
                    Text("Cancel")
                })
                    .alert(isPresented:$showingAlert) {
                        Alert(
                            title: Text("Are you sure?"),
                            primaryButton: .destructive(Text("Discard Changes")) {
                                print("Discard")
                                self.presentationMode.wrappedValue.dismiss()
                            },
                            secondaryButton: .cancel()
                        )
                    }
            }
        }
        .task {
            user.fetchUserData()
        }
    }
}

func createNote(title: String, note: String, email: String) {
    DispatchQueue.main.async {
        //Success
        //start of creation date
        let date_original = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY, MMM d"
        let date_formatted = dateFormatter.string(from: date_original)
        //end of creation date
        let noteData = ["title": title, "note": note, "email": email, "creation_date": date_formatted]
        //Firestore.firestore().collection("notes").document(email).setData(noteData)
        Firestore.firestore().collection("notes").document(email).collection("userNotes").document().setData(noteData)
    }
}
