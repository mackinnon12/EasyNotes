//
//  EditNoteView.swift
//  EasyNotes
//
//  Created by Jacob MacKinnon on 2022-03-02.
//

import SwiftUI

struct EditNoteView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showingAlert = false
    
    @State var title: String
    @State var note: String
    
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
        //.navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    print("Save note")
//                    createNote(title: title, note: note, email: user.currentUser?.email ?? "Error no email found")
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save")
                })
            }
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: {
//                    showingAlert = true
//                }, label: {
//                    Text("Cancel")
//                })
//                    .alert(isPresented:$showingAlert) {
//                        Alert(
//                            title: Text("Are you sure?"),
//                            primaryButton: .destructive(Text("Discard Changes")) {
//                                print("Discard")
//                                self.presentationMode.wrappedValue.dismiss()
//                            },
//                            secondaryButton: .cancel()
//                        )
//                    }
//            }
        }
    }
}
