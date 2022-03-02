//
//  NotesView.swift
//  LoginExample
//
//  Created by Jacob MacKinnon on 2022-02-20.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct NotesView: View {
    
    @ObservedObject var user = MainUserDataModel()
    @ObservedObject var note = NoteViewModel()
    @State private var searchText = ""
    //to do: swipe actions on note (delete, pin), click on note to view/edit it (bring the same view as the create note view but as an "editnoteview"
    var body: some View {
        NavigationView {
            VStack {
                List (note.list) { item in
                        NavigationLink(destination: EditNoteView(title: item.title, note: item.note)) {
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                Text(item.note)
                                    .font(.subheadline)
                                Text(item.creation_date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .searchable(text: $searchText)
                        }
                        .swipeActions(allowsFullSwipe: false) {
                            Button (role: .destructive) {
                                print("deleted")
                                note.deleteNote(noteID: item.id)
                                note.getData()
                            } label: {
                                Label("Delete", systemImage: "trash.circle.fill")
                            }
                        }
                        .swipeActions (edge: .leading, allowsFullSwipe: false){
                        Button {
                            print("pinned")
                        } label: {
                            Label("Pin", systemImage: "pin.circle.fill")
                        }
                        .tint(.orange)
                    }
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                NavigationLink(destination: CreateNoteView()) {
                    Image(systemName: "square.and.pencil")
                }
                .task {
                    user.fetchUserData()
                    note.getData()
                }
            }
        }
    }
}

//struct NotesView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotesView()
//    }
//}
