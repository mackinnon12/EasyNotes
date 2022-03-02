//
//  EditNoteView.swift
//  EasyNotes
//
//  Created by Jacob MacKinnon on 2022-03-02.
//

import SwiftUI

struct EditNoteView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var notes = NoteViewModel()
    
    @State var id: String
    @State var title: String
    @State var note: String
    @State var email: String
    
    var body: some View {
        VStack {
        TextField("Enter a title", text: $title)
                .font(Font.title.weight(.heavy))
                
                .padding(10)
        TextField("Start typing here...", text: $note)
                .padding(10)
        }
        NavigationView {
            
        }
        .navigationBarTitle("Note", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    notes.updateNote(id: id, title: title, note: note, email: email)
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Back")
                })
            }
        }
    }
}
