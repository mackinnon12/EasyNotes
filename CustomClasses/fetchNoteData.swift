//
//  fetchNoteData.swift
//  EasyNotes
//
//  Created by Jacob MacKinnon on 2022-02-22.
//

import SwiftUI
import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore

class NoteViewModel: ObservableObject {
    @Published var list = [Notes]()
    @State private var userEmail = Auth.auth().currentUser?.email ?? "User"
    
    func getData() {
        let db = Firestore.firestore()
        
        db.collection("notes").document(userEmail).collection("userNotes").getDocuments() { snapshot, error in
            if error == nil {
                // No errors
                if let snapshot = snapshot {
                    // Update the list property in the main thread
                    DispatchQueue.main.async {
                        // Get all the documents and create
                        self.list = snapshot.documents.map { d in
                            // Create a item for each document returned
                            return Notes(id: d.documentID,
                                         title: d["title"] as? String ?? "",
                                         note: d["note"] as? String ?? "",
                                         creation_date: d["creation_date"] as? String ?? "",
                                         email: d["email"] as? String ?? "")
                        }
                    }
                }
            }
            else {
                // Handle the error
            }
        }
    }
    
    func deleteNote(noteID: String) {
        let db = Firestore.firestore()
        db.collection("notes").document(userEmail).collection("userNotes").document(noteID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Note successfully deleted!")
            }
        }
    }
    
    func updateNote(id: String, title: String, note: String, email: String) {
        let db = Firestore.firestore()
        
        let title = ["title": title]
        let note = ["note": note]

        db.collection("notes").document(userEmail).collection("userNotes").document(id).updateData(title)
        db.collection("notes").document(userEmail).collection("userNotes").document(id).updateData(note)
    }
    
}

