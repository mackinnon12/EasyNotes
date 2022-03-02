//
//  Notes.swift
//  EasyNotes
//
//  Created by Jacob MacKinnon on 2022-03-02.
//

import Foundation
//title, note, creation_date, email: String

struct Notes: Identifiable {
    var id: String
    var title: String
    var note: String
    var creation_date: String
    var email: String
}
